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
		
		SDABIGAIL =
		{
			MOD_NAME = "WORKSHOP-647062183",
			CHARACTER = "SDABIGAIL",
			SUPPORTED_VERSION = "1.2.1",
			
			HEALTH = 150,
			ABSORB = 0,
			PLAYER_ABSORB = 0,
			FIRE_HURT_RATE = 1,
			
			HUNGER = 100,
			CAN_EAT = { FOODGROUP.OMNI },
			IGNORES_SPOILAGE = false,
			HUNGER_HURT_RATE = 1,
			HUNGER_RATE = 1,
			PREFERS_EATING = { FOODGROUP.OMNI },
			STRONG_STOMACH = false,
			
			SANITY = 150,
			DAPPERNESS_MULT = 1,
			DAPPERNESS = 0,
			GHOST_DRAIN_MULT = 1,
			NEG_AURA_MULT = 1,
			NIGHT_DRAIN_MULT = 1,
			
			DAMAGE = 1,
			AREA_HIT_DAMAGE_PERCENT = nil,
			AREA_HIT_RANGE = nil,
			ATTACK_RANGE = 3,
			DEFAULT_DAMAGE = 0,
			HIT_RANGE = 3,
			
			WALK_SPEED = 1,
			RUN_SPEED = 1,
			
			MAX_TEMP = 90,
			MIN_TEMP = -20,
			OVERHEAT_TEMP = 70,
			SUMMER_INSULATION = 0,
			TEMPERATURE_HURT_RATE = 1,
			WINTER_INSULATION = 0,
			
			INVENTORY = {"pumpkin_seeds", "pumpkin_seeds", "pumpkin_seeds"},
			
			QUARTZBAR_INGREDIENTS = {Ingredient("sdquartz", 10, "images/inventoryimages/sdquartz.xml")},
			QUARTZBAR_RECIPETAB = sdabigailtab,
			QUARTZBAR_TECH = TECH.MAGIC_THREE,
			
			IRIDIUMBAR_INGREDIENTS = {Ingredient("sdiridium", 5, "images/inventoryimages/sdiridium.xml")},
			IRIDIUMBAR_RECIPETAB = sdabigailtab,
			IRIDIUMBAR_TECH = TECH.MAGIC_THREE,
			
			GALAXYSWORD =
			{
				ITEM = "GALAXYSWORD",
				COMPONENTS = {"finiteuses"},
				INGREDIENTS = {Ingredient("sdquartzbar", 5, "images/inventoryimages/sdquartzbar.xml"), Ingredient("sdiridiumbar", 5, "images/inventoryimages/sdiridiumbar.xml"), Ingredient("purplegem", 1)},
				RECIPETAB = sdabigailtab,
				TECH = TECH.MAGIC_THREE,
				PENALTY_SANITY_ONEQUIP = -5,
				PENALTY_SANITY_ONUNEQUIP = -5,
				PENALTY_SANITY_ONATTACK = -2,
				USES = 100,
				DAMAGE = 78,
				DAPPERNESS = craziness_medlarge,
				SPEED_MULT = TUNING.CANE_SPEED_MULT,
			},
			
			PANFLUTE_INGREDIENTS = {Ingredient("cutreeds", 5), Ingredient("nightmarefuel", 2), Ingredient("boneshard", 1)},
			PANFLUTE_RECIPETAB = sdabigailtab,
			PANFLUTE_TECH = TECH.MAGIC_THREE,
			PANFLUTE_USES = 5,
			
			QUARTZ_HEALTHVALUE = -5,
			QUARTZ_HUNGERVALUE = 5,
			QUARTZ_SANITYVALUE = 5,
		},
		
		ACE =
		{
			MOD_NAME = "WORKSHOP-388109833",
			CHARACTER = "ACE",
			SUPPORTED_VERSION = "1.1.16",
			HEALTH = 150,
			HUNGER = 150,
			SANITY = 100,
			DAMAGE = 1,
			MIN_TEMP = TUNING.MIN_ENTITY_TEMP,
			FIRE_INGREDIENTS = {Ingredient("nightmarefuel", 1), Ingredient("redgem", 1)},
			FIRE_RECIPETAB = RECIPETABS.MAGIC,
			FIRE_TECH = TECH.MAGIC_THREE,
			FIRE_PENALTY_SANITY_ONATTACK = -2,
			FIRE_DAMAGE = 20,
			FIRE_USES = 15,
			HAT_INGREDIENTS = {Ingredient("cutgrass", 12), Ingredient("rope", 1)},
			HAT_RECIPETAB = RECIPETABS.DRESS,
			HAT_TECH = TECH.SCIENCE_ONE,
			HAT_PERISHTIME = total_day_time * 5,
		},
		
		LUFFY =
		{
			MOD_NAME = "WORKSHOP-380079744",
			CHARACTER = "LUFFY",
			SUPPORTED_VERSION = "1.2.1",
			DEFAULT_DAMAGE = 50,
			UNARMED_AREA_HIT_RANGE = 2.5,
			UNARMED_AREA_HIT_DAMAGE = 0.75,
			HAT_INGREDIENTS = {Ingredient("cutgrass", 12), Ingredient("rope", 1)},
			HAT_RECIPETAB = RECIPETABS.DRESS,
			HAT_TECH = TECH.SCIENCE_ONE,
			HAT_PERISHTIME = total_day_time * 5,
		},
		
		RIN =
		{
			MOD_NAME = "WORKSHOP-399803164",
			CHARACTER = "RIN",
			SUPPORTED_VERSION = "1.3.5",
			HEALTH = 125,
			HUNGER = 125,
			SANITY = 250,
			INVENTORY = {},
			GANDR_INGREDIENTS = {Ingredient("orangegem", 1), Ingredient("yellowgem", 1), Ingredient("greengem", 1)},
			GANDR_RECIPETAB = RECIPETABS.MAGIC,
			GANDR_TECH = TECH.MAGIC_THREE,
			GANDR_USES = 30,
			GANDR_DAMAGE = 100,
			GANDR_DAPPERNESS = craziness_med,
			GANDR_PENALTY_SANITY_ONATTACK = -5,
			GANDR_PENALTY_SANITY_ONHIT_SELF = -15,
			FORMREDGEM_INGREDIENTS = {Ingredient("redgem", 1), Ingredient("charcoal", 2), Ingredient("nightmarefuel", 1)},
			FORMREDGEM_RECIPETAB = RECIPETABS.ANCIENT,
			FORMREDGEM_TECH = TECH.ANCIENT_TWO,
			FORMBLUEGEM_INGREDIENTS = {Ingredient("bluegem", 1), Ingredient("ice", 2), Ingredient("nightmarefuel", 1)},
			FORMBLUEGEM_RECIPETAB = RECIPETABS.ANCIENT,
			FORMBLUEGEM_TECH = TECH.ANCIENT_TWO,
			FORMPURPLEGEM_INGREDIENTS = {Ingredient("purplegem", 1), Ingredient("nightmarefuel", 2)},
			FORMPURPLEGEM_RECIPETAB = RECIPETABS.ANCIENT,
			FORMPURPLEGEM_TECH = TECH.ANCIENT_TWO,
			FORMYELLOWGEM_INGREDIENTS = {Ingredient("yellowgem", 1), Ingredient("fireflies", 4), Ingredient("nightmarefuel", 2)},
			FORMYELLOWGEM_RECIPETAB = RECIPETABS.ANCIENT,
			FORMYELLOWGEM_TECH = TECH.ANCIENT_TWO,
			FORMORANGEGEM_INGREDIENTS = {Ingredient("orangegem", 1), Ingredient("houndstooth", 4), Ingredient("nightmarefuel", 2)},
			FORMORANGEGEM_RECIPETAB = RECIPETABS.ANCIENT,
			FORMORANGEGEM_TECH = TECH.ANCIENT_TWO,
			FORMGREENGEM_INGREDIENTS = {Ingredient("greengem", 1), Ingredient("livinglog", 4), Ingredient("nightmarefuel", 2)},
			FORMGREENGEM_RECIPETAB = RECIPETABS.ANCIENT,
			FORMGREENGEM_TECH = TECH.ANCIENT_TWO,
			FORMTHULECITE_INGREDIENTS = {Ingredient("thulecite", 1), Ingredient("goldnugget", 2), Ingredient("nightmarefuel", 1)},
			FORMTHULECITE_RECIPETAB = RECIPETABS.ANCIENT,
			FORMTHULECITE_TECH = TECH.ANCIENT_TWO,
		},
		
		SABER =
		{
			MOD_NAME = "WORKSHOP-376244443",
			CHARACTER = "SABER",
			SUPPORTED_VERSION = "1.2.4",
			HEALTH = 200,
			HUNGER = 150,
			SANITY = 125,
			DAMAGE = 1.25,
			WALK_SPEED = 1.1,
			RUN_SPEED = 1.1,
			NEG_AURA_MULT = 1.25,
			HUNGER_RATE = 1,
			HUNGER_HURT_RATE = 2,
			KENDOSTICK_INGREDIENTS = {Ingredient("log", 1), Ingredient("twigs", 2), Ingredient("cutgrass", 2)},
			KENDOSTICK_RECIPETAB = RECIPETABS.WAR,
			KENDOSTICK_TECH = TECH.NONE,
			KENDOSTICK_USES = 100,
			KENDOSTICK_DAMAGE = 34,
			KENDOSTICK_DAMAGE_MODIFIER = 1.5,
		},
		
		SAKURA =
		{
			MOD_NAME = "WORKSHOP-384048428",
			CHARACTER = "SAKURA",
			SUPPORTED_VERSION = "1.3.9",
			IGNORES_SPOILAGE = false,
			SANITY_AURA_NOPVP = 0,
			SANITY_AURA_PVP = -TUNING.SANITYAURA_LARGE,
			DAMAGE_DAY = 0.75,
			DAMAGE_DUSK = 1,
			DAMAGE_NIGHT = 1.25,
			WALK_SPEED_DAY = 1,
			RUN_SPEED_DAY = 1,
			WALK_SPEED_DUSK = 1.125,
			RUN_SPEED_DUSK = 1.125,
			WALK_SPEED_NIGHT = 1.25,
			RUN_SPEED_NIGHT = 1.25,
		},
		
		TAMAMO =
		{
			MOD_NAME = "WORKSHOP-399799824",
			CHARACTER = "TAMAMO",
			SUPPORTED_VERSION = "1.3.5",
			IGNORES_SPOILAGE = false,
		},
		
		ZORO =
		{
			MOD_NAME = "WORKSHOP-409184357",
			CHARACTER = "ZORO",
			SUPPORTED_VERSION = "1.1.19",
		},
	}
end

ModTune()
