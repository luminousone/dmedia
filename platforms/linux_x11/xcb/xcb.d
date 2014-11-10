/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module xcb.xcb;

version ( Posix ) {

import x11.xlib;

extern( System ) {
	
	alias uint   uint32_t;
	alias ushort uint16_t;
	alias ubyte   uint8_t;
	
	alias int   int32_t;
	alias short int16_t;
	alias byte   int8_t;
	
	alias uint32_t	xcb_window_t;
	alias uint32_t	xcb_colormap_t;
	alias uint32_t	xcb_visualid_t;
	alias uint8_t 	xcb_keycode_t;
	alias uint32_t	xcb_keysym_t;
	alias uint32_t	xcb_timestamp_t;
	alias uint32_t	xcb_atom_t;
	alias uint8_t	xcb_button_t;
	
	immutable ulong XCB_NONE = 0;
	immutable ulong XCB_COPY_FROM_PARENT = 0;
	immutable ulong XCB_CURRENT_TIME = 0;
	immutable ulong XCB_NO_SYMBOL = 0;
	
	immutable ulong XCB_KEY_PRESS    	= 2;
	immutable ulong XCB_KEY_RELEASE  	= 3;
	immutable ulong XCB_BUTTON_PRESS	= 4;
	immutable ulong XCB_BUTTON_RELEASE	= 5;
	immutable ulong XCB_MOTION_NOTIFY  	= 6;
	immutable ulong XCB_ENTER_NOTIFY   	= 7;
	immutable ulong XCB_LEAVE_NOTIFY	= 8;
	immutable ulong XCB_FOCUS_IN		= 9;
	immutable ulong XCB_FOCUS_OUT		= 10;
	immutable ulong XCB_KEYMAP_NOTIFY	= 11;
	immutable ulong XCB_EXPOSE 			= 12;
	immutable ulong XCB_GRAPHICS_EXPOSURE= 13;
	immutable ulong XCB_NO_EXPOSURE		= 14;
	immutable ulong XCB_VISIBILITY_NOTIFY= 15;
	immutable ulong XCB_CREATE_NOTIFY	= 16;
	immutable ulong XCB_DESTROY_NOTIFY	= 17;
	immutable ulong XCB_UNMAP_NOTIFY	= 18;
	immutable ulong XCB_MAP_NOTIFY		= 19;
	immutable ulong XCB_MAP_REQUEST		= 20;
	immutable ulong XCB_REPARENT_NOTIFY	= 21;
	immutable ulong XCB_CONFIGURE_NOTIFY= 22;
	immutable ulong XCB_CONFIGURE_REQUEST= 23;
	immutable ulong XCB_GRAVITY_NOTIFY	= 24;
	immutable ulong XCB_RESIZE_REQUEST	= 25;
	immutable ulong XCB_CIRCULATE_NOTIFY= 26;
	immutable ulong XCB_CIRCULATE_REQUEST= 27;
	immutable ulong XCB_PROPERTY_NOTIFY	= 28;
	immutable ulong XCB_SELECTION_CLEAR	= 29;
	immutable ulong XCB_SELECTION_REQUEST= 30;
	immutable ulong XCB_SELECTION_NOTIFY= 31;
	immutable ulong XCB_COLORMAP_NOTIFY = 32;
	immutable ulong XCB_CLIENT_MESSAGE	= 33;
	immutable ulong XCB_MAPPING_NOTIFY	= 34;
	
	enum xcb_button_mask_t {
	    XCB_BUTTON_MASK_1 = 256,
	    XCB_BUTTON_MASK_2 = 512,
	    XCB_BUTTON_MASK_3 = 1024,
	    XCB_BUTTON_MASK_4 = 2048,
	    XCB_BUTTON_MASK_5 = 4096,
	    XCB_BUTTON_MASK_ANY = 32768
    };
	
	
	struct xcb_screen_t {
	    xcb_window_t   root; /**<  */
	    xcb_colormap_t default_colormap; /**<  */
	    uint32_t       white_pixel; /**<  */
	    uint32_t       black_pixel; /**<  */
	    uint32_t       current_input_masks; /**<  */
	    uint16_t       width_in_pixels; /**<  */
	    uint16_t       height_in_pixels; /**<  */
	    uint16_t       width_in_millimeters; /**<  */
	    uint16_t       height_in_millimeters; /**<  */
	    uint16_t       min_installed_maps; /**<  */
	    uint16_t       max_installed_maps; /**<  */
	    xcb_visualid_t root_visual; /**<  */
	    uint8_t        backing_stores; /**<  */
	    uint8_t        save_unders; /**<  */
	    uint8_t        root_depth; /**<  */
	    uint8_t        allowed_depths_len; /**<  */
	};
	
	struct xcb_screen_iterator_t {
	    xcb_screen_t *data; /**<  */
	    int           rem; /**<  */
	    int           index; /**<  */
	};
	
	struct xcb_setup_t {
	    uint8_t       status; /**<  */
	    uint8_t       pad0; /**<  */
	    uint16_t      protocol_major_version; /**<  */
	    uint16_t      protocol_minor_version; /**<  */
	    uint16_t      length; /**<  */
	    uint32_t      release_number; /**<  */
	    uint32_t      resource_id_base; /**<  */
	    uint32_t      resource_id_mask; /**<  */
	    uint32_t      motion_buffer_size; /**<  */
	    uint16_t      vendor_len; /**<  */
	    uint16_t      maximum_request_length; /**<  */
	    uint8_t       roots_len; /**<  */
	    uint8_t       pixmap_formats_len; /**<  */
	    uint8_t       image_byte_order; /**<  */
	    uint8_t       bitmap_format_bit_order; /**<  */
	    uint8_t       bitmap_format_scanline_unit; /**<  */
	    uint8_t       bitmap_format_scanline_pad; /**<  */
	    xcb_keycode_t min_keycode; /**<  */
	    xcb_keycode_t max_keycode; /**<  */
	    uint8_t       pad1[4]; /**<  */
	};

	struct xcb_connection_t;
	
	struct xcb_generic_iterator_t {
	void *data;   /**< Data of the current iterator */
    	int rem;    /**< remaining elements */
    	int index;  /**< index of the current iterator */
    };
	
	struct xcb_generic_reply_t {
		uint8_t   response_type;  /**< Type of the response */
    	uint8_t  pad0;           /**< Padding */
    	uint16_t sequence;       /**< Sequence number */
    	uint32_t length;         /**< Length of the response */
    };
	
	struct xcb_generic_event_t {
		uint8_t   response_type;  /**< Type of the response */
    	uint8_t  pad0;           /**< Padding */
    	uint16_t sequence;       /**< Sequence number */
    	uint32_t pad[7];         /**< Padding */
    	uint32_t full_sequence;  /**< full sequence */
    };
	
	struct xcb_ge_event_t {
		uint8_t  response_type;  /**< Type of the response */
    	uint8_t  pad0;           /**< Padding */
    	uint16_t sequence;       /**< Sequence number */
    	uint32_t length;
    	uint16_t event_type;
    	uint16_t pad1;
    	uint32_t pad[5];         /**< Padding */
    	uint32_t full_sequence;  /**< full sequence */
    };
	
	struct xcb_generic_error_t {
		uint8_t   response_type;  /**< Type of the response */
    	uint8_t   error_code;     /**< Error code */
    	uint16_t sequence;       /**< Sequence number */
    	uint32_t resource_id;     /** < Resource ID for requests with side effects only */
    	uint16_t minor_code;      /** < Minor opcode of the failed request */
    	uint8_t major_code;       /** < Major opcode of the failed request */
    	uint8_t pad0;
    	uint32_t pad[5];         /**< Padding */
    	uint32_t full_sequence;  /**< full sequence */
    };
	
	struct xcb_void_cookie_t {
		uint sequence;  /**< Sequence number */
    };
	
	enum xcb_mod_mask_t {
	    XCB_MOD_MASK_SHIFT = 1,
	    XCB_MOD_MASK_LOCK = 2,
	    XCB_MOD_MASK_CONTROL = 4,
	    XCB_MOD_MASK_1 = 8,
	    XCB_MOD_MASK_2 = 16,
	    XCB_MOD_MASK_3 = 32,
	    XCB_MOD_MASK_4 = 64,
	    XCB_MOD_MASK_5 = 128,
	    XCB_MOD_MASK_ANY = 32768
	}
	
	enum xcb_key_but_mask_t {
	    XCB_KEY_BUT_MASK_SHIFT = 1,
	    XCB_KEY_BUT_MASK_LOCK = 2,
	    XCB_KEY_BUT_MASK_CONTROL = 4,
	    XCB_KEY_BUT_MASK_MOD_1 = 8,
	    XCB_KEY_BUT_MASK_MOD_2 = 16,
	    XCB_KEY_BUT_MASK_MOD_3 = 32,
	    XCB_KEY_BUT_MASK_MOD_4 = 64,
	    XCB_KEY_BUT_MASK_MOD_5 = 128,
	    XCB_KEY_BUT_MASK_BUTTON_1 = 256,
	    XCB_KEY_BUT_MASK_BUTTON_2 = 512,
	    XCB_KEY_BUT_MASK_BUTTON_3 = 1024,
	    XCB_KEY_BUT_MASK_BUTTON_4 = 2048,
	    XCB_KEY_BUT_MASK_BUTTON_5 = 4096
	}
	
	struct xcb_key_press_event_t {
	    uint8_t         response_type; /**<  */
	    xcb_keycode_t   detail; /**<  */
	    uint16_t        sequence; /**<  */
	    xcb_timestamp_t time; /**<  */
	    xcb_window_t    root; /**<  */
	    xcb_window_t    event; /**<  */
	    xcb_window_t    child; /**<  */
	    int16_t         root_x; /**<  */
	    int16_t         root_y; /**<  */
	    int16_t         event_x; /**<  */
	    int16_t         event_y; /**<  */
	    uint16_t        state; /**<  */
	    uint8_t         same_screen; /**<  */
	    uint8_t         pad0; /**<  */
    }
	
	struct xcb_button_press_event_t {
	    uint8_t         response_type; /**<  */
	    xcb_button_t    detail; /**<  */
	    uint16_t        sequence; /**<  */
	    xcb_timestamp_t time; /**<  */
	    xcb_window_t    root; /**<  */
	    xcb_window_t    event; /**<  */
	    xcb_window_t    child; /**<  */
	    int16_t         root_x; /**<  */
	    int16_t         root_y; /**<  */
	    int16_t         event_x; /**<  */
	    int16_t         event_y; /**<  */
	    uint16_t        state; /**<  */
	    uint8_t         same_screen; /**<  */
	    uint8_t         pad0; /**<  */
	}
	
	alias xcb_button_press_event_t xcb_button_release_event_t;
	
	struct xcb_mapping_notify_event_t { 
		uint8_t response_type; 
		uint8_t pad0; 
		uint16_t sequence; 
		uint8_t request; 
		xcb_keycode_t first_keycode; 
		uint8_t count; 
		uint8_t pad1; 
	}
	
	struct xcb_expose_event_t{
        uint8_t      response_type; /* The type of the event, here it is XCB_EXPOSE */
        uint8_t      pad0;
        uint16_t     sequence;
        xcb_window_t window;        /* The Id of the window that receives the event (in case */
                                    /* our application registered for events on several windows */
        uint16_t     x;             /* The x coordinate of the top-left part of the window that needs to be redrawn */
        uint16_t     y;             /* The y coordinate of the top-left part of the window that needs to be redrawn */
        uint16_t     width;         /* The width of the part of the window that needs to be redrawn */
        uint16_t     height;        /* The height of the part of the window that needs to be redrawn */
        uint16_t     count;
    }
	
	struct xcb_configure_notify_event_t {
	    uint8_t      response_type; /**<  */
	    uint8_t      pad0; /**<  */
	    uint16_t     sequence; /**<  */
	    xcb_window_t event; /**<  */
	    xcb_window_t window; /**<  */
	    xcb_window_t above_sibling; /**<  */
	    int16_t      x; /**<  */
	    int16_t      y; /**<  */
	    uint16_t     width; /**<  */
	    uint16_t     height; /**<  */
	    uint16_t     border_width; /**<  */
	    uint8_t      override_redirect; /**<  */
	    uint8_t      pad1; /**<  */
    }
	
	struct xcb_motion_notify_event_t {
	    uint8_t         response_type; /**<  */
	    uint8_t         detail; /**<  */
	    uint16_t        sequence; /**<  */
	    xcb_timestamp_t time; /**<  */
	    xcb_window_t    root; /**<  */
	    xcb_window_t    event; /**<  */
	    xcb_window_t    child; /**<  */
	    int16_t         root_x; /**<  */
	    int16_t         root_y; /**<  */
	    int16_t         event_x; /**<  */
	    int16_t         event_y; /**<  */
	    uint16_t        state; /**<  */
	    uint8_t         same_screen; /**<  */
	    uint8_t         pad0; /**<  */
	}
	
	union xcb_client_message_data_t {
	    uint8_t  data8[20]; /**<  */
	    uint16_t data16[10]; /**<  */
	    uint32_t data32[5]; /**<  */
	}
	
	/**
	 * @brief xcb_client_message_data_iterator_t
	 **/
	struct xcb_client_message_data_iterator_t {
	    xcb_client_message_data_t *data; /**<  */
	    int                        rem; /**<  */
	    int                        index; /**<  */
	}
	
	/**
	 * @brief xcb_client_message_event_t
	 **/
	struct xcb_client_message_event_t {
	    uint8_t                   response_type; /**<  */
	    uint8_t                   format; /**<  */
	    uint16_t                  sequence; /**<  */
	    xcb_window_t              window; /**<  */
	    xcb_atom_t                type; /**<  */
	    xcb_client_message_data_t data; /**<  */
	}

	
	enum xcb_notify_detail_t {
	    XCB_NOTIFY_DETAIL_ANCESTOR = 0,
	    XCB_NOTIFY_DETAIL_VIRTUAL = 1,
	    XCB_NOTIFY_DETAIL_INFERIOR = 2,
	    XCB_NOTIFY_DETAIL_NONLINEAR = 3,
	    XCB_NOTIFY_DETAIL_NONLINEAR_VIRTUAL = 4,
	    XCB_NOTIFY_DETAIL_POINTER = 5,
	    XCB_NOTIFY_DETAIL_POINTER_ROOT = 6,
	    XCB_NOTIFY_DETAIL_NONE = 7
	}
	
	enum xcb_notify_mode_t {
	    XCB_NOTIFY_MODE_NORMAL = 0,
	    XCB_NOTIFY_MODE_GRAB = 1,
	    XCB_NOTIFY_MODE_UNGRAB = 2,
	    XCB_NOTIFY_MODE_WHILE_GRABBED = 3
	}
	
	struct xcb_enter_notify_event_t {
	    uint8_t         response_type; /**<  */
	    uint8_t         detail; /**<  */
	    uint16_t        sequence; /**<  */
	    xcb_timestamp_t time; /**<  */
	    xcb_window_t    root; /**<  */
	    xcb_window_t    event; /**<  */
	    xcb_window_t    child; /**<  */
	    int16_t         root_x; /**<  */
	    int16_t         root_y; /**<  */
	    int16_t         event_x; /**<  */
	    int16_t         event_y; /**<  */
	    uint16_t        state; /**<  */
	    uint8_t         mode; /**<  */
	    uint8_t         same_screen_focus; /**<  */
	}
	
	struct xcb_focus_in_event_t {
	    uint8_t      response_type; /**<  */
	    uint8_t      detail; /**<  */
	    uint16_t     sequence; /**<  */
	    xcb_window_t event; /**<  */
	    uint8_t      mode; /**<  */
	    uint8_t      pad0[3]; /**<  */
	}
	
	enum xcb_colormap_alloc_t {
		XCB_COLORMAP_ALLOC_NONE = 0,
		XCB_COLORMAP_ALLOC_ALL = 1
    };
	
	enum xcb_event_mask_t {
	    XCB_EVENT_MASK_NO_EVENT = 0,
	    XCB_EVENT_MASK_KEY_PRESS = 1,
	    XCB_EVENT_MASK_KEY_RELEASE = 2,
	    XCB_EVENT_MASK_BUTTON_PRESS = 4,
	    XCB_EVENT_MASK_BUTTON_RELEASE = 8,
	    XCB_EVENT_MASK_ENTER_WINDOW = 16,
	    XCB_EVENT_MASK_LEAVE_WINDOW = 32,
	    XCB_EVENT_MASK_POINTER_MOTION = 64,
	    XCB_EVENT_MASK_POINTER_MOTION_HINT = 128,
	    XCB_EVENT_MASK_BUTTON_1_MOTION = 256,
	    XCB_EVENT_MASK_BUTTON_2_MOTION = 512,
	    XCB_EVENT_MASK_BUTTON_3_MOTION = 1024,
	    XCB_EVENT_MASK_BUTTON_4_MOTION = 2048,
	    XCB_EVENT_MASK_BUTTON_5_MOTION = 4096,
	    XCB_EVENT_MASK_BUTTON_MOTION = 8192,
	    XCB_EVENT_MASK_KEYMAP_STATE = 16384,
	    XCB_EVENT_MASK_EXPOSURE = 32768,
	    XCB_EVENT_MASK_VISIBILITY_CHANGE = 65536,
	    XCB_EVENT_MASK_STRUCTURE_NOTIFY = 131072,
	    XCB_EVENT_MASK_RESIZE_REDIRECT = 262144,
	    XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY = 524288,
	    XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT = 1048576,
	    XCB_EVENT_MASK_FOCUS_CHANGE = 2097152,
	    XCB_EVENT_MASK_PROPERTY_CHANGE = 4194304,
	    XCB_EVENT_MASK_COLOR_MAP_CHANGE = 8388608,
	    XCB_EVENT_MASK_OWNER_GRAB_BUTTON = 16777216
    };
	
	enum xcb_cw_t {
	    XCB_CW_BACK_PIXMAP = 1,
	    XCB_CW_BACK_PIXEL = 2,
	    XCB_CW_BORDER_PIXMAP = 4,
	    XCB_CW_BORDER_PIXEL = 8,
	    XCB_CW_BIT_GRAVITY = 16,
	    XCB_CW_WIN_GRAVITY = 32,
	    XCB_CW_BACKING_STORE = 64,
	    XCB_CW_BACKING_PLANES = 128,
	    XCB_CW_BACKING_PIXEL = 256,
	    XCB_CW_OVERRIDE_REDIRECT = 512,
	    XCB_CW_SAVE_UNDER = 1024,
	    XCB_CW_EVENT_MASK = 2048,
	    XCB_CW_DONT_PROPAGATE = 4096,
	    XCB_CW_COLORMAP = 8192,
	    XCB_CW_CURSOR = 16384
    };
	
	enum xcb_window_class_t {
		XCB_WINDOW_CLASS_COPY_FROM_PARENT = 0,
    	XCB_WINDOW_CLASS_INPUT_OUTPUT = 1,
    	XCB_WINDOW_CLASS_INPUT_ONLY = 2
    };
	
	enum xcb_prop_mode_t {
		XCB_PROP_MODE_REPLACE = 0,
    	XCB_PROP_MODE_PREPEND = 1,
    	XCB_PROP_MODE_APPEND = 2
    }

    enum xcb_atom_enum_t {
	    XCB_ATOM_NONE = 0,
	    XCB_ATOM_ANY = 0,
	    XCB_ATOM_PRIMARY,
	    XCB_ATOM_SECONDARY,
	    XCB_ATOM_ARC,
	    XCB_ATOM_ATOM,
	    XCB_ATOM_BITMAP,
	    XCB_ATOM_CARDINAL,
	    XCB_ATOM_COLORMAP,
	    XCB_ATOM_CURSOR,
	    XCB_ATOM_CUT_BUFFER0,
	    XCB_ATOM_CUT_BUFFER1,
	    XCB_ATOM_CUT_BUFFER2,
	    XCB_ATOM_CUT_BUFFER3,
	    XCB_ATOM_CUT_BUFFER4,
	    XCB_ATOM_CUT_BUFFER5,
	    XCB_ATOM_CUT_BUFFER6,
	    XCB_ATOM_CUT_BUFFER7,
	    XCB_ATOM_DRAWABLE,
	    XCB_ATOM_FONT,
	    XCB_ATOM_INTEGER,
	    XCB_ATOM_PIXMAP,
	    XCB_ATOM_POINT,
	    XCB_ATOM_RECTANGLE,
	    XCB_ATOM_RESOURCE_MANAGER,
	    XCB_ATOM_RGB_COLOR_MAP,
	    XCB_ATOM_RGB_BEST_MAP,
	    XCB_ATOM_RGB_BLUE_MAP,
	    XCB_ATOM_RGB_DEFAULT_MAP,
	    XCB_ATOM_RGB_GRAY_MAP,
	    XCB_ATOM_RGB_GREEN_MAP,
	    XCB_ATOM_RGB_RED_MAP,
	    XCB_ATOM_STRING,
	    XCB_ATOM_VISUALID,
	    XCB_ATOM_WINDOW,
	    XCB_ATOM_WM_COMMAND,
	    XCB_ATOM_WM_HINTS,
	    XCB_ATOM_WM_CLIENT_MACHINE,
	    XCB_ATOM_WM_ICON_NAME,
	    XCB_ATOM_WM_ICON_SIZE,
	    XCB_ATOM_WM_NAME,
	    XCB_ATOM_WM_NORMAL_HINTS,
	    XCB_ATOM_WM_SIZE_HINTS,
	    XCB_ATOM_WM_ZOOM_HINTS,
	    XCB_ATOM_MIN_SPACE,
	    XCB_ATOM_NORM_SPACE,
	    XCB_ATOM_MAX_SPACE,
	    XCB_ATOM_END_SPACE,
	    XCB_ATOM_SUPERSCRIPT_X,
	    XCB_ATOM_SUPERSCRIPT_Y,
	    XCB_ATOM_SUBSCRIPT_X,
	    XCB_ATOM_SUBSCRIPT_Y,
	    XCB_ATOM_UNDERLINE_POSITION,
	    XCB_ATOM_UNDERLINE_THICKNESS,
	    XCB_ATOM_STRIKEOUT_ASCENT,
	    XCB_ATOM_STRIKEOUT_DESCENT,
	    XCB_ATOM_ITALIC_ANGLE,
	    XCB_ATOM_X_HEIGHT,
	    XCB_ATOM_QUAD_WIDTH,
	    XCB_ATOM_WEIGHT,
	    XCB_ATOM_POINT_SIZE,
	    XCB_ATOM_RESOLUTION,
	    XCB_ATOM_COPYRIGHT,
	    XCB_ATOM_NOTICE,
	    XCB_ATOM_FONT_NAME,
	    XCB_ATOM_FAMILY_NAME,
	    XCB_ATOM_FULL_NAME,
	    XCB_ATOM_CAP_HEIGHT,
	    XCB_ATOM_WM_CLASS,
	    XCB_ATOM_WM_TRANSIENT_FOR
    }
    
    enum xcb_config_window_t {
	    XCB_CONFIG_WINDOW_X = 1,
	    XCB_CONFIG_WINDOW_Y = 2,
	    XCB_CONFIG_WINDOW_WIDTH = 4,
	    XCB_CONFIG_WINDOW_HEIGHT = 8,
	    XCB_CONFIG_WINDOW_BORDER_WIDTH = 16,
	    XCB_CONFIG_WINDOW_SIBLING = 32,
	    XCB_CONFIG_WINDOW_STACK_MODE = 64
    }
    
    struct xcb_intern_atom_cookie_t {
    	uint sequence; /**<  */
    }
    
    struct xcb_intern_atom_reply_t {
           uint8_t    response_type;
           uint8_t    pad0;
           uint16_t   sequence;
           uint32_t   length;
           xcb_atom_t atom;
    }
    
    struct _XCBKeySymbols;
    alias _XCBKeySymbols xcb_key_symbols_t;
	xcb_key_symbols_t *xcb_key_symbols_alloc        (xcb_connection_t         *c);

	void xcb_key_symbols_free (xcb_key_symbols_t * syms);

	xcb_keysym_t xcb_key_symbols_get_keysym (xcb_key_symbols_t * syms, xcb_keycode_t keycode,int col);

	xcb_keysym_t xcb_key_press_lookup_keysym  (xcb_key_symbols_t * syms,xcb_key_press_event_t * event, int col );
	xcb_keysym_t xcb_key_release_lookup_keysym(xcb_key_symbols_t * syms,xcb_key_press_event_t * event, int col );
	int          xcb_refresh_keyboard_mapping (xcb_key_symbols_t * syms,xcb_mapping_notify_event_t *event);
	
	xcb_void_cookie_t xcb_configure_window (xcb_connection_t *c,            /* The connection to the X server*/
                                            xcb_window_t      window,       /* The window to configure */
                                            uint16_t          value_mask,   /* The mask */
                                            const uint32_t   *value_list);  /* The values to set */
	
	int                   xcb_flush                ( xcb_connection_t  * c );
	xcb_screen_iterator_t xcb_setup_roots_iterator ( const xcb_setup_t * R );
	
	const(xcb_setup_t *)  xcb_get_setup            ( xcb_connection_t  * c );
	
	void                  xcb_screen_next          ( xcb_screen_iterator_t *i  );
	uint32_t xcb_generate_id(xcb_connection_t *c);
	xcb_void_cookie_t
	xcb_create_colormap (xcb_connection_t *c  ,
                     uint8_t           alloc  ,
                     xcb_colormap_t    mid    ,
                     xcb_window_t      window ,
                     xcb_visualid_t    visual );
	
	xcb_void_cookie_t
	xcb_create_window (xcb_connection_t *c  ,
                   uint8_t           depth  ,
                   xcb_window_t      wid  ,
                   xcb_window_t      parent ,
                   int16_t           x  ,
                   int16_t           y  ,
                   uint16_t          width  ,
                   uint16_t          height  ,
                   uint16_t          border_width  ,
                   uint16_t          _class  ,
                   xcb_visualid_t    visual  ,
                   uint32_t          value_mask  ,
                   const uint32_t   *value_list  );
	
	xcb_void_cookie_t
	xcb_map_window (xcb_connection_t *c,
                xcb_window_t      window );
	
	xcb_void_cookie_t
	xcb_unmap_window (xcb_connection_t *c,
                xcb_window_t      window );
	
	xcb_generic_event_t *xcb_wait_for_event(xcb_connection_t *c);
	xcb_generic_event_t *xcb_poll_for_event(xcb_connection_t *c);
	
	xcb_void_cookie_t xcb_destroy_window (xcb_connection_t *c , xcb_window_t      window );

	xcb_void_cookie_t xcb_change_property (xcb_connection_t *,
                                           uint8_t,
                                           xcb_window_t,
                                           xcb_atom_t,
                                           xcb_atom_t,
                                           uint8_t, 
                                           uint32_t,
                                           const void      *);
	xcb_intern_atom_cookie_t xcb_intern_atom( xcb_connection_t *, uint8_t, uint16_t, const char *);
	
	xcb_intern_atom_reply_t *xcb_intern_atom_reply(
		xcb_connection_t *conn,
        xcb_intern_atom_cookie_t cookie, 
        xcb_generic_error_t **e);
	
	//void xcb_flush( xcb_connection_t * );
	
	xcb_connection_t * 	xcb_connect ( const char *, int * );
	void 	xcb_disconnect ( xcb_connection_t * );
}

}


