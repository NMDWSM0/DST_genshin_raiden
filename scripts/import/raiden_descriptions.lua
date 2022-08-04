--有几个函数我要先给一下
local function plainfloatfunc(num)  --直接写,浮点
    return string.format("%.1f", num) 
end

local function plainintfunc(num)    --直接写,整数
    return string.format("%d", num) 
end
local plainfunc = plainfloatfunc

local function dmgmultfunc(num)  --攻击倍率通用模板函数
    return string.format("%.1f%%", 100 * num) 
end
local dmgmultfunc_sc = dmgmultfunc
local dmgmultfunc_en = dmgmultfunc

local function timefunc(num)  --时间通用模板函数
    return string.format("%.1f秒", num) 
end
local function timefunc_en(num)
    return string.format("%.1fs", num) 
end
local timefunc_sc = timefunc

STRINGS.CHARACTERS.RAIDEN_SHOGUN = require "speech_wilson"

if TUNING.LANGUAGE_GENSHIN_RAIDEN == "sc" then
    --基本描述
    STRINGS.CHARACTER_TITLES.raiden_shogun = "尘世七执政•雷之神"
    STRINGS.CHARACTER_NAMES.raiden_shogun = "雷电将军"
    STRINGS.CHARACTER_DESCRIPTIONS.raiden_shogun = "其身为御建鸣神主尊大御所大人\n许稻妻人民以亘古不变之【永恒】\n"
    STRINGS.CHARACTER_QUOTES.raiden_shogun = "\"此身即是尘世最为殊胜尊贵之身\n应持天下之大权。\""

    STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAIDEN_SHOGUN = 
    {
	    GENERIC = "那是雷电将军!",
	    ATTACKER = "她看上去很...",
	    MURDERER = "杀人者!",
	    REVIVER = "她.",
	    GHOST = "她.",
    }

    STRINGS.NAMES.RAIDEN_SHOGUN = "雷电将军"

    --技能文本
    TUNING.RAIDEN_CONSTELLATION_DESC = {
        titlename = {
            "恶曜卜词",
            "斩铁断金",
            "真影旧事",
            "誓奉常道",
            "凶将显形",
            "负愿前行",
        },
        content = {
            "诸愿百眼之轮能更加迅速地积攒愿力。元素类型为雷元素的角色施放元素爆发后，积攒的愿力提升80%；其他元素类型的角色施放元素爆发后，积攒的愿力提升20%。",
            "奥义•梦想真说的梦想一刀与梦想一心状态下的雷电将军的攻击将无视敌人60%的防御力。",
            "奥义•梦想真说的技能等级提高3级。\n至多提升至15级。",
            "奥义•梦想真说施加的梦想一心状态结束后，附近的队伍中所有角色的攻击力提升30%，持续10秒。",
            "神变•恶曜开眼的技能等级提高3级。\n至多提升至15级。",
            "处于奥义•梦想真说施加的梦想一心状态下时，雷电将军的元素爆发伤害命中敌人时，使附近的队伍中所有角色元素爆发的冷却时间缩短1秒。该效果每1秒至多触发一次，在持续期间内至多触发5次。",
        },
    }

    TUNING.RAIDEN_TALENTS_DESC = {
		titlename = {
            "普通攻击•源流",
            "神变•恶曜开眼",
            "奥义•梦想真说",
            "万千的愿望",
            "殊胜之御体",
            "天下名物狩",
        },
        content = {
            {
                {str = "普通攻击", title = true},
                {str = "进行连续枪击。", title = false},
                {str = "重击", title = true},
                {str = "消耗一定体力，进行向上的挑斩攻击。", title = false},
            },
            {
                {str = "雷电将军展开净土的一角，对周围的敌人造成雷元素伤害，为队伍中附近的所有角色授以「雷罚恶曜之眼」。", title = false},
                {str = "雷罚恶曜之眼", title = true},
                {str = "•获授雷罚恶曜之眼的角色的攻击对敌人造成伤害时，雷罚恶曜之眼会进行协同攻击，在敌人的位置造成雷元素范围伤害。\n•获授雷罚恶曜之眼的角色在持续期间内，元素爆发造成的伤害获得提升，提升程度基于元素爆发的元素能量。\n每个队伍的雷罚恶曜之眼，每0.9秒至多进行一次协同攻击。\n由队伍中自己的角色以外的角色触发的协同攻击造成的伤害为原本的20%。", title = false},
            },
            {
                {str = "汇聚万千真言，竭尽诸愿百眼之愿力，斩出粉碎一切诅咒的梦想一刀，造成雷元素范围伤害；并在接下来的一段时间内，使用「梦想一心」战斗。依据施放时消耗的诸愿百眼之轮的愿力层数，增加梦想一刀与梦想一心的攻击造成的伤害。", title = false},
                {str = "梦想一心", title = true},
                {str = "在此状态下，雷电将军将使用刀进行攻击，并将普通攻击与重击造成的伤害转为无法被附魔覆盖的雷元素伤害，并在这些攻击命中敌人时，为队伍中附近的所有角色恢复元素能量。每1秒至多通过这种方式恢复一次元素能量，在持续期间内至多触发5次。\n梦想一心状态下，雷电将军的普通攻击与重击造成的伤害，视为元素爆发伤害。", title = false},
                {str = "诸愿百眼之轮", title = true},
                {str = "队伍中附近的角色施放元素爆发时，会依据元素爆发的元素能量，为雷电将军的诸愿百眼之轮积攒愿力。\n至多积攒60层愿力。", title = false},
            },
            {
                {str = "队伍中附近的角色获得元素晶球或元素微粒时，会为诸愿百眼之轮积攒2层愿力。\n该效果每3秒至多触发一次。" , title = false},
            },
            {
                {str = "基于元素充能效率超过100%的部分，每1%使雷电将军获 得下列效果：\n•梦想一心状态提供的元素能量恢复提高0.6%；\n•雷元素伤害加成提升0.4%。", title = false},
            },
            {
                {str = "制造单手剑和长柄武器时，消耗的材料数量减少50%。", title = false},
            },
			{
                {str = "?", title = false},
            },
        },
	}

    TUNING.RAIDENSKILL_NORMALATK_TEXT = 
    {
        ATK_DMG = {
            title = "普通攻击伤害", 
            formula = dmgmultfunc,
        },
        CHARGE_ATK_DMG = {
            title = "重击伤害", 
            formula = dmgmultfunc,
        },
    }

    TUNING.RAIDENSKILL_ELESKILL_TEXT = 
    {
        DMG = {
            title = "技能伤害",
            formula = dmgmultfunc,
        },
        CO_DMG = {
            title = "协同攻击伤害",
            formula = dmgmultfunc,
        },
        DURATION = {
            title = "持续时间",
            formula = timefunc,
        },
        ELEBURST_BONUS = {
            title = "元素爆发伤害提高",
            formula = function(num)  
                return string.format("每点元素能量%.2f%%", 100 * num) 
            end,
        },
        CD = {
            title = "冷却时间",
            formula = timefunc,
        },
    }

    TUNING.RAIDENSKILL_ELEBURST_TEXT = 
    {
        DMG = {
            title = "梦想一刀基础伤害", 
            formula = dmgmultfunc,
        },
        RESOLVE_BONUS = {
            title = "梦想一刀愿力加成", 
            formula = function(num)  
                return string.format("每层%.2f%%攻击力", 100 * num) 
            end,
        },
        ATK_RESOLVE_BONUS = {
            title = "梦想一心愿力加成", 
            formula = function(num)  
                return string.format("每层%.2f%%攻击力", 100 * num) 
            end,
        },
        RESOLVE_GAIN = {
            title = "积攒愿力层数", 
            formula = function(num)  
                return string.format("每点元素能量%.2f", num) 
            end,
        },
        ATK_DMG = {
            title = "普通攻击伤害", 
            formula = dmgmultfunc,
        },
        CHARGE_ATK_DMG = {
            title = "重击伤害", 
            formula = dmgmultfunc,
        },
        ENERGY_GAIN = {
            title = "梦想一心能量恢复", 
            formula = plainfloatfunc,
        },
        DURATION = {
            title = "梦想一心持续时间", 
            formula = timefunc,
        },
        CD = {
            title = "冷却时间",
            formula = timefunc,
        },
        ENERGY = {
            title = "元素能量",
            formula = plainintfunc,
        },
    }

    --其它文本
    STRINGS.CHARACTERS.RAIDEN_SHOGUN.ACTIONFAIL.COOK = "你不要让我做饭啦。我什么都能办到，但是真的不会做饭。"

    STRINGS.RAIDEN_FIREPIT_LEVEL_UPGRADE = {
        "好吧，我答应尝试一下那堆火。",
        "在我看来，火焰应该变得更加听话一点。",
        "感觉烤制食物，有时候也没有那么难...",
        "现在我能感觉火焰的魔力了，真该感谢写下这本书的人呢。",
    }

    STRINGS.RAIDEN_COOKPOT_LEVEL_UPGRADE = {
        "使用锅这种事情，需要极大的决心和勇气。",
        "做饭什么的，确实比武斗困难许多。",
        "虽然有时也会失误，但是我感觉料理的知识正在逐渐丰富呢。",
        "今后，可以自己做想吃的甜点心了，真是值得纪念的一天。",
    }

    STRINGS.RAIDEN_SPICER_LEVEL_UPGRADE = {
        "如此神奇的一整套料理教程，究竟是谁的力量呢？希望有一天能见过这位前辈呢。",
    }

    STRINGS.RAIDEN_COOK_RAW = "这份，没熟透。"

    STRINGS.RAIDEN_COOK_BURNT = "看来用力过猛了。"

    STRINGS.RAIDEN_STEW_FAIL = "嗯，技巧上还有点小问题。"

    STRINGS.RAIDEN_STEW_EXPLODE = "啊，怎么又这样，一定是mhy干的乆乆乆"

    STRINGS.USE_RAIDENCOOKBOOK_FAIL = {
        IS_STUDYING = "我正在向书中的异界厨神学习其他技能。",
        INVALID_LEVEL = "invalid_level_to_unlock",
        MAX_LEVEL = "厨神说在这方面她已经没有能教给我的了",
        ERROR_ORDER = "异界的厨神说我现在还不能学习那个技能。",
    }

    STRINGS.USE_RAIDENCOOKBOOK_SUCCEED = "感受到一股力量，她想要教会我料理。"

    STRINGS.RAIDENCOOKBOOK_TIMEOVER = "书给予我的力量衰弱了，我也许应该再读读它。"

    TUNING.GENSHIN_ACTION_READCOOKBOOK = "阅读"

    --食物相关
    STRINGS.NAMES.SPICE_AMAKUMO_FOOD = "酥酥麻麻的{food}"
    STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ATTACH_BUFF_AMAKUMOEATEN = "身上的雷元素变得暴躁起来了。"
    STRINGS.CHARACTERS.GENERIC.ANNOUNCE_DETACH_BUFF_AMAKUMOEATEN = "身上的雷元素又安分下来了。"

    STRINGS.CANNOTUSE_SPICE_AMAKUMO = "这个食物不可以用天云草实粉调味吧。"

    STRINGS.NAMES.SPICE_AMAKUMO = "天云草实粉"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPICE_AMAKUMO = "使用天云草实制成的调味品，闻起来有点雷电的味道。"
    STRINGS.RECIPE_DESC.SPICE_AMAKUMO = "提高雷元素的活跃性！"

    STRINGS.NAMES.TRICOLORDANGO = "三彩团子"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRICOLORDANGO = "软糯弹牙的点心，团子上的光泽犹如晨露落于朝花之上。"

    STRINGS.NAMES.DANGOMILK = "团子牛奶"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.DANGOMILK = "将粘稠的团子加入牛奶而制成的创意饮品，滋味甜美，口感绵密。"

    STRINGS.NAMES.RAINBOWASTER = "紫苑云霓"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAINBOWASTER = "别具一格的饮品，难怪书中生病了的将军大人喝完后也会打起精神。"

    STRINGS.NAMES.ADJUDICATETIME = "裁决之时"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ADJUDICATETIME = "雷电将军的特色料理，传说落一滴于地，只令得周围数百里千年寸草不生。"

    --物品描述
    STRINGS.NAMES.ENGULFINGLIGHTNING = "薙草之稻光"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ENGULFINGLIGHTNING = "用于【斩草】的薙刀。对向此物之军势,也会如苇草般倒下吧..."
    STRINGS.RECIPE_DESC.ENGULFINGLIGHTNING = "用于【斩草】的薙刀"
	TUNING.WEAPONEFFECT_ENGULFINGLIGHTNING = {
        "非时之梦•常世灶食\n•攻击力获得提升,提升程度相当于元素充能效率超出100%部分的28%,至多通过这种方式提升80%。施放元素爆发后的12秒内,元素充能效率提升30%。",
        "非时之梦•常世灶食\n•攻击力获得提升,提升程度相当于元素充能效率超出100%部分的35%,至多通过这种方式提升90%。施放元素爆发后的12秒内,元素充能效率提升35%。",
        "非时之梦•常世灶食\n•攻击力获得提升,提升程度相当于元素充能效率超出100%部分的42%,至多通过这种方式提升100%。施放元素爆发后的12秒内,元素充能效率提升40%。",
        "非时之梦•常世灶食\n•攻击力获得提升,提升程度相当于元素充能效率超出100%部分的49%,至多通过这种方式提升110%。施放元素爆发后的12秒内,元素充能效率提升45%。",
        "非时之梦•常世灶食\n•攻击力获得提升,提升程度相当于元素充能效率超出100%部分的56%,至多通过这种方式提升120%。施放元素爆发后的12秒内,元素充能效率提升50%。",
    }

    STRINGS.NAMES.FAVONIUSLANCE = "西风长枪"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FAVONIUSLANCE = "西风骑士团的制式长枪。枪杆直挺，枪尖轻风流溢。"
    STRINGS.RECIPE_DESC.FAVONIUSLANCE = "西风骑士团的制式长枪"
	TUNING.WEAPONEFFECT_FAVONIUSLANCE = {
        "顺风而行\n•攻击造成暴击时，有60%的概率产生少量元素微粒。能为角色恢复6点元素能量。该效果每12秒只能触发一次。",
        "顺风而行\n•攻击造成暴击时，有70%的概率产生少量元素微粒。能为角色恢复6点元素能量。该效果每10.5秒只能触发一次。",
        "顺风而行\n•攻击造成暴击时，有80%的概率产生少量元素微粒。能为角色恢复6点元素能量。该效果每9秒只能触发一次。",
        "顺风而行\n•攻击造成暴击时，有90%的概率产生少量元素微粒。能为角色恢复6点元素能量。该效果每7.5秒只能触发一次。",
        "顺风而行\n•攻击造成暴击时，有100%的概率产生少量元素微粒。能为角色恢复6点元素能量。该效果每6秒只能触发一次。",
    }

    STRINGS.NAMES.THECATCH = "【渔获】"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.THECATCH = "在久远的过去，曾经闻名稻妻的大盗爱用的枪。"
    STRINGS.RECIPE_DESC.THECATCH = "在久远的过去，曾经闻名稻妻的大盗爱用的枪"
	TUNING.WEAPONEFFECT_THECATCH = {
        "船歌\n•元素爆发造成的伤害提升16%，元素爆发的暴击率提升6%。",
        "船歌\n•元素爆发造成的伤害提升20%，元素爆发的暴击率提升7.5%。",
        "船歌\n•元素爆发造成的伤害提升24%，元素爆发的暴击率提升9%。",
        "船歌\n•元素爆发造成的伤害提升28%，元素爆发的暴击率提升10.5%。",
        "船歌\n•元素爆发造成的伤害提升32%，元素爆发的暴击率提升12%。",
    }
    STRINGS.NAMES.AKO_SAKE_VESSEL = "赤穗酒枡"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.AKO_SAKE_VESSEL = "过去称霸清籁地方的赤穗百目鬼一众爱用的酒具"
    STRINGS.RECIPE_DESC.AKO_SAKE_VESSEL = "【渔获】专用的精炼道具"

    STRINGS.NAMES.RAIDEN_CONSTELLATION_STAR = "雷电将军的命星"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAIDEN_CONSTELLATION_STAR = "雷电将军的命之座激活素材"
    STRINGS.RECIPE_DESC.RAIDEN_CONSTELLATION_STAR = "雷电将军的命之座激活素材"

    STRINGS.NAMES.CROWN_OF_INSIGHT = "智识之冕"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROWN_OF_INSIGHT = "提升天赋所需的珍贵素材。"

    STRINGS.NAMES.BOOK_FIREPIT = "异世界厨神的烤制教学"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_FIREPIT = "有种神秘的力量，能教会人做饭，甚至还能感受到一丝雷元素？"
    STRINGS.RECIPE_DESC.BOOK_FIREPIT = "制作一本能教人烤制的书"

    STRINGS.NAMES.BOOK_COOKPOT = "异世界厨神的炉灶教学"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_COOKPOT = "有种神秘的力量，能教会人做饭，甚至还能感受到一丝雷元素？"
    STRINGS.RECIPE_DESC.BOOK_COOKPOT = "制作一本能教人使用炉灶的书"

    STRINGS.NAMES.BOOK_SPICER = "异世界厨神的香料教学"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_SPICER = "有种神秘的力量，能教会人做饭，甚至还能感受到一丝雷元素？"
    STRINGS.RECIPE_DESC.BOOK_SPICER = "制作一本能教人调和香料的书"

    STRINGS.NAMES.AMAKUMO_FRUIT = "天云草实"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.AMAKUMO_FRUIT = "天云草结成的果实，贴在耳畔能听见微弱的电流声。"

    STRINGS.NAMES.AMAKUMO_GRASS = "天云草"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.AMAKUMO_GRASS = "原本生长在天云峠的植物，不知为什么出现在了这里。"

else
    --基本描述
    STRINGS.CHARACTER_TITLES.raiden_shogun = "The Seven:Electro Archon"
    STRINGS.CHARACTER_NAMES.raiden_shogun = "Raiden Shogun"
    STRINGS.CHARACTER_DESCRIPTIONS.raiden_shogun = "Her Excellency, the Almighty Narukami Ogosho,\nwho promised the people of Inazuma an unchanging Eternity."
    STRINGS.CHARACTER_QUOTES.raiden_shogun = "\"Mine is the most supreme and noble form, let power over the realm be vested within me.\""

    STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAIDEN_SHOGUN = 
    {
	    GENERIC = "It's Raiden Shogun!",
	    ATTACKER = "That Raiden Shogun looks shifty...",
	    MURDERER = "Murderer!",
	    REVIVER = "Raiden Shogun, friend of ghosts.",
	    GHOST = "Raiden Shogun could use a heart.",
    }

    STRINGS.NAMES.RAIDEN_SHOGUN = "Raiden Shogun"

    --技能文本
    TUNING.RAIDEN_CONSTELLATION_DESC = {
        titlename = {
            "Ominous Inscription",
            "Steelbreaker",
            "Shinkage Bygones",
            "Pledge of Propriety",
            "Shogun's Descent",
            "Wishbearer",
        },
        content = {
            "Chakra Desiderata will gather Resolve even faster. When Electro characters use their Elemental Bursts, the Resolve gained is increased by 80%. When characters of other Elemental Types use their Elemental Bursts, the Resolve gained is increased by 20%.",
            "While using Musou no Hitotachi and in the Musou Isshin state applied by Secret Art: Musou Shinsetsu, the Raiden Shogun's attacks ignore 60% of opponents' DEF.",
            "Increases the Level of Secret Art: Musou Shinsetsu by 3.\nMaximum upgrade level is 15.",
            "When the Musou Isshin state applied by Secret Art: Musou Shinsetsu expires, all nearby party members gain 30% bonus ATK for 10s.",
            "Increases the Level of Transcendence: Baleful Omen by 3.\nMaximum upgrade level is 15.",
            "While in the Musou Isshin state applied by Secret Art: Musou Shinsetsu, attacks by the Raiden Shogun that are considered part of her Elemental Burst will decrease all nearby party members' Elemental Burst CD by is when they hit opponents. This effect can trigger once every 1s and can trigger a total of 5 times during Musou Isshin's duration.",
        },
    }

    TUNING.RAIDEN_TALENTS_DESC = {
		titlename = {
            "Normal Attack: Origin",
            "Transcendence: Baleful Omen",
            "Secret Art: Musou Shinsetsu",
            "Wishes Unnumbered",
            "Enlightened One",
            "All-Preserver",
        },
        content = {
            {
                {str = "Normal Attack", title = true},
                {str = "Performs consecutive spear strikes.", title = false},
                {str = "Charged Attack", title = true},
                {str = "Perform an upward slash.", title = false},
            },
            {
                {str = "The Raiden Shogun unveils a shard of her Euthymia, dealing Electro DMG to nearby opponents, and granting nearby party members the Eye of Stormy Judgment.", title = false},
                {str = "Eye of Stormy Judgement", title = true},
                {str = "•When characters with this buff attack and deal DMG to opponents, the Eye will unleash a coordinated attack, dealing AoE Electro DMG at the opponent's position.\n•Characters who gain the Eye of Stormy Judgment will have their Elemental Burst DMG increased based on the Energy Cost of the Elemental Burst during the Eye's duration.\nThe Eye can initiate one coordinated attack every 0.9s per party.\nCoordinated attacks generated by characters not controlled by you deal 20% of the normal DMG.", title = false},
            },
            {
                {str = "Gathering truths unnumbered and wishes uncounted, the Raiden Shogun unleashes the Musou no Hitotachi and deals AoE Electro DMG, using Musou Isshin in combat for a certain duration afterward. The DMG dealt by Musou no Hitotachi and Musou Isshin's attacks will be increased based on the number of Chakra Desiderata's Resolve stacks consumed when this skill is used.", title = false},
                {str = "Musou Isshin", title = true},
                {str = "While in this state, the Raiden Shogun will wield her tachi in battle, while her Normal and Charged Attacks will be infused with Electro DMG which cannot be overridden. When such attacks hit opponents, she will regenerate Energy for all nearby party members. Energy can be restored this way once every ls, and this effect can be triggered 5 times throughout this skill's duration.\nWhile Musou Isshin is active, the Raiden Shogun's Normal and Charged Attack DMG will be considered Elemental Burst DMG.", title = false},
                {str = "Chakra Desiderata", title = true},
                {str = "When nearby party members use their Elemental Bursts the Raiden Shogun will build up Resolve stacks based on the Energy Cost of these Elemental Bursts.\nThe maximum number of Resolve stacks is 60.", title = false},
            },
            {
                {str = "When nearby party members gain Elemental Orbs or Particles, Chakra Desiderata gains 2 Resolve stacks. This effect can occur once every 3s" , title = false},
            },
            {
                {str = "Each 1% above 100% Energy Recharge that the Raiden Shogun possesses grants her:\n• 0.6% greater Energy restoration from Musou Isshin\n• 0.4% Electro DMG Bonus.", title = false},
            },
            {
                {str = "Ingredients expended when crafting Swords and Polearms is decreased by 50%.", title = false},
            },
			{
                {str = "?", title = false},
            },
        },
	}

    TUNING.RAIDENSKILL_NORMALATK_TEXT = 
    {
        ATK_DMG = {
            title = "Normal Attack DMG", 
            formula = dmgmultfunc,
        },
        CHARGE_ATK_DMG = {
            title = "Charged Attack DMG", 
            formula = dmgmultfunc,
        },
    }

    TUNING.RAIDENSKILL_ELESKILL_TEXT = 
    {
        DMG = {
            title = "Skill DMG",
            formula = dmgmultfunc,
        },
        CO_DMG = {
            title = "Coordinated ATK DMG",
            formula = dmgmultfunc,
        },
        DURATION = {
            title = "Duration",
            formula = timefunc_en,
        },
        ELEBURST_BONUS = {
            title = "Elemental Burst DMG\nBonus",
            formula = function(num)  
                return string.format("%.2f%% Per\nEnergy", 100 * num) 
            end,
        },
        CD = {
            title = "CD",
            formula = timefunc_en,
        },
    }

    TUNING.RAIDENSKILL_ELEBURST_TEXT = 
    {
        DMG = {
            title = "Musou no Hitotachi\nBase DMG", 
            formula = dmgmultfunc,
        },
        RESOLVE_BONUS = {
            title = "Resolve Bonus", 
            formula = function(num)  
                return string.format("%.2f%% Per Stack", 100 * num) 
            end,
        },
        ATK_RESOLVE_BONUS = {
            title = "Resolve Bonus(ATK DMG)", 
            formula = function(num)  
                return string.format("%.2f%% Per Stack", 100 * num) 
            end,
        },
        RESOLVE_GAIN = {
            title = "Resolve Stacks Gained", 
            formula = function(num)  
                return string.format("%.2f Per Energy\nConsumed", num) 
            end,
        },
        ATK_DMG = {
            title = "Normal Attack DMG", 
            formula = dmgmultfunc,
        },
        CHARGE_ATK_DMG = {
            title = "Charged Attack DMG", 
            formula = dmgmultfunc,
        },
        ENERGY_GAIN = {
            title = "Musou Isshin Energy\nRestoration", 
            formula = plainfloatfunc,
        },
        DURATION = {
            title = "Musou Isshin Duartion", 
            formula = timefunc_en,
        },
        CD = {
            title = "CD",
            formula = timefunc_en,
        },
        ENERGY = {
            title = "Energy Cost",
            formula = plainintfunc,
        },
    }


    --其它文本
    STRINGS.CHARACTERS.RAIDEN_SHOGUN.ACTIONFAIL.COOK = "Don't try and get me to cook. I can take care of anything else, but not that."

    STRINGS.RAIDEN_FIREPIT_LEVEL_UPGRADE = {
        "OK, I'll try the fire later.",
        "Flames should be more domestic.",
        "Sometimes I even consider roasting to be not that hard...",
        "It's miraculous when I control the flames.Thanks to who write this book.",
    }

    STRINGS.RAIDEN_COOKPOT_LEVEL_UPGRADE = {
        "Using cookpot requires determination and bravery.",
        "Cooking is pretty harder than Fighting, in my opinion.",
        "The knowledge of cooking is becoming plentiful regardless of some accidental mistakes",
        "I can bake my favorite desserts by myself from no on.What a memorial day.",
    }

    STRINGS.RAIDEN_SPICER_LEVEL_UPGRADE = {
        "These are a set of miraculous cooking courses.Who onearth is the author?I wish I can visit this senior some day.",
    }

    STRINGS.RAIDEN_COOK_RAW = "It's raw..."

    STRINGS.RAIDEN_COOK_BURNT = "I accidentally overcook it."

    STRINGS.RAIDEN_STEW_FAIL = "Eh, there're some questions in the skill."

    STRINGS.RAIDEN_STEW_EXPLODE = "Oh, why does this happen so frequently!"

    STRINGS.USE_RAIDENCOOKBOOK_FAIL = {
        IS_STUDYING = "I'm learning other skills from the professional chef from other world.",
        INVALID_LEVEL = "invalid_level_to_unlock",
        MAX_LEVEL = "The professional chef have nothing to teach me in this field now.",
        ERROR_ORDER = "She says that I'm not qualified to learn that now.",
    }

    STRINGS.USE_RAIDENCOOKBOOK_SUCCEED = "I can feel someone want to teach me cooking."

    STRINGS.RAIDENCOOKBOOK_TIMEOVER = "Power from the book has weakened, I should read that book again."

    TUNING.GENSHIN_ACTION_READCOOKBOOK = "Read"

    --食物相关
    STRINGS.NAMES.SPICE_AMAKUMO_FOOD = "Tingling {food}"
    STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ATTACH_BUFF_AMAKUMOEATEN = "I can feel Electro element becoming active."
    STRINGS.CHARACTERS.GENERIC.ANNOUNCE_DETACH_BUFF_AMAKUMOEATEN = "Electro element returns stable now."

    STRINGS.NAMES.SPICE_AMAKUMO = "Amakumo Spice"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPICE_AMAKUMO = "Spice made of Amakumo fruit.You can even smell Electro element."
    STRINGS.RECIPE_DESC.SPICE_AMAKUMO = "Make Electro element more active!"

    STRINGS.CANNOTUSE_SPICE_AMAKUMO = "This food cannot spiced by Amakumo Spice."

    STRINGS.NAMES.TRICOLORDANGO = "Tricolor Dango"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRICOLORDANGO = "A soft,glutinous snack.The luster of this dango is like the falling morning dew,and it gives off the feeling of lush flowres and branches."

    STRINGS.NAMES.DANGOMILK = "Dango Milk"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.DANGOMILK = "A creative snack made by adding sticky dango to milk.It is sweet and have a dence mouthfeel."

    STRINGS.NAMES.RAINBOWASTER = "Rainbow Aster"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAINBOWASTER = "A unique drink.It is utterly unsurprising that the ill Shogun in the tale war re-energized by the merits of this drink alone."

    STRINGS.NAMES.ADJUDICATETIME = "Adjudicate Time"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ADJUDICATETIME = "Raiden shogun's specialty.It is said that if dropped on the ground then it will be barren hundred miles around for thousands of years."

    --物品描述
    STRINGS.NAMES.ENGULFINGLIGHTNING = "Engulfing Lightning"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ENGULFINGLIGHTNING = "A naginata used to \"cut grass.\" Any army that stands before this weapon will probably be likewise cut down..."
    STRINGS.RECIPE_DESC.ENGULFINGLIGHTNING = "A naginata used to \"cut grass.\""
	TUNING.WEAPONEFFECT_ENGULFINGLIGHTNING = {
        "Timeless Dream:Eternal Stove\n•ATK increased by 28% of Energy Recharge over the base 100%.You can gain a maximum bonus of 80% ATK.Gain 30% Energy Recharge for 12s after using an Elemental Burst.",
        "Timeless Dream:Eternal Stove\n•ATK increased by 35% of Energy Recharge over the base 100%.You can gain a maximum bonus of 90% ATK.Gain 35% Energy Recharge for 12s after using an Elemental Burst.",
        "Timeless Dream:Eternal Stove\n•ATK increased by 42% of Energy Recharge over the base 100%.You can gain a maximum bonus of 100% ATK.Gain 40% Energy Recharge for 12s after using an Elemental Burst.",
        "Timeless Dream:Eternal Stove\n•ATK increased by 49% of Energy Recharge over the base 100%.You can gain a maximum bonus of 110% ATK.Gain 45% Energy Recharge for 12s after using an Elemental Burst.",
        "Timeless Dream:Eternal Stove\n•ATK increased by 56% of Energy Recharge over the base 100%.You can gain a maximum bonus of 120% ATK.Gain 50% Energy Recharge for 12s after using an Elemental Burst.",
    }

    STRINGS.NAMES.FAVONIUSLANCE = "Favonius Lance"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FAVONIUSLANCE = "A polearm made in the style of the Knights of Favonius. Its shaft is straight, and its tip flows lightlty like the wind."
    STRINGS.RECIPE_DESC.FAVONIUSLANCE = "A polearm made in the style of the Knights of Favonius"
	TUNING.WEAPONEFFECT_FAVONIUSLANCE = {
        "Windfall\n•CRIT Hits have a 60% chance to generate a small amount of Elemental Particles, which will regenerate 6 Energy for the character.Can only occur once every 12s.",
        "Windfall\n•CRIT Hits have a 70% chance to generate a small amount of Elemental Particles, which will regenerate 6 Energy for the character.Can only occur once every 10.5s.",
        "Windfall\n•CRIT Hits have a 80% chance to generate a small amount of Elemental Particles, which will regenerate 6 Energy for the character.Can only occur once every 9s.",
        "Windfall\n•CRIT Hits have a 90% chance to generate a small amount of Elemental Particles, which will regenerate 6 Energy for the character.Can only occur once every 7.5s.",
        "Windfall\n•CRIT Hits have a 100% chance to generate a small amount of Elemental Particles, which will regenerate 6 Energy for the character.Can only occur once every 6s.",
    }

    STRINGS.NAMES.THECATCH = "\"The Catch\""
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.THECATCH = "In the distant past, this was the beloved spear of a famed Inazuman bandit."
    STRINGS.RECIPE_DESC.THECATCH = "The beloved spear of a famed Inazuman bandit"
	TUNING.WEAPONEFFECT_THECATCH = {
        "Shanty\n•Increases Elemental Burst DMG by 16% and Elemental Burst CRIT Rate by 6%.",
        "Shanty\n•Increases Elemental Burst DMG by 20% and Elemental Burst CRIT Rate by 7.5%.",
        "Shanty\n•Increases Elemental Burst DMG by 24% and Elemental Burst CRIT Rate by 9%.",
        "Shanty\n•Increases Elemental Burst DMG by 28% and Elemental Burst CRIT Rate by 10.5%.",
        "Shanty\n•Increases Elemental Burst DMG by 32% and Elemental Burst CRIT Rate by 12%.",
    }
    STRINGS.NAMES.AKO_SAKE_VESSEL = "Ako’s Sake Vessel"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.AKO_SAKE_VESSEL = "This was the favored liquor vessel of Ako Domeki,who once ruled over the Seirai region."
    STRINGS.RECIPE_DESC.AKO_SAKE_VESSEL = "Specialized refinement material for “The Catch.”"

    STRINGS.NAMES.RAIDEN_CONSTELLATION_STAR = "Raiden Shogun's Stella Fortuna"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAIDEN_CONSTELLATION_STAR = "Raiden Shogun's Constellation Activation Material."
    STRINGS.RECIPE_DESC.RAIDEN_CONSTELLATION_STAR = "Raiden Shogun's Constellation Activation Material"

    STRINGS.NAMES.CROWN_OF_INSIGHT = "Crown of Insight"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROWN_OF_INSIGHT = "A precious Talent Level-Up material."

    STRINGS.NAMES.BOOK_FIREPIT = "Course of Roasting"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_FIREPIT = "Have a miraculous power.Teach readers cooking.And can even feel Electro element?"
    STRINGS.RECIPE_DESC.BOOK_FIREPIT = "Craft a book to teach readers roasting"

    STRINGS.NAMES.BOOK_COOKPOT = "Course of Cooking"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_COOKPOT = "Have a miraculous power.Teach readers cooking.And can even feel Electro element?"
    STRINGS.RECIPE_DESC.BOOK_COOKPOT = "Craft a book to teach readers cooking"

    STRINGS.NAMES.BOOK_SPICER = "Course of Spicing"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_SPICER = "Have a miraculous power.Teach readers cooking.And can even feel Electro element?"
    STRINGS.RECIPE_DESC.BOOK_SPICER = "Craft a book to teach readers spicing"

    STRINGS.NAMES.AMAKUMO_FRUIT = "Amakumo Fruit"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.AMAKUMO_FRUIT = "The fruit of the Amakumo Grass.Can hear it crackling with a tiny current if hold it up to the ear."

    STRINGS.NAMES.AMAKUMO_GRASS = "Amakumo Grass"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.AMAKUMO_GRASS = "A plant originally grows in Amakumo Peak.It appears here due to some unknown reasons."

end