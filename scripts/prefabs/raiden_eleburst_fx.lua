local assets =
{
    Asset("ANIM", "anim/raiden_eleburst_fx.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(3, 3, 3)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("raiden_eleburst_fx")
    inst.AnimState:SetBuild("raiden_eleburst_fx")
    inst.AnimState:PlayAnimation("anim", false)
    inst.AnimState:SetMultColour(196/255, 162/255, 255/255, 1)
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

return Prefab("raiden_eleburst_fx", fn, assets)