/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module x11.xlib;

version( Posix ) {
	
	import core.stdc.config;
	
	extern( System ) {
	alias ulong XID;
	alias ulong VisualID;
	alias ulong Atom;
	alias char * XPointer;
	alias XID Pixmap;
	alias XID Cursor;
	alias XID Colormap;
	alias XID Font;
	alias XID Window;
	alias XID GContext;
	
	alias int Status;
	
	alias bool Bool;
	immutable Bool True  = true;
	immutable Bool False = false;
	
	immutable uint None = 0;
	
	struct ScreenFormat {
		XExtData *ext_data;
		int depth;
		int bits_per_pixel;
		int scanline_pad;
	};
	
	struct _XPrivate;
	struct _XrmHashBucketRec;
	
	struct _XDisplay {
		XExtData *ext_data;
		_XPrivate *private1;
		int fd;
		int private2;
		int proto_major_version;
		int proto_minor_version;
		char *vendor;
		    XID private3;
		XID private4;
		XID private5;
		int private6;
		XID function( _XDisplay* ) resource_alloc;
		int byte_order;
		int bitmap_unit;
		int bitmap_pad;
		int bitmap_bit_order;
		int nformats;
		ScreenFormat *pixmap_format;
		int private8;
		int release;
		_XPrivate * private9 ,  private10;
		int qlen;
		ulong last_request_read;
		ulong request;
		XPointer private11;
		XPointer private12;
		XPointer private13;
		XPointer private14;
		uint max_request_size;
		_XrmHashBucketRec *db;
		int function( _XDisplay* ) private15;
		char *display_name;
		int default_screen;
		int nscreens;
		Screen *screens;
		ulong motion_buffer;
		ulong private16;
		int min_keycode;
		int max_keycode;
		XPointer private17;
		XPointer private18;
		int private19;
		char *xdefaults;
	};

	alias _XDisplay Display;
	
	struct XExtData {
		int number;
		XExtData *next;
		int function( XExtData *extension ) free_private;
		XPointer private_data;
	};
	
	struct Visual {
		XExtData *ext_data;
		VisualID visualid;
		int c_class;
		ulong red_mask, green_mask, blue_mask;
		int bits_per_rgb;
		int map_entries;
	};
	
	struct Depth{
		int depth;
		int nvisuals;
		Visual *visuals;
	};
	
	struct XVisualInfo{
		Visual *visual;
		VisualID visualid;
	    int screen;
	    int depth;
	    int c_class;
	    ulong red_mask;
	    ulong green_mask;
	    ulong blue_mask;
	    int colormap_size;
	    int bits_per_rgb;
	  };
	
	struct XSetWindowAttributes{
	    Pixmap background_pixmap;
	    ulong background_pixel;
	    Pixmap border_pixmap;
	    ulong border_pixel;
	    int bit_gravity;
	    int win_gravity;
	    int backing_store;
	    ulong backing_planes;
	    ulong backing_pixel;
	    Bool save_under;
	    long event_mask;
	    long do_not_propagate_mask;
	    Bool override_redirect;
	    Colormap colormap;
	    Cursor cursor;
    };
	
	struct Screen {
		XExtData *ext_data;
		Display *display;
		Window root;
		int width, height;
		int mwidth, mheight;
		int ndepths;
		Depth *depths;
		int root_depth;
		Visual *root_visual;
		GC default_gc;
		Colormap cmap;
		ulong white_pixel;
		ulong black_pixel;
		int max_maps, min_maps;
		int backing_store;
		Bool save_unders;
		long root_input_mask;
	};
	
	struct _XGC
	{
	    XExtData *ext_data;	/* hook for extension to hang data */
	    GContext gid;	/* protocol ID for graphics context */
	    /* there is more to this structure, but it is private to Xlib */
	};
	alias _XGC * GC;
	
	int         ConnectionNumber            ( ref Display dpy           )   { return dpy.fd;                                            }
	Window      RootWindow                  ( ref Display dpy,int scr   )   { return ScreenOfDisplay( dpy,scr ).root;                   }
	int         DefaultScreen               ( ref Display dpy           )   { return dpy.default_screen;                                }
	Window      DefaultRootWindow           ( ref Display dpy           )   { return ScreenOfDisplay( dpy,DefaultScreen( dpy ) ).root;  }
	Visual*     DefaultVisual               ( ref Display dpy,int scr   )   { return ScreenOfDisplay( dpy,scr ).root_visual;            }
	GC          DefaultGC                   ( ref Display dpy,int scr   )   { return ScreenOfDisplay( dpy,scr ).default_gc;             }
	uint        BlackPixel                  ( ref Display dpy,int scr   )   { return cast(uint)ScreenOfDisplay( dpy,scr ).black_pixel;  }
	uint        WhitePixel                  ( ref Display dpy,int scr   )   { return cast(uint)ScreenOfDisplay( dpy,scr ).white_pixel;  }
	c_ulong     AllPlanes                   (                           )   { return 0xFFFFFFFF;                                        }
	int         QLength                     ( ref Display dpy           )   { return dpy.qlen;                                          }
	int         DisplayWidth                ( ref Display dpy,int scr   )   { return ScreenOfDisplay( dpy,scr ).width;                  }
	int         DisplayHeight               ( ref Display dpy,int scr   )   { return ScreenOfDisplay( dpy,scr ).height;                 }
	int         DisplayWidthMM              ( ref Display dpy,int scr   )   { return ScreenOfDisplay( dpy,scr ).mwidth;                 }
	int         DisplayHeightMM             ( ref Display dpy,int scr   )   { return ScreenOfDisplay( dpy,scr ).mheight;                }
	int         DisplayPlanes               ( ref Display dpy,int scr   )   { return ScreenOfDisplay( dpy,scr ).root_depth;             }
	int         DisplayCells                ( ref Display dpy,int scr   )   { return DefaultVisual( dpy,scr ).map_entries;              }
	int         ScreenCount                 ( ref Display dpy           )   { return dpy.nscreens;                                      }
	char*       ServerVendor                ( ref Display dpy           )   { return dpy.vendor;                                        }
	int         ProtocolVersion             ( ref Display dpy           )   { return dpy.proto_major_version;                           }
	int         ProtocolRevision            ( ref Display dpy           )   { return dpy.proto_minor_version;                           }
	int         VendorRelease               ( ref Display dpy           )   { return dpy.release;                                       }
	char*       DisplayString               ( ref Display dpy           )   { return dpy.display_name;                                  }
	int         DefaultDepth                ( ref Display dpy,int scr   )   { return ScreenOfDisplay( dpy,scr ).root_depth;             }
	Colormap    DefaultColormap             ( ref Display dpy,int scr   )   { return ScreenOfDisplay( dpy,scr ).cmap;                   }
	int         BitmapUnit                  ( ref Display dpy           )   { return dpy.bitmap_unit;                                   }
	int         BitmapBitOrder              ( ref Display dpy           )   { return dpy.bitmap_bit_order;                              }
	int         BitmapPad                   ( ref Display dpy           )   { return dpy.bitmap_pad;                                    }
	//int         ImagecharOrder              ( ref Display dpy           )   { return dpy.char_order;                                    }
	uint        NextRequest                 ( ref Display dpy           )   { return cast(uint)dpy.request + 1;                         }
	uint        LastKnownRequestProcessed   ( ref Display dpy           )   { return cast(uint)dpy.last_request_read;                   }
	
	Screen*     ScreenOfDisplay             ( ref Display dpy,int scr   )   { return &dpy.screens[scr];                                  }
	Screen*     DefaultScreenOfDisplay      ( ref Display dpy           )   { return ScreenOfDisplay( dpy,DefaultScreen( dpy ) );       }
	Display*    DisplayOfScreen             ( Screen s                  )   { return s.display;                                         }
	Window      RootWindowOfScreen          ( Screen s                  )   { return s.root;                                            }
	uint        BlackPixelOfScreen          ( Screen s                  )   { return cast(uint)s.black_pixel;                           }
	uint        WhitePixelOfScreen          ( Screen s                  )   { return cast(uint)s.white_pixel;                           }
	Colormap    DefaultColormapOfScreen     ( Screen s                  )   { return s.cmap;                                            }
	int         DefaultDepthOfScreen        ( Screen s                  )   { return s.root_depth;                                      }
	GC          DefaultGCOfScreen           ( Screen s                  )   { return s.default_gc;                                      }
	Visual*     DefaultVisualOfScreen       ( Screen s                  )   { return s.root_visual;                                     }
	int         WidthOfScreen               ( Screen s                  )   { return s.width;                                           }
	int         HeightOfScreen              ( Screen s                  )   { return s.height;                                          }
	int         WidthMMOfScreen             ( Screen s                  )   { return s.mwidth;                                          }
	int         HeightMMOfScreen            ( Screen s                  )   { return s.mheight;                                         }
	int         PlanesOfScreen              ( Screen s                  )   { return s.root_depth;                                      }
	int         CellsOfScreen               ( Screen s                  )   { return DefaultVisualOfScreen( s ).map_entries;            }
	int         MinCmapsOfScreen            ( Screen s                  )   { return s.min_maps;                                        }
	int         MaxCmapsOfScreen            ( Screen s                  )   { return s.max_maps;                                        }
	Bool        DoesSaveUnders              ( Screen s                  )   { return s.save_unders;                                     }
	int         DoesBackingStore            ( Screen s                  )   { return s.backing_store;                                   }
	long        EventMaskOfScreen           ( Screen s                  )   { return s.root_input_mask;                                 }

	
	Display * XOpenDisplay( const char * );
	int       XCloseDisplay( Display * );
	Status    XInitThreads( );
	int       XSync( Display * , Bool );
	
	Colormap XCreateColormap( Display*, Window , Visual* , int );
	
	Window XCreateWindow(
	    Display*,
	    Window,
	    int,
	    int,
	    uint,
	    uint,
	    uint,
	    int,
	    uint,
	    Visual*,
	    ulong,
	    XSetWindowAttributes*
	);
	
	int XDestroyWindow(
		Display*,
    	Window
    );
	
	int XFreeColormap(
		Display* ,
    	Colormap
    );
	
	int XStoreName(
		Display *,
    	Window,
    	const char *
    );
	int XMapWindow(
		Display *,
    	Window
    );
	
	void XFlushGC(
		Display *,
    	GC
    );
	
	int XFlush(
		Display *
    );
	
	void XLockDisplay(
		Display *
    );
	
	void XUnlockDisplay(
		Display *
    );
	
	int XFree(
		void *
    );
	
	Atom XInternAtom(
	    Display*            /* display */,
	    const char*       /* atom_name */,
	    Bool                /* only_if_exists */
	);
	
	Status XSetWMProtocols(
	    Display*            /* display */,
	    Window              /* w */,
	    Atom*               /* protocols */,
	    int                 /* count */
	);
	
	}
	
}
