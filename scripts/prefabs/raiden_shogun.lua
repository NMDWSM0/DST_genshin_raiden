--初始加载
local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset("IMAGE", "images/colour_cubes/raiden_eleburst_cc.tex"),
}

local prefabs = {
    "favoniuslance",
}

local start_inv = {
	"favoniuslance",
}

local skillkeys = {
    TUNING.ELEMENTALSKILL_KEY,
	TUNING.ELEMENTALBURST_KEY,
}
local raiden_eleburst_cc = resolvefilepath("images/colour_cubes/raiden_eleburst_cc.tex")
local RAIDEN_ELEBURST_COLOURCUBES =
{
    day = raiden_eleburst_cc,
    dusk = raiden_eleburst_cc,
    night = raiden_eleburst_cc,
    full_moon = raiden_eleburst_cc,
}
--------------------------------------------------------------------------
--保存和加载
local function OnBecameHuman(inst, data)
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 6

	if inst.chakra_desiderata == nil then
		inst.chakra_desiderata = SpawnPrefab("chakra_desiderata")
	end
	inst.chakra_desiderata.master = inst
	inst.chakra_desiderata.entity:SetParent(inst.entity)
	inst.chakra_desiderata.Transform:SetPosition(-0.8, 1.8, 0)
	if data and data.chakra_stack then
		inst.chakra_desiderata:SetStack(data.chakra_stack)
	end
end

local function OnDeath(inst)
	if inst.chakra_desiderata ~= nil then
    	inst.chakra_desiderata:Remove()
    	inst.chakra_desiderata = nil
	end
	inst.chakra_stack = 0
end

local function OnDespawn(inst)
	if inst.chakra_desiderata ~= nil then
		inst.chakra_stack = inst.chakra_desiderata:GetStack()
		inst.chakra_desiderata:Remove()
    	inst.chakra_desiderata = nil
	else
		inst.chakra_stack = 0
	end
end

--保存
local function OnSave(inst, data)
	if inst.chakra_stack == nil then
		inst.chakra_stack = inst.chakra_desiderata ~= nil and inst.chakra_desiderata:GetStack() or 0
	end
	data.chakra_stack = inst.chakra_stack
end

--读取
local function OnLoad(inst, data)
    inst:ListenForEvent("ms_respawnedfromghost", OnBecameHuman)
    if not inst:HasTag("playerghost") then
        OnBecameHuman(inst, data)
    end
end

----------------------------------------------------------------------------
--命之座
--一命效果直接写函数里面

local function constellation_func2(inst)
	inst.components.combat:SetDefenseIgnoreFn(function(inst, target, weapon, atk_elements, attackkey)
		return attackkey == "elementalburst" and 0.6 or 0
	end)
end

local function constellation_func3(inst)
	if inst.components.talents == nil then
		return
    end
	inst.components.talents:SetExtensionModifier(3, inst, 3, "raiden_constellation3")
end

local function raiseattack(inst)   --这个是4命效果，非常驻所以写这里就可以了
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = TheSim:FindEntities(x, y, z, 20, {"player"}, {"playerghost"})
	for k, v in pairs(players) do
		v.components.combat.external_atk_multipliers:SetModifier(inst, 0.3, "raiden_constellation4")
		v:DoTaskInTime(10, function()
			v.components.combat.external_atk_multipliers:RemoveModifier(inst, "raiden_constellation4")
		end)
	end
end

local function constellation_func5(inst)
	if inst.components.talents == nil then
		return
    end
	inst.components.talents:SetExtensionModifier(2, inst, 3, "raiden_constellation5")
end

local function decreasecd(inst, player)	  --这个是6命效果，非常驻所以写这里就可以了
	player.components.elementalcaster:LeftTimeDelta("elementalburst", 1)
end

----------------------------------------------------------------------------
--天赋
local function TakeChakraStack(inst)
	local stack = inst.chakra_desiderata and inst.chakra_desiderata:GetStack() or 0
	if inst.chakra_desiderata ~= nil then
		inst.chakra_desiderata:SetStack(0.1)
	end
	return stack
end

--注意这是一个客机也运行的函数
local function ChargeSGFn(inst)
	if TheWorld.ismastersim then
		local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
		if weapon == nil then
			return "attack"
		end
	else
		local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
		if equip == nil then
			return "attack"
		end
	end
	return inst.burststate and "raiden_chargeattack" or "chargeattack"
end

--key和element
local function AttackkeyFn(inst, weapon, target)
    if inst.burststate then
		return "elementalburst"
	else
        return inst.sg:HasStateTag("chargeattack") and "charge" or "normal"
	end
end

local function StimuliFn(inst, weapon, targ, attackkey)
    if inst.burststate then
		return 4
	else
		return nil
	end
end

--普通攻击倍率
local function NormalATKRateFn(inst, target)
    if inst.burststate then
		local base = TUNING.RAIDENSKILL_ELEBURST.ATK_DMG[inst.components.talents:GetTalentLevel(3)]
		local atk_resolve_bonus = TUNING.RAIDENSKILL_ELEBURST.ATK_RESOLVE_BONUS[inst.components.talents:GetTalentLevel(3)]
        return base + inst.resolve_stack * atk_resolve_bonus
	else
        return TUNING.RAIDENSKILL_NORMALATK.ATK_DMG[inst.components.talents:GetTalentLevel(1)] 
	end
end

--重击倍率
local function ChargeATKRateFn(inst, target)
    if inst.burststate then
		local base = TUNING.RAIDENSKILL_ELEBURST.CHARGE_ATK_DMG[inst.components.talents:GetTalentLevel(3)]
		local atk_resolve_bonus = TUNING.RAIDENSKILL_ELEBURST.ATK_RESOLVE_BONUS[inst.components.talents:GetTalentLevel(3)]
        return base + inst.resolve_stack * atk_resolve_bonus
	else
        return TUNING.RAIDENSKILL_NORMALATK.CHARGE_ATK_DMG[inst.components.talents:GetTalentLevel(1)] 
	end
end

--
local function CustomAttackFn(inst, target, instancemult, ischarge)
	if ischarge and inst.burststate then
		local x, y, z = target.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 2.5, {"_combat"}, TUNING.RAIDEN_AREASKILLS_NOTAGS)
		local old_state = inst.components.combat.ignorehitrange
        inst.components.combat.ignorehitrange = true
        for k, v in pairs(ents) do 
            inst.components.combat:DoAttack(v, nil, nil, nil, instancemult)
        end
        inst.components.combat.ignorehitrange = old_state
	else
		inst.components.combat:DoAttack(target, nil, nil, nil, instancemult)
	end
end

--生成眼
local function giveeye(inst)
	local x, y, z = inst.Transform:GetWorldPosition()  --上面的移走之后这里要重新启用
    local players = TheSim:FindEntities(x, y, z, 20, {"player"})
	for k, v in pairs(players) do
		local eye = nil
		if v.children ~= nil then
            for m, n in pairs(v.children) do
                if m:HasTag("eye_stormy_judge") then
				    eye = m
				    break
			    end
		    end
		end

		if eye ~= nil then
            eye:Restart()
			local eye_master = eye.components.entitytracker:GetEntity("master")
			if not (eye_master == v) then  --如果队友身上的眼不是自己给自己的，那么就更新眼的主人
				eye.components.entitytracker:ForgetEntity("master")
				eye.components.entitytracker:TrackEntity("master", inst)
			end
		else
            eye = SpawnPrefab("eye_stormy_judge")
			eye:LinkToPlayer(v, inst)
		end
	end
end

--元素战技
local function elementalskillfn(inst)
	if (inst.components.rider and inst.components.rider:IsRiding()) or inst.sg:HasStateTag("dead") then
	    return
	end
	
	if not inst.components.elementalcaster:outofcooldown("elementalskill") then
	    return
	end

	inst:PushEvent("cast_elementalskill")

	inst:DoTaskInTime(14 * FRAMES, function(inst) giveeye(inst) end)

	inst.sg:GoToState("raiden_eleskill")
end

--元素爆发滤镜
local function SetVisionMode(inst, mode)
	if inst.components.playervision == nil then
		return
	end
    if mode then
	    inst.components.playervision:ForceNightVision(true)
        inst.components.playervision:SetCustomCCTable(RAIDEN_ELEBURST_COLOURCUBES)
	else
    	inst.components.playervision:ForceNightVision(false)
        inst.components.playervision:SetCustomCCTable(nil)
	end
end

--元素爆发结束
local function elementalburst_exitfn(inst)
	if inst.burststate == true then
		inst.burststate = false
		SetVisionMode(inst, inst.burststate)
		inst._burststate:set(false)
		inst.gaincount = 0
		inst.resolve_stack = 0
		if inst.components.constellation:GetActivatedLevel() >= 4 then
			raiseattack(inst)
		end
	end

	inst:RemoveTag("stronggrip")
	inst:RemoveTag("nohitanim")
	inst.components.pinnable.canbepinned = true
	inst.components.combat:SetRange(TUNING.DEFAULT_ATTACK_RANGE)
	if inst.components.inventory.isexternallyinsulated then
		inst.components.inventory.isexternallyinsulated:RemoveModifier(inst)
	end

	local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if item ~= nil and item.components.equippable then
		-- function inst.components.inventory:Equip(item) has changed after Klei updated the game, which has caused the weapon 
		-- being removed from hand if it was previously equipped.
		inst.components.inventory:Unequip(item.components.equippable.equipslot)  -- add this to fix that
		-- Thanks Anda and nyoomdoom for their work to find this and fix.
		inst.components.inventory:Equip(item)
	else
		inst.AnimState:ClearOverrideSymbol("swap_object")
		inst.AnimState:Hide("ARM_CARRY")
		inst.AnimState:Show("ARM_NORMAL")
	end
end

--元素爆发(测试)
local function elementalburstfn(inst)
    if (inst.components.rider and inst.components.rider:IsRiding()) or inst.sg:HasStateTag("dead") then
	    return
	end
	
	if not inst.components.elementalcaster:outofcooldown("elementalburst") then
	    return
	end

	if inst.burststate then
		elementalburst_exitfn(inst)
		if inst.exittask ~= nil then
			inst.exittask:Cancel()
			inst.exittask = nil
		end
	end

	inst.burststate = true
	SetVisionMode(inst, inst.burststate)
	if inst.components.inventory.isexternallyinsulated then
		inst.components.inventory.isexternallyinsulated:SetModifier(inst, true)
	end
	inst._burststate:set(true)
	inst.resolve_stack = TakeChakraStack(inst)
	inst.exittask = inst:DoTaskInTime(TUNING.RAIDENSKILL_ELEBURST.DURATION + 2, elementalburst_exitfn)

	inst:AddTag("stronggrip")
	inst:AddTag("nohitanim")
	inst.components.pinnable.canbepinned = false

	inst:PushEvent("cast_elementalburst", {energycost = TUNING.RAIDENSKILL_ELEBURST.ENERGY, element = 4})
	TheWorld:PushEvent("cast_elementalburst", {energycost = TUNING.RAIDENSKILL_ELEBURST.ENERGY, element = 4})

    --这块以后会被sg替代
	inst.sg:GoToState("raiden_eleburst")

end

--固有天赋（充能转雷伤）
local function ElectroBonusChange(inst)
	local rechargeover100 = inst.components.energyrecharge:GetEnergyRecharge() - 1
    local electrobonus = math.max(0.4 * rechargeover100, 0)
	inst.components.combat.external_electro_multipliers:SetModifier(inst, electrobonus, "all_talent1_base")
end

--固有天赋（开大回能）
local function RestoreEnergy(inst, data)
	if data.attackkey ~= "elementalburst" or inst.gaincount > 5 or inst:HasTag("") then
        return
	end
    local rechargeover100 = inst.components.energyrecharge:GetEnergyRecharge() - 1
    local gainbonus = math.max(0.6 * rechargeover100, 0)
	local x, y, z = inst.Transform:GetWorldPosition()
    local players = TheSim:FindEntities(x, y, z, 20, {"player"})
	for k, v in pairs(players) do
		if v.components.energyrecharge then
			v.components.energyrecharge:DoDelta((1 + gainbonus) * TUNING.RAIDENSKILL_ELEBURST.ENERGY_GAIN[inst.components.talents:GetTalentLevel(3)])
		end
		if inst.components.constellation:GetActivatedLevel() >= 6 and v.components.elementalcaster then
			decreasecd(inst, v)
		end
	end
	inst.gaincount = inst.gaincount + 1
end

--生活天赋（返还单手剑和长柄武器50%材料）
local function RefundIngredients(inst, data)
	local recipe = data.recipe
	if recipe == nil then
		return
	end
	
	local issword_or_polearm = false
	for k, v in pairs(TUNING.POLEARM_WEAPONS) do
		if v == recipe.name then
			issword_or_polearm = true
			break
		end
	end
	for k, v in pairs(TUNING.SWORD_WEAPONS) do
		if v == recipe.name then
			issword_or_polearm = true
			break
		end
	end
	if not issword_or_polearm then
		return
	end

	for k, v in pairs(recipe.ingredients) do
		if v.amount > 0 then
			local amt = math.max(1, RoundBiasedUp(v.amount * inst.components.builder.ingredientmod))
			local refund_amt = math.floor(amt / 2)
			for i = 1, refund_amt do
				local item = SpawnPrefab(v.type)
				if item ~= nil then
					inst.components.inventory:GiveItem(item)
				end
			end
		end
	end
end

--技能RPC

AddModRPCHandler("raiden_shogun", "elementalskill", elementalskillfn)
AddModRPCHandler("raiden_shogun", "elementalburst", elementalburstfn)

----------------------------------------------------------------------------

local common_postinit = function(inst) 

	inst.MiniMapEntity:SetIcon( "raiden_shogun.tex" )
	
	--标签
	inst:AddTag("raiden_shogun")
	inst:AddTag("Electro")
	inst:AddTag("genshin_character")

	--会被genshin_core读取的有关信息
	--
	inst.character_description = STRINGS.CHARACTER_DESCRIPTIONS.raiden_shogun
	--命之座相关信息
	inst.constellation_path = "images/ui/constellation_raiden"
	inst.constellation_positions = TUNING.RAIDEN_CONSTELLATION_POSITION
	inst.constellation_decription = TUNING.RAIDEN_CONSTELLATION_DESC
	inst.constellation_starname = "raiden_constellation_star"
	--天赋相关信息
    inst.talents_path = "images/ui/talents_raiden"
	inst.talents_number = 6
	inst.talents_ingredients = TUNING.RAIDEN_TALENTS_INGREDIENTS
	inst.talents_description = TUNING.RAIDEN_TALENTS_DESC
	inst.talents_attributes = {
		value = {
			TUNING.RAIDENSKILL_NORMALATK,
			TUNING.RAIDENSKILL_ELESKILL,
			TUNING.RAIDENSKILL_ELEBURST,
		},
		text = {
			TUNING.RAIDENSKILL_NORMALATK_TEXT,
			TUNING.RAIDENSKILL_ELESKILL_TEXT,
			TUNING.RAIDENSKILL_ELEBURST_TEXT,
		},
		keysort = {
			TUNING.RAIDENSKILL_NORMALATK_SORT,
			TUNING.RAIDENSKILL_ELESKILL_SORT,
			TUNING.RAIDENSKILL_ELEBURST_SORT,
		},
	}
	--资料相关信息
	inst.genshin_profile_addition = {
		STRINGS.CHARACTER_BIOS.raiden_shogun[3],
		STRINGS.CHARACTER_BIOS.raiden_shogun[4],
		{
			title = STRINGS.CHARACTER_BIOS.raiden_shogun[5].title,
			update_fn = function (player)
				return player.components.cookunlocker and player.components.cookunlocker.firepit_experience
					or (player.replica.cookunlocker and player.replica.cookunlocker._firepit_experience:value() or 0)
			end,
			format_fn = function (number)
				local nextexp = -1
				if number < 100 then
					nextexp = 100
				elseif number < 300 then
					nextexp = 300
				elseif number < 700 then
					nextexp = 700
				end
				return nextexp > 0 and string.format("%d / %d", number, nextexp) or string.format("%d (maxlevel)", number)
			end
		},
		{
			title = STRINGS.CHARACTER_BIOS.raiden_shogun[6].title,
			update_fn = function (player)
				return player.components.cookunlocker and player.components.cookunlocker.cookpot_experience
					or (player.replica.cookunlocker and player.replica.cookunlocker._cookpot_experience:value() or 0)
			end,
			format_fn = function (number)
				local nextexp = -1
				if number < 150 then
					nextexp = 150
				elseif number < 450 then
					nextexp = 450
				elseif number < 1050 then
					nextexp = 1050
				end
				return nextexp > 0 and string.format("%d / %d", number, nextexp) or string.format("%d (maxlevel)", number)
			end
		},
		{
			title = STRINGS.CHARACTER_BIOS.raiden_shogun[7].title,
			update_fn = function (player)
				return player.components.cookunlocker and player.components.cookunlocker.mastercook_experience
					or (player.replica.cookunlocker and player.replica.cookunlocker._mastercook_experience:value() or 0)
			end,
			format_fn = function (number)
				local nextexp = -1
				if number < 2000 then
					nextexp = 2000
				end
				return nextexp > 0 and string.format("%d / %d", number, nextexp) or string.format("%d (maxlevel)", number)
			end
		}
	}
	
	--添加显示血量组件和键位设置器
	
	inst:AddComponent("keyhandler_raiden")
	inst.components.keyhandler_raiden:SetSkillKeys(skillkeys)
	--释放
	inst.components.keyhandler_raiden:AddActionListener(TUNING.ELEMENTALSKILL_KEY, {Namespace = "raiden_shogun", Action = "elementalskill"}, "keyup", nil, false)
	inst.components.keyhandler_raiden:AddActionListener(TUNING.ELEMENTALBURST_KEY, {Namespace = "raiden_shogun", Action = "elementalburst"}, "keyup", nil, false)

    ----------------------------------------------------------------------------
    --状态
    inst.burststate = false
	--网络变量
	inst._burststate = net_bool(inst.GUID, "raiden._burststate", "statedirty")
	--不是主机
	if not TheWorld.ismastersim then
		inst:ListenForEvent("statedirty", function(inst) 
			inst.burststate = inst._burststate:value() 
			SetVisionMode(inst, inst.burststate)
		end)
	end
	----------------------------------------------------------------------------
	--inst.chargesgname = "raiden_chargeattack"
	inst.chargesgname = ChargeSGFn

	inst:DoPeriodicTask(0, function(inst) inst.AnimState:Show("HAIR_HAT") end)
end

local master_postinit = function(inst)

	inst.soundsname = "willow"

    --计数
	inst.gaincount = 0
	inst.resolve_stack = 0
	
	--energyrecharge和talents会在playerpostinit里面添加，但是却比这里更晚？？太怪了，得重新加
    --添加元素充能
    inst:AddComponent("energyrecharge")
	inst.components.energyrecharge:SetMax(TUNING.RAIDENSKILL_ELEBURST.ENERGY)

	--设置元素战技和元素爆发施放
	inst:AddComponent("elementalcaster")
	inst.components.elementalcaster:SetElementalSkill(TUNING.RAIDENSKILL_ELESKILL.CD)
	inst.components.elementalcaster:SetElementalBurst(TUNING.RAIDENSKILL_ELEBURST.CD, TUNING.RAIDENSKILL_ELEBURST.ENERGY)

	--天赋
	inst:AddComponent("talents")

	--命之座
	inst:AddComponent("constellation")
	--1命效果不写在这里
	inst.components.constellation:SetLevelFunc(2, constellation_func2)
	inst.components.constellation:SetLevelFunc(3, constellation_func3)
	inst.components.constellation:SetLevelFunc(5, constellation_func5)

	--做饭的学习之路
	inst:AddComponent("cookunlocker")

	--添加其他组件
	inst:AddComponent("entitytracker")
	
    --设置三维
	inst.components.health:SetMaxHealth(TUNING.RAIDEN_SHOGUN_HEALTH)
	inst.components.hunger:SetMax(TUNING.RAIDEN_SHOGUN_HUNGER)
	inst.components.sanity:SetMax(TUNING.RAIDEN_SHOGUN_SANITY)

	--设置其他属性
	inst.components.combat:SetDefaultDamage(TUNING.RAIDEN_SHOGUN_BASEATK)
	inst.components.combat.damagemultiplier = 1
	inst.components.hunger.hungerrate = TUNING.RAIDEN_HUNGER_RATE * TUNING.WILSON_HUNGER_RATE
	inst.components.energyrecharge.recharge = 1.32

	inst.components.foodaffinity:AddFoodtypeAffinity(FOODTYPE.GOODIES, 1.33)

	inst.components.combat:SetOverrideAttackkeyFn(AttackkeyFn)
	inst.components.combat:SetOverrideStimuliFn(StimuliFn)
	
    --监听器
	inst:ListenForEvent("energyrecharge_change", ElectroBonusChange)
	inst:ListenForEvent("damagecalculated", RestoreEnergy)
	inst:ListenForEvent("builditem", RefundIngredients)
	inst:ListenForEvent("death", OnDeath)
	--
	
	--函数
	inst.OnDespawn = OnDespawn
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
    inst.OnNewSpawn = OnLoad

	inst.normalattackdmgratefn = NormalATKRateFn
	inst.chargeattackdmgratefn = ChargeATKRateFn

	inst.customattackfn = CustomAttackFn

	inst.elementalburst_exit = elementalburst_exitfn

	OnBecameHuman(inst)
    
end

return MakePlayerCharacter("raiden_shogun", prefabs, assets, common_postinit, master_postinit, start_inv)