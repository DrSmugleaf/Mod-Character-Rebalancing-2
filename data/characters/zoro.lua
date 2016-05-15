local info = KnownModIndex:LoadModInfo("workshop-409184357")
local minimapinfo = KnownModIndex:LoadModInfo("workshop-345692228")

local function addsimpostinit(inst)
end

local function balancezoro(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	
	local zorostats =	{
		health = MODTUNING.ZORO_HEALTH,
		hunger = MODTUNING.ZORO_HUNGER,
		sanity = MODTUNING.ZORO_SANITY,
		
		absorb = MODTUNING.ZORO_ABSORPTION,
		
		ignoresspoilage = MODTUNING.ZORO_IGNORES_SPOILAGE,
		strongstomach = MODTUNING.ZORO_STRONG_STOMACH,
		hungerkillrate = MODTUNING.ZORO_HUNGER_KILL_RATE,
		hungerrate = MODTUNING.ZORO_HUNGER_RATE,
		
		dapperness = MODTUNING.ZORO_DAPPERNESS,
		dapperness_mult = MODTUNING.ZORO_DAPPERNESS_MULT,
		neg_aura_mult = MODTUNING.ZORO_NEG_AURA_MULT,
		night_drain_mult = MODTUNING.ZORO_NIGHT_DRAIN_MULT,
		
		damage = MODTUNING.ZORO_DAMAGE,
		
		walkspeed = MODTUNING.ZORO_WALK_SPEED,
		runspeed = MODTUNING.ZORO_RUN_SPEED,
		
		winterinsulation = MODTUNING.ZORO_WINTER_INSULATION,
		summerinsulation = MODTUNING.ZORO_SUMMER_INSULATION,
	}
	
	ModifyCharacter:ModifyStats(inst, zorostats)
end

local function deleteminimap(inst)
	inst.old_EnableMinimapUpdating = inst.EnableMinimapUpdating
	function inst:EnableMinimapUpdating()
		if inst.owner.prefab == "zoro" then return end
		inst:old_EnableMinimapUpdating()
	end
	
	return inst
end

if GetModConfigData("ZORO_BALANCED") then
	if not info.ignoreMCR then
		if info.version ~= MODTUNING.ZORO_SUPPORTED_VERSION then
			LogHelper:PrintWarn("Running unsupported version of " .. info.name .. " Version: " .. info.version .. " Supported version: " .. MODTUNING.ZORO_SUPPORTED_VERSION)
		end
		LogHelper:PrintInfo("Balancing " .. info.name ..  " by " .. info.author .. " Version: " .. info.version)
		AddSimPostInit(addsimpostinit)
		AddPrefabPostInit("zoro", balancezoro)
		if not minimapinfo.ignoreMCR and (KnownModIndex:IsModEnabled("workshop-345692228") or KnownModIndex:IsModTempEnabled("workshop-345692228")) then
			AddClassPostConstruct("widgets/minimapwidget", deleteminimap)
		end
	else
		LogHelper:PrintInfo("Balancing " .. info.name .. " Version: " .. info.version .. " disabled by " .. info.author)
	end
else
	LogHelper:PrintInfo("Balancing " .. info.name .. " by " .. info.author .. " Version: " .. info.version .. " disabled by server")
end
