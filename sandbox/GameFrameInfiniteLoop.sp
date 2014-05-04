public Plugin:myinfo =
{
	name = "GameFrameInfiniteLoop",
	author = "Skas",
	description = "Get Plugin",
	version = "1.0",
	url = "http://www.sourcemod.net/"
}

new Handle:g_Charlie;
public OnPluginStart()
{
	CreateTimer(1.0, LoadStuff,_,TIMER_REPEAT);
	g_Charlie = CreateGlobalForward("Charlie",ET_Single ,Param_String);
	//Run tests
	//*For each file run its equivilant '%File_Name%Test();'
	
}
public Action:LoadStuff(Handle:timer)
{
	//Ran into an issue in testing openFile

}
public OnGameFrame()
{
	
}