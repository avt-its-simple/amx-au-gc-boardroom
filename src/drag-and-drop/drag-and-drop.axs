module_name='drag-and-drop' (dev virtual, dev panel)

#include 'amx-device-control'
#include 'amx-modero-control'
#include 'touch-tracker'


define_constant

// CMD/STR Delimeters
char DELIM_HEADER[] = '-'
char DELIM_PARAM[] = ','

/*
 * Command Headers
 */
char CMD_HEADER_DEFINE_DRAG_ITEM[] = 'DEFINE_DRAG_ITEM-'
// CMD Syntax:
//    'DEFINE_DROP_ITEM-<id>,<left>,<top>,<width>,<height>'
// Example:
//    'DEFINE_DRAG_ITEM-1,254,625,160,118'
char CMD_HEADER_DEFINE_DROP_AREA[] = 'DEFINE_DROP_AREA-'
// CMD Syntax:
//    'DEFINE_DROP_AREA-<id>,<left>,<top>,<width>,<height>'
// Example:
//    'DEFINE_DROP_AREA-1,254,625,160,118'

char CMD_HEADER_DELETE_DRAG_ITEM[] = 'DELETE_DRAG_ITEM-'
// CMD Syntax:
//    'DELETE_DRAG_ITEM-<id>'
// Example:
//    'DELETE_DRAG_ITEM-1'
char CMD_HEADER_DELETE_DROP_AREA[] = 'DELETE_DROP_AREA-'
// CMD Syntax:
//    'DELETE_DROP_AREA-<id>'
// Example:
//    'DELETE_DROP_AREA-1'

char CMD_HEADER_ACTIVATE_DRAG_ITEM[] = 'ACTIVATE_DRAG_ITEM-'
// CMD Syntax:
//    'ACTIVATE_DRAG_ITEM-<id>'
// Example:
//    'ACTIVATE_DRAG_ITEM-1'
char CMD_HEADER_ACTIVATE_DROP_AREA[] = 'ACTIVATE_DROP_AREA-'
// CMD Syntax:
//    'ACTIVATE_DROP_AREA-<id>'
// Example:
//    'ACTIVATE_DROP_AREA-1'

char CMD_HEADER_DEACTIVATE_DRAG_ITEM[] = 'DEACTIVATE_DRAG_ITEM-'
// CMD Syntax:
//    'DEACTIVATE_DRAG_ITEM-<id>'
// Example:
//    'DEACTIVATE_DRAG_ITEM-1'
char CMD_HEADER_DEACTIVATE_DROP_AREA[] = 'DEACTIVATE_DROP_AREA-'
// CMD Syntax:
//    'DEACTIVATE_DROP_AREA-<id>'
// Example:
//    'DEACTIVATE_DROP_AREA-1'

char CMD_HEADER_STOP_TRACKING_TOUCH[] = 'STOP_TRACKING_TOUCH'
// CMD Syntax:
//    'STOP_TRACKING_TOUCH'
// Example:
//    'STOP_TRACKING_TOUCH'
char CMD_HEADER_START_TRACKING_TOUCH[] = 'START_TRACKING_TOUCH'
// CMD Syntax:
//    'START_TRACKING_TOUCH'
// Example:
//    'START_TRACKING_TOUCH'



/*
 * String Response Headers
 */
char STR_RESP_HEADER_DRAG_ITEM_SELECTED[]             = 'DRAG_ITEM_SELECTED-'
// STR Syntax:
//    'DRAG_ITEM_SELECTED-<id>'
// Example:
//    'DRAG_ITEM_SELECTED-1'
char STR_RESP_HEADER_DRAG_ITEM_DESELECTED[]           = 'DRAG_ITEM_DESELECTED-'
// STR Syntax:
//    'DRAG_ITEM_DESELECTED-<id>'
// Example:
//    'DRAG_ITEM_DESELECTED-1'
char STR_RESP_HEADER_DRAG_ITEM_ENTER_DROP_AREA[]      = 'DRAG_ITEM_ENTER_DROP_AREA-'
// STR Syntax:
//    'DRAG_ITEM_ENTER_DROP_AREA-<drag_item_id>,<drop_area_id>'
// Example:
//    'DRAG_ITEM_ENTER_DROP_AREA-1,1'
char STR_RESP_HEADER_DRAG_ITEM_EXIT_DROP_AREA[]       = 'DRAG_ITEM_EXIT_DROP_AREA-'
// STR Syntax:
//    'DRAG_ITEM_EXIT_DROP_AREA-<drag_item_id>,<drop_area_id>'
// Example:
//    'DRAG_ITEM_EXIT_DROP_AREA-1,1'
char STR_RESP_HEADER_DRAG_ITEM_DROPPED_ON_DROP_AREA[] = 'DRAG_ITEM_DROPPED_ON_DROP_AREA-'
// STR Syntax:
//    'DRAG_ITEM_DROPPED_ON_DROP_AREA-<drag_item_id>,<drop_area_id>'
// Example:
//    'DRAG_ITEM_DROPPED_ON_DROP_AREA-1,1'
char STR_RESP_HEADER_DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME[] = 'DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME-'
// STR Syntax:
//    'DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME-<drag_item_id>'
// Example:
//    'DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME-1'


/*
 * Maxiumum values
 */

integer MAX_DROP_AREAS = 10
integer MAX_DRAG_AREAS = 10
integer MAX_AREA_NAME_LENGTH = 50

long TIMELINE_ID_1 = 1
long TIMELINE_ID_2 = 2
long TIMELINE_ID_3 = 3


define_type

structure _bounds
{
	integer left
	integer top
	integer width
	integer height
}

structure _area
{
	integer id
	integer activeStatus
	_bounds bounds
}


define_variable

// Listener DEV array for amx-modero-listener
dev dvPanelsCoordinateTracking[1]

_area dropAreas[MAX_DROP_AREAS]
_area dragAreas[MAX_DRAG_AREAS]
integer selectedDragArea[MAXIMUM_TOUCH_POINTS]
char intersectStatus[MAX_DRAG_AREAS][MAX_DROP_AREAS]

long timelineTimes[] = {1000}

integer isTrackingTouch = true

dev panelPort1


define_start

// Populate listener DEV array for amx-modero-listener
panelPort1 = panel.number:1:panel.system
dvPanelsCoordinateTracking[1] = panelPort1
set_length_array (dvPanelsCoordinateTracking,1)
rebuild_event()


define_function copyRectangle (_bounds boundsCopyTo, _bounds boundsCopyFrom)
{
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function copyRectangle (_bounds boundsCopyTo, _bounds boundsCopyFrom)'"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyTo.left = ',itoa(boundsCopyTo.left)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyTo.top = ',itoa(boundsCopyTo.top)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyTo.width = ',itoa(boundsCopyTo.width)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyTo.height = ',itoa(boundsCopyTo.height)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyFrom.left = ',itoa(boundsCopyFrom.left)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyFrom.top = ',itoa(boundsCopyFrom.top)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyFrom.width = ',itoa(boundsCopyFrom.width)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyFrom.height = ',itoa(boundsCopyFrom.height)"*/
	
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to copy bounds'"*/
	boundsCopyTo.height = boundsCopyFrom.height
	boundsCopyTo.left = boundsCopyFrom.left
	boundsCopyTo.top = boundsCopyFrom.top
	boundsCopyTo.width = boundsCopyFrom.width
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::copying bounds is complete'"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyTo.left = ',itoa(boundsCopyTo.left)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyTo.top = ',itoa(boundsCopyTo.top)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyTo.width = ',itoa(boundsCopyTo.width)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::boundsCopyTo.height = ',itoa(boundsCopyTo.height)"*/
}

define_function updateArea (_area area, integer id, _bounds bounds)
{
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function updateArea (_area area, integer id, _bounds bounds)'"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::area.bounds.left = ',itoa(area.bounds.left)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::area.bounds.top = ',itoa(area.bounds.top)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::area.bounds.width = ',itoa(area.bounds.width)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::area.bounds.height = ',itoa(area.bounds.height)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::id = ',itoa(id)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::bounds.left = ',itoa(bounds.left)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::bounds.top = ',itoa(bounds.top)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::bounds.width = ',itoa(bounds.width)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::bounds.height = ',itoa(bounds.height)"*/
	
	area.id = id
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::area.id = ',itoa(area.id)"*/
	
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to copy rectangle'"*/
	copyRectangle (area.bounds, bounds)
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::copy rectangle complete'"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::area.bounds.left = ',itoa(area.bounds.left)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::area.bounds.top = ',itoa(area.bounds.top)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::area.bounds.width = ',itoa(area.bounds.width)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::area.bounds.height = ',itoa(area.bounds.height)"*/
}


define_function addDragArea (integer id, _bounds bounds)
{
	// #1) check if the array is empty - if it is add the item to the first index and exit.
	// #2) check to see if the id for the item is already in the array - if the id exists just update the _bounds info at that location and exit
	// #3) check if the array is full - if it is not, increase the size of the list (aka, length of the array), add the item to the new end of the list and exit.
	
	stack_var integer i
	
	if (length_array(dragAreas) == 0)
	{
		set_length_array (dragAreas, 1)
		updateArea (dragAreas[1], id, bounds)
		activateArea (dragAreas[1])
		return
	}
	
	for (i = 1; i <= length_array(dragAreas); i++)
	{
		if (dragAreas[i].id == id)
		{
			updateArea (dragAreas[i], id, bounds)
			activateArea (dragAreas[i])
			return
		}
	}
	
	// check that the array is not full
	if (i < max_length_array(dragAreas))
	{
		set_length_array (dragAreas, i)
		updateArea (dragAreas[i], id, bounds)
		activateArea (dragAreas[i])
		return
	}
}

define_function activateArea (_area area)
{
	area.activeStatus = true
}

define_function deactivateArea (_area area)
{
	
	//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function deactivateArea (_area area)'"
	//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set area.activeState (currently <',itoa(,area.activeStatus),'>) to false'"
	area.activeStatus = false
	//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::finished setting area.activeState to false. area.activeState = ',itoa(,area.activeStatus)"
}

define_function integer getAreaActiveStatus (_area area)
{
	return area.activeStatus
}

define_function activateDragArea (integer id)
{
	stack_var integer i
	
	for (i = 1; i <= max_length_array(dragAreas); i++)
	{
		if (dragAreas[i].id == id)
		{
			activateArea(dragAreas[i])
		}
	}
}

define_function activateDropArea (integer id)
{
	stack_var integer i
	
	for (i = 1; i <= max_length_array(dropAreas); i++)
	{
		if (dropAreas[i].id == id)
		{
			activateArea(dropAreas[i])
		}
	}
}

define_function deactivateDragArea (integer id)
{
	stack_var integer i
	stack_var integer isMatchFound
	
	//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function deactivateDragArea (integer id)'"
	//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::id = ',itoa(id)"
	
	for (i = 1; i <= length_array(dragAreas); i++)
	{
		//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::i = ',itoa(i)"
		if (dragAreas[i].id == id)
		{
			//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (dragAreas[i].id == id)'"
			//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to activate dragAreas[',itoa(i),']'"
			deactivateArea(dragAreas[i])
			//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::activation of dragAreas[',itoa(i),'] complete'"
		}
	}
}

define_function deactivateDropArea (integer id)
{
	stack_var integer i
	stack_var integer isMatchFound
	
	for (i = 1; i <= max_length_array(dropAreas); i++)
	{
		if (dropAreas[i].id == id)
		{
			deactivateArea(dropAreas[i])
		}
	}
}

define_function removeDragArea (integer id)
{
	stack_var integer i
	stack_var integer isMatchFound
	
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function removeDragArea (integer id)'"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::id = ',itoa(id)"*/
	
	isMatchFound = FALSE
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::isMatchFound = ',itoa(isMatchFound)"*/
	
	for (i = 1; i <= length_array(dragAreas); i++)
	{
		/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::i = ',itoa(i)"
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'].id = ',itoa(dragAreas[i].id)"*/
		if (dragAreas[i].id == id)
		{
			/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (dragAreas[i].id == id)'"*/
			isMatchFound = TRUE
			/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::isMatchFound = ',itoa(isMatchFound)"*/
		}
		
		if (isMatchFound)
		{
			/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (isMatchFound)'"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.left = ',itoa(dragAreas[i].bounds.left)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.top = ',itoa(dragAreas[i].bounds.top)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.width = ',itoa(dragAreas[i].bounds.width)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.height = ',itoa(dragAreas[i].bounds.height)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::....about to reset dragAreas[',itoa(i),']'"*/
			resetArea (dragAreas[i])
			/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::....reset dragAreas[',itoa(i),'] complete'"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.left = ',itoa(dragAreas[i].bounds.left)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.top = ',itoa(dragAreas[i].bounds.top)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.width = ',itoa(dragAreas[i].bounds.width)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.height = ',itoa(dragAreas[i].bounds.height)"*/
			if (i <= length_array(dragAreas))
			{
				/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (i <= length_array(dragAreas))'"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.left = ',itoa(dragAreas[i].bounds.left)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.top = ',itoa(dragAreas[i].bounds.top)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.width = ',itoa(dragAreas[i].bounds.width)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.height = ',itoa(dragAreas[i].bounds.height)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::....about to update dragAreas[',itoa(i),']'"*/
				updateArea (dragAreas[i],dragAreas[i+1].id,dragAreas[i+1].bounds)
				/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::....update of dragAreas[',itoa(i),'] is complete'"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.left = ',itoa(dragAreas[i].bounds.left)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.top = ',itoa(dragAreas[i].bounds.top)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.width = ',itoa(dragAreas[i].bounds.width)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dragAreas[',itoa(i),'.bounds.height = ',itoa(dragAreas[i].bounds.height)"*/
			}
		}
	}
	
	
	if (isMatchFound)
	{
		/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (isMatchFound)'"
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::length_array(dragAreas) = ',itoa(length_array(dragAreas))"
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to decrease length of dragAreas array by 1'"*/
		set_length_array (dragAreas, (length_array(dragAreas)-1))
		/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::length_array(dragAreas) = ',itoa(length_array(dragAreas))"*/
	}
}


define_function removeDropArea (integer id)
{
	stack_var integer i
	stack_var integer isMatchFound
	
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function removeDropArea (integer id)'"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::id = ',itoa(id)"*/
	
	isMatchFound = FALSE
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::isMatchFound = ',itoa(isMatchFound)"*/
	
	for (i = 1; i <= length_array(dropAreas); i++)
	{
		/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::i = ',itoa(i)"*/
		if (dropAreas[i].id == id)
		{
			/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (dropAreas[i].id == id)'"*/
			isMatchFound = TRUE
			/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::isMatchFound = ',itoa(isMatchFound)"*/
		}
		
		if (isMatchFound)
		{
			/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (isMatchFound)'"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.left = ',itoa(dropAreas[i].bounds.left)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.top = ',itoa(dropAreas[i].bounds.top)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.width = ',itoa(dropAreas[i].bounds.width)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.height = ',itoa(dropAreas[i].bounds.height)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::....about to reset dropAreas[',itoa(i),']'"*/
			resetArea (dropAreas[i])
			/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::....reset dropAreas[',itoa(i),'] complete'"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.left = ',itoa(dropAreas[i].bounds.left)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.top = ',itoa(dropAreas[i].bounds.top)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.width = ',itoa(dropAreas[i].bounds.width)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.height = ',itoa(dropAreas[i].bounds.height)"*/
			if (i <= length_array(dropAreas))
			{
				/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (i <= length_array(dropAreas))'"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.left = ',itoa(dropAreas[i].bounds.left)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.top = ',itoa(dropAreas[i].bounds.top)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.width = ',itoa(dropAreas[i].bounds.width)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.height = ',itoa(dropAreas[i].bounds.height)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::....about to update dropAreas[',itoa(i),']'"*/
				updateArea (dropAreas[i],dropAreas[i+1].id,dropAreas[i+1].bounds)
				/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::....update of dropAreas[',itoa(i),'] is complete'"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.left = ',itoa(dropAreas[i].bounds.left)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.top = ',itoa(dropAreas[i].bounds.top)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.width = ',itoa(dropAreas[i].bounds.width)"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dropAreas[',itoa(i),'.bounds.height = ',itoa(dropAreas[i].bounds.height)"*/
			}
		}
	}
	
	if (isMatchFound)
	{
		/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (isMatchFound)'"
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::length_array(dropAreas) = ',itoa(length_array(dropAreas))"
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to decrease length of dropAreas array by 1'"*/
		set_length_array (dropAreas, (length_array(dropAreas)-1))
		/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::length_array(dropAreas) = ',itoa(length_array(dropAreas))"*/
	}
}

define_function resetArea (_area area)
{
	/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function resetArea (_area area)'"*/
	area.id = 0
	area.bounds.height = 0
	area.bounds.left = 0
	area.bounds.top = 0
	area.bounds.width = 0
}


define_function addDropArea (integer id, _bounds bounds)
{
	// #1) check if the array is empty - if it is add the item to the first index and exit.
	// #2) check to see if the id for the item is already in the array - if the id exists just update the _bounds info at that location and exit
	// #3) check if the array is full - if it is not, increase the size of the list (aka, length of the array), add the item to the new end of the list and exit.
	
	stack_var integer i
	
	if (length_array(dropAreas) == 0)
	{
		set_length_array (dropAreas, 1)
		updateArea (dropAreas[1], id, bounds)
		activateArea (dropAreas[1])
		return
	}
	
	for (i = 1; i <= length_array(dropAreas); i++)
	{
		if (dropAreas[i].id == id)
		{
			updateArea (dropAreas[i], id, bounds)
			activateArea (dropAreas[i])
			return
		}
	}
	
	// check that the array is not full
	if (i <= max_length_array(dropAreas))
	{
		set_length_array (dropAreas, i)
		updateArea (dropAreas[i], id, bounds)
		activateArea (dropAreas[i])
		return
	}
}

// function to check if an X,Y coordinate is within the bounds of an area
define_function integer isCoordWithinBounds (integer xCoord, integer yCoord, _area area)
{
	if ((xCoord < area.bounds.left) or (xCoord > (area.bounds.left+area.bounds.width)))
		return false
	
	if ((yCoord < area.bounds.top) or (yCoord > (area.bounds.top+area.bounds.height)))
		return false
	
	return true
}


/*
 * Override the notify callback functions from amx-modero-listener.
 */

#define INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_PRESS
// Note: This will get triggered BEFORE a push event handler in a button_event
// Note: If push/release coordinate reporting is enabled a push anywhere on the panel will trigger this function
define_function moderoNotifyTouchCoordinatesPress (dev panel, integer nX, integer nY)
{
	// panel is the touch panel
	// nX is the X coordinate
	// nY is the Y Coordinate
	
	stack_var integer idTouchPoint
	stack_var integer i
	
	if (isTrackingTouch)
	{
		idTouchPoint = getNextAvailableTouchPointID ()
		setTouchPointCoords (idTouchPoint, nX, nY)
		setTouchPointActive (idTouchPoint)
		
		for (i = 1; i <= length_array(dragAreas); i++)
		{
			if (getAreaActiveStatus(dragAreas[i]))	// look no further unless the drag area is active
			{
				if (isCoordWithinBounds(nX, nY, dragAreas[i]))
				{
					selectedDragArea[idTouchPoint] = i
					sendString (virtual, "STR_RESP_HEADER_DRAG_ITEM_SELECTED,itoa(dragAreas[i].id)")
					
					if (!timeline_active(idTouchPoint))
						timeline_create (idTouchPoint, timelineTimes, 1, TIMELINE_ABSOLUTE, TIMELINE_ONCE)
					
				}
			}
		}
	}
}


#define INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_MOVE
// Note: This will get triggered BEFORE a push event handler in a button_event
// Note: If push/release coordinate reporting is enabled a movement in user touch anywhere on the panel will trigger this function
define_function moderoNotifyTouchCoordinatesMove (dev panel, integer nX, integer nY)
{
	// panel is the touch panel
	// nX is the X coordinate
	// nY is the Y Coordinate
	
	stack_var integer idTouchPoint
	stack_var Point p
	stack_var integer i
	
	if (isTrackingTouch)
	{
		setPointCoords (p, nX, nY)
		idTouchPoint =  getClosestTouchPoint(p)
		
		if (idTouchPoint)	// check to see that there is a touch point being tracked (mouse movements over VNC will trigger a move even though there has been no push
		{
			setTouchPointCoords (idTouchPoint, nX, nY)
			
			// intersectStatus
			// selectedDragArea[idTouchPoint] - contains the index of the selected drag area in the dragAreas array
			
			if (selectedDragArea[idTouchPoint])
			{
				if (timeline_active(idTouchPoint))
				{
					if (!isCoordWithinBounds(nX,nY,dragAreas[selectedDragArea[idTouchPoint]]))
					{
						timeline_kill (idTouchPoint)
					}
				}
				
				for (i=1; i<=max_length_array(dropAreas); i++)
				{
					if (getAreaActiveStatus(dropAreas[i]))	// look no further unless the drop area is active
					{
						if (isCoordWithinBounds(nX,nY,dropAreas[i]) )
						{
							if (!intersectStatus[selectedDragArea[idTouchPoint]][i])
							{
								intersectStatus[selectedDragArea[idTouchPoint]][i] = true
								
								sendString (virtual, "STR_RESP_HEADER_DRAG_ITEM_ENTER_DROP_AREA,itoa(dragAreas[selectedDragArea[idTouchPoint]].id),DELIM_PARAM,itoa(dropAreas[i].id)")
							}
						}
						else
						{
							if (intersectStatus[selectedDragArea[idTouchPoint]][i])
							{
								intersectStatus[selectedDragArea[idTouchPoint]][i] = false
								
								sendString (virtual, "STR_RESP_HEADER_DRAG_ITEM_EXIT_DROP_AREA,itoa(dragAreas[selectedDragArea[idTouchPoint]].id),DELIM_PARAM,itoa(dropAreas[i].id)")
							}
						}
					}
				}
			}
		}
	}
	
}

#define INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_RELEASE
// Note: This will get triggered AFTER a release event handler in a button_event
// Note: If push/release coordinate reporting is enabled a release anywhere on the panel will trigger this function
define_function moderoNotifyTouchCoordinatesRelease (dev panel, integer nX, integer nY)
{
	// panel is the touch panel
	// nX is the X coordinate
	// nY is the Y Coordinate
	
	stack_var integer idTouchPoint
	stack_var Point p
	stack_var integer i
	stack_var integer isDroppedOntoDragArea
	
	if (isTrackingTouch)
	{
		isDroppedOntoDragArea = false
		
		setPointCoords (p, nX, nY)
		idTouchPoint =  getClosestTouchPoint(p)
		setTouchPointCoords (idTouchPoint, nX, nY)
		setTouchPointDeactive (idTouchPoint)
		
		if (selectedDragArea[idTouchPoint])
		{
			if (timeline_active(idTouchPoint))
				timeline_kill (idTouchPoint)
			
			for (i=1; i<= length_array(dropAreas); i++)
			{
				if (getAreaActiveStatus(dropAreas[i]))	// look no further unless the drop area is active
				{
					if (isCoordWithinBounds(nX, nY, dropAreas[i]))
					{
						isDroppedOntoDragArea = true
						sendString (virtual, "STR_RESP_HEADER_DRAG_ITEM_DROPPED_ON_DROP_AREA,itoa(dragAreas[selectedDragArea[idTouchPoint]].id),DELIM_PARAM,itoa(dropAreas[i].id)")
					}
				}
			}
			
			if (!isDroppedOntoDragArea)
			{
				sendString (virtual, "STR_RESP_HEADER_DRAG_ITEM_DESELECTED,itoa(dragAreas[selectedDragArea[idTouchPoint]].id)")
			}
			
			for (i=1; i<=MAX_DROP_AREAS; i++)
			{
				intersectStatus[selectedDragArea[idTouchPoint]][i] = false
			}
			
			selectedDragArea[idTouchPoint] = 0
		}
	}
}

#include 'amx-modero-listener'	// copy modero listener notify callback functions above this line



define_start


define_event

data_event[panel]
{
	online:
	{
		moderoEnableTouchCoordinateTrackingPressReleaseMove (panel)
	}
}

data_event[virtual]
{
	command:
	{
		stack_var char header[50]
		
		//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::data_event[virtual]'"
		//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::data.text = ',data.text"
		
		header = remove_string(data.text,DELIM_HEADER,1)
		//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::header = ',header"
		
		if (!length_array(header))
		{
			/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (!length_array(header))'"*/
			switch (data.text)
			{
				case CMD_HEADER_STOP_TRACKING_TOUCH:
				{
					stack_var integer i
					
					isTrackingTouch = false
					
					for (i=1; i<=MAXIMUM_TOUCH_POINTS; i++)
					{
						setTouchPointDeactive (i)
					}
				}
				case CMD_HEADER_START_TRACKING_TOUCH:
				{
					isTrackingTouch = true
				}
			}
		}
		else
		{
			//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (!length_array(header))...else'"
			switch (header)
			{
				case CMD_HEADER_DEFINE_DRAG_ITEM:
				{
					// <id>,<left>,<top>,<width>,<height>
					integer id
					_bounds bounds
					
					id = atoi(remove_string (data.text,DELIM_PARAM,1))
					bounds.left = atoi(remove_string (data.text,DELIM_PARAM,1))
					bounds.top = atoi(remove_string (data.text,DELIM_PARAM,1))
					bounds.width = atoi(remove_string (data.text,DELIM_PARAM,1))
					bounds.height = atoi(data.text)
					
					addDragArea (id, bounds)
				}
				
				case CMD_HEADER_DEFINE_DROP_AREA:
				{
					// <id>,<left>,<top>,<width>,<height>
					integer id
					_bounds bounds
					
					id = atoi(remove_string (data.text,DELIM_PARAM,1))
					bounds.left = atoi(remove_string (data.text,DELIM_PARAM,1))
					bounds.top = atoi(remove_string (data.text,DELIM_PARAM,1))
					bounds.width = atoi(remove_string (data.text,DELIM_PARAM,1))
					bounds.height = atoi(data.text)
					
					addDropArea (id, bounds)
				}
				
				case CMD_HEADER_DELETE_DRAG_ITEM:
				{
					// <id>
					integer id
					
					/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....case CMD_HEADER_DELETE_DRAG_ITEM'"*/
					id = atoi(data.text)
					
					/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....about to remove drag area <',itoa(id),'>'"*/
					removeDragArea (id)
					/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....removal of drag area <',itoa(id),'> complete'"*/
				}
				
				case CMD_HEADER_DELETE_DROP_AREA:
				{
					// <id>
					integer id
					
					/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....case CMD_HEADER_DELETE_DROP_AREA'"*/
					id = atoi(data.text)
					
					/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....about to remove drop area <',itoa(id),'>'"*/
					removeDropArea (id)
					/*send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....removal of drop area <',itoa(id),'> complete'"*/
				}
				
				case CMD_HEADER_ACTIVATE_DRAG_ITEM:
				{
					// <id>
					integer id
					
					id = atoi(data.text)
					
					activateDragArea (id)
				}
				
				case CMD_HEADER_ACTIVATE_DROP_AREA:
				{
					// <id>
					integer id
					
					id = atoi(data.text)
					
					activateDropArea (id)
				}
				
				case CMD_HEADER_DEACTIVATE_DRAG_ITEM:
				{
					// <id>
					integer id
					//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....case CMD_HEADER_DEACTIVATE_DRAG_ITEM'"
					
					id = atoi(data.text)
					
					//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....about to deactivate drag area <',itoa(id),'>'"
					deactivateDragArea (id)
					//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....deactivation of drag area <',itoa(id),'> complete'"
				}
				
				case CMD_HEADER_DEACTIVATE_DROP_AREA:
				{
					// <id>
					integer id
					//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....case CMD_HEADER_DEACTIVATE_DROP_AREA'"
					
					id = atoi(data.text)
					
					//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....about to deactivate drop area <',itoa(id),'>'"
					deactivateDropArea (id)
					//send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (header)....about to deactivate drop area <',itoa(id),'>'"
				}
			}
		}
	}
}

timeline_event[TIMELINE_ID_1]
{
	sendString (virtual, "STR_RESP_HEADER_DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME,itoa(dragAreas[selectedDragArea[TIMELINE_ID_1]].id)")
}

timeline_event[TIMELINE_ID_2]
{
	sendString (virtual, "STR_RESP_HEADER_DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME,itoa(dragAreas[selectedDragArea[TIMELINE_ID_2]].id)")
}

timeline_event[TIMELINE_ID_3]
{
	sendString (virtual, "STR_RESP_HEADER_DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME,itoa(dragAreas[selectedDragArea[TIMELINE_ID_3]].id)")
}
