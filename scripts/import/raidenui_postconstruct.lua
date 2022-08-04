local ElementalBurst_Badge = require "widgets/elementalburst_badge"
local ElementalSkill_Badge = require "widgets/elementalskill_badge"

--------------------------------------------------------------------------
--���Ӵ���UI

AddClassPostConstruct("widgets/controls",function(self)        
	if self.owner and self.owner:HasTag("raiden_shogun") then

	    self.elementalburst_badge = self:AddChild(ElementalBurst_Badge(self.owner, "eleburst_raiden", "eleburst_raiden", "anim", nil, TUNING.RAIDENSKILL_ELEBURST.CD, TUNING.ELEMENTALBURST_KEY))
        self.elementalburst_badge:SetPosition(1700, 100, 0)
        self.elementalburst_badge:SetScale(0.4)
        self.elementalburst_badge:SetOnClick(function()
            SendModRPCToServer(MOD_RPC["raiden_shogun"]["elementalburst"])
        end)

		self.elementalskill_badge = self:AddChild(ElementalSkill_Badge(self.owner, "images/ui/eleskill_raiden.xml", "eleskill_raiden.tex", TUNING.RAIDENSKILL_ELESKILL.CD, TUNING.ELEMENTALSKILL_KEY))
        self.elementalskill_badge:SetPosition(1600, 80, 0)
        self.elementalskill_badge:SetScale(0.3)
        self.elementalskill_badge:SetOnClick(function()
            SendModRPCToServer(MOD_RPC["raiden_shogun"]["elementalskill"])
        end)

	end
end)