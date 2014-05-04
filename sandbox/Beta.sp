#define dude 0.1

#include <sourcemod>
#include <sdktools>
#include "../globals.inc"
public Plugin:myinfo =
{
	name = "Beta",
	author = "Skas",
	description = "Get Plugin",
	version = "1.0",
	url = "http://www.sourcemod.net/"
}

new Handle:g_Charlie;
public OnPluginStart()
{
	CreateTimer(1.0, LoadStuff,_,TIMER_REPEAT);
	g_Charlie = CreateGlobalForward("Charlie",ET_Single );
	//Run tests
	//*For each file run its equivilant '%File_Name%Test();'
	
}//semi clones hah, fucked up errors
public OnGameFrame()
{
	
}

forward Charlie( String:astr[]);
public Action:LoadStuff(Handle:timer)
{
	//Ran into an issue in testing openFile
	decl result;
	Call_StartForward(g_Charlie);
	Call_PushString("Hey!");
	Call_Finish(result);
}
//this might as well be a different name. 
//The purpose is to have a user execute a user written function @ run time -
//replacing existing function. Or perhaps just running his own code here. 
//That seems possible. I dont think its possible to replace a code thats already compiled.
//Perhaps replacing a dynamic parameter such as a pass by. But not #DEFINES!
//Hmmm.. perhaps i can request to access a specific value

