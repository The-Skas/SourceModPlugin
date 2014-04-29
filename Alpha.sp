#include <sourcemod>
#include <sdktools>

#pragma semicolon 1

#define CLIENT_ID 1
//To stop compiler warning 206
#define Robot.%1
		
		
#define MAX_CLIENTS 32
#define Client_Attrb 4

//Client 
enum CLIENT_ATTRIBS
{
	CL_aX,
	CL_aY,
	CL_aZ,
	CL_THRUST_ON
}

//To get around index tag mismatch : warning 229 set raw value
//we need to set a number N (eg: '4')
new g_Client[MAX_CLIENTS][4];
//Globals END


//User Includes
#include "globals.inc"
#include "Robot.inc"
#include "tests/tests.inc"




public Plugin:myinfo =
{
	name = "My First Pluginz",
	author = "Skas",
	description = "Get Plugin",
	version = "1.0",
	url = "http://www.sourcemod.net/"
};
 
public OnPluginStart()
{
	Robot.aFunc();
	//Run tests
	//*For each file run its equivilant '%FileName%Test();'
	CreateTimer(1.0, LoadStuff,_,TIMER_REPEAT);

	PrintToServer("Hello world!");
	//commands
	RegConsoleCmd("thrust", Command_Thrust);
	//hooks
	HookEvent("player_spawn", OnPlayerSpawned);
	
}
public Action:LoadStuff(Handle:timer)
{
	PrintToServer("ALPHA-tX: %i", tX);

}
public Action:OnPlayerSpawned(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	// FakeClientCommandEx(client, "bind shift +_thrust");
	// FakeClientCommand(client, "noclip");
	// FakeClientCommand(client, "bind shift +_thrust");
	new String:message[2000] = "Lorem Ipsum is simply dummy text of the \n printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum";
	
	new Handle:kv = CreateKeyValues("Stuff", "title", message);
	KvSetNum(kv, "level", 1);
	KvSetNum(kv, "time", 10);
	
	CreateDialog(client, kv, DialogType_Msg);
	
	CloseHandle(kv);	
	// PrintToChatAll("to enable jetpack set the following commands to console: \n alias +_thrust thrust 1 \n alias -_thrust thrust 0 \n bind shift +thrust \n Use SHIFT to jetpack.");
	ResetClient(client);
}

ResetClient(client)
{
	for(new i = 0; i < any:CLIENT_ATTRIBS; i++)
		g_Client[client][i] = 0;
}
//move to different file
public Action:Command_Thrust(client, args)
{
	new String:arg[128];
	new String:full[256];
 
	GetCmdArgString(full, sizeof(full));
 
	if (client)
	{
		PrintToServer("Command from client: %i", client);
	} 
	for (new i=1; i<=2; i++)
	{
		GetCmdArg(i, arg, sizeof(arg));
		if(arg[0] == '0') {
			PrintToServer("(OFF) Thrust");
			g_Client[client][CL_THRUST_ON] = false;
		}else if(arg[0] == '1') {
			PrintToServer("(ON) Thrust");
			g_Client[client][CL_THRUST_ON] = true;
		}
	}
	return Plugin_Handled;
}
public OnGameFrame()
{
	tX = 4;
	printClientAbsVelocity(1);
	printClientVelocity(1);
	//These lines Are the thruster code*
	//
	for(new i = 1; i < MaxClients; i++)
	{
		//This should belong to the boss.
		if(isClientAlive(i)) {
			thrusterLogic(g_Client,i);
		}
		//Update all relevant code for this Player entity indice.

	}
}


//OnClientConnect
//Set up binds.

//OnClientDisconnect
//Restore Binds.

//Can create default values


//OnPlayeRunCMD 
//+ Does not BREAK Doors when using velocity.
// public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
// {
// 	if(IsPlayerAlive(client))
// 	{
// 		if(buttons & IN_JUMP)
// 		{

// 			//Here should scale to amount of ticks
// 			g_Client[CL_aZ] = 20;
// 			new Float:vecAbsVelocity[3];
// 			GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vecAbsVelocity);

// 			vecAbsVelocity[2] += g_Client[CL_aZ];
		
// 			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vecAbsVelocity);

// 			
// 		}
// 	}
// 	return Plugin_Continue;
// }


