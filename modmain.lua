----------------------------------------------------
----------------- 注册Prefab文件 -------------------

PrefabFiles = {
    --人物
    "raiden_shogun_none",
    "raiden_shogun",

    --武器
	"engulfinglightning",
    "favoniuslance",
    "thecatch",

    --采集物
    "amakumo_grass",
    "amakumo_fruit",

    --食物和调味料
    "raiden_preparedfoods",
    "spice_amakumo",
    
    --食物有关的buff
    "raiden_adjudicatebuff",
    "buff_amakumoeaten",

    --其它物品
    "raiden_constellation_star",
    "raiden_cookbooks",
    "ako_sake_vessel",
    "crown_of_insight",

    --蓝图
    "raiden_blueprints",

    --技能召唤物
    "eye_stormy_judge",
    "chakra_desiderata",

    --特效
    "raiden_eleskill_fx",
    "raiden_eleburst_fx",
    "raiden_atk_fx",
}

----------------------------------------------------
------------------ 图片资源文件 --------------------

Assets = {
    --动作
    Asset( "ANIM", "anim/action_raiden_chargeattack.zip"),
    Asset( "ANIM", "anim/action_raiden_chargeattack_pst.zip"),
    Asset( "ANIM", "anim/action_raiden_eleburst.zip"),
    Asset( "ANIM", "anim/action_raiden_eleskill.zip"),

    --其它物品
    Asset( "ANIM", "anim/swap_musouisshin.zip"),

--------------------------------------------------------------------
    --制作
    Asset( "IMAGE", "images/inventoryimages/book_firepit.tex" ),
    Asset( "ATLAS", "images/inventoryimages/book_firepit.xml" ),

    Asset( "IMAGE", "images/inventoryimages/book_cookpot.tex" ),
    Asset( "ATLAS", "images/inventoryimages/book_cookpot.xml" ),

    Asset( "IMAGE", "images/inventoryimages/book_spicer.tex" ),
    Asset( "ATLAS", "images/inventoryimages/book_spicer.xml" ),

    Asset( "IMAGE", "images/inventoryimages/amakumo_fruit.tex" ),
    Asset( "ATLAS", "images/inventoryimages/amakumo_fruit.xml" ),

    Asset( "IMAGE", "images/inventoryimages/ako_sake_vessel.tex" ),
    Asset( "ATLAS", "images/inventoryimages/ako_sake_vessel.xml" ),

    Asset( "IMAGE", "images/inventoryimages/crown_of_insight.tex" ),
    Asset( "ATLAS", "images/inventoryimages/crown_of_insight.xml" ),

--------------------------------------------------------------------
    --小地图
    Asset( "IMAGE", "images/map_icons/amakumo_grass.tex" ),
	Asset( "ATLAS", "images/map_icons/amakumo_grass.xml" ),

--------------------------------------------------------------------
    --声音
    Asset("SOUNDPACKAGE", "sound/raiden_sound.fev"),
    Asset("SOUND", "sound/raiden_sound_bank00.fsb"),

--------------------------------------------------------------------
    --
    Asset( "IMAGE", "images/saveslot_portraits/raiden_shogun.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/raiden_shogun.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/raiden_shogun.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/raiden_shogun.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/raiden_shogun_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/raiden_shogun_silho.xml" ),

    Asset( "IMAGE", "bigportraits/raiden_shogun.tex" ),
    Asset( "ATLAS", "bigportraits/raiden_shogun.xml" ),
	
	Asset( "IMAGE", "images/map_icons/raiden_shogun.tex" ),
	Asset( "ATLAS", "images/map_icons/raiden_shogun.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_raiden_shogun.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_raiden_shogun.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_raiden_shogun.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_raiden_shogun.xml" ),

    Asset( "IMAGE", "images/avatars/self_inspect_raiden_shogun.tex" ), 
    Asset( "ATLAS", "images/avatars/self_inspect_raiden_shogun.xml" ),
	
	Asset( "IMAGE", "bigportraits/raiden_shogun_none.tex" ),
    Asset( "ATLAS", "bigportraits/raiden_shogun_none.xml" ),
	
	Asset( "IMAGE", "images/names_raiden_shogun.tex" ),
    Asset( "ATLAS", "images/names_raiden_shogun.xml" ),
---------------------------------------------------------------
--有关技能图标
    Asset( "IMAGE", "images/ui/eleskill_raiden.tex" ),
    Asset( "ATLAS", "images/ui/eleskill_raiden.xml" ),

    Asset( "ANIM", "anim/eleburst_raiden.zip" ),

---------------------------------------------------------------
--命之座图片
    Asset( "IMAGE", "images/ui/constellation_raiden/1_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/1_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_raiden/1_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/1_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_raiden/2_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/2_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_raiden/2_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/2_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_raiden/3_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/3_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_raiden/3_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/3_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_raiden/4_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/4_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_raiden/4_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/4_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_raiden/5_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/5_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_raiden/5_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/5_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_raiden/6_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/6_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_raiden/6_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/6_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_raiden/constellation_image.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/constellation_image.xml" ),

    Asset( "IMAGE", "images/ui/constellation_raiden/constellation_lines.tex" ),
    Asset( "ATLAS", "images/ui/constellation_raiden/constellation_lines.xml" ),

--天赋图片
    Asset( "IMAGE", "images/ui/talents_raiden/talent_icon_1.tex" ),
    Asset( "ATLAS", "images/ui/talents_raiden/talent_icon_1.xml" ),

    Asset( "IMAGE", "images/ui/talents_raiden/talent_icon_2.tex" ),
    Asset( "ATLAS", "images/ui/talents_raiden/talent_icon_2.xml" ),

    Asset( "IMAGE", "images/ui/talents_raiden/talent_icon_3.tex" ),
    Asset( "ATLAS", "images/ui/talents_raiden/talent_icon_3.xml" ),

    Asset( "IMAGE", "images/ui/talents_raiden/talent_icon_4.tex" ),
    Asset( "ATLAS", "images/ui/talents_raiden/talent_icon_4.xml" ),

    Asset( "IMAGE", "images/ui/talents_raiden/talent_icon_5.tex" ),
    Asset( "ATLAS", "images/ui/talents_raiden/talent_icon_5.xml" ),

    Asset( "IMAGE", "images/ui/talents_raiden/talent_icon_6.tex" ),
    Asset( "ATLAS", "images/ui/talents_raiden/talent_icon_6.xml" ),
}

----------------------------------------------------
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
--------------------- 自定义 -----------------------

TUNING.ELEMENTALBURST_KEY = GetModConfigData("key_elementalburst")

TUNING.ELEMENTALSKILL_KEY = GetModConfigData("key_elementalskill")

TUNING.LANGUAGE_GENSHIN_RAIDEN = TUNING.LANGUAGE_GENSHIN_CORE

TUNING.RAIDEN_UISCALE = TUNING.GENSHINCORE_UISCALE or 1

TUNING.CHAKRA_STACKNUMBER = GetModConfigData("chakra_stacknumber")

TUNING.AMAKUMOGRASS_REGROWTH_TIME_MULT = GetModConfigData("amakumo_grass_regrowth")

TUNING.RAIDEN_COOK_EXPLOSION = GetModConfigData("raiden_stew_explode")

----------------------------------------------------
---------------------- 常量 ------------------------
--武器参数

TUNING.ENGULFINGLIGHTNING_DAMAGE = 51
TUNING.ENGULFINGLIGHTNING_ATKUP_RATE = { 0.28, 0.35, 0.42, 0.49, 0.56 }
TUNING.ENGULFINGLIGHTNING_ATKUP_MAX = { 0.8, 0.9, 1, 1.1, 1.2 }
TUNING.ENGULFINGLIGHTNING_RECHARGEUP = { 0.3, 0.35, 0.4, 0.45, 0.5 }

TUNING.FAVONIUSLANCE_DAMAGE = 37
TUNING.FAVONIUSLANCE_EFFECT_CD = { 12, 10.5, 9, 7.5, 6 }
TUNING.FAVONIUSLANCE_TRIGGER_RATE = { 0.6, 0.7, 0.8, 0.9, 1 }

TUNING.THECATCH_DAMAGE = 44
TUNING.THCATCH_CRIT_RATE = { 0.06, 0.075, 0.09, 0.105, 0.12 }
TUNING.THECATCH_ELEBURST_BONUS = { 0.16, 0.2, 0.24, 0.28, 0.32 }

--------------------------------------
--人物参数
TUNING.RAIDEN_SHOGUN_BASEATK = GetModConfigData("easy_mode") and 33.7 or 10

TUNING.RAIDEN_SHOGUN_HEALTH = 130
TUNING.RAIDEN_SHOGUN_HUNGER = 250
TUNING.RAIDEN_SHOGUN_SANITY = 150

TUNING.RAIDEN_HUNGER_RATE = 1.5

TUNING.RAIDEN_BURST_ATTACKRANGE = 3

--------------------------------------
--厨艺经验
TUNING.FIREPIT_EXPDELTA = 5
TUNING.COOKPOT_EXPDELTA = 15

TUNING.RAIDEN_COOKBOOK_LEARNTIME = TUNING.TOTAL_DAY_TIME

--------------------------------------
--食物BUFF参数
TUNING.RAIDEN_ADJUDICATEBUFF_DURATION = 120

TUNING.BUFF_AMAKUMOEATEN_DURATION = TUNING.TOTAL_DAY_TIME * 0.5

--------------------------------------
--植物参数
TUNING.AMAKUMO_GRASS_REGROW_TIME = TUNING.TOTAL_DAY_TIME * 4  --长出来的时间
TUNING.AMAKUMOGRASS_REGROWTH_TIME = TUNING.TOTAL_DAY_TIME * 6  --资源再生时间（被烧掉），这两个是不一样的

------------------------------------------
--技能参数
TUNING.RAIDENSKILL_NORMALATK = 
{
    --LEVEL            1      2      3      4      5      6      7      8      9      10     11     12     13     14     15
    ATK_DMG =        {0.421, 0.455, 0.490, 0.539, 0.573, 0.612, 0.666, 0.720, 0.774, 0.832, 0.899, 0.979, 1.058, 1.137, 1.224},
    CHARGE_ATK_DMG = {0.996, 1.077, 1.158, 1.274, 1.355, 1.448, 1.575, 1.702, 1.830, 1.969, 2.128, 2.315, 2.502, 2.690, 2.894},
}

TUNING.RAIDENSKILL_ELESKILL = 
{
    CD = 10,
    DURATION = 25,
    --LEVEL           1      2      3      4      5      6      7      8      9      10     11     12     13     14     15
    DMG =            {1.172, 1.260, 1.348, 1.465, 1.553, 1.641, 1.758, 1.875, 1.992, 2.110, 2.227, 2.344, 2.491, 2.637, 2.784},
    CO_DMG =         {0.420, 0.452, 0.483, 0.525, 0.557, 0.588, 0.630, 0.672, 0.714, 0.756, 0.798, 0.840, 0.893, 0.945, 0.998},
    ELEBURST_BONUS = {0.0022,0.0023,0.0024,0.0025,0.0026,0.0027,0.0028,0.0029,0.003, 0.003, 0.003, 0.003, 0.003, 0.003, 0.003},
}

TUNING.RAIDENSKILL_ELEBURST = 
{
    CD = 18,
    ENERGY = 90, 
    DURATION = 7,
    --LEVEL              1      2      3      4      5      6      7      8      9      10     11     12     13     14     15
    DMG =               {4.008, 4.309, 4.609, 5.010, 5.311, 5.611, 6.012, 6.413, 6.814, 7.214, 7.615, 8.016, 8.517, 9.018, 9.519},
    ATK_DMG =           {0.464, 0.496, 0.527, 0.569, 0.601, 0.638, 0.685, 0.733, 0.780, 0.826, 0.875, 0.922, 0.970, 1.017, 1.065},
    CHARGE_ATK_DMG =    {1.359, 1.452, 1.545, 1.669, 1.761, 1.870, 2.009, 2.148, 2.287, 2.426, 2.565, 2.704, 2.843, 2.982, 3.121},
    RESOLVE_BONUS =     {0.039, 0.042, 0.045, 0.049, 0.052, 0.054, 0.058, 0.062, 0.066, 0.070, 0.074, 0.079, 0.083, 0.088, 0.092},
    ATK_RESOLVE_BONUS = {0.0073,0.0078,0.0084,0.0091,0.0096,0.0102,0.0109,0.0116,0.0123,0.0131,0.0138,0.0145,0.0154,0.0163,0.0172},
    RESOLVE_GAIN =      {0.150, 0.160, 0.160, 0.170, 0.170, 0.180, 0.180, 0.190, 0.190, 0.200, 0.200, 0.200, 0.200, 0.200, 0.200},
    ENERGY_GAIN =       {1.6  , 1.7  , 1.8  , 1.9  , 2.0  , 2.1  , 2.2  , 2.3  , 2.4  , 2.5  , 2.5  , 2.5  , 2.5  , 2.5  , 2.5  },
}

TUNING.RAIDEN_AREASKILLS_NOTAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "player", "playerghost", "companion", "abigail"}

TUNING.RAIDENSKILL_NORMALATK_SORT = 
{
    "ATK_DMG",
    "CHARGE_ATK_DMG",
}

TUNING.RAIDENSKILL_ELESKILL_SORT = 
{
    "DMG",
    "CO_DMG",
    "DURATION",
    "ELEBURST_BONUS",
    "CD",
}

TUNING.RAIDENSKILL_ELEBURST_SORT = 
{
    "DMG",
    "RESOLVE_BONUS",
    "ATK_RESOLVE_BONUS",
    "RESOLVE_GAIN",
    "ATK_DMG",
    "CHARGE_ATK_DMG",
    "ENERGY_GAIN",
    "DURATION",
    "CD",
    "ENERGY", 
}

------------------------------------------

TUNING.RAIDEN_CONSTELLATION_POSITION = 
{
    {0, -312},
    {264, -150},
    {264, 110},
    {0, 280},
    {-264, 110},
    {-264, -155},
}

require("recipe")
TUNING.RAIDEN_TALENTS_INGREDIENTS = 
{
    {Ingredient("amakumo_fruit", 2, "images/inventoryimages/amakumo_fruit.xml"), Ingredient("purplegem", 1), Ingredient("goldnugget", 1)},  --1~2
    {Ingredient("amakumo_fruit", 4, "images/inventoryimages/amakumo_fruit.xml"), Ingredient("purplegem", 1), Ingredient("goldnugget", 2)},  --2~3
    {Ingredient("amakumo_fruit", 6, "images/inventoryimages/amakumo_fruit.xml"), Ingredient("purplegem", 2), Ingredient("goldnugget", 3)},  --3~4
    {Ingredient("amakumo_fruit", 8, "images/inventoryimages/amakumo_fruit.xml"), Ingredient("purplegem", 2), Ingredient("goldnugget", 4)},  --4~5
    {Ingredient("amakumo_fruit", 10, "images/inventoryimages/amakumo_fruit.xml"), Ingredient("purplegem", 3), Ingredient("goldnugget", 5)},  --5~6
    {Ingredient("amakumo_fruit", 12, "images/inventoryimages/amakumo_fruit.xml"), Ingredient("purplegem", 3), Ingredient("goldnugget", 6)},  --6~7
    {Ingredient("amakumo_fruit", 15, "images/inventoryimages/amakumo_fruit.xml"), Ingredient("purplegem", 4), Ingredient("goldnugget", 7)},  --7~8
    {Ingredient("amakumo_fruit", 20, "images/inventoryimages/amakumo_fruit.xml"), Ingredient("purplegem", 4), Ingredient("goldnugget", 8)},  --8~9
    {Ingredient("amakumo_fruit", 30, "images/inventoryimages/amakumo_fruit.xml"), Ingredient("purplegem", 5), Ingredient("goldnugget", 9), Ingredient("crown_of_insight", 1, "images/inventoryimages/crown_of_insight.xml")},  --9~10
}

table.insert(TUNING.POLEARM_WEAPONS, "thecatch")
table.insert(TUNING.POLEARM_WEAPONS, "favoniuslance")
table.insert(TUNING.POLEARM_WEAPONS, "engulfinglightning")

----------------------------------------------------
----------------------  ------------------------
--暂时禁用这个排查，不知道是什么问题呢
--modimport("editedanim.lua")

----------------------------------------------------
---------------------- 描述 ------------------------

modimport("scripts/import/raiden_descriptions.lua")

----------------------------------------------------
---------------------- 制作 ------------------------

modimport("scripts/import/genshin_raiden_recipes.lua")

----------------------------------------------------
----------------------- UI -------------------------

modimport("scripts/import/raidenui_postconstruct.lua")

----------------------------------------------------
---------------------- 动作 -------------------------

modimport("scripts/import/action_raiden_cookbook.lua")

----------------------------------------------------
----------------------- SG -------------------------

modimport("scripts/import/raiden_sg.lua")

modimport("scripts/import/eventhandler_yawn_postinit")

----------------------------------------------------
----------------------- 料理 -------------------------

-- local raiden_foods = require("import/raiden_preparedfoods")
-- for k, recipe in pairs (raiden_foods) do
-- 	AddCookerRecipe("cookpot", recipe, true)
-- 	AddCookerRecipe("portablecookpot", recipe, true)
-- 	AddCookerRecipe("archive_cookpot", recipe, true)
-- end

----------------------------------------------------
---------------------- 修改 -------------------------

modimport("scripts/import/cook_postinit.lua")

modimport("scripts/import/cursable_postinit.lua")

modimport("scripts/import/regrowthmanager_postinit.lua")

modimport("scripts/import/moonbase_postinit.lua")

modimport("scripts/import/crownloot_prefabpostinit.lua")

--------------------------------------

--客机组件
require "entityreplica"
AddReplicableComponent("cookunlocker")

--------------------------------------------------------------------------
--初始物品
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.RAIDEN_SHOGUN = { "favoniuslance" }
TUNING.STARTING_ITEM_IMAGE_OVERRIDE.favoniuslance = { atlas = "images/inventoryimages/favoniuslance.xml", image = "favoniuslance.tex" }

STRINGS.CHARACTER_SURVIVABILITY.raiden_shogun = TUNING.LANGUAGE_GENSHIN_RAIDEN == "sc" and "不那么难" or "Not that Hard"

--------------------------------------------------------------------------
--物品图标
AddMinimapAtlas("images/map_icons/amakumo_grass.xml")

--------------------------------------------------------------------------
--添加角色
AddMinimapAtlas("images/map_icons/raiden_shogun.xml")

AddModCharacter("raiden_shogun", "FEMALE")

-----------------------------------------------------------------------
-----------------------------Bug Tracker-------------------------------

bugtracker_config = {
	email = "diaokedu17430@126.com",
	upload_client_log = true,
	upload_server_log = true,
	-- 其它配置项目...
}
