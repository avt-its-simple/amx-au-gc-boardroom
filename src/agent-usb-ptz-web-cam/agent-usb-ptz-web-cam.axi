program_name='agent-usb-ptz-web-cam'

#if_not_defined __AGENT_USB_PTZ_WEB_CAM__
#define __AGENT_USB_PTZ_WEB_CAM__

#include 'amx-device-control'

define_constant

integer CAMERA_MIN_TILT_SPEED = 1
integer CAMERA_MAX_TILT_SPEED = 18

integer CAMERA_MIN_PAN_SPEED = 1
integer CAMERA_MAX_PAN_SPEED = 18

integer CAMERA_MIN_ZOOM_SPEED = 1
integer CAMERA_MAX_ZOOM_SPEED = 7

integer CAMERA_MIN_FOCUS_SPEED = 1
integer CAMERA_MAX_FOCUS_SPEED = 7


/*
 * --------------------
 * Camera Tilt Functions
 * --------------------
 */


/*
 * Function:    agentUsbPtzWebCamTiltUp
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Tilts camera up at specified speed (1 - 18).
 */
define_function agentUsbPtzWebCamTiltUp (dev camera, integer tiltSpeed)
{
	if (tiltSpeed > CAMERA_MAX_TILT_SPEED)
		sendString (camera, "$81,$01,$06,$01,$00,CAMERA_MAX_TILT_SPEED,$03,$01,$FF")
	else if (tiltSpeed < CAMERA_MIN_TILT_SPEED)
		sendString (camera, "$81,$01,$06,$01,$00,CAMERA_MIN_TILT_SPEED,$03,$01,$FF")
	else
		sendString (camera, "$81,$01,$06,$01,$00,tiltSpeed,$03,$01,$FF")
}

/*
 * Function:    agentUsbPtzWebCamTiltDown
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Tilts camera down at specified speed (1 - 18).
 */
define_function agentUsbPtzWebCamTiltDown (dev camera, integer tiltSpeed)
{
	if (tiltSpeed > CAMERA_MAX_TILT_SPEED)
		sendString (camera, "$81,$01,$06,$01,$00,CAMERA_MAX_TILT_SPEED,$03,$02,$FF")
	else if (tiltSpeed < CAMERA_MIN_TILT_SPEED)
		sendString (camera, "$81,$01,$06,$01,$00,CAMERA_MIN_TILT_SPEED,$03,$02,$FF")
	else
		sendString (camera, "$81,$01,$06,$01,$00,tiltSpeed,$03,$02,$FF")
}

/*
 * Function:    agentUsbPtzWebCamTiltOff
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Stop camera tilt.
 */
define_function agentUsbPtzWebCamTiltOff (dev camera)
{
	sendString (camera, "$81,$01,$06,$01,$00,$00,$03,$03,$FF")
}


/*
 * --------------------
 * Camera Pan Functions
 * --------------------
 */


/*
 * Function:    agentUsbPtzWebCamPanLeft
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Pans camera left at specified speed (1 - 18).
 */
define_function agentUsbPtzWebCamPanLeft (dev camera, integer panSpeed)
{
	if (panSpeed > CAMERA_MAX_PAN_SPEED)
		sendString (camera, "$81,$01,$06,$01,CAMERA_MAX_PAN_SPEED,$00,$01,$03,$FF")
	else if (panSpeed < CAMERA_MIN_PAN_SPEED)
		sendString (camera, "$81,$01,$06,$01,CAMERA_MIN_PAN_SPEED,$00,$01,$03,$FF")
	else
		sendString (camera, "$81,$01,$06,$01,panSpeed,$00,$01,$03,$FF")
}

/*
 * Function:    agentUsbPtzWebCamPanRight
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Pans camera right at specified speed (1 - 18).
 */
define_function agentUsbPtzWebCamPanRight (dev camera, integer panSpeed)
{
	if (panSpeed > CAMERA_MAX_PAN_SPEED)
		sendString (camera, "$81,$01,$06,$01,CAMERA_MAX_PAN_SPEED,$00,$02,$03,$FF")
	else if (panSpeed < CAMERA_MIN_PAN_SPEED)
		sendString (camera, "$81,$01,$06,$01,CAMERA_MIN_PAN_SPEED,$00,$02,$03,$FF")
	else
		sendString (camera, "$81,$01,$06,$01,panSpeed,$00,$02,$03,$FF")
}

/*
 * Function:    agentUsbPtzWebCamPanOff
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Stop camera pan.
 */
define_function agentUsbPtzWebCamPanOff (dev camera)
{
	sendString (camera, "$81,$01,$06,$01,$00,$00,$03,$03,$FF")
}


/*
 * --------------------
 * Camera Zoom Functions
 * --------------------
 */


/*
 * Function:    agentUsbPtzWebCamZoomInStandardSpeed
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Zooms camera up at standard speed.
 */
define_function agentUsbPtzWebCamZoomInStandardSpeed (dev camera)
{
	sendString (camera, "$81,$01,$04,$07,$02,$FF")
}

/*
 * Function:    agentUsbPtzWebCamZoomInVariableSpeed
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Zooms camera up at variable specified speed (1 - 7).
 */
define_function agentUsbPtzWebCamZoomInVariableSpeed (dev camera, integer zoomSpeed)
{
	if (zoomSpeed > CAMERA_MAX_ZOOM_SPEED)
		sendString (camera, "$81,$01,$04,$07,($20 & CAMERA_MAX_ZOOM_SPEED),$FF")
	else if (zoomSpeed < CAMERA_MIN_ZOOM_SPEED)
		sendString (camera, "$81,$01,$04,$07,($20 & CAMERA_MIN_ZOOM_SPEED),$FF")
	else
		sendString (camera, "$81,$01,$04,$07,($20 & zoomSpeed),$FF")
}

/*
 * Function:    agentUsbPtzWebCamZoomOutStandardSpeed
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Zooms camera down at standard speed.
 */
define_function agentUsbPtzWebCamZoomOutStandardSpeed (dev camera)
{
	sendString (camera, "$81,$01,$04,$07,$03,$FF")
}

/*
 * Function:    agentUsbPtzWebCamZoomOutVariableSpeed
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Zooms camera down at specified speed (1 - 7).
 */
define_function agentUsbPtzWebCamZoomOutVariableSpeed (dev camera, integer zoomSpeed)
{
	if (zoomSpeed > CAMERA_MAX_ZOOM_SPEED)
		sendString (camera, "$81,$01,$04,$07,($30 & CAMERA_MAX_ZOOM_SPEED),$FF")
	else if (zoomSpeed < CAMERA_MIN_ZOOM_SPEED)
		sendString (camera, "$81,$01,$04,$07,($30 & CAMERA_MIN_ZOOM_SPEED),$FF")
	else
		sendString (camera, "$81,$01,$04,$07,($30 & zoomSpeed),$FF")
}

/*
 * Function:    agentUsbPtzWebCamZoomOff
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Stop camera zoom.
 */
define_function agentUsbPtzWebCamZoomOff (dev camera)
{
	sendString (camera, "$81,$01,$04,$07,$00,$FF")
}


/*
 * --------------------
 * Camera Focus Functions
 * --------------------
 */


/*
 * Function:    agentUsbPtzWebCamFocusFarStandardSpeed
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Focuss camera up at standard speed.
 */
define_function agentUsbPtzWebCamFocusFarStandardSpeed (dev camera)
{
	sendString (camera, "$81,$01,$04,$08,$02,$FF")
}

/*
 * Function:    agentUsbPtzWebCamFocusFarVariableSpeed
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Focuss camera up at variable specified speed (1 - 7).
 */
define_function agentUsbPtzWebCamFocusFarVariableSpeed (dev camera, integer focusSpeed)
{
	if (focusSpeed > CAMERA_MAX_FOCUS_SPEED)
		sendString (camera, "$81,$01,$04,$08,($20 & CAMERA_MAX_FOCUS_SPEED),$FF")
	else if (focusSpeed < CAMERA_MIN_FOCUS_SPEED)
		sendString (camera, "$81,$01,$04,$08,($20 & CAMERA_MIN_FOCUS_SPEED),$FF")
	else
		sendString (camera, "$81,$01,$04,$08,($20 & focusSpeed),$FF")
}

/*
 * Function:    agentUsbPtzWebCamFocusNearStandardSpeed
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Focuss camera down at standard speed.
 */
define_function agentUsbPtzWebCamFocusNearStandardSpeed (dev camera)
{
	sendString (camera, "$81,$01,$04,$08,$03,$FF")
}

/*
 * Function:    agentUsbPtzWebCamFocusNearVariableSpeed
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Focuss camera down at specified speed (1 - 7).
 */
define_function agentUsbPtzWebCamFocusNearVariableSpeed (dev camera, integer focusSpeed)
{
	if (focusSpeed > CAMERA_MAX_FOCUS_SPEED)
		sendString (camera, "$81,$01,$04,$08,($30 & CAMERA_MAX_FOCUS_SPEED),$FF")
	else if (focusSpeed < CAMERA_MIN_FOCUS_SPEED)
		sendString (camera, "$81,$01,$04,$08,($30 & CAMERA_MIN_FOCUS_SPEED),$FF")
	else
		sendString (camera, "$81,$01,$04,$08,($30 & focusSpeed),$FF")
}

/*
 * Function:    agentUsbPtzWebCamFocusOff
 * 
 * Arguments:   dev camera - serial port connected to web cam
 * 
 * Description: Stop camera focus.
 */
define_function agentUsbPtzWebCamFocusOff (dev camera)
{
	sendString (camera, "$81,$01,$04,$08,$00,$FF")
}



#end_if