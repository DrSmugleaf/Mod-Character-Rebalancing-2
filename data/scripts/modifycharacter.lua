ModifyCharacter = Class(function(self, inst)
	self.inst = inst
end)

function ModifyCharacter:ModifyStats(inst, stats)
	if not TheWorld.ismastersim then 
		return inst
	end
	
	-- Health
	inst.components.health:SetMaxHealth(stats.HEALTH or inst.components.health.maxhealth)
	inst.components.health:SetAbsorptionAmount(stats.ABSORB or inst.components.health.absorb)
	inst.components.health:SetAbsorptionAmountFromPlayer(stats.PLAYER_ABSORB or inst.components.health.playerabsorb)
	inst.components.health.fire_damage_scale = stats.FIRE_HURT_RATE or inst.components.health.fire_damage_scale
	
	-- Hunger and Eater
	inst.components.hunger:SetMax(stats.HUNGER or inst.components.hunger.max)
	inst.components.eater:SetDiet(stats.CAN_EAT or inst.components.eater.caneat, stats.PREFERS_EATING or inst.components.eater.preferseating)
	inst.components.eater.ignoresspoilage = stats.IGNORES_SPOILAGE or inst.components.eater.ignoresspoilage
	inst.components.hunger:SetKillRate(stats.HUNGER_HURT_RATE or inst.components.hunger.hurtrate)
	inst.components.hunger:SetRate(stats.HUNGER_RATE and TUNING.WILSON_HUNGER_RATE * stats.HUNGER_RATE or inst.components.hunger.hungerrate)
	inst.components.eater.strongstomach = stats.STRONG_STOMACH or inst.components.eater.strongstomach
	
	-- Sanity
	inst.components.sanity:SetMax(stats.SANITY or inst.components.sanity.max)
	inst.components.sanity.dapperness_mult = stats.DAPPERNESS_MULT or inst.components.sanity.dapperness_mult
	inst.components.sanity.dapperness = stats.DAPPERNESS or inst.components.sanity.dapperness
	inst.components.sanity.ghost_drain_mult = stats.GHOST_DRAIN_MULT or inst.components.sanity.ghost_drain_mult
	inst.components.sanity.neg_aura_mult = stats.NEG_AURA_MULT or inst.components.sanity.neg_aura_mult
	inst.components.sanity.night_drain_mult = stats.NIGHT_DRAIN_MULT or inst.components.sanity.night_drain_mult
	
	-- Combat
	inst.components.combat.damagemultiplier = stats.DAMAGE or inst.components.combat.damagemultiplier
	inst.components.combat:SetAreaDamage(stats.AREA_HIT_RANGE or inst.components.combat.areahitrange, stats.AREA_HIT_DAMAGE_PERCENT or inst.components.combat.areahitdamagepercent)
	inst.components.combat:SetRange(stats.ATTACK_RANGE or inst.components.combat.attackrange, stats.HIT_RANGE or inst.components.combat.hitrange)
	inst.components.combat:SetDefaultDamage(stats.DEFAULT_DAMAGE or inst.components.combat.defaultdamage)
	
	-- Locomotor
	inst.components.locomotor.walkspeed = stats.WALK_SPEED and TUNING.WILSON_WALK_SPEED * stats.WALK_SPEED or inst.components.locomotor.walkspeed
	inst.components.locomotor.runspeed = stats.RUN_SPEED and TUNING.WILSON_RUN_SPEED * stats.RUN_SPEED or inst.components.locomotor.runspeed
	
	-- Temperature
	inst.components.temperature.maxtemp = stats.MAX_TEMP or inst.components.temperature.maxtemp
	inst.components.temperature.mintemp = stats.MIN_TEMP or inst.components.temperature.mintemp
	inst.components.temperature.overheattemp = stats.OVERHEAT_TEMP or inst.components.temperature.overheattemp
	inst.components.temperature.inherentinsulation = stats.WINTER_INSULATION or inst.components.temperature.inherentinsulation
	inst.components.temperature.hurtrate = stats.TEMPERATURE_HURT_RATE or inst.components.temperature.hurtrate
	inst.components.temperature.inherentsummerinsulation = stats.SUMMER_INSULATION or inst.components.temperature.inherentsummerinsulation
end

function ModifyCharacter:ModifyStatsWithLeveling(inst, stats)
	local function applyupgrades(inst)
		local max_upgrades = stats.max_upgrades or 15
		inst.level = math.min(inst.level, max_upgrades)
		
		local health_percent = inst.components.health:GetPercent()
		local hunger_percent = inst.components.hunger:GetPercent()
		local sanity_percent = inst.components.sanity:GetPercent()
		
		inst.components.health.maxhealth = math.ceil(stats.initialhealth + inst.level * (stats.finalhealth - stats.initialhealth) / max_upgrades)
		inst.components.hunger.max = math.ceil(stats.initialhunger + inst.level * (stats.finalhealth - stats.initialhealth) / max_upgrades)
		inst.components.sanity.max = math.ceil(stats.initialsanity + inst.level * (stats.finalsanity - stats.initialsanity) / max_upgrades)
		
		inst.components.health:SetPercent(health_percent)
		inst.components.hunger:SetPercent(hunger_percent)
		inst.components.sanity:SetPercent(sanity_percent)
	end
	
	local function oneat(inst, food)
		for foodprefab, levelperfood in pairs(stats.levelingfood) do
			if food and food.components.edible and food.prefab == foodprefab then
				inst.level = inst.level + levelperfood
				applyupgrades(inst)
				inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
			end
		end
	end
	
	local function onpreload(inst, data)
		if data ~= nil and data.level ~= nil then
			inst.level = data.level
			applyupgrades(inst)
			if data.health and data.health.health then inst.components.health:SetCurrentHealth(data.health.health) end
			if data.hunger and data.hunger.hunger then inst.components.hunger.current = data.hunger.hunger end
			if data.sanity and data.sanity.current then inst.components.sanity.current = data.sanity.current end
			inst.components.health:DoDelta(0)
			inst.components.hunger:DoDelta(0)
			inst.components.sanity:DoDelta(0)
		end
	end
	
	local function onsave(inst, data)
		data.level = inst.level
	end
	
	inst.level = 0
	inst.components.eater:SetOnEatFn(oneat)
	applyupgrades(inst)
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
end

function ModifyCharacter:ChangeStartingInventory(inst, start_inv)
	if inst.OnNewSpawn then
		inst.old_OnNewSpawn = inst.OnNewSpawn
	end
	
	inst.OnNewSpawn = function(inst)
		if old_OnNewSpawn ~= nil then old_OnNewSpawn() end
		
		if inst.components.inventory ~= nil then
			inst.components.inventory.ignoresound = true
			for i = 1, inst.components.inventory:GetNumSlots() do
				inst.components.inventory:RemoveItemBySlot(i)
			end
			for _, v in ipairs(start_inv) do
				inst.components.inventory:GiveItem(SpawnPrefab(v))
			end
			inst.components.inventory.ignoresound = false
		end
	end
end

return ModifyCharacter
