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
	
	local saberstats =	{
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
	
	ModifyCharacter:ModifyStats(inst, saberstats)
	
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

if GetModConfigData("SABER_BALANCED") then
	if not info.ignoreMCR2 then
		if info.version ~= MODTUNING.SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported Version: " .. MODTUNING.SUPPORTED_VERSION)
		end
		LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
		AddSimPostInit(addsimpostinit)
		AddPrefabPostInit("saber", balancesaber)
		AddPrefabPostInit("kendostick", balancekendostick)
	else
		LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
	end
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
end
