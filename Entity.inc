#if defined _ENTITY_INCLUDED
	#endinput
#endif
#define _ENTITY_INCLUDED

stock IsEntityOnGround(entity)
{
	return (GetEntityFlags(entity) & FL_ONGROUND);
}