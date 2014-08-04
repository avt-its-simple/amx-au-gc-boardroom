PROGRAM_NAME='system-variables'

#if_not_defined __SYSTEM_VARIABLES__
#define __SYSTEM_VARIABLES__

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'

// special case
#include 'agent-usb-ptz-web-cam'




/*
 * --------------------
 * Global variables
 * --------------------
 */

define_variable


/*
 * --------------------
 * Device arrays
 * --------------------
 */

// Override the DEV array within modero-listener
dev dvPanelsCoordinateTracking[] = {dvTpTableMain}

// Override the DEV array within dvx-listener
dev dvDvxMainPorts[] = {dvDvxMain}

dev dvDvxVidOutPorts[] =
{
	dvDvxVidOutMultiPreview,
	dvDvxVidOutMonitorLeft,
	dvDvxVidOutMonitorRight
}

dev dvDvxVidInPorts[] =
{
	dvDvxVidIn1,
	dvDvxVidIn2,
	dvDvxVidIn3,
	dvDvxVidIn4,
	dvDvxVidIn5,
	dvDvxVidIn6,
	dvDvxVidIn7,
	dvDvxVidIn8,
	dvDvxVidIn9,
	dvDvxVidIn10
}

dev dvDvxAudOutPorts[] = {dvDvxAudOutSpeakers}

dev dvDvxAudInPorts[] =
{
	dvDvxAudInPc,
	dvDvxAudInTx1,
	dvDvxAudInTx2,
	dvDvxAudInTx3,
	dvDvxAudInTx4
}

//dev dvDvxMicInPorts[] = { 5002:1:0, 5002:2:0 }

// Override the DEV arrays within dxlink-listener
dev dvDxlinkTxMainPorts[] =
{
	dvTxTable1Main,
	dvTxTable2Main,
	dvTxTable3Main,
	dvTxTable4Main
}

dev dvDxlinkTxDigitalVideoInPorts[] =
{
	dvTxTable1VidInDigital,
	dvTxTable2VidInDigital,
	dvTxTable3VidInDigital,
	dvTxTable4VidInDigital
}

dev dvDxlinkTxAudInPorts[] =
{
	dvTxTable1AudIn,
	dvTxTable2AudIn,
	dvTxTable3AudIn,
	dvTxTable4AudIn
}

dev dvDxlinkTxAnalogVidInPorts[] =
{
	dvTxTable1VidInAnalog,
	dvTxTable2VidInAnalog,
	dvTxTable3VidInAnalog,
	dvTxTable4VidInAnalog
}

// DXLink RX Ports
dev dvDxlinkRxMainPorts[] =
{
	dvRxMonitorLeftMain,
	dvRxMonitorRightMain
}

dev dvDxlinkRxVidOutPorts[] =
{
	dvRxMonitorLeftVidOut,
	dvRxMonitorRightVidOut
}

dev dvDxlinkRxAudOutPorts[] =
{	dvRxMonitorLeftAudOut,
	dvRxMonitorRightAudOut
}


// Override the DEV arrays within pdu-listener

dev dvPduMains1[] = {dvPduMain1}

dev dvPduMains2[] = {dvPduMain2}

dev dvPduOutlets[] =
{	dvPduOutlet1,
	dvPduOutlet2,
	dvPduOutlet3,
	dvPduOutlet4,
	dvPduOutlet5,
	dvPduOutlet6,
	dvPduOutlet7,
	dvPduOutlet8
}

dev dvPduAxlinkBuses[] =
{
	dvPduAxlinkBus1,
	dvPduAxlinkBus2
}

// Override the DEV arrays within controlports-listener

dev dvIoPorts[] = {dvDvxIos}


/*
 * --------------------
 * Channel arrays
 * --------------------
 */
/*
integer btnsVideoInputsMonitorLeft[]    =
{
	BTN_VIDEO_MONITOR_LEFT_INPUT_01,
	BTN_VIDEO_MONITOR_LEFT_INPUT_02,
	BTN_VIDEO_MONITOR_LEFT_INPUT_03,
	BTN_VIDEO_MONITOR_LEFT_INPUT_04,
	BTN_VIDEO_MONITOR_LEFT_INPUT_05,
	BTN_VIDEO_MONITOR_LEFT_INPUT_06,
	BTN_VIDEO_MONITOR_LEFT_INPUT_07,
	BTN_VIDEO_MONITOR_LEFT_INPUT_08,
	BTN_VIDEO_MONITOR_LEFT_INPUT_09,
	BTN_VIDEO_MONITOR_LEFT_INPUT_10
}

integer btnsVideoInputsMonitorRight[]   =
{
	BTN_VIDEO_MONITOR_RIGHT_INPUT_01,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_02,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_03,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_04,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_05,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_06,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_07,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_08,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_09,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_10
}
*/


/*
 * --------------------
 * Button channel/address codes
 * - need to declare these as variable instead of constant as they are being
 *   passed through to a module
 * --------------------
 */


integer btnsVideoSnapshotPreviews[DVX_MAX_VIDEO_INPUTS] = 
{
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20
}   

integer btnAdrsVideoSnapshotPreviews[DVX_MAX_VIDEO_INPUTS] = 
{
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20
}   


integer btnAdrsVideoInputLabels[DVX_MAX_VIDEO_INPUTS] = 
{
	41,
	42,
	43,
	44,
	45,
	46,
	47,
	48,
	49,
	50
}

integer btnAdrsVideoOutputSnapshotPreviews[DVX_MAX_VIDEO_OUTPUTS] = 
{
	BTN_ADR_VIDEO_MONITOR_LEFT_PREVIEW_SNAPSHOT,
	0,
	BTN_ADR_VIDEO_MONITOR_RIGHT_PREVIEW_SNAPSHOT,
	0
}

integer btnAdrsVideoOutputLabels[DVX_MAX_VIDEO_OUTPUTS] = 
{
	BTN_ADR_VIDEO_MONITOR_LEFT_PREVIEW_LABEL,
	0,
	BTN_ADR_VIDEO_MONITOR_RIGHT_PREVIEW_LABEL,
	0
}


integer btnAdrVideoPreviewLoadingMessage = 30

integer btnLoadingBarMultiState = 32

integer btnAdrLoadingBar = 32

integer btnAdrVideoPreviewWindow = 31

integer btnExitVideoPreview = 100

char popupNameVideoPreview[] = 'popup-video-preview'

char imageFileNameNoVideo[] = 'icon-novideo.png'

/*
 * --------------------
 * Variables to keep track of changes in the system
 * --------------------
 */

persistent integer selectedVideoInputMonitorLeft    = 0
persistent integer selectedVideoInputMonitorRight   = 0
persistent char signalStatusDvxInputMonitorLeft[50]
persistent char signalStatusDvxInputMonitorRight[50]

persistent integer selectedAudioInput           = 0
persistent integer audioFollowingVideoOutput    = 0

volatile integer isVideoBeingPreviewed  = 0

volatile integer isRoomOccupied     = FALSE // this will reset when the OCC sensor sends the IO port high after boot
persistent integer isSystemAvInUse  = FALSE

persistent integer countTimesPeopleLeftWithoutShuttingDownSystem    = 0

volatile integer userAcknowledgedSelectingInputWithNoSignal = false

_DvxSwitcher dvx

persistent integer volumeMax        = 75
persistent integer volumeDefault    = 30

persistent integer opacityUnselected    = 102
persistent integer opacitySelected      = 255

persistent integer panSpeed     = CAMERA_MAX_PAN_SPEED
persistent integer tiltSpeed    = CAMERA_MAX_TILT_SPEED

/*persistent integer CAMERASpeedPresetTilt  = CAMERA_MIN_TILT_SPEED
persistent integer CAMERASpeedPresetPan     = CAMERA_MIN_PAN_SPEED
persistent integer CAMERASpeedPresetZoom    = CAMERA_MIN_ZOOM_SPEED
persistent integer CAMERASpeedPresetFocus   = CAMERA_MIN_FOCUS_SPEED*/

persistent integer cameraSpeedPreset1Pan    = 17
persistent integer cameraSpeedPreset1Tilt   = 17
persistent integer cameraSpeedPreset1Zoom   = 1
persistent integer cameraSpeedPreset1Focus  = 1

long timelineTimesMultiPreviewSnapshots[DVX_MAX_VIDEO_INPUTS]
long timelineTimeMplBetweenSwitches = 1000


char draggableItemBitmapNames[DVX_MAX_VIDEO_INPUTS][30]

// Drag and drop areas for 19" panel
// drop areas
_area dropAreasTpTable[DVX_MAX_VIDEO_OUTPUTS]
// drag item areas
_area dragAreasTpTable[DVX_MAX_VIDEO_INPUTS]


char draggablePopupsTpTable[DVX_MAX_VIDEO_INPUTS][40]

/*
 * --------------------
 * Wait times
 * - in tenths of seconds
 * --------------------
 */

integer waitTimeVideoPreview    = 5
integer waitTimeVideoLoading    = 20
integer waitTimePowerCycle      = 30
integer waitTimeValidSignal     = 600
integer waitTimeMplSnapShot     = 8

persistent integer waitTimeCameraAdjustingToBasePosition    = 60
/*persistent integer waitTimeCameraAdjustingToPresetTilt    = 50
persistent integer waitTimeCameraAdjustingToPresetPan       = 50
persistent integer waitTimeCameraAdjustingToPresetZoom      = 50
persistent integer waitTimeCameraAdjustingToPresetFocus     = 50*/
persistent integer waitTimeCameraAdjustingToPreset1Pan      = 24
persistent integer waitTimeCameraAdjustingToPreset1Tilt     = 18
persistent integer waitTimeCameraAdjustingToPreset1Zoom     = 10
persistent integer waitTimeCameraAdjustingToPreset1Focus    = 0


/*
 * --------------------
 * Debugging variables
 * --------------------
 */











#end_if

