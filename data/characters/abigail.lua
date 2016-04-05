package.path = package.path .. ";../mods/workshop-647062183/?.lua"
require "modinfo"
package.path = package.path .. ";../mods/workshop-647062183/scripts/prefabs/?.lua"
require "sdabigail"


local function balancestats(inst)
	local characterstats =	{
								health = MODTUNING.ABIGAIL_HEALTH,
								hunger = MODTUNING.ABIGAIL_HUNGER,
								damage = MODTUNING.ABIGAIL_DAMAGE,
								walkspeed = MODTUNING.ABIGAIL_WALK_SPEED,
								runspeed = MODTUNING.ABIGAIL_RUN_SPEED,
								winterinsulation = MODTUNING.ABIGAIL_WINTER_INSULATION,
								summerinsulation = MODTUNING.ABIGAIL_SUMMER_INSULATION,
								dapperness = MODTUNING.ABIGAIL_DAPPERNESS,
								dapperness_mult = MODTUNING.ABIGAIL_DAPPERNESS_MULT,
								night_drain_mult = MODTUNING.ABIGAIL_NIGHT_DRAIN_MULT,
								neg_aura_mult = MODTUNING.ABIGAIL_NEG_AURA_MULT,
								strongstomach = MODTUNING.ABIGAIL_STRONG_STOMACH,
								hungerrate = MODTUNING.ABIGAIL_HUNGER_RATE,
								hungerhurtrate = MODTUNING.ABIGAIL_HUNGER_HURT_RATE,
							}
	
	ModifyCharacter:ModifyStats(inst, characterstats)
end

local function balancegalaxysword(inst)
	
	AllRecipes["galaxysword"].level = TECH.MAGIC_THREE
	
	local function OnEquip(inst, owner)
	    owner.AnimState:OverrideSymbol("swap_object", "swap_galaxysword", "swap_galaxysword")
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
		if owner.components ~= nil and owner.components.sanity ~= nil then
			owner.components.sanity:DoDelta(MODTUNING.ABIGAIL_GALAXYSWORD_PENALTY_SANITY_ONEQUIP)
		end
	end
	
	local function OnUnequip(inst, owner)
	    owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
		if owner.components ~= nil and owner.components.sanity ~= nil then
			owner.components.sanity:DoDelta(MODTUNING.ABIGAIL_GALAXYSWORD_PENALTY_SANITY_ONUNEQUIP)
		end
	end

	
	local function onattack(weapon, attacker, target)
		local atkfx = SpawnPrefab("explode_small")
		if atkfx then
			local follower = atkfx.entity:AddFollower()
			follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0 )
		end
		
		if attacker.components ~= nil and attacker.components.sanity ~= nil then
			attacker.components.sanity:DoDelta(MODTUNING.ABIGAIL_GALAXYSWORD_PENALTY_SANITY_ONATTACK)
		end
	end
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.weapon:SetDamage(MODTUNING.ABIGAIL_GALAXYSWORD_DAMAGE)
	inst.components.weapon:SetOnAttack(onattack)
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(MODTUNING.ABIGAIL_GALAXYSWORD_USES)
	inst.components.finiteuses:SetUses(MODTUNING.ABIGAIL_GALAXYSWORD_USES)
	inst.components.finiteuses:SetOnFinished(inst.remove)
	
	inst.components.inventoryitem.keepondeath = false
	
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.dapperness = MODTUNING.ABIGAIL_GALAXYSWORD_DAPPERNESS
	inst.components.equippable.walkspeedmult = MODTUNING.ABIGAIL_GALAXYSWORD_SPEED_MULT
	
	MakeHauntableLaunch(inst)
	
	return inst
end

if not ignoreMCR then
	if version ~= MODTUNING.ABIGAIL_SUPPORTED_VERSION then
		LogHelper:PrintWarn("Running unsupported version of " .. name .. " Version: " .. version .. " Supported version: " .. MODTUNING.ABIGAIL_SUPPORTED_VERSION)
	end
	LogHelper:PrintInfo("Balancing " .. name ..  " by " .. author .. " Version: " .. version)
	AddPrefabPostInit("sdabigail", balancestats)
	AddPrefabPostInit("galaxysword", balancegalaxysword)
else
	LogHelper:PrintInfo("Balancing " .. name .. " disabled by " .. author)
end
