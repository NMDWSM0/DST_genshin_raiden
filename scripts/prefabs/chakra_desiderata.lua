local assets = 
{
    Asset( "ANIM", "anim/chakra_test.zip" ),
    Asset( "ANIM", "anim/chakra_item.zip" ),
}

--item_fns


--fns
local function spawnitems(inst)
    local PI = 3.1415926535
    for i = 1, 60 do
        local item = SpawnPrefab("chakra_item")
        inst:AddChild(item)

        local offset = 0
        if i >= 2 and i <= 10 then
            offset = 1 * PI / 36
        elseif i == 11 then
            offset = 2 * PI / 36
        elseif i >= 12 and i <= 20 then
            offset = 3 * PI / 36
        elseif i == 21 then
            offset = 4 * PI / 36
        elseif i >= 22 and i <= 30 then
            offset = 5 * PI / 36
        elseif i == 31 then
            offset = 6 * PI / 36
        elseif i >= 32 and i <= 40 then
            offset = 7 * PI / 36
        elseif i == 41 then
            offset = 8 * PI / 36
        elseif i >= 42 and i <= 50 then
            offset = 9 * PI / 36
        elseif i == 51 then
            offset = 10 * PI / 36
        elseif i >= 52 and i <= 60 then
            offset = 11 * PI / 36
        end

        local angle = PI / 2 - (i - 1) * PI / 36 - offset
        local z = 1 * math.cos(angle)
        local y = 1 * math.sin(angle)
        item.Transform:SetPosition(0, y, z)
        if i % 10 ~= 1 then
            local a = (i - 1) % 20
            local b = math.abs(a - 10)
            local scale = 1.1 - 0.05 * b
            item.Transform:SetScale(scale, scale, scale)
        end
        inst.components.entitytracker:TrackEntity("item_"..i, item)
    end
end

local function SetStack(inst, stack)
    inst.stack = math.min(math.max(stack, 0), 60)
    inst.AnimState:SetPercent("anim", inst.stack / 60)
    --print(inst.stack)
    for i = 1, 60 do
        local item = inst.components.entitytracker:GetEntity("item_"..i)
        if i <= inst.stack then
            item.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            if i == 11 or i == 31 or i == 51 then
                item.AnimState:PlayAnimation("icon_active", true)
                item.AnimState:SetTime(item.AnimState:GetCurrentAnimationLength() * math.random())
            elseif i == 1 or i == 21 or i == 41 then
                item.AnimState:PlayAnimation("big_active", true)
                item.AnimState:SetTime(item.AnimState:GetCurrentAnimationLength() * math.random())
            else 
                item.AnimState:PlayAnimation("normal_active", true)
            end
        else
            item.AnimState:ClearBloomEffectHandle()
            if i == 11 or i == 31 or i == 51 then
                item.AnimState:PlayAnimation("icon_inactive", true)
            elseif i == 1 or i == 21 or i == 41 then
                item.AnimState:PlayAnimation("big_inactive", true)
            else 
                item.AnimState:PlayAnimation("normal_inactive", true)
            end
        end
    end

    if inst.stack == 0 then
        inst.AnimState:SetMultColour(1, 1, 1, 0)
        for i = 1, 60 do
            local item = inst.components.entitytracker:GetEntity("item_"..i)
            item.AnimState:SetMultColour(1, 1, 1, 0)
        end
    else
        if TUNING.CHAKRA_STACKNUMBER then
            inst.AnimState:SetMultColour(1, 1, 1, 1)
        else
            inst.AnimState:SetMultColour(1, 1, 1, 0)
        end
        for i = 1, 60 do
            local item = inst.components.entitytracker:GetEntity("item_"..i)
            item.AnimState:SetMultColour(1, 1, 1, 1)
        end
    end
end

local function GainStack(inst, newstack)
    local finalstack = inst.stack + newstack
    SetStack(inst, finalstack)
    if inst.components.timer:TimerExists("clearstack") then
        inst.components.timer:SetTimeLeft("clearstack", 300)
    else
        inst.components.timer:StartTimer("clearstack", 300)
    end
end

local function GetStack(inst)
    return inst.stack or 0
end

-----------------------------------------------------------

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("chakra_item")
    inst.AnimState:SetBuild("chakra_item")
    inst.AnimState:PlayAnimation("normal_inactive", true)

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    inst.persists = false

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("chakra_test")
    inst.AnimState:SetBuild("chakra_test")
    --inst.AnimState:PlayAnimation("anim", true)
    inst.AnimState:SetPercent("anim", 0)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    if TUNING.CHAKRA_STACKNUMBER then
        inst.AnimState:SetMultColour(1, 1, 1, 1)
    else
        inst.AnimState:SetMultColour(1, 1, 1, 0)
    end

    inst.entity:SetPristine()

    inst:AddTag("chakra_desiderata")
    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")

    inst.persists = false

    if not TheWorld.ismastersim then
        return inst
    end

    inst.stack = 0 --愿力层数

    inst.master = nil

    inst:AddComponent("timer")

    inst:AddComponent("entitytracker")

    spawnitems(inst)

    inst:ListenForEvent("timerdone", function(inst, data) 
        if data and data.name == "clearstack" then
            inst:SetStack(0) 
        end
    end)

    inst.onelementalburst_casted = function(src, data)
        local master = inst.master
        if master == nil then
            return
        end
        local energycost = data and data.energycost or 0
        local electro_rate = 1
        local other_rate = 1
        if master.components.constellation and master.components.constellation:GetActivatedLevel() >= 1 then
            electro_rate = 1.8
            other_rate = 1.2
        end
        local gain_rate = TUNING.RAIDENSKILL_ELEBURST.RESOLVE_GAIN[master.components.talents:GetTalentLevel(3)]
        inst:GainStack(energycost * gain_rate * (data.element == 4 and electro_rate or other_rate))
    end
    inst.onorbsget = function(src, data)
        if not inst:HasTag("orbsget_stackgain_cd") then
            inst:AddTag("orbsget_stackgain_cd")
            inst:GainStack(2)
            inst:DoTaskInTime(3, function(inst) inst:RemoveTag("orbsget_stackgain_cd") end)
        end
    end
    inst:ListenForEvent("cast_elementalburst", inst.onelementalburst_casted, TheWorld)
    inst:ListenForEvent("elemental_orbs_get", inst.onorbsget, TheWorld)

    inst.SetStack = SetStack
    inst.GainStack = GainStack
    inst.GetStack = GetStack

    return inst
end

return Prefab("chakra_item", itemfn, assets),
    Prefab("chakra_desiderata", fn, assets)