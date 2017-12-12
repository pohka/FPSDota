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
	GameRules:SetUseUniversalShopMode(true)

	--set custom values for game mode
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStickyItemDisabled(true)
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetAnnouncerDisabled(true)
	GameMode:SetDaynightCycleDisabled(true)
	GameMode:SetCustomGameForceHero("windrunner")
	
	
	Camera:Init(self)
	--CustomGameEventManager:RegisterListener("input", FPSCam.OnInput)
	ListenToGameEvent("game_rules_state_change", FPSCam.Setup, self)
	ListenToGameEvent("dota_player_used_ability", FPSCam.SetAbilityCooldown, self)
end

--[[
	input.playerid : playerid of this input
	input.move_x : horizontal input (-1, 0 or 1) i.e A,D
	input.move_y : vertical input (-1, 0 or 1) i.e. W,S
	input.cursor_x : cursor horizonal position (value from -1 to 1 and 0 is center) 
	input.cursor_y : cursor vertical position (value from -1 to 1 and zero is center) 
	
	To remove/change direction input keys change addoninfo.txt
]]
-- function FPSCam:OnInput(input)
	-- if input.playerid ~= -1 then
		-- --do something with input
	-- end
-- end

function FPSCam:Setup()
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		local minTeam = DOTA_TEAM_GOODGUYS
		local maxTeam = DOTA_TEAM_BADGUYS
		for team=minTeam, maxTeam do
			for n = 1, PlayerResource:GetPlayerCountForTeam(team) do
				local playerID = PlayerResource:GetNthPlayerIDOnTeam(team, n)
				if playerID ~= nil then
					local player = PlayerResource:GetPlayer(playerID)
					local hero = player:GetAssignedHero()
					hero:AddItemByName("item_force_staff")
					hero:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
					
					local abil = hero:FindAbilityByName("windrunner_powershot")
					abil:SetLevel(4)
				end
			end
		end
	end
end	

--custom cooldowns
FPSCam.cooldowns = {
	windrunner_powershot = 3,
	item_force_staff = 7
}

--sets the ability cooldowns
function FPSCam:SetAbilityCooldown(e)
	if self.cooldowns[e.abilityname] ~= nil then
		local player = PlayerResource:GetPlayer(e.PlayerID)
		local hero = player:GetAssignedHero()
		local abil = hero:FindAbilityByName(e.abilityname)
		if abil ~= nil then
			abil:EndCooldown()
			abil:StartCooldown(self.cooldowns[e.abilityname])
		else
			for i=0, 8 do
				local item = hero:GetItemInSlot(i)
				if item~= nil and item:GetAbilityName() == e.abilityname then
					item:EndCooldown()
					item:StartCooldown(self.cooldowns[e.abilityname])
				end
			end
		end
	end
end