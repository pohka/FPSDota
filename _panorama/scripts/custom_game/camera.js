//the starting values for the camera
function SetCamera()
{
	//3rd person
	// GameUI.SetCameraPitchMin( 10 )
	// GameUI.SetCameraPitchMax( 10 )
	// GameUI.SetCameraLookAtPositionHeightOffset(100)
	// GameUI.SetCameraDistance(750)
	
	GameUI.SetCameraPitchMin( 0.1 )
	GameUI.SetCameraPitchMax( 0.1 )
	GameUI.SetCameraLookAtPositionHeightOffset(120)
	GameUI.SetCameraDistance(360)
}

//sets the rotation of the camera
function SetYaw(table_name, key, data)
{
	var playerID = "" + Players.GetLocalPlayer()
	if(key === playerID)
	{
		GameUI.SetCameraYaw(data.yaw)
	}
}

(function()
{
	GameEvents.Subscribe( "npc_spawned", SetCamera );
	CustomNetTables.SubscribeNetTableListener("camera", SetYaw);
})();