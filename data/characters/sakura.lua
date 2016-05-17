local MODTUNING = MODTUNING.SAKURA
local info = KnownModIndex:LoadModInfo("workshop-384048428")

local function addsimpostinit(inst)
end

local function balancesakura(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local sakurastats =	{
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
	
	ModifyCharacter:ModifyStats(inst, sakurastats)
	
	RemoveEvent:RemoveWatchWorldState(inst, "startday")
	RemoveEvent:RemoveWatchWorldState(inst, "startdusk")
	RemoveEvent:RemoveWatchWorldState(inst, "startnight")
	
	inst:AddTag("monster")
	
	inst:RemoveComponent("reader")
	
	local defaulteater = require("components/eater")
	function inst.components.eater:Eat(food)
		return defaulteater.Eat(self, food)
	end
	
	if TheNet:GetPVPEnabled() then
		inst.components.sanityaura.aura = MODTUNING.SANITY_AURA_PVP
	else
		inst.components.sanityaura.aura = MODTUNING.SANITY_AURA_NOPVP
	end
	
	local function updatestats()
		if TheWorld.state.phase == "day" then
			inst.components.combat.damagemultiplier = MODTUNING.DAMAGE_DAY
			
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * MODTUNING.WALK_SPEED_DAY
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * MODTUNING.RUN_SPEED_DAY
		elseif TheWorld.state.phase == "dusk" then
			inst.components.combat.damagemultiplier = MODTUNING.DAMAGE_DUSK
			
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * MODTUNING.WALK_SPEED_DUSK
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * MODTUNING.RUN_SPEED_DUSK
		elseif TheWorld.state.phase == "night" then
			inst.components.combat.damagemultiplier = MODTUNING.DAMAGE_NIGHT
			
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * MODTUNING.WALK_SPEED_NIGHT
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * MODTUNING.RUN_SPEED_NIGHT
		end
	end
	
	inst:WatchWorldState("startday", function(inst) updatestats(inst) end)
	inst:WatchWorldState("startdusk", function(inst) updatestats(inst) end)
	inst:WatchWorldState("startnight", function(inst) updatestats(inst) end)
	updatestats(inst)
end

if GetModConfigData("SAKURA_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.SUPPORTED_VERSION)
		end
		LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
		AddSimPostInit(addsimpostinit)
		AddPrefabPostInit("sakura", balancesakura)
	else
		LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
	end
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
end
