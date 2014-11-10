/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module application.state;

import std.stdio;

import core.sync.condition;
import core.sync.mutex;
import core.thread;
import std.concurrency;

public import application.resource;
import application.manager;

import window.drawable;
import window.window;

import system.event;
import system.types;

/****************************
 * Actions enum
 * 
 */
enum : uint {
	ACTION_STOP = 1,
	ACTION_SWAP	= 2,
	ACTION_USE	= 3
}

/****************************
 * State will create and add members marked with the @resource UDA to the resource list
 * State will also calls onCreate and onDestroy on items in the resource list.
 * A DrawQueue is created as well, along with some basic built in commands(swap,use)
 *
 */
class State {
	
	public this( type )( Manager manager, type instance ) {
		this.manager = manager;
		wire(instance);
		
		mutex = new Mutex;
		condition = new Condition(mutex);
	}
	
	@disable public this( State );
	
	/****************************
	 * wire searchs member variables of type 
	 * for the resource attribute and adds them to the resource list
	 *
	 * Params:
	 *		instance =		instance of type that will be wired
	 *
	 */
	private final void wire( type )( type instance ) {
		
		import std.typetuple : TypeTuple;
	
		foreach( member ; __traits(allMembers, type ) ) {
           static if(         __traits(compiles, __traits( getMember, type, member)) && 
               __traits(compiles, __traits( getAttributes, __traits( getMember, type, member)))) {
               	
               foreach( attribute ; __traits( getAttributes, __traits( getMember, instance, member))) {
                  if( is(attribute : resource) ) {
                      alias TypeTuple!(__traits(getMember, instance, member)) memberReference;
                      __traits( getMember, instance, member ) = new typeof(memberReference[0]);
                      resources ~= __traits( getMember, instance, member );
                  }
              }
	       }
       }
	}
	
	/****************************
	 * calls onCreate for resource objects and starts draw queue thread
	 *
	 */
	public void onCreate ( ) {
		
		foreach( item ; resources ) {
			item.onCreate();
		}

		synchronized(mutex) {
			drawQueue = new Thread( &this.DrawQueue );
			drawQueue.start;
			condition.wait;
		}
	}
	
	/****************************
	 * calls onStart for resource objects
	 *
	 */
	public void onStart ( ) {
		foreach( item ; resources ) {
			item.onStart();
		}
	}
	
	public void onRun ( ) {
		
	}
	
	
	/****************************
	 * calls onStop for resource objects
	 *
	 */
	public void onStop ( ) {
		foreach( item ; resources ) {
			item.onStop();
		}
	}
	
	/****************************
	 * calls onDestroy for resource objects and stops draw queue thread
	 *
	 */
	public void onDestroy ( ) {
		send(drawTid, ACTION_STOP, cast(uint)0, false );
		drawQueue.join( );
		foreach( item ; resources ) {
			item.onDestroy();
		}
	}
	
	
	
	//
	//	Event functions
	//
	
	public final void doEvents ( ) {
		
		dml_event event;
		while( PollEvent( event ) ) {
			if( onEventFilter(event) ) 
				continue;
				
			switch(event.type) {
				case KeyPress:
					onKeyboardEvent( true , event.keyboard.key, event.keyboard.window );
				break;
				
				case KeyRelease:
					onKeyboardEvent( false, event.keyboard.key, event.keyboard.window );
				break;
				
				case Resize:
					onResizeEvent( event.resize.x, event.resize.y, event.resize.w, event.resize.h, event.resize.window );
				break;
				
				case GainedFocus:
					onGainedFocusEvent( event.window );
				break;
				
				case LostFocus:
					onLostFocusEvent( event.window );
				break;
				
				case ExitApp:
					onExitEvent( );
				break;
				
				case Close:
					onCloseEvent( event.window );
				break;
				
				case MouseButtonPress:
				
				break;
				
				case MouseButtonRelease:
				
				break;
				
				case MouseMovement:
				
				break;
				
				default:
				break;
			}
			
		}
	}
	
	/****************************
	 * Event filter function
	 *
	 * Params:
	 *		event =		event to be handled
	 *
	 */
	public bool onEventFilter( dml_event event ) {
		return false;
	}
	
	/****************************
	 * Window keyboard event
	 *
	 * Params:
	 *		pressed=	true for key pressed, false for key released
	 *		key =		key value
	 *		window =	window that received gained focus event
	 *
	 */
	public void onKeyboardEvent( bool pressed, uint key, WindowID window ) {
	}
	
	/****************************
	 * Window resize event
	 *
	 * Params:
	 *		x =			x position of window
	 *		y =			y position of window
	 *		w =			new window width
	 *		h =			new window height
	 *		window =	window that received close event
	 *
	 */
	public void onResizeEvent( uint x, uint y, uint w, uint h, WindowID ) {
	}
	
	/****************************
	 * Window gained focus event
	 *
	 * Params:
	 *		window =	window that received gained focus event
	 *
	 */
	public void onGainedFocusEvent( WindowID window ) {
	}
	
	/****************************
	 * Window lost focus event
	 *
	 * Params:
	 *		window =	window that received lost focus event
	 *
	 */
	public void onLostFocusEvent( WindowID window ) {
	}
	
	
	/****************************
	 * Application exit event
	 *
	 */
	public void onExitEvent( ) {
	}
	
	/****************************
	 * Window close event
	 *
	 * Params:
	 *		window =	window that received close event
	 *
	 */
	public void onCloseEvent( WindowID window ) {
	}
	
	
	/****************************
	 * Sends drawable object to the draw queue thread
	 *
	 * Params:
	 *		drawable = 	drawable object to be queued
	 *
	 */
	protected final void Draw( dml_drawable drawable ) {
		send(drawTid, cast(shared)drawable);
	}
	
	
	/****************************
	 * Sends swap command to the draw queue thread
	 *
	 * Params:
	 *		window =	window that swap will be called for
	 *		blocking =	if true will hold thread until command has been called
	 *
	 */
	protected final void Swap( dml_window window, bool blocking = true ) {
		if( blocking == true ) {
			synchronized(mutex) {
				send(drawTid, ACTION_SWAP, window.GetID,true);
				condition.wait;
			}
		} else {
			send(drawTid, ACTION_SWAP, window.GetID,false);
		}
	}
	
	/****************************
	 * Sends use command to the draw queue thread
	 *
	 * Params:
	 *		window =	window that use will be called for
	 *		blocking =	if true will hold calling thread until command has been called
	 *
	 */
	protected final void Use( dml_window window, bool blocking = true ) {
		if( blocking == true ) {
			synchronized(mutex) {
				send(drawTid, ACTION_USE, window.GetID,true);
				condition.wait;
			}
		} else {
			send(drawTid, ACTION_USE, window.GetID,false);
		}
	}
	
	/****************************
	 * DrawQueue thread function
	 *
	 */
	private final void DrawQueue( ) {
		
		synchronized(mutex) {
			drawTid = thisTid;
			condition.notifyAll;
		}
		bool running = true;
		while(running) {
			receive(
				( uint action, uint id, bool block ) {
					auto msgFunc = () {
						switch(action) {
							case ACTION_SWAP:
								GetWindowByID(id)._Swap();
							break;
							case ACTION_USE:
								GetWindowByID(id)._Use();
							break;
							case ACTION_STOP:
								running = false;
							break;
							default:
							break;
						}
					};
					if( block == true ) {
						synchronized(mutex) {
							msgFunc();
							condition.notifyAll;
						}
					} else {
						msgFunc();
					}
				},
				(shared(dml_drawable) shared_drawable) {
					auto drawable = cast(dml_drawable)shared_drawable;
					drawable.Draw();
				}
			);
		}
	}
	
	private Thread		drawQueue;
	private Thread		loadQueue;
	
	private Tid			drawTid;
	
	private Mutex		mutex;
	private Condition	condition;
	
	public Manager		manager;
	alias  manager		this;
	
	private dml_resource[]	resources;
	
}
