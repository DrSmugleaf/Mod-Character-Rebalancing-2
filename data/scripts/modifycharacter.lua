local ModifyCharacter = Class(function(self, inst)
	self.inst = inst
end)

function ModifyCharacter:ModifyStats(inst, stats)
	inst.components.health:SetMaxHealth(stats.health or inst.components.health.currenthealth)
	inst.components.hunger:SetMax(stats.hunger or inst.components.hunger.current)
	inst.components.sanity:SetMax(stats.sanity or inst.components.sanity.current)
	
	inst.components.combat.damagemultiplier = stats.damage or inst.components.combat.damagemultiplier
	
	inst.components.temperature.inherentinsulation = stats.winterinsulation or inst.components.temperature.inherentinsulation
	inst.components.temperature.inherentsummerinsulation = stats.summerinsulation or inst.components.temperature.summerinsulation
	
	inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * stats.walkspeed or inst.components.locomotor.walkspeed
	inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * stats.runspeed or inst.components.locomotor.runspeed
	
	inst.components.sanity.dapperness = stats.dapperness or inst.components.sanity.dapperness
	inst.components.sanity.dapperness_mult = stats.dapperness_mult or inst.components.sanity.dapperness_mult
	inst.components.sanity.night_drain_mult = stats.night_drain_mult or inst.components.sanity.night_drain_mult
	inst.components.sanity.neg_aura_mult = stats.neg_aura_mult or inst.components.sanity.neg_aura_mult
	
	inst.components.eater.strongstomach = stats.strongstomach or inst.components.eater.strongstomach
	inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * hungerrate or inst.components.hunger.hungerrate)
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

return ModifyCharacter
