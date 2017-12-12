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

--keeps dummy in front of player each frame
function camera_dummy_abil:SetPos()
	local caster = self:GetCaster()
	local owner = caster:GetOwner()
	if owner ~= nil then
		--calculte yaw rotation
		
		local forward = owner:GetForwardVector()
		
		-- degrees = acos(v1:Dot(v2)/|v1|*|v2|)
		local dot = self.WORLD_FORWARD:Dot(forward)
		local a = dot/(self.WORLD_FORWARD:Length() * forward:Length())
		local val = math.acos(a)
		local degrees = val/math.pi  * 180
		
		--check if vectors are pointing in the same direction
		local cross = self.WORLD_FORWARD:Cross(forward)
		if cross.z < 0 then
			 degrees = -degrees
		end
		
		local pos = owner:GetOrigin() + forward * self.OFFSET
		pos.z = owner:GetAbsOrigin().z 
		caster:SetAbsOrigin(pos)
		--local h = GetGroundHeight(owner:GetAbsOrigin(), owner)
		
		local keyName = "" .. tostring(owner:GetPlayerID())
		CustomNetTables:SetTableValue("camera", keyName, { yaw = degrees })
		
		
	else
		print("owner of camera_dummy not found")
	end
	return self.TICK_RATE
end