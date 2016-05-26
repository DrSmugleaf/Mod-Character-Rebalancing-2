local MODTUNING = MODTUNING.SABER
local info = KnownModIndex:LoadModInfo("workshop-376244443")

local function addsimpostinit(inst)
	ModRecipe:ChangeRecipe("kendostick", MODTUNING.KENDOSTICK_INGREDIENTS, MODTUNING.KENDOSTICK_RECIPETAB, MODTUNING.KENDOSTICK_TECH, nil, nil, nil, nil, "saber", "images/inventoryimages/kendostick.xml", "kendostick.tex")
	
	STRINGS.RECIPE_DESC.KENDOSTICK = "The better to smash your enemies with."
end

local function balancesaber(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddTag("saber")
end
										
local function balancekendostick(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local function updatedamage(inst)
		if inst.components.finiteuses and inst.components.weapon then
			local dmg = MODTUNING.KENDOSTICK_DAMAGE * (1 - inst.components.finiteuses:GetPercent())
			dmg = Remap(dmg, 0, MODTUNING.KENDOSTICK_DAMAGE, MODTUNING.KENDOSTICK_DAMAGE, MODTUNING.KENDOSTICK_DAMAGE * MODTUNING.KENDOSTICK_DAMAGE_MODIFIER)
			inst.components.weapon:SetDamage(dmg)
		end
	end
	
	local function onload(inst, data)
		updatedamage(inst)
	end
	
	local old_onequip = inst.components.equippable.onequipfn
	local function onequip(inst, owner)
		updatedamage(inst)
		
		if old_onequip ~= nil then
			old_onequip(inst, owner)
		end
	end
	
	local old_onunequip = inst.components.equippable.onunequipfn
	local function onunequip(inst, owner)
		updatedamage(inst)
		
		if old_onunequip ~= nil then
			old_onunequip(inst, owner)
		end
	end
	
	inst.OnLoad = onload
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	
	inst.components.weapon:SetOnAttack(updatedamage)
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MODTUNING.KENDOSTICK_USES)
	inst.components.finiteuses:SetUses(MODTUNING.KENDOSTICK_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	MakeHauntableLaunch(inst)
end

AddSimPostInit(addsimpostinit)
AddPrefabPostInit("saber", balancesaber)
AddPrefabPostInit("kendostick", balancekendostick)
