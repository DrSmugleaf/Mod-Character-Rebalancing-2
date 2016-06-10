for k, v in pairs(MODTUNING) do
	if	type(v) == "table" and 
		v.MOD_NAME and
		v.CHARACTER and
		v.SUPPORTED_VERSION and
		(KnownModIndex:IsModEnabled(v.MOD_NAME) or 
		KnownModIndex:IsModTempEnabled(v.MOD_NAME)) then
		local info = KnownModIndex:LoadModInfo(v.MOD_NAME)
		if GetModConfigData(string.upper(v.CHARACTER) .. "_BALANCED") then
			if not info.ignoreMCR2 then
				if info.version ~= v.SUPPORTED_VERSION then
					LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. v.SUPPORTED_VERSION)
				end
				LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version)
				AddPrefabPostInit(v.CHARACTER, function(inst)
					ModifyCharacter:ModifyStats(inst, v)
					if v.INVENTORY then
						ModifyCharacter:ChangeStartingInventory(inst, v.INVENTORY)
					end
				end)
				for k, v in pairs(v) do
					if type(v) == "table" and v.ITEM then
						if v.INGREDIENTS then
							AddSimPostInit(function(inst)
								ModRecipe:ChangeRecipe(v.ITEM, v.INGREDIENTS, v.TAB, v.TECH, v.PLACER, v.MIN_SPACING, v.NO_UNLOCK, v.NUM_TO_GIVE, v.BUILDER_TAG, v.ATLAS, v.IMAGE, v.RECIPE_DESC)
							end)
						end
						AddPrefabPostInit(v.ITEM, function(inst)
							ModifyItem:ModifyStats(inst, v)
						end)
					end
				end
				Load("data/characters/" .. v.CHARACTER)
			else
				LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
			end
		else
			LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
		end
	end
end
