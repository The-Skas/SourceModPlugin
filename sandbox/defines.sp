
#define ARGS(%1,%2,%3,%4,%5,%6)
#define EMPTY()
#define DEFER(%1) %1 EMPTY()
#define OBSTRUCT(%1) %1 DEFER(EMPTY)()
#define EXPAND(%1) %1

#define A() 123
#line 9
public OnPluginStart()
{
	#include "loopstart.inc"
		#define LOOP_END 10
		#define MACRO(%1) PrintToServer("%i\n", %1);
	#include "loop.inc"

}