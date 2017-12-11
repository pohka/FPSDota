camera_dummy_abil = class({})
LinkLuaModifier("camera_dummy_abil_modifier", "abils/camera_dummy_abil_modifier", LUA_MODIFIER_MOTION_NONE)

camera_dummy_abil.TICK_RATE = 0.03
camera_dummy_abil.OFFSET = 400
camera_dummy_abil.WORLD_FORWARD = Vector(0,1,0)

--setup dummy
function camera_dummy_abil:OnSpellStart()
	local caster = self:GetCaster()
	caster:SetHullRadius(0)
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	caster:AddNewModifier(caster, self, "camera_dummy_abil_modifier", {})
	self:SetContextThink("Tick", function() return self:SetPos() end, self.TICK_RATE)
end

--keeps dummy in from of player each frame
function camera_dummy_abil:SetPos()
	local caster = self:GetCaster()
	local owner = caster:GetOwner()
	if owner ~= nil then
		local forward = owner:GetForwardVector()
		local pos = owner:GetOrigin() + forward * self.OFFSET
		
		local dot = self.WORLD_FORWARD:Dot(forward)
		--local rot = 
		local cross = self.WORLD_FORWARD:Cross(forward)
		
		--print("rot:" .. tostring(rot))
		--print("cross:" .. tostring(cross.z))
		local a = dot/(self.WORLD_FORWARD:Length2D() * forward:Length2D())
		local val = math.acos(a)
		--print("a:" .. tostring(a))
		--print("val:" .. tostring(val))
		local degrees = val/math.pi  * 180
		if cross.z < 0 then
			 degrees = -degrees
		end
		--print("deg:" .. tostring(degrees))
		
		local keyName = "" .. tostring(owner:GetPlayerID())
		CustomNetTables:SetTableValue("camera", keyName, { yaw = degrees })
		caster:SetOrigin(pos)
	else
		print("owner of camera_dummy not found")
	end
	return self.TICK_RATE
end