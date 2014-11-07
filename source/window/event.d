/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.event;

import window.window;
public import window.events.keyboard;
public import window.events.mouse;
public import window.events.resize;

// event types
enum : uint {
	None				= 0,
	KeyPress			= 1,
	KeyRelease			= 2,
	MouseButtonPress	= 3,
	MouseButtonRelease	= 4,
	MouseEntered		= 5,
	MouseLeft			= 6,
	MouseMovement		= 7,
	GainedFocus			= 8,
	LostFocus			= 9,
	Resize				= 10,
	Close				= 11,
	ExitApp				= 12
}

public bool PollEvent( ref dml_event event ) {
	
	version(Posix) {
		import window.linux_x11.x11event;
		return X11PollEvent(event);
	}
}

struct dml_event {
	union {
		struct {
			uint type;
			dml_window window;
		}
		KeyboardEvent	keyboard;
		Mouse			mouse;
		ResizeEvent 	resize;
	}

	public void opCall( uint type = None, dml_window _window = null) {
		this.type = type;
		this.window = _window;
	}
	
	
	
}
