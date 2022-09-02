
local CookUnlocker = Class(function(self, inst)
	self.inst = inst
	self.inst:AddTag("_cookunlocker")

    self.firepit_level = 0
    self.cookpot_level = 0
    self.spicer_level = 0

    self.firepit_experience = 0    --100升2级， 300升3级， 700升4级
    self.cookpot_experience = 0    --150升2级， 450升3级， 1050升4级
    self.mastercook_experience = 0  --2000升1级

    self.inst:ListenForEvent("timerdone", function (inst, data)
        if data.name == "firepit_level1_unlock" then
            self.firepit_level = 1
            inst:RemoveTag("initial_study")
            inst.components.talker:Say(STRINGS.RAIDEN_FIREPIT_LEVEL_UPGRADE[self.firepit_level])
            return
        elseif data.name == "cookpot_level1_unlock" then
            self.cookpot_level = 1
            inst:RemoveTag("initial_study")
            inst.components.talker:Say(STRINGS.RAIDEN_COOKPOT_LEVEL_UPGRADE[self.cookpot_level])
            return
        end

        if data.name ~= "startcookstudy" then
            return
        end

        inst.components.talker:Say(STRINGS.RAIDENCOOKBOOK_TIMEOVER)
        if inst:HasTag("firepit_study") then
            inst:RemoveTag("firepit_study")
        elseif inst:HasTag("cookpot_study") then
            inst:RemoveTag("cookpot_study")
        elseif inst:HasTag("spicer_study") then
            inst:RemoveTag("spicer_study")
        end
    end)

    self.inst:ListenForEvent("ms_playerreroll", function() 
        self:ReturnIngridents()
    end)
end)

--firepit_level 使用火烤的技能等级：
--    0级：不可以使用火烤
--    1级：可以烤，但有33%几率烤不熟（新鲜度降低15%），有33%几率烤糊（变成烤过的食物但是新鲜度降低33%）
--    2级：可以烤，但有25%几率烤不熟（新鲜度降低10%），有20%几率烤糊（变成烤过的食物但是新鲜度降低25%）
--    3级：可以烤，但有20%几率烤不熟（新鲜度降低5%），不会烤糊食物
--    4级：可以正常的烤制食物

--cookpot_level 使用锅的技能等级：
--    0级：不可以使用锅
--    1级：可以使用锅，但做菜有33%几率是“裁决之时”，且做饭时间增加100%，有5%概率发生爆炸（可以关闭）
--    2级：可以使用锅，但做菜有25%几率是“裁决之时”，且做饭时间增加50%
--    3级：可以使用锅，但做菜有20%几率是“裁决之时”，且做饭时间增加15%
--    4级：可以正常的使用锅

--spicer_level 使用调味盘的技能等级：
--    0级：不可以使用调味盘
--    1级：学习隔壁律者的力量学到精髓了（雾），可以使用调味盘，但是不能做研磨器；
--         也就是说只能使用“天云草实”制作的粉末调味
--         （这是一个会在spicer_level升级到1级时解锁的蓝图，粉末可以调出“酥酥麻麻的料理”，吃下后增加10%雷元素伤害的暴击率）

--升级机制，cookpot级别不高于firepit，都升到4级才能解锁spicer
--cookpot和firepit是0级的时候是摸书过1天后可以升到1级
--1级之后摸书之后进行相应的动作，增加相应炊具的熟悉度（调味盘则是烤和做菜）
--烤成功一次增加3点，做菜成功一次增加10点，升级对应的熟悉度
--只有在摸书期间有效，摸一次持续8分钟

function CookUnlocker:GetLevel(cooker_type)
    if cooker_type == 1 then
        return self.firepit_level
    elseif cooker_type == 2 then
        return self.cookpot_level
    elseif cooker_type == 3 then
        return self.spicer_level
    else
        return 0
    end
end

function CookUnlocker:CanUnlock(cooker_type, level)
    if self.inst:HasTag("firepit_study") or self.inst:HasTag("cookpot_study") or self.inst:HasTag("spicer_study") or self.inst:HasTag("initial_study") then
        return false, "is_studying"
    end

    if cooker_type == 1 then
        if self.firepit_level == 4 then
            return false, "max_level"
        elseif level > 4 or level < 1 then
            return false, "invalid_level"
        end
        return level == self.firepit_level + 1, "error_order"
    elseif cooker_type == 2 then
        if self.cookpot_level == 4 then
            return false, "max_level"
        elseif level > 4 or level < 1 then
            return false, "invalid_level"
        end
        return level == self.cookpot_level + 1 and level <= self.firepit_level, "error_order"
    elseif cooker_type == 3 then
        if level ~= 1 then
            return false, "invalid_level"
        elseif self.spicer_level == 1 then
            return false, "max_level"
        end
        return level == self.spicer_level + 1 and self.firepit_level == 4 and self.cookpot_level == 4, "error_order"
    end
end

function CookUnlocker:StartStudy(cooker_type)
    if cooker_type == 1 then
        self.inst:AddTag("firepit_study")
    elseif cooker_type == 2 then
        self.inst:AddTag("cookpot_study")
    elseif cooker_type == 3 then
        self.inst:AddTag("spicer_study")
    end

    self.inst.components.timer:StartTimer("startcookstudy", TUNING.RAIDEN_COOKBOOK_LEARNTIME)
end

function CookUnlocker:CheckLevel()
    local firepit_experience_table = { 100, 300, 700 }
    local cookpot_experience_table = { 150, 450, 1050 }
    local mastercook_experience_table = { 2000 }

    if self.firepit_level == 0 and self.firepit_experience > 0 then
        self.firepit_level = 1
        self.inst.components.talker:Say(STRINGS.RAIDEN_FIREPIT_LEVEL_UPGRADE[self.firepit_level], nil, true)
    end
    if self.firepit_level == 0 then
        return
    end

    while self.firepit_level <= 3 and self.firepit_experience >= firepit_experience_table[self.firepit_level] do
        self.firepit_level = self.firepit_level + 1
        self.inst.components.talker:Say(STRINGS.RAIDEN_FIREPIT_LEVEL_UPGRADE[self.firepit_level], nil, true)
    end

    if self.cookpot_level == 0 and self.cookpot_experience > 0 then
        self.cookpot_level = 1
        self.inst.components.talker:Say(STRINGS.RAIDEN_COOKPOT_LEVEL_UPGRADE[self.cookpot_level], nil, true)
    end
    if self.cookpot_level == 0 then
        return
    end

    while self.cookpot_level <= 3 and self.cookpot_experience >= cookpot_experience_table[self.cookpot_level]  do
        self.cookpot_level = self.cookpot_level + 1
        self.inst.components.talker:Say(STRINGS.RAIDEN_COOKPOT_LEVEL_UPGRADE[self.cookpot_level], nil, true)
    end

    if self.mastercook_experience >= mastercook_experience_table[1] and self.spicer_level == 0 then
        self.spicer_level = 1
        self.inst.components.talker:Say(STRINGS.RAIDEN_SPICER_LEVEL_UPGRADE[self.spicer_level], nil, true)
        self.inst.components.inventory:GiveItem(SpawnPrefab("spice_amakumo_blueprint"))
        self.inst:AddTag("masterchef")
    end
end

function CookUnlocker:CookSucceed(cooker_type)
    if self.inst:HasTag("firepit_study") then
        if cooker_type == 1 then
            self.firepit_experience = self.firepit_experience + TUNING.FIREPIT_EXPDELTA
        end
    end

    if self.inst:HasTag("cookpot_study") then
        if cooker_type == 2 then
            self.cookpot_experience = self.cookpot_experience + TUNING.COOKPOT_EXPDELTA
        end
    end

    if self.inst:HasTag("spicer_study") then
        if cooker_type == 1 then
            self.mastercook_experience = self.mastercook_experience + TUNING.FIREPIT_EXPDELTA
        elseif cooker_type == 2 then
            self.mastercook_experience = self.mastercook_experience + TUNING.COOKPOT_EXPDELTA
        end
    end

    self:CheckLevel()
end

function CookUnlocker:OnSave()
    return
    {
        firepit_level = self.firepit_level,
        cookpot_level = self.cookpot_level,
        spicer_level = self.spicer_level,

        firepit_experience = self.firepit_experience,
        cookpot_experience = self.cookpot_experience,
        mastercook_experience = self.mastercook_experience,

        tagtype = self.inst:HasTag("firepit_study") and 1 or (self.inst:HasTag("cookpot_study") and 2 or (self.inst:HasTag("spicer_study") and 3 or 0)),
        isinitial = self.inst:HasTag("initial_study")
    }
end

function CookUnlocker:OnLoad(data)
    if data == nil then
        return
    end

    self.firepit_level = data.firepit_level or 0
    self.cookpot_level = data.cookpot_level or 0
    self.spicer_level = data.spicer_level or 0
    self.firepit_experience = data.firepit_experience or 0
    self.cookpot_experience = data.cookpot_experience or 0
    self.mastercook_experience = data.mastercook_experience or 0

    if data.tagtype == nil then
        --
    elseif data.tagtype == 1 then
        self.inst:AddTag("firepit_study")
    elseif data.tagtype == 2 then
        self.inst:AddTag("cookpot_study")
    elseif data.tagtype == 3 then
        self.inst:AddTag("spicer_study")
    end

    if data.isinitial then
        self.inst:AddTag("initial_study")
    end

    if self.spicer_level == 1 then
        self.inst:AddTag("masterchef")
    end
end

function CookUnlocker:ReturnIngridents()
    local inst = self.inst
    local x, y, z = inst.Transform:GetWorldPosition()
    
    local inv = SpawnPrefab("book_giveexp")
    if inv ~= nil then
        inv.firepit_experience = self.firepit_experience
        inv.cookpot_experience = self.cookpot_experience
        inv.mastercook_experience = self.mastercook_experience
        if inv.Physics ~= nil then
            local speed = 2 + math.random()
            local angle = math.random() * 2 * PI
            inv.Physics:Teleport(x, y + 1, z)
            inv.Physics:SetVel(speed * math.cos(angle), speed * 3, speed * math.sin(angle))
        else
            inv.Transform:SetPosition(x, y, z)
        end
    end
end

function CookUnlocker:DebugUnlock(cookertype, level, customexp)
    local firepit_experience_table = { 100, 300, 700 }
    local cookpot_experience_table = { 150, 450, 1050 }

    level = level or 1
    if level == 0 or level > 4 then
        return
    end

    if cookertype == 1 then
        self.firepit_experience = level == 1 and 0 or firepit_experience_table[level - 1]
        if customexp ~= nil and customexp > self.firepit_experience then
            self.firepit_experience = customexp
        end
    elseif cookertype == 2 then
        self.cookpot_experience = level == 1 and 0 or cookpot_experience_table[level - 1]
        if level > self.firepit_level then
            self.firepit_experience = level == 1 and 0 or firepit_experience_table[level - 1]
        end
        if customexp ~= nil and customexp > self.cookpot_experience then
            self.cookpot_experience = customexp
        end
    elseif cookertype == 3 then
        self.firepit_experience = 700
        self.cookpot_experience = 1050
        self.mastercook_experience = 2000
        if customexp ~= nil and customexp > self.mastercook_experience then
            self.mastercook_experience = customexp
        end
    end

    self:CheckLevel()
end

return CookUnlocker