//the starting values for the camera
function SetCamera()
{
	GameUI.SetCameraPitchMin( 10 )
	GameUI.SetCameraPitchMax( 10 )
	GameUI.SetCameraLookAtPositionHeightOffset(-10)
	GameUI.SetCameraDistance( 380)
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