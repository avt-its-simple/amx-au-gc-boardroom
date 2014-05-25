program_name='rms-main'


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
'RmsGenericNetLinxDeviceMonitor' mdlRmsKeypad1Mon(vdvRms, dvKeypad1)
'RmsGenericNetLinxDeviceMonitor' mdlRmsKeypad2Mon(vdvRms, dvKeypad2)

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

// camera
// @TODO requires NetLinx / Duet control module for simple integration

// PDU monitor
// @TODO implement PDU monitor - require schematics for visibility of attached devices
//'RmsPowerDistributionUnitMonitor' mdlRmsPduMon(vdvRms

// Monitoring for the lighting system
// @TODO config internals of module
'RmsDuetLightSystemMonitor' mdlRmsLightMon(vdvRms, vdvDynaliteDyNetLightSystem, dvDynaliteDyNetLightSystem)

// @TODO register room PC

// @TODO register blinds and shades
 
// @TODO implement system power on/off notification and control

// @TODO implement source usage monitoring

// @TODO register occupancy sensor against system asset

// @TODO implement power tracking of house PC based on signal status / power draw
