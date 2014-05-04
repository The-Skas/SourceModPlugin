#include "../helper.inc"

/**
 *  @author: Skas
 *
 *	File 'Object.sp'
 *
 * 	This class/file is meant to emulate an object oriented
 * 	behaviour for use in Sourcepawn. 
 *
 * 	The idea is to have a static global Variable of instances
 * 	in a TYPELESS array. 
 *
 *
 * 
 */

enum Object_Attr
{
	bool:isUsed,
	Integer:anInt,
	Float:aFloat,
	Integer:aString
}

#define MAX_SIZE 10

functag MyFunction public(client);
native My_NativeEx(MyFunction:func);
//Used to manage available instances
//all global instances
static any:g_Object[MAX_SIZE][Object_Attr];

//TEMP is used in g_Object as an instance for temporary calculations
#define DEFAULT 0
#define TEMP 1
static bool:isTemp = false;
//Start from '1', SINCE TEMP is at '0'
static any:_nextInstance = 2;


stock Object(instance, _instance = 0)
{
	if(_instance == 0)
	{
		//Default Constructor
	}
	else
	{
		//Copy Constructor
	}
}

stock Object: new_Object(Object:obj, int = 5, Float:float = 3.05)
{
	//TODO:a sharable Allocation function.
	new instance = _nextInstance;

	g_Object[instance][isUsed] = true;

	//this signifies there isnt a temp object.

	g_Object[instance][anInt] = g_Object[obj][anInt];
	g_Object[instance][aFloat] = g_Object[obj][aFloat];
	g_Object[instance][aString] = g_Object[obj][aString];

	//Increment nextInstance
	_nextInstance++;

	return Object:instance;
}

Func()
{

}

public Object_delete(Object:object)
{

	PrintToServer("Deleting obj %i", any:object);

	g_Object[any:object][0] = false;
}


public Object: operator+(Object:a, Object:b) {
	//Initalise C at pos '2'
		//TODO - Create a default array, manager.
	PrintToServer("In Object: + operator indice a: %i -- b: %i", a,b);

	g_Object[TEMP][anInt] = g_Object[a][anInt] + g_Object[b][anInt];

	PrintToServer("G_Object 0 %i", g_Object[0][anInt]);

	g_Object[TEMP][aFloat]= Float:g_Object[a][aFloat] + Float:g_Object[b][aFloat];

	g_Object[TEMP][aString] = g_Object[a][aString] + g_Object[b][aString];
	
	//Used to toggle if there is temporary storage.
	isTemp = true;

	return Object:TEMP;
}

/**
 * The '=' overloads assignment 
 * 
 * This is called on a 'new Object:objA'
 * or on assignment such as 'objA = objB'
 * given objB is a tag Object
 * 
 * new Object:aVarName
 */
	
public Object: operator=(Object:obj)
{
	//isTemp signifies that the object is from the temp variable
	if(any:obj == TEMP)
	{
		PrintToServer("In equal value t: %i %f",g_Object[TEMP][anInt], g_Object[TEMP][aFloat]);

		return new_Object(Object:TEMP);
	}
	
	
	return Object:obj;
}



//OnPluginStart -> main
public OnPluginStart()
{
	for(new i = 0; i < 3; i ++)
	{
		new Object:obj = new_Object(obj);
		PrintToServer("Object ind %i is : %i %f",i, g_Object[0][anInt],g_Object[0][aFloat] );
	}				  

					// _Object_new();
	new Object:objA = new_Object(objA);
	new Object:objB = new_Object(objB);
	new Object:objC = objA + objB;
	new Object:objD = objA + objB + objC + objA;
	PrintToServer("ObjA ind is: %i", objA);

	PrintToServer("Get last instance : %i", _nextInstance - 1);
	PrintToServer("Object C[%i]  is : %i %f",objC, g_Object[objC][anInt],g_Object[objC][aFloat]);
	PrintToServer("Object D[%i]  is : %i %f",objD, g_Object[objD][anInt],g_Object[objD][aFloat]);

	for(new any:i = 0; i < MAX_SIZE; i++)
	{
		PrintToServer("Array value:[%i] = %b ", i, g_Object[i]);
	}
	PrintToServer("ObjA ind is: %i", objA);

	//Testing Deleting

	Object_delete(objA);
	

	for(new any:i = 0; i < MAX_SIZE; i++)
	{
		PrintToServer("Array value:[%i] = %b ", i, g_Object[i]);
	}


	for(new any:i = 0; i < 3; i++) {
		for(new any:j = 0; j < Object_Attr; j++) {

		}
	}


}