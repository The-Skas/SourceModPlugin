Globals{}

public OnPluginStart()
{
	CreateTimer(1.0, LoadStuff,_,TIMER_REPEAT);
	g_Charlie = CreateGlobalForward("Charlie",ET_Single ,Param_String);
	//Run tests
	//*For each file run its equivilant '%File_Name%Test();'
	
}