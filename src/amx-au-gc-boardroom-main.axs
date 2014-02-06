program_name='amx-au-gc-boardroom-main'


/*
 * --------------------
 * Room: Boardroom
 * Location: AMX Australia Gold Coast office
 * 
 * 
 * Device Hostname Info
 * ::::::::::::::::::::
 * DVX in Rack:
 *      AV-GC-BRDRM-DVX
 * 19" Touch Panel on Boardroom Table:
 *      AV-GC-BRDRM-TP-CONTROL
 * 7" Touch Panel on wall outside of Boardroom:
 *      AV-GC-BRDRM-TP-WELCOME
 * DXLink Receivers:
 *      AV-GC-BRDRM-DXL-RX-MON-LFT
 *      AV-GC-BRDRM-DXL-RX-MON-RHT
 * DXLink Multi-Format Transmitters:
 *      AV-GC-BRDRM-DXL-MFTX-01
 *      AV-GC-BRDRM-DXL-MFTX-02
 *      AV-GC-BRDRM-DXL-MFTX-03
 *      AV-GC-BRDRM-DXL-MFTX-04
 * --------------------
 */

#warn '@TODO - amx-au-gc-boardroom-main - Turn off house PC each night'
#warn '@TODO - amx-au-gc-boardroom-main - Turn on house PC each morning (weekdays)'
#warn '@TODO - amx-au-gc-boardroom-main - Drop power to monitors each night'
#warn '@TODO - amx-au-gc-boardroom-main - Restore power to monitors each morning'
#warn '@TODO - amx-au-gc-boardroom-main - RMS asset tracking'
#warn '@TODO - amx-au-gc-boardroom-main - RMS scheduling, from this panel?'
#warn '@TODO - amx-au-gc-boardroom-main - doorbell and video intercom between panels'


/*
 * --------------------
 * API and Control Includes
 * --------------------
 */

// include files
#include 'common'
#include 'debug'
#include 'amx-device-control'
#include 'amx-controlports-api'
#include 'amx-controlports-control'
#include 'amx-dvx-api'
#include 'amx-dvx-control'
#include 'amx-pdu-api'
#include 'amx-pdu-control'
#include 'amx-dxlink-api'
#include 'amx-dxlink-control'
#include 'amx-modero-api'
#include 'amx-modero-control'
#include 'agent-usb-ptz-web-cam'



/*
 * --------------------
 * Constant definitions
 * --------------------
 */

define_constant


/*
 * --------------------
 * Device id's
 * --------------------
 */
integer DEV_ID_MASTER                               = 0
integer DEV_ID_TOUCH_PANEL_TABLE                    = 10001
integer DEV_ID_TX_1                                 = 7001
integer DEV_ID_TX_2                                 = 7002
integer DEV_ID_TX_3                                 = 7003
integer DEV_ID_TX_4                                 = 7004
integer DEV_ID_RX_MONITOR_LEFT                      = 8001
integer DEV_ID_RX_MONITOR_RIGHT                     = 8002
integer DEV_ID_DVX_CONTROLLER                       = 5001
integer DEV_ID_DVX_SWITCHER                         = 5002
integer DEV_ID_RELAY_BOX                            = 69
integer DEV_ID_KEYPAD_1                             = 213
integer DEV_ID_KEYPAD_2                             = 214
integer DEV_ID_PDU_1                                =  85
integer DEV_ID_PDU_2                                =  86
integer DEV_ID_PDU_3                                =  87
integer DEV_ID_PDU_4                                =  88
integer DEV_ID_PDU_5                                =  89
integer DEV_ID_PDU_6                                =  90
integer DEV_ID_PDU_7                                =  91
integer DEV_ID_PDU_8                                =  92
integer DEV_ID_DUET_MODULE_VIRTUAL_RMS              = 41001
integer DEV_ID_DUET_MODULE_VIRTUAL_MONITOR_LEFT     = 41002
integer DEV_ID_DUET_MODULE_VIRTUAL_MONITOR_RIGHT    = 41003
integer DEV_ID_DUET_MODULE_VIRTUAL_DYNALITE         = 41004

/*
 * --------------------
 * Device ports
 * --------------------
 */
 
 // Virtual device main port
integer PORT_VIRTUAL_MAIN       = 1

// Touch Panel Ports
integer PORT_TP_MAIN            = 1
integer PORT_TP_LIGHTING        = 2
integer PORT_TP_VIDEO           = 3
integer PORT_TP_AUDIO           = 4
integer PORT_TP_BLINDS          = 5
integer PORT_TP_POWER           = 6
integer PORT_TP_CAMERA          = 7
integer PORT_TP_DXLINK          = 8
integer PORT_TP_DEVICE_INFO     = 9
integer PORT_TP_OCCUPANCY       = 10
integer PORT_TP_DEBUG           = 100

// DVX Controller Serial Ports
integer PORT_DVX_CONTROLLER_MAIN    = 1
integer PORT_DVX_SERIAL_1           = 1
integer PORT_DVX_SERIAL_2           = 2
integer PORT_DVX_SERIAL_3           = 3
integer PORT_DVX_SERIAL_4           = 4
integer PORT_DVX_SERIAL_5           = 5
integer PORT_DVX_SERIAL_6           = 6
integer PORT_DVX_RELAYS             = 8
integer PORT_DVX_IR_1               = 9
integer PORT_DVX_IR_2               = 10
integer PORT_DVX_IR_3               = 11
integer PORT_DVX_IR_4               = 12
integer PORT_DVX_IR_5               = 13
integer PORT_DVX_IR_6               = 14
integer PORT_DVX_IR_7               = 15
integer PORT_DVX_IR_8               = 16
integer PORT_DVX_IOS                = 17

// Axlink port - always 1
integer PORT_AXLINK = 1

// System IDs
integer SYS_MASTER  = 0


/*
 * --------------------
 * Device Definitions
 * --------------------
 */

define_device

// Master Controller
dvMaster    = DEV_ID_MASTER:1:SYS_MASTER

// Keypad
dvKeypad1   = DEV_ID_KEYPAD_1:PORT_AXLINK:SYS_MASTER
dvKeypad2   = DEV_ID_KEYPAD_2:PORT_AXLINK:SYS_MASTER

// Touch Panel Ports
dvTpTableMain       = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_MAIN:SYS_MASTER
dvTpTableLighting   = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_LIGHTING:SYS_MASTER
dvTpTableVideo      = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_VIDEO:SYS_MASTER
dvTpTableAudio      = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_AUDIO:SYS_MASTER
dvTpTableBlinds     = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_BLINDS:SYS_MASTER
dvTpTablePower      = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_POWER:SYS_MASTER
dvTpTableCamera     = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_CAMERA:SYS_MASTER
dvTpTableDxlink     = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_DXLINK:SYS_MASTER
dvTpTableDeviceInfo = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_DEVICE_INFO:SYS_MASTER
dvTpTableOccupancy  = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_OCCUPANCY:SYS_MASTER
dvTpTableDebug      = DEV_ID_TOUCH_PANEL_TABLE:PORT_TP_DEBUG:SYS_MASTER

// DXLinx Receiver on Left Monitor
dvRxMonitorLeftMain     = DEV_ID_RX_MONITOR_LEFT:DXLINK_PORT_MAIN:SYS_MASTER
dvRxMonitorLeftSerial   = DEV_ID_RX_MONITOR_LEFT:DXLINK_PORT_SERIAL:SYS_MASTER
dvRxMonitorLeftVidOut   = DEV_ID_RX_MONITOR_LEFT:DXLINK_PORT_VIDEO_OUTPUT:SYS_MASTER
dvRxMonitorLeftAudOut   = DEV_ID_RX_MONITOR_LEFT:DXLINK_PORT_AUDIO_OUTPUT:SYS_MASTER

// DXLinx Receiver on Right Monitor
dvRxMonitorRightMain    = DEV_ID_RX_MONITOR_RIGHT:DXLINK_PORT_MAIN:SYS_MASTER
dvRxMonitorRightSerial  = DEV_ID_RX_MONITOR_RIGHT:DXLINK_PORT_SERIAL:SYS_MASTER
dvRxMonitorRightVidOut  = DEV_ID_RX_MONITOR_RIGHT:DXLINK_PORT_VIDEO_OUTPUT:SYS_MASTER
dvRxMonitorRightAudOut  = DEV_ID_RX_MONITOR_RIGHT:DXLINK_PORT_AUDIO_OUTPUT:SYS_MASTER

// DXLinx Multi-Format Transmit #1 under board room table
dvTxTable1Main          = DEV_ID_TX_1:DXLINK_PORT_MAIN:SYS_MASTER
dvTxTable1VidInDigital  = DEV_ID_TX_1:DXLINK_PORT_VIDEO_INPUT_DIGITAL:SYS_MASTER
dvTxTable1VidInAnalog   = DEV_ID_TX_1:DXLINK_PORT_VIDEO_INPUT_ANALOG:SYS_MASTER
dvTxTable1AudIn         = DEV_ID_TX_1:DXLINK_PORT_AUDIO_INPUT:SYS_MASTER

// DXLinx Multi-Format Transmit #2 under board room table
dvTxTable2Main          = DEV_ID_TX_2:DXLINK_PORT_MAIN:SYS_MASTER
dvTxTable2VidInDigital  = DEV_ID_TX_2:DXLINK_PORT_VIDEO_INPUT_DIGITAL:SYS_MASTER
dvTxTable2VidInAnalog   = DEV_ID_TX_2:DXLINK_PORT_VIDEO_INPUT_ANALOG:SYS_MASTER
dvTxTable2AudIn         = DEV_ID_TX_2:DXLINK_PORT_AUDIO_INPUT:SYS_MASTER

// DXLinx Multi-Format Transmit #3 under board room table
dvTxTable3Main          = DEV_ID_TX_3:DXLINK_PORT_MAIN:SYS_MASTER
dvTxTable3VidInDigital  = DEV_ID_TX_3:DXLINK_PORT_VIDEO_INPUT_DIGITAL:SYS_MASTER
dvTxTable3VidInAnalog   = DEV_ID_TX_3:DXLINK_PORT_VIDEO_INPUT_ANALOG:SYS_MASTER
dvTxTable3AudIn         = DEV_ID_TX_3:DXLINK_PORT_AUDIO_INPUT:SYS_MASTER

// DXLinx Multi-Format Transmit #4 under board room table
dvTxTable4Main          = DEV_ID_TX_4:DXLINK_PORT_MAIN:SYS_MASTER
dvTxTable4VidInDigital  = DEV_ID_TX_4:DXLINK_PORT_VIDEO_INPUT_DIGITAL:SYS_MASTER
dvTxTable4VidInAnalog   = DEV_ID_TX_4:DXLINK_PORT_VIDEO_INPUT_ANALOG:SYS_MASTER
dvTxTable4AudIn         = DEV_ID_TX_4:DXLINK_PORT_AUDIO_INPUT:SYS_MASTER

// DVX Main Port
dvDvxMain   = DEV_ID_DVX_SWITCHER:DVX_PORT_MAIN:SYS_MASTER

// DVX Video Inputs
dvDvxVidIn1     = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_IN_1:SYS_MASTER
dvDvxVidIn2     = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_IN_2:SYS_MASTER
dvDvxVidIn3     = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_IN_3:SYS_MASTER
dvDvxVidIn4     = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_IN_4:SYS_MASTER
dvDvxVidIn5     = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_IN_5:SYS_MASTER
dvDvxVidIn6     = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_IN_6:SYS_MASTER
dvDvxVidIn7     = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_IN_7:SYS_MASTER
dvDvxVidIn8     = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_IN_8:SYS_MASTER
dvDvxVidIn9     = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_IN_9:SYS_MASTER
dvDvxVidIn10    = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_IN_10:SYS_MASTER
// Names ports
dvDvxVidInPc    = dvDvxVidIn5
dvDvxVidInTx1   = dvDvxVidIn7
dvDvxVidInTx2   = dvDvxVidIn8
dvDvxVidInTx3   = dvDvxVidIn9
dvDvxVidInTx4   = dvDvxVidIn10

// DVX Video Outputs
dvDvxVidOut1    = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_OUT_1:SYS_MASTER
dvDvxVidOut2    = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_OUT_2:SYS_MASTER
dvDvxVidOut3    = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_OUT_3:SYS_MASTER
dvDvxVidOut4    = DEV_ID_DVX_SWITCHER:DVX_PORT_VID_OUT_4:SYS_MASTER
// Named ports
dvDvxVidOutMultiPreview = dvDvxVidOut2
dvDvxVidOutMonitorLeft  = dvDvxVidOut1
dvDvxVidOutMonitorRight = dvDvxVidOut3

// DVX Audio Inputs
dvDvxAudIn1     = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_1:SYS_MASTER
dvDvxAudIn2     = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_2:SYS_MASTER
dvDvxAudIn3     = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_3:SYS_MASTER
dvDvxAudIn4     = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_4:SYS_MASTER
dvDvxAudIn5     = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_5:SYS_MASTER
dvDvxAudIn6     = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_6:SYS_MASTER
dvDvxAudIn7     = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_7:SYS_MASTER
dvDvxAudIn8     = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_8:SYS_MASTER
dvDvxAudIn9     = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_9:SYS_MASTER
dvDvxAudIn10    = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_10:SYS_MASTER
dvDvxAudIn11    = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_11:SYS_MASTER
dvDvxAudIn12    = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_12:SYS_MASTER
dvDvxAudIn13    = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_13:SYS_MASTER
dvDvxAudIn14    = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_IN_14:SYS_MASTER
// Names ports                                      
dvDvxAudInPc    = dvDvxAudIn5
dvDvxAudInTx1   = dvDvxAudIn7
dvDvxAudInTx2   = dvDvxAudIn8
dvDvxAudInTx3   = dvDvxAudIn9
dvDvxAudInTx4   = dvDvxAudIn10

// DVX Audio Outputs
dvDvxAudOut1    = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_OUT_1:SYS_MASTER
dvDvxAudOut2    = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_OUT_2:SYS_MASTER
dvDvxAudOut3    = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_OUT_3:SYS_MASTER
dvDvxAudOut4    = DEV_ID_DVX_SWITCHER:DVX_PORT_AUD_OUT_4:SYS_MASTER
// Namesd ports
dvDvxAudOutSpeakers = dvDvxAudOut1

// DVX Controller
dvDvxControllerMain = DEV_ID_DVX_CONTROLLER:PORT_DVX_CONTROLLER_MAIN:SYS_MASTER

// Relays for Blind/Shade Control
dvRelaysDvx     = DEV_ID_DVX_CONTROLLER:PORT_DVX_RELAYS:SYS_MASTER
dvRelaysRelBox  = DEV_ID_RELAY_BOX:PORT_AXLINK:SYS_MASTER

// PTZ Camera
dvPtzCam    = DEV_ID_DVX_CONTROLLER:PORT_DVX_SERIAL_1:SYS_MASTER

// PDU
dvPduMain1  = DEV_ID_PDU_1:PORT_AXLINK:SYS_MASTER
dvPduMain2  = DEV_ID_PDU_2:PORT_AXLINK:SYS_MASTER
// PDU Outlets
dvPduOutlet1    = DEV_ID_PDU_1:PORT_AXLINK:SYS_MASTER
dvPduOutlet2    = DEV_ID_PDU_2:PORT_AXLINK:SYS_MASTER
dvPduOutlet3    = DEV_ID_PDU_3:PORT_AXLINK:SYS_MASTER
dvPduOutlet4    = DEV_ID_PDU_4:PORT_AXLINK:SYS_MASTER
dvPduOutlet5    = DEV_ID_PDU_5:PORT_AXLINK:SYS_MASTER
dvPduOutlet6    = DEV_ID_PDU_6:PORT_AXLINK:SYS_MASTER
dvPduOutlet7    = DEV_ID_PDU_7:PORT_AXLINK:SYS_MASTER
dvPduOutlet8    = DEV_ID_PDU_8:PORT_AXLINK:SYS_MASTER
// Named outlets
dvPduOutletMonitorLeft  = dvPduOutlet1
dvPduOutletMonitorRight = dvPduOutlet2
dvPduOutletPdxl2    = dvPduOutlet3
dvPduOutletMultiPreview = dvPduOutlet4
dvPduOutletPc           = dvPduOutlet5
dvPduOutletDvx          = dvPduOutlet6
dvPduOutletFan1         = dvPduOutlet7
dvPduOutletFan2         = dvPduOutlet8
// PDU Axlink buses
dvPduAxlinkBus1 = DEV_ID_PDU_1:PORT_AXLINK:SYS_MASTER
dvPduAxlinkBus2 = DEV_ID_PDU_2:PORT_AXLINK:SYS_MASTER


// PDXL2 - ???


// DVX IO's (Occupancy sensor connects to DVX IO)
dvDvxIos    = DEV_ID_DVX_CONTROLLER:PORT_DVX_IOS:SYS_MASTER


// Lighting
dvDynaliteDyNetLightSystem  = DEV_ID_MASTER:2:SYS_MASTER // This device should be used as the physical device by the COMM module
vdvDynaliteDyNetLightSystem = DEV_ID_DUET_MODULE_VIRTUAL_DYNALITE:PORT_VIRTUAL_MAIN:SYS_MASTER  // The COMM module should use this as its duet device

// IP socket for wake on lan
dvIpSocketWakeOnLan = DEV_ID_MASTER:3:SYS_MASTER

// Monitors
dvMonitorLeft   = dvRxMonitorLeftSerial
vdvMonitorLeft  = DEV_ID_DUET_MODULE_VIRTUAL_MONITOR_LEFT:PORT_VIRTUAL_MAIN:SYS_MASTER
dvMonitorRight  = dvRxMonitorRightSerial
vdvMonitorRight = DEV_ID_DUET_MODULE_VIRTUAL_MONITOR_RIGHT:PORT_VIRTUAL_MAIN:SYS_MASTER

// RMS
vdvRms  = DEV_ID_DUET_MODULE_VIRTUAL_RMS:PORT_VIRTUAL_MAIN:SYS_MASTER


/*
 * --------------------
 * 3rd party device includes
 * --------------------
 */

// Need to declare the lighting include file after declaring the lighting devices
#include 'dynalite-lighting'
// Need to declare the nec monitor include file after declaring the monitor devices
#include 'nec-monitor'
// Need to declare the wake-on-lan include file after declaring the wake-on-lan IP socket
#include 'wake-on-lan'
// Need to declare the rms-main include file after declaring the RMS virtual device
#include 'rms-main'

/*
 * --------------------
 * Constant definitions
 * --------------------
 */
 
define_constant


/*
 * --------------------
 * Keypad button channel/address/level codes
 * --------------------
 */

// channel codes
integer BTN_KP_OFF              = 1
integer BTN_KP_LIGHTS           = 2
integer BTN_KP_BLOCKOUTS        = 3
integer BTN_KP_SHADES           = 4
integer BTN_KP_AV_OFF           = 5
integer BTN_KP_WHITEBOARD       = 6
integer BTN_KP_CURSOR_UP        = 7
integer BTN_KP_CURSOR_DN        = 8
integer BTN_KP_CURSOR_LT        = 9
integer BTN_KP_CURSOR_RT        = 10
integer BTN_KP_ENTER            = 11
integer BTN_KP_WHEEL_ROTATE_LT  = 12
integer BTN_KP_WHEEL_ROTATE_RT  = 13
// level codes
integer nLVL_KP_JOG_WHEEL       = 1


/*
 * --------------------
 * Touch panel button channel/address/level codes
 * --------------------
 */

// Main System
integer BTN_MAIN_SHUT_DOWN  = 1
integer BTN_MAIN_SPLASH_SCREEN = 2

// Debug
integer BTN_DEBUG_REBUILD_EVENT_TABLE   = 1
integer BTN_DEBUG_WAKE_ON_LAN_PC        = 2

// Lighting Control
integer BTN_LIGHTING_PRESET_ALL_OFF         = 1
integer BTN_LIGHTING_PRESET_ALL_ON          = 2
integer BTN_LIGHTING_PRESET_ALL_DIM         = 3
integer BTN_LIGHTING_PRESET_VC_MODE         = 4
integer BTN_LIGHTING_AREA_WHITEBOARD_ON     = 5
integer BTN_LIGHTING_AREA_WHITEBOARD_OFF    = 6
integer BTN_LIGHTING_AREA_FRONT_UP          = 7
integer BTN_LIGHTING_AREA_FRONT_DN          = 8
integer BTN_LIGHTING_AREA_SIDE_AND_BACK_UP  = 9
integer BTN_LIGHTING_AREA_SIDE_AND_BACK_DN  = 10
integer BTN_LIGHTING_AREA_TABLE_UP          = 11
integer BTN_LIGHTING_AREA_TABLE_DN          = 12

// Video Control
integer BTN_VIDEO_MONITOR_LEFT_OFF          = 1
integer BTN_VIDEO_MONITOR_LEFT_ON           = 2
integer BTN_VIDEO_MONITOR_RIGHT_OFF         = 3
integer BTN_VIDEO_MONITOR_RIGHT_ON          = 4
integer BTN_VIDEO_MONITOR_LEFT_INPUT_01     = 10
integer BTN_VIDEO_MONITOR_LEFT_INPUT_02     = 11
integer BTN_VIDEO_MONITOR_LEFT_INPUT_03     = 12
integer BTN_VIDEO_MONITOR_LEFT_INPUT_04     = 13
integer BTN_VIDEO_MONITOR_LEFT_INPUT_05     = 14
integer BTN_VIDEO_MONITOR_LEFT_INPUT_06     = 15
integer BTN_VIDEO_MONITOR_LEFT_INPUT_07     = 16
integer BTN_VIDEO_MONITOR_LEFT_INPUT_08     = 17
integer BTN_VIDEO_MONITOR_LEFT_INPUT_09     = 18
integer BTN_VIDEO_MONITOR_LEFT_INPUT_10     = 19
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_01    = 20
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_02    = 21
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_03    = 22
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_04    = 23
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_05    = 24
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_06    = 25
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_07    = 26
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_08    = 27
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_09    = 28
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_10    = 29

integer BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION[]   =
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

integer BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION[]  =
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


integer BTN_VIDEO_QUERY_LYNC_CALL_YES   = 31
integer BTN_VIDEO_QUERY_LYNC_CALL_NO    = 32
integer BTN_VIDEO_LYNC_MONITOR_LEFT     = 33
integer BTN_VIDEO_LYNC_MONITOR_RIGHT    = 34
// Address Codes
integer BTN_ADR_VIDEO_LOADING_PREVIEW           = 30
integer BTN_ADR_VIDEO_PREVIEW_WINDOW            = 31
integer BTN_VIDEO_PREVIEW_LOADING_BAR           = 32
integer BTN_ADR_VIDEO_PREVIEW_LOADING_BAR       = 32
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_01     = 10
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_02     = 11
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_03     = 12
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_04     = 13
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_05     = 14
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_06     = 15
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_07     = 16
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_08     = 17
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_09     = 18
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_10     = 19
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_01    = 20
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_02    = 21
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_03    = 22
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_04    = 23
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_05    = 24
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_06    = 25
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_07    = 26
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_08    = 27
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_09    = 28
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_10    = 29
integer BTN_ADRS_VIDEO_MONITOR_LEFT_INPUT_SELECTION[]   =
{
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_01,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_02,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_03,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_04,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_05,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_06,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_07,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_08,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_09,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_10
}
integer BTN_ADRS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION[]  =
{
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_01,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_02,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_03,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_04,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_05,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_06,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_07,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_08,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_09,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_10
}

integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_01   = 40
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_02   = 41
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_03   = 42
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_04   = 43
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_05   = 44
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_06   = 45
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_07   = 46
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_08   = 47
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_09   = 48
integer BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_10   = 49

integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_01  = 50
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_02  = 51
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_03  = 52
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_04  = 53
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_05  = 54
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_06  = 55
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_07  = 56
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_08  = 57
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_09  = 58
integer BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_10  = 59

integer BTN_ADRS_VIDEO_MONITOR_LEFT_INPUT_LABELS[]  =
{
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_01,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_02,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_03,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_04,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_05,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_06,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_07,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_08,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_09,
	BTN_ADR_VIDEO_MONITOR_LEFT_INPUT_LABEL_10
}
integer BTN_ADRS_VIDEO_MONITOR_RIGHT_INPUT_LABELS[] =
{
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_01,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_02,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_03,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_04,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_05,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_06,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_07,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_08,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_09,
	BTN_ADR_VIDEO_MONITOR_RIGHT_INPUT_LABEL_10
}


integer BTN_VIDEO_MONITOR_LEFT_INPUT_01_FEEDBACK    = 40
integer BTN_VIDEO_MONITOR_LEFT_INPUT_02_FEEDBACK    = 41
integer BTN_VIDEO_MONITOR_LEFT_INPUT_03_FEEDBACK    = 42
integer BTN_VIDEO_MONITOR_LEFT_INPUT_04_FEEDBACK    = 43
integer BTN_VIDEO_MONITOR_LEFT_INPUT_05_FEEDBACK    = 44
integer BTN_VIDEO_MONITOR_LEFT_INPUT_06_FEEDBACK    = 45
integer BTN_VIDEO_MONITOR_LEFT_INPUT_07_FEEDBACK    = 46
integer BTN_VIDEO_MONITOR_LEFT_INPUT_08_FEEDBACK    = 47
integer BTN_VIDEO_MONITOR_LEFT_INPUT_09_FEEDBACK    = 48
integer BTN_VIDEO_MONITOR_LEFT_INPUT_10_FEEDBACK    = 49
integer BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION_FEEDBACK[]  =
{
	BTN_VIDEO_MONITOR_LEFT_INPUT_01_FEEDBACK,
	BTN_VIDEO_MONITOR_LEFT_INPUT_02_FEEDBACK,
	BTN_VIDEO_MONITOR_LEFT_INPUT_03_FEEDBACK,
	BTN_VIDEO_MONITOR_LEFT_INPUT_04_FEEDBACK,
	BTN_VIDEO_MONITOR_LEFT_INPUT_05_FEEDBACK,
	BTN_VIDEO_MONITOR_LEFT_INPUT_06_FEEDBACK,
	BTN_VIDEO_MONITOR_LEFT_INPUT_07_FEEDBACK,
	BTN_VIDEO_MONITOR_LEFT_INPUT_08_FEEDBACK,
	BTN_VIDEO_MONITOR_LEFT_INPUT_09_FEEDBACK,
	BTN_VIDEO_MONITOR_LEFT_INPUT_10_FEEDBACK
}
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_01_FEEDBACK   = 50
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_02_FEEDBACK   = 51
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_03_FEEDBACK   = 52
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_04_FEEDBACK   = 53
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_05_FEEDBACK   = 54
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_06_FEEDBACK   = 55
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_07_FEEDBACK   = 56
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_08_FEEDBACK   = 57
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_09_FEEDBACK   = 58
integer BTN_VIDEO_MONITOR_RIGHT_INPUT_10_FEEDBACK   = 59
integer BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION_FEEDBACK[] =
{
	BTN_VIDEO_MONITOR_RIGHT_INPUT_01_FEEDBACK,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_02_FEEDBACK,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_03_FEEDBACK,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_04_FEEDBACK,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_05_FEEDBACK,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_06_FEEDBACK,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_07_FEEDBACK,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_08_FEEDBACK,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_09_FEEDBACK,
	BTN_VIDEO_MONITOR_RIGHT_INPUT_10_FEEDBACK
}


// Audio Control
integer BTN_AUDIO_VOLUME_UP             = 1
integer BTN_AUDIO_VOLUME_DN             = 2
integer BTN_AUDIO_VOLUME_MUTE           = 3
integer BTN_AUDIO_INPUT_01              = 10
integer BTN_AUDIO_INPUT_02              = 11
integer BTN_AUDIO_INPUT_03              = 12
integer BTN_AUDIO_INPUT_04              = 13
integer BTN_AUDIO_INPUT_05              = 14
integer BTN_AUDIO_INPUT_06              = 15
integer BTN_AUDIO_INPUT_07              = 16
integer BTN_AUDIO_INPUT_08              = 17
integer BTN_AUDIO_INPUT_09              = 18
integer BTN_AUDIO_INPUT_10              = 19
integer BTN_AUDIO_FOLLOW_MONITOR_LEFT   = 20
integer BTN_AUDIO_FOLLOW_MONITOR_RIGHT  = 21
// Levels
integer BTN_LVL_VOLUME_CONTROL          = 31    // bargraph which user controls (invisible to user - overlayed over the display bargraph)
integer BTN_LVL_VOLUME_DISPLAY          = 32    // bargraph which displays the DVX's current volume
// Address codes
integer BTN_ADR_VOLUME_BARGRAPH_CONTROL = 31
integer BTN_ADR_VOLUME_BARGRAPH_DISPLAY = 32


// Power/Energy Control & Monitoring
integer BTN_POWER_TOGGLE_MONITOR_LEFT   = 1
integer BTN_POWER_TOGGLE_MONITOR_RIGHT  = 2
integer BTN_POWER_TOGGLE_PDXL2          = 3
integer BTN_POWER_TOGGLE_MULTI_PREVIEW  = 4
integer BTN_POWER_TOGGLE_PC             = 5
integer BTN_POWER_TOGGLE_DVX            = 6
integer BTN_POWER_TOGGLE_FAN_1          = 7
integer BTN_POWER_TOGGLE_FAN_2          = 8
integer BTNS_POWER_CONTROL[]            = {1,2,3,4,5,6,7,8}
// address codes
integer BTNS_ADR_POWER_CURRENT_DRAW[]   = {51,52,53,54,55,56,57,58}
integer BTNS_ADR_POWER_CONSUMPTION[]    = {61,62,63,64,65,66,67,68}
integer BTNS_ADR_POWER_ENERGY_USAGE[]   = {71,72,73,74,75,76,77,78}
integer BTN_ADR_POWER_INPUT_VOLTAGE[]   = 80
integer BTN_ADR_POWER_AXLINK_VOLTAGE[]  = 81
integer BTN_ADR_POWER_TEMPERATURE[]     = 82
integer BTN_ADR_POWER_OUTLET_LABEL_1    = 11
integer BTN_ADR_POWER_OUTLET_LABEL_2    = 12
integer BTN_ADR_POWER_OUTLET_LABEL_3    = 13
integer BTN_ADR_POWER_OUTLET_LABEL_4    = 14
integer BTN_ADR_POWER_OUTLET_LABEL_5    = 15
integer BTN_ADR_POWER_OUTLET_LABEL_6    = 16
integer BTN_ADR_POWER_OUTLET_LABEL_7    = 17
integer BTN_ADR_POWER_OUTLET_LABEL_8    = 18
integer BTNS_ADR_POWER_OUTLET_LABELS[]  = {11,12,13,14,15,16,17,18}
integer BTN_ADR_POWER_RELAY_STATUS_1    = 21
integer BTN_ADR_POWER_RELAY_STATUS_2    = 22
integer BTN_ADR_POWER_RELAY_STATUS_3    = 23
integer BTN_ADR_POWER_RELAY_STATUS_4    = 24
integer BTN_ADR_POWER_RELAY_STATUS_5    = 25
integer BTN_ADR_POWER_RELAY_STATUS_6    = 26
integer BTN_ADR_POWER_RELAY_STATUS_7    = 27
integer BTN_ADR_POWER_RELAY_STATUS_8    = 28
integer BTNS_ADR_POWER_RELAY_STATUS[]   = {21,22,23,24,25,26,27,28}
integer BTN_ADR_POWER_SENSE_STATUS_1    = 31
integer BTN_ADR_POWER_SENSE_STATUS_2    = 32
integer BTN_ADR_POWER_SENSE_STATUS_3    = 33
integer BTN_ADR_POWER_SENSE_STATUS_4    = 34
integer BTN_ADR_POWER_SENSE_STATUS_5    = 35
integer BTN_ADR_POWER_SENSE_STATUS_6    = 36
integer BTN_ADR_POWER_SENSE_STATUS_7    = 37
integer BTN_ADR_POWER_SENSE_STATUS_8    = 38
integer BTNS_ADR_POWER_SENSE_STATUS[]   = {31,32,33,34,35,36,37,38}
integer BTN_ADR_POWER_SENSE_TRIGGER_1   = 41
integer BTN_ADR_POWER_SENSE_TRIGGER_2   = 42
integer BTN_ADR_POWER_SENSE_TRIGGER_3   = 43
integer BTN_ADR_POWER_SENSE_TRIGGER_4   = 44
integer BTN_ADR_POWER_SENSE_TRIGGER_5   = 45
integer BTN_ADR_POWER_SENSE_TRIGGER_6   = 46
integer BTN_ADR_POWER_SENSE_TRIGGER_7   = 47
integer BTN_ADR_POWER_SENSE_TRIGGER_8   = 48
integer BTNS_ADR_POWER_SENSE_TRIGGER[]  = {41,42,43,44,45,46,47,48}
//integer BTNS_ADR_POWER_CURRENT_DRAW
integer BTN_ADR_POWER_OUTLET_LABEL_MONITOR_LEFT = BTN_ADR_POWER_OUTLET_LABEL_1

integer BTN_POWER_TEMPERATURE_SCALE_TOGGLE      = 100
integer BTN_POWER_TEMPERATURE_SCALE_CELCIUS     = 101
integer BTN_POWER_TEMPERATURE_SCALE_FAHRENHEIT  = 102


// Blinds & Shades Control
integer BTN_BLIND_1_UP      = 1
integer BTN_BLIND_1_DOWN    = 2
integer BTN_BLIND_1_STOP    = 3
integer BTN_BLIND_2_UP      = 4
integer BTN_BLIND_2_DOWN    = 5
integer BTN_BLIND_2_STOP    = 6
integer BTN_SHADE_1_UP      = 7
integer BTN_SHADE_1_DOWN    = 8
integer BTN_SHADE_1_STOP    = 9
integer BTN_SHADE_2_UP      = 10
integer BTN_SHADE_2_DOWN    = 11
integer BTN_SHADE_2_STOP    = 12


// Camera Control
integer BTN_CAMERA_ZOOM_IN      = 1
integer BTN_CAMERA_ZOOM_OUT     = 2
integer BTN_CAMERA_TILT_UP      = 3
integer BTN_CAMERA_TILT_DOWN    = 4
integer BTN_CAMERA_PAN_LEFT     = 5
integer BTN_CAMERA_PAN_RIGHT    = 6
integer BTN_CAMERA_FOCUS_NEAR   = 7
integer BTN_CAMERA_FOCUS_FAR    = 8
integer BTN_CAMERA_PRESET_1     = 11
integer BTN_CAMERA_PRESET_2     = 12
integer BTN_CAMERA_PRESET_3     = 13


// DXLink Control
integer BTN_DXLINK_TX_AUTO_1                            = 1
integer BTN_DXLINK_TX_AUTO_2                            = 2
integer BTN_DXLINK_TX_AUTO_3                            = 3
integer BTN_DXLINK_TX_AUTO_4                            = 4
integer BTN_DXLINK_TX_HDMI_1                            = 5
integer BTN_DXLINK_TX_HDMI_2                            = 6
integer BTN_DXLINK_TX_HDMI_3                            = 7
integer BTN_DXLINK_TX_HDMI_4                            = 8
integer BTN_DXLINK_TX_VGA_1                             = 9
integer BTN_DXLINK_TX_VGA_2                             = 10
integer BTN_DXLINK_TX_VGA_3                             = 11
integer BTN_DXLINK_TX_VGA_4                             = 12
integer BTN_DXLINK_RX_SCALER_AUTO_MONITOR_LEFT          = 13
integer BTN_DXLINK_RX_SCALER_AUTO_MONITOR_RIGHT         = 14
integer BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_LEFT        = 15
integer BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_RIGHT       = 16
integer BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_LEFT        = 17
integer BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_RIGHT       = 18
integer BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_LEFT      = 19
integer BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_RIGHT     = 20
integer BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_LEFT       = 21
integer BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_RIGHT      = 22
integer BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_LEFT          = 23
integer BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_RIGHT         = 24
integer BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_LEFT    = 25
integer BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_RIGHT   = 26
// Address codes
integer BTN_ADR_DXLINK_TX_INPUT_RESOLUTION_1                = 31
integer BTN_ADR_DXLINK_TX_INPUT_RESOLUTION_2                = 32
integer BTN_ADR_DXLINK_TX_INPUT_RESOLUTION_3                = 33
integer BTN_ADR_DXLINK_TX_INPUT_RESOLUTION_4                = 34
integer BTN_ADR_DXLINK_RX_OUTPUT_RESOLUTION_MONITOR_LEFT    = 35
integer BTN_ADR_DXLINK_RX_OUTPUT_RESOLUTION_MONITOR_RIGHT   = 36


// Device Info
// Channel Codes
integer BTN_DEV_INFO_ONLINE_MASTER                  = 1
integer BTN_DEV_INFO_ONLINE_CONTROLLER              = 2
integer BTN_DEV_INFO_ONLINE_SWITCHER                = 3
integer BTN_DEV_INFO_ONLINE_PDU                     = 4
integer BTN_DEV_INFO_ONLINE_PANEL_TABLE             = 5
integer BTN_DEV_INFO_ONLINE_DXLINK_TX_1             = 6
integer BTN_DEV_INFO_ONLINE_DXLINK_TX_2             = 7
integer BTN_DEV_INFO_ONLINE_DXLINK_TX_3             = 8
integer BTN_DEV_INFO_ONLINE_DXLINK_TX_4             = 9
integer BTN_DEV_INFO_ONLINE_DXLINK_RX_MONITOR_LEFT  = 10
integer BTN_DEV_INFO_ONLINE_DXLINK_RX_MONITOR_RIGHT = 11
// Address Codes
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_CONTROLLER  = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1

// Occupancy Detection
integer BTN_OCCUPANCY_DETECTED  = 1


/*
 * --------------------
 * Relay channel codes
 * --------------------
 */

// Relay Channel codes for Relay Box relays
integer REL_BLOCKOUTS_CORNER_WINDOW_UP  = 1
integer REL_BLOCKOUTS_CORNER_WINDOW_DN  = 2

integer REL_SHADES_CORNER_WINDOW_UP = 3
integer REL_SHADES_CORNER_WINDOW_DN = 4

integer REL_BLOCKOUTS_WALL_WINDOW_UP    = 5
integer REL_BLOCKOUTS_WALL_WINDOW_DN    = 6

integer REL_SHADES_WALL_WINDOW_UP   = 7
integer REL_SHADES_WALL_WINDOW_DN   = 8

// Relay Channel codes for DVX relays
integer REL_DVX_BLOCKOUTS_CORNER_WINDOW_STOP    = 1
integer REL_DVX_SHADES_CORNER_WINDOW_STOP       = 2
integer REL_DVX_BLOCKOUTS_WALL_WINDOW_STOP      = 3
integer REL_DVX_SHADES_WALL_WINDOW_STOP         = 4


/*
 * --------------------
 * IO channel codes
 * --------------------
 */

// IO Channel Codes for Occupancy Sensor
integer IO_OCCUPANCY_SENSOR = 1


/*
 * --------------------
 * Lighting Addresses
 * --------------------
 */

char LIGHT_ADDRESS_DOWN_LIGHTS_WHITEBOARD[]             = '255:1:1'
char LIGHT_ADDRESS_DOWN_LIGHTS_DESK[]                   = '255:1:2'
char LIGHT_ADDRESS_DOWN_LIGHTS_FRONT_WALL[]             = '255:1:3'
char LIGHT_ADDRESS_DOWN_LIGHTS_SIDE_AND_BACK_WALLS[]    = '255:1:4'
char LIGHT_ADDRESS_FLUROS_FRONT_RIGHT[]                 = '255:1:5'
char LIGHT_ADDRESS_FLUROS_FRONT_MIDDLE[]                = '255:1:6'
char LIGHT_ADDRESS_FLUROS_FRONT_LEFT[]                  = '255:1:8'
char LIGHT_ADDRESS_FLUROS_BACK_RIGHT[]                  = '255:1:9'
char LIGHT_ADDRESS_FLUROS_BACK_MIDDLE[]                 = '255:1:7'
char LIGHT_ADDRESS_FLUROS_BACK_LEFT[]                   = '255:1:10'
char LIGHT_ADDRESS_FLUROS_POWER[]                       = '255:1:5'

char DYNALITE_PROTOCOL_RECALL_PRESET_ALL_ON[]       = {$1C,$01,$64,$00,$00,$00,$FF}
char DYNALITE_PROTOCOL_RECALL_PRESET_AV_MODE[]      = {$1C,$01,$64,$01,$00,$00,$FF}
char DYNALITE_PROTOCOL_RECALL_PRESET_ALL_DIM[]      = {$1C,$01,$64,$02,$00,$00,$FF}
char DYNALITE_PROTOCOL_RECALL_PRESET_ALL_OFF[]      = {$1C,$01,$64,$03,$00,$00,$FF}
char DYNALITE_PROTOCOL_RECALL_PRESET_VC_MODE_1[]    = {$1C,$01,$64,$0A,$00,$00,$FF}
char DYNALITE_PROTOCOL_RECALL_PRESET_VC_MODE_2[]    = {$1C,$01,$64,$0B,$00,$00,$FF}
char DYNALITE_PROTOCOL_RECALL_PRESET_VC_MODE_3[]    = {$1C,$01,$64,$0C,$00,$00,$FF}
char DYNALITE_PROTOCOL_RECALL_PRESET_VC_MODE_4[]    = {$1C,$01,$64,$0D,$00,$00,$FF}


/*
 * --------------------
 * PDU outlet labels
 * --------------------
 */
 
char LABELS_PDU_OUTLETS[][20]   =
{
	'L MON',
	'R MON',
	'PDXL2',
	'MPL',
	'PC',
	'DVX',
	'FAN 1',
	'FAN 2'
}


/*
 * --------------------
 * Page and popup page names
 * --------------------
 */
 
char POPUP_NAME_VIDEO_PREVIEW[]                 = 'popup-video-preview'
char POPUP_NAME_VIDEO_LOADING[]                 = 'popup-video-loading'
char POPUP_NAME_MESSAGE_QUERY_USER_LYNC_CALL[]  = 'popup-message-query-user-lync-call'
char PAGE_NAME_SPLASH_SCREEN[]                  = 'page-spash-screen'
char PAGE_NAME_MAIN_USER[]                      = 'page-main-user'
char POPUP_NAME_SOURCE_SELECTION[]              = 'popup-source-selection-v3'

/*
 * --------------------
 * Touch panel image files
 * --------------------
 */

char IMAGE_FILE_NAME_NO_IMAGE_ICON[]    = 'icon-novideo.png'

/*
 * --------------------
 * Touch panel sound files
 * --------------------
 */




/*
 * --------------------
 * Timeline ID's
 * --------------------
 */

long TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS    = 1


/*
 * --------------------
 * Camera Presets
 * --------------------
 */

integer CAMERA_PRESET_1 = 1
integer CAMERA_PRESET_2 = 2
integer CAMERA_PRESET_3 = 3


/*
 * --------------------
 * Other useful constants
 * --------------------
 */

char MAC_ADDRESS_PC[]   = {$EC,$A8,$6B,$F8,$73,$53}

/*
 * --------------------
 * Other useful constants
 * --------------------
 */

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





/*
 * --------------------
 * Mutually Exclusive Groups
 * --------------------
 */
define_mutually_exclusive

// DXLink Rx Aspect Ratio Mode Buttons
(
	[dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_LEFT],
	[dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_LEFT],
	[dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_LEFT],
	[dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_LEFT]
)

(
	[dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_RIGHT],
	[dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_RIGHT],
	[dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_RIGHT],
	[dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_RIGHT]
)

// DXLink Rx Scaler Mode Buttons
(
	[dvTpTableDxlink, BTN_DXLINK_RX_SCALER_AUTO_MONITOR_LEFT],
	[dvTpTableDxlink, BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_LEFT],
	[dvTpTableDxlink, BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_LEFT]
)

(
	[dvTpTableDxlink, BTN_DXLINK_RX_SCALER_AUTO_MONITOR_RIGHT],
	[dvTpTableDxlink, BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_RIGHT],
	[dvTpTableDxlink, BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_RIGHT]
)

// DXLink Tx HDMI/VGA Buttons
(
	[dvTpTableDxlink, BTN_DXLINK_TX_HDMI_1],
	[dvTpTableDxlink, BTN_DXLINK_TX_VGA_1]
)

(
	[dvTpTableDxlink, BTN_DXLINK_TX_HDMI_2],
	[dvTpTableDxlink, BTN_DXLINK_TX_VGA_2]
)

(
	[dvTpTableDxlink, BTN_DXLINK_TX_HDMI_3],
	[dvTpTableDxlink, BTN_DXLINK_TX_VGA_3]
)

(
	[dvTpTableDxlink, BTN_DXLINK_TX_HDMI_4],
	[dvTpTableDxlink, BTN_DXLINK_TX_VGA_4]
)



/*
 * --------------------
 * System functions
 * --------------------
 */


define_function recallCameraPreset (integer cameraPreset)
{
	switch (cameraPreset)
	{
		case CAMERA_PRESET_1:
		{
			if (waitTimeCameraAdjustingToPreset1Pan)
			agentUsbPtzWebCamPanLeft (dvPtzCam, CAMERA_MAX_PAN_SPEED)
			if (waitTimeCameraAdjustingToPreset1Tilt)
			agentUsbPtzWebCamTiltDown (dvPtzCam, CAMERA_MAX_TILT_SPEED)
			if (waitTimeCameraAdjustingToPreset1Zoom)
			agentUsbPtzWebCamZoomOutStandardSpeed (dvPtzCam)
			if (waitTimeCameraAdjustingToPreset1Focus)
			agentUsbPtzWebCamFocusFarStandardSpeed (dvPtzCam)
			
			wait waitTimeCameraAdjustingToBasePosition
			{
				// adjust pan
				if (waitTimeCameraAdjustingToPreset1Pan)
				agentUsbPtzWebCamPanRight (dvPtzCam, cameraSpeedPreset1Pan)
				wait waitTimeCameraAdjustingToPreset1Pan
				{
					if (waitTimeCameraAdjustingToPreset1Pan)
					agentUsbPtzWebCamPanOff (dvPtzCam)
					// adjust tilt
					if (waitTimeCameraAdjustingToPreset1Tilt)
					agentUsbPtzWebCamTiltUp (dvPtzCam, cameraSpeedPreset1Tilt)
					wait waitTimeCameraAdjustingToPreset1Tilt
					{
						if (waitTimeCameraAdjustingToPreset1Tilt)
						agentUsbPtzWebCamTiltOff (dvPtzCam)
						// adjust zoom
						if (waitTimeCameraAdjustingToPreset1Zoom)
						agentUsbPtzWebCamZoomInStandardSpeed (dvPtzCam)
						wait waitTimeCameraAdjustingToPreset1Zoom
						{
							if (waitTimeCameraAdjustingToPreset1Zoom)
							agentUsbPtzWebCamZoomOff (dvPtzCam)
							// adjust focus
							if (waitTimeCameraAdjustingToPreset1Focus)
							agentUsbPtzWebCamFocusNearStandardSpeed (dvPtzCam)
							wait waitTimeCameraAdjustingToPreset1Focus
							{
								if (waitTimeCameraAdjustingToPreset1Focus)
								agentUsbPtzWebCamFocusOff (dvPtzCam)
							}
						}
					}
				}
			}
		}
		case CAMERA_PRESET_2: {}
		case CAMERA_PRESET_3: {}
	}
}


define_function startMultiPreviewSnapshots ()
{
	if (!isVideoBeingPreviewed)
	{
		stack_var integer i
		stack_var integer isAtLeastOneValidSignal
		
		isAtLeastOneValidSignal = FALSE
		
		// reset all timeline times back to zero
		for (i = 1; i<= max_length_array(timelineTimesMultiPreviewSnapshots); i++)
		{
			if (dvx.videoInputs[i].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
			{
				timelineTimesMultiPreviewSnapshots[i] = timelineTimeMplBetweenSwitches
				isAtLeastOneValidSignal = TRUE
			}
			else
			{
				timelineTimesMultiPreviewSnapshots[i] = 0
			}
		}
		
		if (isAtLeastOneValidSignal)
		{
			if (!timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
			{
				set_length_array (timelineTimesMultiPreviewSnapshots, max_length_array(timelineTimesMultiPreviewSnapshots))
				
				timeline_create (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS,
						timelineTimesMultiPreviewSnapshots,
						length_array (timelineTimesMultiPreviewSnapshots),
						timeline_relative,
						timeline_repeat)
			}
			else
			{
				CANCEL_WAIT 'WAIT_MULTI_PREVIEW_SNAPSHOT'
				timeline_reload (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS, timelineTimesMultiPreviewSnapshots, length_array(timelineTimesMultiPreviewSnapshots))
			}
		}
		else
		{
			if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
			{
				timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
				CANCEL_WAIT 'WAIT_MULTI_PREVIEW_SNAPSHOT'
			}
		}
	}
}


define_function stopMultiPreviewSnapshots ()
{
	if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
	{
		timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
		CANCEL_WAIT 'WAIT_MULTI_PREVIEW_SNAPSHOT'
	}
}


define_function shutdownAvSystem ()
{
	// Blinds - raise blockouts and shades
	amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_UP)
	amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_UP)
	amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_UP)
	amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_UP)
	
	// Lights - recall the "all on" preset
	lightsEnablePresetAllOn ()
	
	// Video - Turn the monitors off and switch input "none" to the monitor and multi-preview outputs on the DVX
	necMonitorSetPowerOff (vdvMonitorLeft)
	necMonitorSetPowerOff (vdvMonitorRight)
	dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorLeft.port)
	dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorRight.port)
	dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMultiPreview.port)
	
	// Audio - Switch input "none" to the speaker output on the DVX, unmute the audio and reset the volume to a base level for next use
	dvxSwitchAudioOnly (dvDvxMain, DVX_PORT_AUD_IN_NONE, dvDvxAudOutSpeakers.port)
	dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
	dvxDisableAudioOutputMute (dvDvxAudOutSpeakers)
	
	// stop taking snapshots (no point constantly switching on the DVX anymore)
	stopMultiPreviewSnapshots ()
	
	// recall Camera position
	recallCameraPreset (CAMERA_PRESET_1)
	
	// set flag to indicate that system is not in use
	isSystemAvInUse = FALSE
	
	// clear flags keeping track of selected video/audio inputs
	selectedVideoInputMonitorLeft = FALSE
	selectedVideoInputMonitorRight = FALSE
	selectedAudioInput = FALSE
	audioFollowingVideoOutput = FALSE
}


/*
 * Reports a valid signal on DXLink MFTX HDMI input.
 * 
 * Need to be a little bit careful here. This could be an indicator to tell us someone 
 * has just plugged a video source into a table HDMI input but it might also just be
 * a response to the signal status query that we send to each MFTX when the DVX boots.
 * 
 * One thing we do know for sure is that if the AV system is already on and this notification 
 * comes through just do nothing.
 * 
 * We really only want to react to this notification if the system is off in which case 
 * we turn the system on and route the DVX to the appropriate DXLink input corresponding 
 * to the MFTX that triggered this notification MFTX.
 */
define_function tableInputDetected (dev dvTxVidIn)
{
	#warn '@BUG: amx-au-gc-boardroom-main'
	
	/*
	 * --------------------
	 * This code running as expected but the MFTX is reporting a valid signal twice when a new input is plugged in.
	 * 
	 * The result is that this function is getting called twice.
	 * 
	 * If a new laptop input is plugged in when the system is off this function gets called the first time the MFTX reports
	 * a valid signal and routes the newly found laptop video to the left monitor.
	 * 
	 * But then the MFTX reports a valid signal again so this function gets called again. This time teh system is already on
	 * and nothing is routed to the right monitor so this function sends the laptop to the right monitor.
	 * 
	 * In effect, what the user sees is that when the plug in their laptop it comes on on both screens.
	 * 
	 * Not really an issue as far as the user is concerned (they may think the system is designed to do just that) but it's
	 * not what I want to happen!
	 * --------------------
	 */
	
	if (!isSystemAvInUse)
	{
		stack_var integer input
		
		select
		{
			active (dvTxVidIn == dvTxTable1VidInDigital):    input = dvDvxVidInTx1.port
			active (dvTxVidIn == dvTxTable1VidInAnalog):     input = dvDvxVidInTx1.port
			
			active (dvTxVidIn == dvTxTable2VidInDigital):    input = dvDvxVidInTx2.port
			active (dvTxVidIn == dvTxTable2VidInAnalog):     input = dvDvxVidInTx2.port
			
			active (dvTxVidIn == dvTxTable3VidInDigital):    input = dvDvxVidInTx3.port
			active (dvTxVidIn == dvTxTable3VidInAnalog):     input = dvDvxVidInTx3.port
			
			active (dvTxVidIn == dvTxTable4VidInDigital):    input = dvDvxVidInTx4.port
			active (dvTxVidIn == dvTxTable4VidInAnalog):     input = dvDvxVidInTx4.port
		}
		
		// route the DVX input for this TX to the DVX output for the left monitor
		dvxSwitchVideoOnly (dvDvxMain, input, dvDvxVidOutMonitorLeft.port)
		// route the audio from the DVX input for this TX to the DVX output for the speakers
		dvxSwitchAudioOnly (dvDvxMain, input, dvDvxAudOutSpeakers.port)
		// set the flag to show that the audio is following the left screen
		audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
		
		// lower the shades, raise the blockouts
		amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_UP)
		amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_UP)
		amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_DN)
		amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_DN)
		
		// set up a nice lighting atmosphere for viewing the video
		lightsSetLevelWithFade (LIGHT_ADDRESS_DOWN_LIGHTS_DESK, LIGHTING_LEVEL_100_PERCENT,5)
		lightsSetLevelWithFade (LIGHT_ADDRESS_DOWN_LIGHTS_FRONT_WALL, LIGHTING_LEVEL_40_PERCENT,5)
		lightsSetLevelWithFade (LIGHT_ADDRESS_DOWN_LIGHTS_SIDE_AND_BACK_WALLS, LIGHTING_LEVEL_40_PERCENT,5)
		
		// turn on the left monitor
		necMonitorSetPowerOn (vdvMonitorLeft)
		
		// flip the panel to the main page
		moderoSetPage (dvTpTableMain, PAGE_NAME_MAIN_USER)
		// show the source selection / volume control page
		moderoEnablePopup (dvTpTableMain, POPUP_NAME_SOURCE_SELECTION)
		
		// set the flag to show that the AV system is now in use
		isSystemAvInUse = TRUE
	}
	// system is in use - is there a monitor not being used?
	else if (selectedVideoInputMonitorLeft == DVX_PORT_VID_IN_NONE)
	{
		stack_var integer input
		
		select
		{
			active (dvTxVidIn == dvTxTable1VidInDigital):    input = dvDvxVidInTx1.port
			active (dvTxVidIn == dvTxTable1VidInAnalog):     input = dvDvxVidInTx1.port
			
			active (dvTxVidIn == dvTxTable2VidInDigital):    input = dvDvxVidInTx2.port
			active (dvTxVidIn == dvTxTable2VidInAnalog):     input = dvDvxVidInTx2.port
			
			active (dvTxVidIn == dvTxTable3VidInDigital):    input = dvDvxVidInTx3.port
			active (dvTxVidIn == dvTxTable3VidInAnalog):     input = dvDvxVidInTx3.port
			
			active (dvTxVidIn == dvTxTable4VidInDigital):    input = dvDvxVidInTx4.port
			active (dvTxVidIn == dvTxTable4VidInAnalog):     input = dvDvxVidInTx4.port
		}
		
		// route the DVX input for this TX to the DVX output for the left monitor
		dvxSwitchVideoOnly (dvDvxMain, input, dvDvxVidOutMonitorLeft.port)
		
		// audio
		if (  (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
		      ((audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port) and (signalStatusDvxInputMonitorRight != DVX_SIGNAL_STATUS_VALID_SIGNAL))  )
		{
			audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
		}
		
		if (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port)
		{
			dvxSwitchAudioOnly (dvDvxMain, input, dvDvxAudOutSpeakers.port)
		}
		
		// turn on the left monitor
		necMonitorSetPowerOn (vdvMonitorLeft)
	}
	else if (selectedVideoInputMonitorRight == DVX_PORT_VID_IN_NONE)
	{
		stack_var integer input
		
		select
		{
			active (dvTxVidIn == dvTxTable1VidInDigital):    input = dvDvxVidInTx1.port
			active (dvTxVidIn == dvTxTable1VidInAnalog):     input = dvDvxVidInTx1.port
			
			active (dvTxVidIn == dvTxTable2VidInDigital):    input = dvDvxVidInTx2.port
			active (dvTxVidIn == dvTxTable2VidInAnalog):     input = dvDvxVidInTx2.port
			
			active (dvTxVidIn == dvTxTable3VidInDigital):    input = dvDvxVidInTx3.port
			active (dvTxVidIn == dvTxTable3VidInAnalog):     input = dvDvxVidInTx3.port
			
			active (dvTxVidIn == dvTxTable4VidInDigital):    input = dvDvxVidInTx4.port
			active (dvTxVidIn == dvTxTable4VidInAnalog):     input = dvDvxVidInTx4.port
		}
		
		// route the DVX input for this TX to the DVX output for the right monitor
		dvxSwitchVideoOnly (dvDvxMain, input, dvDvxVidOutMonitorRight.port)
		
		// audio
		if (  (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
		      ((audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port) and (signalStatusDvxInputMonitorLeft != DVX_SIGNAL_STATUS_VALID_SIGNAL))    )
		{
			audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
		}
		
		if (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port)
		{
			dvxSwitchAudioOnly (dvDvxMain, input, dvDvxAudOutSpeakers.port)
		}
		
		// turn on the right monitor
		necMonitorSetPowerOn (vdvMonitorRight)
	}
}


define_function loadVideoPreviewWindow (dev dvDvxVidInPort)
{
	// kill the multi-preview snapshot timeline
	stopMultiPreviewSnapshots ()
	
	// turn on the video being previed flag
	ON [isVideoBeingPreviewed]
	
	// delete video snapshot on the video preview button
	moderoDeleteButtonVideoSnapshot (dvTpTableVideo, BTN_ADR_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL)
	
	moderoDisableButtonFeedback (dvTpTableVideo, BTN_VIDEO_PREVIEW_LOADING_BAR)    // reset the loading progress bar
	
	moderoSetButtonOpacity (dvTpTableVideo, BTN_ADR_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
	//moderoSetButtonHide (dvTpTableVideo, BTN_ADR_VIDEO_PREVIEW_WINDOW)
	moderoSetButtonShow (dvTpTableVideo, BTN_ADR_VIDEO_LOADING_PREVIEW)
	moderoSetButtonShow (dvTpTableVideo, BTN_ADR_VIDEO_PREVIEW_LOADING_BAR)
	
	moderoEnablePopup (dvTpTableVideo, POPUP_NAME_VIDEO_PREVIEW)
	
	moderoEnableButtonFeedback (dvTpTableVideo, BTN_VIDEO_PREVIEW_LOADING_BAR) //start the loading progress bar
	
	dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPort.port, dvDvxVidOutMultiPreview.port)
	
	CANCEL_WAIT 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	WAIT waitTimeVideoLoading 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	{
		moderoSetButtonHide (dvTpTableVideo, BTN_ADR_VIDEO_LOADING_PREVIEW)
		moderoSetButtonHide (dvTpTableVideo, BTN_ADR_VIDEO_PREVIEW_LOADING_BAR)
		//moderoSetButtonShow (dvTpTableVideo, BTN_ADR_VIDEO_PREVIEW_WINDOW)
		moderoSetButtonOpacity (dvTpTableVideo, BTN_ADR_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_OPAQUE)
	}
}



/*
 * --------------------
 * Lighting functions
 * --------------------
 */

define_function lightsEnablePresetAllOn()
{
	lightsPassThroughData (DYNALITE_PROTOCOL_RECALL_PRESET_ALL_ON)
}

define_function lightsEnablePresetAllOff()
{
	lightsPassThroughData (DYNALITE_PROTOCOL_RECALL_PRESET_ALL_OFF)
}

define_function lightsEnablePresetAllDim()
{
	lightsPassThroughData (DYNALITE_PROTOCOL_RECALL_PRESET_ALL_DIM)
}

define_function lightsEnablePresetPresentation()
{
	lightsPassThroughData (DYNALITE_PROTOCOL_RECALL_PRESET_AV_MODE)
}

define_function lightsEnablePresetVc()
{
	lightsPassThroughData (DYNALITE_PROTOCOL_RECALL_PRESET_VC_MODE_1)
}





/*
 * --------------------
 * Override dvx-listener callback functions
 * --------------------
 */

#define INCLUDE_DVX_NOTIFY_SWITCH_CALLBACK
define_function dvxNotifySwitch (dev dvxPort1, char signalType[], integer input, integer output)
{
	// dvxPort1 is port 1 on the DVX.
	// signalType contains the type of signal that was switched ('AUDIO' or 'VIDEO')
	// input contains the source input number that was switched to the destination
	// output contains the destination output number that the source was switched to
	
	switch (signalType)
	{
		case SIGNAL_TYPE_VIDEO:
		{
			select
			{
				active (output == dvDvxVidOutMonitorLeft.port):     selectedVideoInputMonitorLeft = input
				
				active (output == dvDvxVidOutMonitorRight.port):    selectedVideoInputMonitorRight = input
			}
		}
		case SIGNAL_TYPE_AUDIO:
		{
			select
			{
				active (output == dvDvxAudOutSpeakers.port):    selectedAudioInput = input
			}
		}
	}
}


#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_NAME_CALLBACK
define_function dvxNotifyVideoInputName (dev dvxVideoInput, char name[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// name is the name of the video input
	
	//moderoSetButtonText (dvTpTableVideo, btnsVideoInputsMonitorLeft[dvxVideoInput.port], MODERO_BUTTON_STATE_ALL, name)
	//moderoSetButtonText (dvTpTableVideo, btnsVideoInputsMonitorRight[dvxVideoInput.port], MODERO_BUTTON_STATE_ALL, name)
	
	dvx.videoInputs[dvxVideoInput.port].name = name
}


#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)
	
	stack_var char oldSignalStatus[50]
	
	oldSignalStatus = dvx.videoInputs[dvxVideoInput.port].status
	
	if (signalStatus != oldSignalStatus)
	{
		dvx.videoInputs[dvxVideoInput.port].status = signalStatus
		startMultiPreviewSnapshots ()
	}
	
	
	switch (signalStatus)
	{
		case DVX_SIGNAL_STATUS_NO_SIGNAL:
		case DVX_SIGNAL_STATUS_UNKNOWN:
		{
			moderoSetButtonBitmap (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_LEFT_INPUT_SELECTION[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL,IMAGE_FILE_NAME_NO_IMAGE_ICON)
			moderoSetButtonBitmap (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL,IMAGE_FILE_NAME_NO_IMAGE_ICON)
		}
		case DVX_SIGNAL_STATUS_VALID_SIGNAL:
		{
			moderoEnableButtonScaleToFit (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_LEFT_INPUT_SELECTION[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL)
			moderoEnableButtonScaleToFit (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL)
			
			// NOTE: Don't set the dynamic resource here. That should be done by the timeline event for taking snapshots.
			// Otherwise it could result in the snapshots image of the currently routed video to the MPL being shown on all snapshot buttons.
			
		}
	}
	
	if (dvxVideoInput.port == selectedVideoInputMonitorLeft)
	{
		signalStatusDvxInputMonitorLeft = signalStatus
	}
	if (dvxVideoInput.port == selectedVideoInputMonitorRight)
	{
		signalStatusDvxInputMonitorRight = signalStatus
	}
	
	// Energy saving - switch off monitors when signal has been disconnected for some time
	// if signal
	switch (signalStatus)
	{
		case DVX_SIGNAL_STATUS_VALID_SIGNAL:
		{
			if (dvxVideoInput.port == selectedVideoInputMonitorLeft)
			{
				cancel_wait 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_LEFT_MONITOR_TO_RETURN'
				
			}
			if (dvxVideoInput.port == selectedVideoInputMonitorRight)
			{
				cancel_wait 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_RIGHT_MONITOR_TO_RETURN'
			}
		}
		case DVX_SIGNAL_STATUS_NO_SIGNAL:
		{
			if (dvxVideoInput.port == selectedVideoInputMonitorLeft)
			{
				wait waitTimeValidSignal 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_LEFT_MONITOR_TO_RETURN'
				{
					necMonitorSetPowerOff (vdvMonitorLeft)
					dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorLeft.port)
					off [selectedVideoInputMonitorLeft]
					
					if (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port)
					{
						if (signalStatusDvxInputMonitorRight == DVX_SIGNAL_STATUS_VALID_SIGNAL)
						{
							dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorRight, dvDvxAudOutSpeakers.port)
							audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
						}
						else
						{
							dvxSwitchAudioOnly (dvDvxMain, DVX_PORT_AUD_IN_NONE, dvDvxAudOutSpeakers.port)
							dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
							off [selectedAudioInput]
							off [audioFollowingVideoOutput]
						}
					}
				}
			}
			
			if (dvxVideoInput.port == selectedVideoInputMonitorRight)
			{
				wait waitTimeValidSignal 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_RIGHT_MONITOR_TO_RETURN'
				{
					necMonitorSetPowerOff (vdvMonitorRight)
					dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorRight.port)
					off [selectedVideoInputMonitorRight]
					
					if (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port)
					{
						if (signalStatusDvxInputMonitorLeft == DVX_SIGNAL_STATUS_VALID_SIGNAL)
						{
							dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorLeft, dvDvxAudOutSpeakers.port)
							audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
						}
						else
						{
							dvxSwitchAudioOnly (dvDvxMain, DVX_PORT_AUD_IN_NONE, dvDvxAudOutSpeakers.port)
							dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
							off [selectedAudioInput]
							off [audioFollowingVideoOutput]
						}
					}
				}
			}
		}
	}
}


#define INCLUDE_DVX_NOTIFY_AUDIO_OUT_MUTE_CALLBACK
define_function dvxNotifyAudioOutMute (dev dvxAudioOutput, char muteStatus[])
{
	// dvxAudioOutput is the D:P:S of the video output port on the DVX switcher. The output number can be taken from dvDvxAudioOutput.PORT
	// muteStatus is the mute status (STATUS_ENABLE | STATUS_DISABLE)
	
	dvx.audioOutputs[dvxAudioOutput.port].muteStatus = muteStatus
	
	if (dvxAudioOutput == dvDvxAudOutSpeakers)
	{
		switch (muteStatus)
		{
			case STATUS_ENABLE:    moderoEnableButtonFeedback (dvTpTableAudio, BTN_AUDIO_VOLUME_MUTE)
			
			case STATUS_DISABLE:   moderoDisableButtonFeedback (dvTpTableAudio, BTN_AUDIO_VOLUME_MUTE)
		}
	}
}


#define INCLUDE_DVX_NOTIFY_AUDIO_OUT_VOLUME_CALLBACK
define_function dvxNotifyAudioOutVolume (dev dvxAudioOutput, integer volume)
{
	// dvxAudioOutput is the D:P:S of the video output port on the DVX switcher. The output number can be taken from dvDvxAudioOutput.PORT
	// volume is the volume value (range: 0 to 100)
	
	dvx.audioOutputs[dvxAudioOutput.port].volume = volume
	
	if (dvxAudioOutput == dvDvxAudOutSpeakers)
	{
		send_level dvTpTableAudio, BTN_LVL_VOLUME_DISPLAY, volume
	}
}

#define INCLUDE_DVX_NOTIFY_AUDIO_OUT_MAXIMUM_VOLUME_CALLBACK
define_function dvxNotifyAudioOutMaximumVolume (dev dvxAudioOutput, integer maxVol)
{
	// dvxAudioOutput is the D:P:S of the video output port on the DVX switcher. The output number can be taken from dvDvxAudioOutput.PORT
	// maxVol is the maximum volume setting for the audio output port (range: 0 to 100)
	
	if (dvxAudioOutput == dvDvxAudOutSpeakers)
	{
		moderoSetButtonBargraphUpperLimit (dvTpTableAudio, BTN_ADR_VOLUME_BARGRAPH_CONTROL, /*MODERO_BUTTON_STATE_ALL,*/ maxVol)
		moderoSetButtonBargraphUpperLimit (dvTpTableAudio, BTN_ADR_VOLUME_BARGRAPH_DISPLAY, /*MODERO_BUTTON_STATE_ALL,*/ maxVol)
	}
}


/*
 * --------------------
 * Override dxlink-listener callback functions
 * --------------------
 */


#define INCLUDE_DXLINK_NOTIFY_RX_VIDEO_OUTPUT_RESOLUTION_CALLBACK
define_function dxlinkNotifyRxVideoOutputResolution (dev dxlinkRxVideoOutput, char resolution[])
{
	// dxlinkRxVideoOutput is the D:P:S of the video output port on the DXLink receiver
	// cResolution is the video output resolution and refresh (HORxVER,REF)
	
	select
	{
		active(dxlinkRxVideoOutput == dvRxMonitorLeftVidOut):
		{
			moderoSetButtonText(dvTpTableDxlink,
					BTN_ADR_DXLINK_RX_OUTPUT_RESOLUTION_MONITOR_LEFT,
					MODERO_BUTTON_STATE_ALL,
					resolution)
		}
		
		active(dxlinkRxVideoOutput == dvRxMonitorRightVidOut):
			moderoSetButtonText (dvTpTableDxlink, BTN_ADR_DXLINK_RX_OUTPUT_RESOLUTION_MONITOR_RIGHT, MODERO_BUTTON_STATE_ALL, resolution)
	}
}


#define INCLUDE_DXLINK_NOTIFY_RX_VIDEO_OUTPUT_SCALE_MODE_CALLBACK
define_function dxlinkNotifyRxVideoOutputScaleMode (dev dxlinkRxVideoOutput, char scaleMode[])
{
	// dxlinkRxVideoOutput is the D:P:S of the video output port on the DXLink receiver
	// scaleMode contains the scaler mode (DXLINK_SCALE_MODE_AUTO | DXLINK_SCALE_MODE_BYPASS | DXLINK_SCALE_MODE_MANUAL)
	
	select
	{
		active(dxlinkRxVideoOutput == dvRxMonitorLeftVidOut):
		{
			switch (scaleMode)
			{
				case DXLINK_SCALE_MODE_AUTO:    moderoEnableButtonFeedback(dvTpTableDxlink, BTN_DXLINK_RX_SCALER_AUTO_MONITOR_LEFT)
				case DXLINK_SCALE_MODE_BYPASS:  moderoEnableButtonFeedback( dvTpTableDxlink, BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_LEFT)
				case DXLINK_SCALE_MODE_MANUAL:  moderoEnableButtonFeedback( dvTpTableDxlink, BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_LEFT)
			}
		}
		
		active(dxlinkRxVideoOutput == dvRxMonitorRightVidOut):
		{
			switch (scaleMode)
			{
				case DXLINK_SCALE_MODE_AUTO:    moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_SCALER_AUTO_MONITOR_RIGHT)
				case DXLINK_SCALE_MODE_BYPASS:  moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_RIGHT)
				case DXLINK_SCALE_MODE_MANUAL:  moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_RIGHT)
			}
		}
	}
}


#define INCLUDE_DXLINK_NOTIFY_RX_VIDEO_OUTPUT_ASPECT_RATIO_CALLBACK
define_function dxlinkNotifyRxVideoOutputAspectRatio (dev dxlinkRxVideoOutput, char aspectRatio[])
{
	// dxlinkRxVideoOutput is the D:P:S of the video output port on the DXLink receiver
	// cAspectRatio is the aspect ratio (DXLINK_ASPECT_RATIO_ANAMORPHIC | DXLINK_ASPECT_RATIO_MAINTAIN | DXLINK_ASPECT_RATIO_STRETCH | DXLINK_ASPECT_RATIO_ZOOM)
	
	select
	{
		active(dxlinkRxVideoOutput == dvRxMonitorLeftVidOut):
		{
			switch (aspectRatio)
			{
				case DXLINK_ASPECT_RATIO_ANAMORPHIC:    moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_LEFT)
				case DXLINK_ASPECT_RATIO_MAINTAIN:      moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_LEFT)
				case DXLINK_ASPECT_RATIO_STRETCH:       moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_LEFT)
				case DXLINK_ASPECT_RATIO_ZOOM:          moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_LEFT)
			}
		}
		
		active(dxlinkRxVideoOutput == dvRxMonitorRightVidOut):
		{
			switch (aspectRatio)
			{
				case DXLINK_ASPECT_RATIO_ANAMORPHIC:    moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_RIGHT)
				case DXLINK_ASPECT_RATIO_MAINTAIN:      moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_RIGHT)
				case DXLINK_ASPECT_RATIO_STRETCH:       moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_RIGHT)
				case DXLINK_ASPECT_RATIO_ZOOM:          moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_RIGHT)
			}
		}
	}
}


#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_AUTO_SELECT_CALLBACK
define_function dxlinkNotifyTxVideoInputAutoSelect (dev dxlinkTxPort1, char status[])
{
	// dvDxlinkTxPort1 is the port #1 on the DXLink Tx
	// cStatus contains the auto video input select status (STATUS_ENABLE | STATUS_DISABLE)
	
	switch (status)
	{
		case STATUS_ENABLE:
		{
			select
			{
				active (dxlinkTxPort1 == dvTxTable1Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_1)
				active (dxlinkTxPort1 == dvTxTable2Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_2)
				active (dxlinkTxPort1 == dvTxTable3Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_3)
				active (dxlinkTxPort1 == dvTxTable4Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_4)
			}
		}
		case STATUS_DISABLE:
		{
			select
			{
				active (dxlinkTxPort1 == dvTxTable1Main):   moderoDisableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_1)
				active (dxlinkTxPort1 == dvTxTable2Main):   moderoDisableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_2)
				active (dxlinkTxPort1 == dvTxTable3Main):   moderoDisableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_3)
				active (dxlinkTxPort1 == dvTxTable4Main):   moderoDisableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_4)
			}
		}
	}
}


#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_ANALOG_CALLBACK
define_function dxlinkNotifyTxVideoInputStatusAnalog (dev dxlinkTxAnalogVideoInput, char signalStatus[])
{
	// dxlinkTxAnalogVideoInput is the analog video input port on the DXLink Tx
	// signalStatus is the input signal status (DXLINK_SIGNAL_STATUS_NO_SIGNAL | DXLINK_SIGNAL_STATUS_UNKNOWN | DXLINK_SIGNAL_STATUS_VALID_SIGNAL)
	
	switch (signalStatus)
	{
		case DXLINK_SIGNAL_STATUS_UNKNOWN:    {}
		
		case DXLINK_SIGNAL_STATUS_NO_SIGNAL:  {}
		
		case DXLINK_SIGNAL_STATUS_VALID_SIGNAL:
		{
			tableInputDetected (dxlinkTxAnalogVideoInput)
		}
	}
}


#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_DIGITAL_CALLBACK
define_function dxlinkNotifyTxVideoInputStatusDigital (dev dxlinkTxDigitalVideoInput, char signalStatus[])
{
	// dxlinkTxDigitalVideoInput is the digital video input port on the DXLink Tx
	// signalStatus is the input signal status (DXLINK_SIGNAL_STATUS_NO_SIGNAL | DXLINK_SIGNAL_STATUS_UNKNOWN | DXLINK_SIGNAL_STATUS_VALID_SIGNAL)
	
	switch (signalStatus)
	{
		case DXLINK_SIGNAL_STATUS_UNKNOWN:    {}
		
		case DXLINK_SIGNAL_STATUS_NO_SIGNAL:  {}
		
		case DXLINK_SIGNAL_STATUS_VALID_SIGNAL:
		{
			tableInputDetected (dxlinkTxDigitalVideoInput)
		}
	}
}

/*
#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_FORMAT_ANALOG_CALLBACK
define_function dxlinkNotifyTxVideoInputFormatAnalog (dev dxlinkTxAnalogVideoInput, char videoFormat[])
{
	// dxlinkTxAnalogVideoInput is the analog video input port on the DXLink Tx
	// videoFormat is the video format (VIDEO_SIGNAL_FORMAT_VGA | VIDEO_SIGNAL_FORMAT_COMPOSITE | VIDEO_SIGNAL_FORMAT_COMPONENT | VIDEO_SIGNAL_FORMAT_SVIDEO)
}
*/
/*
#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_FORMAT_DIGITAL_CALLBACK
define_function dxlinkNotifyTxVideoInputFormatDigital (dev dxlinkTxDigitalVideoInput, char videoFormat[])
{
	// dxlinkTxDigitalVideoInput is the digital video input port on the DXLink Tx
	// videoFormat is the video format (VIDEO_SIGNAL_FORMAT_DVI | VIDEO_SIGNAL_FORMAT_HDMI)
}
*/

#define INCLUDE_DXLINK_NOTIFY_TX_SWITCH_CALLBACK
define_function dxlinkNotifyTxSwitch (dev dxlinkTxPort1, integer input, integer output)
{
	// dxlinkTxPort1 is port 1 on the DXLink Tx.
	// input contains the input port on the DXLink TX that has been selected (DXLINK_PORT_VIDEO_INPUT_ANALOG | DXLINK_PORT_VIDEO_INPUT_DIGITAL)
	// output contains the output of the DXLink TX. This is always DXLINK_PORT_VIDEO_OUTPUT.
	
	switch (input)
	{
		case DXLINK_PORT_VIDEO_INPUT_ANALOG:
		{
			select
			{
				active (dxlinkTxPort1 == dvTxTable1Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_VGA_1)
				active (dxlinkTxPort1 == dvTxTable2Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_VGA_2)
				active (dxlinkTxPort1 == dvTxTable3Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_VGA_3)
				active (dxlinkTxPort1 == dvTxTable4Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_VGA_4)
			}
		}
		case DXLINK_PORT_VIDEO_INPUT_DIGITAL:
		{
			select
			{
				active (dxlinkTxPort1 == dvTxTable1Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_HDMI_1)
				active (dxlinkTxPort1 == dvTxTable2Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_HDMI_2)
				active (dxlinkTxPort1 == dvTxTable3Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_HDMI_3)
				active (dxlinkTxPort1 == dvTxTable4Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_HDMI_4)
			}
		}
	}
}

/*
#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_RESOLUTION_ANALOG_CALLBACK
define_function dxlinkNotifyTxVideoInputResolutionAnalog (dev dxlinkTxAnalogVideoInput, char resolution[])
{
	// dxlinkTxAnalogVideoInput is the analog video input port on the DXLink Tx
	// resolution is the input resolution.
}
*/
/*
#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_RESOLUTION_DIGITAL_CALLBACK
define_function dxlinkNotifyTxVideoInputResolutionDigital (dev dxlinkTxDigitalVideoInput, char resolution[])
{
	// dxlinkTxDigitalVideoInput is the digital video input port on the DXLink Tx
	// resolution is the input resolution.
}
*/

/*
 * --------------------
 * Override pdu-listener callback functions
 * --------------------
 */


/*
#define INCLUDE_PDU_NOTIFY_OVER_CURRENT_CALLBACK
define_function pduNotifyOverCurrent (dev pduPort1, integer outlet, float current)
{
	// pduPort1 is port 1 on the PDU
	// outlet is the outlet of the PDU which is reporting overcurrent. If nPduOutlet is zero (0) then entire PDU is over current.
	// current is the current (in Amps)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_PERSIST_STATE_ALL_OUTLETS_CALLBACK
define_function pduNotifyPersistStateAllOutlets (dev pduPort1, integer outletPersistStates[])
{
	// pduPort1 is port 1 on the PDU
	// outletPersistStates is an array containing the persist state of each outlet on the PDU
}
*/

#define INCLUDE_PDU_NOTIFY_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyPowerSenseTrigger (dev pduPort1, integer outlet, float triggerValue)
{
	// pduPort1 is port 1 on the PDU
	// outlet is the outlet of the PDU which is reporting the power sense trigger value
	// triggerValue is the power sense trigger value
	
	moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_TRIGGER[outlet], MODERO_BUTTON_STATE_ALL, ftoa(triggerValue))
}


#define INCLUDE_PDU_NOTIFY_OUTLET_OVER_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyOutletOverPowerSenseTrigger (dev pduOutletPort)
{
	// dvPduOutlet is an outlet device on the PDU which has gone over the power sense trigger value
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[1], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[2], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[3], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[4], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[5], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[6], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[7], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[8], MODERO_BUTTON_STATE_ALL, 'Above')
	}
}


#define INCLUDE_PDU_NOTIFY_OUTLET_UNDER_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyOutletUnderPowerSenseTrigger (dev pduOutletPort)
{
	// pduOutletPort is an outlet device on the PDU which has gone under the power sense trigger value
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[1], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[2], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[3], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[4], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[5], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[6], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[7], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[8], MODERO_BUTTON_STATE_ALL, 'Below')
	}
}


#define INCLUDE_PDU_NOTIFY_OUTLET_RELAY_CALLBACK
define_function pduNotifyOutletRelay (dev pduOutletPort, integer relayStatus)
{
	// dvPduOutlet is an outlet device on the PDU
	// nRelayStatus indicates whether the relay is on (TRUE) or off (FALSE)
	switch (relayStatus)
	{
		case TRUE:
		{
			select
			{
				active (pduOutletPort == dvPduOutlet1):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[1], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet2):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[2], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet3):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[3], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet4):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[4], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet5):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[5], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet6):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[6], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet7):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[7], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet8):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[8], MODERO_BUTTON_STATE_ALL, 'On')
			}
		}
		case FALSE:
		{
			select
			{
				active (pduOutletPort == dvPduOutlet1):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[1], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet2):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[2], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet3):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[3], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet4):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[4], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet5):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[5], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet6):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[6], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet7):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[7], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet8):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[8], MODERO_BUTTON_STATE_ALL, 'Off')
			}
		}
	}
}


/*
#define INCLUDE_PDU_NOTIFY_SERIAL_NUMBER_CALLBACK
define_function fnPdyNotifySerialNumber (dev pduPort1, char serialNumber[])
{
	// pduPort1 is port 1 on the PDU
	// serialNumber is the serial number of the PDU
}
*/

/*
#define INCLUDE_PDU_NOTIFY_VERSION_CALLBACK
define_function pduNotifyVersion (dev pduPort1, float version)
{
	// pduPort1 is port 1 on the PDU
	// version is the version of firmware running on the PDU
}
*/

#define INCLUDE_PDU_NOTIFY_INPUT_VOLTAGE_CALLBACK
define_function pduNotifyInputVoltage (dev pduPort1, float voltage)
{
	// pduPort1 is the first device on the PDU
	// voltage is the input voltage (V): Resolution to 0.1V (data scale factor = 10)
	moderoSetButtonText (dvTpTablePower, BTN_ADR_POWER_INPUT_VOLTAGE, MODERO_BUTTON_STATE_ALL, ftoa(voltage))
}


#define INCLUDE_PDU_NOTIFY_TEMPERATURE_CALLBACK
define_function pduNotifyTemperature (dev pduPort1, float temperature)
{
	// pduPort1 is the first device on the PDU
	// temperature is the temperature (degrees C or F): Resolution to 0.1C (data scale factor = 10)
	moderoSetButtonText (dvTpTablePower, BTN_ADR_POWER_TEMPERATURE, MODERO_BUTTON_STATE_ALL, ftoa(temperature))
}


#define INCLUDE_PDU_NOTIFY_OUTLET_POWER_CALLBACK
define_function pduNotifyOutletPower (dev pduOutletPort, float wattage)
{
	// pduOutletPort is the outlet on the PDU reporting its power
	// wattage is the power (W): Resolution to 0.1W (data scale factor = 10)
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[1], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[2], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[3], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[4], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[5], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[6], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[7], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[8], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
	}
}


#define INCLUDE_PDU_NOTIFY_OUTLET_CURRENT_CALLBACK
define_function pduNotifyOutletCurrent (dev pduOutletPort, float current)
{
	// pduOutletPort is the outlet on the PDU reporting its current
	// current is the curren (A): Resolution to 0.1A (data scale factor = 10)
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[1], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[2], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[3], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[4], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[5], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[6], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[7], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[8], MODERO_BUTTON_STATE_ALL, ftoa(current))
	}
}


/*
#define INCLUDE_PDU_NOTIFY_OUTLET_POWER_FACTOR_CALLBACK
define_function pduNotifyOutletPowerFactor (dev pduOutletPort, float powerFactor)
{
	// pduOutletPort is the outlet on the PDU reporting its power factor
	// powerFactor is the Power Factor: W/VA, 2 decimal places (data scale factor = 100).
	//     - "Power Factor" is the ratio of real power to apparent power.
}
*/


#define INCLUDE_PDU_NOTIFY_OUTLET_POWER_CALLBACK
define_function pduNotifyOutletEnergy (dev pduOutletPort, float accumulatedEnergy)
{
	// pduOutletPort is the outlet on the PDU reporting its accumulated energy
	// accumulatedEnergy is the accumulated energy reading or power over time (W-hr): Resolution to 0.1W-hr (data scale factor = 10)
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[1], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[2], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[3], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[4], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[5], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[6], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[7], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[8], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
	}
}


#define INCLUDE_PDU_NOTIFY_AXLINK_VOLTAGE_CALLBACK
define_function pduNotifyAxlinkVoltage (dev pduPort2, float voltage)
{
	// pduPort2 is an Axlink bus on the PDU
	// voltage is the voltage (V): Resolution to 0.1V (data scale factor = 10)
	moderoSetButtonText (dvTpTablePower, BTN_ADR_POWER_AXLINK_VOLTAGE, MODERO_BUTTON_STATE_ALL, ftoa(voltage))
}


/*
#define INCLUDE_PDU_NOTIFY_AXLINK_POWER
define_function pduNotifyAxlinkPower (dev pduAxlinkBus, float power)
{
	// pduAxlinkBus is an Axlink bus on the PDU
	// power is the power (W): Resolution to 0.1W (data scale factor = 10)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_AXLINK_CURRENT
define_function pduNotifyAxlinkCurrent (dev pduAxlinkBus, float current)
{
	// pduAxlinkBus is an Axlink bus on the PDU
	// current is the curren (A): Resolution to 0.1A (data scale factor = 10)
}
*/


#define INCLUDE_PDU_NOTIFY_TEMPERATURE_SCALE_CELCIUS
define_function pduNotifyTemperatureScaleCelcius (dev pduPort1)
{
	// pduPort1 is the first device on the PDU
}

#define INCLUDE_PDU_NOTIFY_TEMPERATURE_SCALE_FAHRENHEIT
define_function pduNotifyTemperatureScaleFahrenheit (dev pduPort1)
{
	// pduPort1 is the first device on the PDU
}








/*
 * --------------------
 * Override controlports-listener callback functions
 * --------------------
 */


#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_ON_CALLBACK
define_function amxControlPortNotifyIoInputOn (dev ioPort, integer ioChanCde)
{
	// ioPort is the IO port.
	// ioChanCde is the IO channel code.
	
	if (ioPort == dvDvxIos)
	{
		switch (ioChanCde)
		{
			case IO_OCCUPANCY_SENSOR:
			{
				// occupancy has been detected - meaning the room was previously vacant
				isRoomOccupied = TRUE
				
				// Set lights to "all on" mode as people have entered the room
				lightsEnablePresetAllOn ()
				
				// wake up the touch panel
				moderoWake (dvTpTableMain)
				
				// start taking snapshots (just in case the person who triggered the occ sensor wants to go to the source selection page)
				startMultiPreviewSnapshots ()
			}
		}
	}
}



#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_OFF_CALLBACK
define_function amxControlPortNotifyIoInputOff (dev ioPort, integer ioChanCde)
{
	// ioPort is the IO port.
	// ioChanCde is the IO channel code.
	
	if (ioPort == dvDvxIos)
	{
		switch (ioChanCde)
		{
			case IO_OCCUPANCY_SENSOR:
			{
				// room is now unoccupied (note: Will take 8 minutes minimum to trigger after person leaves room)
				isRoomOccupied = FALSE
				
				// Set lights to "all off" mode as there have been no people in the room for at least 8 minutes
				lightsEnablePresetAllOff ()
				
				// Flip the touch panel to the splash screen
				moderoSetPage (dvTpTableMain, PAGE_NAME_SPLASH_SCREEN)
				
				// Send the panel to sleep
				moderoSleep (dvTpTableMain)
				
				// Stop taking snapshots
				stopMultiPreviewSnapshots ()
				
				// shutdown the system if it was being used (i.e., someone just walked away without pressing the shutdown button on the panel)
				if (isSystemAvInUse)
				{
					countTimesPeopleLeftWithoutShuttingDownSystem++
					shutdownAvSystem ()
				}
			}
		}
	}
}



/*
 * --------------------
 * Startup code
 * --------------------
 */
define_start


// rebuild the event table after setting the variable device and channel code array values
//rebuild_event()   // not needed unless assigning values to dev or dev array variables during runtime



/*
 * --------------------
 * Events
 * --------------------
 */

define_event


/*
 * --------------------
 * Data events
 * --------------------
 */

data_event[dvDvxMain]
{
	online:
	{
		dvxRequestVideoInputNameAll (dvDvxMain)
		dvxRequestVideoInputStatusAll (dvDvxMain)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorLeft.port)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorRight.port)
		dvxRequestInputAudio (dvDvxMain, dvDvxAudOutSpeakers.port)
		dvxRequestAudioOutputMute (dvDvxAudOutSpeakers)
		dvxSetAudioOutputMaximumVolume (dvDvxAudOutSpeakers, volumeMax)
		dvxRequestAudioOutputVolume (dvDvxAudOutSpeakers)
	}
}

// Configure Resolutions for Multi-Preview Input and associated DVX Output
data_event[dvDvxVidOutMultiPreview]
data_event[dvTpTableMain]
{
	online:
	{
		select
		{
			active (data.device == dvDvxVidOutMultiPreview):
			{
				dvxSetVideoOutputResolution (dvDvxVidOutMultiPreview, DVX_VIDEO_OUTPUT_RESOLUTION_1280x720p_60HZ)
				dvxSetVideoOutputAspectRatio (dvDvxVidOutMultiPreview, DVX_ASPECT_RATIO_STRETCH)
			}
			
			active (data.device == dvTpTableMain):
				moderoSetMultiPreviewInputFormatAndResolution (dvTpTableMain, MODERO_MULTI_PREVIEW_INPUT_FORMAT_HDMI, MODERO_MULTI_PREVIEW_INPUT_RESOLUTION_HDMI_1280x720p30HZ)
		}
	}
}

data_event[dvPduMain1]
{
	online:
	{
		pduRequestVersion (dvPduMain1)
		pduRequestSerialNumber (dvPduMain1)
		pduRequestPersistStateAllOutlets (dvPduMain1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_2)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_3)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_4)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_5)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_6)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_7)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_8)
		WAIT 50   // putting a wait here because the PDU seems to set the temp scale back to fahrenheit if it is set to celcius immediately after coming online
		pduSetTempScaleCelcius (dvPduMain1)
	}
}

data_event[dvTpTableMain]
{
	online:
	{
		/*
		 * --------------------
		 * Request info from connected devices.
		 * 
		 * This will solicit a response which will in turn update button feedback.
		 * --------------------
		 */
		
		// DVX
		dvxRequestVideoInputNameAll (dvDvxMain)
		dvxRequestVideoInputStatusAll (dvDvxMain)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorLeft.port)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorRight.port)
		dvxRequestInputAudio (dvDvxMain, dvDvxAudOutSpeakers.port)
		dvxRequestAudioOutputMute (dvDvxAudOutSpeakers)
		dvxRequestAudioOutputVolume (dvDvxAudOutSpeakers)
		dvxRequestAudioOutputMaximumVolume (dvDvxAudOutSpeakers)
		
		// DXLink Rx - Left monitor
		dxlinkRequestRxVideoOutputResolution (dvRxMonitorLeftVidOut)
		dxlinkRequestRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut)
		dxlinkRequestRxVideoOutputScaleMode (dvRxMonitorLeftVidOut)
		
		// DXLink Rx - Right monitor
		dxlinkRequestRxVideoOutputResolution (dvRxMonitorRightVidOut)
		dxlinkRequestRxVideoOutputAspectRatio (dvRxMonitorRightVidOut)
		dxlinkRequestRxVideoOutputScaleMode (dvRxMonitorRightVidOut)
		
		// DXLink Tx's
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable1Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable2Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable3Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable4Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable1Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable2Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable3Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable4Main)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable1VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable2VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable3VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable4VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable1VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable2VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable3VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable4VidInDigital)
		
		// PDU
		pduRequestVersion (dvPduMain1)
		pduRequestSerialNumber (dvPduMain1)
		pduRequestPersistStateAllOutlets (dvPduMain1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_2)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_3)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_4)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_5)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_6)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_7)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_8)
		
		// Update button text for PDU button labels
		{
			stack_var integer i
			
			for (i = 1; i <= PDU_MAX_OUTLETS; i++)
			{
				moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_OUTLET_LABELS[i], MODERO_BUTTON_STATE_ALL, LABELS_PDU_OUTLETS[i])
			}
		}
	}
}

data_event[dvTxTable1Main]
data_event[dvTxTable2Main]
data_event[dvTxTable3Main]
data_event[dvTxTable4Main]
{
	online:
	{
		dxlinkRequestTxVideoInputAutoSelect (data.device)
		dxlinkRequestTxSelectedVideoInput (data.device)
	}
}

data_event[dvTxTable1VidInAnalog]
data_event[dvTxTable2VidInAnalog]
data_event[dvTxTable3VidInAnalog]
data_event[dvTxTable4VidInAnalog]
{                 
	online:
	{
		dxlinkRequestTxVideoInputSignalStatusAnalog (data.device)
		
	}
}

data_event[dvTxTable1VidInDigital]
data_event[dvTxTable2VidInDigital]
data_event[dvTxTable3VidInDigital]
data_event[dvTxTable4VidInDigital]
{                 
	online:
	{
		dxlinkRequestTxVideoInputSignalStatusDigital (data.device)
		
	}
}

data_event[dvRxMonitorLeftVidOut]
data_event[dvRxMonitorRightVidOut]
{
	online:
	{
		dxlinkRequestRxVideoOutputResolution (data.device)
		dxlinkRequestRxVideoOutputAspectRatio (data.device)
		dxlinkRequestRxVideoOutputScaleMode (data.device)
	}
}


/*
 * --------------------
 * Button events
 * --------------------
 */


button_event[dvKeypad1,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_KP_OFF:         lightsEnablePresetAllOff()
			case BTN_KP_LIGHTS:      lightsEnablePresetAllOn()
			
			case BTN_KP_AV_OFF:      shutdownAvSystem ()
			
			case BTN_KP_WHITEBOARD:  lightsToggle (LIGHT_ADDRESS_DOWN_LIGHTS_WHITEBOARD)
			
			case BTN_KP_SHADES:
			{
				amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_DN)
			}
			case BTN_KP_BLOCKOUTS:
			{
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
			}
			
			#warn '@TODO: amx-au-gc-boardroom-main - What do we want to do with these keypad buttons? Anything?'
			case BTN_KP_WHEEL_ROTATE_LT: {}
			case BTN_KP_WHEEL_ROTATE_RT: {}
			case BTN_KP_CURSOR_UP:       {}
			case BTN_KP_CURSOR_DN:       {}
			case BTN_KP_CURSOR_LT:       {}
			case BTN_KP_CURSOR_RT:       {}
			case BTN_KP_ENTER:           {}
		}
	}
}




button_event[dvTpTableAudio,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_AUDIO_VOLUME_DN:    dvxEnableAudioOutputVolumeRampDown (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_UP:    dvxEnableAudioOutputVolumeRampUp (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_MUTE:  dvxCycleAudioOutputVolumeMute (dvDvxAudOutSpeakers)
			
			case BTN_AUDIO_INPUT_01:     dvxSwitchAudioOnly (dvDvxMain, 1, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_02:     dvxSwitchAudioOnly (dvDvxMain, 2, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_03:     dvxSwitchAudioOnly (dvDvxMain, 3, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_04:     dvxSwitchAudioOnly (dvDvxMain, 4, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_05:     dvxSwitchAudioOnly (dvDvxMain, 5, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_06:     dvxSwitchAudioOnly (dvDvxMain, 6, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_07:     dvxSwitchAudioOnly (dvDvxMain, 7, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_08:     dvxSwitchAudioOnly (dvDvxMain, 8, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_09:     dvxSwitchAudioOnly (dvDvxMain, 9, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_10:     dvxSwitchAudioOnly (dvDvxMain, 10, dvDvxAudOutSpeakers.port)
			
			case BTN_AUDIO_FOLLOW_MONITOR_LEFT:
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
				dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorLeft, dvDvxAudOutSpeakers.port)
			}
			case BTN_AUDIO_FOLLOW_MONITOR_RIGHT:
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
				dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorRight, dvDvxAudOutSpeakers.port)
			}
		}
	}
	release:
	{
		switch (button.input.channel)
		{
			case BTN_AUDIO_VOLUME_DN:    dvxDisableAudioOutputVolumeRampDown (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_UP:    dvxDisableAudioOutputVolumeRampUp (dvDvxAudOutSpeakers)
		}
	}
}

button_event[dvTpTableVideo,BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION]
{
	hold[waitTimeVideoPreview]:
	{
		loadVideoPreviewWindow (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)])
	}
	release:
	{
		if (!isVideoBeingPreviewed)
		{
			necMonitorSetPowerOn (vdvMonitorLeft)
			
			dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)].port, dvDvxVidOutMonitorLeft.port)
			
			if (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)] == dvDvxVidInPc)
			{
				wakeOnLan (MAC_ADDRESS_PC)
			}
			
			if ( (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
			     ((audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port) and (signalStatusDvxInputMonitorRight != DVX_SIGNAL_STATUS_VALID_SIGNAL))  )
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
			}
			
			if (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port)
			{
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)].port, dvDvxAudOutSpeakers.port)
			}
			
			// set flag to indicate that system is in use
			isSystemAvInUse = TRUE
		}
		
		// turn off the video being previewed flag
		//isVideoBeingPreviewed = FALSE	// moved to data_event to capture video preview popup hiding
	}
}

button_event[dvTpTableVideo,BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION]
{
	hold[waitTimeVideoPreview]:
	{
		loadVideoPreviewWindow (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)])
	}
	release:
	{
		if (!isVideoBeingPreviewed)
		{
			necMonitorSetPowerOn (vdvMonitorRight)
			
			dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)].port, dvDvxVidOutMonitorRight.port)
			
			if (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)] == dvDvxVidInPc)
			{
				wakeOnLan (MAC_ADDRESS_PC)
			}
			
			if ( (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
			     ((audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port) and (signalStatusDvxInputMonitorLeft != DVX_SIGNAL_STATUS_VALID_SIGNAL))    )
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
			}
			
			if (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port)
			{
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)].port, dvDvxAudOutSpeakers.port)
			}
			
			// set flag to indicate that system is in use
			isSystemAvInUse = TRUE
		}
		
		// turn off the video being previewed flag
		//isVideoBeingPreviewed = FALSE   // moved to data_event to capture video preview popup hiding
	}
}

button_event[dvTpTableVideo,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_VIDEO_MONITOR_LEFT_OFF:     necMonitorSetPowerOff (vdvMonitorLeft)
			case BTN_VIDEO_MONITOR_LEFT_ON:      necMonitorSetPowerOn (vdvMonitorLeft)
			case BTN_VIDEO_MONITOR_RIGHT_OFF:    necMonitorSetPowerOff (vdvMonitorRight)
			case BTN_VIDEO_MONITOR_RIGHT_ON:     necMonitorSetPowerOn (vdvMonitorRight)
			
			case BTN_VIDEO_QUERY_LYNC_CALL_NO:   {}  // ignore
			case BTN_VIDEO_QUERY_LYNC_CALL_YES:
			{
				lightsEnablePresetVc ()
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
				dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
			}
			
			case BTN_VIDEO_LYNC_MONITOR_LEFT:
			{
				min_to [button.input]   // feedback for the button
				recallCameraPreset (CAMERA_PRESET_1)
				wakeOnLan (MAC_ADDRESS_PC)
				dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxVidOutMonitorLeft.port)
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxAudOutSpeakers.port)
				audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
				lightsEnablePresetVc ()
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
				dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
				necMonitorSetPowerOn (vdvMonitorLeft)
				// set flag to indicate that system is in use
				isSystemAvInUse = TRUE
			}
			
			case BTN_VIDEO_LYNC_MONITOR_RIGHT:
			{
				min_to [button.input]   // feedback for the button
				recallCameraPreset (CAMERA_PRESET_2)
				wakeOnLan (MAC_ADDRESS_PC)
				dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxVidOutMonitorRight.port)
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxAudOutSpeakers.port)
				audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
				lightsEnablePresetVc ()
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
				dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
				necMonitorSetPowerOn (vdvMonitorRight)
				// set flag to indicate that system is in use
				isSystemAvInUse = TRUE
			}
		}
	}
}

button_event[dvTpTableLighting,0]
{
	push:
	{
		min_to [button.input]
		
		switch (button.input.channel)
		{
			case BTN_LIGHTING_PRESET_ALL_OFF:    lightsEnablePresetAllOff()
			case BTN_LIGHTING_PRESET_ALL_ON:     lightsEnablePresetAllOn()
			case BTN_LIGHTING_PRESET_ALL_DIM:    lightsEnablePresetAllDim()
			case BTN_LIGHTING_PRESET_VC_MODE:    lightsEnablePresetVc()
			
			case BTN_LIGHTING_AREA_WHITEBOARD_OFF:   lightsOff (LIGHT_ADDRESS_DOWN_LIGHTS_WHITEBOARD)
			case BTN_LIGHTING_AREA_WHITEBOARD_ON:    lightsOn (LIGHT_ADDRESS_DOWN_LIGHTS_WHITEBOARD)
			
			case BTN_LIGHTING_AREA_FRONT_UP:             lightsEnableRampUp (LIGHT_ADDRESS_DOWN_LIGHTS_FRONT_WALL)
			case BTN_LIGHTING_AREA_FRONT_DN:             lightsEnableRampDown (LIGHT_ADDRESS_DOWN_LIGHTS_FRONT_WALL)
			case BTN_LIGHTING_AREA_SIDE_AND_BACK_UP:     lightsEnableRampUp (LIGHT_ADDRESS_DOWN_LIGHTS_SIDE_AND_BACK_WALLS)
			case BTN_LIGHTING_AREA_SIDE_AND_BACK_DN:     lightsEnableRampDown (LIGHT_ADDRESS_DOWN_LIGHTS_SIDE_AND_BACK_WALLS)
			case BTN_LIGHTING_AREA_TABLE_UP:             lightsEnableRampUp (LIGHT_ADDRESS_DOWN_LIGHTS_DESK)
			case BTN_LIGHTING_AREA_TABLE_DN:             lightsEnableRampDown (LIGHT_ADDRESS_DOWN_LIGHTS_DESK)
		}
	}
	release:
	{
		switch (button.input.channel)
		{
			case BTN_LIGHTING_AREA_FRONT_UP:             lightsDisableRamp (LIGHT_ADDRESS_DOWN_LIGHTS_FRONT_WALL)
			case BTN_LIGHTING_AREA_FRONT_DN:             lightsDisableRamp (LIGHT_ADDRESS_DOWN_LIGHTS_FRONT_WALL)
			case BTN_LIGHTING_AREA_SIDE_AND_BACK_UP:     lightsDisableRamp (LIGHT_ADDRESS_DOWN_LIGHTS_SIDE_AND_BACK_WALLS)
			case BTN_LIGHTING_AREA_SIDE_AND_BACK_DN:     lightsDisableRamp (LIGHT_ADDRESS_DOWN_LIGHTS_SIDE_AND_BACK_WALLS)
			case BTN_LIGHTING_AREA_TABLE_UP:             lightsDisableRamp (LIGHT_ADDRESS_DOWN_LIGHTS_DESK)
			case BTN_LIGHTING_AREA_TABLE_DN:             lightsDisableRamp (LIGHT_ADDRESS_DOWN_LIGHTS_DESK)
		}
	}
}

button_event[dvTpTableBlinds,0]
{
	push:
	{
		min_to [button.input]
		
		switch (button.input.channel)
		{
			case BTN_BLIND_1_UP:     amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_UP)
			case BTN_BLIND_1_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
			case BTN_BLIND_1_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_BLOCKOUTS_CORNER_WINDOW_STOP)
			
			case BTN_BLIND_2_UP:     amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_UP)
			case BTN_BLIND_2_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
			case BTN_BLIND_2_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_BLOCKOUTS_WALL_WINDOW_STOP)
			
			case BTN_SHADE_1_UP:     amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_UP)
			case BTN_SHADE_1_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_DN)
			case BTN_SHADE_1_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_SHADES_CORNER_WINDOW_STOP)
			
			case BTN_SHADE_2_UP:     amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_UP)
			case BTN_SHADE_2_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_DN)
			case BTN_SHADE_2_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_SHADES_WALL_WINDOW_STOP)
		}                      
	}
}

button_event[dvTpTablePower,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_POWER_TOGGLE_MONITOR_LEFT:  pduToggleRelayPower (dvPduOutletMonitorLeft)
			case BTN_POWER_TOGGLE_MONITOR_RIGHT: pduToggleRelayPower (dvPduOutletMonitorRight)
			case BTN_POWER_TOGGLE_PDXL2:         pduToggleRelayPower (dvPduOutletPdxl2)
			
			case BTN_POWER_TOGGLE_MULTI_PREVIEW:
			{
				// Cycle power on the PDU
				pduDisableRelayPower (dvPduOutletMultiPreview)
				wait waitTimePowerCycle
				{
					pduEnableRelayPower (dvPduOutletMultiPreview)
				}
			}
			
			case BTN_POWER_TOGGLE_PC:        pduToggleRelayPower (dvPduOutletPc)
			//case BTN_POWER_TOGGLE_DVX:     pduToggleRelayPower (dvPduOutletDvx)    // don't allow user to turn power off to DVX
			case BTN_POWER_TOGGLE_FAN_1:     pduToggleRelayPower (dvPduOutletFan1)
			case BTN_POWER_TOGGLE_FAN_2:     pduToggleRelayPower (dvPduOutletFan2)
			
			case BTN_POWER_TEMPERATURE_SCALE_TOGGLE:     channelToggle (dvPduMain1,PDU_CHANNEL_TEMP_SCALE)
			case BTN_POWER_TEMPERATURE_SCALE_CELCIUS:    pduSetTempScaleCelcius (dvPduMain1)
			case BTN_POWER_TEMPERATURE_SCALE_FAHRENHEIT: pduSetTempScaleFahrenheit (dvPduMain1)
		}
	}
}

button_event[dvTpTableCamera,0]
{
	push:
	{
		min_to [button.input]
		
		switch (button.input.channel)
		{
			case BTN_CAMERA_FOCUS_NEAR:  agentUsbPtzWebCamFocusNearStandardSpeed (dvPtzCam)
			case BTN_CAMERA_FOCUS_FAR:   agentUsbPtzWebCamFocusFarStandardSpeed (dvPtzCam)
			case BTN_CAMERA_ZOOM_IN:     agentUsbPtzWebCamZoomInStandardSpeed (dvPtzCam)
			case BTN_CAMERA_ZOOM_OUT:    agentUsbPtzWebCamZoomOutStandardSpeed (dvPtzCam)
			case BTN_CAMERA_PAN_LEFT:    agentUsbPtzWebCamPanLeft (dvPtzCam, panSpeed)
			case BTN_CAMERA_PAN_RIGHT:   agentUsbPtzWebCamPanRight (dvPtzCam, panSpeed)
			case BTN_CAMERA_TILT_DOWN:   agentUsbPtzWebCamTiltDown (dvPtzCam, tiltSpeed)
			case BTN_CAMERA_TILT_UP:     agentUsbPtzWebCamTiltUp (dvPtzCam, tiltSpeed)
			
			case BTN_CAMERA_PRESET_1:
			{
				recallCameraPreset (CAMERA_PRESET_1)
			}
			case BTN_CAMERA_PRESET_2:
			{
				recallCameraPreset (CAMERA_PRESET_2)
			}
			case BTN_CAMERA_PRESET_3:
			{
				recallCameraPreset (CAMERA_PRESET_3)
			}
		}
	}
	release:
	{
		switch (button.input.channel)
		{
			case BTN_CAMERA_FOCUS_NEAR:  agentUsbPtzWebCamFocusOff (dvPtzCam)
			case BTN_CAMERA_FOCUS_FAR:   agentUsbPtzWebCamFocusOff (dvPtzCam)
			case BTN_CAMERA_ZOOM_IN:     agentUsbPtzWebCamZoomOff (dvPtzCam)
			case BTN_CAMERA_ZOOM_OUT:    agentUsbPtzWebCamZoomOff (dvPtzCam)
			case BTN_CAMERA_PAN_LEFT:    agentUsbPtzWebCamPanOff (dvPtzCam)
			case BTN_CAMERA_PAN_RIGHT:   agentUsbPtzWebCamPanOff (dvPtzCam)
			case BTN_CAMERA_TILT_DOWN:   agentUsbPtzWebCamTiltOff (dvPtzCam)
			case BTN_CAMERA_TILT_UP:     agentUsbPtzWebCamTiltOff (dvPtzCam)
		}
	}
}

button_event[dvTpTableDxlink,0]
{
	push:
	{
		// button feedback
		on[button.input]
		
		switch (button.input.channel)
		{
			// TX - Auto
			case BTN_DXLINK_TX_AUTO_1:   dxlinkEnableTxVideoInputAutoSelect (dvTxTable1Main)
			case BTN_DXLINK_TX_AUTO_2:   dxlinkEnableTxVideoInputAutoSelect (dvTxTable2Main)
			case BTN_DXLINK_TX_AUTO_3:   dxlinkEnableTxVideoInputAutoSelect (dvTxTable3Main)
			case BTN_DXLINK_TX_AUTO_4:   dxlinkEnableTxVideoInputAutoSelect (dvTxTable4Main)
			
			// TX - HDMI
			case BTN_DXLINK_TX_HDMI_1:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable1Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable1VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable1Main)
			}
			case BTN_DXLINK_TX_HDMI_2:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable2Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable2VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable2Main)
			}
			case BTN_DXLINK_TX_HDMI_3:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable3Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable3VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable3Main)
			}
			case BTN_DXLINK_TX_HDMI_4:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable4Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable4VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable4Main)
			}
			
			// TX - VGA
			case BTN_DXLINK_TX_VGA_1:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable1Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable1VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable1Main)
			}
			case BTN_DXLINK_TX_VGA_2:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable2Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable2VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable2Main)
			}
			case BTN_DXLINK_TX_VGA_3:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable3Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable3VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable3Main)
			}
			case BTN_DXLINK_TX_VGA_4:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable4Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable4VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable4Main)
			}
			
			// RX - Scaler Auto
			case BTN_DXLINK_RX_SCALER_AUTO_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_AUTO)
			}
			case BTN_DXLINK_RX_SCALER_AUTO_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_AUTO)
			}
			
			// RX - Scaler Bypass
			case BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_BYPASS)
			}
			case BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_BYPASS)
			}
			
			// RX - Scaler Manual
			case BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_MANUAL)
			}
			case BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_MANUAL)
			}
			
			// RX - Aspect Maintain
			case BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_MAINTAIN)
			}
			case BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_MAINTAIN)
			}
			
			// RX - Aspect Stretch
			case BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_STRETCH)
			}
			case BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_STRETCH)
			}
			
			// RX - Aspect Zoom
			case BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_ZOOM)
			}
			case BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_ZOOM)
			}
			
			// RX - Aspect Anamorphic
			case BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_ANAMORPHIC)
			}
			case BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_ANAMORPHIC)
			}
		}                                                                        
	}
}

button_event[dvTpTableDebug,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_DEBUG_REBUILD_EVENT_TABLE:
			{
				rebuild_event ()
				debugPrint ('**** Event Table Rebuilt ****')
			}
			case BTN_DEBUG_WAKE_ON_LAN_PC:
			{
				wakeOnLan (MAC_ADDRESS_PC)
			}
		}
	}
}

button_event[dvTpTableMain, 0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_MAIN_SHUT_DOWN:
			{
				shutdownAvSystem ()
			}
			
			case BTN_MAIN_SPLASH_SCREEN:
			{
				startMultiPreviewSnapshots ()
				
				// page flips done on the panel
			}
		}
	}
}



/*
 * --------------------
 * Level events
 * --------------------
 */

level_event[dvTpTableAudio, BTN_LVL_VOLUME_CONTROL]
{
	dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, level.value)
}



/*
 * --------------------
 * Timeline events
 * --------------------
 */

timeline_event[TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS]
{
	stack_var integer input
	local_var integer slotId
	local_var char dynamicImageName[30]
	
	input = timeline.sequence
	
	if (timelineTimesMultiPreviewSnapshots[input])
	{
		slotId = input
		dynamicImageName = "'MXA_PREVIEW_',itoa(slotId)"
		
		// Only take a snapshot if there is a valid signal status on the input
		if (dvx.videoInputs[slotId].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
		{
			dvxSwitchVideoOnly (dvDvxMain, slotId, dvDvxVidOutMultiPreview.port)
			
			WAIT waitTimeMplSnapShot 'WAIT_MULTI_PREVIEW_SNAPSHOT'   // wait just over half a second before taking the snapshot....allows the image time to lock on
			{
				moderoResourceForceRefreshPrefetchFromCache (dvTpTableVideo, dynamicImageName, MODERO_RESOURCE_NOTIFICATION_OFF)
				moderoSetButtonBitmapResource (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_LEFT_INPUT_SELECTION[slotId],MODERO_BUTTON_STATE_ALL,"'MXA_PREVIEW_',itoa(slotId)")
				moderoSetButtonBitmapResource (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION[slotId],MODERO_BUTTON_STATE_ALL,"'MXA_PREVIEW_',itoa(slotId)")
			}
		}
	}
}



/*
 * --------------------
 * Custom events
 * --------------------
 */


#warn 'BUG: amx-au-gc-boardroom-main - custom event for streaming status not triggering'

custom_event[dvTpTableMain,0,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
custom_event[dvTpTableVideo,0,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
custom_event[dvTpTableMain,1,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
custom_event[dvTpTableVideo,1,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
{
	debugPrint ("'custom_event[dvTpTableMain,1,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]'")
	debugPrint ("'custom.device = [',debugDevToString(custom.device),']'")
	debugPrint ("'custom.id = <>',itoa(custom.id)")
	debugPrint ("'custom.type = <>',itoa(custom.type)")
	debugPrint ("'custom.flag = <>',itoa(custom.flag)")
	debugPrint ("'custom.value1 = <>',itoa(custom.value1)")
	debugPrint ("'custom.value2 = <>',itoa(custom.value2)")
	debugPrint ("'custom.value3 = <>',itoa(custom.value3)")
	debugPrint ("'custom.text = "',custom.text,'"'")
	
	switch (custom.flag)
	{
		case 1:	// start
		{
			
		}
		case 2:	// stop
		{
			//startMultiPreviewSnapshots ()
		}
	}
}


data_event[dvTpTableMain]
{
	string:
	{
		// start taking snapshots of each input as soon as the video preview popup closes
		if (find_string(data.text, '@PPF-popup-video-preview',1) == 1)
		{
			// turn off the video being previewed flag
			isVideoBeingPreviewed = FALSE
			startMultiPreviewSnapshots ()
		}
	}
}


/*
 * --------------------
 * Listener includes
 * --------------------
 */

#include 'amx-dvx-listener'
#include 'amx-pdu-listener'
#include 'amx-dxlink-listener'
#include 'amx-modero-listener'
#include 'amx-controlports-listener'


/*
 * --------------------
 * Mainline
 * --------------------
 */
 
define_program

// Feedback for device online status
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_MASTER]                   = device_id(dvMaster)
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_CONTROLLER]               = device_id(dvDvxControllerMain)
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_SWITCHER]                 = device_id(dvDvxMain)
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_PDU]                      = device_id(dvPduMain1)
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_PANEL_TABLE]              = device_id(dvTpTableMain)
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_DXLINK_TX_1]              = device_id(dvTxTable1Main)
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_DXLINK_TX_2]              = device_id(dvTxTable2Main)
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_DXLINK_TX_3]              = device_id(dvTxTable3Main)
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_DXLINK_TX_4]              = device_id(dvTxTable4Main)
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_DXLINK_RX_MONITOR_LEFT]   = device_id(dvRxMonitorLeftMain)
[dvTpTableDeviceInfo, BTN_DEV_INFO_ONLINE_DXLINK_RX_MONITOR_RIGHT]  = device_id(dvRxMonitorRightMain)


// Feedback for video input selection buttons
[dvTpTableVideo, BTN_VIDEO_MONITOR_LEFT_INPUT_01_FEEDBACK]  = (selectedVideoInputMonitorLeft == dvdvxVidIn1.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_LEFT_INPUT_02_FEEDBACK]  = (selectedVideoInputMonitorLeft == dvdvxVidIn2.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_LEFT_INPUT_03_FEEDBACK]  = (selectedVideoInputMonitorLeft == dvdvxVidIn3.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_LEFT_INPUT_04_FEEDBACK]  = (selectedVideoInputMonitorLeft == dvdvxVidIn4.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_LEFT_INPUT_05_FEEDBACK]  = (selectedVideoInputMonitorLeft == dvdvxVidIn5.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_LEFT_INPUT_06_FEEDBACK]  = (selectedVideoInputMonitorLeft == dvdvxVidIn6.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_LEFT_INPUT_07_FEEDBACK]  = (selectedVideoInputMonitorLeft == dvdvxVidIn7.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_LEFT_INPUT_08_FEEDBACK]  = (selectedVideoInputMonitorLeft == dvdvxVidIn8.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_LEFT_INPUT_09_FEEDBACK]  = (selectedVideoInputMonitorLeft == dvdvxVidIn9.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_LEFT_INPUT_10_FEEDBACK]  = (selectedVideoInputMonitorLeft == dvdvxVidIn10.port)

[dvTpTableVideo, BTN_VIDEO_MONITOR_RIGHT_INPUT_01_FEEDBACK] = (selectedVideoInputMonitorRight == dvdvxVidIn1.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_RIGHT_INPUT_02_FEEDBACK] = (selectedVideoInputMonitorRight == dvdvxVidIn2.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_RIGHT_INPUT_03_FEEDBACK] = (selectedVideoInputMonitorRight == dvdvxVidIn3.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_RIGHT_INPUT_04_FEEDBACK] = (selectedVideoInputMonitorRight == dvdvxVidIn4.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_RIGHT_INPUT_05_FEEDBACK] = (selectedVideoInputMonitorRight == dvdvxVidIn5.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_RIGHT_INPUT_06_FEEDBACK] = (selectedVideoInputMonitorRight == dvdvxVidIn6.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_RIGHT_INPUT_07_FEEDBACK] = (selectedVideoInputMonitorRight == dvdvxVidIn7.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_RIGHT_INPUT_08_FEEDBACK] = (selectedVideoInputMonitorRight == dvdvxVidIn8.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_RIGHT_INPUT_09_FEEDBACK] = (selectedVideoInputMonitorRight == dvdvxVidIn9.port)
[dvTpTableVideo, BTN_VIDEO_MONITOR_RIGHT_INPUT_10_FEEDBACK] = (selectedVideoInputMonitorRight == dvdvxVidIn10.port)


// Feedback for audio-follow-video selection buttons
[dvTpTableAudio, BTN_AUDIO_FOLLOW_MONITOR_LEFT]     = (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port) AND selectedAudioInput
[dvTpTableAudio, BTN_AUDIO_FOLLOW_MONITOR_RIGHT]    = (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port) AND selectedAudioInput


// Feedback for occupancy detection button
[dvTpTableOccupancy, BTN_OCCUPANCY_DETECTED] = [dvDvxIos, IO_OCCUPANCY_SENSOR]


// Temp scale buttons
[dvTpTablePower,BTN_POWER_TEMPERATURE_SCALE_TOGGLE]     = [dvPduMain1,PDU_CHANNEL_TEMP_SCALE]
[dvTpTablePower,BTN_POWER_TEMPERATURE_SCALE_CELCIUS]    = ![dvPduMain1,PDU_CHANNEL_TEMP_SCALE]
[dvTpTablePower,BTN_POWER_TEMPERATURE_SCALE_FAHRENHEIT] = [dvPduMain1,PDU_CHANNEL_TEMP_SCALE]

/*
 * --------------------
 * END OF PROGRAM
 * 
 * DO NOT PUT ANY CODE BELOW THIS COMMENT
 * --------------------
 */
 

