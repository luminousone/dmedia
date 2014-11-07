/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.events.keyboard;

import window.window : dml_window;

struct KeyboardEvent {
	uint type;
	dml_window window;
	
	uint key;
	bool pressed;
	
	public void opCall( uint type, dml_window _window, uint key, bool pressed ) {
		
		this.type    = type;
		this.window = _window;
		this.key     = key;
		this.pressed = pressed;
	}
}