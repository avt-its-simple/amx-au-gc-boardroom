program_name='nec-monitor'

#if_not_defined __NEC_MONITOR__
#define __NEC_MONITOR__

#include 'amx-device-control'

#include 'SNAPI'

/*
 * --------------------
 * Device declarations
 * --------------------
 */

define_device

//dvMonitor = 5001:1:0
//vdvMonitor = 41001:1:0    // Duet module virtual device


/*
 * --------------------
 * Module definitions
 * --------------------
 */

//define_module 'NEC_LCD5710_Comm_dr1_0_0' NEC_Left(vdvMonitor, dvMonitor)
define_module 'NEC_LCD5710_Comm_dr1_0_0' NEC_Left(vdvMonitorLeft, dvMonitorLeft)
define_module 'NEC_LCD5710_Comm_dr1_0_0' NEC_Right(vdvMonitorRight, dvMonitorRight)


/*
 * --------------------
 * Power functions
 * --------------------
 */


define_function necMonitorSetPowerOn (dev vdvMonitor)
{
	channelPulse (vdvMonitor, PWR_ON)
}


define_function necMonitorSetPowerOff (dev vdvMonitor)
{
	channelPulse (vdvMonitor, PWR_OFF)
}


#end_if