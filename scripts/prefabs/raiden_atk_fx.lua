local assets =
{
    Asset("ANIM", "anim/raiden_atk_fx1.zip"),
    Asset("ANIM", "anim/raiden_atk_fx2.zip"),
    Asset("ANIM", "anim/raiden_atk_fx3.zip"),
}

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(2, 2, 2)

    inst.AnimState:SetBank("raiden_atk_fx1")
    inst.AnimState:SetBuild("raiden_atk_fx1")
    inst.AnimState:PlayAnimation("anim", false)
    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")  

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    inst.persists = false

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", function(inst) inst:Remove() end)

    return inst
end

local function SetAngle(inst, angle)
    if not (type(angle) == "number" and angle % 15 == 0 and angle >= 0 and angle <= 345) then
        inst:Remove()
        return
    end

    inst.AnimState:PlayAnimation("angle_"..angle, false)
    inst:ListenForEvent("animover", function(inst) inst:Remove() end)
end

local function RandomAngle(inst)
    local angle = 15 * math.random(0, 23)
    SetAngle(inst, angle)
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(2.5, 2.5, 2.5)

    inst.AnimState:SetBank("raiden_atk_fx2")
    inst.AnimState:SetBuild("raiden_atk_fx2")
    inst.AnimState:SetDeltaTimeMultiplier(1.2)
    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")  

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    inst.persists = false

    if not TheWorld.ismastersim then
        return inst
    end
    
    --inst:ListenForEvent("animover", function(inst) inst:Remove() end)
    inst.SetAngle = SetAngle
    inst.RandomAngle = RandomAngle

    return inst
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(2.5, 2.5, 2.5)

    inst.AnimState:SetBank("raiden_atk_fx3")
    inst.AnimState:SetBuild("raiden_atk_fx3")
    inst.AnimState:PlayAnimation("anim", false)
    inst.AnimState:SetMultColour(166/255, 138/255, 255/255, 1)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")  

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    inst.persists = false

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", function(inst) inst:Remove() end)

    return inst
end

return Prefab("raiden_atk_fx1", fn1, assets),
    Prefab("raiden_atk_fx2", fn2, assets),
    Prefab("raiden_atk_fx3", fn3, assets)