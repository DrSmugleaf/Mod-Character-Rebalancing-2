local info = KnownModIndex:LoadModInfo("workshop-380079744")


local function addsimpostinit(inst)
	AddRecipe("luffyhat", MODTUNING.LUFFY_HAT_INGREDIENTS, RECIPETABS.DRESS, MODTUNING.LUFFY_HAT_TECH, nil, nil, nil, nil, "luffy", "images/inventoryimages/luffyhat.xml", "luffyhat.tex")
end

local function balanceluffy(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local luffystats =	{
		health = MODTUNING.LUFFY_HEALTH,
		hunger = MODTUNING.LUFFY_HUNGER,
		sanity = MODTUNING.LUFFY_SANITY,
		
		absorb = MODTUNING.LUFFY_ABSORPTION,
		
		ignoresspoilage = MODTUNING.LUFFY_IGNORES_SPOILAGE,
		strongstomach = MODTUNING.LUFFY_STRONG_STOMACH,
		hungerkillrate = MODTUNING.LUFFY_HUNGER_KILL_RATE,
		hungerrate = MODTUNING.LUFFY_HUNGER_RATE,
		
		dapperness = MODTUNING.LUFFY_DAPPERNESS,
		dapperness_mult = MODTUNING.LUFFY_DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.LUFFY_NEG_AURA_MULT,
		night_drain_mult = MODTUNING.LUFFY_NIGHT_DRAIN_MULT,
		
		damage = MODTUNING.LUFFY_DAMAGE,
		
		walkspeed = MODTUNING.LUFFY_WALK_SPEED,
		runspeed = MODTUNING.LUFFY_RUN_SPEED,
		
		winterinsulation = MODTUNING.LUFFY_WINTER_INSULATION,
		summerinsulation = MODTUNING.LUFFY_SUMMER_INSULATION,
	}
	
	ModifyCharacter:ModifyStats(inst, luffystats)
	
	inst:AddTag("luffy")
	
	inst.components.combat:SetDefaultDamage(MODTUNING.LUFFY_DEFAULT_DAMAGE)
	if not inst.components.inventory:GetActiveItem() then
		inst.components.combat:SetAreaDamage(MODTUNING.LUFFY_UNARMED_AREA_HIT_RANGE, MODTUNING.LUFFY_UNARMED_AREA_HIT_DAMAGE)
	end
	inst:ListenForEvent("equip", function(inst, data)
		if data.eslot == EQUIPSLOTS.HANDS then
			inst.components.combat:SetAreaDamage(nil, nil)
		end
	end)
	inst:ListenForEvent("unequip", function(inst, data)
		if data.eslot == EQUIPSLOTS.HANDS then
			inst.components.combat:SetAreaDamage(MODTUNING.LUFFY_UNARMED_AREA_HIT_RANGE, MODTUNING.LUFFY_UNARMED_AREA_HIT_DAMAGE)
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
	inst.components.fueled:InitializeFuelLevel(MODTUNING.LUFFY_HAT_PERISHTIME)
	inst.components.fueled:SetDepletedFn(inst.Remove)
	
	inst.components.inventoryitem.keepondeath = false
end

if GetModConfigData("LUFFY_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.LUFFY_SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.LUFFY_SUPPORTED_VERSION)
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
