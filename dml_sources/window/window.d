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

import system.windowimpl;
import system.event;
import system.types;

protected __gshared WindowID				window_id_seq = 0; 
protected __gshared dml_window[WindowID]	current_windows;

public dml_window GetWindowByID( WindowID id ) {
	
	if( id in current_windows ) {
		return current_windows[id];
	} 
	return null;
}
/**
 * window object, contains functions for handling the windowing system
 *
 */
class dml_window : dml_resource {


	@disable public this( dml_window );

	public this( ) {
		id = 0;
		impl = null;
	}
	
	public ~this( ) {
	}
	
	public void onCreate ( ) {
		id = (++window_id_seq);
		impl = new WindowImpl(id);
		current_windows[ id ] = this;
	}
	
	public void onStart( ) {
		Open();
	}
	
	public void onStop( ) {
		impl.Close();
	}
	
	public void onDestroy( ) {
		
		current_windows.remove(id);
		
		delete impl;
		impl = null;
		id = 0;
	}
	
	@property {
		public final pure nothrow WindowID GetID(){ return id; }
	}
	
	public	WindowImpl	impl;
	
	private	WindowID		id;
	
	alias impl this;
}



