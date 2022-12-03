local raiden_addedfoods =
{
    --三彩团子
	tricolordango =
	{
		test = function(cooker, names, tags) return tags.dairy and tags.veggie and tags.sweetener and names.twigs and not tags.meat end,
		priority = 1,
		weight = 1,
		foodtype = FOODTYPE.GOODIES,
		health = 10,
		hunger = 45,
		perishtime = TUNING.PERISH_SLOW,
		sanity = 15,
		cooktime = 1,
        overridebuild = "raiden_cook_pot_food",
        floater = {"small", 0.05, 0.7},
        tags = {"raiden_food"},
	},

    --团子牛奶
    dangomilk =
	{
		test = function(cooker, names, tags) return tags.dairy and tags.dairy >= 2 and tags.fruit and not tags.egg and not tags.meat and not tags.veggie and not tags.inedible end,
		priority = 1,
		weight = 1,
		foodtype = FOODTYPE.GOODIES,
		health = 20,
		hunger = 15,
		perishtime = TUNING.PERISH_MED,
		sanity = 45,
		cooktime = 1,
        overridebuild = "raiden_cook_pot_food",
        potlevel = "low",
        floater = {"small", 0.05, 0.7},
        tags = {"raiden_food"},
	},

    --紫苑云霓
    rainbowaster =
	{
		test = function(cooker, names, tags) return tags.dairy and tags.frozen and tags.veggie and tags.fruit and not tags.egg and not tags.meat and not tags.inedible end,
		priority = 1,
		weight = 1,
		foodtype = FOODTYPE.GOODIES,
		health = 40,
		hunger = 15,
		perishtime = TUNING.PERISH_MED,
		sanity = 20,
		cooktime = 1,
        overridebuild = "raiden_cook_pot_food",
        potlevel = "low",
        floater = {"small", 0.05, 0.7},
        tags = {"raiden_food"},
	},

    --裁决之时，吃下后减少30生命值和10san，且接下来的两分钟内每5秒损失1生命值；持续期间雷元素暴击伤害增加30%.
    adjudicatetime =
	{
		test = function(cooker, names, tags) return true end,
		priority = -100,
		weight = 1,
		health = -30,
		hunger = 5,
		perishtime = (20+15+20+15)*1000*8*60, --影小姐做出来的黑暗料理的话，效力永远不消失的呢；我专门不写-1，就是要让showme显示它的腐败时间哼
		sanity = -10,
		cooktime = 0.5,
        overridebuild = "raiden_cook_pot_food",
        oneatenfn = function(inst, eater)
			eater:AddDebuff("raiden_adjudicatebuff", "raiden_adjudicatebuff")
        end,
        floater = {"small", 0.05, 0.7},
        tags = {"raiden_food"},
	},
}

for k, v in pairs(raiden_addedfoods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0

	v.cookbook_category = "cookpot"
end

require("tuning")
require("spicedfoods")

local raiden_addedspicedfoods = {}

local function oneaten_garlic(inst, eater)
    eater:AddDebuff("buff_playerabsorption", "buff_playerabsorption")
end

local function oneaten_sugar(inst, eater)
    eater:AddDebuff("buff_workeffectiveness", "buff_workeffectiveness")
end

local function oneaten_chili(inst, eater)
    eater:AddDebuff("buff_attack", "buff_attack")
end

local function oneaten_amakumo(inst, eater)
    eater:AddDebuff("buff_amakumoeaten", "buff_amakumoeaten")
end

local RAIDEN_SPICES =
{
    --官方原有的，MOD粉末比如能力勋章那样的，他会在LoadPrefabFiles之前给所有食物加一次
    SPICE_GARLIC = { oneatenfn = oneaten_garlic, prefabs = { "buff_playerabsorption" } },
    SPICE_SUGAR  = { oneatenfn = oneaten_sugar, prefabs = { "buff_workeffectiveness" } },
    SPICE_CHILI  = { oneatenfn = oneaten_chili, prefabs = { "buff_attack" } },
    SPICE_SALT   = {},
    --
    SPICE_AMAKUMO = { oneatenfn = oneaten_amakumo, prefabs = { "buff_amakumoeaten" }, overridespicebuild = "spice_amakumo" },
    --天云草实粉，调味的料理会增加雷元素伤害的暴击率10%，持续半天
}

local function GenerateRaidenSpicedFoods(foods)
    for foodname, fooddata in pairs(foods) do
        for spicenameupper, spicedata in pairs(RAIDEN_SPICES) do
            local newdata = shallowcopy(fooddata)
            local spicename = string.lower(spicenameupper)
            if foodname == "wetgoop" then
---@diagnostic disable-next-line: duplicate-set-field
                newdata.test = function(cooker, names, tags) return names[spicename] end
                newdata.priority = -10
            else
---@diagnostic disable-next-line: duplicate-set-field
                newdata.test = function(cooker, names, tags) return names[foodname] and names[spicename] end
                newdata.priority = 100
            end
            newdata.cooktime = .12
            newdata.stacksize = nil
            newdata.spice = spicenameupper
            newdata.basename = foodname
            newdata.name = foodname.."_"..spicename
            newdata.floater = {"med", nil, {0.85, 0.7, 0.85}}
            newdata.overridespicebuild = spicedata.overridespicebuild or nil
            if spicedata.foodtype then
				newdata.foodtype = spicedata.foodtype
			end
			newdata.cookbook_category = fooddata.cookbook_category ~= nil and ("spiced_"..fooddata.cookbook_category) or nil
            raiden_addedspicedfoods[newdata.name] = newdata

            if spicedata.prefabs ~= nil then
                --make a copy (via ArrayUnion) if there are dependencies from the original food
                newdata.prefabs = newdata.prefabs ~= nil and ArrayUnion(newdata.prefabs, spicedata.prefabs) or spicedata.prefabs
            end

            if spicedata.oneatenfn ~= nil then
                if newdata.oneatenfn ~= nil then
                    local oneatenfn_old = newdata.oneatenfn
                    newdata.oneatenfn = function(inst, eater)
                        spicedata.oneatenfn(inst, eater)
                        oneatenfn_old(inst, eater)
                    end
                else
                    newdata.oneatenfn = spicedata.oneatenfn
                end
            end
        end
    end
end

GenerateSpicedFoods(raiden_addedfoods)
GenerateRaidenSpicedFoods(raiden_addedfoods)

local allreturn_foods = {}

for k, v in pairs(raiden_addedfoods) do
    allreturn_foods[k] = v
    AddCookerRecipe("cookpot", v, true)
    AddCookerRecipe("portablecookpot", v, true)
    AddCookerRecipe("archive_cookpot", v, true)
end

for k, v in pairs(raiden_addedspicedfoods) do
    allreturn_foods[k] = v
    AddCookerRecipe("portablespicer", v, true)
end

return allreturn_foods