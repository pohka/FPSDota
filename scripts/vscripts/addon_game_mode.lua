-- Generated from template

if FPSCam == nil then
	_G.FPSCam = class({})
end

FPSCam.Dummies = {}

function Precache( context )
	PrecacheResource( "model", "models/development/invisiblebox.vmdl", context )
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = FPSCam()
	GameRules.AddonTemplate:InitGameMode()
end

function FPSCam:InitGameMode()
	local GameMode = GameRules:GetGameModeEntity()
	GameRules:SetPreGameTime( 2 )
	
	if IsInToolsMode() then
		GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	else
		GameRules:SetCustomGameSetupAutoLaunchDelay( 45 )
	end
	
	GameRules:SetPostGameTime(30)
	GameRules:EnableCustomGameSetupAutoLaunch(true)
	GameRules:SetSameHeroSelectionEnabled(true)

	--set custom values for game mode
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStickyItemDisabled(true)
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetAnnouncerDisabled(true)
	GameMode:SetDaynightCycleDisabled(true)
	GameMode:SetCustomGameForceHero("sniper")
	
	ListenToGameEvent("game_rules_state_change", FPSCam.OnGameStateChange, self)
	CustomGameEventManager:RegisterListener("input", FPSCam.OnInput)
end

--[[
	input.playerid : playerid of this input
	input.move_x : horizontal input (-1, 0 or 1) 
	input.move_y : vertical input (-1, 0 or 1) 
]]
function FPSCam:OnInput(input)
	if input.playerid ~= -1 then
		FPSCam:Move(input.playerid, input.move_x, input.move_y)
	end
end

--basic movement
function FPSCam:Move(playerID, x, y)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	
	if hero ~= nil then
		local direction = Vector(x,y,0):Normalized()
		hero:SetOrigin(hero:GetOrigin() + direction*10)
	end
end

--game state changed
function FPSCam:OnGameStateChange()
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		FPSCam:SpawnAndSetDummies()
	end
end

--spawns a camera dummy for each player if they dont already exists
--it then sets the camera target to dummies
function FPSCam:SpawnAndSetDummies()
	local minTeam = DOTA_TEAM_GOODGUYS
	local maxTeam = DOTA_TEAM_BADGUYS
	for team=minTeam, maxTeam do
		for n = 1, PlayerResource:GetPlayerCountForTeam(team) do
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(team, n)
			if playerID ~= nil and FPSCam.Dummies[playerID] == nil then
				local player = PlayerResource:GetPlayer(playerID)
				if player ~= nil then
					local hero = player:GetAssignedHero()
					if hero ~= nil then
						local forward = hero:GetForwardVector()
						local location = hero:GetAbsOrigin() + forward*100
						local dummy = CreateUnitByName("camera_dummy", location, false, hero, hero, team)
						dummy:GetAbilityByIndex(0):CastAbility()
						FPSCam.Dummies[playerID] = dummy
						PlayerResource:SetCameraTarget(playerID, dummy)
					end
				end
			end
		end
	end
end

