--local mod = get_mod("preboggy")
script_data["eac-untrusted"] = true
--GameSettingsDevelopment.backend_settings.allow_local = true
--GameSettingsDevelopment.use_backend = false

local has_boggy = DLCSettings.bogenhafen and true or false
local has_wom = DLCSettings.scorpion and true or false
local has_drachen1 = DLCSettings.penny_part_1 and true or false
local has_drachen2 = DLCSettings.penny_part_2 and true or false
local has_drachen3 = DLCSettings.penny_part_3 and true or false
print("has_boggy" .. tostring(has_boggy))
print("has_wom" .. tostring(has_wom))

PlayFabMirror.inventory_request_cb = function (self, result)
	self._num_items_to_load = self._num_items_to_load - 1
	local inventory_items = result.Inventory

	if self._inventory_items then
		table.clear(self._inventory_items)
	else
		self._inventory_items = {}
	end

	for i = 1, #inventory_items, 1 do
		local item = inventory_items[i]

		if not item.BundleContents then
			local backend_id = item.ItemInstanceId

            local item_key = item.ItemId
            
            if table.contains(ItemMasterList, item_key) then
                self:_update_data(item, backend_id)

			    self._inventory_items[backend_id] = item
            end
		end
	end

	self:_request_all_users_characters()
end

SimpleInventoryExtension.add_equipment_by_category = function (self, category)
	local career_name = self.career_extension:career_name()
	local category_slots = InventorySettings[category]
	local num_slots = #category_slots

	for i = 1, num_slots, 1 do
		repeat
			local slot = category_slots[i]
			local slot_name = slot.name
			local item = BackendUtils.get_loadout_item(career_name, slot_name)
			local item_data = nil

			if item then
				item_data = table.clone(item.data)
				item_data.backend_id = item.backend_id
			else
				local item_name = self.initial_inventory[slot_name]
				item_data = rawget(ItemMasterList, item_name)

				if not item_data then
					break
				end
			end

			if item_data.slot_to_use then
				local override_slot_data = self._equipment.slots[item_data.slot_to_use]

				if not override_slot_data then
					break
				end

				local override_item_data = override_slot_data.item_data
				item_data.left_hand_unit = override_item_data.left_hand_unit
				item_data.right_hand_unit = override_item_data.right_hand_unit
			end

            if item_data ~= nil and category == "weapon_slots" then
                local profile = self._profile
                local item_name = profile.equipment_slots[slot_name]
			    item_data = rawget(ItemMasterList, item_name)

                local backend_items = Managers.backend:get_interface("items")
                item = backend_items:get_item_from_key(item_name)
                print("MOD: add_equipment_by_category Changed to " .. tostring(item_name))
            end

			self:add_equipment(slot_name, item_data, nil, nil, self.initial_ammo_percent[slot_name])
		until true
	end
end

SimpleInventoryExtension.extensions_ready = function (self, world, unit)
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self.first_person_extension = first_person_extension
	self._first_person_unit = first_person_extension:get_first_person_unit()
	self.buff_extension = ScriptUnit.extension(unit, "buff_system")
	local career_extension = ScriptUnit.extension(unit, "career_system")
	self.career_extension = career_extension
	local talent_extension = ScriptUnit.has_extension(unit, "talent_system")
	self.talent_extension = talent_extension
	local equipment = self._equipment
	local profile = self._profile
	local unit_1p = self._first_person_unit
	local unit_3p = self._unit

	self:add_equipment_by_category("weapon_slots")
	self:add_equipment_by_category("enemy_weapon_slots")

    if has_wom then
	    local skill_index = (talent_extension and talent_extension:get_talent_career_skill_index()) or 1
	    local weapon_index = talent_extension and talent_extension:get_talent_career_weapon_index()
        self.initial_inventory.slot_career_skill_weapon = career_extension:career_skill_weapon_name(skill_index, weapon_index)
    else
        self.initial_inventory.slot_career_skill_weapon = self.career_extension:career_skill_weapon_name()
    end


	self:add_equipment_by_category("career_skill_weapon_slots")

	local additional_inventory = self.initial_inventory.additional_items

	if additional_inventory then
		for i = 1, #additional_inventory, 1 do
			local additional_item = additional_inventory[i]
			local slot_name = additional_item.slot_name
			local item_data = ItemMasterList[additional_item.item_name]
			local slot_data = self:get_slot_data(slot_name)

			if slot_data then
				self:store_additional_item(slot_name, item_data)
			else
				self:add_equipment(slot_name, item_data)
			end
		end
	end

	Unit.set_data(self._first_person_unit, "equipment", self._equipment)

	if profile.default_wielded_slot then
		local default_wielded_slot = profile.default_wielded_slot
		local slot_data = self._equipment.slots[default_wielded_slot]

		if not slot_data then
            local profile = self._profile
            local item_name = profile.equipment_slots[default_wielded_slot]
            local item_data = rawget(ItemMasterList, item_name)
            local world = self._world
	        local equipment = self._equipment
	        local unit_1p = self._first_person_unit
	        local unit_3p = self._unit
	        local is_bot = self.is_bot
	        local override_item_units = nil
	        local override_item_template = self:override_career_skill_item_template(item_data)

	        if item_data.slot_to_use then
	        	local other_slot_slot_data = self._equipment.slots[item_data.slot_to_use]
	        	override_item_units = BackendUtils.get_item_units(other_slot_slot_data.item_data)
	        end

        
            local slot_equipment_data = GearUtils.create_equipment(world, default_wielded_slot, item_data, unit_1p, unit_3p, is_bot, nil, nil, self.initial_ammo_percent[default_wielded_slot], override_item_template, override_item_units)
            slot_equipment_data.master_item = item_data
            slot_data = slot_equipment_data
			

            --local backend_items = Managers.backend:get_interface("items")
            --item = backend_items:get_item_from_key(item_name)
            print("MOD: extensions_ready Changed to " .. tostring(item_name))
			--table.dump(self._equipment.slots, "self._equipment.slots", 1)
			--Application.error("Tried to wield default slot %s for %s that contained no weapon.", default_wielded_slot, career_extension:career_name())
		end

		self:_wield_slot(equipment, slot_data, unit_1p, unit_3p)

		local item_data = slot_data.item_data
		local item_template = BackendUtils.get_item_template(item_data)

		self:_spawn_attached_units(item_template.first_person_attached_units)

		local backend_id = item_data.backend_id
		local buffs = self:_get_property_and_trait_buffs(backend_id)

		self:apply_buffs(buffs, "wield", item_data.name, default_wielded_slot)
	end

	self._equipment.wielded_slot = profile.default_wielded_slot
end

LevelUnlockUtils.completed_level_difficulty_index = function (statistics_db, player_stats_id, level_key)
	local level_difficulty_name = LevelDifficultyDBNames[level_key]

	if level_difficulty_name then
        local difficulty_index = statistics_db:get_persistent_stat(player_stats_id, "completed_levels_difficulty", level_difficulty_name)
        if has_wom then
            return difficulty_index
        elseif difficulty_index >= 5 then
            return 4
        else
            return difficulty_index
        end
	else
		return 0
    end
end

StartGameStateSettingsOverview.get_difficulty_option = function (self, ignore_approval)
    local selected_difficulty_key = self._selected_difficulty_key
    
    if selected_difficulty_key == "cataclysm" and has_wom then
        selected_difficulty_key = "hardest"
        self:set_difficulty_option("hardest")
    end

	if not ignore_approval and selected_difficulty_key and not self:is_difficulty_approved(selected_difficulty_key) then
		selected_difficulty_key = nil
	end

	return selected_difficulty_key
end

PlayFabMirror.init = function (self, signin_result)
    if has_drachen1 then
        self._num_items_to_load = 0
        self._stats = {}
        self._commits = {}
        self._commit_current_id = nil
        self._last_id = 0
        self._queued_commit = {}
        self._request_queue = PlayFabRequestQueue:new()
        self._quest_data = {}
        self._fake_inventory_items = {}
        self._best_power_levels = nil
        self.sum_best_power_levels = nil
        self._playfab_id = signin_result.PlayFabId
        local info_result_payload = signin_result.InfoResultPayload
        local read_only_data = info_result_payload.UserReadOnlyData or {}
        local read_only_data_values = {}

        for key, data in pairs(read_only_data) do
            local value = data.Value

            if tonumber(value) then
                value = tonumber(value)
            elseif value == "true" or value == "false" then
                value = to_boolean(value)
            end

            read_only_data_values[key] = value
        end

        self._read_only_data = read_only_data_values
        self._read_only_data_mirror = table.clone(read_only_data_values)
        local title_data = info_result_payload.TitleData or {}
        self._title_data = {}

        for key, value in pairs(title_data) do
            self:set_title_data(key, value)
        end

        local user_data = info_result_payload.UserData or {}
        local user_data_values = {}

        for key, value_table in pairs(user_data) do
            local value = value_table.Value

            if value then
                if tonumber(value) then
                    value = tonumber(value)
                elseif value == "true" or value == "false" then
                    value = to_boolean(value)
                end

                user_data_values[key] = value
            end
        end

        self._user_data = user_data_values
        self._user_data_mirror = table.clone(self._user_data)
        self._commit_limit_timer = REDUCTION_INTERVAL
        self._commit_limit_total = 1
        self:_update_dlc_ownership()
    elseif has_boggy then
        self._num_items_to_load = 0
        self._stats = {}
        self._commits = {}
        self._commit_current_id = nil
        self._last_id = 0
        self._queued_commit = {}
        self._request_queue = PlayFabRequestQueue:new()
        self._quest_data = {}
        self._fake_inventory_items = {}
        self._best_power_levels = nil
        self.sum_best_power_levels = nil
        local info_result_payload = signin_result.InfoResultPayload
        local read_only_data = info_result_payload.UserReadOnlyData
        local read_only_data_values = {}

        for key, data in pairs(read_only_data) do
            local value = data.Value

            if tonumber(value) then
                value = tonumber(value)
            elseif value == "true" or value == "false" then
                value = to_boolean(value)
            end

            read_only_data_values[key] = value
        end

        self._read_only_data = read_only_data_values
        self._read_only_data_mirror = table.clone(read_only_data_values)
        local title_data = info_result_payload.TitleData or {}
        self._title_data = {}

        for key, value in pairs(title_data) do
            self:set_title_data(key, value)
        end

        local user_data = info_result_payload.UserData or {}
        local user_data_values = {}

        for key, value_table in pairs(user_data) do
            local value = value_table.Value

            if value then
                if tonumber(value) then
                    value = tonumber(value)
                end

                user_data_values[key] = value
            end
        end

        self._claimed_achievements = self:_parse_claimed_achievements(read_only_data_values)
        self._unlocked_weapon_skins = self:_parse_unlocked_weapon_skins(read_only_data_values)
        local unlocked_keep_decorations_json = read_only_data_values.unlocked_keep_decorations or "{}"
        self._unlocked_keep_decorations = cjson.decode(unlocked_keep_decorations_json)
        self._user_data = user_data_values
        self._user_data_mirror = table.clone(self._user_data)
        self._commit_limit_timer = REDUCTION_INTERVAL
        self._commit_limit_total = 1

        if PLATFORM == "xb1" or PLATFORM == "ps4" then
            self._claimed_console_dlc_rewards = self:_parse_claimed_console_dlc_rewards(read_only_data_values)
        end

        self:_execute_dlc_specific_logic_challenge()
    else
        self._num_items_to_load = 0
            self._stats = {}
            self._commits = {}
            self._commit_current_id = nil
            self._last_id = 0
            self._queued_commit = {}
            self._request_queue = PlayFabRequestQueue:new()
            self._quest_data = {}
            self._best_power_levels = nil
            self.sum_best_power_levels = nil
            local info_result_payload = signin_result.InfoResultPayload
            local read_only_data = info_result_payload.UserReadOnlyData
            local read_only_data_values = {}
        
            for key, data in pairs(read_only_data) do
                local value = data.Value
        
                if tonumber(value) then
                    value = tonumber(value)
                end
        
                read_only_data_values[key] = value
            end
        
            self._read_only_data = read_only_data_values
            self._read_only_data_mirror = table.clone(read_only_data_values)
            local title_data = info_result_payload.TitleData
            local title_data_values = {}
        
            for key, value in pairs(title_data) do
                if tonumber(value) then
                    value = tonumber(value)
                end
        
                title_data_values[key] = value
            end
        
            self._title_data = title_data_values
            self._commit_limit_timer = REDUCTION_INTERVAL
            self._commit_limit_total = 1
            self._claimed_achievements = self:_parse_claimed_achievements(read_only_data_values)
        
            self:_request_best_power_levels()
    end
end

talent_ids = {}

TalentExtension._get_talent_ids = function (self)
    if has_wom then 
        local talent_interface = Managers.backend:get_talents_interface()
    	local career_name = self._career_name
    	local talent_tree = talent_interface:get_talent_tree(career_name)
    	local talent_ids = {}

    	if talent_tree then
    		local talents = talent_interface:get_talents(career_name)

    		for i = 1, #talents, 1 do
    			local column = talents[i]

    			if column == 0 then
    				talent_ids[i] = 0
    			else
	    			local talent_name = talent_tree[i][column]
	    			talent_ids[i] = (TalentIDLookup[talent_name] and TalentIDLookup[talent_name].talent_id) or 0
			    end
		    end
	    end

	    return talent_ids
    else
        local talent_interface = Managers.backend:get_interface("talents")
        local career_name = self._career_name
        local talents = talent_interface:get_talents(career_name)
        local career_settings = self.career_extension:career_settings()
        local talent_tree_index = career_settings.talent_tree_index
    
        table.clear(talent_ids)
    
        if talent_tree_index then
            local talent_tree = TalentTrees[self._hero_name][talent_tree_index]
    
            for i = 1, 5, 1 do --changes number of times to 5
                local column = talents[i]
    
                if column == 0 then
                    talent_ids[i] = 0
                else
                    local talent_name = talent_tree[i][column]
                    talent_ids[i] = TalentIDLookup[talent_name] or 0
                end
            end
    
            return talent_ids
        end
    end
end--]]