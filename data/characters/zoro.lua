local MODTUNING = MODTUNING.ZORO
local info = KnownModIndex:LoadModInfo("workshop-409184357")
local minimapinfo = KnownModIndex:LoadModInfo("workshop-345692228")

local function addsimpostinit(inst)
end

local function balancezoro(inst)
	if not TheWorld.ismastersim then
		return inst
	end
end

local function deleteminimap(inst)
	inst.old_EnableMinimapUpdating = inst.EnableMinimapUpdating
	function inst:EnableMinimapUpdating()
		if inst.owner.prefab == "zoro" then return end
		inst:old_EnableMinimapUpdating()
	end
	
	return inst
end

AddSimPostInit(addsimpostinit)
AddPrefabPostInit("zoro", balancezoro)
if not minimapinfo.ignoreMCR2 and (KnownModIndex:IsModEnabled("workshop-345692228") or KnownModIndex:IsModTempEnabled("workshop-345692228")) then
	AddClassPostConstruct("widgets/minimapwidget", deleteminimap)
end
