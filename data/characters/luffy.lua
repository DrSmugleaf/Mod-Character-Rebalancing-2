local MODTUNING = MODTUNING.LUFFY
local info = KnownModIndex:LoadModInfo("workshop-380079744")

local function addsimpostinit(inst)
	ModRecipe:ChangeRecipe("luffyhat", MODTUNING.HAT_INGREDIENTS, MODTUNING.HAT_RECIPETAB, MODTUNING.HAT_TECH, nil, nil, nil, nil, "luffy", "images/inventoryimages/luffyhat.xml", "luffyhat.tex")
	
	STRINGS.RECIPE_DESC.LUFFYHAT = "Not just a better Garland. Promise."
end

local function balanceluffy(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddTag("luffy")
	
	inst.components.combat:SetDefaultDamage(MODTUNING.DEFAULT_DAMAGE)
	if not inst.components.inventory:GetActiveItem() then
		inst.components.combat:SetAreaDamage(MODTUNING.UNARMED_AREA_HIT_RANGE, MODTUNING.UNARMED_AREA_HIT_DAMAGE)
	end
	inst:ListenForEvent("equip", function(inst, data)
		if data.eslot == EQUIPSLOTS.HANDS then
			inst.components.combat:SetAreaDamage(nil, nil)
		end
	end)
	inst:ListenForEvent("unequip", function(inst, data)
		if data.eslot == EQUIPSLOTS.HANDS then
			inst.components.combat:SetAreaDamage(MODTUNING.UNARMED_AREA_HIT_RANGE, MODTUNING.UNARMED_AREA_HIT_DAMAGE)
		end
	end)
	
	local defaulteater = require("components/eater")
	function inst.components.eater:Eat(food)
		return defaulteater.Eat(self, food)
	end
end

local function balanceluffyhat(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(MODTUNING.HAT_PERISHTIME)
	inst.components.fueled:SetDepletedFn(inst.Remove)
	
	inst:RemoveComponent("tradable")
	
	inst.components.inventoryitem.keepondeath = false
end

AddSimPostInit(addsimpostinit)
AddPrefabPostInit("luffy", balanceluffy)
AddPrefabPostInit("luffyhat", balanceluffyhat)
