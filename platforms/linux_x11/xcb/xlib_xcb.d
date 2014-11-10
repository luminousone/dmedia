/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module xcb.xlib_xcb;

import x11.xlib;
import xcb.xcb;

extern ( System ) {
	
	xcb_connection_t *XGetXCBConnection(Display *dpy);
	
	enum XEventQueueOwner { XlibOwnsEventQueue = 0, XCBOwnsEventQueue };
	void XSetEventQueueOwner(Display *dpy, XEventQueueOwner owner);
}
