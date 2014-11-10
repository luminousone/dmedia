module system.types;
	
alias uint	WindowID;
alias uint	WindowMSG;

enum : uint {
	Window_Hide = 1
}

struct VideoMode
{
	private ushort _width, _height;
	private bool _fullScreen;
	
	public static VideoMode opCall( ushort _width, ushort _height, bool _fullScreen = false) {
		VideoMode mode;
		mode._width		 = _width;
		mode._height	 = _height;
		mode._fullScreen = _fullScreen;
		return mode;
	}
	
	@property {
		public pure ushort width     () nothrow { return _width;      }
		public pure ushort height    () nothrow { return _height;     }
		public pure uint fullScreen() nothrow { return _fullScreen; }
	}
	
	invariant() {
		assert( _width > 0 );
		assert( _height > 0 );
	}
}


struct KeyboardEvent {
	uint type;
	WindowID window;
	
	uint key;
	bool pressed;
	
	public void opCall( uint type, WindowID _window, uint key, bool pressed ) {
		
		this.type    = type;
		this.window = _window;
		this.key     = key;
		this.pressed = pressed;
	}
}

enum : uint {
	ButtonLeft		= 1,
	ButtonRight		= 2,
	ButtonMiddle	= 3,
	WheelUp			= 4,
	WheelDown		= 5,
	WheelLeft		= 6,
	WheelRight		= 7,
	XButton1		= 8,
	XButton2		= 9,
	XButton3		= 10
}

struct Mouse {
	
	uint type;
	WindowID window;
	uint x,y;
	uint button;
	
	public void opCall( uint type, WindowID window, uint x, uint y, uint button ) {
		this.type	= type;
		this.window = window;
		this.x		= x;
		this.y		= y;
		this.button = button;
	}
}


struct ResizeEvent {
	uint type;
	WindowID window;
	
	uint x,y,w,h;
	
	public void opCall( uint type, WindowID _window, uint x, uint y, uint w, uint h ) {
		
		this.type   = type;
		this.window = _window;
		this.x 		= x;
		this.y 		= y;
		this.w 		= w;
		this.h 		= h;
	}
}

// event types
enum : uint {
	None				= 0,
	KeyPress			= 1,
	KeyRelease			= 2,
	MouseButtonPress	= 3,
	MouseButtonRelease	= 4,
	MouseEntered		= 5,
	MouseLeft			= 6,
	MouseMovement		= 7,
	GainedFocus			= 8,
	LostFocus			= 9,
	Resize				= 10,
	Close				= 11,
	ExitApp				= 12
}


struct dml_event {
	union {
		struct {
			uint type;
			WindowID window;
		}
		KeyboardEvent	keyboard;
		Mouse			mouse;
		ResizeEvent 	resize;
	}

	public static dml_event opCall( uint type = None, WindowID _window = 0) {
		dml_event e;
		e.type = type;
		e.window = _window;
		return e;
	}
}