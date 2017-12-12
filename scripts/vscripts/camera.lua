--[[
	Known problems with this camera
	-----------------------------------
	* Does not work with height on the map
	* The camera transform is limited near the top section of map
	* The camera dips lower the futher you move away from the spawn point
]]

if Camera == nil then
	print("[Physics] Creating Camera")
	Camera = class ({})
end

Camera.Dummies = {}

--create camera when the game starts
function Camera:Init(ctx)
	ListenToGameEvent("game_rules_state_change", 
	function()
		local state = GameRules:State_Get()
		if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			Camera:SpawnAndSetDummies()
		end
	end
	, ctx)
end

--spawns and assigns camera dummies for each player
function Camera:SpawnAndSetDummies()
	local minTeam = DOTA_TEAM_GOODGUYS
	local maxTeam = DOTA_TEAM_BADGUYS
	for team=minTeam, maxTeam do
		for n = 1, PlayerResource:GetPlayerCountForTeam(team) do
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(team, n)
			if playerID ~= nil and Camera.Dummies[playerID] == nil then
				local player = PlayerResource:GetPlayer(playerID)
				if player ~= nil then
					local hero = player:GetAssignedHero()
					if hero ~= nil then
						local forward = hero:GetForwardVector()
						local location = hero:GetAbsOrigin() + forward*100
						local dummy = CreateUnitByName("camera_dummy", location, false, hero, hero, team)
						dummy:GetAbilityByIndex(0):CastAbility()
						Camera.Dummies[playerID] = dummy
						PlayerResource:SetCameraTarget(playerID, dummy)
					end
				end
			end
		end
	end
end