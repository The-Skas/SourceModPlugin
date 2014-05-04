#if defined _ROBOT_INCLUDED
	#endinput
#endif
#define _ROBOT_INCLUDED
#define MAX_ROBOTS 32

#include "Entity.inc"
#include "helper.inc"

 static const Float:INIT_JUMP_VEL = 255.0;
 static const Float:MAX_THRUST_X_VEL = 500.0;
 static const Float:MAX_THRUST_Y_VEL = 140.0;
 static const Float:HOVER_Z_ACC = 15.00;
 static const Float:THRUSTER_ACC = 35.0;
 static const Float:THRUSTER_Z_ACC = 40.0;
 static const Float:FRICTION	   = 1.00;


enum Robot_Attrb
{
	Robot_vX,
	Robot_vY,
	Robot_vZ,
	Robot_thrustOn
}

enum AxisAngles
{
	x_z,
	x_y
}



//have instances of current objects in refrence.
static Robot:instances[MAX_ROBOTS][Robot_Attrb];
public Robot:Robot_getInstance(Int:i, Robot:newRobot[Robot_Attrb] )
{
	newRobot = instances[i];
}

public void:Robot_setInstance(const Robot:robot[Robot_Attrb], Int:i)
{
	instances[i] = robot;
}


//Call test;
public Robot: operator*(Robot:a, Robot: b) {
	PrintToServer("I am adding");
	//ADD TWO ROBOTS TOGETHER!
	
}


forward Float:getClientXYAngles(client);
stock thrusterLogic(g_temp_Client[][],const client)
{
	//Should this be here? Who calls thrusterlogic?
	//Is thruster On?
	if(g_Client[client][CL_THRUST_ON])
	{
		new Float:radXY = getClientXYAngles(client);
		new const Float:scaleVx = Cosine(radXY);
		new const Float:scaleVy = Sine(radXY );
		

		//Perform Button Checks of the client.
		//g_Client passed in to signify input params
		new bool:isButtonPressed = buttonLogic(g_temp_Client, client, any:scaleVx, any:scaleVy);
		//Normalizes and Scales the vector 
		

		normalizeAndScaleAcc(g_temp_Client, client);
		//reInits Z accel after Normalization so it wont affect it.
		g_temp_Client[client][CL_aZ] = any:THRUSTER_Z_ACC;
	

		new Float:vecAbsVelocity[3];
		GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vecAbsVelocity);

							//Must convert to float otherwise, overflow
		vecAbsVelocity[0]+= Float:g_Client[client][CL_aX];
		vecAbsVelocity[1]+= Float:g_Client[client][CL_aY];
		
		//Ceils the vector to a maximum velocity
		ceilAbsVelocity(vecAbsVelocity);

		new Float:tFriction = (isButtonPressed ? 1.0 : 0.95);
		//Calculate Friction After Always for only X , Y - axis.
		vecAbsVelocity[0] *=tFriction;
		vecAbsVelocity[1] *=tFriction;
		
		//If On ground
		if(IsEntityOnGround(client))
		{
			vecAbsVelocity[2] = INIT_JUMP_VEL;
		}
		else
		{
			vecAbsVelocity[2] += Float:g_Client[client][CL_aZ];

			new buttons = GetClientButtons(client);
			if(buttons & IN_JUMP) {
				vecAbsVelocity[2] = min(MAX_THRUST_Y_VEL,vecAbsVelocity[2]);
			}
			else
			{
				vecAbsVelocity[2] = min(HOVER_Z_ACC,vecAbsVelocity[2]);
			}
		}


		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vecAbsVelocity);

		//ResetAccel for next Loop
		//--BAD PRACTICE
		//Reseting a global variable here can result in tricky bugs to figure
		//out. Since we may be replacing the values accidently in another frame.
		

	}
	
}

stock static Float:getClientXYAngles(client)
{
	new Float:viewAngle[3];
	GetClientEyeAngles(client, viewAngle);
		//ScalevY to angle
	return (DEG2RAD(viewAngle[1]));
}

//Button Logic Of the Thruster
stock static bool:buttonLogic(g_temp_Client[][], const client, const Float:scaleVx, const Float:scaleVy)
{
	new buttons = GetClientButtons(client);

	new bool:isButtonPressed = false;

	//Reset Thruster velocity
	g_temp_Client[client][CL_aX] = any:0.0;
	g_temp_Client[client][CL_aY] = any:0.0;
	g_temp_Client[client][CL_aZ] = any:0.0;
	printD("ScalevY: %f", scaleVy);
	printD("ScalevX: %f", scaleVx);
	if(buttons & IN_FORWARD)
	{
		//90 degree sin
		g_temp_Client[client][CL_aY] = any:(THRUSTER_ACC * scaleVy); 
		g_temp_Client[client][CL_aX] = any:(THRUSTER_ACC * scaleVx);
		isButtonPressed = true;
	}

	if(buttons & IN_BACK)
	{
		
		g_temp_Client[client][CL_aY] = any:((-THRUSTER_ACC * scaleVy) + Float:g_temp_Client[client][CL_aY]); 
		g_temp_Client[client][CL_aX] = any:((-THRUSTER_ACC * scaleVx) + Float:g_temp_Client[client][CL_aX]);

		isButtonPressed = true;
	}

	if(buttons & IN_MOVERIGHT)
	{
		//flip assignments *confusing*
		g_temp_Client[client][CL_aY] = any:((-THRUSTER_ACC * scaleVx) + Float:g_temp_Client[client][CL_aY]);
		g_temp_Client[client][CL_aX] = any:((THRUSTER_ACC * scaleVy)  + Float:g_temp_Client[client][CL_aX]);
		
		isButtonPressed = true; 
	}

	if(buttons & IN_MOVELEFT)
	{
		//flip assignments *confusing*
		g_temp_Client[client][CL_aY] = any:((THRUSTER_ACC * scaleVx) + Float:g_temp_Client[client][CL_aY]);
		g_temp_Client[client][CL_aX] = any:((-THRUSTER_ACC * scaleVy)+ Float:g_temp_Client[client][CL_aX]); 
		isButtonPressed = true;
	}

	return isButtonPressed;
}

static normalizeAndScaleAcc(g_temp_Client[][],const client)
{
	new Float:clientAcc[3];
	//copy into clientAcc

	subArray(g_temp_Client[client], clientAcc, 0, 2);
	//Scale Vector to Thruster acceleration

	NormalizeVector(any:clientAcc, any:clientAcc);


	ScaleVector(clientAcc, THRUSTER_ACC);
	//Copy back into g_temp_Client
	subArray(clientAcc,g_temp_Client[client], 0, 2);
}

static ceilAbsVelocity(Float:vecAbsVelocity[3])
{
	//dont touch z (2)
	new Float:magnitudeXY = SquareRoot(vecAbsVelocity[0] * vecAbsVelocity[0] +
								 vecAbsVelocity[1] * vecAbsVelocity[1]);
	vecAbsVelocity[0]/=magnitudeXY;
	vecAbsVelocity[1]/=magnitudeXY;

	vecAbsVelocity[0] *= min(magnitudeXY, MAX_THRUST_X_VEL);
	vecAbsVelocity[1] *= min(magnitudeXY, MAX_THRUST_X_VEL);
}
//**Tests

/**
 * Robot Enum
 * enum Robot_Attrb
	{
		Robot_vX,
		Robot_vY,
		Robot_vZ,
		Robot_thrustOn
	}
 */

//variables
static Robot:testRobot[Robot_Attrb];
public Robot_Test()
{
	init();
	Should_Have_Zero_Accel_At_End_Of_buttonLogic();
}

static init()
{
	for(new i = 0; i < any:Robot_Attrb; i++) 
	{
		testRobot[i] = any:0;
	}

}

static bool:Should_Have_Zero_Accel_At_End_Of_buttonLogic()
{
	new g_temp_Client[1][Client_Attrb];
	buttonLogic(g_temp_Client, 0, Float:1.0, Float:1.0);

	new bool:test = true;
						//so i = 2
	for(new i = _:CL_aX; i <= _:CL_aZ; i++)
	{
		if(g_temp_Client[0][i] != _:0)
		{
			test = false;
		}
	}
	printT("Should_Have_Zero_Accel_At_End_Of_*buttonLogic \n %b", test);
}





