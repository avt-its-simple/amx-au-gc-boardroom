program_name='snapi-display-control'

#if_not_defined __SNAPI_DISPLAY_CONTROL__
#define __SNAPI_DISPLAY_CONTROL__

#include 'common'
#include 'amx-device-control'
#include 'SNAPI'


define_function snapiDisplayEnablePower (dev virtual)
{
	channelPulse (virtual, PWR_ON)
}

define_function snapiDisplayDisablePower (dev virtual)
{
	channelPulse (virtual, PWR_OFF)
}
















#end_if