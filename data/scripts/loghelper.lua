LogHelper = Class(function(self, inst)
	self.inst = inst
end)

function LogHelper:PrintDebug(message)
	print("[" .. MOD_NAME .. "] " .. "[DEBUG] " .. message)
end

function LogHelper:PrintError(message)
	print("[" .. MOD_NAME .. "] " .. "[ERROR] " .. message)
end

function LogHelper:PrintFatal(message)
	print("[" .. MOD_NAME .. "] " .. "[FATAL] " .. message)
end

function LogHelper:PrintInfo(message)
	print("[" .. MOD_NAME .. "] " .. "[INFO] " .. message)
end

function LogHelper:PrintWarn(message)
	print("[" .. MOD_NAME .. "] " .. "[WARN] " .. message)
end

function LogHelper:Announce(message)
	TheNet:Announce("[" .. MOD_NAME .. "] " .. message)
end

LogHelper:PrintInfo("Running Mod Character Rebalancing 2 Version: " .. MOD_VERSION)

return LogHelper
