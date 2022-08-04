
local assets =
{
    Asset("ANIM", "anim/spice_amakumo.zip"),
    Asset("IMAGE", "images/inventoryimages/spice_amakumo.tex"),
    Asset("ATLAS", "images/inventoryimages/spice_amakumo.xml"),
}

local function MakeSpice(name)
    local function spicefn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("spice_amakumo")
        inst.AnimState:SetBuild("spice_amakumo")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_spice", "spice_amakumo", name)

        inst:AddTag("spice")

        MakeInventoryFloatable(inst, "med", nil, 0.7)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "spice_amakumo"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/spice_amakumo.xml"
	    inst.components.inventoryitem:ChangeImageName("spice_amakumo")

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, spicefn, assets)
end

return MakeSpice("spice_amakumo")