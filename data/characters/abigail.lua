local MODTUNING = MODTUNING.ABIGAIL
local info = KnownModIndex:LoadModInfo("workshop-647062183")

local function addsimpostinit(inst)
	ModRecipe:ChangeRecipe("sdquartzbar", MODTUNING.QUARTZBAR_INGREDIENTS, nil, MODTUNING.QUARTZBAR_TECH, nil, nil, nil, nil, "sdabigail", "images/inventoryimages/sdquartzbar.xml", "sdquartzbar.tex")
	ModRecipe:ChangeRecipe("sdiridiumbar", MODTUNING.IRIDIUMBAR_INGREDIENTS, nil, MODTUNING.IRIDIUMBAR_TECH, nil, nil, nil, nil, "sdabigail", "images/inventoryimages/sdiridiumbar.xml", "sdiridiumbar.tex")
	ModRecipe:ChangeRecipe("galaxysword", MODTUNING.GALAXYSWORD_INGREDIENTS, MODTUNING.GALAXYSWORD_RECIPETAB, MODTUNING.GALAXYSWORD_TECH, nil, nil, nil, nil, "sdabigail", "images/inventoryimages/galaxysword.xml", "galaxysword.tex")
	ModRecipe:ChangeRecipe("sdpan_flute", MODTUNING.PANFLUTE_INGREDIENTS, MODTUNING.PANFLUTE_RECIPETAB, MODTUNING.PANFLUTE_TECH, nil, nil, nil, nil, "sdabigail", "images/inventoryimages/sdpan_flute.xml", "sdpan_flute.tex")
end

local function balanceabigail(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local abigailstats =	{
		health = MODTUNING.HEALTH,
		hunger = MODTUNING.HUNGER,
		sanity = MODTUNING.SANITY,
		
		firedamagescale = MODTUNING.FIRE_DAMAGE_SCALE,
		absorb = MODTUNING.ABSORB,
		playerabsorb = MODTUNING.PLAYER_ABSORB,
		
		ignoresspoilage = MODTUNING.IGNORES_SPOILAGE,
		strongstomach = MODTUNING.STRONG_STOMACH,
		caneat = MODTUNING.CAN_EAT,
		preferseating = MODTUNING.PREFERS_EATING,
		hungerhurtrate = MODTUNING.HUNGER_HURT_RATE,
		hungerrate = MODTUNING.HUNGER_RATE,
		
		dapperness = MODTUNING.DAPPERNESS,
		dapperness_mult = MODTUNING.DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.NEG_AURA_MULT,
		night_drain_mult = MODTUNING.NIGHT_DRAIN_MULT,
		ghost_drain_mult = MODTUNING.GHOST_DRAIN_MULT,
		
		damage = MODTUNING.DAMAGE,
		attackrange = MODTUNING.ATTACK_RANGE,
		hitrange = MODTUNING.HIT_RANGE,
		areahitrange = MODTUNING.AREA_HIT_RANGE,
		areahitdamagepercent = MODTUNING.AREA_HIT_DAMAGE_PERCENT,
		defaultdamage = MODTUNING.DEFAULT_DAMAGE,
		minattackperiod = MODTUNING.MIN_ATTACK_PERIOD,
		
		walkspeed = MODTUNING.WALK_SPEED,
		runspeed = MODTUNING.RUN_SPEED,
		
		maxtemp = MODTUNING.MAX_TEMP,
		mintemp = MODTUNING.MIN_TEMP,
		overheattemp = MODTUNING.OVERHEAT_TEMP,
		temperaturehurtrate = MODTUNING.TEMPERATURE_HURT_RATE,
		winterinsulation = MODTUNING.WINTER_INSULATION,
		summerinsulation = MODTUNING.SUMMER_INSULATION,
	}
	
	ModifyCharacter:ModifyStats(inst, abigailstats)
	ModifyCharacter:ChangeStartingInventory(inst, MODTUNING.INVENTORY)
	
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

if GetModConfigData("ABIGAIL_BALANCED") then
	if not info.ignoreMCR2 then
		if info.version ~= MODTUNING.SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.SUPPORTED_VERSION)
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
