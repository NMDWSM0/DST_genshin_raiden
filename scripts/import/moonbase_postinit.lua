AddPrefabPostInit("moonbase", function (inst)
    local KEY_STAFF = "yellowstaff"
    local function HasStaff(inst, staffname)
        return (inst._staffinst ~= nil and inst._staffinst.prefab or inst.components.pickable.product) == staffname
    end

    local upvaluehelper = require("import/upvaluehelper")
    local timerdonefn = upvaluehelper.GetEventHandle(inst, "timerdone","prefabs/moonbase")
    if timerdonefn then
		inst:RemoveEventCallback("timerdone", timerdonefn)
        local function editted_timerdonefn(inst, data)
            if data.name == "mooncharge" and inst.components.pickable.caninteractwith and HasStaff(inst, KEY_STAFF) then
                local bp = SpawnPrefab("engulfinglightning_blueprint")
                local x, y, z = inst.Transform:GetWorldPosition()
                if bp ~= nil then
                    if bp.Physics ~= nil then
                        local speed = 2 + math.random()
                        local angle = math.random() * 2 * PI
                        bp.Physics:Teleport(x, y + 1, z)
                        bp.Physics:SetVel(speed * math.cos(angle), speed * 3, speed * math.sin(angle))
                    else
                        bp.Transform:SetPosition(x, y, z)
                    end
                end
            end
            timerdonefn(inst, data)
        end
        
        inst:ListenForEvent("timerdone", editted_timerdonefn)
    end
end)