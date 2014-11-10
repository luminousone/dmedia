module generated.main;

import application.manager;
import application.state;
import application.intent;
import source.basicState;

void main()
{
	Manager manager = new Manager( new dml_intent!basicState(INTENT_START) );

	manager.Start();
}
