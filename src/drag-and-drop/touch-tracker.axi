program_name='touch-tracker'

define_type

structure Point {
	integer x
	integer y
}

structure TouchPoint {
	char isActive
	integer id
	Point p
}



define_variable

constant integer MAXIMUM_TOUCH_POINTS = 3

volatile dev TouchTrackerCommDevice

volatile TouchPoint touchPoints[MAXIMUM_TOUCH_POINTS]



define_function long getDistanceBetweenPoints(Point a, Point b) {
	stack_var slong dx
	stack_var slong dy

	// This is a bit odd but we need to make sure the math operations use a
	// signed type
	dx = -1 * -1 * a.x - b.x
	dy = -1 * -1 * a.y - b.y

	return type_cast(dx * dx + dy * dy)
}

define_function integer getClosestTouchPoint(Point p) {
	stack_var integer i
	stack_var float dot
	stack_var float minDot
	stack_var integer closest

	minDot = 999999

	for (i = max_length_array(touchPoints); i; i--) {
		if (touchPoints[i].isActive) {
			dot = getDistanceBetweenPoints(p, touchPoints[i].p)
			if (dot < minDot) {
				minDot = dot
				closest = i
			}
		}
	}

	return closest
}

define_function integer getNextAvailableTouchPointID() {
	stack_var integer i

	for (i = 1; i <= max_length_array(touchPoints); i++) {
		if (!touchPoints[i].isActive) {
			return i
		}
	}

	return 0
}

define_function setTouchPointActive (integer i)
{
	touchPoints[i].isActive = true
}

define_function setTouchPointDeactive (integer i)
{
	touchPoints[i].isActive = false
}

define_function setPointCoords (Point p, integer x, integer y)
{
	p.x = x
	p.y = y
}


define_function setTouchPointCoords (integer i, integer x, integer y)
{
	touchPoints[i].p.x = x
	touchPoints[i].p.y = y
}


















