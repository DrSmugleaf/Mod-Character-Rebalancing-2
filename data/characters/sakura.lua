local info = KnownModIndex:LoadModInfo("workshop-384048428")


local function addsimpostinit(inst)
end

local function balancesakura(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local sakurastats =	{
		health = MODTUNING.SAKURA_HEALTH,
		hunger = MODTUNING.SAKURA_HUNGER,
		sanity = MODTUNING.SAKURA_SANITY,
		damage = MODTUNING.SAKURA_DAMAGE,
		walkspeed = MODTUNING.SAKURA_WALK_SPEED,
		runspeed = MODTUNING.SAKURA_RUN_SPEED,
		winterinsulation = MODTUNING.SAKURA_WINTER_INSULATION,
		summerinsulation = MODTUNING.SAKURA_SUMMER_INSULATION,
		dapperness = MODTUNING.SAKURA_DAPPERNESS,
		dapperness_mult = MODTUNING.SAKURA_DAPPERNESS_MULT,
		night_drain_mult = MODTUNING.SAKURA_NIGHT_DRAIN_MULT,
		neg_aura_mult = MODTUNING.SAKURA_NEG_AURA_MULT,
		strongstomach = MODTUNING.SAKURA_STRONG_STOMACH,
		hungerrate = MODTUNING.SAKURA_HUNGER_RATE,
		hungerkillrate = MODTUNING.SAKURA_HUNGER_KILL_RATE,
		absorb = MODTUNING.SAKURA_ABSORPTION,
	}
	
	ModifyCharacter:ModifyStats(inst, sakurastats)
	
	RemoveEvent:RemoveWatchWorldState(inst, "startday")
	RemoveEvent:RemoveWatchWorldState(inst, "startdusk")
	RemoveEvent:RemoveWatchWorldState(inst, "startnight")
	
	inst:AddTag("monster")
	
	inst:RemoveComponent("reader")
	
	inst.components.eater.ignoresspoilage = MODTUNING.SAKURA_IGNORE_SPOILAGE
	local defaulteater = require("components/eater")
	function inst.components.eater:Eat(food)
		return defaulteater.Eat(self, food)
	end
	
	if TheNet:GetPVPEnabled() then
		inst.components.sanityaura.aura = MODTUNING.SAKURA_SANITY_AURA_PVP
	else
		inst.components.sanityaura.aura = MODTUNING.SAKURA_SANITY_AURA_NOPVP
	end
	
	local function updatestats()
		if TheWorld.state.phase == "day" then
			inst.components.combat.damagemultiplier = MODTUNING.SAKURA_DAMAGE_DAY
			
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * MODTUNING.SAKURA_WALK_SPEED_DAY
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * MODTUNING.SAKURA_RUN_SPEED_DAY
		elseif TheWorld.state.phase == "dusk" then
			inst.components.combat.damagemultiplier = MODTUNING.SAKURA_DAMAGE_DUSK
			
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * MODTUNING.SAKURA_WALK_SPEED_DUSK
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * MODTUNING.SAKURA_RUN_SPEED_DUSK
		elseif TheWorld.state.phase == "night" then
			inst.components.combat.damagemultiplier = MODTUNING.SAKURA_DAMAGE_NIGHT
			
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * MODTUNING.SAKURA_WALK_SPEED_NIGHT
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * MODTUNING.SAKURA_RUN_SPEED_NIGHT
		end
	end
	
	inst:WatchWorldState("startday", updatestats(inst))
	inst:WatchWorldState("startdusk", updatestats(inst))
	inst:WatchWorldState("startnight", updatestats(inst))
	updatestats(inst)
end

if not info.ignoreMCR then
	if info.version ~= MODTUNING.SAKURA_SUPPORTED_VERSION then
		LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.SAKURA_SUPPORTED_VERSION)
	end
	LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
	AddSimPostInit(addsimpostinit)
	AddPrefabPostInit("sakura", balancesakura)
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " disabled by " .. info.author)
end
