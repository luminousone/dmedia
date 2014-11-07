dmedia
======

dmedia is a media library.

Currently it only has linux X11 support, but I plan on adding windows support.

How dmedia differs from other media libraries, is its entirely written in D, its not just a wrapper around SDL, or SFML, it directly uses XCB/XLIB/GLX to create opengl Contexts, and open windows for drawing into via opengl in X11.

dmedia also differs from SDL, and SFML, in that it uses XCB for event handling and opening windows, This solves a great number of problems with multithreaded applications accessing the connection X11 from different threads.

Currently the library features,

- draw thread that drawable objects can be sent to.
- simple state manager
- states that somewhat resemble android activities supporting a similar lifecycle (onCreate->onStart->onRun->onStop->onDestroy)
- states expose events through overloadable functions, 
- automatic wiring of resource objects


Do note that not all opengl resources are shared across Contexts, VAO's have to be created in your drawable objects draw function so that the draw threads context can use them, most other opengl resources are shared.


