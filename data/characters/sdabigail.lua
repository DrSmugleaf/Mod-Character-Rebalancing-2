local MODTUNING = MODTUNING.SDABIGAIL
local info = KnownModIndex:LoadModInfo("workshop-647062183")

local function addsimpostinit(inst)
end

local function balancesdabigail(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	RemoveEvent:RemoveListener(inst, "oneat", "sdabigail")
	
	inst:AddTag("sdabigail")
end

local function balancegalaxysword(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local old_onequip = inst.components.equippable.onequipfn
	local function onequip(inst, owner)
		if old_onequip ~= nil then
			old_onequip(inst, owner)
		end
		
		if owner.components ~= nil and owner.components.sanity ~= nil then
			owner.components.sanity:DoDelta(MODTUNING.GALAXYSWORD_PENALTY_SANITY_ONEQUIP)
		end
	end
	
	local old_onunequip = inst.components.equippable.onunequipfn
	local function onunequip(inst, owner)
		if old_onunequip ~= nil then
			old_onunequip(inst, owner)
		end
		
		if owner.components ~= nil and owner.components.sanity ~= nil then
			owner.components.sanity:DoDelta(MODTUNING.GALAXYSWORD_PENALTY_SANITY_ONUNEQUIP)
		end
	end
	
	local old_onattack = inst.components.weapon.onattack
	local function onattack(weapon, attacker, target)
		if old_onattack ~= nil then
			old_onattack(weapon, attacker, target)
		end
		
		if attacker.components ~= nil and attacker.components.sanity ~= nil then
			attacker.components.sanity:DoDelta(MODTUNING.GALAXYSWORD_PENALTY_SANITY_ONATTACK)
		end
	end
	
	inst:AddTag("shadow")
	
	inst.components.weapon:SetDamage(MODTUNING.GALAXYSWORD_DAMAGE)
	inst.components.weapon:SetOnAttack(onattack)
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MODTUNING.GALAXYSWORD_USES)
	inst.components.finiteuses:SetUses(MODTUNING.GALAXYSWORD_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst.components.inventoryitem.keepondeath = false
	
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.dapperness = MODTUNING.GALAXYSWORD_DAPPERNESS
	inst.components.equippable.walkspeedmult = MODTUNING.GALAXYSWORD_SPEED_MULT
	
	MakeHauntableLaunch(inst)
end

local function balancepanflute(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.finiteuses:SetMaxUses(MODTUNING.PANFLUTE_USES)
	inst.components.finiteuses:SetUses(MODTUNING.PANFLUTE_USES)
end

local function balancequartz(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.edible.healthvalue = MODTUNING.QUARTZ_HEALTHVALUE
	inst.components.edible.hungervalue = MODTUNING.QUARTZ_HUNGERVALUE
	inst.components.edible.sanityvalue = MODTUNING.QUARTZ_SANITYVALUE
	
	inst:RemoveComponent("tradable")
	
	MakeHauntableLaunch(inst)
end

local function balanceiridium(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:RemoveComponent("edible")
	inst:RemoveComponent("tradable")
	
	MakeHauntableLaunch(inst)
end

local function balancequartzbar(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.tradable.goldvalue = 2
	
	MakeHauntableLaunch(inst)
end

local function balanceiridiumbar(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.tradable.goldvalue = 5
	
	MakeHauntableLaunch(inst)
end

AddSimPostInit(addsimpostinit)
AddPrefabPostInit("sdabigail", balancesdabigail)
--AddPrefabPostInit("galaxysword", balancegalaxysword)
AddPrefabPostInit("sdpan_flute", balancepanflute)
AddPrefabPostInit("sdquartz", balancequartz)
AddPrefabPostInit("sdiridium", balanceiridium)
AddPrefabPostInit("sdquartzbar", balancequartzbar)
AddPrefabPostInit("sdiridiumbar", balanceiridiumbar)
