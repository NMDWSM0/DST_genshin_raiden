local assets = {
    Asset( "ANIM", "anim/crown_of_insight.zip" ),

    Asset( "IMAGE", "images/inventoryimages/crown_of_insight.tex" ),
    Asset( "ATLAS", "images/inventoryimages/crown_of_insight.xml" ),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("crown_of_insight")
    inst.AnimState:SetBuild("crown_of_insight")
    inst.AnimState:PlayAnimation("idle")
	--inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.Transform:SetScale(0.8, 0.8, 0.8)

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    inst:AddTag("crown_of_insight")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "crown_of_insight"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/crown_of_insight.xml"
	inst.components.inventoryitem:ChangeImageName("crown_of_insight")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("crown_of_insight", fn, assets)