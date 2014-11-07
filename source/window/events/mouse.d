/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.events.mouse;

import window.window : dml_window;

enum : uint {
	ButtonLeft		= 1,
	ButtonRight		= 2,
	ButtonMiddle	= 3,
	WheelUp			= 4,
	WheelDown		= 5,
	WheelLeft		= 6,
	WheelRight		= 7,
	XButton1		= 8,
	XButton2		= 9,
	XButton3		= 10
}

struct Mouse {
	
	uint type;
	dml_window window;
	uint x,y;
	uint button;
	
	public void opCall( uint type, dml_window window, uint x, uint y, uint button ) {
		this.type	= type;
		this.window = window;
		this.x		= x;
		this.y		= y;
		this.button = button;
	}
}