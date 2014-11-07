/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.events.resize;

import window.window : dml_window;

struct ResizeEvent {
	uint type;
	dml_window window;
	
	uint x,y,w,h;
	
	public void opCall( uint type, dml_window _window, uint x, uint y, uint w, uint h ) {
		
		this.type   = type;
		this.window = _window;
		this.x 		= x;
		this.y 		= y;
		this.w 		= w;
		this.h 		= h;
	}
}