local CookUnlocker = Class(function(self, inst)
	self.inst = inst

    self._firepit_experience = net_shortint(inst.GUID, "cookunlocker._firepit_experience", "firepitexpdirty")
    self._cookpot_experience = net_shortint(inst.GUID, "cookunlocker._cookpot_experience", "cookpotexpdirty")
    self._mastercook_experience = net_shortint(inst.GUID, "cookunlocker._mastercook_experience", "mastercookexpdirty")

end)

return CookUnlocker