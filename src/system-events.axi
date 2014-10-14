PROGRAM_NAME='system-events'

#if_not_defined __SYSTEM_EVENTS__
#define __SYSTEM_EVENTS__

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-functions'
#include 'system-library-api'
#include 'system-library-control'

#include 'debug'
#include 'wake-on-lan'


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
	string:
	{
		// start taking snapshots of each input as soon as the video preview popup closes
		if ( (find_string(data.text, '@PPF-popup-source-selection-drag-and-drop',1) == 1) or
		     (find_string(data.text, 'PPOF-popup-source-selection-drag-and-drop',1) == 1) )
		{
			// deactivate the source selection drag areas
			disableDragItemsAll (vdvDragAndDropTpTable)
			do_push(dvTpTableDebug,1)
		}
		
		if ( (find_string(data.text, '@PPN-popup-source-selection-drag-and-drop',1) == 1) or
		     (find_string(data.text, 'PPON-popup-source-selection-drag-and-drop',1) == 1) )
		{
			// activate the source selection drag areas
			enableDragItemsAll (vdvDragAndDropTpTable)
		}
		
		if ( (find_string(data.text, '@PPF-popup-source-control-background',1) == 1) or
		     (find_string(data.text, 'PPOF-popup-source-control-background',1) == 1) )
		{
			// activate the source selection drag areas
			enableDragItemsAll (vdvDragAndDropTpTable)
			sendCommand (vdvMultiPreview, 'SNAPSHOTS')
		}
		
		if ( (find_string(data.text, '@PPN-popup-source-control-background',1) == 1) or
		     (find_string(data.text, 'PPON-popup-source-control-background',1) == 1) )
		{
			// deactivate the source selection drag areas
			disableDragItemsAll (vdvDragAndDropTpTable)
		}
	}
}



data_event [vdvDragAndDropTpTable]
{
    online:
    {
		// Define drag/drop items - they will automatically be enabled by the module
		addDragItemsAll (vdvDragAndDropTpTable)
		addDropAreasAll (vdvDragAndDropTpTable)
		
		//if (getSystemMode() != SYSTEM_MODE_PRESENTATION)
		//	disableDropAreasAll (vdvDragAndDrop19)
    }
    string:
    {
		stack_var char header[50]
		
		header = remove_string (data.text,DELIM_HEADER,1)
		
		switch (header)
		{
			case 'DRAG_ITEM_SELECTED-':
			{
				enableDropItemsAll (vdvDragAndDropTpTable)
				
				animateTpVideoSourceSelectionOpen()
			}
			
			case 'DRAG_ITEM_DESELECTED-':
			{
				stack_var integer idDragItem
				
				idDragItem = atoi(data.text)
				
				// reset the draggable popup position by hiding it and then showing it again
				resetDraggablePopup (vdvDragAndDropTpTable, idDragItem)
				
				disableDropAreasAll (vdvDragAndDropTpTable)
			}
			
			case 'DRAG_ITEM_ENTER_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						channelOn (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_LEFT)
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						channelOn (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_RIGHT)
					}
				}
			}
			
			case 'DRAG_ITEM_EXIT_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						channelOff (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_LEFT)
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						channelOff (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_RIGHT)
					}
				}
			}
			
			case 'DRAG_ITEM_DROPPED_ON_DROP_AREA-':
			{
				local_var integer idDragItem
				local_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				disableDropAreasAll (vdvDragAndDropTpTable)
				
				resetDraggablePopup (vdvDragAndDropTpTable, idDragItem)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						
						if (dvx.videoInputs[idDragItem].status != DVX_SIGNAL_STATUS_VALID_SIGNAL)
						{
							moderoEnablePopup (dvTpTableVideo, POPUP_NAME_NO_SIGNAL_ARE_YOU_SURE)
							wait_until (userAcknowledgedSelectingInputWithNoSignal) 'WAITING_FOR_USER_TO_ACKNOWLEDGE_SENDING_NO_SIGNAL_INPUT_TO_MONITOR'
							{
								userAcknowledgedSelectingInputWithNoSignal = false
								sendSelectedInputToLeftMonitor (idDragItem, idDropArea)
							}
						}
						else
						{
							sendSelectedInputToLeftMonitor (idDragItem, idDropArea)
						}
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
					
						if (dvx.videoInputs[idDragItem].status != DVX_SIGNAL_STATUS_VALID_SIGNAL)
						{
							moderoEnablePopup (dvTpTableVideo, POPUP_NAME_NO_SIGNAL_ARE_YOU_SURE)
							wait_until (userAcknowledgedSelectingInputWithNoSignal) 'WAITING_FOR_USER_TO_ACKNOWLEDGE_SENDING_NO_SIGNAL_INPUT_TO_MONITOR'
							{
								userAcknowledgedSelectingInputWithNoSignal = false
								sendSelectedInputToRightMonitor (idDragItem, idDropArea)
							}
						}
						else
						{
							sendSelectedInputToRightMonitor (idDragItem, idDropArea)
						}
					}
					
					active (idDropArea == dvDvxVidOutMultiPreview.port):
					{
						showSourceOnDisplay (idDragItem, idDropArea)
						
						sendCommand (vdvMultiPreview, "'VIDEO_PREVIEW-',itoa(idDragItem)")
					}
				}
			}
			
			case 'DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME-': {}
		}
    }
}


data_event [dvTpTableVideo]
{
	online:
	{
		moderoEnableButtonScaleToFit (dvTpTableVideo, BTN_ADR_VIDEO_MONITOR_LEFT_PREVIEW_SNAPSHOT, MODERO_BUTTON_STATE_ALL)
		moderoEnableButtonScaleToFit (dvTpTableVideo, BTN_ADR_VIDEO_MONITOR_RIGHT_PREVIEW_SNAPSHOT, MODERO_BUTTON_STATE_ALL)
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
		
		// Panel
		moderoEnablePageTracking(dvTpTableMain)

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
			
			case BTN_USER_ACKNOWLEDGE_SEND_INPUT_NO_SIGNAL_TO_MONITOR_NO:
			{
				userAcknowledgedSelectingInputWithNoSignal = false
				cancel_wait 'WAITING_FOR_USER_TO_ACKNOWLEDGE_SENDING_NO_SIGNAL_INPUT_TO_MONITOR'
				channelOff (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_LEFT)
				channelOff (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_RIGHT)
			}
			
			case BTN_USER_ACKNOWLEDGE_SEND_INPUT_NO_SIGNAL_TO_MONITOR_YES:
			{
				userAcknowledgedSelectingInputWithNoSignal = true
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

#warn 'finish programming Enzo control button event'
button_event[dvTpTableEnzo,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_ENZO_HOME:						enzoHome (dvEnzo)
			case BTN_ENZO_BACK:						enzoBack (dvEnzo)
			case BTN_ENZO_ENTER:					enzoEnter (dvEnzo)
			case BTN_ENZO_START_SESSION:			enzoSessionStart (dvEnzo)
			case BTN_ENZO_END_SESSION:				enzoSessionEnd (dvEnzo)
			case BTN_ENZO_UP:						enzoUp (dvEnzo)
			case BTN_ENZO_DOWN:						enzoDown (dvEnzo)
			case BTN_ENZO_LEFT:						enzoLeft (dvEnzo)
			case BTN_ENZO_RIGHT:					enzoRight (dvEnzo)
			case BTN_ENZO_PLAY:						enzoPlay (dvEnzo)
			case BTN_ENZO_PAUSE:					enzoPause (dvEnzo)
			case BTN_ENZO_STOP:						enzoStop (dvEnzo)
			case BTN_ENZO_FFWD:						enzoFfwd (dvEnzo)
			case BTN_ENZO_REWIND:					enzoRewind (dvEnzo)
			case BTN_ENZO_PAGE_DOWN:				enzoPageDown (dvEnzo)
			case BTN_ENZO_PAGE_UP:					enzoPageUp (dvEnzo)
			case BTN_ENZO_PREVIOUS:					enzoPrevious(dvEnzo)
			case BTN_ENZO_NEXT:						enzoNext (dvEnzo)
			/*case BTN_ENZO_CLOSE_OPEN_APP:
			case BTN_ENZO_LAUNCH_APP_WEB_BROWSER:	
			case BTN_ENZO_LAUNCH_APP_DROPBOX:		
			case BTN_ENZO_LAUNCH_APP_MIRROR_OP:	*/
		}
	}
}


button_event[dvTpTableEnzoKeyboard,0]
{
	push:
	{
		
		switch (button.input.channel)
		{
			case BTN_KEYBOARD_SHIFT_LEFT:
			{
				keyboardStatusLeftShiftHeld = TRUE
				enableKeyboardShift (dvTpTableEnzoKeyboard)
			}
			
			case BTN_KEYBOARD_SHIFT_RIGHT:
			{
				keyboardStatusRightShiftHeld = TRUE
				enableKeyboardShift (dvTpTableEnzoKeyboard)
			}
			
			case BTN_KEYBOARD_CAPS_LOCK:
			{
				// toggle Caps lock
				keyboardStatusCapsLock = !keyboardStatusCapsLock
				
				if (keyboardStatusCapsLock)	// caps lock is now on
				{
					enableKeyboardCapsLock (dvTpTableEnzoKeyboard)
				}
				else	// caps lock is off
				{
					disableKeyboardCapsLock (dvTpTableEnzoKeyboard)
				}
			}
			
			case BTN_KEYBOARD_SPACE:        enzoKeystrokes(dvEnzo,' ')
			case BTN_KEYBOARD_TAB:          enzoKeystrokes(dvEnzo,"$09")
			case BTN_KEYBOARD_INSERT:       { }
			case BTN_KEYBOARD_ENTER:        enzoEnter(dvEnzo)
			case BTN_KEYBOARD_BACKSPACE:    enzoKeystrokes(dvEnzo,"$08")
			case BTN_KEYBOARD_DELETE:       enzoKeystrokes(dvEnzo,"$7F")
			
			
			case BTN_KEYBOARD_HOME:         enzoHome(dvEnzo)
			case BTN_KEYBOARD_END:          { }
			   // there is no "END" function for Enzo
			
			case BTN_KEYBOARD_CTRL_LEFT:    { }
			case BTN_KEYBOARD_CTRL_RIGHT:   { }
			
			case BTN_KEYBOARD_ALT_LEFT:     { }
			case BTN_KEYBOARD_ALT_RIGHT:    { }
			
			case BTN_KEYBOARD_ARROW_UP:      enzoUp(dvEnzo)
			case BTN_KEYBOARD_ARROW_DOWN:    enzoDown(dvEnzo)
			case BTN_KEYBOARD_ARROW_LEFT:    enzoLeft(dvEnzo)
			case BTN_KEYBOARD_ARROW_RIGHT:   enzoRight(dvEnzo)
			
			case BTN_KEYBOARD_PAGE_UP:       enzoPageUp(dvEnzo)
			case BTN_KEYBOARD_PAGE_DOWN:     enzoPageDown(dvEnzo)
		}
		
		if (keyboardStatusCapsLock == TRUE)	// caps lock enabled
		{
			switch (button.input.channel)
			{
				case BTN_KEYBOARD_A:                                 enzoKeystrokes(dvEnzo,'A')
				case BTN_KEYBOARD_B:                                 enzoKeystrokes(dvEnzo,'B')
				case BTN_KEYBOARD_C:                                 enzoKeystrokes(dvEnzo,'C')
				case BTN_KEYBOARD_D:                                 enzoKeystrokes(dvEnzo,'D')
				case BTN_KEYBOARD_E:                                 enzoKeystrokes(dvEnzo,'E')
				case BTN_KEYBOARD_F:                                 enzoKeystrokes(dvEnzo,'F')
				case BTN_KEYBOARD_G:                                 enzoKeystrokes(dvEnzo,'G')
				case BTN_KEYBOARD_H:                                 enzoKeystrokes(dvEnzo,'H')
				case BTN_KEYBOARD_I:                                 enzoKeystrokes(dvEnzo,'I')
				case BTN_KEYBOARD_J:                                 enzoKeystrokes(dvEnzo,'J')
				case BTN_KEYBOARD_K:                                 enzoKeystrokes(dvEnzo,'K')
				case BTN_KEYBOARD_L:                                 enzoKeystrokes(dvEnzo,'L')
				case BTN_KEYBOARD_M:                                 enzoKeystrokes(dvEnzo,'M')
				case BTN_KEYBOARD_N:                                 enzoKeystrokes(dvEnzo,'N')
				case BTN_KEYBOARD_O:                                 enzoKeystrokes(dvEnzo,'O')
				case BTN_KEYBOARD_P:                                 enzoKeystrokes(dvEnzo,'P')
				case BTN_KEYBOARD_Q:                                 enzoKeystrokes(dvEnzo,'Q')
				case BTN_KEYBOARD_R:                                 enzoKeystrokes(dvEnzo,'R')
				case BTN_KEYBOARD_S:                                 enzoKeystrokes(dvEnzo,'S')
				case BTN_KEYBOARD_T:                                 enzoKeystrokes(dvEnzo,'T')
				case BTN_KEYBOARD_U:                                 enzoKeystrokes(dvEnzo,'U')
				case BTN_KEYBOARD_V:                                 enzoKeystrokes(dvEnzo,'V')
				case BTN_KEYBOARD_W:                                 enzoKeystrokes(dvEnzo,'W')
				case BTN_KEYBOARD_X:                                 enzoKeystrokes(dvEnzo,'X')
				case BTN_KEYBOARD_Y:                                 enzoKeystrokes(dvEnzo,'Y')
				case BTN_KEYBOARD_Z:                                 enzoKeystrokes(dvEnzo,'Z')
			}
			
			if ((keyboardStatusLeftShiftHeld == TRUE) or (keyboardStatusRightShiftHeld == TRUE))	// shift key held down
			{
				switch (button.input.channel)
				{
					case BTN_KEYBOARD_1_EXCLAMATION_POINT:               enzoKeystrokes(dvEnzo,'!')
					case BTN_KEYBOARD_2_AT_SYMBOL:                       enzoKeystrokes(dvEnzo,'@')
					case BTN_KEYBOARD_3_NUMBER_SIGN:                     enzoKeystrokes(dvEnzo,'#')
					case BTN_KEYBOARD_4_DOLLAR_SIGN:                     enzoKeystrokes(dvEnzo,'$')
					case BTN_KEYBOARD_5_PERCENT_SIGN:                    enzoKeystrokes(dvEnzo,'%')
					case BTN_KEYBOARD_6_CARET:                           enzoKeystrokes(dvEnzo,'^')
					case BTN_KEYBOARD_7_AMPERSAND:                       enzoKeystrokes(dvEnzo,'&')
					case BTN_KEYBOARD_8_ASTERISK:                        enzoKeystrokes(dvEnzo,'*')
					case BTN_KEYBOARD_9_OPENING_PARENTHESIS:             enzoKeystrokes(dvEnzo,'(')
					case BTN_KEYBOARD_0_CLOSING_PARENTHESIS:             enzoKeystrokes(dvEnzo,')')
					case BTN_KEYBOARD_GRAVE_ACCENT_TILDE:                enzoKeystrokes(dvEnzo,'~')
					case BTN_KEYBOARD_MINUS_SIGN_UNDERSCORE:             enzoKeystrokes(dvEnzo,'_')
					case BTN_KEYBOARD_EQUAL_SIGN_PLUS_SIGN:              enzoKeystrokes(dvEnzo,'+')
					case BTN_KEYBOARD_OPENING_BRACKET_OPENING_BRACE:     enzoKeystrokes(dvEnzo,'{')
					case BTN_KEYBOARD_CLOSING_BRACKET_CLOSING_BRACE:     enzoKeystrokes(dvEnzo,'}')
					case BTN_KEYBOARD_BACKSLASH_VERTICAL_BAR:            enzoKeystrokes(dvEnzo,'|')
					case BTN_KEYBOARD_SEMICOLON_COLON:                   enzoKeystrokes(dvEnzo,':')
					case BTN_KEYBOARD_SINGLE_QUOTE_DOUBLE_QUOTE:         enzoKeystrokes(dvEnzo,'"')
					case BTN_KEYBOARD_COMMA_LESS_THAN_SIGN:              enzoKeystrokes(dvEnzo,'<')
					case BTN_KEYBOARD_FULLSTOP_GREATER_THAN_SIGN:        enzoKeystrokes(dvEnzo,'>')
					case BTN_KEYBOARD_SLASH_QUESTION_MARK:               enzoKeystrokes(dvEnzo,'?')
				}
			}
			else
			{
				switch (button.input.channel)
				{
					case BTN_KEYBOARD_1_EXCLAMATION_POINT:               enzoKeystrokes(dvEnzo,'1')
					case BTN_KEYBOARD_2_AT_SYMBOL:                       enzoKeystrokes(dvEnzo,'2')
					case BTN_KEYBOARD_3_NUMBER_SIGN:                     enzoKeystrokes(dvEnzo,'3')
					case BTN_KEYBOARD_4_DOLLAR_SIGN:                     enzoKeystrokes(dvEnzo,'4')
					case BTN_KEYBOARD_5_PERCENT_SIGN:                    enzoKeystrokes(dvEnzo,'5')
					case BTN_KEYBOARD_6_CARET:                           enzoKeystrokes(dvEnzo,'6')
					case BTN_KEYBOARD_7_AMPERSAND:                       enzoKeystrokes(dvEnzo,'7')
					case BTN_KEYBOARD_8_ASTERISK:                        enzoKeystrokes(dvEnzo,'8')
					case BTN_KEYBOARD_9_OPENING_PARENTHESIS:             enzoKeystrokes(dvEnzo,'9')
					case BTN_KEYBOARD_0_CLOSING_PARENTHESIS:             enzoKeystrokes(dvEnzo,'0')
					case BTN_KEYBOARD_GRAVE_ACCENT_TILDE:                enzoKeystrokes(dvEnzo,'`')
					case BTN_KEYBOARD_MINUS_SIGN_UNDERSCORE:             enzoKeystrokes(dvEnzo,'-')
					case BTN_KEYBOARD_EQUAL_SIGN_PLUS_SIGN:              enzoKeystrokes(dvEnzo,'=')
					case BTN_KEYBOARD_OPENING_BRACKET_OPENING_BRACE:     enzoKeystrokes(dvEnzo,'[')
					case BTN_KEYBOARD_CLOSING_BRACKET_CLOSING_BRACE:     enzoKeystrokes(dvEnzo,']')
					case BTN_KEYBOARD_BACKSLASH_VERTICAL_BAR:            enzoKeystrokes(dvEnzo,'\')
					case BTN_KEYBOARD_SEMICOLON_COLON:                   enzoKeystrokes(dvEnzo,';')
					case BTN_KEYBOARD_SINGLE_QUOTE_DOUBLE_QUOTE:         enzoKeystrokes(dvEnzo,"$27")
					case BTN_KEYBOARD_COMMA_LESS_THAN_SIGN:              enzoKeystrokes(dvEnzo,',')
					case BTN_KEYBOARD_FULLSTOP_GREATER_THAN_SIGN:        enzoKeystrokes(dvEnzo,'.')
					case BTN_KEYBOARD_SLASH_QUESTION_MARK:               enzoKeystrokes(dvEnzo,'/')
				}
			}
		}
		else // caps lock disabled
		{
			if ((keyboardStatusLeftShiftHeld == TRUE) or (keyboardStatusRightShiftHeld == TRUE))	// shift key held down
			{
				switch (button.input.channel)
				{
					case BTN_KEYBOARD_A:                                 enzoKeystrokes(dvEnzo,'A')
					case BTN_KEYBOARD_B:                                 enzoKeystrokes(dvEnzo,'B')
					case BTN_KEYBOARD_C:                                 enzoKeystrokes(dvEnzo,'C')
					case BTN_KEYBOARD_D:                                 enzoKeystrokes(dvEnzo,'D')
					case BTN_KEYBOARD_E:                                 enzoKeystrokes(dvEnzo,'E')
					case BTN_KEYBOARD_F:                                 enzoKeystrokes(dvEnzo,'F')
					case BTN_KEYBOARD_G:                                 enzoKeystrokes(dvEnzo,'G')
					case BTN_KEYBOARD_H:                                 enzoKeystrokes(dvEnzo,'H')
					case BTN_KEYBOARD_I:                                 enzoKeystrokes(dvEnzo,'I')
					case BTN_KEYBOARD_J:                                 enzoKeystrokes(dvEnzo,'J')
					case BTN_KEYBOARD_K:                                 enzoKeystrokes(dvEnzo,'K')
					case BTN_KEYBOARD_L:                                 enzoKeystrokes(dvEnzo,'L')
					case BTN_KEYBOARD_M:                                 enzoKeystrokes(dvEnzo,'M')
					case BTN_KEYBOARD_N:                                 enzoKeystrokes(dvEnzo,'N')
					case BTN_KEYBOARD_O:                                 enzoKeystrokes(dvEnzo,'O')
					case BTN_KEYBOARD_P:                                 enzoKeystrokes(dvEnzo,'P')
					case BTN_KEYBOARD_Q:                                 enzoKeystrokes(dvEnzo,'Q')
					case BTN_KEYBOARD_R:                                 enzoKeystrokes(dvEnzo,'R')
					case BTN_KEYBOARD_S:                                 enzoKeystrokes(dvEnzo,'S')
					case BTN_KEYBOARD_T:                                 enzoKeystrokes(dvEnzo,'T')
					case BTN_KEYBOARD_U:                                 enzoKeystrokes(dvEnzo,'U')
					case BTN_KEYBOARD_V:                                 enzoKeystrokes(dvEnzo,'V')
					case BTN_KEYBOARD_W:                                 enzoKeystrokes(dvEnzo,'W')
					case BTN_KEYBOARD_X:                                 enzoKeystrokes(dvEnzo,'X')
					case BTN_KEYBOARD_Y:                                 enzoKeystrokes(dvEnzo,'Y')
					case BTN_KEYBOARD_Z:                                 enzoKeystrokes(dvEnzo,'Z')
					case BTN_KEYBOARD_1_EXCLAMATION_POINT:               enzoKeystrokes(dvEnzo,'!')
					case BTN_KEYBOARD_2_AT_SYMBOL:                       enzoKeystrokes(dvEnzo,'@')
					case BTN_KEYBOARD_3_NUMBER_SIGN:                     enzoKeystrokes(dvEnzo,'#')
					case BTN_KEYBOARD_4_DOLLAR_SIGN:                     enzoKeystrokes(dvEnzo,'$')
					case BTN_KEYBOARD_5_PERCENT_SIGN:                    enzoKeystrokes(dvEnzo,'%')
					case BTN_KEYBOARD_6_CARET:                           enzoKeystrokes(dvEnzo,'^')
					case BTN_KEYBOARD_7_AMPERSAND:                       enzoKeystrokes(dvEnzo,'&')
					case BTN_KEYBOARD_8_ASTERISK:                        enzoKeystrokes(dvEnzo,'*')
					case BTN_KEYBOARD_9_OPENING_PARENTHESIS:             enzoKeystrokes(dvEnzo,'(')
					case BTN_KEYBOARD_0_CLOSING_PARENTHESIS:             enzoKeystrokes(dvEnzo,')')
					case BTN_KEYBOARD_GRAVE_ACCENT_TILDE:                enzoKeystrokes(dvEnzo,'~')
					case BTN_KEYBOARD_MINUS_SIGN_UNDERSCORE:             enzoKeystrokes(dvEnzo,'_')
					case BTN_KEYBOARD_EQUAL_SIGN_PLUS_SIGN:              enzoKeystrokes(dvEnzo,'+')
					case BTN_KEYBOARD_OPENING_BRACKET_OPENING_BRACE:     enzoKeystrokes(dvEnzo,'{')
					case BTN_KEYBOARD_CLOSING_BRACKET_CLOSING_BRACE:     enzoKeystrokes(dvEnzo,'}')
					case BTN_KEYBOARD_BACKSLASH_VERTICAL_BAR:            enzoKeystrokes(dvEnzo,'|')
					case BTN_KEYBOARD_SEMICOLON_COLON:                   enzoKeystrokes(dvEnzo,':')
					case BTN_KEYBOARD_SINGLE_QUOTE_DOUBLE_QUOTE:         enzoKeystrokes(dvEnzo,'"')
					case BTN_KEYBOARD_COMMA_LESS_THAN_SIGN:              enzoKeystrokes(dvEnzo,'<')
					case BTN_KEYBOARD_FULLSTOP_GREATER_THAN_SIGN:        enzoKeystrokes(dvEnzo,'>')
					case BTN_KEYBOARD_SLASH_QUESTION_MARK:               enzoKeystrokes(dvEnzo,'?')
				}
			}
			else	// shift key not held down
			{
				switch (button.input.channel)
				{
					case BTN_KEYBOARD_A:                                 enzoKeystrokes(dvEnzo,'a')
					case BTN_KEYBOARD_B:                                 enzoKeystrokes(dvEnzo,'b')
					case BTN_KEYBOARD_C:                                 enzoKeystrokes(dvEnzo,'c')
					case BTN_KEYBOARD_D:                                 enzoKeystrokes(dvEnzo,'d')
					case BTN_KEYBOARD_E:                                 enzoKeystrokes(dvEnzo,'e')
					case BTN_KEYBOARD_F:                                 enzoKeystrokes(dvEnzo,'f')
					case BTN_KEYBOARD_G:                                 enzoKeystrokes(dvEnzo,'g')
					case BTN_KEYBOARD_H:                                 enzoKeystrokes(dvEnzo,'h')
					case BTN_KEYBOARD_I:                                 enzoKeystrokes(dvEnzo,'i')
					case BTN_KEYBOARD_J:                                 enzoKeystrokes(dvEnzo,'j')
					case BTN_KEYBOARD_K:                                 enzoKeystrokes(dvEnzo,'k')
					case BTN_KEYBOARD_L:                                 enzoKeystrokes(dvEnzo,'l')
					case BTN_KEYBOARD_M:                                 enzoKeystrokes(dvEnzo,'m')
					case BTN_KEYBOARD_N:                                 enzoKeystrokes(dvEnzo,'n')
					case BTN_KEYBOARD_O:                                 enzoKeystrokes(dvEnzo,'o')
					case BTN_KEYBOARD_P:                                 enzoKeystrokes(dvEnzo,'p')
					case BTN_KEYBOARD_Q:                                 enzoKeystrokes(dvEnzo,'q')
					case BTN_KEYBOARD_R:                                 enzoKeystrokes(dvEnzo,'r')
					case BTN_KEYBOARD_S:                                 enzoKeystrokes(dvEnzo,'s')
					case BTN_KEYBOARD_T:                                 enzoKeystrokes(dvEnzo,'t')
					case BTN_KEYBOARD_U:                                 enzoKeystrokes(dvEnzo,'u')
					case BTN_KEYBOARD_V:                                 enzoKeystrokes(dvEnzo,'v')
					case BTN_KEYBOARD_W:                                 enzoKeystrokes(dvEnzo,'w')
					case BTN_KEYBOARD_X:                                 enzoKeystrokes(dvEnzo,'x')
					case BTN_KEYBOARD_Y:                                 enzoKeystrokes(dvEnzo,'y')
					case BTN_KEYBOARD_Z:                                 enzoKeystrokes(dvEnzo,'z')
					case BTN_KEYBOARD_1_EXCLAMATION_POINT:               enzoKeystrokes(dvEnzo,'1')
					case BTN_KEYBOARD_2_AT_SYMBOL:                       enzoKeystrokes(dvEnzo,'2')
					case BTN_KEYBOARD_3_NUMBER_SIGN:                     enzoKeystrokes(dvEnzo,'3')
					case BTN_KEYBOARD_4_DOLLAR_SIGN:                     enzoKeystrokes(dvEnzo,'4')
					case BTN_KEYBOARD_5_PERCENT_SIGN:                    enzoKeystrokes(dvEnzo,'5')
					case BTN_KEYBOARD_6_CARET:                           enzoKeystrokes(dvEnzo,'6')
					case BTN_KEYBOARD_7_AMPERSAND:                       enzoKeystrokes(dvEnzo,'7')
					case BTN_KEYBOARD_8_ASTERISK:                        enzoKeystrokes(dvEnzo,'8')
					case BTN_KEYBOARD_9_OPENING_PARENTHESIS:             enzoKeystrokes(dvEnzo,'9')
					case BTN_KEYBOARD_0_CLOSING_PARENTHESIS:             enzoKeystrokes(dvEnzo,'0')
					case BTN_KEYBOARD_GRAVE_ACCENT_TILDE:                enzoKeystrokes(dvEnzo,'`')
					case BTN_KEYBOARD_MINUS_SIGN_UNDERSCORE:             enzoKeystrokes(dvEnzo,'-')
					case BTN_KEYBOARD_EQUAL_SIGN_PLUS_SIGN:              enzoKeystrokes(dvEnzo,'=')
					case BTN_KEYBOARD_OPENING_BRACKET_OPENING_BRACE:     enzoKeystrokes(dvEnzo,'[')
					case BTN_KEYBOARD_CLOSING_BRACKET_CLOSING_BRACE:     enzoKeystrokes(dvEnzo,']')
					case BTN_KEYBOARD_BACKSLASH_VERTICAL_BAR:            enzoKeystrokes(dvEnzo,'\')
					case BTN_KEYBOARD_SEMICOLON_COLON:                   enzoKeystrokes(dvEnzo,';')
					case BTN_KEYBOARD_SINGLE_QUOTE_DOUBLE_QUOTE:         enzoKeystrokes(dvEnzo,"$27")
					case BTN_KEYBOARD_COMMA_LESS_THAN_SIGN:              enzoKeystrokes(dvEnzo,',')
					case BTN_KEYBOARD_FULLSTOP_GREATER_THAN_SIGN:        enzoKeystrokes(dvEnzo,'.')
					case BTN_KEYBOARD_SLASH_QUESTION_MARK:               enzoKeystrokes(dvEnzo,'/')
					
				}
			}
		}
		
		
		// feedback
		switch (button.input.channel)
		{
			case BTN_KEYBOARD_SHIFT_LEFT:
			case BTN_KEYBOARD_SHIFT_RIGHT:
			case BTN_KEYBOARD_SPACE:
			case BTN_KEYBOARD_TAB:
			case BTN_KEYBOARD_INSERT:
			case BTN_KEYBOARD_ENTER:
			case BTN_KEYBOARD_BACKSPACE:
			case BTN_KEYBOARD_DELETE:
			case BTN_KEYBOARD_HOME:
			case BTN_KEYBOARD_END:
			case BTN_KEYBOARD_CTRL_LEFT:
			case BTN_KEYBOARD_CTRL_RIGHT:
			case BTN_KEYBOARD_ALT_LEFT:
			case BTN_KEYBOARD_ALT_RIGHT:
			case BTN_KEYBOARD_ARROW_UP:
			case BTN_KEYBOARD_ARROW_DOWN:
			case BTN_KEYBOARD_ARROW_LEFT:
			case BTN_KEYBOARD_ARROW_RIGHT:
			case BTN_KEYBOARD_PAGE_UP:
			case BTN_KEYBOARD_PAGE_DOWN:
			{
				channelTo(button.input.device, button.input.channel)
			}
			
			case BTN_KEYBOARD_CAPS_LOCK:
			{
				channelSet(button.input.device, button.input.channel, keyboardStatusCapsLock)
			}
			
			
			case BTN_KEYBOARD_A:
			case BTN_KEYBOARD_B:
			case BTN_KEYBOARD_C:
			case BTN_KEYBOARD_D:
			case BTN_KEYBOARD_E:
			case BTN_KEYBOARD_F:
			case BTN_KEYBOARD_G:
			case BTN_KEYBOARD_H:
			case BTN_KEYBOARD_I:
			case BTN_KEYBOARD_J:
			case BTN_KEYBOARD_K:
			case BTN_KEYBOARD_L:
			case BTN_KEYBOARD_M:
			case BTN_KEYBOARD_N:
			case BTN_KEYBOARD_O:
			case BTN_KEYBOARD_P:
			case BTN_KEYBOARD_Q:
			case BTN_KEYBOARD_R:
			case BTN_KEYBOARD_S:
			case BTN_KEYBOARD_T:
			case BTN_KEYBOARD_U:
			case BTN_KEYBOARD_V:
			case BTN_KEYBOARD_W:
			case BTN_KEYBOARD_X:
			case BTN_KEYBOARD_Y:
			case BTN_KEYBOARD_Z:
			{
				if (keyboardStatusCapsLock == TRUE)
				{
					moderoEnableButtonAnimate (button.input.device, button.input.channel, 0, 4, 0)
				}
				else
				{
					if ((keyboardStatusLeftShiftHeld == TRUE) or (keyboardStatusRightShiftHeld == TRUE))
					{
						moderoEnableButtonAnimate (button.input.device, button.input.channel, 0, 4, 0)
					}
					else
					{
						moderoEnableButtonAnimate (button.input.device, button.input.channel, 0, 2, 0)
					}
				}
			}
			
			case BTN_KEYBOARD_1_EXCLAMATION_POINT:
			case BTN_KEYBOARD_2_AT_SYMBOL:
			case BTN_KEYBOARD_3_NUMBER_SIGN:
			case BTN_KEYBOARD_4_DOLLAR_SIGN:
			case BTN_KEYBOARD_5_PERCENT_SIGN:
			case BTN_KEYBOARD_6_CARET:
			case BTN_KEYBOARD_7_AMPERSAND:
			case BTN_KEYBOARD_8_ASTERISK:
			case BTN_KEYBOARD_9_OPENING_PARENTHESIS:
			case BTN_KEYBOARD_0_CLOSING_PARENTHESIS:
			case BTN_KEYBOARD_GRAVE_ACCENT_TILDE:
			case BTN_KEYBOARD_MINUS_SIGN_UNDERSCORE:
			case BTN_KEYBOARD_EQUAL_SIGN_PLUS_SIGN:
			case BTN_KEYBOARD_OPENING_BRACKET_OPENING_BRACE:
			case BTN_KEYBOARD_CLOSING_BRACKET_CLOSING_BRACE:
			case BTN_KEYBOARD_BACKSLASH_VERTICAL_BAR:
			case BTN_KEYBOARD_SEMICOLON_COLON:
			case BTN_KEYBOARD_SINGLE_QUOTE_DOUBLE_QUOTE:
			case BTN_KEYBOARD_COMMA_LESS_THAN_SIGN:
			case BTN_KEYBOARD_FULLSTOP_GREATER_THAN_SIGN:
			case BTN_KEYBOARD_SLASH_QUESTION_MARK:
			{
				if ((keyboardStatusLeftShiftHeld == TRUE) or (keyboardStatusRightShiftHeld == TRUE))
				{
					moderoEnableButtonAnimate (button.input.device, button.input.channel, 0, 4, 0)
				}
				else
				{
					moderoEnableButtonAnimate (button.input.device, button.input.channel, 0, 2, 0)
				}
			}
			
		}
	}
	release:
	{
		
		switch (button.input.channel)
		{
			case BTN_KEYBOARD_SHIFT_LEFT:
			{
				keyboardStatusLeftShiftHeld = FALSE
				
				if (keyboardStatusRightShiftHeld == FALSE)
				{
					disableKeyboardShift (dvTpTableEnzoKeyboard, keyboardStatusCapsLock)
				}
			}
			
			case BTN_KEYBOARD_SHIFT_RIGHT:
			{
				keyboardStatusRightShiftHeld = FALSE
				
				if (keyboardStatusLeftShiftHeld == FALSE)
				{
					disableKeyboardShift (dvTpTableEnzoKeyboard, keyboardStatusCapsLock)
				}
			}
		}
		
		
		// feedback
		switch (button.input.channel)
		{
			case BTN_KEYBOARD_A:
			case BTN_KEYBOARD_B:
			case BTN_KEYBOARD_C:
			case BTN_KEYBOARD_D:
			case BTN_KEYBOARD_E:
			case BTN_KEYBOARD_F:
			case BTN_KEYBOARD_G:
			case BTN_KEYBOARD_H:
			case BTN_KEYBOARD_I:
			case BTN_KEYBOARD_J:
			case BTN_KEYBOARD_K:
			case BTN_KEYBOARD_L:
			case BTN_KEYBOARD_M:
			case BTN_KEYBOARD_N:
			case BTN_KEYBOARD_O:
			case BTN_KEYBOARD_P:
			case BTN_KEYBOARD_Q:
			case BTN_KEYBOARD_R:
			case BTN_KEYBOARD_S:
			case BTN_KEYBOARD_T:
			case BTN_KEYBOARD_U:
			case BTN_KEYBOARD_V:
			case BTN_KEYBOARD_W:
			case BTN_KEYBOARD_X:
			case BTN_KEYBOARD_Y:
			case BTN_KEYBOARD_Z:
			{
				if (keyboardStatusCapsLock == TRUE)
				{
					moderoEnableButtonAnimate (button.input.device, button.input.channel, 0, 3, 0)
				}
				else
				{
					if ((keyboardStatusLeftShiftHeld == TRUE) or (keyboardStatusRightShiftHeld == TRUE))
					{
						moderoEnableButtonAnimate (button.input.device, button.input.channel, 0, 3, 0)
					}
					else
					{
						moderoEnableButtonAnimate (button.input.device, button.input.channel, 0, 1, 0)
					}
				}
			}
			
			case BTN_KEYBOARD_1_EXCLAMATION_POINT:
			case BTN_KEYBOARD_2_AT_SYMBOL:
			case BTN_KEYBOARD_3_NUMBER_SIGN:
			case BTN_KEYBOARD_4_DOLLAR_SIGN:
			case BTN_KEYBOARD_5_PERCENT_SIGN:
			case BTN_KEYBOARD_6_CARET:
			case BTN_KEYBOARD_7_AMPERSAND:
			case BTN_KEYBOARD_8_ASTERISK:
			case BTN_KEYBOARD_9_OPENING_PARENTHESIS:
			case BTN_KEYBOARD_0_CLOSING_PARENTHESIS:
			case BTN_KEYBOARD_GRAVE_ACCENT_TILDE:
			case BTN_KEYBOARD_MINUS_SIGN_UNDERSCORE:
			case BTN_KEYBOARD_EQUAL_SIGN_PLUS_SIGN:
			case BTN_KEYBOARD_OPENING_BRACKET_OPENING_BRACE:
			case BTN_KEYBOARD_CLOSING_BRACKET_CLOSING_BRACE:
			case BTN_KEYBOARD_BACKSLASH_VERTICAL_BAR:
			case BTN_KEYBOARD_SEMICOLON_COLON:
			case BTN_KEYBOARD_SINGLE_QUOTE_DOUBLE_QUOTE:
			case BTN_KEYBOARD_COMMA_LESS_THAN_SIGN:
			case BTN_KEYBOARD_FULLSTOP_GREATER_THAN_SIGN:
			case BTN_KEYBOARD_SLASH_QUESTION_MARK:
			{
				if ((keyboardStatusLeftShiftHeld == TRUE) or (keyboardStatusRightShiftHeld == TRUE))
				{
					moderoEnableButtonAnimate (button.input.device, button.input.channel, 0, 3, 0)
				}
				else
				{
					moderoEnableButtonAnimate (button.input.device, button.input.channel, 0, 1, 0)
				}
			}
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
				// page flips done on the panel
			}
		}
	}
}

button_event [dvTpTableDebug, 1]	// exit monitor selection animation
{
    push:
    {
		animateTpVideoSourceSelectionClose()
		
		sendCommand (vdvMultiPreview, "'SNAPSHOTS'")
    }
}

button_event [dvTpTableDebug, 2]	// select left monitor
button_event [dvTpTableDebug, 3]	// select right monitor
{
    push:
    {
		stack_var integer input
		
		switch (button.input.channel)
		{
			case 2:		showSourceControlPopup (selectedVideoInputMonitorLeft)
			
			case 3:		showSourceControlPopup (selectedVideoInputMonitorRight)
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


/*
 * --------------------
 * Custom events
 * --------------------
 */




#end_if