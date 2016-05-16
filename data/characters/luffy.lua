local MODTUNING = MODTUNING.LUFFY
local info = KnownModIndex:LoadModInfo("workshop-380079744")

local function addsimpostinit(inst)
	AddRecipe("luffyhat", MODTUNING.HAT_INGREDIENTS, MODTUNING.HAT_RECIPETAB, MODTUNING.HAT_TECH, nil, nil, nil, nil, "luffy", "images/inventoryimages/luffyhat.xml", "luffyhat.tex")
end

local function balanceluffy(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local luffystats =	{
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
	
	ModifyCharacter:ModifyStats(inst, luffystats)
	
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

if GetModConfigData("LUFFY_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.SUPPORTED_VERSION)
		end
		LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
		AddSimPostInit(addsimpostinit)
		AddPrefabPostInit("luffy", balanceluffy)
		AddPrefabPostInit("luffyhat", balanceluffyhat)
	else
		LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
	end
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
end
