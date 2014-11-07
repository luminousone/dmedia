module deimos.gl.glx;

public:
	
version(Posix) {
		
	import x11.xlib;

	import deimos.gl.glcorearb;

		alias XID GLXContextID;
		alias XID GLXPixmap;
		alias XID GLXDrawable;
		alias XID GLXPbuffer;
		alias XID GLXWindow;
		alias XID GLXFBConfigID;
		
		struct __GLXcontextRec;
		alias __GLXcontextRec *GLXContext;
		
		struct __GLXFBConfigRec;
		alias __GLXFBConfigRec *GLXFBConfig;
		
		
		enum {
        GLX_USE_GL              = 1,    /* support GLX rendering */
        GLX_BUFFER_SIZE         = 2,    /* depth of the color buffer */
        GLX_LEVEL               = 3,    /* level in plane stacking */
        GLX_RGBA                = 4,    /* true if RGBA mode */
        GLX_DOUBLEBUFFER        = 5,    /* double buffering supported */
        GLX_STEREO              = 6,    /* stereo buffering supported */
        GLX_AUX_BUFFERS         = 7,    /* number of aux buffers */
        GLX_RED_SIZE            = 8,    /* number of red component bits */
        GLX_GREEN_SIZE          = 9,    /* number of green component bits */
        GLX_BLUE_SIZE           = 10,   /* number of blue component bits */
        GLX_ALPHA_SIZE          = 11,   /* number of alpha component bits */
        GLX_DEPTH_SIZE          = 12,   /* number of depth bits */
        GLX_STENCIL_SIZE        = 13,   /* number of stencil bits */
        GLX_ACCUM_RED_SIZE      = 14,   /* number of red accum bits */
        GLX_ACCUM_GREEN_SIZE    = 15,   /* number of green accum bits */
        GLX_ACCUM_BLUE_SIZE     = 16,   /* number of blue accum bits */
        GLX_ACCUM_ALPHA_SIZE    = 17,   /* number of alpha accum bits */
    /*
    ** FBConfig-specific attributes
    */
        GLX_X_VISUAL_TYPE       = 0x22,
        GLX_CONFIG_CAVEAT       = 0x20, /* Like visual_info VISUAL_CAVEAT_EXT */
        GLX_TRANSPARENT_TYPE    = 0x23,
        GLX_TRANSPARENT_INDEX_VALUE = 0x24,
        GLX_TRANSPARENT_RED_VALUE   = 0x25,
        GLX_TRANSPARENT_GREEN_VALUE = 0x26,
        GLX_TRANSPARENT_BLUE_VALUE  = 0x27,
        GLX_TRANSPARENT_ALPHA_VALUE = 0x28,
        GLX_DRAWABLE_TYPE       = 0x8010,
        GLX_RENDER_TYPE         = 0x8011,
        GLX_X_RENDERABLE        = 0x8012,
        GLX_FBCONFIG_ID         = 0x8013,
        GLX_MAX_PBUFFER_WIDTH   = 0x8016,
        GLX_MAX_PBUFFER_HEIGHT  = 0x8017,
        GLX_MAX_PBUFFER_PIXELS  = 0x8018,
        GLX_VISUAL_ID           = 0x800B,
    
    /*
    ** Error return values from glXGetConfig.  Success is indicated by
    ** a value of 0.
    */
        GLX_BAD_SCREEN      = 1,    /* screen # is bad */
        GLX_BAD_ATTRIBUTE   = 2,    /* attribute to get is bad */
        GLX_NO_EXTENSION    = 3,    /* no glx extension on server */
        GLX_BAD_VISUAL      = 4,    /* visual # not known by GLX */
        GLX_BAD_CONTEXT     = 5,    /* returned only by import_context EXT? */
        GLX_BAD_VALUE       = 6,    /* returned only by glXSwapIntervalSGI? */
        GLX_BAD_ENUM        = 7,    /* unused? */
    
    /* FBConfig attribute values */
    
    /*
    ** Generic "don't care" value for glX ChooseFBConfig attributes (except
    ** GLX_LEVEL)
    */
        GLX_DONT_CARE           = 0xFFFFFFFF,
    
    /* GLX_RENDER_TYPE bits */
        GLX_RGBA_BIT            = 0x00000001,
        GLX_COLOR_INDEX_BIT     = 0x00000002,
    
    /* GLX_DRAWABLE_TYPE bits */
        GLX_WINDOW_BIT          = 0x00000001,
        GLX_PIXMAP_BIT          = 0x00000002,
        GLX_PBUFFER_BIT         = 0x00000004,
    
    /* GLX_CONFIG_CAVEAT attribute values */
        GLX_NONE                = 0x8000,
        GLX_SLOW_CONFIG         = 0x8001,
        GLX_NON_CONFORMANT_CONFIG   = 0x800D,
    
    /* GLX_X_VISUAL_TYPE attribute values */
        GLX_TRUE_COLOR          = 0x8002,
        GLX_DIRECT_COLOR        = 0x8003,
        GLX_PSEUDO_COLOR        = 0x8004,
        GLX_STATIC_COLOR        = 0x8005,
        GLX_GRAY_SCALE          = 0x8006,
        GLX_STATIC_GRAY         = 0x8007,
    
    /* GLX_TRANSPARENT_TYPE attribute values */
    /*     GLX_NONE            0x8000 */
        GLX_TRANSPARENT_RGB     = 0x8008,
        GLX_TRANSPARENT_INDEX   = 0x8009,
    
    /* glXCreateGLXPbuffer attributes */
        GLX_PRESERVED_CONTENTS  = 0x801B,
        GLX_LARGEST_PBUFFER     = 0x801C,
        GLX_PBUFFER_HEIGHT      = 0x8040,   /* New for GLX 1.3 */
        GLX_PBUFFER_WIDTH       = 0x8041,   /* New for GLX 1.3 */
    
    /* glXQueryGLXPBuffer attributes */
        GLX_WIDTH       = 0x801D,
        GLX_HEIGHT      = 0x801E,
        GLX_EVENT_MASK  = 0x801F,
    
    /* glXCreateNewContext render_type attribute values */
        GLX_RGBA_TYPE           = 0x8014,
        GLX_COLOR_INDEX_TYPE    = 0x8015,
    
    /* glXQueryContext attributes */
    /*     GLX_FBCONFIG_ID        0x8013 */
    /*     GLX_RENDER_TYPE        0x8011 */
        GLX_SCREEN          = 0x800C,
    
    /* glXSelectEvent event mask bits */
        GLX_PBUFFER_CLOBBER_MASK    = 0x08000000,
    
    /* GLXPbufferClobberEvent event_type values */
        GLX_DAMAGED         = 0x8020,
        GLX_SAVED           = 0x8021,
    
    /* GLXPbufferClobberEvent draw_type values */
        GLX_WINDOW          = 0x8022,
        GLX_PBUFFER         = 0x8023,
    
    /* GLXPbufferClobberEvent buffer_mask bits */
        GLX_FRONT_LEFT_BUFFER_BIT   = 0x00000001,
        GLX_FRONT_RIGHT_BUFFER_BIT  = 0x00000002,
        GLX_BACK_LEFT_BUFFER_BIT    = 0x00000004,
        GLX_BACK_RIGHT_BUFFER_BIT   = 0x00000008,
        GLX_AUX_BUFFERS_BIT     = 0x00000010,
        GLX_DEPTH_BUFFER_BIT        = 0x00000020,
        GLX_STENCIL_BUFFER_BIT      = 0x00000040,
        GLX_ACCUM_BUFFER_BIT        = 0x00000080,
    
    /*
    ** Extension return values from glXGetConfig.  These are also
    ** accepted as parameter values for glXChooseVisual.
    */
    
        GLX_X_VISUAL_TYPE_EXT = 0x22,   /* visual_info extension type */
        GLX_TRANSPARENT_TYPE_EXT = 0x23,    /* visual_info extension */
        GLX_TRANSPARENT_INDEX_VALUE_EXT = 0x24, /* visual_info extension */
        GLX_TRANSPARENT_RED_VALUE_EXT   = 0x25, /* visual_info extension */
        GLX_TRANSPARENT_GREEN_VALUE_EXT = 0x26, /* visual_info extension */
        GLX_TRANSPARENT_BLUE_VALUE_EXT  = 0x27, /* visual_info extension */
        GLX_TRANSPARENT_ALPHA_VALUE_EXT = 0x28, /* visual_info extension */
    
    /* Property values for visual_type */
        GLX_TRUE_COLOR_EXT  = 0x8002,
        GLX_DIRECT_COLOR_EXT    = 0x8003,
        GLX_PSEUDO_COLOR_EXT    = 0x8004,
        GLX_STATIC_COLOR_EXT    = 0x8005,
        GLX_GRAY_SCALE_EXT  = 0x8006,
        GLX_STATIC_GRAY_EXT = 0x8007,
    
    /* Property values for transparent pixel */
        GLX_NONE_EXT        = 0x8000,
        GLX_TRANSPARENT_RGB_EXT     = 0x8008,
        GLX_TRANSPARENT_INDEX_EXT   = 0x8009,
    
    /* Property values for visual_rating */
        GLX_VISUAL_CAVEAT_EXT       = 0x20,  /* visual_rating extension type */
        GLX_SLOW_VISUAL_EXT     = 0x8001,
        GLX_NON_CONFORMANT_VISUAL_EXT   = 0x800D,
    
    /*
    ** Names for attributes to glXGetClientString.
    */
        GLX_VENDOR      = 0x1,
        GLX_VERSION     = 0x2,
        GLX_EXTENSIONS  = 0x3,
    
    /*
    ** Names for attributes to glXQueryContextInfoEXT.
    */
        GLX_SHARE_CONTEXT_EXT = 0x800A, /* id of share context */
        GLX_VISUAL_ID_EXT = 0x800B, /* id of context's visual */
        GLX_SCREEN_EXT = 0x800C,    /* screen number */
    
    /*
    * GLX 1.4 
    */
        GLX_SAMPLE_BUFFERS = 100000,
        GLX_SAMPLES = 100001,

    /*
    * GL bits 
    */
        GL_VIEWPORT = 0x0BA2
    }
		
		// glx glxext.h --
		
		enum : int {
			
			GLX_CONTEXT_DEBUG_BIT_ARB				= 0x00000001,
			GLX_CONTEXT_FORWARD_COMPATIBLE_BIT_ARB	= 0x00000002,
			GLX_CONTEXT_CORE_PROFILE_BIT_ARB		= 0x00000001,
			GLX_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB = 0x00000002,
			GLX_CONTEXT_MAJOR_VERSION_ARB			= 0x2091,
			GLX_CONTEXT_MINOR_VERSION_ARB			= 0x2092,
			GLX_CONTEXT_FLAGS_ARB					= 0x2094,
			GLX_CONTEXT_PROFILE_MASK_ARB			= 0x9126
		}
		
		// extern GLXContext glXCreateContextAttribsARB (Display *dpy, GLXFBConfig config, GLXContext share_context, Bool direct, const int *attrib_list);
		// function from glxext.h
		
		//extern(C) GLXContext glXCreateContextAttribsARB (Display *dpy, GLXFBConfig config, GLXContext share_context, Bool direct, const int *attrib_list);
		
		
		
		/************************************************************************/
		extern(C) XVisualInfo* glXChooseVisual (Display *dpy, int screen, int *attribList);
		extern(C) void glXCopyContext (Display *dpy, GLXContext src, GLXContext dst, uint mask);
		extern(C) GLXContext glXCreateContext (Display *dpy, XVisualInfo *vis, GLXContext shareList, Bool direct);
		extern(C) GLXPixmap glXCreateGLXPixmap (Display *dpy, XVisualInfo *vis, Pixmap pixmap);
		extern(C) void glXDestroyContext (Display *dpy, GLXContext ctx);
		extern(C) void glXDestroyGLXPixmap (Display *dpy, GLXPixmap pix);
		extern(C) int glXGetConfig (Display *dpy, XVisualInfo *vis, int attrib, int *value);
		extern(C) GLXContext glXGetCurrentContext ();
		extern(C) GLXDrawable glXGetCurrentDrawable ();
		extern(C) Bool glXIsDirect (Display *dpy, GLXContext ctx);
		extern(C) Bool glXMakeCurrent (Display *dpy, GLXDrawable drawable, GLXContext ctx);
		extern(C) Bool glXQueryExtension (Display *dpy, int *errorBase, int *eventBase);
		extern(C) Bool glXQueryVersion (Display *dpy, int *major, int *minor);
		extern(C) void glXSwapBuffers (Display *dpy, GLXDrawable drawable);
		extern(C) void glXUseXFont (Font font, int first, int count, int listBase);
		extern(C) void glXWaitGL ();
		extern(C) void glXWaitX ();
		extern(C) char * glXGetClientString (Display *dpy, int name );
		extern(C) char * glXQueryServerString (Display *dpy, int screen, int name );
		extern(C) char * glXQueryExtensionsString (Display *dpy, int screen );
		/* New for GLX 1.3 */
		extern(C) GLXFBConfig * glXGetFBConfigs (Display *dpy, int screen, int *nelements);
		extern(C) GLXFBConfig * glXChooseFBConfig (Display *dpy, int screen, int *attrib_list, int *nelements);
		extern(C) int glXGetFBConfigAttrib (Display *dpy, GLXFBConfig config, int attribute, int *value);
		extern(C) XVisualInfo * glXGetVisualFromFBConfig (Display *dpy, GLXFBConfig config);
		extern(C) GLXWindow glXCreateWindow (Display *dpy, GLXFBConfig config, Window win, int *attrib_list);
		extern(C) void glXDestroyWindow (Display *dpy, GLXWindow win);
		extern(C) GLXPixmap glXCreatePixmap (Display *dpy, GLXFBConfig config, Pixmap pixmap, int *attrib_list);
		extern(C) void glXDestroyPixmap (Display *dpy, GLXPixmap pixmap);
		extern(C) GLXPbuffer glXCreatePbuffer (Display *dpy, GLXFBConfig config, int *attrib_list);
		extern(C) void glXDestroyPbuffer (Display *dpy, GLXPbuffer pbuf);
		extern(C) void glXQueryDrawable (Display *dpy, GLXDrawable draw, int attribute, uint *value);
		extern(C) GLXContext glXCreateNewContext (Display *dpy, GLXFBConfig config, int render_type, GLXContext share_list, Bool direct);
		extern(C) Bool glXMakeContextCurrent (Display *display, GLXDrawable draw, GLXDrawable read, GLXContext ctx);
		extern(C) GLXDrawable glXGetCurrentReadDrawable ();
		extern(C) Display * glXGetCurrentDisplay ();
		extern(C) int glXQueryContext (Display *dpy, GLXContext ctx, int attribute, int *value);
		extern(C) void glXSelectEvent (Display *dpy, GLXDrawable draw, uint event_mask);
		extern(C) void glXGetSelectedEvent (Display *dpy, GLXDrawable draw, uint *event_mask);
		extern(C) int XDefaultScreen (Display * dpy);
		/*** SGI GLX extensions */
		extern(C) GLXContextID glXGetContextIDEXT (GLXContext ctx);
		extern(C) GLXDrawable glXGetCurrentDrawableEXT ();
		extern(C) GLXContext glXImportContextEXT (Display *dpy, GLXContextID contextID);
		extern(C) void glXFreeContextEXT (Display *dpy, GLXContext ctx);
		extern(C) int glXQueryContextInfoEXT (Display *dpy, GLXContext ctx, int attribute, int *value);

		//alias nothrow void function(GLubyte *) glXGetProcAddressARB;
		extern(C) void * glXGetProcAddressARB(GLubyte *);

		
		/*** Should these go here, or in another header? */
		/*
		** GLX Events
		*/
		struct GLXPbufferClobberEvent {
		    int event_type;		/* GLX_DAMAGED or GLX_SAVED */
		    int draw_type;		/* GLX_WINDOW or GLX_PBUFFER */
		    size_t serial;	/* # of last request processed by server */
		    Bool send_event;		/* true if this came for SendEvent request */
		    Display *display;		/* display the event was read from */
		    GLXDrawable drawable;	/* XID of Drawable */
		    uint buffer_mask;	/* mask indicating which buffers are affected */
		    uint aux_buffer;	/* which aux buffer was affected */
		    int x, y;
		    int width, height;
		    int count;			/* if nonzero, at least this many more */
		} 

		union __GLXEvent {
		    GLXPbufferClobberEvent glxpbufferclobber;
		    size_t pad[24];
		}
		alias __GLXEvent GLXEvent;
	
}
