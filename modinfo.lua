---@diagnostic disable: lowercase-global
local ischinese = locale == "zh" or locale == "zht" or locale == "zhr"

if ischinese then
    name = "雷电将军"
    description = "其身为御建鸣神主尊大御所大人，许稻妻人民以亘古不变之「永恒」。"
else
    name = "Raiden Shogun"
    description = "Her Excellency, the Almighty Narukami Ogosho, who promised the people of Inazuma an unchanging Eternity."
end

author = "1526606449"
version = "1.0.15"
api_version = 10
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true
icon_atlas = "iconraiden.xml"
icon = "iconraiden.tex"
all_clients_require_mod = true
client_only_mod = false
priority = -10  --必须比core模块后加载

--MOD中使用了风铃草的“upvaluehelper”
--MOD中可以拖动的按钮，参考了“Insight”的写法
--MOD中制作栏filters的资料整理，参照了“能力勋章”中的注释

local opt_Empty = {{description = "", data = 0}}

local function Title(title, hover)
    return {
        name = title,
        hover = hover,
        options = opt_Empty,
        default = 0,
    }
end

local SEPARATOR = Title("")

if ischinese then

    configuration_options =
    {
        Title("简单模式"),
        {
            name = "easy_mode",
            label = "简单模式",
            hover = "如果你嫌弃她前期伤害太低，可以开启此选项",
            options =
            {
                { description = "开启", data = true, hover = "雷电将军的基础攻击力将被提升至33.7" },
                { description = "关闭", data = false, hover = "雷电将军的基础攻击力为10" },
            },
            default = false,
        },

        Title("控制"),
        {
            name = "key_elementalskill",
            label = "元素战技键位",
            hover = "自定义释放元素战技的按键",
            options =
            {
                { description = "TAB", data = 9 },
                { description = "KP_PERIOD", data = 266 },
                { description = "KP_DIVIDE", data = 267 },
                { description = "KP_MULTIPLY", data = 268 },
                { description = "KP_MINUS", data = 269 },
                { description = "KP_PLUS", data = 270 },
                { description = "KP_ENTER", data = 271 },
                { description = "KP_EQUALS", data = 272 },
                { description = "MINUS", data = 45 },
                { description = "EQUALS", data = 61 },
                { description = "SPACE", data = 32 },
                { description = "ENTER", data = 13 },
                { description = "ESCAPE", data = 27 },
                { description = "HOME", data = 278 },
                { description = "INSERT", data = 277 },
                { description = "DELETE", data = 127 },
                { description = "END", data = 279 },
                { description = "PAUSE", data = 19 },
                { description = "PRINT", data = 316 },
                { description = "CAPSLOCK", data = 301 },
                { description = "SCROLLOCK", data = 302 },
                { description = "BACKSPACE", data = 8 },
                { description = "PERIOD", data = 46 },
                { description = "SLASH", data = 47 },
                { description = "LEFTBRACKET", data = 91 },
                { description = "BACKSLASH", data = 92 },
                { description = "RIGHTBRACKET", data = 93 },
                { description = "TILDE", data = 96 },
                { description = "A", data = 97 },
                { description = "B", data = 98 },
                { description = "C", data = 99 },
                { description = "D", data = 100 },
                { description = "E", data = 101 },
                { description = "F", data = 102 },
                { description = "G", data = 103 },
                { description = "H", data = 104 },
                { description = "I", data = 105 },
                { description = "J", data = 106 },
                { description = "K", data = 107 },
                { description = "L", data = 108 },
                { description = "M", data = 109 },
                { description = "N", data = 110 },
                { description = "O", data = 111 },
                { description = "P", data = 112 },
                { description = "Q", data = 113 },
                { description = "R", data = 114 },
                { description = "S", data = 115 },
                { description = "T", data = 116 },
                { description = "U", data = 117 },
                { description = "V", data = 118 },
                { description = "W", data = 119 },
                { description = "X", data = 120 },
                { description = "Y", data = 121 },
                { description = "Z", data = 122 },
                { description = "F1", data = 282 },
                { description = "F2", data = 283 },
                { description = "F3", data = 284 },
                { description = "F4", data = 285 },
                { description = "F5", data = 286 },
                { description = "F6", data = 287 },
                { description = "F7", data = 288 },
                { description = "F8", data = 289 },
                { description = "F9", data = 290 },
                { description = "F10", data = 291 },
                { description = "F11", data = 292 },
                { description = "F12", data = 293 },
                { description = "UP", data = 273 },
                { description = "DOWN", data = 274 },
                { description = "RIGHT", data = 275 },
                { description = "LEFT", data = 276 },
                { description = "PAGEUP", data = 280 },
                { description = "PAGEDOWN", data = 281 },
                { description = "0", data = 48 },
                { description = "1", data = 49 },
                { description = "2", data = 50 },
                { description = "3", data = 51 },
                { description = "4", data = 52 },
                { description = "5", data = 53 },
                { description = "6", data = 54 },
                { description = "7", data = 55 },
                { description = "8", data = 56 },
                { description = "9", data = 57 },
            },
            default = 101,
        },
        {
            name = "key_elementalburst",
            label = "元素爆发键位",
            hover = "自定义释放元素爆发的按键",
            options =
            {
                { description = "TAB", data = 9 },
                { description = "KP_PERIOD", data = 266 },
                { description = "KP_DIVIDE", data = 267 },
                { description = "KP_MULTIPLY", data = 268 },
                { description = "KP_MINUS", data = 269 },
                { description = "KP_PLUS", data = 270 },
                { description = "KP_ENTER", data = 271 },
                { description = "KP_EQUALS", data = 272 },
                { description = "MINUS", data = 45 },
                { description = "EQUALS", data = 61 },
                { description = "SPACE", data = 32 },
                { description = "ENTER", data = 13 },
                { description = "ESCAPE", data = 27 },
                { description = "HOME", data = 278 },
                { description = "INSERT", data = 277 },
                { description = "DELETE", data = 127 },
                { description = "END", data = 279 },
                { description = "PAUSE", data = 19 },
                { description = "PRINT", data = 316 },
                { description = "CAPSLOCK", data = 301 },
                { description = "SCROLLOCK", data = 302 },
                { description = "BACKSPACE", data = 8 },
                { description = "PERIOD", data = 46 },
                { description = "SLASH", data = 47 },
                { description = "LEFTBRACKET", data = 91 },
                { description = "BACKSLASH", data = 92 },
                { description = "RIGHTBRACKET", data = 93 },
                { description = "TILDE", data = 96 },
                { description = "A", data = 97 },
                { description = "B", data = 98 },
                { description = "C", data = 99 },
                { description = "D", data = 100 },
                { description = "E", data = 101 },
                { description = "F", data = 102 },
                { description = "G", data = 103 },
                { description = "H", data = 104 },
                { description = "I", data = 105 },
                { description = "J", data = 106 },
                { description = "K", data = 107 },
                { description = "L", data = 108 },
                { description = "M", data = 109 },
                { description = "N", data = 110 },
                { description = "O", data = 111 },
                { description = "P", data = 112 },
                { description = "Q", data = 113 },
                { description = "R", data = 114 },
                { description = "S", data = 115 },
                { description = "T", data = 116 },
                { description = "U", data = 117 },
                { description = "V", data = 118 },
                { description = "W", data = 119 },
                { description = "X", data = 120 },
                { description = "Y", data = 121 },
                { description = "Z", data = 122 },
                { description = "F1", data = 282 },
                { description = "F2", data = 283 },
                { description = "F3", data = 284 },
                { description = "F4", data = 285 },
                { description = "F5", data = 286 },
                { description = "F6", data = 287 },
                { description = "F7", data = 288 },
                { description = "F8", data = 289 },
                { description = "F9", data = 290 },
                { description = "F10", data = 291 },
                { description = "F11", data = 292 },
                { description = "F12", data = 293 },
                { description = "UP", data = 273 },
                { description = "DOWN", data = 274 },
                { description = "RIGHT", data = 275 },
                { description = "LEFT", data = 276 },
                { description = "PAGEUP", data = 280 },
                { description = "PAGEDOWN", data = 281 },
                { description = "0", data = 48 },
                { description = "1", data = 49 },
                { description = "2", data = 50 },
                { description = "3", data = 51 },
                { description = "4", data = 52 },
                { description = "5", data = 53 },
                { description = "6", data = 54 },
                { description = "7", data = 55 },
                { description = "8", data = 56 },
                { description = "9", data = 57 },
            },
            default = 113,
        },

        Title("显示"),
        {
            name = "chakra_stacknumber",
            label = "愿力数字显示",
            hover = "关闭后可以观察诸愿百眼之轮的动画来判断层数",
            options =
            {
                { description = "开启", data = true, hover = "使用数字显示诸愿百眼之轮的愿力层数" },
                { description = "关闭", data = false, hover = "关闭数字显示" },
            },
            default = true,
        },

        Title("游戏"),
        {
            name = "amakumo_grass_regrowth",
            label = "天云草再生速度",
            hover = "控制天云草被摧毁后的再生时间间隔",
            options =
            {
                { description = "无", data = 0, hover = "没了就是没了"},
                { description = "极慢", data = 0.25, hover = "天云草被烧掉后24天将会在附近长出一株新的天云草" },
                { description = "慢", data = 0.5, hover = "天云草被烧掉后12天将会在附近长出一株新的天云草" },
                { description = "默认", data = 1, hover = "天云草被烧掉后6天将会在附近长出一株新的天云草" },
                { description = "快", data = 2, hover = "天云草被烧掉后3天将会在附近长出一株新的天云草" },
                { description = "极快", data = 4, hover = "天云草被烧掉后1.5天将会在附近长出一株新的天云草" },
            },
            default = 1,
        },
        {
            name = "raiden_stew_explode",
            label = "做饭炸锅",
            hover = "我的影小姐啊，因为做饭总是把锅炸了，气的内心崩溃又哭又闹呜呜呜呜好可怜啊",
            options =
            {
                { description = "开启", data = true, hover = "你，要与我为敌吗（bushi）" },
                { description = "关闭", data = false, hover = "嗯" },
            },
            default = true,
        },
    }

else

    configuration_options =
    {
        Title("Easy Mode"),
        {
            name = "easy_mode",
            label = "Easy Mode",
            hover = "If you think her dmg is too low, then you can turn on this",
            options =
            {
                { description = "On", data = true, hover = "Her base atk will be increased to 33.7" },
                { description = "Off", data = false, hover = "Her base atk is still 10" },
            },
            default = false,
        },

        Title("Control"),
        {
            name = "key_elementalskill",
            label = "Elemental Skill Key",
            hover = "Custom the key to use Elemental Skill",
            options =
            {
                { description = "TAB", data = 9 },
                { description = "KP_PERIOD", data = 266 },
                { description = "KP_DIVIDE", data = 267 },
                { description = "KP_MULTIPLY", data = 268 },
                { description = "KP_MINUS", data = 269 },
                { description = "KP_PLUS", data = 270 },
                { description = "KP_ENTER", data = 271 },
                { description = "KP_EQUALS", data = 272 },
                { description = "MINUS", data = 45 },
                { description = "EQUALS", data = 61 },
                { description = "SPACE", data = 32 },
                { description = "ENTER", data = 13 },
                { description = "ESCAPE", data = 27 },
                { description = "HOME", data = 278 },
                { description = "INSERT", data = 277 },
                { description = "DELETE", data = 127 },
                { description = "END", data = 279 },
                { description = "PAUSE", data = 19 },
                { description = "PRINT", data = 316 },
                { description = "CAPSLOCK", data = 301 },
                { description = "SCROLLOCK", data = 302 },
                { description = "BACKSPACE", data = 8 },
                { description = "PERIOD", data = 46 },
                { description = "SLASH", data = 47 },
                { description = "LEFTBRACKET", data = 91 },
                { description = "BACKSLASH", data = 92 },
                { description = "RIGHTBRACKET", data = 93 },
                { description = "TILDE", data = 96 },
                { description = "A", data = 97 },
                { description = "B", data = 98 },
                { description = "C", data = 99 },
                { description = "D", data = 100 },
                { description = "E", data = 101 },
                { description = "F", data = 102 },
                { description = "G", data = 103 },
                { description = "H", data = 104 },
                { description = "I", data = 105 },
                { description = "J", data = 106 },
                { description = "K", data = 107 },
                { description = "L", data = 108 },
                { description = "M", data = 109 },
                { description = "N", data = 110 },
                { description = "O", data = 111 },
                { description = "P", data = 112 },
                { description = "Q", data = 113 },
                { description = "R", data = 114 },
                { description = "S", data = 115 },
                { description = "T", data = 116 },
                { description = "U", data = 117 },
                { description = "V", data = 118 },
                { description = "W", data = 119 },
                { description = "X", data = 120 },
                { description = "Y", data = 121 },
                { description = "Z", data = 122 },
                { description = "F1", data = 282 },
                { description = "F2", data = 283 },
                { description = "F3", data = 284 },
                { description = "F4", data = 285 },
                { description = "F5", data = 286 },
                { description = "F6", data = 287 },
                { description = "F7", data = 288 },
                { description = "F8", data = 289 },
                { description = "F9", data = 290 },
                { description = "F10", data = 291 },
                { description = "F11", data = 292 },
                { description = "F12", data = 293 },
                { description = "UP", data = 273 },
                { description = "DOWN", data = 274 },
                { description = "RIGHT", data = 275 },
                { description = "LEFT", data = 276 },
                { description = "PAGEUP", data = 280 },
                { description = "PAGEDOWN", data = 281 },
                { description = "0", data = 48 },
                { description = "1", data = 49 },
                { description = "2", data = 50 },
                { description = "3", data = 51 },
                { description = "4", data = 52 },
                { description = "5", data = 53 },
                { description = "6", data = 54 },
                { description = "7", data = 55 },
                { description = "8", data = 56 },
                { description = "9", data = 57 },
            },
            default = 101,
        },
        {
            name = "key_elementalburst",
            label = "Elemental Burst Key",
            hover = "Custom the key to use Elemental Burst",
            options =
            {
                { description = "TAB", data = 9 },
                { description = "KP_PERIOD", data = 266 },
                { description = "KP_DIVIDE", data = 267 },
                { description = "KP_MULTIPLY", data = 268 },
                { description = "KP_MINUS", data = 269 },
                { description = "KP_PLUS", data = 270 },
                { description = "KP_ENTER", data = 271 },
                { description = "KP_EQUALS", data = 272 },
                { description = "MINUS", data = 45 },
                { description = "EQUALS", data = 61 },
                { description = "SPACE", data = 32 },
                { description = "ENTER", data = 13 },
                { description = "ESCAPE", data = 27 },
                { description = "HOME", data = 278 },
                { description = "INSERT", data = 277 },
                { description = "DELETE", data = 127 },
                { description = "END", data = 279 },
                { description = "PAUSE", data = 19 },
                { description = "PRINT", data = 316 },
                { description = "CAPSLOCK", data = 301 },
                { description = "SCROLLOCK", data = 302 },
                { description = "BACKSPACE", data = 8 },
                { description = "PERIOD", data = 46 },
                { description = "SLASH", data = 47 },
                { description = "LEFTBRACKET", data = 91 },
                { description = "BACKSLASH", data = 92 },
                { description = "RIGHTBRACKET", data = 93 },
                { description = "TILDE", data = 96 },
                { description = "A", data = 97 },
                { description = "B", data = 98 },
                { description = "C", data = 99 },
                { description = "D", data = 100 },
                { description = "E", data = 101 },
                { description = "F", data = 102 },
                { description = "G", data = 103 },
                { description = "H", data = 104 },
                { description = "I", data = 105 },
                { description = "J", data = 106 },
                { description = "K", data = 107 },
                { description = "L", data = 108 },
                { description = "M", data = 109 },
                { description = "N", data = 110 },
                { description = "O", data = 111 },
                { description = "P", data = 112 },
                { description = "Q", data = 113 },
                { description = "R", data = 114 },
                { description = "S", data = 115 },
                { description = "T", data = 116 },
                { description = "U", data = 117 },
                { description = "V", data = 118 },
                { description = "W", data = 119 },
                { description = "X", data = 120 },
                { description = "Y", data = 121 },
                { description = "Z", data = 122 },
                { description = "F1", data = 282 },
                { description = "F2", data = 283 },
                { description = "F3", data = 284 },
                { description = "F4", data = 285 },
                { description = "F5", data = 286 },
                { description = "F6", data = 287 },
                { description = "F7", data = 288 },
                { description = "F8", data = 289 },
                { description = "F9", data = 290 },
                { description = "F10", data = 291 },
                { description = "F11", data = 292 },
                { description = "F12", data = 293 },
                { description = "UP", data = 273 },
                { description = "DOWN", data = 274 },
                { description = "RIGHT", data = 275 },
                { description = "LEFT", data = 276 },
                { description = "PAGEUP", data = 280 },
                { description = "PAGEDOWN", data = 281 },
                { description = "0", data = 48 },
                { description = "1", data = 49 },
                { description = "2", data = 50 },
                { description = "3", data = 51 },
                { description = "4", data = 52 },
                { description = "5", data = 53 },
                { description = "6", data = 54 },
                { description = "7", data = 55 },
                { description = "8", data = 56 },
                { description = "9", data = 57 },
            },
            default = 113,
        },

        Title("Display"),
        {
            name = "chakra_stacknumber",
            label = "Display number of Chakra Stack",
            hover = "You can get information by the anim of Chakra Desiderata if you turn off",
            options =
            {
                { description = "On", data = true, hover = "Show the number of stack in the middle of Chakra Desiderata" },
                { description = "Off", data = false, hover = "The number of stack will not show" },
            },
            default = true,
        },

        Title("Game"),
        {
            name = "amakumo_grass_regrowth",
            label = "Amakumo Grass Regrowth Speed",
            hover = "Control the intervals of the regrowth of Amakumo Grass after they've been destroyed.",
            options =
            {
                { description = "No Regrowth", data = 0 },
                { description = "Very Slow", data = 0.25 },
                { description = "Slow", data = 0.5 },
                { description = "Default", data = 1 },
                { description = "Fast", data = 2 },
                { description = "Very Fast", data = 4 },
            },
            default = 1,
        },
        {
            name = "raiden_stew_explode",
            label = "Cookpot Explosion",
            hover = "If you turn on this, then your cookpot may explode when she's cooking",
            options =
            {
                { description = "On", data = true },
                { description = "Off", data = false },
            },
            default = true,
        },
    }

end
