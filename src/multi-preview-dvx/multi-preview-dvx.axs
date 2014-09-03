module_name='multi-preview-dvx' (dev virtual,
								 dev dvDvxVidOutMultiPreview, 
                                 dev dvTpSnapshotPreview, 
								 integer btnsVideoInputSnapshotPreviews[],     // address codes
								 integer btnAdrsVideoInputSnapshotPreviews[],  // address codes
								 integer btnAdrsVideoInputLabels[],            // address codes
								 integer btnAdrsVideoOutputSnapshotPreviews[], // address codes
								 integer btnAdrsVideoOutputPreviewLabels[],    // address codes
								 integer btnAdrVideoPreviewLoadingMessage,     // address code
								 integer btnLoadingBarMultiState,              // channel code
								 integer btnAdrLoadingBar,                     // address code
								 integer btnAdrVideoPreviewWindow,             // address code
								 integer btnExitVideoPreview,                  // channel code
								 char popupNameVideoPreview[],
								 char imageFileNameNoVideo[])

#include 'common'
#include 'amx-device-control'
#include 'amx-dvx-api'
#include 'amx-dvx-control'
#include 'amx-modero-api'
#include 'amx-modero-control'
#include 'debug'



define_constant

integer MODE_NONE = 0
integer MODE_SNAPSHOTS = 1
integer MODE_SNAPSHOTS_INPUT_X = 2
integer MODE_VIDEO_PREVIEW = 3

char DYNAMIC_IMAGE_NAME_HEADER[30] = 'MXA_PREVIEW_'


define_variable

long timelineTimesMultiPreviewSnapshots[DVX_MAX_VIDEO_INPUTS]
long timelineTimeMplBetweenSwitches = 1000

integer waitTimeVideoPreview = 5
integer waitTimeVideoLoading = 20
integer waitTimeMplSnapShot  = 10
integer waitTimeSwitchToNextInputAfterSnapshot = 20
integer waitTimeUntilNextSwitch = 20

volatile integer inputForVideoPreview = DVX_PORT_VID_IN_NONE
volatile integer inputForSingleInputSnapshots = DVX_PORT_VID_IN_NONE

volatile integer mode = MODE_SNAPSHOTS

volatile _DvxSwitcher dvx

volatile integer inputToSwitchTo = DVX_PORT_VID_IN_NONE

volatile char currentPreviewButtonBitmap[DVX_MAX_VIDEO_INPUTS][30]

// Modero Listener Dev Array for Listening to button events
dev dvPanelsButtons[1]


dev dvTpPort1


// DVX Main Switcher Port
dev dvDvxSwitcher

// Override the dvx switcher input listener dev array from amx-dvx-listener
dev dvDvxMainPorts[1]

// Override the dvx video input listener dev array from amx-dvx-listener
dev dvDvxVidInPorts[DVX_MAX_VIDEO_INPUTS]



define_function setFlag (integer flag, integer boolean)
{
	flag = boolean
}

define_function integer getFlag (integer flag)
{
	return flag
}



define_function initDevice (dev device, integer number, integer port, integer system)
{
	device.number = number
	device.port = port
	device.system = system
}

define_function addDeviceToDevArray (dev deviceArray[], dev device)
{
	if (length_array(deviceArray) < max_length_array(deviceArray))
	{
		set_length_array (deviceArray, (length_array(deviceArray)+1))
		deviceArray[length_array(deviceArray)] = device
	}
}

define_function integer anyValidInputs ()
{
	stack_var integer input
	
	for (input = 1; input <= DVX_MAX_VIDEO_INPUTS; input++)
	{
		if (dvx.videoInputs[input].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
			return TRUE
	}
	
	return FALSE
}

define_function switchToNextInput()
{
	stack_var integer i
	
	if (anyValidInputs ()) 
	{
		// set up dvx input to start from
		if (inputToSwitchTo == DVX_PORT_VID_IN_NONE)
		{
			inputToSwitchTo = 1	// seed
		}
		
		for (i = inputToSwitchTo; i < inputToSwitchTo + DVX_MAX_VIDEO_INPUTS - 1; i++)
		{
			if (dvx.videoInputs[((i % DVX_MAX_VIDEO_INPUTS) + 1)].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
			{
				inputToSwitchTo = ((i % DVX_MAX_VIDEO_INPUTS) + 1)
				break	// exit the for loop
			}
		}
		
		moderoRequestButtonBitmapName (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[inputToSwitchTo], MODERO_BUTTON_STATE_OFF)
		
		// only switch if we actually need to
		if (inputToSwitchTo != dvx.switchStatusVideoOutputs[dvDvxVidOutMultiPreview.port])
		{
			dvxSwitchVideoOnly (dvDvxSwitcher, inputToSwitchTo, dvDvxVidOutMultiPreview.port)
		}
		else
		{
			takeSnapshot ()
		}
	}
	else
	{
		wait waitTimeUntilNextSwitch 'WAITING_FOR_ANY_VALID_SIGNALS'
		{
			switchToNextInput()
		}
	}
}

define_function takeSnapshotSingle ()
{
	stack_var char dynamicImageName[30]
	stack_var integer output
	stack_var integer input
	
	input = inputForSingleInputSnapshots
	
	select
	{
		active (dvx.videoInputs[input].status == DVX_SIGNAL_STATUS_VALID_SIGNAL):
		{
			dynamicImageName = "DYNAMIC_IMAGE_NAME_HEADER,itoa(input)"
			
			moderoEnableResourceReloadOnView (dvTpSnapshotPreview, dynamicImageName)
			
			moderoResourceForceRefreshPrefetchFromCache (dvTpSnapshotPreview, dynamicImageName, MODERO_RESOURCE_NOTIFICATION_OFF)
			
			moderoDisableResourceReloadOnView (dvTpSnapshotPreview, dynamicImageName)
			
			moderoSetButtonBitmapResource (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[input],MODERO_BUTTON_STATE_ALL,dynamicImageName)
			
			for (output = 1; output <= DVX_MAX_VIDEO_OUTPUTS; output++)
			{
				if (dvx.switchStatusVideoOutputs[output] == input)
				{
					moderoButtonCopyAttribute (dvTpSnapshotPreview,
											   dvTpSnapshotPreview.port,
											   btnAdrsVideoInputSnapshotPreviews[input],
											   MODERO_BUTTON_STATE_OFF,
											   btnAdrsVideoOutputSnapshotPreviews[output],
											   MODERO_BUTTON_STATE_ALL,
											   MODERO_BUTTON_ATTRIBUTE_BITMAP)
				}
			}
		}
		active (1):
		{
			moderoSetButtonBitmap (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[input], MODERO_BUTTON_STATE_ALL, imageFileNameNoVideo)
		}
	}
	
	wait waitTimeMplSnapShot 'WAITING_TO_TAKE_SNAPSHOT'
	takeSnapshotSingle ()
}

define_function takeSnapshot ()
{
	stack_var char dynamicImageName[30]
	stack_var integer output
	stack_var integer input
	
	input = dvx.switchStatusVideoOutputs[dvDvxVidOutMultiPreview.port]
	
	select
	{
		active (dvx.videoInputs[input].status == DVX_SIGNAL_STATUS_VALID_SIGNAL):
		{
			dynamicImageName = "DYNAMIC_IMAGE_NAME_HEADER,itoa(input)"
			
			moderoEnableResourceReloadOnView (dvTpSnapshotPreview, dynamicImageName)
			
			moderoResourceForceRefreshPrefetchFromCache (dvTpSnapshotPreview, dynamicImageName, MODERO_RESOURCE_NOTIFICATION_OFF)
			
			moderoDisableResourceReloadOnView (dvTpSnapshotPreview, dynamicImageName)
			
			moderoSetButtonBitmapResource (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[input],MODERO_BUTTON_STATE_ALL,dynamicImageName)
			
			for (output = 1; output <= DVX_MAX_VIDEO_OUTPUTS; output++)
			{
				if (dvx.switchStatusVideoOutputs[output] == input)
				{
					moderoButtonCopyAttribute (dvTpSnapshotPreview,
											   dvTpSnapshotPreview.port,
											   btnAdrsVideoInputSnapshotPreviews[input],
											   MODERO_BUTTON_STATE_OFF,
											   btnAdrsVideoOutputSnapshotPreviews[output],
											   MODERO_BUTTON_STATE_ALL,
											   MODERO_BUTTON_ATTRIBUTE_BITMAP)
				}
			}
		}
		active (1):
		{
			send_string 0, "'DEBUG[File ',__FILE__,', Line ',itoa(__LINE__),'] - load "no video" image for input #',itoa(input)"
			moderoSetButtonBitmap (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[input], MODERO_BUTTON_STATE_ALL, imageFileNameNoVideo)
			
			for (output = 1; output <= DVX_MAX_VIDEO_OUTPUTS; output++)
			{
				if (dvx.switchStatusVideoOutputs[output] == input)
				{
					send_string 0, "'DEBUG[File ',__FILE__,', Line ',itoa(__LINE__),'] - load "no video" image for output #',itoa(output)"
					moderoSetButtonBitmap (dvTpSnapshotPreview, btnAdrsVideoOutputSnapshotPreviews[output], MODERO_BUTTON_STATE_ALL, imageFileNameNoVideo)
				}
			}
		}
	}
	
	wait waitTimeSwitchToNextInputAfterSnapshot 'WAITING_TO_SWITCH_TO_NEXT_INPUT'
	switchToNextInput()
}

define_function startMultiPreviewSnapshots ()
{
	dvxRequestVideoInputStatusAll (dvDvxSwitcher)
	dvxRequestVideoInputNameAll (dvDvxSwitcher)
	dvxRequestInputVideo (dvDvxSwitcher, dvDvxVidOutMultiPreview.port)	// pretty sure the dvxNotifySwitch command gets called
}

define_function startSinglePreviewSnapshots ()
{
	cancel_wait 'WAITING_TO_TAKE_SNAPSHOT'
	cancel_wait 'WAITING_TO_SWITCH_TO_NEXT_INPUT'
	cancel_wait 'WAITING_FOR_ANY_VALID_SIGNALS'
	
	dvxRequestVideoInputStatus (dvDvxVidInPorts[inputForSingleInputSnapshots])
	dvxRequestVideoInputName (dvDvxVidInPorts[inputForSingleInputSnapshots])
	
	if (dvx.switchStatusVideoOutputs[dvDvxVidOutMultiPreview.port] != inputForSingleInputSnapshots)
	{
		dvxSwitchVideoOnly (dvDvxSwitcher, inputForSingleInputSnapshots, dvDvxVidOutMultiPreview.port)
	}
	else
	{
		dvxRequestInputVideo (dvDvxSwitcher, dvDvxVidOutMultiPreview.port)	// pretty sure the dvxNotifySwitch command gets called
	}
}


define_function stopLiveVideoPreview ()
{
	cancel_wait 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	moderoSetButtonHide (dvTpSnapshotPreview, btnAdrVideoPreviewLoadingMessage)
	moderoSetButtonHide (dvTpSnapshotPreview, btnAdrLoadingBar)
}

define_function startLiveVideoPreview (integer input)
{
	// turn on the video being previed flag
	
	cancel_wait 'WAITING_TO_TAKE_SNAPSHOT'
	cancel_wait 'WAITING_TO_SWITCH_TO_NEXT_INPUT'
	cancel_wait 'WAITING_FOR_ANY_VALID_SIGNALS'
	
	// delete video snapshot on the video preview button
	moderoDeleteButtonVideoSnapshot (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL)
	
	moderoDisableButtonFeedback (dvTpSnapshotPreview, btnLoadingBarMultiState)    // reset the loading progress bar
	
	moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
	moderoSetButtonShow (dvTpSnapshotPreview, btnAdrVideoPreviewLoadingMessage)
	moderoSetButtonShow (dvTpSnapshotPreview, btnAdrLoadingBar)
	
	moderoEnableButtonFeedback (dvTpSnapshotPreview, btnLoadingBarMultiState) //start the loading progress bar
	
	dvxSwitchVideoOnly (dvDvxSwitcher, input, dvDvxVidOutMultiPreview.port)
	
	cancel_wait 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	wait waitTimeVideoLoading 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	{
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrVideoPreviewLoadingMessage)
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrLoadingBar)
		moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_OPAQUE)
	}
	
}


define_function changeMode (integer newMode)
{
	switch (newMode)
	{
		case MODE_NONE:
		{
			setFlag (mode, MODE_NONE)
		}
		
		case MODE_SNAPSHOTS:
		{
			setFlag (mode, MODE_SNAPSHOTS)
			
			// delete video snapshot on the video preview button
			moderoDeleteButtonVideoSnapshot (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL)
			moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
			stopLiveVideoPreview ()
			startMultiPreviewSnapshots ()
		}
		
		case MODE_SNAPSHOTS_INPUT_X:
		{
			setFlag (mode, MODE_SNAPSHOTS_INPUT_X)
			
			// delete video snapshot on the video preview button
			moderoDeleteButtonVideoSnapshot (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL)
			moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
			stopLiveVideoPreview ()
			startSinglePreviewSnapshots ()
		}
		
		case MODE_VIDEO_PREVIEW:
		{
			setFlag (mode, MODE_VIDEO_PREVIEW)
			
			startLiveVideoPreview (inputForVideoPreview)
		}
	}
}


#define INCLUDE_DVX_NOTIFY_SWITCH_CALLBACK
define_function dvxNotifySwitch (dev dvxPort1, char signalType[], integer input, integer output)
{
	// dvxPort1 is port 1 on the DVX.
	// signalType contains the type of signal that was switched ('AUDIO' or 'VIDEO')
	// input contains the source input number that was switched to the destination
	// output contains the destination output number that the source was switched to
	
	if (signalType == SIGNAL_TYPE_VIDEO)
	{
		//dvx.switchStatusVideoOutputs[dvDvxVidOutMultiPreview.port] = input	// replaced with next line
		dvx.switchStatusVideoOutputs[output] = input
		
		
		if (output == dvDvxVidOutMultiPreview.port)
		{
			if (mode == MODE_SNAPSHOTS)
			{
				cancel_wait 'WAITING_FOR_ANY_VALID_SIGNALS'
				cancel_wait 'WAITING_TO_SWITCH_TO_NEXT_INPUT'
				cancel_wait 'WAITING_TO_TAKE_SNAPSHOT'
				wait waitTimeMplSnapShot 'WAITING_TO_TAKE_SNAPSHOT'
				{
					takeSnapshot ()
				}
			}
			
			if (mode == MODE_SNAPSHOTS_INPUT_X)
			{
				cancel_wait 'WAITING_FOR_ANY_VALID_SIGNALS'
				cancel_wait 'WAITING_TO_SWITCH_TO_NEXT_INPUT'
				cancel_wait 'WAITING_TO_TAKE_SNAPSHOT'
				wait waitTimeMplSnapShot 'WAITING_TO_TAKE_SNAPSHOT'
				{
					takeSnapshotSingle ()
				}
			}
		}
		else
		{
			
			if (input == DVX_PORT_VID_IN_NONE)
			{
				//send_string 0, "'DEBUG[File ',__FILE__,', Line ',itoa(__LINE__),'] - load "no video" image for output #',itoa(output)"
				moderoSetButtonBitmap (dvTpSnapshotPreview, btnAdrsVideoOutputSnapshotPreviews[output], MODERO_BUTTON_STATE_ALL, imageFileNameNoVideo)
				moderoSetButtonText (dvTpSnapshotPreview, btnAdrsVideoOutputPreviewLabels[output], MODERO_BUTTON_STATE_ALL, '')
			}
			else
			{
				//send_string 0, "'DEBUG[File ',__FILE__,', Line ',itoa(__LINE__),'] - btnAdrsVideoInputSnapshotPreviews[input] #',itoa(btnAdrsVideoInputSnapshotPreviews[input])"
				//send_string 0, "'DEBUG[File ',__FILE__,', Line ',itoa(__LINE__),'] - btnAdrsVideoOutputSnapshotPreviews[output] #',itoa(btnAdrsVideoOutputSnapshotPreviews[output])"
				
				
				moderoButtonCopyAttribute (dvTpSnapshotPreview, 
										   dvTpSnapshotPreview.port, 
										   btnAdrsVideoInputSnapshotPreviews[input], 
										   MODERO_BUTTON_STATE_OFF,
										   btnAdrsVideoOutputSnapshotPreviews[output], 
										   MODERO_BUTTON_STATE_ALL,
										   MODERO_BUTTON_ATTRIBUTE_BITMAP)
				
				
				//send_string 0, "'DEBUG[File ',__FILE__,', Line ',itoa(__LINE__),'] - btnAdrsVideoInputLabels[input] #',itoa(btnAdrsVideoInputLabels[input])"
				//send_string 0, "'DEBUG[File ',__FILE__,', Line ',itoa(__LINE__),'] - btnAdrsVideoOutputPreviewLabels[output] #',itoa(btnAdrsVideoOutputPreviewLabels[output])"
				
				moderoButtonCopyAttribute (dvTpSnapshotPreview, 
										   dvTpSnapshotPreview.port, 
										   btnAdrsVideoInputLabels[input], 
										   MODERO_BUTTON_STATE_OFF,
										   btnAdrsVideoOutputPreviewLabels[output], 
										   MODERO_BUTTON_STATE_ALL,
										   MODERO_BUTTON_ATTRIBUTE_TEXT)
				
			}
		}
	}
}


#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	stack_var char oldSignalStatus[50]
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)
	
	oldSignalStatus = dvx.videoInputs[dvxVideoInput.port].status
	dvx.videoInputs[dvxVideoInput.port].status = signalStatus
	
	if (mode == MODE_SNAPSHOTS)
	{
		switch (signalStatus)
		{
			case DVX_SIGNAL_STATUS_NO_SIGNAL:
			case DVX_SIGNAL_STATUS_UNKNOWN:
			{
				stack_var integer output
				
				send_string 0, "'DEBUG[File ',__FILE__,', Line ',itoa(__LINE__),'] - load "no video" image for input #',itoa(dvxVideoInput.port)"
				moderoSetButtonBitmap (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL,imageFileNameNoVideo)
				
				for (output = 1; output <= DVX_MAX_VIDEO_OUTPUTS; output++)
				{
					if (dvx.switchStatusVideoOutputs[output] == dvxVideoInput.port)
					{
						moderoButtonCopyAttribute (dvTpSnapshotPreview, 
												   dvTpSnapshotPreview.port, 
												   btnAdrsVideoInputSnapshotPreviews[dvxVideoInput.port], 
												   MODERO_BUTTON_STATE_OFF,
												   btnAdrsVideoOutputSnapshotPreviews[output], 
												   MODERO_BUTTON_STATE_ALL,
												   MODERO_BUTTON_ATTRIBUTE_BITMAP)
					}
				}
			}
			case DVX_SIGNAL_STATUS_VALID_SIGNAL:
			{
				// check that we didn't previously have a valid signal
				if (oldSignalStatus != signalStatus)
				{
					if (dvxVideoInput.port != dvx.switchStatusVideoOutputs[dvDvxVidOutMultiPreview.port])
					{
						cancel_wait 'WAITING_TO_TAKE_SNAPSHOT'
						cancel_wait 'WAITING_TO_SWITCH_TO_NEXT_INPUT'
						cancel_wait 'WAITING_FOR_ANY_VALID_SIGNALS'
						dvxSwitchVideoOnly (dvDvxSwitcher, dvxVideoInput.port, dvDvxVidOutMultiPreview.port)
					}
				}
			}
		}
	}
}

#define INCLUDE_MODERO_NOTIFY_BUTTON_BITMAP_NAME
define_function moderoNotifyButtonBitmapName (dev panel, integer btnAdrCde, integer nbtnState, char bitmapName[])
{
	// panel is the touch panel
	// btnAdrCde is the button address code
	// btnState is the button state
	// bitmapName is the name of the image assigned to the button
	
	if (panel == dvTpSnapshotPreview)
	{
		stack_var integer i
		
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
		{
			if (btnAdrCde == btnAdrsVideoInputSnapshotPreviews[i])
			{
				currentPreviewButtonBitmap[i] = bitmapName
			}
		}
	}
}

#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_NAME_CALLBACK
define_function dvxNotifyVideoInputName (dev dvxVideoInput, char name[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// name is the name of the video input
	moderoSetButtonText (dvTpSnapshotPreview, btnAdrsVideoInputLabels[dvxVideoInput.port], MODERO_BUTTON_STATE_ALL, name)
}


// Listener includes go below function definitions (IMPORTANT!!!)
#include 'amx-dvx-listener'
#include 'amx-modero-listener'




define_start

initDevice (dvTpPort1, dvTpSnapshotPreview.number, 1, dvTpSnapshotPreview.system)

// DVX Switcher
initDevice (dvDvxSwitcher, dvDvxVidOutMultiPreview.number, DVX_PORT_MAIN, dvDvxVidOutMultiPreview.system)

initDevice (dvDvxMainPorts[1], dvDvxSwitcher.number, dvDvxSwitcher.port, dvDvxSwitcher.system)
set_length_array (dvDvxMainPorts, 1)

// DVX Video Inputs
{
	stack_var integer number
	stack_var integer port
	stack_var integer system
	
	number = dvDvxVidOutMultiPreview.number
	system = dvDvxVidOutMultiPreview.system
	
	for (port = 1; port <= DVX_MAX_VIDEO_INPUTS; port++)
	{
		initDevice (dvDvxVidInPorts[port], number, port, system)
	}
	
	set_length_array (dvDvxVidInPorts, DVX_MAX_VIDEO_INPUTS)
}


addDeviceToDevArray (dvPanelsButtons, dvTpSnapshotPreview)

rebuild_event()



define_event

data_event[dvDvxSwitcher]
{
	online:
	{
		startMultiPreviewSnapshots ()
	}
}

data_event[dvDvxVidOutMultiPreview]
{
	online:
	{
		dvxSetVideoOutputScaleMode (dvDvxVidOutMultiPreview, DVX_SCALE_MODE_AUTO)
		
		if (device_id(dvTpSnapshotPreview))
		{
			stack_var integer i
			
			for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
			{
				// request bitmaps of sources
				moderoRequestButtonBitmapName (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[i], MODERO_BUTTON_STATE_OFF)
			}
		}
	}
}

data_event[dvTpSnapshotPreview]
{
	online:
	{
		stack_var integer i
		
		// Set snapshot preview buttons to scale-to-fit (only applies to dynamic images in G4 modero panels)
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
			moderoEnableButtonScaleToFit (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[i],MODERO_BUTTON_STATE_ALL)
		
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
		{
			// request bitmaps of sources
			moderoRequestButtonBitmapName (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[i], MODERO_BUTTON_STATE_OFF)
		}
		
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrVideoPreviewLoadingMessage)
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrLoadingBar)
		moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
		
		// Setup video settings for MPL
		moderoSetMultiPreviewInputFormatAndResolution (data.device, MODERO_MULTI_PREVIEW_INPUT_FORMAT_HDMI, MODERO_MULTI_PREVIEW_INPUT_RESOLUTION_HDMI_1280x720p30HZ)
		
		// Request Dvx Info
		dvxRequestVideoInputStatusAll (dvDvxSwitcher)
		dvxRequestVideoInputNameAll (dvDvxSwitcher)
	}
}

data_event[dvTpPort1]
{
	online:
	{
		moderoEnablePageTracking (dvTpPort1)
		
		if (device_id(dvDvxSwitcher))
			dvxRequestVideoInputStatusAll (dvDvxSwitcher)
	}
}


data_event[virtual]
{
	command:
	{
		stack_var char header[50]
		
		header = remove_string(data.text,DELIM_HEADER,1)
		
		if (!length_array(header))
		{
			switch (data.text)
			{
				case 'SNAPSHOTS':
				{
					changeMode (MODE_SNAPSHOTS)
				}
			}
		}
		else
		{
			switch (header)
			{
				case 'VIDEO_PREVIEW-':
				{
					inputForVideoPreview = atoi(data.text)
					changeMode (MODE_VIDEO_PREVIEW)
				}
				
				case 'SNAPSHOTS_INPUT-':
				{
					inputForSingleInputSnapshots = atoi(data.text)
					changeMode (MODE_SNAPSHOTS_INPUT_X)
				}
			}
		}
	}
}
