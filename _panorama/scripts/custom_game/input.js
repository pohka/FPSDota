/*
	stores values for input
	direction values are always -1, 0 or 1
*/
var inputBuffer = {
	up : 0,
	down : 0,
	left : 0,
	right : 0
};

//callback functions for keybinds
function UpPressed(){ inputBuffer["up"] = 1; }
function UpReleased(){ inputBuffer["up"] = 0; }
function DownPressed(){ inputBuffer["down"] = 1; }
function DownReleased(){ inputBuffer["down"] = 0; }
function LeftPressed(){ inputBuffer["left"] = 1; }
function LeftReleased(){ inputBuffer["left"] = 0; }
function RightPressed(){ inputBuffer["right"] = 1; }
function RightReleased(){ inputBuffer["right"] = 0; }

//sends input to server each frame
function SendInput()
{
	var playerID = Players.GetLocalPlayer()
	
	//convert cursor position in a value form -1 to 1, with 0 being the center of the axis
	var cursorPos = GameUI.GetCursorPosition();
	var halfScreenW = Game.GetScreenWidth() * 0.5;
	var halfScreenH = Game.GetScreenHeight() * 0.5;
	var cursorX = (cursorPos[0] - halfScreenW) / halfScreenW;
	var cursorY = -(cursorPos[1] - halfScreenH) / halfScreenH;
	
	GameEvents.SendCustomGameEventToServer("input", { 
		playerid : playerID, 
		move_x : inputBuffer["right"] - inputBuffer["left"],
		move_y : inputBuffer["up"] - inputBuffer["down"],
		cursor_x : cursorX,
		cursor_y : cursorY,
	});
	$.Schedule(0.03, SendInput)
}

(function()
{
	Game.AddCommand( "+UpKey", UpPressed, "", 0 );
	Game.AddCommand( "-UpKey", UpReleased, "", 0 );
	Game.AddCommand( "+DownKey", DownPressed, "", 0 );
	Game.AddCommand( "-DownKey", DownReleased, "", 0 );
	Game.AddCommand( "+LeftKey", LeftPressed, "", 0 );
	Game.AddCommand( "-LeftKey", LeftReleased, "", 0 );
	Game.AddCommand( "+RightKey", RightPressed, "", 0 );
	Game.AddCommand( "-RightKey", RightReleased, "", 0 );
	GameEvents.Subscribe( "npc_spawned", SetCamera );
	SendInput()
})();