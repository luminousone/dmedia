/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module system.context;


import std.algorithm : find;

// X11 libraries
import x11.xlib;
import xcb.xcb;

import system.windowimpl;
import system.connection;
import system.types;

// opengl glx libraries
import deimos.gl.glx;

alias extern(C) GLXContext function(
	Display*, 
	GLXFBConfig, 
	GLXContext, 
	Bool, 
	const int*) glXCreateContextAttribsARBproc;

private glXCreateContextAttribsARBproc 
	glXCreateContextAttribsARB = null;

class ContextImpl {

	protected uint	_glmajor;
	protected uint	_glminor;
	protected uint	_bpp; 
	protected uint	_depth; 
	protected uint	_stencil; 
	protected uint	_samples;
	protected uint	_isShared;
	
	private GLXContext	context;
	private GLXFBConfig	_fbConfig;
	private int[]		glAttr;
	
	public final this( ContextImpl shared_context ) {
		auto parent = shared_context;
		
		this._glmajor   = _glmajor;
		this._glminor   = _glminor;
		this._bpp       = _bpp;
		this._depth     = _depth;
		this._stencil   = _stencil;
		this._samples   = _samples;
		this._isShared   = false;
		
		_isShared	= true;
		
		glAttr		= parent.glAttr.dup;
		_fbConfig	= parent._fbConfig;
		
		import std.string : toStringz;
		
		if( glXCreateContextAttribsARB is null ) {
			glXCreateContextAttribsARB = cast( glXCreateContextAttribsARBproc )
			glXGetProcAddressARB( cast(ubyte*)toStringz("glXCreateContextAttribsARB") );
		}
		
		context = glXCreateContextAttribsARB( x11connection.GetDisplay, _fbConfig, parent.context , True, glAttr.ptr );
	}
	
	public final this( uint _glmajor = 3, uint _glminor = 1, uint _bpp = 32, uint _depth = 24, uint _stencil = 0, uint _samples = 0 ) {
		
		this._glmajor   = _glmajor;
		this._glminor   = _glminor;
		this._bpp       = _bpp;
		this._depth     = _depth;
		this._stencil   = _stencil;
		this._samples   = _samples;
		this._isShared   = false;
		
		//
		// Open X11 connection
		//
		if( x11connection is null ) {
			x11connection = new x11Connection();
		}	
		
		_fbConfig = GetVisual( );
		
		import std.string : toStringz;
		if( glXCreateContextAttribsARB is null ) {
			glXCreateContextAttribsARB = cast( glXCreateContextAttribsARBproc )
			glXGetProcAddressARB( cast(ubyte*)toStringz("glXCreateContextAttribsARB") );
		}
	
		glAttr = 
		[
			GLX_CONTEXT_MAJOR_VERSION_ARB, glmajor,
			GLX_CONTEXT_MINOR_VERSION_ARB, glminor,
			GLX_CONTEXT_FLAGS_ARB, GLX_CONTEXT_DEBUG_BIT_ARB,
			GLX_CONTEXT_PROFILE_MASK_ARB, GLX_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB,
			x11.xlib.None
		];
		
		context = glXCreateContextAttribsARB( x11connection.GetDisplay, _fbConfig, null , True, glAttr.ptr );	
	}
	
	public final void MakeCurrent( GLXDrawable drawable ) {
		
		if( !glXMakeContextCurrent( x11connection.GetDisplay, drawable, drawable, context ) ) {
			throw new Exception("unable to make context current");
	    }
	}
	
	
	public final void MakeCurrent( WindowImpl window ) {
		auto x11window = cast(WindowImpl)window;
		MakeCurrent(x11window.glxdrawable);
	}
	
	@property {
		public final pure	GLXFBConfig	fbconfig( ) { return _fbConfig; }
		public final		int			VisualId( ) { 
			int vid = 0; 
			glXGetFBConfigAttrib( x11connection.GetDisplay, _fbConfig, GLX_VISUAL_ID, &vid ); 
			return vid; 
		}
	}
	
	private final GLXFBConfig GetVisual( ) {
		
		int fbcount;
		GLXFBConfig * fbc;
		GLXFBConfig result;
		
		auto display = x11connection.GetDisplay;
		
		fbc = glXGetFBConfigs( display, DefaultScreen(*display),  &fbcount );
		XSync(display,false);
		for( int i = 0 ; i < fbcount ; i++ ) {
			int r,g,b,a,depth,stencil,samples,doublebuffer;
			
			// get color bit size
			glXGetFBConfigAttrib( display, fbc[i], GLX_RED_SIZE,     &r );
			glXGetFBConfigAttrib( display, fbc[i], GLX_GREEN_SIZE,   &g );
			glXGetFBConfigAttrib( display, fbc[i], GLX_BLUE_SIZE,    &b );
			glXGetFBConfigAttrib( display, fbc[i], GLX_ALPHA_SIZE,   &a );
			glXGetFBConfigAttrib( display, fbc[i], GLX_DEPTH_SIZE,   &depth );
			glXGetFBConfigAttrib( display, fbc[i], GLX_STENCIL_SIZE, &stencil );
			glXGetFBConfigAttrib( display, fbc[i], GLX_SAMPLES,      &samples );
			glXGetFBConfigAttrib( display, fbc[i], GLX_DOUBLEBUFFER, &doublebuffer  );
			
			switch(bpp){
				case 32:
					if( r != 8 || g != 8 || b != 8 || a != 8 ) {
						// not 32bit color mode
						continue;
					}
					break;
				default:
					throw new Exception("Unknown or unsupported visual mode");							
			}
			
			if(	depth   == depth && 
				stencil == stencil && 
				samples == samples  && 
				doublebuffer != 0 ) {
				result = fbc[i];
				XFree( fbc );
				return result;
			}
			
		}
		XFree( fbc );
		throw new Exception("Unknown visual mode");
	}
	

	@property {
		
		public final pure uint glmajor  () nothrow { return _glmajor;   }
		public final pure uint glminor  () nothrow { return _glminor;   }
		public final pure uint bpp      () nothrow { return _bpp;       }
		public final pure uint depth    () nothrow { return _depth;     }
		public final pure uint stencil  () nothrow { return _stencil;   }
		public final pure uint samples  () nothrow { return _samples;   }
		public final pure uint isShared () nothrow { return _isShared;  }
	}
}