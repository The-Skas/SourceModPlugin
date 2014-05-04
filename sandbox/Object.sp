#include "../helper.inc"


enum Object_Attr
{
	bool:isUsed,
	Integer:anInt,
	Float:aFloat,
	Integer:aString
}

#define MAX_SIZE 10


//Used to manage available instances
//all global instances
static any:g_Object[MAX_SIZE][Object_Attr];

static any:t_Object[3];
//TEMP is used in g_Object as an instance for temporary calculations
#define TEMP 'T'
#define ZERO 0
static bool:isTemp = false;
//Start from '1', SINCE TEMP is at '0'
static any:_nextInstance = 1;


									
stock Object: new_Object(Object:obj = Object:-1, int = 5, Float:float = 3.05)
{
	//TODO:a sharable Allocation function.
	new instance = _nextInstance;

	g_Object[instance][isUsed] = true;

	if(obj == Object:-1)
	{	//if no object passed, set values to default
		g_Object[instance][anInt] = any:int;
		g_Object[instance][aFloat] = any:float;
		g_Object[instance][aString] = any:4;
	}
	else
	{	//else copy object's values in.
		g_Object[instance][anInt] = g_Object[obj][anInt];
		g_Object[instance][aFloat] = g_Object[obj][aFloat];
		g_Object[instance][aString] = g_Object[obj][aString];
	}

	//Increment nextInstance
	_nextInstance++;

	return Object:instance;
}

public delete_Object(Object:object)
{
	PrintToServer("Deleting obj %i", any:object);

	g_Object[any:object][0] = false;
}

//Had issues adding arrays.
public Object: operator+(Object:a, Object:b) {
	//Initalise C at pos '2'
		//TODO - Create a default array, manager.
	PrintToServer("In Object: + operator indice a: %i -- b: %i", a,b);

	g_Object[0][anInt] = g_Object[a][anInt] + g_Object[b][anInt];

	PrintToServer("G_Object 0 %i", g_Object[0][anInt]);

	g_Object[0][aFloat]= Float:g_Object[a][aFloat] + Float:g_Object[b][aFloat];

	g_Object[0][aString] = g_Object[a][aString] + g_Object[b][aString];
	
	//Used to toggle if there is temporary storage.
	isTemp = true;

	return Object:ZERO;
}

/**
 * The '=' overloads assignment AND
 * calling 'new'
 * 
 * new Object:aVarName
 */
	
public Object: operator=(Object:obj)
{
	//TEMP signifies that the object is from the temp variable
	if(isTemp)
	{
		isTemp = false;
		PrintToServer("In equal value t: %i %f",g_Object[ZERO][anInt], g_Object[ZERO][aFloat]);

		return new_Object(Object:ZERO);
	}
	
	
	return Object:obj;
}


//OnPluginStart -> main
public OnPluginStart()
{
	
	for(new i = 0; i < 3; i ++)
	{
		new Object:obj = new_Object();
		PrintToServer("Object ind %i is : %i %f",i, g_Object[0][anInt],g_Object[0][aFloat] );
	}				  

					// _Object_new();
	new Object:objA = new_Object();
	new Object:objB = new_Object();
	new Object:objC = objA + objB;
	new Object:objD = objA + objB + objC + objA;
	PrintToServer("Get last instance : %i", _nextInstance - 1);
	PrintToServer("Object C[%i]  is : %i %f",objC, g_Object[objC][anInt],g_Object[objC][1]);
	PrintToServer("Object D[%i]  is : %i %f",objD, g_Object[objD][anInt],g_Object[objD][1]);

	for(new any:i = 0; i < MAX_SIZE; i++)
	{
		PrintToServer("Array value:[%i] = %b ", i, g_Object[i]);
	}

	//Testing Deleting
	delete_Object(objA);


	for(new any:i = 0; i < MAX_SIZE; i++)
	{
		PrintToServer("Array value:[%i] = %b ", i, g_Object[i]);
	}


	for(new any:i = 0; i < 3; i++) {
		for(new any:j = 0; j < Object_Attr; j++) {

		}
	}


}