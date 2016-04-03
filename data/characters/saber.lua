package.path = package.path .. ";../mods/workshop-376244443/?.lua"
require "modinfo"
package.path = package.path .. ";../mods/workshop-376244443/scripts/prefabs/?.lua"
require "saber"

local function balancestats(inst)
	local characterstats =	{
							}

	ModifyCharacter:ModifyStats(inst, characterstats)
	
	inst:AddTag("saber")
end

local function balancesaberkendostick(inst)
	Recipe("kendostick", {Ingredient("log", 2), Ingredient("twigs", 1)}, RECIPETABS.WAR, TECH.NONE, nil, nil, nil, nil, "saber", "images/inventoryimages/kendostick.xml", "kendostick.tex")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.weapon:SetDamage(TUNING.SABER_KENDOSTICK_DAMAGE)
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.SABER_KENDOSTICK_USES)
	inst.components.finiteuses:SetUses(TUNING.SABER_KENDOSTICK_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	MakeHauntableLaunch(inst)
	
	return inst
end

if not ignoreMCR then
	AddPrefabPostInit("saber", balancesaberstats)
	AddPrefabPostInit("kendostick", balancesaberkendostick)
	LogHelper:PrintInfo("Balancing " .. name ..  " by " .. author .. " Version: " .. version)
else
	LogHelper:PrintInfo("Balancing Saber disabled by " .. author)
end
