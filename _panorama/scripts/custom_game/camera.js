//the starting values for the camera
function SetCamera()
{
	GameUI.SetCameraPitchMin( 0.1 )
	GameUI.SetCameraPitchMax( 0.1 )
	
	//First person
	GameUI.SetCameraLookAtPositionHeightOffset(84)
	GameUI.SetCameraDistance(360)
	
	//3rd person cam
	//GameUI.SetCameraLookAtPositionHeightOffset(110)
	//GameUI.SetCameraDistance(550)
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
	CustomNetTables.SubscribeNetTableListener("camera", SetYaw);
})();