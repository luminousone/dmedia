/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module system.event;


import window.window;
import system.types;

import xcb.xcb;

import window.window;
import system.windowimpl;
import system.connection;

import std.c.stdlib : free;

public static bool PollEvent( ref dml_event event ) {
	
	xcb_generic_event_t *xevent = xcb_poll_for_event(x11connection.GetConnection);
    if( xevent is null) {
        return false;
    }
    event(None);
    scope(exit) free(xevent);
    
    
    
    switch( xevent.response_type & ~0x80 )
    {
    	case XCB_DESTROY_NOTIFY:
    		event(ExitApp);
    	break;
    	
    	case XCB_FOCUS_IN:
    		auto focus = cast(xcb_focus_in_event_t *)xevent;
    		event(GainedFocus,current_x11windows[focus.event]);
    	break;
    	
    	case XCB_FOCUS_OUT:
    		auto focus = cast(xcb_focus_in_event_t *)xevent;
    		event(LostFocus,current_x11windows[focus.event]);
    	break;
        
        case XCB_CONFIGURE_NOTIFY:  
        	auto notify = cast(xcb_configure_notify_event_t *)xevent;
        	auto _window = GetWindowByID(current_x11windows[notify.window]);
        	if( 
        		(_window.GetWidth  != notify.width) || 
        		(_window.GetHeight != notify.height) 
        		) {
        		
        		event.resize(
        			Resize,
        			current_x11windows[notify.event],
        			notify.x,
        			notify.y,
        			notify.width,
        			notify.height);
        		
        		_window.GetWidth = notify.width;
        		_window.GetHeight= notify.height;
        	}
        break;
    	
    	case XCB_CLIENT_MESSAGE:
    		auto client = cast(xcb_client_message_event_t *)xevent;
    		if( ( client.data.data32[0] == x11connection.GetAtom("WM_DELETE_WINDOW",0)) ) {
    			event(
    				Close,
    				current_x11windows[client.window]);
    		}
    	break;
    	
        case XCB_KEY_PRESS:
        	auto kb = cast(xcb_key_press_event_t *)xevent;
        	auto _window = GetWindowByID(current_x11windows[kb.event]);
        	auto _x11window = cast(WindowImpl)_window.impl;
        	if( !((_x11window.lastKeyPressKeycode == kb.detail) && 
        		(_x11window.lastKeyPressTime - kb.time < 2 )) ) {
        		
        		_x11window.lastKeyPressKeycode	= kb.detail;
        		_x11window.lastKeyPressTime		= kb.time;
        		
        		auto sym0 = xcb_key_press_lookup_keysym(x11connection.GetKeySymbols,kb,0);
        		auto sym1 = xcb_key_press_lookup_keysym(x11connection.GetKeySymbols,kb,1);
        		
        		import std.stdio;
        		writeln("syms: ", sym0, " ", sym1 );
        		event.keyboard(KeyPress, current_x11windows[kb.event], sym0, true );
        	}
        break;
        
        case XCB_KEY_RELEASE:
        	auto kb = cast(xcb_key_press_event_t *)xevent; 
        	auto _window = current_x11windows[kb.event];
        	
        	auto sym0 = xcb_key_release_lookup_keysym(x11connection.GetKeySymbols,kb,0);
        		
            event.keyboard(KeyRelease, _window, sym0,false);
        break;
        
        case XCB_BUTTON_PRESS:
        	auto mbutton = cast(xcb_button_press_event_t *)xevent;
        	uint button;
        	final switch( mbutton.detail ) {
        		case 1: button = ButtonLeft;	break;
        		case 2: button = ButtonRight;	break;
        		case 3: button = ButtonMiddle;	break;
        		case 4: button = WheelUp;		break;
        		case 5: button = WheelDown;		break;
        		case 6: button = WheelLeft;		break;
        		case 7: button = WheelRight;	break;
        		case 8: button = XButton1;		break;
        		case 9: button = XButton2; 		break;
        		case 10:button = XButton3; 		break;
        	}
        	event.mouse(
        		MouseButtonPress,
        		current_x11windows[mbutton.event],
        		mbutton.event_x,
        		mbutton.event_y,
        		button);
        break;
        
        case XCB_BUTTON_RELEASE:
        	auto mbutton = cast(xcb_button_press_event_t *)xevent;
        	uint button;
        	final switch( mbutton.detail ) {
        		case 1: button = ButtonLeft;	break;
        		case 2: button = ButtonRight;	break;
        		case 3: button = ButtonMiddle;	break;
        		case 4: button = WheelUp;		break;
        		case 5: button = WheelDown;		break;
        		case 6: button = WheelLeft;		break;
        		case 7: button = WheelRight;	break;
        		case 8: button = XButton1;		break;
        		case 9: button = XButton2; 		break;
        		case 10:button = XButton3; 		break;
        	}
        	event.mouse(
        		MouseButtonRelease, 
        		current_x11windows[mbutton.event],
        		mbutton.event_x,
        		mbutton.event_y,
        		button);
        
        break;
        
        case XCB_MOTION_NOTIFY:
        	auto motion = cast(xcb_motion_notify_event_t *)xevent;
        	event.mouse(
        		MouseMovement,
        		current_x11windows[motion.event],
        		motion.event_x,
        		motion.event_y,
        		0);
        break;
        
        case XCB_ENTER_NOTIFY:
        	auto notify = cast(xcb_enter_notify_event_t *)xevent;
        	if( notify.mode == xcb_notify_mode_t.XCB_NOTIFY_MODE_NORMAL ) {
        		event(
        			MouseEntered,
        			current_x11windows[notify.event]);
        	}
        break;
        
        case XCB_LEAVE_NOTIFY:
        	auto notify = cast(xcb_enter_notify_event_t *)xevent;
        	if( notify.mode == xcb_notify_mode_t.XCB_NOTIFY_MODE_NORMAL ) {
        		event(
        			MouseLeft,
        			current_x11windows[notify.event]);
        	}
        break;
        
        case XCB_REPARENT_NOTIFY:
        	xcb_flush(x11connection.GetConnection);
        break;
         
        default:
        	event(None);
        break;
    }

	return true;
}