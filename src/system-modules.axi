PROGRAM_NAME='system-modules'

#if_not_defined __SYSTEM_MODULES__
#define __SYSTEM_MODULES__

#include 'system-devices'
#include 'system-variables'

/*
 * --------------------
 * Module Definitions
 * --------------------
 */

define_module


'drag-and-drop' dragAndDropMod (vdvDragAndDropTpTable, dvTpTableDragAndDrop)




#end_if