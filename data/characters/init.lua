for k, v in pairs(MODTUNING) do
	if	type(v) == "table" and 
		v.MOD_NAME and
		v.CHARACTER and
		v.SUPPORTED_VERSION and
		(KnownModIndex:IsModEnabled(string.lower(v.MOD_NAME)) or 
		KnownModIndex:IsModTempEnabled(string.lower(v.MOD_NAME))) then
		local info = KnownModIndex:LoadModInfo(string.lower(v.MOD_NAME))
		if GetModConfigData(string.upper(v.CHARACTER) .. "_BALANCED") then
			if not info.ignoreMCR2 then
				if info.version ~= v.SUPPORTED_VERSION then
					LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. v.SUPPORTED_VERSION)
				end
				LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version)
				AddPrefabPostInit(string.lower(v.CHARACTER), function(inst)
					ModifyCharacter:ModifyStats(inst, v)
					if v.INVENTORY then
						ModifyCharacter:ChangeStartingInventory(inst, v.INVENTORY)
					end
				end)
				Load("data/characters/" .. string.lower(v.CHARACTER))
			else
				LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
			end
		else
			LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
		end
	end
end
