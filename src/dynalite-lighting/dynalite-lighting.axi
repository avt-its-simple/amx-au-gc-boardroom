program_name='lighting'

#if_not_defined __LIGHTING__
#define	__LIGHTING__

#include 'amx-device-control'

define_device

/*
 * --------------------
 * Dynalite devices
 *
 * Programmer needs to declare these devices in the main code
 *  - device ID's can be different
 * --------------------
 */

//dvDynaliteDyNetLightSystem = 0:3:0 // This device should be used as the physical device by the COMM module

//vdvDynaliteDyNetLightSystem = 41003:1:0  // The COMM module should use this as its duet device


/*
 * --------------------
 * Lighting constants
 * --------------------
 */

define_constant

// lighting levels by percentage 
INTEGER LIGHTING_LEVEL_0_PERCENT    = 0
INTEGER LIGHTING_LEVEL_10_PERCENT   = 25
INTEGER LIGHTING_LEVEL_20_PERCENT   = 51
INTEGER LIGHTING_LEVEL_30_PERCENT   = 76
INTEGER LIGHTING_LEVEL_40_PERCENT   = 102
INTEGER LIGHTING_LEVEL_50_PERCENT   = 127
INTEGER LIGHTING_LEVEL_60_PERCENT   = 153
INTEGER LIGHTING_LEVEL_70_PERCENT   = 178
INTEGER LIGHTING_LEVEL_80_PERCENT   = 204
INTEGER LIGHTING_LEVEL_90_PERCENT   = 230
INTEGER LIGHTING_LEVEL_100_PERCENT  = 255


/*
 * --------------------
 * Lighting variables level codes
 * --------------------
 */

define_variable

// virtual device array to pass to module
dev vdvLights[] = {vdvDynaliteDyNetLightSystem}

#warn '@PROGRAMMERS NOTE: dynalite-lighting - Need to edit the IP address for the Lighting System'
// ip address of Dynalite interface
char strIPAddressDynalite[15] = '192.168.7.193'

// Dynalite Lighting System Module
define_module 'Dynalite_DyNet_Comm_dr1_0_0' dynaliteCommModule(vdvDynaliteDyNetLightSystem, dvDynaliteDyNetLightSystem)


/*
 * --------------------
 * Lighting Functions
 * --------------------
 */


define_function lightsPassThroughData (char strData[])
{
	sendCommand (vdvDynaliteDyNetLightSystem,"'PASSTHRU-',strData")
}

define_function lightsSetLevelAll(integer lightingLevel)
{
	sendCommand (vdvDynaliteDyNetLightSystem,"'LIGHTSYSTEMLEVEL-255:1:ALL,',itoa(lightingLevel)")
}

define_function lightsSetLevel (char strLightAddress[], integer lightingLevel)
{
	sendCommand (vdvDynaliteDyNetLightSystem,"'LIGHTSYSTEMLEVEL-',strLightAddress,',',itoa(lightingLevel)")
}

define_function lightsSetLevelWithFade (char strLightAddress[], integer lightingLevel, integer fadeRateInSeconds)
{
	sendCommand (vdvDynaliteDyNetLightSystem,"'LIGHTSYSTEMLEVEL-',strLightAddress,',',itoa(lightingLevel),',',itoa(fadeRateInSeconds)")
}

define_function lightsToggle (char strLightAddress[])
{
	sendCommand (vdvDynaliteDyNetLightSystem,"'LIGHTSYSTEMSTATE-',strLightAddress,',TOGGLE'")
}

define_function lightsOn (char strLightAddress[])
{
	sendCommand (vdvDynaliteDyNetLightSystem,"'LIGHTSYSTEMSTATE-',strLightAddress,',ON'")
}

define_function lightsOff (char strLightAddress[])
{
	sendCommand (vdvDynaliteDyNetLightSystem,"'LIGHTSYSTEMSTATE-',strLightAddress,',OFF'")
}

define_function lightsEnableRampUp (char strLightAddress[])
{
	sendCommand (vdvDynaliteDyNetLightSystem, "'LIGHTSYSTEMRAMP-',strLightAddress,',UP'")
}

define_function lightsEnableRampDown (char strLightAddress[])
{
	sendCommand (vdvDynaliteDyNetLightSystem, "'LIGHTSYSTEMRAMP-',strLightAddress,',DOWN'")
}

define_function lightsDisableRamp (char strLightAddress[])
{
	sendCommand (vdvDynaliteDyNetLightSystem, "'LIGHTSYSTEMRAMP-',strLightAddress,',STOP'")
}


/*
 * --------------------
 * Events
 * --------------------
 */

define_event

data_event[vdvDynaliteDyNetLightSystem]
{
	online:
	{
		sendCommand (vdvDynaliteDyNetLightSystem,"'PROPERTY-IP_Address,',strIPAddressDynalite")
		sendCommand (vdvDynaliteDyNetLightSystem,'PROPERTY-Port,24601')
		sendCommand (vdvDynaliteDyNetLightSystem,'REINIT')
	}
}


#end_if