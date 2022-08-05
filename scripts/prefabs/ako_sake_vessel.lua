local assets = {
    Asset( "ANIM", "anim/ako_sake_vessel.zip" ),

    Asset( "IMAGE", "images/inventoryimages/ako_sake_vessel.tex" ),
    Asset( "ATLAS", "images/inventoryimages/ako_sake_vessel.xml" ),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ako_sake_vessel")
    inst.AnimState:SetBuild("ako_sake_vessel")
    inst.AnimState:PlayAnimation("idle")
	--inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.Transform:SetScale(0.8, 0.8, 0.8)

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    inst:AddTag("ako_sake_vessel")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "ako_sake_vessel"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ako_sake_vessel.xml"
	inst.components.inventoryitem:ChangeImageName("ako_sake_vessel")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("ako_sake_vessel", fn, assets)