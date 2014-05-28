program_name='rms-main'


#define INCLUDE_RMS_EVENT_SYSTEM_POWER_REQUEST_CALLBACK
#define INCLUDE_RMS_EVENT_CLIENT_ONLINE_CALLBACK
#define INCLUDE_RMS_EVENT_CLIENT_OFFLINE_CALLBACK


#include 'RmsEventListener'


define_device

// Virtual devices for asset registration and power / source monitoring
rmsPc = 34001:1:0
rmsPdxl2 = 34002:1:0
rmsMpl = 34003:1:0
rmsFan1 = 34004:1:0
rmsFan2 = 34005:1:0


define_variable

// As there's no single point to latch on to in order to detect system power
// we'll set up a timeline to monitor the 'isSystemAvInUse' variable and update
// RMS accordingly.
constant long RMS_TL_IN_USE_CHECK = 300
constant long RMS_IN_USE_CHECK_INTERVAL[1] = {5000}

// PDU asset associations
volatile dev rmsPduAssets[] = {
	dvMonitorLeft,
	dvMonitorRight,
	rmsPdxl2,
	rmsMpl,
	rmsPc,
	dvDvxMain,
	rmsFan1,
	rmsFan2
}

// Name / description pairs for passing to our virtual device monitors
volatile char rmsPdxl2Name[] = 'PDXL2'
volatile char rmsPdxl2Desc[] = 'DXLink power supply'
volatile char rmsMplName[] = 'MXA-MPL'
volatile char rmsMplDesc[] = 'Multi preview live encoder / capture box'
volatile char rmsPcName[] = 'PC'
volatile char rmsPcDesc[] = 'House PC'
volatile char rmsFan1Name[] = 'Rack fan 1'
volatile char rmsFan1Desc[] = 'Controllable active cooling'
volatile char rmsFan2Name[] = 'Rack fan 2'
volatile char rmsFan2Desc[] = 'Controllable active cooling'


// Rms callbacks

define_function RmsEventClientOnline()
{
	// This system doesn't really appear to have a concept of an initial on
	// state that we can activate remotely so lets just ommit the control.
	RmsAssetControlMethodExclude(RmsDevToString(dvMaster), 'system.power.on')

	// Set up our system power state monitoring timeline
	if (!timeline_active(RMS_TL_IN_USE_CHECK))
	{
		timeline_create(RMS_TL_IN_USE_CHECK,
				RMS_IN_USE_CHECK_INTERVAL,
				1,
				TIMELINE_ABSOLUTE,
				TIMELINE_REPEAT)
	}
}

define_function RmsEventClientOffline()
{
	if (timeline_active(RMS_TL_IN_USE_CHECK))
	{
		timeline_kill(RMS_TL_IN_USE_CHECK)
	}
}

define_function RmsEventSystemPowerChangeRequest(CHAR powerOn)
{
	if (powerOn)
	{
		// Not implemented
	}
	else
	{
		shutdownAvSystem()
		moderoSetPage(dvTpTableMain, PAGE_NAME_SPLASH_SCREEN)
		moderoDisableAllPopups(dvTpTableMain)
	}
}


define_module

// instantiate the Netlinx adaptor module which will start the RMS client
'RmsNetLinxAdapter_dr4_0_0' mdlRms(vdvRms)

// add the control system as an assett
'RmsControlSystemMonitor' mdlRmsControlSysMon(vdvRms, dvMaster)

// monitor power of the system
'RmsSystemPowerMonitor' mdlRmsSysPwrMon(vdvRms, dvMaster)

// DVX switcher monitor
'RmsDvxSwitcherMonitor' mdlRmsDvxMon(vdvRms)

// touch panel monitoring
'RmsTouchPanelMonitor' mdlRmsTpMon(vdvRms, dvTpTableMain)

// keypads
'RmsGenericNetLinxDeviceMonitor' mdlRmsKeypadMon(vdvRms, dvKeypad1)

// DXLink receivers
'RmsGenericNetLinxDeviceMonitor' mdlRmsRxMonitorLeftMon(vdvRms, dvRxMonitorLeftMain)
'RmsGenericNetLinxDeviceMonitor' mdlRmsRxMonitorRightMon(vdvRms, dvRxMonitorRightMain)

// DXLink transmitters
'RmsGenericNetLinxDeviceMonitor' mdlRmsTxTable1Mon(vdvRms, dvTxTable1Main)
'RmsGenericNetLinxDeviceMonitor' mdlRmsTxTable2Mon(vdvRms, dvTxTable2Main)
'RmsGenericNetLinxDeviceMonitor' mdlRmsTxTable3Mon(vdvRms, dvTxTable3Main)
'RmsGenericNetLinxDeviceMonitor' mdlRmsTxTable4Mon(vdvRms, dvTxTable4Main)

// external relay box
'RmsGenericNetLinxDeviceMonitor' mdlRmsRelayMon(vdvRms, dvRelaysRelBox)

// monitoring for our LCD's
'RmsDuetMonitorMonitor' mdlRmsLcdLeftMon(vdvRms, vdvMonitorLeft, dvMonitorLeft)
'RmsDuetMonitorMonitor' mdlRmsLcdRightMon(vdvRms, vdvMonitorRight, dvMonitorRight)

// Monitoring for the lighting system
// @TODO config internals of module
'RmsDuetLightSystemMonitor' mdlRmsLightMon(vdvRms, vdvDynaliteDyNetLightSystem, dvDynaliteDyNetLightSystem)

// Virtual monitor for the PDXL2
'RmsVirtualDeviceMonitor' mdlRmsPdxl2Mon(vdvRms, rmsPdxl2, rmsPdxl2Name, rmsPdxl2Desc)

// Virtual monitor for the MPL
'RmsVirtualDeviceMonitor' mdlRmsMplMon(vdvRms, rmsMpl, rmsMplName, rmsMplDesc)

// Virtual monitor for the rack PC
'RmsVirtualDeviceMonitor' mdlRmsPcMon(vdvRms, rmsPc, rmsPcName, rmsPcDesc)

// Virtual monitor for the additional rack fans
'RmsVirtualDeviceMonitor' mdlRmsFan1Mon(vdvRms, rmsFan1, rmsFan1Name, rmsFan1Desc)
'RmsVirtualDeviceMonitor' mdlRmsFan1Mon(vdvRms, rmsFan2, rmsFan2Name, rmsFan2Desc)

// PDU monitor
'RmsPowerDistributionUnitMonitor' mdlRmsPduMon(vdvRms, dvPduMain1, rmsPduAssets)

// @TODO register blinds and shades

// @TODO implement source usage monitoring

// @TODO add camera monitoring (requires NetLinx / Duet control module for simple integration)

// @TODO register occupancy sensor against system asset



define_event

timeline_event[RMS_TL_IN_USE_CHECK]
{
	local_var integer lastInUseValue

	if (lastInUseValue != isSystemAvInUse)
	{
		if (isSystemAvInUse)
		{
			RmsSystemPowerOn()
		}
		else
		{
			RmsSystemPowerOff()
		}
	}

	lastInUseValue = isSystemAvInUse
}
