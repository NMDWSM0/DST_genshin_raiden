
local assets =
{
    Asset("ANIM", "anim/favoniuslance.zip"),
    Asset("ANIM", "anim/swap_favoniuslance.zip"),
    Asset("IMAGE", "images/inventoryimages/favoniuslance.tex"),
    Asset("ATLAS", "images/inventoryimages/favoniuslance.xml"),
}

local function CheckCrit(inst, player, data)
    if data == nil or data.crit == false then
        return
    end

    if math.random() > TUNING.FAVONIUSLANCE_TRIGGER_RATE[inst.components.refineable:GetCurrentLevel()] then
        return
    end

    if inst.components.rechargeable == nil or inst.components.rechargeable.IsCharged == nil or inst.components.rechargeable:IsCharged() == false then
        return
    end

    if player.components.energyrecharge then
        player.components.energyrecharge:GainEnergy(6)
    end
    inst.components.rechargeable:Discharge(TUNING.FAVONIUSLANCE_EFFECT_CD[inst.components.refineable:GetCurrentLevel()])
end

---------------------------------------------------------------------------------

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_favoniuslance", "swap_favoniuslance")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if owner.components.energyrecharge then
        owner.components.energyrecharge:SetModifier(inst, 0.306, "all_favoniuslance_base")
    end
    inst:ListenForEvent("damagecalculated", inst.playerhitother, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if owner.components.energyrecharge then
        owner.components.energyrecharge:RemoveModifier(inst)
    end
    inst:RemoveEventCallback("damagecalculated", inst.playerhitother, owner)
end

---------------------------------------------------------------------------------

local function DamageFn(weapon, attacker, target)
    if attacker == nil or attacker.components.combat == nil then
        return TUNING.FAVONIUSLANCE_DAMAGE
    end
    return attacker.components.combat.defaultdamage + TUNING.FAVONIUSLANCE_DAMAGE
end

---------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("favoniuslance")
    inst.AnimState:SetBuild("favoniuslance")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    --inst:AddTag("chargeattack_weapon")
    inst:AddTag("subtextweapon")
    inst.subtext = "recharge"
    inst.subnumber = "30.6%"
    inst.description = TUNING.WEAPONEFFECT_FAVONIUSLANCE

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
    inst.components.inventoryitem.imagename = "favoniuslance"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/favoniuslance.xml"
	inst.components.inventoryitem:ChangeImageName("favoniuslance")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("rechargeable")

    inst:AddComponent("refineable")

    inst.playerhitother = function(player, data) CheckCrit(inst, player, data) end

    return inst
end

return Prefab("favoniuslance", fn, assets)