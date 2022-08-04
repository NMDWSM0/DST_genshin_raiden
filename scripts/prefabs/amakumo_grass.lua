
local assets =
{
    Asset( "ANIM", "anim/amakumo_grass.zip" ),
    Asset( "SOUND", "sound/common.fsb" ),
}

local prefabs =
{
    "amakumo_fruit",
}

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle_full", true)
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("idle_empty", true)
end


local function onpickedfn(inst, picker)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.AnimState:PlayAnimation("picking")
    inst.AnimState:PushAnimation("idle_empty", true)
end

local function onburntfn(inst)
	TheWorld:PushEvent("beginregrowth", inst)
    DefaultBurntFn(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(0.5, 0.5, 0.5)
    inst.MiniMapEntity:SetIcon("amakumo_grass.tex")

    inst.AnimState:SetBank("amakumo_grass")
    inst.AnimState:SetBuild("amakumo_grass")
    inst.AnimState:PlayAnimation("idle_full", true)

    inst:AddTag("plant")
    inst:AddTag("renewable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"

    inst.components.pickable:SetUp("amakumo_fruit", TUNING.AMAKUMO_GRASS_REGROW_TIME, 2)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    ---------------------
    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburntfn)
    MakeHauntableIgnite(inst)
    ---------------------

    return inst
end

return Prefab("amakumo_grass", fn, assets, prefabs)
