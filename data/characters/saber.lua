package.path = package.path .. ";../mods/workshop-376244443/?.lua"
require "modinfo"
package.path = package.path .. ";../mods/workshop-376244443/scripts/prefabs/?.lua"
require "saber"


local function balancesaber(inst)
	local saberstats =	{
								health = MODTUNING.SABER_HEALTH,
								hunger = MODTUNING.SABER_HUNGER,
								sanity = MODTUNING.SABER_SANITY,
								damage = MODTUNING.SABER_DAMAGE,
								walkspeed = MODTUNING.SABER_WALK_SPEED,
								runspeed = MODTUNING.SABER_RUN_SPEED,
								winterinsulation = MODTUNING.SABER_WINTER_INSULATION,
								summerinsulation = MODTUNING.SABER_SUMMER_INSULATION,
								dapperness = MODTUNING.SABER_DAPPERNESS,
								dapperness_mult = MODTUNING.SABER_DAPPERNESS_MULT,
								night_drain_mult = MODTUNING.SABER_NIGHT_DRAIN_MULT,
								neg_aura_mult = MODTUNING.SABER_NEG_AURA_MULT,
								strongstomach = MODTUNING.SABER_STRONG_STOMACH,
								hungerrate = MODTUNING.SABER_HUNGER_RATE,
								hungerhurtrate = MODTUNING.SABER_HUNGER_HURT_RATE,
							}
	
	ModifyCharacter:ModifyStats(inst, saberstats)
	
	inst:AddTag("saber")
end

local function balancekendostick(inst)
	AddRecipe("kendostick", {Ingredient("log", 1), Ingredient("twigs", 2)}, RECIPETABS.WAR, TECH.NONE, nil, nil, nil, nil, "saber", "images/inventoryimages/kendostick.xml", "kendostick.tex")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.weapon:SetDamage(MODTUNING.SABER_KENDOSTICK_DAMAGE)
	
	inst.components.weapon:SetOnAttack(function(inst, attacker, target)
		if math.random() <= MODTUNING.SABER_KENDOSTICK_SLIP_CHANCE then
			attacker.components.inventory:DropItem(inst, true, true)
			attacker.components.talker:Say("I should craft a better weapon")
		end
	end)
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MODTUNING.SABER_KENDOSTICK_USES)
	inst.components.finiteuses:SetUses(MODTUNING.SABER_KENDOSTICK_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	MakeHauntableLaunch(inst)
	
	return inst
end

if not ignoreMCR then
	if (version ~= MODTUNING.SABER_SUPPORTED_VERSION) then
		LogHelper:PrintWarn("Running unsupported version of " .. name .. " Version: " .. version .. " Supported Version: " .. MODTUNING.SABER_SUPPORTED_VERSION)
	end
	LogHelper:PrintInfo("Balancing " .. name ..  " by " .. author .. " Version: " .. version)
	AddPrefabPostInit("saber", balancesaber)
	AddPrefabPostInit("kendostick", balancekendostick)
else
	LogHelper:PrintInfo("Balancing " .. name .. " disabled by " .. author)
end
