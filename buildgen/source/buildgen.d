module buildgen;

import std.xml;
import std.file;
import std.stdio;
import std.array;

string mainSource = q"EOS
module generated.main;

import application.manager;
import application.state;
import application.intent;
import $$STATE_MODULE$$.$$STATE_NAME$$;

void main()
{
	Manager manager = new Manager( new dml_intent!$$INITIAL_STATE$$(INTENT_START) );

	manager.Start();
}
EOS";

struct State {
	string name;
	string location;
}

int main( string[] args ) {
	
	string manifest = cast(string)std.file.read("manifest.xml");
	
	check(manifest);
	
	string initialState;
	State[string] stateList;
	
	auto xml = new DocumentParser(manifest);
	
	xml.onStartTag["States"] = (ElementParser xml) {
		xml.onEndTag["InitialState"] = ( in Element e) { initialState = e.text(); };
		xml.onEndTag["State"] = ( in Element e) { State s; s.name = e.tag.attr["name"]; s.location = e.tag.attr["module"]; stateList[e.tag.attr["name"]] = s;};
		xml.parse();
	};
	xml.parse();
	
	mainSource = replace(mainSource,"$$INITIAL_STATE$$", initialState);
	mainSource = replace(mainSource,"$$STATE_MODULE$$", stateList[initialState].location);
	mainSource = replace(mainSource,"$$STATE_NAME$$", stateList[initialState].name);
	
	std.file.write("generated/main.d", mainSource );
	
	return 0;
}