/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module simple;

import std.traits;
import std.stdio;
import core.thread;

import deimos.gl.glcorearb;

import application.manager;
import application.state;
import application.intent;

import window.event;
import window.videomode;
import window.drawable;
import window.context;
import window.window;


class ClearScreen : dml_drawable {
	override
	public void Draw() {
		glClearColor(0.2, 0.4, 0.9, 1.0);
		glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	}
}

class ResizeScreen : dml_drawable {
	public uint x,y,w,h;
	this() {
		x = y = 0;
		w = 1024;
		h = 768;
	}
	override
	public void Draw() {
		glViewport(x,y,w,h);
	}
}

class Triangle : dml_drawable {
	
	GLuint	VertexArrayID;
	GLuint	vertexbuffer;
	GLuint	sp;
		
	override
	public void Draw() {

		if( !VertexArrayID ) {
			
			glGenVertexArrays ( 1, &VertexArrayID );
			glBindVertexArray(VertexArrayID);
			
				glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
				glVertexAttribPointer( 0, 3, GL_FLOAT, GL_FALSE, 0, cast(const GLvoid *)0 );
				glEnableVertexAttribArray(0);
	 		
	 		glBindVertexArray(0);
			
		}
		glUseProgram(sp);
		glBindAttribLocation(sp, 0, "position");
		
		glBindVertexArray(VertexArrayID);
		
		glDrawArrays(GL_TRIANGLES, 0, 3);

		glBindVertexArray(0);
		glUseProgram(0);
	}
	
	public this() {
		import std.string;
		import std.file;
		
		auto vert = (cast(string) read("data/test.vert")).toStringz();
		auto frag = (cast(string) read("data/test.frag")).toStringz();
		
		GLuint vs = glCreateShader(GL_VERTEX_SHADER);
		GLuint fs = glCreateShader(GL_FRAGMENT_SHADER);
		glShaderSource(vs, 1, cast(const(GLchar)**)&vert,cast(const(int)*)0);
		glShaderSource(fs, 1, cast(const(GLchar)**)&frag,cast(const(int)*)0);
		glCompileShader(vs);
		glCompileShader(fs);

		sp = glCreateProgram();
		glAttachShader(sp,vs);
		glAttachShader(sp,fs);
		glLinkProgram(sp);
		glUseProgram(sp);
		
		VertexArrayID = 0;
		
		float[] vertex_data = [
	   		-1.0f, -1.0f, 0.0f,
	   		 1.0f, -1.0f, 0.0f,
	   		 0.0f,  1.0f, 0.0f
		];
		
		glGenBuffers      ( 1, &vertexbuffer  );
 		glBindBuffer ( GL_ARRAY_BUFFER, vertexbuffer );
 		glBufferData ( GL_ARRAY_BUFFER, vertex_data.length*float.sizeof, vertex_data.ptr, GL_STATIC_DRAW);
 		glBindBuffer ( GL_ARRAY_BUFFER, 0 );
 		glFlush();
	}
}

class BasicState : State {
	
	@resource public dml_window hidden_window;
	@resource public dml_window window;
	
	dml_context loadContext;
	dml_context drawContext;
	
	ClearScreen	clear;
	ResizeScreen resize;
	Triangle triangle;
	
	public this( Manager manager ) {
		super(manager,this);
		
		loadContext = new dml_context( );
		drawContext = new dml_context( loadContext );
	}
	
	public ~this( ) {
		delete drawContext;
		delete loadContext;
	}
	
	override final
	void onCreate( ) {
		super.onCreate();
		
		hidden_window.Create( new dml_videoMode(   1,  1), "hidden_window",Window_Hide, loadContext );
		window.Create       ( new dml_videoMode(1024,768), "test"         ,0, drawContext );
		
		hidden_window._Use( );
		
		clear = new ClearScreen( );
		triangle   = new Triangle( );
		resize  = new ResizeScreen( );
	}
	
	override final
	void onRun( ) {
		Use(window);
		Draw(clear);
		Draw(triangle);
		Swap(window);
	
	}
	
	override
	public final void onCloseEvent( dml_window window ) {
	}
	
	override
	public final void onKeyboardEvent( bool pressed, uint key, dml_window window ) {
		if( key == 'q' ) {
			manager.Finish();
		}
	}
	
	override
	public final void onResizeEvent( uint x, uint y, uint w, uint h, dml_window window) {
		resize.x = x;
		resize.y = y;
		resize.w = w;
		resize.h = h;
		Use( window );
		Draw( resize );
	}
	
	override
	public void onExitEvent( ) {
		manager.Finish();
	}
}

void main()
{
	Manager manager = new Manager( new dml_intent!BasicState(INTENT_START) );

	manager.Start();
}


