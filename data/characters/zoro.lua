local MODTUNING = MODTUNING.ZORO
local info = KnownModIndex:LoadModInfo("workshop-409184357")
local minimapinfo = KnownModIndex:LoadModInfo("workshop-345692228")

local function addsimpostinit(inst)
end

local function balancezoro(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local zorostats =	{
		health = MODTUNING.HEALTH,
		hunger = MODTUNING.HUNGER,
		sanity = MODTUNING.SANITY,
		
		firedamagescale = MODTUNING.FIRE_DAMAGE_SCALE,
		absorb = MODTUNING.ABSORB,
		playerabsorb = MODTUNING.PLAYER_ABSORB,
		
		ignoresspoilage = MODTUNING.IGNORES_SPOILAGE,
		strongstomach = MODTUNING.STRONG_STOMACH,
		caneat = MODTUNING.CAN_EAT,
		preferseating = MODTUNING.PREFERS_EATING,
		hungerhurtrate = MODTUNING.HUNGER_HURT_RATE,
		hungerrate = MODTUNING.HUNGER_RATE,
		
		dapperness = MODTUNING.DAPPERNESS,
		dapperness_mult = MODTUNING.DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.NEG_AURA_MULT,
		night_drain_mult = MODTUNING.NIGHT_DRAIN_MULT,
		ghost_drain_mult = MODTUNING.GHOST_DRAIN_MULT,
		
		damage = MODTUNING.DAMAGE,
		attackrange = MODTUNING.ATTACK_RANGE,
		hitrange = MODTUNING.HIT_RANGE,
		areahitrange = MODTUNING.AREA_HIT_RANGE,
		areahitdamagepercent = MODTUNING.AREA_HIT_DAMAGE_PERCENT,
		defaultdamage = MODTUNING.DEFAULT_DAMAGE,
		minattackperiod = MODTUNING.MIN_ATTACK_PERIOD,
		
		walkspeed = MODTUNING.WALK_SPEED,
		runspeed = MODTUNING.RUN_SPEED,
		
		maxtemp = MODTUNING.MAX_TEMP,
		mintemp = MODTUNING.MIN_TEMP,
		overheattemp = MODTUNING.OVERHEAT_TEMP,
		temperaturehurtrate = MODTUNING.TEMPERATURE_HURT_RATE,
		winterinsulation = MODTUNING.WINTER_INSULATION,
		summerinsulation = MODTUNING.SUMMER_INSULATION,
	}
	
	ModifyCharacter:ModifyStats(inst, zorostats)
end

local function deleteminimap(inst)
	inst.old_EnableMinimapUpdating = inst.EnableMinimapUpdating
	function inst:EnableMinimapUpdating()
		if inst.owner.prefab == "zoro" then return end
		inst:old_EnableMinimapUpdating()
	end
	
	return inst
end

if GetModConfigData("ZORO_BALANCED") then
	if not info.ignoreMCR2 then
		if info.version ~= MODTUNING.SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.SUPPORTED_VERSION)
		end
		LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
		AddSimPostInit(addsimpostinit)
		AddPrefabPostInit("zoro", balancezoro)
		if not minimapinfo.ignoreMCR2 and (KnownModIndex:IsModEnabled("workshop-345692228") or KnownModIndex:IsModTempEnabled("workshop-345692228")) then
			AddClassPostConstruct("widgets/minimapwidget", deleteminimap)
		end
	else
		LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
	end
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
end
