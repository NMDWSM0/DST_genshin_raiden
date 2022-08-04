
AddComponentPostInit("regrowthmanager", function (self)
    self:SetRegrowthForType("amakumo_grass", TUNING.AMAKUMOGRASS_REGROWTH_TIME, "amakumo_grass", function()
        return TUNING.AMAKUMOGRASS_REGROWTH_TIME_MULT
    end)
end)
