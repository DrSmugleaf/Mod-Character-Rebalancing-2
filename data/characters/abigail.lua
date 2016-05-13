local info = KnownModIndex:LoadModInfo("workshop-647062183")


local function addsimpostinit(inst)
	AllRecipes["galaxysword"].level = MODTUNING.ABIGAIL_GALAXYSWORD_TECH
	AllRecipes["sdpan_flute"].ingredients = MODTUNING.ABIGAIL_PANFLUTE_INGREDIENTS
	AllRecipes["sdpan_flute"].level = MODTUNING.ABIGAIL_PANFLUTE_TECH
end

local function balanceabigail(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local abigailstats =	{
		health = MODTUNING.ABIGAIL_HEALTH,
		hunger = MODTUNING.ABIGAIL_HUNGER,
		sanity = MODTUNING.ABIGAIL_SANITY,
		
		absorb = MODTUNING.ABIGAIL_ABSORPTION,
		
		ignoresspoilage = MODTUNING.ABIGAIL_IGNORES_SPOILAGE,
		strongstomach = MODTUNING.ABIGAIL_STRONG_STOMACH,
		hungerkillrate = MODTUNING.ABIGAIL_HUNGER_KILL_RATE,
		hungerrate = MODTUNING.ABIGAIL_HUNGER_RATE,
		
		dapperness = MODTUNING.ABIGAIL_DAPPERNESS,
		dapperness_mult = MODTUNING.ABIGAIL_DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.ABIGAIL_NEG_AURA_MULT,
		night_drain_mult = MODTUNING.ABIGAIL_NIGHT_DRAIN_MULT,
		
		damage = MODTUNING.ABIGAIL_DAMAGE,
		
		walkspeed = MODTUNING.ABIGAIL_WALK_SPEED,
		runspeed = MODTUNING.ABIGAIL_RUN_SPEED,
		
		winterinsulation = MODTUNING.ABIGAIL_WINTER_INSULATION,
		summerinsulation = MODTUNING.ABIGAIL_SUMMER_INSULATION,
	}
	
	local start_inv = {"pumpkin_seeds", "pumpkin_seeds", "pumpkin_seeds"}
	
	ModifyCharacter:ModifyStats(inst, abigailstats)
	ModifyCharacter:ChangeStartingInventory(inst, start_inv)
	
	RemoveEvent:RemoveListener(inst, "oneat", "sdabigail")
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
			owner.components.sanity:DoDelta(MODTUNING.ABIGAIL_GALAXYSWORD_PENALTY_SANITY_ONEQUIP)
		end
	end
	
	local old_onunequip = inst.components.equippable.onunequipfn
	local function onunequip(inst, owner)
		if old_onunequip ~= nil then
			old_onunequip(inst, owner)
		end
		
		if owner.components ~= nil and owner.components.sanity ~= nil then
			owner.components.sanity:DoDelta(MODTUNING.ABIGAIL_GALAXYSWORD_PENALTY_SANITY_ONUNEQUIP)
		end
	end
	
	local function onattack(weapon, attacker, target)
		local atkfx = SpawnPrefab("explode_small")
		if atkfx then
			local follower = atkfx.entity:AddFollower()
			follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0 )
		end
		
		if attacker.components ~= nil and attacker.components.sanity ~= nil then
			attacker.components.sanity:DoDelta(MODTUNING.ABIGAIL_GALAXYSWORD_PENALTY_SANITY_ONATTACK)
		end
	end
	
	inst:AddTag("shadow")
	
	inst.components.weapon:SetDamage(MODTUNING.ABIGAIL_GALAXYSWORD_DAMAGE)
	inst.components.weapon:SetOnAttack(onattack)
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MODTUNING.ABIGAIL_GALAXYSWORD_USES)
	inst.components.finiteuses:SetUses(MODTUNING.ABIGAIL_GALAXYSWORD_USES)
	inst.components.finiteuses:SetOnFinished(inst.remove)
	
	inst.components.inventoryitem.keepondeath = false
	
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.dapperness = MODTUNING.ABIGAIL_GALAXYSWORD_DAPPERNESS
	inst.components.equippable.walkspeedmult = MODTUNING.ABIGAIL_GALAXYSWORD_SPEED_MULT
	
	MakeHauntableLaunch(inst)
	
	return inst
end

local function balancepanflute(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.finiteuses:SetMaxUses(MODTUNING.ABIGAIL_PANFLUTE_USES)
	inst.components.finiteuses:SetUses(MODTUNING.ABIGAIL_PANFLUTE_USES)
end

local function balancequartz(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.edible.healthvalue = MODTUNING.ABIGAIL_QUARTZ_HEALTHVALUE
	inst.components.edible.hungervalue = MODTUNING.ABIGAIL_QUARTZ_HUNGERVALUE
	inst.components.edible.sanityvalue = MODTUNING.ABIGAIL_QUARTZ_SANITYVALUE
	
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

if GetModConfigData("ABIGAIL_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.ABIGAIL_SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.ABIGAIL_SUPPORTED_VERSION)
		end
		LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
		AddSimPostInit(addsimpostinit)
		AddPrefabPostInit("sdabigail", balanceabigail)
		AddPrefabPostInit("galaxysword", balancegalaxysword)
		AddPrefabPostInit("sdpan_flute", balancepanflute)
		AddPrefabPostInit("sdquartz", balancequartz)
		AddPrefabPostInit("sdiridium", balanceiridium)
		AddPrefabPostInit("sdquartzbar", balancequartzbar)
		AddPrefabPostInit("sdiridiumbar", balanceiridiumbar)
	else
		LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
	end
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
end
