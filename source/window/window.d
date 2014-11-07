/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.window;

import application.resource;

import window.windowimpl;
import window.linux_x11.x11windowimpl;
import window.linux_x11.x11event;

alias uint	WindowID;
alias uint	WindowMSG;


enum : uint {
	Window_Hide = 1
}

protected __gshared WindowID				window_id_seq = 0; 
protected __gshared dml_window[WindowID]	current_windows;

public dml_window GetWindowByID( WindowID id ) {
	
	if( id in current_windows ) {
		return current_windows[id];
	} 
	return null;
}

class dml_window : dml_resource {


	@disable public this( dml_window );

	public this( ) {
		id = 0;
		impl = null;
	}
	
	public ~this( ) {
	}
	
	public void onCreate ( ) {
		version(Posix) {
			impl = new dml_x11WindowImpl();
			current_x11windows	[ (cast(dml_x11WindowImpl)impl).window ]	= this;
			current_windows		[ id = (++window_id_seq) ] 					= this;
		}
	}
	
	public void onStart( ) {
		Open();
	}
	
	public void onStop( ) {
		Close();
	}
	
	public void onDestroy( ) {
		version( Posix ) {
			current_x11windows.remove((cast(dml_x11WindowImpl)impl).window);
			current_windows.remove(id);
		}
		delete impl;
		impl = null;
		id = 0;
	}
	
	@property {
		public final pure nothrow WindowID GetID(){ return id; }
	}
	
	public	dml_windowImpl	impl;
	
	private	WindowID		id;
	
	alias impl this;
}



