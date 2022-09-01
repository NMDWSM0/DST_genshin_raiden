local old_COOK_fn = ACTIONS.COOK.fn
local upvaluehelper = require("import/upvaluehelper")

ACTIONS.COOK.fn = function(act)
    if act.target and act.target.components.cooker ~= nil or act.target.components.cookable ~= nil and act.invobject ~= nil and act.invobject.components.cooker ~= nil then
        if act.doer and act.doer.components.cookunlocker and act.doer.components.cookunlocker:GetLevel(1) == 0 then
            act.doer.components.talker:Say(GetActionFailString(act.doer, "COOK"))
            return false
        end
    elseif act.target and act.target.components.stewer ~= nil then
        if act.doer and act.doer.components.cookunlocker and act.doer.components.cookunlocker:GetLevel(2) == 0 then
            act.doer.components.talker:Say(GetActionFailString(act.doer, "COOK"))
            return false
        end
    end

    return old_COOK_fn(act)
end

AddComponentPostInit("cookable", function (self)
    local old_Cook = self.Cook

    function self:Cook(cooker, chef)
        local raw_rate = {0.25, 0.2, 0.15, 0}
        local raw_punish = {-0.15, -0.1, -0.05, 0}
        local burnt_rate = {0.25, 0.2, 0, 0}
        local burnt_punish = {-0.33, -0.2, 0, 0}

        local type = "normal"
        local level = 4
        if chef:HasTag("_cookunlocker") and chef.components.cookunlocker then
            level = chef.components.cookunlocker:GetLevel(1)
            local rand = math.random()
            if rand < raw_rate[level] then
                type = "raw"
                chef.components.talker:Say(STRINGS.RAIDEN_COOK_RAW, nil, true)
            elseif rand < raw_rate[level] + burnt_rate[level] then
                type = "burnt"
                chef.components.talker:Say(STRINGS.RAIDEN_COOK_BURNT, nil, true)
            else
                chef.components.cookunlocker:CookSucceed(1)
            end
        else
            return old_Cook(self, cooker, chef)
        end

        if type == "raw" then
            local prod = SpawnPrefab(self.inst.prefab)
            if self.inst.components.perishable ~= nil then
                local old_percent = self.inst.components.perishable:GetPercent()
                local new_percent = old_percent * (1 + raw_punish[level])
                prod.components.perishable:SetPercent(new_percent)
            end
            return prod
        end
        
        --可以烤
        local prod = old_Cook(self, cooker, chef)

        if type == "burnt" then
            if prod.components.perishable ~= nil then
                local old_percent = prod.components.perishable:GetPercent()
                local new_percent = old_percent * (1 + burnt_punish[level])
                prod.components.perishable:SetPercent(new_percent)
            end
        end

        return prod
    end
end)

local function OnExplodeFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function Explode(inst)
    inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = 20
    inst.components.explosive.explosiverange = 2
    inst.components.explosive:OnBurnt()
end

AddComponentPostInit("stewer", function (self)
    local old_StartCooking = self.StartCooking
    local dostew = upvaluehelper.Get(old_StartCooking, "dostew")

    function self:StartCooking(doer)
        --先排除掉，有不能调味的料理
        local has_amakumo_spice = false
        local food_isnot_raidenfood = false
        if self.inst.prefab == "portablespicer" then
            for k, v in pairs(self.inst.components.container.slots) do
                if v.prefab == "spice_amakumo" then
                    has_amakumo_spice = true
                elseif not v:HasTag("raiden_food") then
                    food_isnot_raidenfood = true
                end
            end
        end
        local cannot_stew_amakumo = has_amakumo_spice and food_isnot_raidenfood

        local explode_rate = {0.05, 0, 0, 0}
        local fail_rate = {0.25, 0.2, 0.15, 0} 
        local time_rate = {2, 1.5, 1.15, 1}

        local type = "normal"
        local level = 4
        if doer:HasTag("_cookunlocker") and doer.components.cookunlocker then
            level = doer.components.cookunlocker:GetLevel(2)
            local rand = math.random()
            if rand < fail_rate[level] then
                type = "fail"
                doer.components.talker:Say(STRINGS.RAIDEN_STEW_FAIL, nil, true)
            elseif rand < fail_rate[level] + explode_rate[level] and TUNING.RAIDEN_COOK_EXPLOSION then
                doer.components.talker:Say(STRINGS.RAIDEN_STEW_EXPLODE, nil, true)
                doer.components.sanity:DoDelta(-20)
                self.inst.components.container:DropEverything()
                self.inst.components.burnable:Ignite()
                self.inst:DoTaskInTime(3, function ()
                    Explode(self.inst)
                end)
                return
            else
                doer.components.cookunlocker:CookSucceed(2)
            end
        else
            if not cannot_stew_amakumo then
                old_StartCooking(self, doer)
            else
                doer.components.talker:Say(STRINGS.CANNOTUSE_SPICE_AMAKUMO, nil, true)
            end
            return
        end

        if not cannot_stew_amakumo then
            old_StartCooking(self, doer)
        else
            doer.components.talker:Say(STRINGS.CANNOTUSE_SPICE_AMAKUMO, nil, true)
            return
        end

        if type == "fail" then
            self.product = "wetgoop"  --后面会换成裁决之时
        end
        if self.product == "wetgoop" and doer:HasTag("raiden_shogun") then
            self.product = "adjudicatetime"
            self.product_spoilage = 1
        end
        -- cooktime = TUNING.BASE_COOK_TIME * cooktime * self.cooktimemult
        -- self.targettime = GetTime() + cooktime
        local old_cooktime = type == "normal" and (self.targettime - GetTime()) or TUNING.BASE_COOK_TIME * 0.5 * self.cooktimemult
        local new_cooktime = old_cooktime * time_rate[level]
        self.targettime = GetTime() + new_cooktime
        if self.task ~= nil then
            self.task:Cancel()
        end
        self.task = self.inst:DoTaskInTime(new_cooktime, dostew, self)
    end
end)

AddComponentPostInit("wisecracker", function (self)
    local inst = self.inst
    local upvaluehelper = require("import/upvaluehelper")
    local oneatenfn = upvaluehelper.GetEventHandle(inst, "oneat","components/wisecracker")
    if oneatenfn then
		inst:RemoveEventCallback("oneat", oneatenfn)
        local function editted_oneatenfn(inst, data)
            if data.food ~= nil and data.food.components.edible ~= nil then
                if data.food.prefab ~= "spoiled_food" and data.food.components.perishable ~= nil then
                    if data.food.components.perishable:IsFresh() then
                        local isextended_raiden = inst:HasTag("masterchef") and inst:HasTag("raiden_shogun")
                        if isextended_raiden and data.food.prefab ~= "wetgoop" then
                            return
                        end
                    end
                end
            end
            oneatenfn(inst, data)
        end
        
        inst:ListenForEvent("oneat", editted_oneatenfn)
    end
end)