--自定义区域
local chargeattack_anim = "action_raiden_chargeattack"   --OK
local chargeattack_anim_pst = "action_raiden_chargeattack_pst"
local eleburst_anim = "action_raiden_eleburst"   --OK
local eleskill_anim = "action_raiden_eleskill"   --OK
local chargeattack_timeout = 32 * FRAMES   --OK
local eleburst_timeout = 75 * FRAMES   --OK
local eleskill_timeout = 39 * FRAMES   --OK
--更改xxxx_anim的名字就播放对应的动画
--更改xxxx_timeout的数值就设置这个动画播放多长时间后自动退出（如果时间比动画短会强退），FRAMES = 1/30秒
--chargeattack是重击，长按F（长按攻击键）触发
--eleburst是元素爆发，默认键位Q，可以自行设置
--eleskill是元素战技，默认键位E，可以自行设置
------------------------------------------------------------

local function ClearCollision(inst)
    local phys = inst.Physics
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
end

local function RecoverCollision(inst)
    local phys = inst.Physics
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
    phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.GIANTS)
end

--重击
local raiden_chargeattack = State{
    name = "raiden_chargeattack",
    tags = { "chargeattack", "attack", "notalking", "nointerrupt", "abouttoattack", "autopredict" },

    onenter = function(inst)
        if inst.components.combat:InCooldown() then
            inst.sg:RemoveStateTag("abouttoattack")
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end
        if inst.sg.laststate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
        end
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        inst.components.combat:SetTarget(target)
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation(chargeattack_anim, false)
        inst.SoundEmitter:PlaySound("raiden_sound/sesound/raiden_chargeattack")

        inst.sg:SetTimeout(chargeattack_timeout)

        if target ~= nil then
            inst.components.combat:BattleCry()
            if target:IsValid() then
                inst:FacePoint(target:GetPosition())
                inst.sg.statemem.attacktarget = target
                inst.sg.statemem.retarget = target
            end
        end
    end,

    timeline =
    {
        TimeEvent(2 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("raiden_sound/sesound/raiden_chargeattack")
        end),

        TimeEvent(6 * FRAMES, function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            local facingangle = inst.Transform:GetRotation() * DEGREES
	        local facedirection = Vector3(math.cos(-facingangle), 0, math.sin(-facingangle))
            if inst.sg.statemem.attacktarget ~= nil then
                x, y, z = inst.sg.statemem.attacktarget.Transform:GetWorldPosition()
            else
                x = x + facedirection.x * 2
                z = z + facedirection.z * 2
            end
            local fx = SpawnPrefab("raiden_atk_fx3")
            fx.Transform:SetPosition(x, 2, z)

            ClearCollision(inst)
            inst.sg.statemem.collisioncleared = true

            x, y, z = inst.Transform:GetWorldPosition()
            inst.sg.statemem.oripos = Vector3(x, y, z)
            local dis = 0
            inst.DashTask = inst:DoPeriodicTask(FRAMES, function ()
                dis = dis + 0.2
                local delta = facedirection * dis
                inst.Transform:SetPosition(x + delta.x, y, z + delta.z)
            end)
        end),

        TimeEvent(9 * FRAMES, function(inst)
            inst.DashTask:Cancel()
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
            inst.AnimState:PlayAnimation("empty")
        end),

        TimeEvent(18 * FRAMES, function(inst)
            inst.AnimState:SetPercent(chargeattack_anim_pst, 0)
            --6*FRAMES to Rotate
            local rot = inst.Transform:GetRotation()
            local x, y, z = inst.Transform:GetWorldPosition()
            local dir = inst.sg.statemem.oripos - Vector3(x, y, z)
            inst.Transform:SetPosition(x + dir.x/2, y, z + dir.z/2)
            local times = 6
            rot = rot + 180
            inst.Transform:SetRotation(rot)
            inst.RotateTask = inst:DoPeriodicTask(FRAMES, function ()
                rot = rot + 30
                times = times + 1
                local delta = dir * times / 12
                inst.Transform:SetRotation(rot)
                inst.Transform:SetPosition(x + delta.x, y, z + delta.z)
            end)
        end),

        TimeEvent(23 * FRAMES, function(inst)
            inst.RotateTask:Cancel()

            RecoverCollision(inst)
            inst.sg.statemem.collisioncleared = false

            inst.AnimState:PlayAnimation(chargeattack_anim_pst)
        end),

        TimeEvent(27 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end),

    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        -- EventHandler("animqueueover", function(inst)
        --     if inst.AnimState:AnimDone() then
        --         inst.sg:GoToState("idle")
        --     end
        -- end),
    },

    onexit = function(inst)
        if inst.DashTask ~= nil then
            inst.DashTask:Cancel()
        end
        if inst.RotateTask ~= nil then
            inst.RotateTask:Cancel()
        end
        if inst.sg.statemem.collisioncleared then
            RecoverCollision(inst)
        end
        if inst.sg.statemem.oripos ~= nil then
            inst.Transform:SetPosition(inst.sg.statemem.oripos:Get())
        end
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
    end,
}

local raiden_chargeattack_client = State{
    name = "raiden_chargeattack",
    tags = {"chargeattack", "attack", "notalking", "nointerrupt", "abouttoattack" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        if inst.replica.combat ~= nil then
            if inst.replica.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
            inst.replica.combat:StartAttack()
        end
        if inst.sg.laststate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
        end
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation(chargeattack_anim, false)

        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil and buffaction.target:IsValid() then
                inst:FacePoint(buffaction.target:GetPosition())
                inst.sg.statemem.attacktarget = buffaction.target
                inst.sg.statemem.retarget = buffaction.target
            end
        end

        inst.sg:SetTimeout(chargeattack_timeout)
    end,

    timeline =
    {
        TimeEvent(6 * FRAMES, function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            local facingangle = inst.Transform:GetRotation() * DEGREES
	        local facedirection = Vector3(math.cos(-facingangle), 0, math.sin(-facingangle))
            inst.sg.statemem.oripos = Vector3(x, y, z)
            local dis = 0
            inst.DashTask = inst:DoPeriodicTask(FRAMES, function ()
                dis = dis + 0.2
                local delta = facedirection * dis
                inst.Transform:SetPosition(x + delta.x, y, z + delta.z)
            end)
        end),

        TimeEvent(9 * FRAMES, function(inst)
            inst.DashTask:Cancel()
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
            inst.AnimState:PlayAnimation("empty")
        end),

        TimeEvent(18 * FRAMES, function(inst)
            inst.AnimState:SetPercent(chargeattack_anim_pst, 0)
            --6*FRAMES to Rotate
            local rot = inst.Transform:GetRotation()
            local x, y, z = inst.Transform:GetWorldPosition()
            local dir = inst.sg.statemem.oripos - Vector3(x, y, z)
            inst.Transform:SetPosition(x + dir.x/2, y, z + dir.z/2)
            local times = 6
            rot = rot + 180
            inst.Transform:SetRotation(rot)
            inst.RotateTask = inst:DoPeriodicTask(FRAMES, function ()
                rot = rot + 30
                times = times + 1
                local delta = dir * times / 12
                inst.Transform:SetRotation(rot)
                inst.Transform:SetPosition(x + delta.x, y, z + delta.z)
            end)
        end),

        TimeEvent(23 * FRAMES, function(inst)
            inst.RotateTask:Cancel()
            inst.AnimState:PlayAnimation(chargeattack_anim_pst)
        end),

        TimeEvent(27 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        -- EventHandler("animqueueover", function(inst)
        --     if inst.AnimState:AnimDone() then
        --         inst.sg:GoToState("idle")
        --     end
        -- end),
    },

    onexit = function(inst)
        if inst.DashTask ~= nil then
            inst.DashTask:Cancel()
        end
        if inst.RotateTask ~= nil then
            inst.RotateTask:Cancel()
        end
        if inst.sg.statemem.oripos ~= nil then
            inst.Transform:SetPosition(inst.sg.statemem.oripos:Get())
        end
        if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
            inst.replica.combat:CancelAttack()
        end
    end,
}

--------------------------------------------------------------------------	
--元素爆发
local raiden_eleburst = State{
    name = "raiden_eleburst",
    tags = { "attack", "notalking", "nointerrupt", "noyawn", "nosleep", "nofreeze", "nocurse", "temp_invincible", "no_gotootherstate", "pausepredict" },	
    
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()	
        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation(eleburst_anim)
        inst.AnimState:OverrideSymbol("swap_object", "action_raiden_eleburst", "swap_object")
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item == nil then
            inst.AnimState:Show("ARM_CARRY")
		    inst.AnimState:Hide("ARM_NORMAL")
        end

        inst.SoundEmitter:PlaySound("raiden_sound/sesound/raiden_eleburst")

        inst.sg:SetTimeout(eleburst_timeout)
    end,
    
    timeline=
    {   
        TimeEvent(0 * FRAMES, function(inst) 
            local x, y, z = inst.Transform:GetWorldPosition()
	        local ents = TheSim:FindEntities(x, y, z, 6, {"_combat"}, TUNING.RAIDEN_AREASKILLS_NOTAGS)
	        local mindist = 6
	        local mintarget = nil
	        if ents ~= nil then
		        for k, v in pairs(ents) do
			        local dist = Vector3(x, y, z):Dist(inst:GetPosition())
			        if dist < mindist then
				        mindist = dist
				        mintarget = v
			        end
		        end
	        end
	        if mintarget ~= nil then
                inst:ForceFacePoint(Point(mintarget.Transform:GetWorldPosition()))
	        end
        end),

        TimeEvent(34 * FRAMES, function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            local facingangle = inst.Transform:GetRotation() * DEGREES
            local fx = SpawnPrefab("raiden_eleburst_fx")
            fx.Transform:SetPosition(x + math.cos(-facingangle) * 2.5, 1.5, z + math.sin(-facingangle) * 2.5)
            fx.Transform:SetRotation(inst.Transform:GetRotation())
        end),
        
        TimeEvent(46 * FRAMES, function(inst) 
            inst:ShakeCamera(CAMERASHAKE.FULL, 0.15, 0.03, 0.3)

            local x, y, z = inst.Transform:GetWorldPosition()
	        local ents = TheSim:FindEntities(x, y, z, 6, {"_combat"}, TUNING.RAIDEN_AREASKILLS_NOTAGS)
            local work_ents = TheSim:FindEntities(x, y, z, 6, {"plant"})
            local bloombombs = TheSim:FindEntities(x, y, z, 6, {"bloombomb"}, {"isexploding", "istracing"})
            local facingangle = inst.Transform:GetRotation() * DEGREES
	        local facedirection = Vector3(math.cos(-facingangle), 0, math.sin(-facingangle))

            local old_state = inst.components.combat.ignorehitrange
            inst.components.combat.ignorehitrange = true
            for k, v in pairs(ents) do
                local targetdirection = (v:GetPosition() - Vector3(x, y, z)):Normalize()
                if targetdirection:Dot(facedirection) > 0 then   
                    inst.components.combat:DoAttack(v, nil, nil, 4, TUNING.RAIDENSKILL_ELEBURST.DMG[inst.components.talents:GetTalentLevel(3)] + inst.resolve_stack * TUNING.RAIDENSKILL_ELEBURST.RESOLVE_BONUS[inst.components.talents:GetTalentLevel(3)], nil, nil, "elementalburst") 
                end
            end
            inst.components.combat.ignorehitrange = old_state

            for k, v in pairs(work_ents) do
                local targetdirection = (v:GetPosition() - Vector3(x, y, z)):Normalize()
                if targetdirection:Dot(facedirection) > 0 and v.components.workable and v.components.workable.action == ACTIONS.CHOP then   
                    v.components.workable:Destroy(inst)
                end
            end

            for k, v in pairs(bloombombs) do
                local targetdirection = (v:GetPosition() - Vector3(x, y, z)):Normalize()
	        	if targetdirection:Dot(facedirection) > 0 then
	        		v:Hyperbloom(inst)
	        	end
            end
        end),

        TimeEvent(50 * FRAMES, function(inst) 
            inst.sg:RemoveStateTag("pausepredict")
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("noyawn")
            inst.sg:RemoveStateTag("nosleep")
            inst.sg:RemoveStateTag("nofreeze")
            inst.sg:RemoveStateTag("nocurse")
            inst.sg:RemoveStateTag("temp_invincible")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.components.playercontroller:Enable(true)
        end),

    },

    events=
    {
        EventHandler("animqueueover", function(inst) 
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:GoToState("idle")                                    
        end),
    },  

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("no_gotootherstate")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")	   
        inst.components.playercontroller:Enable(true)         		
    end,
    
    onexit = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:OverrideSymbol("swap_object", "swap_musouisshin", "swap_object")
            inst.components.combat:SetRange(TUNING.RAIDEN_BURST_ATTACKRANGE)
        elseif inst:HasTag("raiden_shogun") then
            inst:elementalburst_exit()
        else
            inst.AnimState:ClearOverrideSymbol("swap_object")
		    inst.AnimState:Hide("ARM_CARRY")
		    inst.AnimState:Show("ARM_NORMAL")
        end
        inst.components.playercontroller:Enable(true)
    end,               
}

local raiden_eleburst_client = State{
    name = "raiden_eleburst",
    tags = { "attack", "notalking", "nointerrupt", "noyawn", "nosleep", "nofreeze", "nocurse", "temp_invincible", "no_gotootherstate" },	
    
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()	
        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation(eleburst_anim)

        inst.sg:SetTimeout(eleburst_timeout)
    end,
    
    timeline=
    {   
        TimeEvent(46 * FRAMES, function(inst) 
            inst:ShakeCamera(CAMERASHAKE.FULL, 0.15, 0.03, 0.3)
        end),

        TimeEvent(50 * FRAMES, function(inst) 
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("noyawn")
            inst.sg:RemoveStateTag("nosleep")
            inst.sg:RemoveStateTag("nofreeze")
            inst.sg:RemoveStateTag("nocurse")
            inst.sg:RemoveStateTag("temp_invincible")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.components.playercontroller:Enable(true)
        end),
    },

    events=
    {
        EventHandler("animqueueover", function(inst) 
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:GoToState("idle")                                    
        end),
    },  

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("no_gotootherstate")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")	   
        inst.components.playercontroller:Enable(true)         		
    end,
    
    onexit = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        inst.components.playercontroller:Enable(true)
    end,               
}

--元素战技
local raiden_eleskill = State{
    name = "raiden_eleskill",
    tags = { "attack", "notalking", "nointerrupt", "nosleep", "nofreeze", "nocurse", "temp_invincible", "no_gotootherstate", "pausepredict" },	
    
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()	
        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation(eleskill_anim)
        inst.sg:SetTimeout(eleskill_timeout)
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_NORMAL")
		    inst.AnimState:Hide("ARM_CARRY")
        end

        inst.SoundEmitter:PlaySound("raiden_sound/sesound/raiden_eleskill")

        inst:AddTag("stronggrip")
    end,
    
    timeline=
    {   
        TimeEvent(0 * FRAMES, function(inst) 
            local x, y, z = inst.Transform:GetWorldPosition()
	        local ents = TheSim:FindEntities(x, y, z, 5, {"_combat"}, TUNING.RAIDEN_AREASKILLS_NOTAGS)
	        local mindist = 5
	        local mintarget = nil
	        if ents ~= nil then
		        for k, v in pairs(ents) do
			        local dist = Vector3(x, y, z):Dist(inst:GetPosition())
			        if dist < mindist then
				        mindist = dist
				        mintarget = v
			        end
		        end
	        end
	        if mintarget ~= nil then
                inst:FacePoint(Point(mintarget.Transform:GetWorldPosition()))
	        end
            local facingangle = inst.Transform:GetRotation() * DEGREES
            local fx = SpawnPrefab("raiden_eleskill_fx")
            fx.Transform:SetPosition(x + math.cos(-facingangle) * 2.5, 1.5, z + math.sin(-facingangle) * 2.5)
        end),

        TimeEvent(7 * FRAMES, function(inst) 
            local x, y, z = inst.Transform:GetWorldPosition()
	        local ents = TheSim:FindEntities(x, y, z, 5, {"_combat"}, TUNING.RAIDEN_AREASKILLS_NOTAGS)
            local bloombombs = TheSim:FindEntities(x, y, z, 5, {"bloombomb"}, {"isexploding", "istracing"})
	        local mindist = 5
	        local mintarget = nil
	        local facingangle = inst.Transform:GetRotation() * DEGREES
	        local facedirection = Vector3(math.cos(-facingangle), 0, math.sin(-facingangle))
	        if ents ~= nil then
		        for k, v in pairs(ents) do
			        local dist = Vector3(x, y, z):Dist(inst:GetPosition())
			        if dist < mindist then
				        mindist = dist
				        mintarget = v
			        end
		        end
	        end
	        if mintarget ~= nil then
                inst.components.energyrecharge:GainEnergy(3) --一个同色球
                inst:FacePoint(Point(mintarget.Transform:GetWorldPosition()))
		        facedirection = (mintarget:GetPosition() - Vector3(x, y, z)):Normalize()
                local old_state = inst.components.combat.ignorehitrange
				inst.components.combat.ignorehitrange = true
---@diagnostic disable-next-line: param-type-mismatch
                for k, v in pairs(ents) do
			        local targetdirection = (v:GetPosition() - Vector3(x, y, z)):Normalize()
			        if targetdirection:Dot(facedirection) >= 1/3 then
				        inst.components.combat:DoAttack(v, nil, nil, 4, TUNING.RAIDENSKILL_ELESKILL.DMG[inst.components.talents:GetTalentLevel(2)], nil, nil, "elementalskill")
			        end
		        end
                inst.components.combat.ignorehitrange = old_state
	        end

            for k, v in pairs(bloombombs) do
                local targetdirection = (v:GetPosition() - Vector3(x, y, z)):Normalize()
	        	if targetdirection:Dot(facedirection) >= 1/3 then
	        		v:Hyperbloom(inst)
	        	end
            end
        end),

        TimeEvent(10 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("pausepredict")
            inst.sg:RemoveStateTag("nosleep")
            inst.sg:RemoveStateTag("nofreeze")
            inst.sg:RemoveStateTag("nocurse")
            inst.sg:RemoveStateTag("temp_invincible")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.components.playercontroller:Enable(true)
        end)
    },

    events=
    {
        EventHandler("animqueueover", function(inst) 
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:GoToState("idle")                                    
        end),
    },  

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("no_gotootherstate")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")	   
        inst.components.playercontroller:Enable(true)    		
    end,
    
    onexit = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_CARRY")
		    inst.AnimState:Hide("ARM_NORMAL")
        end
        inst.sg:RemoveStateTag("attack")
        inst:RemoveTag("stronggrip")
        inst.components.playercontroller:Enable(true)
    end,               
}

local raiden_eleskill_client = State{
    name = "raiden_eleskill",
    tags = { "attack", "notalking", "nointerrupt", "nosleep", "nofreeze", "nocurse", "temp_invincible", "no_gotootherstate" },	
    
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()	
        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation(eleskill_anim)

        inst.sg:SetTimeout(eleskill_timeout)
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_NORMAL")
		    inst.AnimState:Hide("ARM_CARRY")
        end
    end,
    
    timeline=
    {   
        TimeEvent(10 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("nosleep")
            inst.sg:RemoveStateTag("nofreeze")
            inst.sg:RemoveStateTag("nocurse")
            inst.sg:RemoveStateTag("temp_invincible")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.components.playercontroller:Enable(true)
        end)
    },

    events=
    {
        EventHandler("animqueueover", function(inst) 
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:GoToState("idle")                                    
        end),
    },  

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("no_gotootherstate")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")	   
        inst.components.playercontroller:Enable(true)         		
    end,
    
    onexit = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_CARRY")
		    inst.AnimState:Hide("ARM_NORMAL")
        end
        inst.sg:RemoveStateTag("attack")
        inst.components.playercontroller:Enable(true)
    end,               
}

--------------------------------------------------------------------------
--添加sg
local function SGWilsonPostInit(sg)
    sg.states["raiden_chargeattack"] = raiden_chargeattack
    sg.states["raiden_eleburst"] = raiden_eleburst
    sg.states["raiden_eleskill"] = raiden_eleskill
end

local function SGWilsonClientPostInit(sg)
    sg.states["raiden_chargeattack"] = raiden_chargeattack_client
    sg.states["raiden_eleburst"] = raiden_eleburst_client
    sg.states["raiden_eleskill"] = raiden_eleskill_client
end

AddStategraphState("SGwilson", raiden_chargeattack)
AddStategraphState("SGwilson", raiden_eleburst)
AddStategraphState("SGwilson", raiden_eleskill)

AddStategraphState("SGwilson_client", raiden_chargeattack_client)
AddStategraphState("SGwilson_client", raiden_eleburst_client)
AddStategraphState("SGwilson_client", raiden_eleskill_client)

AddStategraphPostInit("wilson", SGWilsonPostInit)
AddStategraphPostInit("wilson_client", SGWilsonClientPostInit)

-- 这个不需要了，直接加nohitanim全抗打断
-- AddStategraphPostInit("wilson", function(sg)
--     --雷电将军重击期间提升抗打断能力
-- 	if sg.events and sg.events.attacked then
-- 		local old_attacked = sg.events.attacked.fn
-- 		sg.events.attacked.fn = function(inst, data)
-- 			if inst.sg and inst.sg:HasStateTag("nointerrupt") and inst.sg:HasStateTag("chargeattack") and inst:HasTag("raiden_shogun") then
--                 return
--             end
--             return old_attacked(inst, data)
--         end
-- 	end
-- end)

-- AddGlobalClassPostConstruct("stategraph", "StateGraphInstance", function (self)
--     local old_GoToState = self.GoToState
--     function self:GoToState(...)
--         if self.tags and self.tags["no_gotootherstate"] then
--             print("Try to goto another state while in an unchanging state")
--             return
--         end
--         old_GoToState(self, ...)
--     end
-- end)