if FPSCam == nil then
	_G.FPSCam = class({})
end

require('camera')

function Precache( context )
	PrecacheResource( "model", "models/development/invisiblebox.vmdl", context )
end

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
		GameRules:SetCustomGameSetupAutoLaunchDelay( 60 )
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
	GameMode:SetCustomGameForceHero("windrunner")
	
	Camera:Init(self)
	CustomGameEventManager:RegisterListener("input", FPSCam.OnInput)
end

--[[
	input.playerid : playerid of this input
	input.move_x : horizontal input (-1, 0 or 1) i.e A,D
	input.move_y : vertical input (-1, 0 or 1) i.e. W,S
	input.cursor_x : cursor horizonal position (value from -1 to 1 and 0 is center) 
	input.cursor_y : cursor vertical position (value from -1 to 1 and zero is center) 
	
	To remove/change direction input keys edit addoninfo.txt
]]
function FPSCam:OnInput(input)
	if input.playerid ~= -1 then
		--do something with input
	end
end
