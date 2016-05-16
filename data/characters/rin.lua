local MODTUNING = MODTUNING.RIN
local info = KnownModIndex:LoadModInfo("workshop-399803164")

local function addsimpostinit(inst)
	ModRecipe:ChangeRecipe("gandr", MODTUNING.GANDR_INGREDIENTS, MODTUNING.GANDR_RECIPETAB, MODTUNING.GANDR_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/gandr.xml", "gandr.tex")
	
	ModRecipe:ChangeRecipe("formredgem", MODTUNING.FORMREDGEM_INGREDIENTS, MODTUNING.FORMREDGEM_RECIPETAB, MODTUNING.FORMREDGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formredgem.xml", "formredgem.tex")
	ModRecipe:ChangeRecipe("formbluegem", MODTUNING.FORMBLUEGEM_INGREDIENTS, MODTUNING.FORMBLUEGEM_RECIPETAB, MODTUNING.FORMBLUEGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formbluegem.xml", "formbluegem.tex")
	ModRecipe:ChangeRecipe("formpurplegem", MODTUNING.FORMPURPLEGEM_INGREDIENTS, MODTUNING.FORMPURPLEGEM_RECIPETAB, MODTUNING.FORMPURPLEGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formpurplegem.xml", "formpurplegem.tex")
	ModRecipe:ChangeRecipe("formyellowgem", MODTUNING.FORMYELLOWGEM_INGREDIENTS, MODTUNING.FORMYELLOWGEM_RECIPETAB, MODTUNING.FORMYELLOWGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formyellowgem.xml", "formyellowgem.tex")
	ModRecipe:ChangeRecipe("formorangegem", MODTUNING.FORMORANGEGEM_INGREDIENTS, MODTUNING.FORMORANGEGEM_RECIPETAB, MODTUNING.FORMORANGEGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formorangegem.xml", "formorangegem.tex")
	ModRecipe:ChangeRecipe("formgreengem", MODTUNING.FORMGREENGEM_INGREDIENTS, MODTUNING.FORMGREENGEM_RECIPETAB, MODTUNING.FORMGREENGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formgreengem.xml", "fromgreengem.tex")
	ModRecipe:ChangeRecipe("formthulecite", MODTUNING.FORMTHULECITE_INGREDIENTS, MODTUNING.FORMTHULECITE_RECIPETAB, MODTUNING.FORMTHULECITE_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formthulecite.xml", "formthulecite.tex")
	
	STRINGS.RECIPE_DESC.GANDR = STRINGS.CHARACTERS.GENERIC.DESCRIBE.GANDR
end

local function balancerin(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local rinstats =	{
		health = MODTUNING.HEALTH,
		hunger = MODTUNING.HUNGER,
		sanity = MODTUNING.SANITY,
		
		absorb = MODTUNING.ABSORB,
		playerabsorb = MODTUNING.PLAYER_ABSORB,
		
		ignoresspoilage = MODTUNING.IGNORES_SPOILAGE,
		strongstomach = MODTUNING.STRONG_STOMACH,
		hungerkillrate = MODTUNING.HUNGER_KILL_RATE,
		hungerrate = MODTUNING.HUNGER_RATE,
		
		dapperness = MODTUNING.DAPPERNESS,
		dapperness_mult = MODTUNING.DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.NEG_AURA_MULT,
		night_drain_mult = MODTUNING.NIGHT_DRAIN_MULT,
		
		damage = MODTUNING.DAMAGE,
		
		walkspeed = MODTUNING.WALK_SPEED,
		runspeed = MODTUNING.RUN_SPEED,
		
		winterinsulation = MODTUNING.WINTER_INSULATION,
		summerinsulation = MODTUNING.SUMMER_INSULATION,
	}
	
	ModifyCharacter:ModifyStats(inst, rinstats)
	ModifyCharacter:ChangeStartingInventory(inst, MODTUNING.INVENTORY)
	
	inst:RemoveTag("ancient_builder")
	inst:RemoveTag("bookbuilder")
	inst:RemoveTag("reader")
	inst:AddTag("rin")
end

local function balancegandr(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local function onattack(inst, attacker, target)
		if attacker and attacker.components.sanity then
			if attacker == target then
				attacker.components.sanity:DoDelta(MODTUNING.GANDR_PENALTY_SANITY_ONHIT_SELF)
			else
				attacker.components.sanity:DoDelta(MODTUNING.GANDR_PENALTY_SANITY_ONATTACK)
			end
		end
	end
	
	local function onprojectilelaunch(inst, attacker, target)
		for i = 0,1,0.1 do
			inst:DoTaskInTime(i, function(inst)
				if target == attacker or target.components.health:IsDead() then
					target = attacker
					inst.components.weapon:SetDamage(0)
				else
					inst.components.weapon:SetDamage(MODTUNING.GANDR_DAMAGE)
				end
				local proj = SpawnPrefab(inst.components.weapon.projectile)
				if proj then
					if proj.components.projectile then
						proj.Transform:SetPosition(attacker.Transform:GetWorldPosition())
						proj.components.projectile:Throw(inst.components.weapon.inst, target, attacker)
					elseif proj.components.complexprojectile then
						proj.Transform:SetPosition(attacker.Transform:GetWorldPosition())
						proj.components.complexprojectile:Launch(Vector3(target.transform:GetWorldPosition()), attacker, inst.components.weapon.inst)
					end
				end
			end)
		end
	end
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MODTUNING.GANDR_USES)
	inst.components.finiteuses:SetUses(MODTUNING.GANDR_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst.components.inventoryitem.keepondeath = false
	
	inst.components.equippable.dapperness = MODTUNING.GANDR_DAPPERNESS
	
	inst.components.weapon:SetDamage(MODTUNING.GANDR_DAMAGE)
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetOnProjectileLaunch(onprojectilelaunch)
	
	MakeHauntableLaunch(inst)
end

if GetModConfigData("RIN_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.SUPPORTED_VERSION)
		end
		LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
		AddSimPostInit(addsimpostinit)
		AddPrefabPostInit("rin", balancerin)
		AddPrefabPostInit("gandr", balancegandr)
	else
		LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
	end
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
end
