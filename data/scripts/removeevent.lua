local RemoveEvent = Class(function(self, inst)
	self.inst = inst
end)

function RemoveEvent:RemoveListener(inst, event, prefab)
	if inst.event_listening then
		for e, sources in pairs(inst.event_listening) do
			if e == event then
				for s, _ in pairs (sources) do
					if prefab == nil and s.event_listeners and s.event_listeners[e] then
						s.event_listeners[e][inst] = nil
					elseif s.prefab == prefab and s.event_listeners and s.event_listeners[e] then
						s.event_listeners[e][inst] = nil
					end
				end
			end
		end
	end
	
	if inst.event_listeners then
		for e, listeners in pairs(inst.event_listeners) do
			if e == event then
				for listener, _ in pairs(listeners) do
					if listener.event_listening and listener.event_listening[e] then
						listener.event_listening[e][inst] = nil
					end
				end
			end
		end
	end
end

function RemoveEvent:RemoveWatchWorldState(inst, event)
	if inst.worldstatewatching ~= nil then
		for var in pairs(inst.worldstatewatching) do
			if var == event then
				TheWorld.components.worldstate.RemoveWatcher(var, inst)
			end
		end
	end
end

return RemoveEvent
