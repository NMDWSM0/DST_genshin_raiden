
local assets =
{
    Asset("ANIM", "anim/thecatch.zip"),
    Asset("ANIM", "anim/swap_thecatch.zip"),
    Asset("IMAGE", "images/inventoryimages/thecatch.tex"),
    Asset("ATLAS", "images/inventoryimages/thecatch.xml"),
}

---------------------------------------------------------------------------------

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_thecatch", "swap_thecatch")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if owner.components.energyrecharge then
        owner.components.energyrecharge:SetModifier(inst, 0.459, "all_thecatch_base")
    end
    owner.components.combat.external_critical_rate_multipliers:SetModifier(inst, TUNING.THCATCH_CRIT_RATE[inst.components.refineable:GetCurrentLevel()], "thecatch_eleburst", { atk_key = "elementalburst" })
    owner.components.combat.external_attacktype_multipliers:SetModifier(inst, TUNING.THECATCH_ELEBURST_BONUS[inst.components.refineable:GetCurrentLevel()], "thecatch_eleburst", { atk_key = "elementalburst" })
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if owner.components.energyrecharge then
        owner.components.energyrecharge:RemoveModifier(inst)
    end
    owner.components.combat.external_critical_rate_multipliers:RemoveModifier(inst)
    owner.components.combat.external_attacktype_multipliers:RemoveModifier(inst)
end

---------------------------------------------------------------------------------

local function DamageFn(weapon, attacker, target)
    if attacker == nil or attacker.components.combat == nil then
        return TUNING.THECATCH_DAMAGE
    end
    return attacker.components.combat.defaultdamage + TUNING.THECATCH_DAMAGE
end

---------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("thecatch")
    inst.AnimState:SetBuild("thecatch")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    --inst:AddTag("chargeattack_weapon")
    inst:AddTag("subtextweapon")
    inst.subtext = "recharge"
    inst.subnumber = "45.9%"
    inst.description = TUNING.WEAPONEFFECT_THECATCH

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DamageFn)

    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "thecatch"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/thecatch.xml"
	inst.components.inventoryitem:ChangeImageName("thecatch")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("refineable")
    inst.components.refineable.ingredient = "ako_sake_vessel"
    inst.components.refineable.overrideimage = "ako_sake_vessel"
    inst.components.refineable.overrideatlas = "images/inventoryimages/ako_sake_vessel.xml"

    return inst
end

return Prefab("thecatch", fn, assets)