package.path = package.path .. ";../mods/workshop-380079744/?.lua"
require "modinfo"
package.path = package.path .. ";../mods/workshop-380079744/scripts/prefabs/?.lua"
require "luffy"


local function addsimpostinit(inst)
	AddRecipe("luffyhat", MODTUNING.LUFFY_HAT_INGREDIENTS, RECIPETABS.DRESS, MODTUNING.LUFFY_HAT_TECH, nil, nil, nil, nil, "luffy", "images/inventoryimages/luffyhat.xml", "luffyhat.tex")
end

local function balanceluffy(inst)
	local luffystats =	{
								health = MODTUNING.LUFFY_HEALTH,
								hunger = MODTUNING.LUFFY_HUNGER,
								sanity = MODTUNING.LUFFY_SANITY,
								damage = MODTUNING.LUFFY_DAMAGE,
								walkspeed = MODTUNING.LUFFY_WALK_SPEED,
								runspeed = MODTUNING.LUFFY_RUN_SPEED,
								winterinsulation = MODTUNING.LUFFY_WINTER_INSULATION,
								summerinsulation = MODTUNING.LUFFY_SUMMER_INSULATION,
								dapperness = MODTUNING.LUFFY_DAPPERNESS,
								dapperness_mult = MODTUNING.LUFFY_DAPPERNESS_MULT,
								night_drain_mult = MODTUNING.LUFFY_NIGHT_DRAIN_MULT,
								neg_aura_mult = MODTUNING.LUFFY_NEG_AURA_MULT,
								strongstomach = MODTUNING.LUFFY_STRONG_STOMACH,
								hungerrate = MODTUNING.LUFFY_HUNGER_RATE,
								hungerkillrate = MODTUNING.LUFFY_HUNGER_KILL_RATE,
							}
	
	ModifyCharacter:ModifyStats(inst, luffystats)
	
	inst:AddTag("luffy")
	
	inst.components.combat:SetDefaultDamage(MODTUNING.LUFFY_DEFAULT_DAMAGE)
	
	local defaulteater = require("components/eater")
	function inst.components.eater:Eat(food)
		return defaulteater.Eat(self, food)
	end
	
	inst:SetStateGraph("SGluffy") -- Punch 3 times faster
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

if not ignoreMCR then
	if version ~= MODTUNING.LUFFY_SUPPORTED_VERSION then
		LogHelper:PrintWarn("Running unsupported version of " .. name .. " Version: " .. version .. " Supported version: " .. MODTUNING.LUFFY_SUPPORTED_VERSION)
	end
	LogHelper:PrintInfo("Balancing " .. name ..  " by " .. author .. " Version: " .. version)
	AddSimPostInit(addsimpostinit)
	AddPrefabPostInit("luffy", balanceluffy)
	AddPrefabPostInit("luffyhat", balanceluffyhat)
else
	LogHelper:PrintInfo("Balancing " .. name .. " disabled by " .. author)
end
