/**
 * File that has all helper functions shared amongst several programs
 */


#define private static
#define min(%1,%2) ((%1) < (%2) ? (%1) : (%2))
#define PI 3.14159265359
#define DEG2RAD(%1) ((%1) * PI / 180)

stock void:printD(const String:printStr[], any:...)
{
	if(DEBUG)
	{
		new String:myFormattedString[256];
		VFormat(myFormattedString, sizeof(myFormattedString), printStr, 2);
		PrintToServer(myFormattedString);
	}
}

stock void:printT(const String:printStr[], any:...)
{
	new String:myFormattedString[256];
	VFormat(myFormattedString, sizeof(myFormattedString), printStr, 2);
	PrintToServer("		%s", myFormattedString);
}
stock pause()
{
	for(;;)
	{
		
	}
}

stock static thrustRobot()
{

}

stock printVector(any:astring[], any:vec[])
{
	PrintToServer("%s x %f - y %f - z %f",
								   astring,
								   vec[0],
								   vec[1],
								   vec[2]);
}

/**
 * Prints Client Velocity
 *
 * @param client - entity id of client
 */

stock void:printClientVelocity(client)
{
	if(!isClientAlive(client))
		return;
		
	new Float:vecVelocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", vecVelocity);
	printVector("Client vel ", vecVelocity);
}
/**
 * Prints Client's Absolute Velocity
 * 
 * @param client - entity id of client
 */
stock void:printClientAbsVelocity(client)
{
	if(!isClientAlive(client))
		return;
		
	new Float:vecAbsVelocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vecAbsVelocity);
	printVector("Client abs vel ", vecAbsVelocity);
}

/**
 * Returns if Client is Alive
 * 
 * @param client - the entity id of the client
 * @return bool  
 */
stock bool:isClientAlive(client)
{
	return (IsValidEntity(client)&&IsPlayerAlive(client));
}

/**
 * returns a sub array, from start index, to end index
 * of an existing array.
 *
 * @param array			Array[]
 * @param indStart		int
 * @param indEnd		int
 * @return 				Array[indEnd-indStart]
 */
stock subArray(any:old_arr[], any:new_arr[],indStart, indEnd)
{
	for(new i = indStart; i <= indEnd; i++)
	{
		new_arr[i] = any:old_arr[i];
	}
}