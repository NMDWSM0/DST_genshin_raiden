
local assets =
{
    Asset("ANIM", "anim/engulfinglightning.zip"),
    Asset("ANIM", "anim/swap_engulfinglightning.zip"),
    Asset("IMAGE", "images/inventoryimages/engulfinglightning.tex"),
    Asset("ATLAS", "images/inventoryimages/engulfinglightning.xml"),
}


local function UpdateATKModifier(inst, player)
    if not player.components.energyrecharge then
        return
    end
    local rechargeover100 = player.components.energyrecharge:GetEnergyRecharge() - 1
    local atkup = math.max(math.min(TUNING.ENGULFINGLIGHTNING_ATKUP_RATE * rechargeover100, TUNING.ENGULFINGLIGHTNING_ATKUP_MAX), 0)
    player.components.combat.external_atk_multipliers:SetModifier(inst, atkup, "all_engulfinglightning_base")
end

local function UpdateRechargeModifier(inst, player)
    if not player.components.energyrecharge then
        return
    end
    player.components.energyrecharge:SetModifier(inst, TUNING.ENGULFINGLIGHTNING_RECHARGEUP, "all_engulfinglightning_eleburstcasted")
    player:DoTaskInTime(12, function(player)
        player.components.energyrecharge:RemoveModifier(inst, "all_engulfinglightning_eleburstcasted")
    end)
end

---------------------------------------------------------------------------------

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_engulfinglightning", "swap_engulfinglightning")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if owner.components.energyrecharge then
        inst:ListenForEvent("energyrecharge_change", inst.playeratkupdate, owner)
        owner.components.energyrecharge:SetModifier(inst, 0.551, "all_engulfinglightning_base")
    end
    inst:ListenForEvent("cast_elementalburst", inst.playerrechargeupdate, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst:RemoveEventCallback("energyrecharge_change", inst.playeratkupdate, owner)
    inst:RemoveEventCallback("cast_elementalburst", inst.playerrechargeupdate, owner)
    if owner.components.energyrecharge then
        owner.components.energyrecharge:RemoveModifier(inst, "all_engulfinglightning_base")
        --不要直接去除"all_engulfinglightning_eleburstcasted"的加成，不然我走个位换个手杖BUFF没了
    end
    if owner.components.combat then
        owner.components.combat.external_atk_multipliers:RemoveModifier(inst)
    end
end

---------------------------------------------------------------------------------

local function DamageFn(weapon, attacker, target)
    if attacker == nil or attacker.components.combat == nil then
        return TUNING.ENGULFINGLIGHTNING_DAMAGE
    end
    return attacker.components.combat.defaultdamage + TUNING.ENGULFINGLIGHTNING_DAMAGE
end

local function newanimation(inst)
    if math.random() < 0.2 then
        inst.AnimState:PlayAnimation("idle-dynamic", false)
    else
        inst.AnimState:PlayAnimation("idle", false)
    end
end

---------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("engulfinglightning")
    inst.AnimState:SetBuild("engulfinglightning")
    inst.AnimState:PlayAnimation("idle-dynamic", false)
    inst.AnimState:SetDeltaTimeMultiplier(0.6)

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    --inst:AddTag("chargeattack_weapon")
    inst:AddTag("subtextweapon")
    inst.subtext = "recharge"
    inst.subnumber = "55.1%"
    inst.description = TUNING.WEAPONEFFECT_ENGULFINGLIGHTNING

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
    inst.components.inventoryitem.imagename = "engulfinglightning"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/engulfinglightning.xml"
	inst.components.inventoryitem:ChangeImageName("engulfinglightning")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("timer")
    inst:ListenForEvent("animover", newanimation)

    inst.playeratkupdate = function(player) UpdateATKModifier(inst, player) end
    inst.playerrechargeupdate = function(player) UpdateRechargeModifier(inst, player) end

    return inst
end

return Prefab("engulfinglightning", fn, assets)