return {
	run = function()
		return dofile("scripts/mods/preboggy/preboggy")
		--[[fassert(rawget(_G, "new_mod"), "`preboggy` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("preboggy", {
			mod_script       = "scripts/mods/preboggy/preboggy",
			mod_data         = "scripts/mods/preboggy/preboggy_data",
			mod_localization = "scripts/mods/preboggy/preboggy_localization",
		})]]
	end,
	packages = {
		"resource_packages/preboggy/preboggy",
	},
}
