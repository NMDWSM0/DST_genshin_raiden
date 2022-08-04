local function IsHUDScreen(inst) 
	local defaultscreen = false 
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name  and type(TheFrontEnd:GetActiveScreen().name) == "string"  and TheFrontEnd:GetActiveScreen().name == "HUD" then 
		defaultscreen = true 
	end 
	return defaultscreen 
end  

local KeyHandler_A = Class(function(self, inst)
	self.inst = inst
	self.paused = false
	self.enabled = true 
	self.ticktime = 0
	self.handler = TheInput:AddKeyHandler(function(key, down) 
	    self:OnRawKey(key, down) 
	end)
	self.mousehandler = TheInput:AddMouseButtonHandler(function(button, down, x, y) 
		self:OnRawButton(button, down, x, y)
	end)
	self.downkeys = {}
	self.skillkeys = {}
end)

function KeyHandler_A:SetSkillKeys(keys)
    self.skillkeys = keys
end

function KeyHandler_A:isinclude(key)
    for k,v in pairs(self.downkeys) do
	    if key == v then
			return true
		end
	end
	return false
end

function KeyHandler_A:SetEnabled(enable)
	self.enabled = enable
end 

function KeyHandler_A:CanTrigger()
	return self.enabled and IsHUDScreen(self.inst) and (self.inst.sg == nil or not self.inst.sg:HasStateTag("dead"))
	and self.inst.components.playercontroller:IsEnabled()
end 

function KeyHandler_A:OnRawKey(key, down)
	local player = ThePlayer
	if player ~= nil then
  		if (key and not down) and not self.paused then
      			player:PushEvent("keyup", {inst = self.inst, player = player, key = key})
				local a = self.downkeys
				for i = #a,1,-1 do
				    if self.downkeys[i] == key then
					    table.remove(self.downkeys,i)
					end
				end
		elseif key and down and not self.paused then
      			player:PushEvent("keydown", {inst = self.inst, player = player, key = key})
				if not self:isinclude(key) then
				    table.insert(self.downkeys,key)
				end
		end
  	end
end

function KeyHandler_A:IsKeyDown(key)
    return self:isinclude(key)
end

function KeyHandler_A:IsKeyDownForOtherSkills(key)
    for k,v in pairs(self.skillkeys) do
	    if v ~= key then
		    if self:IsKeyDown(v) then
			    return true
			end
		end
	end

	if self:IsKeyDown(400) or self:IsKeyDown(401) or self:IsKeyDown(402)  --ctrl,shift,alt
		or self:IsKeyDown(304) or self:IsKeyDown(306) or self:IsKeyDown(308)
		or self:IsKeyDown(303) or self:IsKeyDown(305) or self:IsKeyDown(307) then
			return true
	end

	return false 
end

function KeyHandler_A:OnRawButton(button, down, x, y)
	local player = ThePlayer
	if player ~= nil then
		if (button and not down) and not self.paused then
      		player:PushEvent("mousebuttonup", {inst = self.inst, player = player, button = button})
		elseif button and down and not self.paused then
      		player:PushEvent("mousebuttondown", {inst = self.inst, player = player, button = button})
		end
  	end
end

function KeyHandler_A:HandleRPC(Rpc, clientfn, restrict, key)
	local x,y,z = ( TheInput:GetWorldPosition() or Vector3(0,0,0) ):Get()
	local entity = TheInput:GetWorldEntityUnderMouse()
	local Namespace = Rpc.Namespace
	local Action = Rpc.Action
	if restrict then
	    if self:IsKeyDownForOtherSkills(key) then
	        return
		end
	end
	if clientfn then 
		clientfn(self.inst, x, y, z, entity)
	end	
	--[[if TheWorld.ismastersim then
		local masterfn = MOD_RPC_HANDLERS[Namespace][MOD_RPC[Namespace][Action].id]
		masterfn(self.inst, x, y, z, entity)
	else]]
		SendModRPCToServer(MOD_RPC[Namespace][Action], x, y, z, entity)
	--end
end 

function KeyHandler_A:AddActionListener(Key, Rpc, keytype, clientfn, restrict)
	local keyevent = keytype or "keyup"
	
	self.inst:ListenForEvent(keyevent, function(inst, data)
		if data.inst == ThePlayer then
			if data.key == Key then
				if self:CanTrigger()  and not ThePlayer:HasTag("playerghost") 
				and not (ThePlayer.components.health and ThePlayer.components.health:IsDead()) then
					self:HandleRPC(Rpc, clientfn, restrict, Key)
				end
			end
		end	
	end)
end

function KeyHandler_A:AddMouseActionListener(Button, Rpc, mousebuttontype, clientfn, restrict)
	local buttonevent = mousebuttontype or "mousebuttonup"
	
	self.inst:ListenForEvent(buttonevent, function(inst, data)
		if data.inst == ThePlayer then
			if data.button == Button then
				if self:CanTrigger()  and not ThePlayer:HasTag("playerghost") 
				and not (ThePlayer.components.health and ThePlayer.components.health:IsDead()) then
					self:HandleRPC(Rpc, clientfn, restrict, Button)
				end
			end
		end	
	end)
end

return KeyHandler_A