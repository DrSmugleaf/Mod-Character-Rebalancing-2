local info = KnownModIndex:LoadModInfo("workshop-376244443")


local function addsimpostinit(inst)
	AddRecipe("kendostick", MODTUNING.SABER_KENDOSTICK_INGREDIENTS, MODTUNING.SABER_KENDOSTICK_RECIPETAB, MODTUNING.SABER_KENDOSTICK_TECH, nil, nil, nil, nil, "saber", "images/inventoryimages/kendostick.xml", "kendostick.tex")
end

local function balancesaber(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local saberstats =	{
		health = MODTUNING.SABER_HEALTH,
		hunger = MODTUNING.SABER_HUNGER,
		sanity = MODTUNING.SABER_SANITY,
		
		absorb = MODTUNING.SABER_ABSORPTION,
		
		ignoresspoilage = MODTUNING.SABER_IGNORES_SPOILAGE,
		strongstomach = MODTUNING.SABER_STRONG_STOMACH,
		hungerkillrate = MODTUNING.SABER_HUNGER_KILL_RATE,
		hungerrate = MODTUNING.SABER_HUNGER_RATE,
		
		dapperness = MODTUNING.SABER_DAPPERNESS,
		dapperness_mult = MODTUNING.SABER_DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.SABER_NEG_AURA_MULT,
		night_drain_mult = MODTUNING.SABER_NIGHT_DRAIN_MULT,
		
		damage = MODTUNING.SABER_DAMAGE,
		
		walkspeed = MODTUNING.SABER_WALK_SPEED,
		runspeed = MODTUNING.SABER_RUN_SPEED,
		
		winterinsulation = MODTUNING.SABER_WINTER_INSULATION,
		summerinsulation = MODTUNING.SABER_SUMMER_INSULATION,
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
			local dmg = MODTUNING.SABER_KENDOSTICK_DAMAGE * (1 - inst.components.finiteuses:GetPercent())
			dmg = Remap(dmg, 0, MODTUNING.SABER_KENDOSTICK_DAMAGE, MODTUNING.SABER_KENDOSTICK_DAMAGE, MODTUNING.SABER_KENDOSTICK_DAMAGE * MODTUNING.SABER_KENDOSTICK_DAMAGE_MODIFIER)
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
	inst.components.finiteuses:SetMaxUses(MODTUNING.SABER_KENDOSTICK_USES)
	inst.components.finiteuses:SetUses(MODTUNING.SABER_KENDOSTICK_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	MakeHauntableLaunch(inst)
end

if GetModConfigData("SABER_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.SABER_SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported Version: " .. MODTUNING.SABER_SUPPORTED_VERSION)
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
