local info = KnownModIndex:LoadModInfo("workshop-399803164")

local function addsimpostinit(inst)
	ModRecipe:ChangeRecipe("gandr", MODTUNING.RIN_GANDR_INGREDIENTS, MODTUNING.RIN_GANDR_RECIPETAB, MODTUNING.RIN_GANDR_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/gandr.xml", "gandr.tex")
	
	ModRecipe:ChangeRecipe("formredgem", MODTUNING.RIN_FORMREDGEM_INGREDIENTS, MODTUNING.RIN_FORMREDGEM_RECIPETAB, MODTUNING.RIN_FORMREDGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formredgem.xml", "formredgem.tex")
	ModRecipe:ChangeRecipe("formbluegem", MODTUNING.RIN_FORMBLUEGEM_INGREDIENTS, MODTUNING.RIN_FORMBLUEGEM_RECIPETAB, MODTUNING.RIN_FORMBLUEGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formbluegem.xml", "formbluegem.tex")
	ModRecipe:ChangeRecipe("formpurplegem", MODTUNING.RIN_FORMPURPLEGEM_INGREDIENTS, MODTUNING.RIN_FORMPURPLEGEM_RECIPETAB, MODTUNING.RIN_FORMPURPLEGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formpurplegem.xml", "formpurplegem.tex")
	ModRecipe:ChangeRecipe("formyellowgem", MODTUNING.RIN_FORMYELLOWGEM_INGREDIENTS, MODTUNING.RIN_FORMYELLOWGEM_RECIPETAB, MODTUNING.RIN_FORMYELLOWGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formyellowgem.xml", "formyellowgem.tex")
	ModRecipe:ChangeRecipe("formorangegem", MODTUNING.RIN_FORMORANGEGEM_INGREDIENTS, MODTUNING.RIN_FORMORANGEGEM_RECIPETAB, MODTUNING.RIN_FORMORANGEGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formorangegem.xml", "formorangegem.tex")
	ModRecipe:ChangeRecipe("formgreengem", MODTUNING.RIN_FORMGREENGEM_INGREDIENTS, MODTUNING.RIN_FORMGREENGEM_RECIPETAB, MODTUNING.RIN_FORMGREENGEM_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formgreengem.xml", "fromgreengem.tex")
	ModRecipe:ChangeRecipe("formthulecite", MODTUNING.RIN_FORMTHULECITE_INGREDIENTS, MODTUNING.RIN_FORMTHULECITE_RECIPETAB, MODTUNING.RIN_FORMTHULECITE_TECH, nil, nil, nil, 2, "rin", "images/inventoryimages/formthulecite.xml", "formthulecite.tex")
	
	STRINGS.RECIPE_DESC.GANDR = STRINGS.CHARACTERS.GENERIC.DESCRIBE.GANDR
end

local function balancerin(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local rinstats =	{
		health = MODTUNING.RIN_HEALTH,
		hunger = MODTUNING.RIN_HUNGER,
		sanity = MODTUNING.RIN_SANITY,
		
		absorb = MODTUNING.RIN_ABSORPTION,
		
		ignoresspoilage = MODTUNING.RIN_IGNORES_SPOILAGE,
		strongstomach = MODTUNING.RIN_STRONG_STOMACH,
		hungerkillrate = MODTUNING.RIN_HUNGER_KILL_RATE,
		hungerrate = MODTUNING.RIN_HUNGER_RATE,
		
		dapperness = MODTUNING.RIN_DAPPERNESS,
		dapperness_mult = MODTUNING.RIN_DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.RIN_NEG_AURA_MULT,
		night_drain_mult = MODTUNING.RIN_NIGHT_DRAIN_MULT,
		
		damage = MODTUNING.RIN_DAMAGE,
		
		walkspeed = MODTUNING.RIN_WALK_SPEED,
		runspeed = MODTUNING.RIN_RUN_SPEED,
		
		winterinsulation = MODTUNING.RIN_WINTER_INSULATION,
		summerinsulation = MODTUNING.RIN_SUMMER_INSULATION,
	}
	
	ModifyCharacter:ModifyStats(inst, rinstats)
	ModifyCharacter:ChangeStartingInventory(inst, MODTUNING.RIN_INVENTORY)
	
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
				attacker.components.sanity:DoDelta(MODTUNING.RIN_GANDR_PENALTY_SANITY_ONHIT_SELF)
			else
				attacker.components.sanity:DoDelta(MODTUNING.RIN_GANDR_PENALTY_SANITY_ONATTACK)
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
					inst.components.weapon:SetDamage(MODTUNING.RIN_GANDR_DAMAGE)
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
	inst.components.finiteuses:SetMaxUses(MODTUNING.RIN_GANDR_USES)
	inst.components.finiteuses:SetUses(MODTUNING.RIN_GANDR_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst.components.inventoryitem.keepondeath = false
	
	inst.components.equippable.dapperness = MODTUNING.RIN_GANDR_DAPPERNESS
	
	inst.components.weapon:SetDamage(MODTUNING.RIN_GANDR_DAMAGE)
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetOnProjectileLaunch(onprojectilelaunch)
	
	MakeHauntableLaunch(inst)
end

if GetModConfigData("RIN_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.RIN_SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.RIN_SUPPORTED_VERSION)
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
