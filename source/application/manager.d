/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module application.manager;

import std.container;

import application.state;
import application.intent;

class Manager {
	
	private DList!State		stateQueue;
	private Intent			intent;
	
	this( Intent _intent) {
		stateQueue  = make!( DList!State  )( );
		intent = _intent;
	}
	
	void StartState( state )( ) {
		intent = new dml_intent!state( INTENT_START );
	}
	
	public final void Finish( ) {
		intent = new dml_intent!BlankState( INTENT_FINISH );
	}
	 
	@property public final bool isRunning( ) { return intent is null ? true : false; }
	
	void Start( ) {
		State currentState = null;
		bool running = true;
		while( running ) {
			
			if( intent !is null ) {
				switch( intent.action ) {
					case INTENT_START:
					if( currentState !is null )
						currentState.onStop( );
						
					currentState = intent.make(this);
					stateQueue.insertFront( currentState );
					currentState.onCreate( );
					currentState.onStart ( );
					break;
					case INTENT_FINISH:
					currentState.onStop   ( );
					currentState.onDestroy( );
					stateQueue.removeFront( );
					delete currentState;
					if( stateQueue.empty() )
						return;
					currentState = stateQueue.front( );
					currentState.onStart( );
					
					break;
					default:
					break;
				}
				delete intent;
				intent = null;
			}
			
			if( running == true ) {
				currentState.onStart( );
				while( currentState.isRunning ) {
					currentState.onRun( );
					currentState.doEvents( );
				}
			}
		}
	}
}