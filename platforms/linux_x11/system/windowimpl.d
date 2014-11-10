/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module system.windowimpl;

import window.context;
import window.drawable;

// X11 libraries
import x11.xlib;
import xcb.xcb;
import xcb.xlib_xcb;

import system.context;
import system.connection;
import system.event;
import system.types;

// opengl glx libraries
import deimos.gl.glx;
import deimos.gl.glcorearb;

// c memory functions
import std.c.stdlib : free;
import std.stdio : writeln;

class WindowImpl {
	
	
	public final this( WindowID id ) {
		if( x11connection is null ) {
			x11connection = new x11Connection();
		}
		auto connection = x11connection.GetConnection;	
		
		colormap = xcb_generate_id(connection);
		window   = xcb_generate_id(connection);
		
		current_x11windows[ window ] = id;
	}
	
	public final ~this() {
		current_x11windows.remove(window);
		xcb_destroy_window(x11connection.GetConnection,window);
	}
	
	public final void Create (
		VideoMode	_mode, 
		string		_title, 
		uint		_style, 
		dml_context	_context ) {
			
		mode	= _mode;
		title	= _title;
		style	= _style;
		context	= _context;
	
		//
		// Open X11 connection
		//	
		auto display	= x11connection.GetDisplay;
		auto connection = x11connection.GetConnection;
		auto screen		= x11connection.GetScreen;
		
		
		xcb_create_colormap(
	    	connection,
	    	xcb_colormap_alloc_t.XCB_COLORMAP_ALLOC_NONE,
	    	colormap,
	    	screen.root,
	    	context.VisualId
	    );
    
    	/* Create window */
    	uint32_t eventmask = 
    		xcb_event_mask_t.XCB_EVENT_MASK_EXPOSURE | 
    		xcb_event_mask_t.XCB_EVENT_MASK_KEY_PRESS | 
    		xcb_event_mask_t.XCB_EVENT_MASK_KEY_RELEASE |
    		xcb_event_mask_t.XCB_EVENT_MASK_BUTTON_PRESS | 
    		xcb_event_mask_t.XCB_EVENT_MASK_BUTTON_RELEASE |
    		xcb_event_mask_t.XCB_EVENT_MASK_BUTTON_MOTION |
    		xcb_event_mask_t.XCB_EVENT_MASK_POINTER_MOTION |
    		xcb_event_mask_t.XCB_EVENT_MASK_FOCUS_CHANGE;
    		
    	uint32_t valuelist[] = [ eventmask, colormap, 0 ];
    	uint32_t valuemask = xcb_cw_t.XCB_CW_EVENT_MASK | xcb_cw_t.XCB_CW_COLORMAP;// | xcb_cw_t.XCB_CW_BACK_PIXEL;// | xcb_cw_t.XCB_CW_BORDER_PIXEL | xcb_cw_t.XCB_CW_BIT_GRAVITY;

    	this.width = mode.width;
    	this.height= mode.height;
    	
    	this.lastKeyPressTime= 0;
    	this.lastKeyPressKeycode= 0;
    	
		xcb_create_window(
			connection,
			XCB_COPY_FROM_PARENT,
			window,
			screen.root,
			0, 0,
			mode.width, mode.height,
			0,
			xcb_window_class_t.XCB_WINDOW_CLASS_INPUT_OUTPUT,
			context.VisualId,
			valuemask,
			valuelist.ptr
		);
		
		SetTitle(title);
		
		
		auto Atom_Protocols	= x11connection.GetAtom("WM_PROTOCOLS",1);
		auto Atom_Close 	= x11connection.GetAtom("WM_DELETE_WINDOW",0);	
			
		xcb_change_property(connection, xcb_prop_mode_t.XCB_PROP_MODE_REPLACE, window, Atom_Protocols, 4, 32, 1, &Atom_Close);
	    xcb_flush(connection);
		
		auto glxwindow = glXCreateWindow( display, context.fbconfig, window, null );
		glxdrawable = glxwindow;
	}
		
	public final void Open  ( ) {
		if( !(style & Window_Hide ) )
			xcb_map_window(x11connection.GetConnection, window);
	}

	
	public final void Close ( ) {
		if( !(style & Window_Hide ) )
			xcb_unmap_window(x11connection.GetConnection, window);
	}
	
	public final void _Use( ) {
		context.MakeCurrent(glxdrawable);
	}
	
	public final void SetTitle ( string title ) {
		import std.string;
		
		xcb_change_property (x11connection.GetConnection,
             xcb_prop_mode_t.XCB_PROP_MODE_REPLACE,
             window,
             xcb_atom_enum_t.XCB_ATOM_WM_NAME,
             xcb_atom_enum_t.XCB_ATOM_STRING,
             8,
             cast(uint)title.length,
             cast(const(void*))title.toStringz() );
	}

	public final void _Swap ( ) {
		glFlush();
		glXSwapBuffers ( x11connection.GetDisplay, glxdrawable );
	}
	
	@property {
		public final pure nothrow uint	GetWidth ( ) { return width;  }
		public final pure nothrow uint	GetHeight( ) { return height; }
		public final pure nothrow uint	GetWidth ( uint _width  ) { return width  = _width;  }
		public final pure nothrow uint	GetHeight( uint _height ) { return height = _height; }
	}
	
	public  GLXDrawable 		glxdrawable;
	
	public  xcb_window_t		window;
	private xcb_colormap_t 		colormap;
	private xcb_atom_t			atomClose;
	
	private uint				id;
	
	public VideoMode			mode; 
	public string				title; 
	public uint					style;
	public dml_context			context;
	
	public uint width;
	public uint height;
	public uint lastKeyPressTime;
	public uint lastKeyPressKeycode;
}
