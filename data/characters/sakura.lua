local MODTUNING = MODTUNING.SAKURA
local info = KnownModIndex:LoadModInfo("workshop-384048428")

local function addsimpostinit(inst)
end

local function balancesakura(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
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

AddSimPostInit(addsimpostinit)
AddPrefabPostInit("sakura", balancesakura)
