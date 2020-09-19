--local mod = get_mod("preboggy")
script_data["eac-untrusted"] = true
-- Your mod code goes here.
-- https://vmf-docs.verminti.de
local invalid_item_keys_table = {
    --2.0
        --Frames
    "frame_bear",
    "frame_scorpion_complete_all_helmgart_levels_cataclysm",
    "frame_scorpion_complete_bogenhafen_cataclysm",
    "frame_scorpion_complete_plaza_cataclysm",
    "frame_scorpion_complete_crater_recruit",
    "frame_scorpion_complete_crater_veteran",
    "frame_scorpion_complete_crater_champion",
    "frame_scorpion_complete_crater_legend",
    "frame_scorpion_complete_crater_cataclysm",
    "frame_scorpion_season_1_beasts",
    "frame_scorpion_season_1_death",
    "frame_scorpion_season_1_fire",
    "frame_scorpion_season_1_heavens",
    "frame_scorpion_season_1_life",
    "frame_scorpion_season_1_light",
    "frame_scorpion_season_1_metal",
    "frame_scorpion_season_1_shadow",
    "frame_scorpion_season_1_cataclysm_1",
    "frame_scorpion_season_1_cataclysm_2",
    "frame_scorpion_season_1_cataclysm_3",
    "frame_scorpion_season_1_leaderboard_1",
    "frame_scorpion_season_1_leaderboard_2",
    "frame_scorpion_season_1_leaderboard_3",
        --Weapons
    "bw_1h_flail_flaming",
    "dr_1h_throwing_axes",
    "es_2h_heavy_spear",
    "we_1h_spears_shield",
    "wh_2h_billhook",
    "bw_1h_flail_flaming_skin",
    "dr_1h_throwing_axes_skin",
    "es_2h_heavy_spear_skin",
    "we_1h_spears_shield_skin",
    "wh_2h_billhook_skin",
    "es_1h_sword_magic_01",
    "es_1h_mace_magic_01",
    "es_2h_sword_executioner_magic_01",
    "es_2h_sword_magic_01",
    "es_2h_hammer_magic_01",
    "es_longbow_tutorial_magic_01",
    "es_2h_hammer_tutorial_magic_01",
    "es_sword_shield_magic_01",
    "es_mace_shield_magic_01 ",
    "es_1h_flail_magic_01",
    "es_halberd_magic_01",
    "es_longbow_magic_01",
    "es_blunderbuss_magic_01",
    "es_handgun_magic_01",
    "es_repeating_handgun_magic_01",
    "we_spear_magic_01",
    "we_dual_wield_daggers_magic_01",
    "we_dual_wield_swords_magic_01",
    "we_1h_sword_magic_01",
    "we_dual_wield_sword_dagger_magic_01",
    "we_shortbow_magic_01",
    "we_shortbow_hagbane_magic_01",
    "we_longbow_magic_01",
    "we_2h_axe_magic_01",
    "we_2h_sword_magic_01",
    "we_crossbow_repeater_magic_01",
    "bw_1h_mace_magic_01",
    "bw_sword_magic_01",
    "bw_flame_sword_magic_01",
    "bw_dagger_magic_01",
    "bw_skullstaff_fireball_magic_01",
    "bw_skullstaff_beam_magic_01",
    "bw_skullstaff_geiser_magic_01",
    "bw_skullstaff_spear_magic_01",
    "bw_skullstaff_flamethrower_magic_01",
    "dr_1h_axe_magic_01",
    "dr_dual_wield_axes_magic_01",
    "dr_2h_axe_magic_01",
    "dr_2h_hammer_magic_01",
    "dr_1h_hammer_magic_01",
    "dr_1h_hammer_magic_01",
    "dr_shield_hammer_magic_01",
    "dr_crossbow_magic_01",
    "dr_rakegun_magic_01",
    "dr_handgun_magic_01",
    "dr_drakegun_magic_01",
    "dr_drake_pistol_magic_01",
    "dr_2h_pick_magic_01",
    "wh_1h_axe_magic_01",
    "wh_2h_sword_magic_01",
    "wh_fencing_sword_magic_01",
    "wh_brace_of_pistols_magic_01",
    "wh_repeating_pistols_magic_01",
    "wh_crossbow_magic_01",
    "wh_crossbow_repeater_magic_01",
    "wh_1h_falchion_magic_01",
    "we_1h_axe_magic_01",
    "bw_1h_crowbill_magic_01",
    "wh_dual_wield_axe_falchion_magic_01",
    "dr_dual_wield_hammers_magic_01",
    "es_dual_wield_hammer_sword_magic_01",
    "bw_1h_flail_flaming_magic_01",
    "dr_1h_throwing_axes_magic_01",
    "es_2h_heavy_spear_magic_01",
    "we_1h_spears_shield_magic_01",
    "wh_2h_billhook_magic_01",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    "frame_bear",
    --Other
    "adept_hat_0008",
    "ironbreaker_hat_0002",
    "ironbreaker_hat_0003",
    "deed_4001",
    "deed_4002",
    "deed_4003",
    "deed_4004",
    "deed_4005",
    "deed_4006",
    "deed_4007",
    "deed_4008",
    "deed_4009",
    "deed_4010",
    "deed_4011",
    "deed_4012",
    "deed_4013",
    "deed_4014",
    "deed_4015",
    "deed_4016",
    "deed_4017",
    "deed_4018",
    "deed_4019",
    "deed_4020",
    "deed_4021",
    "deed_4022",
    "deed_4023",
    "deed_4024",
    "deed_4025",
    "deed_4026",
    "deed_4027",
    "deed_4028",
    "deed_4029",
    "deed_4030",
    "deed_4031",
    "deed_4032",
    "deed_4033",
    "deed_4034",
    "deed_4035",
    "deed_4036",
    "deed_4037",
    "deed_4038",
    "deed_4039",
    "deed_4040",
    "level_chest",
    "level_chest_02",
    "bogenhafen_chest",
    "deed_chest",
    "loot_chest_05_01",
    "loot_chest_05_02",
    "loot_chest_05_03",
    "loot_chest_05_04",
    "loot_chest_05_05",
    "loot_chest_05_06",
    "magic_barrel",
    "wpn_magic_crystal",
    "wpn_shadow_gargoyle_head",
    "shadow_torch",
    "shadow_flare",
    "kerillian_waywatcher_career_skill_weapon_piercing_shot",
        --Skins
    "bw_1h_flail_flaming_skin_01",
    "bw_1h_flail_flaming_skin_01_runed_01",
    "bw_1h_flail_flaming_skin_02",
    "dr_1h_throwing_axes_skin_01",
    "dr_1h_throwing_axes_skin_01_runed_01",
    "dr_1h_throwing_axes_skin_02",
    "es_2h_heavy_spear_skin_01",
    "es_2h_heavy_spear_skin_01_runed_01",
    "es_2h_heavy_spear_skin_02",
    "we_1h_spears_shield_skin_01",
    "we_1h_spears_shield_skin_01_runed_01",
    "we_1h_spears_shield_skin_02",
    "wh_2h_billhook_skin_01",
    "wh_2h_billhook_skin_01_runed_01",
    "wh_2h_billhook_skin_02",
    "es_2h_sword_exe_skin_03_magic_01",
    "es_2h_sword_skin_03_magic_01",
    "wh_2h_sword_skin_04_magic_01",
    "es_2h_hammer_skin_02_magic_01",
    "we_spear_skin_02_magic_01",
    "es_1h_flail_skin_04_magic_01",
    "es_1h_sword_skin_04_magic_01",
    "we_2h_axe_skin_03_magic_01",
    "we_1h_axe_skin_02_magic_01",
    "we_2h_sword_skin_08_magic_01",
    "we_dual_dagger_skin_07_magic_01",
    "we_dual_sword_dagger_skin_07_magic_01",
    "we_dual_sword_skin_06_magic_01",
    "we_sword_skin_06_magic_01",
    "we_longbow_skin_02_magic_01",
    "wh_1h_falchion_skin_04_magic_01",
    "wh_dual_wield_axe_falchion_skin_01_magic_01",
    "wh_1h_axe_skin_06_magic_01",
    "es_dual_wield_hammer_sword_skin_02_magic_01",   
    "es_1h_mace_skin_05_magic_01",
    "we_crossbow_skin_01_magic_01",
    "es_longbow_skin_04_magic_01",
    "es_halberd_skin_03_magic_01",
    "we_shortbow_skin_02_magic_01",
    "we_shortbow_hagbane_skin_02_magic_01",
    "dw_2h_axe_skin_02_magic_01",
    "dw_2h_hammer_skin_03_magic_01",
    "dw_1h_axe_skin_04_magic_01",
    "dw_dual_axe_skin_04_magic_01",
    "dw_1h_hammer_skin_03_magic_01",
    "dr_dual_wield_hammers_skin_01_magic_01",
    "dw_2h_pick_skin_02_magic_01",
    "dw_1h_axe_shield_skin_04_magic_01",
    "dw_1h_hammer_shield_skin_04_magic_01",
    "es_repeating_handgun_skin_01_magic_01",
    "wh_brace_of_pistols_skin_05_magic_01",
    "wh_repeating_pistol_skin_05_magic_01",
    "es_1h_mace_shield_skin_04_magic_01",
    "es_1h_sword_shield_skin_04_magic_01",
    "wh_fencing_sword_skin_07_magic_01",
    "wh_crossbow_skin_06_magic_01",
    "dw_crossbow_skin_03_magic_01",
    "es_blunderbuss_skin_01_magic_01",
    "es_handgun_skin_02_magic_01",
    "dw_drake_pistol_skin_01_magic_01",
    "dw_handgun_skin_03_magic_01",
    "dw_drakegun_skin_02_magic_01",
    "dw_grudge_raker_skin_03_magic_01",
    "bw_1h_sword_skin_06_magic_01",
    "bw_1h_flaming_sword_skin_06_magic_01",
    "bw_1h_mace_skin_02_magic_01",
    "bw_1h_crowbill_skin_01_magic_01",
    "bw_beam_staff_skin_02_magic_01",
    "bw_dagger_skin_02_magic_01",
    "wh_repeating_crossbow_skin_02_magic_01",
    "bw_conflagration_staff_skin_01_magic_01",
    "bw_flamethrower_staff_skin_04_magic_01",
    "bw_spear_staff_skin_05_magic_01",
    "bw_fireball_staff_skin_02_magic_01",
    "bw_1h_flail_flaming_skin_02_magic_01",
    "dr_1h_throwing_axes_skin_02_magic_01",
    "es_2h_heavy_spear_skin_02_magic_01",
    "we_1h_spears_shield_skin_02_magic_01",
    "wh_2h_billhook_skin_02_magic_01",
    --2.0.14
    "frame_geheimnisnacht_03",
    --2.1.0
        --Store
    "shilling_bag_1",
    "shilling_bag_5",
    "shilling_bag_10",
    "shilling_bag_25",
    "shilling_bag_50",
    "shilling_bag_100",
    "shilling_bag_base",
    "shilling_bag_collectors",
    "shilling_bag_bogenhafen",
    "shilling_bag_holly",
    "shilling_bag_scorpion",
        --DLC hats
    "unchained_hat_1001",
    "adept_hat_1001",
    "scholar_hat_1001",
    "ranger_hat_1001",
    "ironbreaker_hat_1001",
    "slayer_hat_1001",
    "huntsman_hat_1001",
    "mercenary_hat_1001",
    "knight_hat_1001",
    "witchhunter_hat_1001",
    "zealot_hat_1001",
    "bountyhunter_hat_1001",
    "waywatcher_hat_1001",
    "shade_hat_1001",
    "maidenguard_hat_1001",
    --2.1.1
    "frame_year_of_the_rat",
    --2.2.2
    "frame_0094",

}

local invalid_item_keys = {}
for i=1, #invalid_item_keys_table do
    local item_key = invalid_item_keys_table[i]
    invalid_item_keys[item_key] = true
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
            
            if invalid_item_keys[item_key] == nil then
                self:_update_data(item, backend_id)

			    self._inventory_items[backend_id] = item
            end
		end
	end

	self:_request_all_users_characters()
end

BackendUtils.get_item_units = function (item_data, backend_id, skin)
	local left_hand_unit = item_data.left_hand_unit
	local right_hand_unit = item_data.right_hand_unit
	local unit = item_data.unit
	local material = item_data.material
	local icon = item_data.hud_icon
	local backend_id = item_data.backend_id or backend_id
	local skin_name = nil

	if backend_id or skin then
		if not skin then
			local backend_items = Managers.backend:get_interface("items")
			skin = backend_items:get_skin(backend_id)
		end
        if skin and not invalid_item_keys[item_key] == nil then
                local skin_template = WeaponSkins.skins[skin]
                left_hand_unit = skin_template.left_hand_unit
                right_hand_unit = skin_template.right_hand_unit
                icon = skin_template.hud_icon
                skin_name = skin
        end
	end

	if left_hand_unit or right_hand_unit or unit or material or icon then
		local units = {
			left_hand_unit = left_hand_unit,
			right_hand_unit = right_hand_unit,
			unit = unit,
			material = material,
			icon = icon,
			skin = skin_name
		}

		return units
	end

	fassert(false, "no left hand or right hand unit defined for : " .. item_data.backend_id)
end

UIUtils.get_ui_information_from_item = function (item)
	local item_data = item.data
	local item_type = item_data.item_type
	local rarity = item.rarity
	local inventory_icon, display_name, description = nil

        if item_type == "weapon_skin" and not invalid_item_keys[item_key] == nil then
            local skin = item.skin
            local skin_template = WeaponSkins.skins[skin]
            inventory_icon = skin_template.inventory_icon
            display_name = skin_template.display_name
            description = skin_template.description
        elseif item.skin and not invalid_item_keys[item_key] == nil then
            local skin = item.skin
            local skin_template = WeaponSkins.skins[skin]
            inventory_icon = skin_template.inventory_icon
            display_name = skin_template.display_name
            description = skin_template.description
        elseif rarity == "default" and not invalid_item_keys[item_key] == nil then
            local item_key = item_data.key
            local default_item_data = UISettings.default_items[item_key]

            if default_item_data then
                inventory_icon = default_item_data.inventory_icon or item_data.inventory_icon
                display_name = default_item_data.display_name or item_data.display_name
                description = default_item_data.description or item_data.description
            else
                inventory_icon = item_data.inventory_icon
                display_name = item_data.display_name
                description = item_data.description
            end
        else
            inventory_icon = item_data.inventory_icon
            display_name = item_data.display_name
            description = item_data.description
        end

	return inventory_icon, display_name, description
end