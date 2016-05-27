ModifyItem = Class(function(self, inst)
	self.inst = inst
end)

function ModifyItem:ModifyStats(inst, stats)
	if not TheWorld.ismastersim then
		return inst
	end
	
	for k, v in pairs(stats.COMPONENTS) do
		if not inst.components[v] then
			inst:AddComponent(v)
		end
	end
	
	if inst.components.edible ~= nil then
		inst.components.edible.healthvalue = stats.HEALTHVALUE or inst.components.edible.healthvalue
		inst.components.edible.hungervalue = stats.HUNGERVALUE or inst.components.edible.hungervalue
		inst.components.edible.sanityvalue = stats.SANITYVALUE or inst.components.edible.sanityvalue
	end
	
	if inst.components.equippable ~= nil then
		inst.components.equippable.dapperness = stats.DAPPERNESS or inst.components.equippable.dapperness
		inst.components.equippable.walkspeedmult = stats.SPEED_MULT
	end
	
	if inst.components.finiteuses ~= nil then
		inst.components.finiteuses:SetMaxUses(stats.USES or inst.components.finiteuses.total)
		inst.components.finiteuses:SetUses(stats.USES or inst.components.finiteuses.current)
		inst.components.finiteuses:SetOnFinished(stats.ON_FINISHED or inst.components.finiteuses.onfinished)
	end
	
	if inst.components.tradable ~= nil then
		inst.components.tradable.goldvalue = stats.GOLD_VALUE
	end
	
	if inst.components.weapon ~= nil then
		inst.components.weapon:SetDamage(stats.DAMAGE or inst.components.weapon.damage)
	end
end

return ModifyItem
