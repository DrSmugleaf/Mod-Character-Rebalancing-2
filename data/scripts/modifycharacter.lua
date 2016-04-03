local ModifyCharacter = Class(function(self, inst)
	self.inst = inst
end)

function ModifyCharacter:ModifyStats(inst, stats)
	inst.components.health:SetMaxHealth(stats.health or inst.components.health.currenthealth)
	inst.components.hunger:SetMax(stats.hunger or inst.components.hunger.current)
	inst.components.sanity:SetMax(stats.sanity or inst.components.sanity.current)
	
	inst.components.combat.damagemultiplier = stats.damage or inst.components.combat.damagemultiplier
	
	inst.components.temperature.inherentinsulation = stats.winterinsulation or inst.components.temperature.inherentinsulation
	inst.components.temperature.inherentsummerinsulation = stats.summerinsulation or inst.components.temperature.summerinsulation
	
	inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * stats.walkspeed or inst.components.locomotor.walkspeed
	inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * stats.runspeed or inst.components.locomotor.runspeed
	
	inst.components.sanity.dapperness = stats.dapperness or inst.components.sanity.dapperness
	inst.components.sanity.dapperness_mult = stats.dapperness_mult or inst.components.sanity.dapperness_mult
	inst.components.sanity.night_drain_mult = stats.night_drain_mult or inst.components.sanity.night_drain_mult
	inst.components.sanity.neg_aura_mult = stats.neg_aura_mult or inst.components.sanity.neg_aura_mult
	
	inst.components.eater.strongstomach = stats.strongstomach or inst.components.eater.strongstomach
	inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * hungerrate or inst.components.hunger.hungerrate)
end

return ModifyCharacter
