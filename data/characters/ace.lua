local info = KnownModIndex:LoadModInfo("workshop-388109833")

local function addsimpostinit(inst)
end

local function balanceace(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local acestats =	{
		health = MODTUNING.ACE_HEALTH,
		hunger = MODTUNING.ACE_HUNGER,
		sanity = MODTUNING.ACE_SANITY,
		
		absorb = MODTUNING.ACE_ABSORPTION,
		
		ignoresspoilage = MODTUNING.ACE_IGNORES_SPOILAGE,
		strongstomach = MODTUNING.ACE_STRONG_STOMACH,
		hungerkillrate = MODTUNING.ACE_HUNGER_KILL_RATE,
		hungerrate = MODTUNING.ACE_HUNGER_RATE,
		
		dapperness = MODTUNING.ACE_DAPPERNESS,
		dapperness_mult = MODTUNING.ACE_DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.ACE_NEG_AURA_MULT,
		night_drain_mult = MODTUNING.ACE_NIGHT_DRAIN_MULT,
		
		damage = MODTUNING.ACE_DAMAGE,
		
		walkspeed = MODTUNING.ACE_WALK_SPEED,
		runspeed = MODTUNING.ACE_RUN_SPEED,
		
		winterinsulation = MODTUNING.ACE_WINTER_INSULATION,
		summerinsulation = MODTUNING.ACE_SUMMER_INSULATION,
	}
	
	ModifyCharacter:ModifyStats(inst, acestats)
	
	inst.components.combat.onhitotherfn = (function(attacker, inst, damage, stimuli)
		inst.components.burnable:Ignite(nil, attacker)
	end)
	
	inst.components.temperature.mintemp = MODTUNING.ACE_MIN_TEMP
	
	inst.Light:Enable(false)
	inst:ListenForEvent("ms_respawnedfromghost", function(inst)
		inst.Light:Enable(false)
	end)
end

if GetModConfigData("ACE_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.ACE_SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.ACE_SUPPORTED_VERSION)
		end
		LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
		AddSimPostInit(addsimpostinit)
		AddPrefabPostInit("ace", balanceace)
	else
		LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
	end
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
end
