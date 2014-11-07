module application.intent;

import application.state;
import application.manager;


/****************************
 * BlankState used for a empty template fill in for intents that don't involve State data
 * 
 */
class BlankState : State {
	this( Manager manager ) {
		super(manager,this);
	}
}

enum : uint {
	INTENT_FINISH	= 1,
	INTENT_START	= 2,
	INTENT_STOP 	= 3
}

interface Intent {
	
	public State make( Manager manager );
	
	@property{
		public pure uint action(             );
		public pure uint action( uint action );
	}
}

class dml_intent( type ) : Intent {
	private uint _action;
	
	this( uint _action ) {
		this._action = _action;
	}
	
	public final State make( Manager manager ) {
		return new type( manager );
	}
	
	
	@property{
		public pure final uint action(              ) { return this._action; }
		public pure final uint action( uint _action ) { return (this._action = _action); }
	}
}