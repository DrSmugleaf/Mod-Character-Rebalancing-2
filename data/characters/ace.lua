local info = KnownModIndex:LoadModInfo("workshop-388109833")

local function addsimpostinit(inst)
	AddRecipe("acefire", MODTUNING.ACE_FIRE_INGREDIENTS, MODTUNING.ACE_FIRE_RECIPETAB, MODTUNING.ACE_FIRE_TECH, nil, nil, nil, nil, "ace", "images/inventoryimages/acefire.xml", "acefire.tex")
	AddRecipe("acehat", MODTUNING.ACE_HAT_INGREDIENTS, MODTUNING.ACE_HAT_RECIPETAB, MODTUNING.ACE_HAT_TECH, nil, nil, nil, nil, "ace", "images/inventoryimages/acehat.xml", "acehat.tex")
end

local function balanceace(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local acestats =	{
		health = MODTUNING.ACE_HEALTH,
		hunger = MODTUNING.ACE_HUNGER,
		sanity = MODTUNING.ACE_SANITY,
		
		absorb = MODTUNING.ACE_ABSORPTION,
		
		ignoresspoilage = MODTUNING.ACE_IGNORES_SPOILAGE,
		strongstomach = MODTUNING.ACE_STRONG_STOMACH,
		hungerkillrate = MODTUNING.ACE_HUNGER_KILL_RATE,
		hungerrate = MODTUNING.ACE_HUNGER_RATE,
		
		dapperness = MODTUNING.ACE_DAPPERNESS,
		dapperness_mult = MODTUNING.ACE_DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.ACE_NEG_AURA_MULT,
		night_drain_mult = MODTUNING.ACE_NIGHT_DRAIN_MULT,
		
		damage = MODTUNING.ACE_DAMAGE,
		
		walkspeed = MODTUNING.ACE_WALK_SPEED,
		runspeed = MODTUNING.ACE_RUN_SPEED,
		
		winterinsulation = MODTUNING.ACE_WINTER_INSULATION,
		summerinsulation = MODTUNING.ACE_SUMMER_INSULATION,
	}
	
	ModifyCharacter:ModifyStats(inst, acestats)
	
	inst:AddTag("ace")
	
	inst.components.combat.onhitotherfn = (function(attacker, inst, damage, stimuli)
		inst.components.burnable:Ignite(nil, attacker)
	end)
	
	inst.components.temperature.mintemp = MODTUNING.ACE_MIN_TEMP
	
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
			attacker.components.sanity:DoDelta(MODTUNING.ACE_FIRE_PENALTY_SANITY_ONATTACK)
		end
	end
	
	local function onequip(inst, owner)
		inst.components.burnable:Ignite()
		
		owner.AnimState:OverrideSymbol("swap_object", "swap_acefire", "swap_acefire")
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
		
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
		
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
	end
	
	local function onpocket(inst, owner)
		inst.components.burnable:Extinguish()
	end
	
	inst:AddTag("lighter")
	inst:AddTag("shadow")
	
	inst.components.weapon:SetDamage(MODTUNING.ACE_FIRE_DAMAGE)
	inst.components.weapon:SetOnAttack(onattack)
	
	inst:AddComponent("lighter")
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MODTUNING.ACE_FIRE_USES)
	inst.components.finiteuses:SetUses(MODTUNING.ACE_FIRE_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
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
	
	return inst
end

local function balanceacehat(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(MODTUNING.ACE_HAT_PERISHTIME)
	inst.components.fueled:SetDepletedFn(inst.Remove)
	
	inst:RemoveComponent("tradable")
	
	inst.components.inventoryitem.keepondeath = false
end

if GetModConfigData("ACE_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.ACE_SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.ACE_SUPPORTED_VERSION)
		end
		LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
		AddSimPostInit(addsimpostinit)
		AddPrefabPostInit("ace", balanceace)
		AddPrefabPostInit("acefire", balanceacefire)
		AddPrefabPostInit("acehat", balanceacehat)
	else
		LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
	end
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
end
