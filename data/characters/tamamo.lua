local MODTUNING = MODTUNING.TAMAMO
local info = KnownModIndex:LoadModInfo("workshop-399799824")

local function addsimpostinit(inst)
end

local function balancetamamo(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
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

AddSimPostInit(addsimpostinit)
AddPrefabPostInit("tamamo", balancetamamo)
