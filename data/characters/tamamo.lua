local info = KnownModIndex:LoadModInfo("workshop-399799824")


local function addsimpostinit(inst)
	if not TheWorld.ismastersim then
		return inst
	end
end

local function balancetamamo(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local tamamostats =	{
							health = MODTUNING.TAMAMO_HEALTH,
							hunger = MODTUNING.TAMAMO_HUNGER,
							sanity = MODTUNING.TAMAMO_SANITY,
							damage = MODTUNING.TAMAMO_DAMAGE,
							walkspeed = MODTUNING.TAMAMO_WALK_SPEED,
							runspeed = MODTUNING.TAMAMO_RUN_SPEED,
							winterinsulation = MODTUNING.TAMAMO_WINTER_INSULATION,
							summerinsulation = MODTUNING.TAMAMO_SUMMER_INSULATION,
							dapperness = MODTUNING.TAMAMO_DAPPERNESS,
							dapperness_mult = MODTUNING.TAMAMO_DAPPERNESS_MULT,
							night_drain_mult = MODTUNING.TAMAMO_NIGHT_DRAIN_MULT,
							neg_aura_mult = MODTUNING.TAMAMO_NEG_AURA_MULT,
							strongstomach = MODTUNING.TAMAMO_STRONG_STOMACH,
							hungerrate = MODTUNING.TAMAMO_HUNGER_RATE,
							hungerkillrate = MODTUNING.TAMAMO_HUNGER_KILL_RATE,
						}
	
	ModifyCharacter:ModifyStats(inst, tamamostats)
	
	RemoveEvent:RemoveListener(inst, "equip", "tamamo")
	
	inst.components.eater.ignorespoilage = false
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
		return old_Equip(self, item, old_to_active)
	end
end

if not ignoreMCR then
	if info.version ~= MODTUNING.TAMAMO_SUPPORTED_VERSION then
		LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.TAMAMO_SUPPORTED_VERSION)
	end
	LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
	AddSimPostInit(addsimpostinit)
	AddPrefabPostInit("tamamo", balancetamamo)
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " disabled by " .. info.author)
end
