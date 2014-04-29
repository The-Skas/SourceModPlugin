#define dude 0.1

#include <sourcemod>
#include <sdktools>
#include "globals.inc"
public Plugin:myinfo =
{
	name = "Beta",
	author = "Skas",
	description = "Get Plugin",
	version = "1.0",
	url = "http://www.sourcemod.net/"
}

public OnPluginStart()
{
	CreateTimer(1.0, LoadStuff,_,TIMER_REPEAT);
	//Run tests
	//*For each file run its equivilant '%File_Name%Test();'
	
}//semi clones hah, fucked up errors
public OnGameFrame()
{
	
}
forward AyYoG();
public Action:LoadStuff(Handle:timer)
{
	new Handle:file = OpenFile("averyuniquefile.txt","a+");
	if (file == INVALID_HANDLE)
	{
		PrintToServer("Invalid handlez");
	}
	PrintToServer("BETA-tX: %i", tX);
	if(WriteFileString(file, "COOL", true))
	{
		PrintToServer("Success!");
	}
	tX = 10;
	CloseHandle(file);
}
//this might as well be a different name. 
//The purpose is to have a user execute a user written function @ run time -
//replacing existing function. Or perhaps just running his own code here. 
//That seems possible. I dont think its possible to replace a code thats already compiled.
//Perhaps replacing a dynamic parameter such as a pass by. But not #DEFINES!
//Hmmm.. perhaps i can request to access a specific value

