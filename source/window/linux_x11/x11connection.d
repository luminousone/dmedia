/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.linux_x11.x11connection;

version( Posix ) {

	// X11 libraries
	import x11.xlib;
	import xcb.xcb;
	import xcb.xlib_xcb;

	public	__gshared dml_x11Connection		x11connection = null;
	
	class dml_x11Connection {
		
		private Display          * 	display;
		private xcb_connection_t * 	connection;
		private xcb_screen_t     * 	screen;
		private int 				default_screen;
		private xcb_atom_t[string]	Atoms;
		private xcb_key_symbols_t *	key_symbols;
		
		public this( ) {
			Startup();
		}
		
		public ~this( ) {
			Shutdown();
		}
		
		@property public Display			*	GetDisplay() 		{ return display; 			}
		@property public xcb_connection_t	*	GetConnection() 	{ return connection;		}
		@property public xcb_screen_t		*	GetScreen() 		{ return screen; 			}
		@property public int					GetDefault_Screen()	{ return default_screen;	}
		@property public xcb_key_symbols_t	*	GetKeySymbols()		{ return key_symbols;	}
		
		private void Startup( ) {
			
			// initialize x11 threading
			if( XInitThreads() == 0 ) {
				throw new Exception("failed to initialize xthreading");
			}
	
			// get xlib display connection
			if( (display = XOpenDisplay( null )) is null ) {
				throw new Exception("unable to create XLIB connection");
			}
			
			default_screen = DefaultScreen(*display);
			
			// get xcb connection from xlib display connection	
			if( ( connection = XGetXCBConnection(display) ) is null ) {
				XCloseDisplay(display);
				throw new Exception("unable to create XCB connection");
			}
			
			// make xcb handle the event queue rather then xlib
			XSetEventQueueOwner(display, XEventQueueOwner.XCBOwnsEventQueue);
				
			// find xcb screen	
			xcb_screen_iterator_t screen_iter = xcb_setup_roots_iterator(xcb_get_setup(connection));
			
			for( int screen_num = default_screen ; 
				 screen_iter.rem && screen_num > 0 ; 
				 --screen_num, xcb_screen_next(&screen_iter)){}
			
			screen = screen_iter.data;
			
			key_symbols = xcb_key_symbols_alloc( connection );
		}
			
		private void Shutdown() {
			xcb_key_symbols_free( key_symbols );
			// close the display connection
			if( display !is null ) {
				XCloseDisplay(display);
			}
		}
		
		public xcb_atom_t GetAtom( string atomName, ubyte only_if_exists) {
			
			import std.string : toStringz;
			import std.c.stdlib : free;
			
			if(  atomName in Atoms ) {
				return Atoms[atomName];
			}
			
			xcb_intern_atom_cookie_t	cookie;
			xcb_intern_atom_reply_t	*	reply;
			xcb_atom_t					atom;
			
			cookie	= xcb_intern_atom		( connection, only_if_exists, cast(ushort)atomName.length, cast(const(char*))toStringz(atomName) );
			reply	= xcb_intern_atom_reply	( connection, cookie, cast(xcb_generic_error_t**)null );
			
			Atoms[atomName] = reply.atom;
			
			free(reply);
			
			return Atoms[atomName];
			
		}
		
	} // end class X11Connection

	
	
	
}