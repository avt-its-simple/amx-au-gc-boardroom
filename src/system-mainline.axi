PROGRAM_NAME='system-mainline'

#if_not_defined __SYSTEM_MAINLINE__
#define __SYSTEM_MAINLINE__

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-functions'
#include 'system-library-api'
#include 'system-library-control'


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

// Feedback for audio-follow-video selection buttons
[dvTpTableAudio, BTN_AUDIO_FOLLOW_MONITOR_LEFT]     = (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port) AND selectedAudioInput
[dvTpTableAudio, BTN_AUDIO_FOLLOW_MONITOR_RIGHT]    = (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port) AND selectedAudioInput


// Feedback for occupancy detection button
[dvTpTableOccupancy, BTN_OCCUPANCY_DETECTED] = [dvDvxIos, IO_OCCUPANCY_SENSOR]

// Temp scale buttons
[dvTpTablePower,BTN_POWER_TEMPERATURE_SCALE_TOGGLE]     = [dvPduMain1,PDU_CHANNEL_TEMP_SCALE]
[dvTpTablePower,BTN_POWER_TEMPERATURE_SCALE_CELCIUS]    = ![dvPduMain1,PDU_CHANNEL_TEMP_SCALE]
[dvTpTablePower,BTN_POWER_TEMPERATURE_SCALE_FAHRENHEIT] = [dvPduMain1,PDU_CHANNEL_TEMP_SCALE]


#end_if