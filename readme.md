amx-au-gc-boardroom
===================

Files
-----
+ amx-au-gc-boardroom-main.axs
+ amx-device-control.axi
+ amx-controlports-control.axi
+ amx-dvx-api.axi
+ amx-dvx-control.axi
+ amx-dvx-listener.axi
+ amx-dxlink-api.axi
+ amx-dxlink-control.axi
+ amx-dxlink-listener.axi
+ amx-modero-api.axi
+ amx-modero-control.axi
+ amx-modero-listener.axi
+ amx-pdu-api.axi
+ amx-pdu-control.axi
+ amx-pdu-listener.axi
+ agent-usb-ptz-web-cam.axi
+ debug.axi
+ dynalite-lighting.axi
+ Dynalite_DyNet_Comm_dr1_0_0.jar
+ nec-monitor.axi
+ NEC_LCD5710_Comm_dr1_0_0.jar
+ wake-on-lan.axi
+ xtra-pc-control-api.axi
+ xtra-pc-control-control.axi
+ xtra-pc-control-listener.axi
+ rms-main.axi
+ RmsNetLinxAdapter_dr4_0_0.jar
+ rmsclient.jar
+ rmsnlplatform.jar
+ commons-codec-1.4-AMX-01.jar
+ commons-httpclient-3.1-AMX-01.jar
+ commons-lang-2.5-AMX-01.jar
+ commons-logging-1.1.1-AMX-01.jar

Overview
--------
**amx-au-gc-boardroom** is the NetLinx program created for the AMX system located in the boardroom of AMX Australia's Gold Coast office (5 Commercial Drive, Southport, QLD, Australia).

The system consists of the following AMX devices:
+ AMX Enova DVX-3156HD-SP Presentation Switcher
+ Modero X-Series MXT-1900L-PAN Control Surface Touch Panel
+ Multi-Preview Live MXA-MPL
+ 4 x DXLink Multi-Format Transmitters (TX-MULTI-DXLINK)
+ 2 x DXLink Receivers (RX-DXLINK-HDMI)
+ AMX Power Distribution Unit (NXA-PDU1508-08)
+ AMX Occupancy Sensor
+ Modero X-Series MXD-700 Welcome Panel mounted outside room

And the following 3rd party devices:
+ 2 x NEC Monitors (RS232 control from DXLink receivers; powered from PDU outlets)
+ House PC located in rack

While it is only a small room the AMX Australia Gold Coast boardroom is jam packed with features demonstrating how powerful AMX Automation can be especially when integrated with RMS. As well as being a functional space used daily by the staff at AMX Australia it is also a mini showroom highlighting seemless integration and automation provided by AMX.

Features Implemented:
+ Automated lighting and touch panel wake upon occupancy detection
+ Automated system/lighting shutdown and blinds/screens raise after 8 minutes of no occupancy
+ Automated system startup (lighting to presentation mode, display monitors on, volume set, AV routing, shades drop, touch panel flip to source selection page) upon signal presence detection when laptop plugged into table input.
+ Automated monitor shutdown after 1 minute of source selected with no signal detected.
+ House PC Wake-On-Lan
+ House PC shutdown after hours.
+ House PC lock screen after room occupancy loss detected.
+ Multi-Preview snapshots.
+ Streaming video preview of selected input source.
+ NFC authentication for ad-hoc room booking from touch panel.
+ Gestures
+ Subpage scrolling.
+ Animated page flips.
+ RMS asset management.
+ RMS scheduling.

Features Still To Be Implemented:
+ Video intercom doorbell.
+ Room booking and meeting extension from 19" Modero-X panel.

---------------------------------------------------------------

Author: David Vine - AMX Australia  
Readme formatted with markdown  
Any questions, email <support@amxaustralia.com.au> or phone +61 (7) 5531 3103.
