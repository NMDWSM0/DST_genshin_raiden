local assets = 
{
    Asset( "ANIM", "anim/eye_stormy_judge.zip" ),
}

local function HelpAttack(player, data)
    local inst = nil
    if player.children == nil then
        return
    end
    for k, v in pairs(player.children) do
        if k:HasTag("eye_stormy_judge") then
            inst = k
            break
        end
    end
    if inst == nil then
        return
    end
    --print(inst, master, player)
    local target = data.target
    local master = inst.components.entitytracker:GetEntity("master")
    if not master:HasTag("eye_stormy_judge_cd") then
        master:AddTag("eye_stormy_judge_cd") --顺序不能改
        local old_state = master.components.combat.ignorehitrange
		master.components.combat.ignorehitrange = true
        local x, y, z = target.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 1.5, {"_combat"}, {"FX", "NOCLICK", "DECOR", "INLIMBO", "player", "playerghost", "companion", "noauradamage"})
        for k, v in pairs(ents) do
            master.components.combat:DoAttack(v, nil, nil, 4, TUNING.RAIDENSKILL_ELESKILL.CO_DMG[master.components.talents:GetTalentLevel(2)], "elementalskill")
        end
        master.components.combat.ignorehitrange = old_state
        master:DoTaskInTime(0.9, function(master) 
            master:RemoveTag("eye_stormy_judge_cd")
        end)

        local fx1 = SpawnPrefab("raiden_atk_fx1")
        local fx2 = SpawnPrefab("raiden_atk_fx2")
        if target.components.combat.hiteffectsymbol ~= nil and target.AnimState:BuildHasSymbol(target.components.combat.hiteffectsymbol) then
            fx1.entity:SetParent(target.entity)
            fx1.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
            fx2.entity:SetParent(target.entity)
            fx2.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        else
            fx1.Transform:SetPosition(x, y + 1.8, z)
            fx2.Transform:SetPosition(x, y + 1.8, z)
        end
        fx2:RandomAngle()
    end
end

local function LinkToPlayer(inst, player, master)
    if master == nil then
        master = player
    end
    --print(inst, player, master)
    inst.components.entitytracker:TrackEntity("master", master)
    player:AddChild(inst)
    inst.Transform:SetPosition(-0.8, 2.8, 0)
    if player.components.elementalcaster ~= nil then
        local eleburst_bonus = TUNING.RAIDENSKILL_ELESKILL.ELEBURST_BONUS[master.components.talents:GetTalentLevel(2)]
        local energycost = player.components.elementalcaster.energy.elementalburst
        player.components.combat.external_attacktype_multipliers:SetModifier(inst, eleburst_bonus * energycost, "eye_stormy_judge_burst", { atk_key = "elementalburst" })
    end
    inst:ListenForEvent("onhitother", HelpAttack, player)
    inst:ListenForEvent("death", function(player, data)
        inst:Remove() 
    end, player)
    inst.components.timer:StartTimer("remove", 25)
end

local function Restart(inst)
    inst.components.timer:SetTimeLeft("remove", 25)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("eye_stormy_judge")
    inst.AnimState:SetBuild("eye_stormy_judge")
    inst.AnimState:PlayAnimation("show", false)
    inst.AnimState:SetDeltaTimeMultiplier(1.2)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddComponent("colourtweener")
    inst:DoTaskInTime(0.375, function(inst)
        inst.components.colourtweener:StartTween({0.6, 0.2, 0.7, 0}, 0.25)
    end)
    inst:DoTaskInTime(0.625, function(inst)
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetDeltaTimeMultiplier(0.65)
        inst.AnimState:ClearBloomEffectHandle()
        inst.components.colourtweener:StartTween({1, 1, 1, 1}, 0.25)
    end)

    inst.Transform:SetScale(0.3, 0.3, 0.3)

    inst.entity:SetPristine()

    inst:AddTag("eye_stormy_judge")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("timer")

    inst:AddComponent("entitytracker")

    inst:ListenForEvent("timerdone", function(inst) 
        inst.components.colourtweener:StartTween({0.6, 0.2, 0.7, 0}, 0.5)
        inst:DoTaskInTime(0.5, function(inst)
            inst:Remove() 
        end)
    end)

    inst.Restart = Restart
    inst.LinkToPlayer = LinkToPlayer

    return inst
end

return Prefab("eye_stormy_judge", fn, assets)