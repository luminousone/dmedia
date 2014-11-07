/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.linux_x11.x11context;

version( Posix ) {
	
	
	// X11 libraries
	import x11.xlib;
	import xcb.xcb;
	
	import window.windowimpl;
	import window.linux_x11.x11windowimpl;
	import window.linux_x11.x11connection;
	
	import window.contextimpl;
	
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
	
	class dml_x11context : dml_contextImpl {
		
		private GLXContext	context;
		private GLXFBConfig	_fbConfig;
		private int[]		glAttr;
		
		public final this( dml_contextImpl shared_context ) {
			auto parent = cast(dml_x11context)shared_context;
			
			super( 
				parent._glmajor,
				parent._glminor,
				parent._bpp,
				parent._depth,
				parent._stencil,
				parent._samples);
			
			_isShared	= true;
			
			glAttr		= parent.glAttr.dup;
			_fbConfig	= parent._fbConfig;
			
			if( glXCreateContextAttribsARB is null ) {
				glXCreateContextAttribsARB = cast( glXCreateContextAttribsARBproc )
				glXGetProcAddressARB( cast(ubyte*)std.string.toStringz("glXCreateContextAttribsARB") );
			}
			
			context = glXCreateContextAttribsARB( x11connection.GetDisplay, _fbConfig, parent.context , True, glAttr.ptr );
		}
		
		public final this( uint _glmajor = 3, uint _glminor = 1, uint _bpp = 32, uint _depth = 24, uint _stencil = 0, uint _samples = 0 ) {
			
			super( _glmajor,_glminor,_bpp,_depth,_stencil,_samples );
			
			//
			// Open X11 connection
			//
			if( x11connection is null ) {
				x11connection = new dml_x11Connection();
			}	
			
			_fbConfig = GetVisual( );
			
			if( glXCreateContextAttribsARB is null ) {
				glXCreateContextAttribsARB = cast( glXCreateContextAttribsARBproc )
				glXGetProcAddressARB( cast(ubyte*)std.string.toStringz("glXCreateContextAttribsARB") );
			}
		
			glAttr = 
			[
				GLX_CONTEXT_MAJOR_VERSION_ARB, glmajor,
				GLX_CONTEXT_MINOR_VERSION_ARB, glminor,
				GLX_CONTEXT_FLAGS_ARB, GLX_CONTEXT_DEBUG_BIT_ARB,
				GLX_CONTEXT_PROFILE_MASK_ARB, GLX_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB,
				None
			];
			
			context = glXCreateContextAttribsARB( x11connection.GetDisplay, _fbConfig, null , True, glAttr.ptr );	
		}
		
		public final void MakeCurrent( GLXDrawable drawable ) {
			
			if( !glXMakeContextCurrent( x11connection.GetDisplay, drawable, drawable, context ) ) {
				throw new Exception("unable to make context current");
		    }
		}
		
		
		public final void MakeCurrent( dml_windowImpl window ) {
			auto x11window = cast(dml_x11WindowImpl)window;
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
	}
	
}