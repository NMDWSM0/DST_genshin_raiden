
local function tryplaysound(inst, id, sound)
    inst._soundtasks[id] = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst.SoundEmitter:PlaySound(sound)
    end
end

local function trykillsound(inst, id, sound)
    inst._soundtasks[id] = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst.SoundEmitter:KillSound(sound)
    end
end

local function queueplaysound(inst, delay, id, sound)
    if inst._soundtasks[id] ~= nil then
        inst._soundtasks[id]:Cancel()
    end
    inst._soundtasks[id] = inst:DoTaskInTime(delay, tryplaysound, id, sound)
end

local function queuekillsound(inst, delay, id, sound)
    if inst._soundtasks[id] ~= nil then
        inst._soundtasks[id]:Cancel()
    end
    inst._soundtasks[id] = inst:DoTaskInTime(delay, trykillsound, id, sound)
end

local function tryqueueclosingsounds(inst, onanimover)
    inst._soundtasks.animover = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst:RemoveEventCallback("animover", onanimover)
        --Delay one less frame, since this task is delayed one frame already
        queueplaysound(inst, 4 * FRAMES, "close", "dontstarve/common/together/book_maxwell/close")
        queuekillsound(inst, 5 * FRAMES, "killidle", "idlesound")
        queueplaysound(inst, 14 * FRAMES, "drop", "dontstarve/common/together/book_maxwell/drop")
    end
end

local function onanimover(inst)
    if inst._soundtasks.animover ~= nil then
        inst._soundtasks.animover:Cancel()
    end
    inst._soundtasks.animover = inst:DoTaskInTime(FRAMES, tryqueueclosingsounds, onanimover)
end

local function stopclosingsounds(inst)
    inst:RemoveEventCallback("animover", onanimover)
    if next(inst._soundtasks) ~= nil then
        for k, v in pairs(inst._soundtasks) do
            v:Cancel()
        end
        inst._soundtasks = {}
    end
end

local function startclosingsounds(inst)
    stopclosingsounds(inst)
    inst:ListenForEvent("animover", onanimover)
    onanimover(inst)
end

-------------------------------------------------------------------

local function doneact(inst)
    inst._activetask = nil
    inst.AnimState:PushAnimation("proximity_pst")
    inst.AnimState:PushAnimation("idle", false)
    startclosingsounds(inst)
end

local function showfx(inst, show)
    if inst.AnimState:IsCurrentAnimation("use") then
        if show then
            inst.AnimState:Show("FX")
        else
            inst.AnimState:Hide("FX")
        end
    end
end

local function onuse(inst)
    inst.components.finiteuses:Use(1)
    stopclosingsounds(inst)
    inst.AnimState:PlayAnimation("use")
    inst:DoTaskInTime(0, showfx, true)
    inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/use")
    if inst._activetask ~= nil then
        inst._activetask:Cancel()
    end
    inst._activetask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), doneact)
end


local function onfirepituse(inst, doer)
    if doer.components.cookunlocker == nil then
        return false
    end

    local can, reason = doer.components.cookunlocker:CanUnlock(1, doer.components.cookunlocker.firepit_level + 1)
    if not can then
        doer.components.talker:Say(STRINGS.USE_RAIDENCOOKBOOK_FAIL[string.upper(reason)])
        return false
    end

    if doer.components.cookunlocker.firepit_level == 0 then
        doer.components.timer:StartTimer("firepit_level1_unlock", TUNING.RAIDEN_COOKBOOK_LEARNTIME)
        doer:AddTag("initial_study")
        onuse(inst)
    else
        doer.components.cookunlocker:StartStudy(1)
        onuse(inst)
    end
    return true
end

local function oncookpotuse(inst, doer)
    if doer.components.cookunlocker == nil then
        return false
    end

    local can, reason = doer.components.cookunlocker:CanUnlock(2, doer.components.cookunlocker.cookpot_level + 1)
    if not can then
        doer.components.talker:Say(STRINGS.USE_RAIDENCOOKBOOK_FAIL[string.upper(reason)])
        return false
    end

    if doer.components.cookunlocker.cookpot_level == 0  then
        doer:AddTag("initial_study")
        doer.components.timer:StartTimer("cookpot_level1_unlock", TUNING.RAIDEN_COOKBOOK_LEARNTIME)
        onuse(inst)
    else
        doer.components.cookunlocker:StartStudy(2)
        onuse(inst)
    end
    return true
end

local function onspiceruse(inst, doer)
    if doer.components.cookunlocker == nil then
        return false
    end

    local can, reason = doer.components.cookunlocker:CanUnlock(3, 1)
    if not can then
        doer.components.talker:Say(STRINGS.USE_RAIDENCOOKBOOK_FAIL[string.upper(reason)])
        return false
    end

    doer.components.cookunlocker:StartStudy(3)
    onuse(inst)
    return true
end

----------------------------------------------------------

local function onputininventory(inst)
    if inst._activetask ~= nil then
        inst._activetask:Cancel()
        inst._activetask = nil
    end
    stopclosingsounds(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.SoundEmitter:KillSound("idlesound")
end

local function MakeRaidenCookbook(name, onusefn)
    local assets = {
        Asset("ANIM", "anim/"..name..".zip"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),

        Asset("SOUND", "sound/together.fsb"),
    }

    local function fn()
        local inst = CreateEntity()
    
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
    
        MakeInventoryPhysics(inst)
    
        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle")
    
        inst:AddTag("raiden_cookbooks")
        inst:AddTag(name)
    
        MakeInventoryFloatable(inst, "med", nil, 0.75)
    
        inst.entity:SetPristine()
    
        if not TheWorld.ismastersim then
            return inst
        end
    
        inst._activetask = nil
        inst._soundtasks = {}
    
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"
	    inst.components.inventoryitem:ChangeImageName(name)

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(5)
        inst.components.finiteuses:SetUses(5)
    
        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    
        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)
    
        inst:ListenForEvent("onputininventory", onputininventory)
    
        inst.onuse = onusefn

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeRaidenCookbook("book_firepit", onfirepituse),
    MakeRaidenCookbook("book_cookpot", oncookpotuse),
    MakeRaidenCookbook("book_spicer", onspiceruse)