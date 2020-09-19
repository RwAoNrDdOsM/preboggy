--local mod = get_mod("preboggy")
script_data["eac-untrusted"] = true

local function has_value (tab, val)
    --print("Start Search")
    for value, n in next, tab do
        -- We grab the first index of our sub-table instead
        if value == val then
            --print("found " .. tostring(val))
            return true
        end
    end
    --print("didn't find " .. tostring(val))
    return false
end

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
            
            if has_value(ItemMasterList, item_key) then
                self:_update_data(item, backend_id)

			    self._inventory_items[backend_id] = item
            end
		end
	end

	self:_request_all_users_characters()
end

LevelUnlockUtils.completed_level_difficulty_index = function (statistics_db, player_stats_id, level_key)
	local level_difficulty_name = LevelDifficultyDBNames[level_key]

	if level_difficulty_name then
        local difficulty_index = statistics_db:get_persistent_stat(player_stats_id, "completed_levels_difficulty", level_difficulty_name)
        if WeaveSettings then
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
    
    if selected_difficulty_key == "cataclysm" then
        selected_difficulty_key = "hardest"
        self:set_difficulty_option("hardest")
    end

	if not ignore_approval and selected_difficulty_key and not self:is_difficulty_approved(selected_difficulty_key) then
		selected_difficulty_key = nil
	end

	return selected_difficulty_key
end

talent_ids = {}

TalentExtension._get_talent_ids = function (self)
    if WeaveSettings then 
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
end