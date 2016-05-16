MODTUNING = {}


function ModTune(overrides)
	if overrides == nil then
		overrides = {}
	end
	
	local seg_time = 30
	local total_day_time = seg_time*16
	
	local day_segs = 10
	local dusk_segs = 4
	local night_segs = 2
	
	--default day composition. changes in winter, etc
	local day_time = seg_time * day_segs
	local dusk_time = seg_time * dusk_segs
	local night_time = seg_time * night_segs
	
	local multiplayer_attack_modifier = 1
	local multiplayer_goldentool_modifier = 1
	local multiplayer_armor_durability_modifier = 0.7
	local multiplayer_armor_absorption_modifier = 1
	local multiplayer_wildlife_respawn_modifier = 1

	local wilson_attack = 34 * multiplayer_attack_modifier
	local wilson_health = 150
	local calories_per_day = 75
	
	local wilson_attack_period = .1
	-----------------------
	
	local perish_warp = 1--/200
	
	local craziness_small = -100/(day_time*2)
	local craziness_med = -100/(day_time)
	local craziness_medlarge = -100/(day_time/1.5)
	local craziness_large = -100/(day_time/2)
	local craziness_huge = -100/(day_time/4)
	
	MODTUNING =
	{
		CRAZINESS_SMALL = craziness_small,
		CRAZINESS_MED = craziness_med,
		CRAZINESS_MEDLARGE = craziness_medlarge,
		CRAZINESS_LARGE = craziness_large,
		CRAZINESS_HUGE = craziness_huge,
		
		ABIGAIL =
		{
			SUPPORTED_VERSION = "1.2.1",
			HEALTH = 150,
			HUNGER = 100,
			SANITY = 150,
			ABSORB = 0,
			PLAYER_ABSORB = 0,
			IGNORES_SPOILAGE = false,
			STRONG_STOMACH = false,
			HUNGER_KILL_RATE = 1,
			HUNGER_RATE = 1,
			DAPPERNESS = 0,
			DAPPERNESS_MULT = 1,
			NEG_AURA_MULT = 1.25,
			NIGHT_DRAIN_MULT = 1.25,
			DAMAGE = 1,
			WALK_SPEED = 1,
			RUN_SPEED = 1,
			WINTER_INSULATION = 0,
			SUMMER_INSULATION = 0,
			INVENTORY = {"pumpkin_seeds", "pumpkin_seeds", "pumpkin_seeds"},
			QUARTZBAR_INGREDIENTS = {Ingredient("sdquartz", 10)},
			QUARTZBAR_RECIPETAB = sdabigailtab,
			QUARTZBAR_TECH = TECH.MAGIC_THREE,
			IRIDIUMBAR_INGREDIENTS = {Ingredient("sdiridium", 5)},
			IRIDIUMBAR_RECIPETAB = sdabigailtab,
			IRIDIUMBAR_TECH = TECH.MAGIC_THREE,
			GALAXYSWORD_INGREDIENTS = {Ingredient("sdquartzbar", 5), Ingredient("sdiridiumbar", 5), Ingredient("purplegem", 1)},
			GALAXYSWORD_RECIPETAB = sdabigailtab,
			GALAXYSWORD_TECH = TECH.MAGIC_THREE,
			GALAXYSWORD_PENALTY_SANITY_ONEQUIP = -5,
			GALAXYSWORD_PENALTY_SANITY_ONUNEQUIP = -5,
			GALAXYSWORD_PENALTY_SANITY_ONATTACK = -2,
			GALAXYSWORD_USES = 100,
			GALAXYSWORD_DAMAGE = 78,
			GALAXYSWORD_DAPPERNESS = craziness_medlarge,
			GALAXYSWORD_SPEED_MULT = TUNING.CANE_SPEED_MULT,
			PANFLUTE_INGREDIENTS = {Ingredient("cutreeds", 5), Ingredient("nightmarefuel", 2), Ingredient("boneshard", 1)},
			PANFLUTE_RECIPETAB = sdabigailtab,
			PANFLUTE_TECH = TECH.MAGIC_THREE,
			PANFLUTE_USES = 5,
			QUARTZ_HEALTHVALUE = -5,
			QUARTZ_HUNGERVALUE = 5,
			QUARTZ_SANITYVALUE = 5,
		},
		
		ACE_SUPPORTED_VERSION = "1.1.16",
		ACE_HEALTH = 150,
		ACE_HUNGER = 150,
		ACE_SANITY = 100,
		ACE_DAMAGE = 1,
		ACE_MIN_TEMP = TUNING.MIN_ENTITY_TEMP,
		ACE_FIRE_INGREDIENTS = {Ingredient("nightmarefuel", 1), Ingredient("redgem", 1)},
		ACE_FIRE_RECIPETAB = RECIPETABS.MAGIC,
		ACE_FIRE_TECH = TECH.MAGIC_THREE,
		ACE_FIRE_PENALTY_SANITY_ONATTACK = -2,
		ACE_FIRE_DAMAGE = 20,
		ACE_FIRE_USES = 15,
		ACE_HAT_INGREDIENTS = {Ingredient("cutgrass", 12), Ingredient("rope", 1)},
		ACE_HAT_RECIPETAB = RECIPETABS.DRESS,
		ACE_HAT_TECH = TECH.SCIENCE_ONE,
		ACE_HAT_PERISHTIME = total_day_time * 5,
		
		LUFFY_SUPPORTED_VERSION = "1.2.1",
		LUFFY_DEFAULT_DAMAGE = 50,
		LUFFY_UNARMED_AREA_HIT_RANGE = 2.5,
		LUFFY_UNARMED_AREA_HIT_DAMAGE = 0.75,
		LUFFY_HAT_INGREDIENTS = {Ingredient("cutgrass", 12), Ingredient("rope", 1)},
		LUFFY_HAT_RECIPETAB = RECIPETABS.DRESS,
		LUFFY_HAT_TECH = TECH.SCIENCE_ONE,
		LUFFY_HAT_PERISHTIME = total_day_time * 5,
		
		RIN_SUPPORTED_VERSION = "1.3.5",
		RIN_HEALTH = 125,
		RIN_HUNGER = 125,
		RIN_SANITY = 250,
		RIN_INVENTORY = {},
		RIN_GANDR_INGREDIENTS = {Ingredient("orangegem", 1), Ingredient("yellowgem", 1), Ingredient("greengem", 1)},
		RIN_GANDR_RECIPETAB = RECIPETABS.MAGIC,
		RIN_GANDR_TECH = TECH.MAGIC_THREE,
		RIN_GANDR_USES = 30,
		RIN_GANDR_DAMAGE = 100,
		RIN_GANDR_DAPPERNESS = craziness_med,
		RIN_GANDR_PENALTY_SANITY_ONATTACK = -5,
		RIN_GANDR_PENALTY_SANITY_ONHIT_SELF = -15,
		RIN_FORMREDGEM_INGREDIENTS = {Ingredient("redgem", 1), Ingredient("charcoal", 2), Ingredient("nightmarefuel", 1)},
		RIN_FORMREDGEM_RECIPETAB = RECIPETABS.ANCIENT,
		RIN_FORMREDGEM_TECH = TECH.ANCIENT_TWO,
		RIN_FORMBLUEGEM_INGREDIENTS = {Ingredient("bluegem", 1), Ingredient("ice", 2), Ingredient("nightmarefuel", 1)},
		RIN_FORMBLUEGEM_RECIPETAB = RECIPETABS.ANCIENT,
		RIN_FORMBLUEGEM_TECH = TECH.ANCIENT_TWO,
		RIN_FORMPURPLEGEM_INGREDIENTS = {Ingredient("purplegem", 1), Ingredient("nightmarefuel", 2)},
		RIN_FORMPURPLEGEM_RECIPETAB = RECIPETABS.ANCIENT,
		RIN_FORMPURPLEGEM_TECH = TECH.ANCIENT_TWO,
		RIN_FORMYELLOWGEM_INGREDIENTS = {Ingredient("yellowgem", 1), Ingredient("fireflies", 4), Ingredient("nightmarefuel", 2)},
		RIN_FORMYELLOWGEM_RECIPETAB = RECIPETABS.ANCIENT,
		RIN_FORMYELLOWGEM_TECH = TECH.ANCIENT_TWO,
		RIN_FORMORANGEGEM_INGREDIENTS = {Ingredient("orangegem", 1), Ingredient("houndstooth", 4), Ingredient("nightmarefuel", 2)},
		RIN_FORMORANGEGEM_RECIPETAB = RECIPETABS.ANCIENT,
		RIN_FORMORANGEGEM_TECH = TECH.ANCIENT_TWO,
		RIN_FORMGREENGEM_INGREDIENTS = {Ingredient("greengem", 1), Ingredient("livinglog", 4), Ingredient("nightmarefuel", 2)},
		RIN_FORMGREENGEM_RECIPETAB = RECIPETABS.ANCIENT,
		RIN_FORMGREENGEM_TECH = TECH.ANCIENT_TWO,
		RIN_FORMTHULECITE_INGREDIENTS = {Ingredient("thulecite", 1), Ingredient("goldnugget", 2), Ingredient("nightmarefuel", 1)},
		RIN_FORMTHULECITE_RECIPETAB = RECIPETABS.ANCIENT,
		RIN_FORMTHULECITE_TECH = TECH.ANCIENT_TWO,
		
		SABER_SUPPORTED_VERSION = "1.2.4",
		SABER_HEALTH = 200,
		SABER_HUNGER = 150,
		SABER_SANITY = 125,
		SABER_DAMAGE = 1.25,
		SABER_WALK_SPEED = 1.1,
		SABER_RUN_SPEED = 1.1,
		SABER_NEG_AURA_MULT = 1.25,
		SABER_HUNGER_RATE = 1,
		SABER_HUNGER_HURT_RATE = 2,
		SABER_KENDOSTICK_INGREDIENTS = {Ingredient("log", 1), Ingredient("twigs", 2), Ingredient("cutgrass", 2)},
		SABER_KENDOSTICK_RECIPETAB = RECIPETABS.WAR,
		SABER_KENDOSTICK_TECH = TECH.NONE,
		SABER_KENDOSTICK_USES = 100,
		SABER_KENDOSTICK_DAMAGE = 34,
		SABER_KENDOSTICK_DAMAGE_MODIFIER = 1.5,
		
		SAKURA_SUPPORTED_VERSION = "1.3.9",
		SAKURA_IGNORES_SPOILAGE = false,
		SAKURA_SANITY_AURA_NOPVP = 0,
		SAKURA_SANITY_AURA_PVP = -TUNING.SANITYAURA_LARGE,
		SAKURA_DAMAGE_DAY = 0.75,
		SAKURA_DAMAGE_DUSK = 1,
		SAKURA_DAMAGE_NIGHT = 1.25,
		SAKURA_WALK_SPEED_DAY = 1,
		SAKURA_RUN_SPEED_DAY = 1,
		SAKURA_WALK_SPEED_DUSK = 1.125,
		SAKURA_RUN_SPEED_DUSK = 1.125,
		SAKURA_WALK_SPEED_NIGHT = 1.25,
		SAKURA_RUN_SPEED_NIGHT = 1.25,
		
		TAMAMO_SUPPORTED_VERSION = "1.3.5",
		TAMAMO_IGNORES_SPOILAGE = false,
		
		ZORO_SUPPORTED_VERSION = "1.1.19",
	}
end

ModTune()
