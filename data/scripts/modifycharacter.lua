local ModifyCharacter = Class(function(self, inst)
	self.inst = inst
end)

function ModifyCharacter:ModifyStats(inst, stats)
	inst.components.health:SetMaxHealth(stats.health or inst.components.health.currenthealth)
	inst.components.hunger:SetMax(stats.hunger or inst.components.hunger.current)
	inst.components.sanity:SetMax(stats.sanity or inst.components.sanity.current)
end

return ModifyCharacter
