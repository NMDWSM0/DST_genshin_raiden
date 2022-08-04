local function OnTick(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        target.components.health:DoDelta(-1, nil, "raiden_adjudicatebuff")
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    
    if target.components.combat then
        target.components.combat.external_critical_damage_multipliers:SetModifier(inst, 0.3, "electro_adjudicatebuff", { atk_elements = 4 })
    end
    inst.task = inst:DoPeriodicTask(5, OnTick, nil, target)

    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
    if target.components.combat then
        target.components.combat.external_critical_damage_multipliers:RemoveModifier(inst)
    end

    inst:Remove()
end

local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("buffover")
    inst.components.timer:StartTimer("buffover", TUNING.RAIDEN_ADJUDICATEBUFF_DURATION)
    inst.task:Cancel()
    inst.task = inst:DoPeriodicTask(5, OnTick, nil, target)
end

local function fn()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)

        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    --inst.entity:SetCanSleep(false)
    inst.entity:Hide()
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("buffover", TUNING.RAIDEN_ADJUDICATEBUFF_DURATION)
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("raiden_adjudicatebuff", fn)