local MODTUNING = MODTUNING.TAMAMO
local info = KnownModIndex:LoadModInfo("workshop-399799824")

local function addsimpostinit(inst)
end

local function balancetamamo(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local tamamostats =	{
		health = MODTUNING.HEALTH,
		hunger = MODTUNING.HUNGER,
		sanity = MODTUNING.SANITY,
		
		absorb = MODTUNING.ABSORB,
		playerabsorb = MODTUNING.PLAYER_ABSORB,
		
		ignoresspoilage = MODTUNING.IGNORES_SPOILAGE,
		strongstomach = MODTUNING.STRONG_STOMACH,
		hungerhurtrate = MODTUNING.HUNGER_HURT_RATE,
		hungerrate = MODTUNING.HUNGER_RATE,
		
		dapperness = MODTUNING.DAPPERNESS,
		dapperness_mult = MODTUNING.DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.NEG_AURA_MULT,
		night_drain_mult = MODTUNING.NIGHT_DRAIN_MULT,
		
		damage = MODTUNING.DAMAGE,
		
		walkspeed = MODTUNING.WALK_SPEED,
		runspeed = MODTUNING.RUN_SPEED,
		
		maxtemp = MODTUNING.MAX_TEMP,
		mintemp = MODTUNING.MIN_TEMP,
		overheattemp = MODTUNING.OVERHEAT_TEMP,
		temperaturehurtrate = MODTUNING.TEMPERATURE_HURT_RATE,
		winterinsulation = MODTUNING.WINTER_INSULATION,
		summerinsulation = MODTUNING.SUMMER_INSULATION,
	}
	
	ModifyCharacter:ModifyStats(inst, tamamostats)
	
	RemoveEvent:RemoveListener(inst, "equip", "tamamo")
	
	local defaulteater = require("components/eater")
	function inst.components.eater:Eat(food)
		return defaulteater.Eat(self, food)
	end
	
	local function IsChestArmor(item)
		if item.components.armor and item.components.equippable.equipslot == EQUIPSLOTS.BODY then
			return true
		else
			return false
		end
	end
	
	local old_Equip = inst.components.inventory.Equip
	inst.components.inventory.Equip = function(self, item, old_to_active)
		if IsChestArmor(item) then
			self.inst.components.talker:Say("I'm already wearing something")
			return false
		end
		if old_Equip ~= nil then
			old_Equip(self, item, old_to_active)
		end
	end
end

if GetModConfigData("TAMAMO_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.SUPPORTED_VERSION)
		end
		LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
		AddSimPostInit(addsimpostinit)
		AddPrefabPostInit("tamamo", balancetamamo)
	else
		LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
	end
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
end
