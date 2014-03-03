program_name='rms-main'


define_variable

// location ID for boardroom
//integer nLocationIdBoardroom = 30
//#warn '@WTF? - rms-main - what is the location ID for the boardroom? Do we even need this?'
//char cLocationNameBoardroom[] = 'Gold Coast Boardroom'


url_struct rmsUrl




// instantiate the Netlinx adaptor module which will start the RMS client
define_module 'RmsNetLinxAdapter_dr4_0_0' modRMS1(vdvRms)
// add the control system as an assett
define_module 'RmsControlSystemMonitor' modRMSsysMon(vdvRms, dvMaster)
// monitor power of the system
define_module 'RmsSystemPowerMonitor' modRMSPwrMon(vdvRms, dvMaster)




// This function will get called when RMS is ready to register assets
// as long as 'RmsEventListener' is included and the 
// INCLUDE_RMS_CUSTOM_EVENT_CLIENT_RESPONSE_CALLBACK compiler directive is 
// defined above the line on which 'RmsEventListener' is included.
#define INCLUDE_RMS_EVENT_ASSETS_REGISTER_CALLBACK
define_function RmsEventRegisterAssets()
{
	/*stack_var RmsAsset rmsAssetDtvRx
	
	
	rmsAssetDtvRx.assetType = RMS_ASSET_TYPE_SETTOP_BOX
	rmsAssetDtvRx.clientKey = cIpTvRxAddressBoardroom
	rmsAssetDtvRx.globalKey = ''
	rmsAssetDtvRx.name = 'TV Receiver'
	rmsAssetDtvRx.description = 'High Definition Receiver, Ethernet, with integrated IR and Serial control'
	rmsAssetDtvRx.manufacturerName = 'AMX'
	rmsAssetDtvRx.manufacturerUrl = 'http://www.amx.com'
	rmsAssetDtvRx.modelName = 'DTV-RX02HD'
	rmsAssetDtvRx.modelUrl = 'http://www.amx.com/products/DTV-RX02-HD.asp'
	rmsAssetDtvRx.serialNumber = ''
	rmsAssetDtvRx.firmwareVersion = ''
	*/
}




#define INCLUDE_RMS_EVENT_ASSET_REGISTERED_CALLBACK
define_function RmsEventAssetRegistered(CHAR assetClientKey[], LONG assetId, CHAR newAssetRegistration)
{
	/*switch (assetClientKey)
	{
		case cIpTvRxAddressBoardroom:
		{
			/*
			RmsAssetParameterEnqueueString(	CHAR assetClientKey[],
											CHAR parameterKey[],
											CHAR parameterName[],
											CHAR parameterDescription[],
											CHAR reportingType[],
											CHAR initialValue[],
											CHAR units[],
											CHAR allowReset,
											CHAR resetValue[],
											CHAR trackChanges )
			*/
			
			RmsAssetParameterEnqueueString(assetClientKey,
											'Channel',
											'Channel',
											'Current Channel',
											RMS_ASSET_PARAM_TYPE_NONE,
											'',
											'',
											FALSE,
											'',
											FALSE)
			
			//RmsAssetParameterSubmit(assetClientKey)
		}
	}*/
}






/*
 * --------------------
 * Events for listening to RMS server
 * --------------------
 */



define_event

data_event[vdvRms]
{
	online: 
	{
	
	}
}















