local READRAIDENCOOKBOOK = GLOBAL.Action({ priority= 2 })
READRAIDENCOOKBOOK.str = TUNING.GENSHIN_ACTION_READCOOKBOOK
READRAIDENCOOKBOOK.id = "READRAIDENCOOKBOOK"
READRAIDENCOOKBOOK.fn = function(act)
    local book = act.target
	local doer = act.doer
    if book and doer then
	    local succeeded = book:onuse(doer)
        if succeeded then
            doer.components.talker:Say(STRINGS.USE_RAIDENCOOKBOOK_SUCCEED)
        end
		return true
	end	
end
AddAction(READRAIDENCOOKBOOK)


AddComponentAction("SCENE", "inventoryitem", function(inst, doer, actions, right)
    if inst:HasTag("raiden_cookbooks") then
	    table.insert(actions, ACTIONS.READRAIDENCOOKBOOK)
    end
end)


local readraidencookbook_handler = ActionHandler(ACTIONS.READRAIDENCOOKBOOK, "dolongaction")
AddStategraphActionHandler("wilson", readraidencookbook_handler)
AddStategraphActionHandler("wilson_client", readraidencookbook_handler)