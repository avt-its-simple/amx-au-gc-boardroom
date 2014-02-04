program_name='debug'

#if_not_defined __DEBUG__
#define __DEBUG__

#include 'amx-device-control'


define_device

#if_not_defined dvDebug
dvDebug = 0:1:0
#end_if

/*
 * --------------------
 * Function: debugPrint
 *
 * Parameters:  char debugString[] - debug string
 * 
 * Description: Prints a debug string to the Diagnostics tab in NetLinx Studio.
 * --------------------
 */
define_function debugPrint (char debugString[])
{
	sendString (dvDebug, "'DEBUG::',debugString")
}

/*
 * --------------------
 * Function: debugDevToString
 *
 * Parameters:  dev device - device
 * 
 * Description: Returns a string representation of a device in D:P:S format.
 * --------------------
 */
define_function char[50] debugDevToString (dev device)
{
	return "itoa(device.number),':',itoa(device.port),':',itoa(device.system)"
}

/*
 * --------------------
 * Function: debugDevChanToString
 *
 * Parameters:  devchan dc - device,channel
 * 
 * Description: Returns a string representation of a devchan in D:P:S,C format.
 * --------------------
 */
define_function char[50] debugDevChanToString (devchan dc)
{
	return "itoa(dc.device.number),':',itoa(dc.device.port),':',itoa(dc.device.system),',',itoa(dc.channel)"
}

/*
 * --------------------
 * Function: debugDevLevToString
 *
 * Parameters:  devlev dl - device,level
 * 
 * Description: Returns a string representation of a devlev in D:P:S,L format.
 * --------------------
 */
define_function char[50] debugDevLevToString (devlev dl)
{
	return "itoa(dl.device.number),':',itoa(dl.device.port),':',itoa(dl.device.system),',',itoa(dl.level)"
}

#end_if