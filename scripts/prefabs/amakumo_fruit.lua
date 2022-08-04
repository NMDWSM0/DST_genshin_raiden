local assets = {
    Asset( "ANIM", "anim/amakumo_fruit.zip" ),

    Asset( "IMAGE", "images/inventoryimages/amakumo_fruit.tex" ),
    Asset( "ATLAS", "images/inventoryimages/amakumo_fruit.xml" ),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(0.8, 0.8, 0.8)

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("amakumo_fruit")
    inst.AnimState:SetBuild("amakumo_fruit")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    inst:AddTag("amakumo_fruit")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "amakumo_fruit"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/amakumo_fruit.xml"
	inst.components.inventoryitem:ChangeImageName("amakumo_fruit")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("amakumo_fruit", fn, assets)