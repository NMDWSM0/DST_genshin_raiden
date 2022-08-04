local assets = {
    Asset( "ANIM", "anim/raiden_constellation_star.zip" ),

    Asset( "IMAGE", "images/inventoryimages/raiden_constellation_star.tex" ),
    Asset( "ATLAS", "images/inventoryimages/raiden_constellation_star.xml" ),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("raiden_constellation_star")
    inst.AnimState:SetBuild("raiden_constellation_star")
    inst.AnimState:PlayAnimation("idle", true)
	--inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.Transform:SetScale(1, 1, 1)

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    inst:AddTag("constellation_star")
    inst:AddTag("raiden_constellation_star")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "raiden_constellation_star"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/raiden_constellation_star.xml"
	inst.components.inventoryitem:ChangeImageName("raiden_constellation_star")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("raiden_constellation_star", fn, assets)