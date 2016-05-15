local info = KnownModIndex:LoadModInfo("workshop-399803164")

local function addsimpostinit(inst)
	AddRecipe("gandr", MODTUNING.RIN_GANDR_INGREDIENTS, MODTUNING.RIN_GANDR_RECIPETAB, MODTUNING.RIN_GANDR_TECH, nil, nil, nil, nil, "rin", "images/inventoryimages/gandr.xml", "gandr.tex")
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
	
	inst:AddTag("rin")
	
	inst:RemoveTag("bookbuilder")
	inst:RemoveTag("reader")
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
