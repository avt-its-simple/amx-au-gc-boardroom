PROGRAM_NAME='amx-au-gc-boardroom-main'

/*
 * --------------------
 * System defines (always first!)
 * --------------------
 */
#include 'system-defines'



// Library Files
#include 'common'
#include 'debug'

#include 'system-library-api'
#include 'system-library-control'







#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-mutual-exclusions'



/*
 * --------------------
 * 3rd party device includes
 * --------------------
 */

// special case agent-usb-ptz-web-cam needs to be declared above system variables
// as they reference constants within this include file
#include 'agent-usb-ptz-web-cam'	
// Need to declare the lighting include file after declaring the lighting devices
#include 'dynalite-lighting'
// Need to declare the nec monitor include file after declaring the monitor devices
#include 'nec-monitor'
// Need to declare the wake-on-lan include file after declaring the wake-on-lan IP socket
#include 'wake-on-lan'
// Need to declare the rms-main include file after declaring the RMS virtual device
#include 'rms-main'






#include 'system-modules'
#include 'system-functions'
#include 'system-events'
#include 'system-start'
#include 'system-mainline'


/*
 * --------------------
 * Listener includes (always last!)
 * --------------------
 */

#include 'system-library-listener'











