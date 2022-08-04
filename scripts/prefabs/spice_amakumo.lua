require "recipes"

local assets =
{
    Asset("ANIM", "anim/spice_amakumo.zip"),
    Asset("IMAGE", "images/inventoryimages/spice_amakumo.tex"),
    Asset("ATLAS", "images/inventoryimages/spice_amakumo.xml"),
}

local blueprint_assets =
{
    Asset("ANIM", "anim/blueprint.zip"),
    Asset("ANIM", "anim/blueprint_rare.zip"),
    Asset("INV_IMAGE", "blueprint"),
    Asset("INV_IMAGE", "blueprint_rare"),
}

local function onload(inst, data)
    if data ~= nil and data.recipetouse ~= nil then
        inst.recipetouse = data.recipetouse
        inst.components.teacher:SetRecipe(inst.recipetouse)

        if data.is_rare then
            inst.is_rare = data.is_rare
            inst.components.named:SetName(subfmt(STRINGS.NAMES.BLUEPRINT_RARE, { item = STRINGS.NAMES[string.upper(inst.recipetouse)] or STRINGS.NAMES.UNKNOWN }))
            inst.AnimState:SetBank("blueprint_rare")
            inst.AnimState:SetBuild("blueprint_rare")
            inst.components.inventoryitem:ChangeImageName("blueprint_rare")
            inst:RemoveComponent("burnable")
            inst:RemoveComponent("propagator")
        else
            inst.components.named:SetName((STRINGS.NAMES[string.upper(inst.recipetouse)] or STRINGS.NAMES.UNKNOWN).." "..STRINGS.NAMES.BLUEPRINT)
        end
    end
end

local function onsave(inst, data)
    data.recipetouse = inst.recipetouse
    data.is_rare = inst.is_rare or nil
end

local function getstatus(inst)
    return (inst.is_rare and "RARE")
           or "COMMON"
end

local function OnTeach(inst, learner)
    learner:PushEvent("learnrecipe", { teacher = inst, recipe = inst.components.teacher.recipe })
end

local function CanBlueprintRandomRecipe(recipe)
    if recipe.nounlock or recipe.builder_tag ~= nil then
        --Exclude crafting station and character specific
        return false
    end
    local hastech = false
    for k, v in pairs(recipe.level) do
        if v >= 10 then
            --Exclude TECH.LOST
            return false
        elseif v > 0 then
            hastech = true
        end
    end
    --Exclude TECH.NONE
    return hastech
end

local function OnHaunt(inst, haunter)
    if not inst.is_rare and math.random() <= TUNING.HAUNT_CHANCE_HALF then
        local recipes = {}
        local old = inst.recipetouse ~= nil and GetValidRecipe(inst.recipetouse) or nil
        for k, v in pairs(AllRecipes) do
            if IsRecipeValid(v.name) and
                old ~= v and
                (old == nil or old.tab == v.tab) and
                CanBlueprintRandomRecipe(v) and
                not haunter.components.builder:KnowsRecipe(v) and
                haunter.components.builder:CanLearn(v.name) then
                table.insert(recipes, v)
            end
        end
        if #recipes > 0 then
            inst.recipetouse = recipes[math.random(#recipes)].name or "unknown"
            inst.components.teacher:SetRecipe(inst.recipetouse)
            inst.components.named:SetName(STRINGS.NAMES[string.upper(inst.recipetouse)].." "..STRINGS.NAMES.BLUEPRINT)
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
            return true
        end
    end
    return false
end

local function fn(is_rare)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blueprint")
    inst.AnimState:SetBuild("blueprint")
    inst.AnimState:PlayAnimation("idle")

    --Sneak these into pristine state for optimization
    inst:AddTag("_named")

    inst:SetPrefabName("blueprint")

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.is_rare = is_rare

    --Remove these tags so that they can be added properly when replicating components below
    inst:RemoveTag("_named")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("blueprint")

    inst:AddComponent("named")
    inst:AddComponent("teacher")
    inst.components.teacher.onteach = OnTeach

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    if not is_rare then
        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)
    else
        inst.AnimState:SetBank("blueprint_rare")
        inst.AnimState:SetBuild("blueprint_rare")
        inst.components.inventoryitem:ChangeImageName("blueprint_rare")
    end

    MakeHauntableLaunch(inst)
    AddHauntableCustomReaction(inst, OnHaunt, true, false, true)

    inst.OnLoad = onload
    inst.OnSave = onsave

    return inst
end

local function MakeSpecificBlueprint(specific_item)
    return function()
        local is_rare = false

        local r = GetValidRecipe(specific_item)
        if r ~= nil then
            for k, v in pairs(r.level) do
                if v >= 10 then
                    is_rare = true
                    break
                end
            end
        end

        local inst = fn(is_rare)

        if not TheWorld.ismastersim then
            return inst
        end

        local r = GetValidRecipe(specific_item)
        inst.recipetouse = r ~= nil and not r.nounlock and r.name or "unknown"
        inst.components.teacher:SetRecipe(inst.recipetouse)
        if is_rare then
            inst.components.named:SetName(subfmt(STRINGS.NAMES.BLUEPRINT_RARE, { item = STRINGS.NAMES[string.upper(inst.recipetouse)] }))
        else
            inst.components.named:SetName(STRINGS.NAMES[string.upper(inst.recipetouse)].." "..STRINGS.NAMES.BLUEPRINT)
        end
        return inst
    end
end

local function MakeSpice(name)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("spice_amakumo")
        inst.AnimState:SetBuild("spice_amakumo")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_spice", "spice_amakumo", name)

        inst:AddTag("spice")

        MakeInventoryFloatable(inst, "med", nil, 0.7)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "spice_amakumo"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/spice_amakumo.xml"
	    inst.components.inventoryitem:ChangeImageName("spice_amakumo")

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeSpice("spice_amakumo"),
    Prefab("spice_amakumo_blueprint", MakeSpecificBlueprint("spice_amakumo"), blueprint_assets)