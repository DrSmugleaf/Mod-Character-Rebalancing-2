local MODTUNING = MODTUNING.ACE
local info = KnownModIndex:LoadModInfo("workshop-388109833")

local function addsimpostinit(inst)
	ModRecipe:ChangeRecipe("acehat", MODTUNING.HAT_INGREDIENTS, MODTUNING.HAT_RECIPETAB, MODTUNING.HAT_TECH, nil, nil, nil, nil, "ace", "images/inventoryimages/acehat.xml", "acehat.tex")
	
	--STRINGS.RECIPE_DESC.ACEFIRE = "Victims might catch on fire."
	--STRINGS.RECIPE_DESC.ACEHAT = "Not just a better Garland. Promise."
end

local function balanceace(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddTag("ace")
	
	inst.components.combat.onhitotherfn = (function(attacker, inst, damage, stimuli)
		inst.components.burnable:Ignite(nil, attacker)
	end)
	
	inst.components.temperature.mintemp = MODTUNING.MIN_TEMP
	
	inst.Light:Enable(false)
	inst:ListenForEvent("ms_respawnedfromghost", function(inst)
		inst.Light:Enable(false)
	end)
end

local function balanceacefire(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local function onattack(weapon, attacker, target)
		local atkfx = SpawnPrefab("attackfire_fx")
		if atkfx then
			local follower = atkfx.entity:AddFollower()
			follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
		end
		
		if attacker.components ~= nil and attacker.components.sanity ~= nil then
			attacker.components.sanity:DoDelta(MODTUNING.ACEFIRE.PENALTY_SANITY_ONATTACK)
		end
	end
	
	local old_onequip = inst.components.equippable.onequipfn
	local function onequip(inst, owner)
		inst.components.burnable:Ignite()
		
		if old_onequip ~= nil then
			old_onequip(inst, owner)
		end
		
		if inst.fires == nil then
			local fire_fx = nil
			if inst:GetSkinName() ~= nil then
				fire_fx = SKIN_FX_PREFAB[inst:GetSkinName()] or {}
			else
				fire_fx = {"torchfire"}
			end
			
			inst.fires = {}
			for _,fx_prefab in pairs(fire_fx) do
				local fx = SpawnPrefab(fx_prefab)
				local follower = fx.entity:AddFollower()
				follower:FollowSymbol(owner.GUID, "swap_object", 0, fx.fx_offset, 0)
				
				table.insert(inst.fires, fx)
			end
		end
	end
	
	local old_onunequip = inst.components.equippable.onunequipfn
	local function onunequip(inst, owner)
		local skin_build = inst:GetSkinBuild()
		if skin_build ~= nil then
			owner:PushEvent("unequipskinneditem", inst:GetSkinName())
		end
		
		if inst.fires ~= nil then
			for _,fx in pairs(inst.fires) do
				fx:Remove()
			end
			inst.fires = nil
			inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")
		end
		
		inst.components.burnable:Extinguish()
		
		if old_onunequip ~= nil then
			old_onunequip(inst, owner)
		end
	end
	
	local function onpocket(inst, owner)
		inst.components.burnable:Extinguish()
	end
	
	inst:AddTag("lighter")
	inst:AddTag("shadow")
	
	--inst.components.weapon:SetDamage(MODTUNING.FIRE_DAMAGE)
	inst.components.weapon:SetOnAttack(onattack)
	
	inst:AddComponent("lighter")
	
	--inst:AddComponent("finiteuses")
	--inst.components.finiteuses:SetMaxUses(MODTUNING.FIRE_USES)
	--inst.components.finiteuses:SetUses(MODTUNING.FIRE_USES)
	--inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst.components.inventoryitem.keepondeath = false
	
	inst.components.equippable:SetOnPocket(onpocket)
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
	
	inst:AddComponent("burnable")
	inst.components.burnable.canlight = false
	inst.components.burnable.fxprefab = nil
	
	MakeHauntableLaunch(inst)
end

local function balanceacehat(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.dapperness.dapperness = TUNING.DAPPERNESS_TINY
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(MODTUNING.ACEHAT.PERISHTIME)
	inst.components.fueled:SetDepletedFn(inst.Remove)
	
	inst:RemoveComponent("tradable")
	
	inst.components.inventoryitem.keepondeath = false
	
	MakeHauntableLaunch(inst)
end

AddSimPostInit(addsimpostinit)
AddPrefabPostInit("ace", balanceace)
AddPrefabPostInit("acefire", balanceacefire)
AddPrefabPostInit("acehat", balanceacehat)
