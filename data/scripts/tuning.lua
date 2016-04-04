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
	
	MODTUNING =
	{
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
		SABER_KENDOSTICK_USES = 50,
		SABER_KENDOSTICK_DAMAGE = 30,
		SABER_KENDOSTICK_SLIP_CHANCE = 0.1,
	}
end

ModTune()
