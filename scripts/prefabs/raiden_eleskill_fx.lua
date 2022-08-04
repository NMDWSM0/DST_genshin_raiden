local assets =
{
    Asset("ANIM", "anim/raiden_eleskill_fx.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.8, 1.8, 1.8)

    inst.AnimState:SetBank("raiden_eleskill_fx")
    inst.AnimState:SetBuild("raiden_eleskill_fx")
    inst.AnimState:PlayAnimation("anim", false)
    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")  不用了，这个特效本身已经很亮了，不用加bloom

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

return Prefab("raiden_eleskill_fx", fn, assets)