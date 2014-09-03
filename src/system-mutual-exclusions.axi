PROGRAM_NAME='system-mutual-exclusions'

#if_not_defined __SYSTEM_MUTUAL_EXCLUSIONS__
#define __SYSTEM_MUTUAL_EXCLUSIONS__

#include 'system-devices'
#include 'system-constants'



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



#end_if