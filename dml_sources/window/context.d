/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.context;

import system.context;

/****************************
 * OpenGL context
 *
 */
class dml_context {
	
	public ContextImpl impl;
	
	alias impl this;
	
	/****************************
	 * constructor for OpenGL context
	 *
	 * Params:
	 *		_glmajor =		major version number for OpenGL
	 *		_glminor =		minor version number for OpenGL
	 *		_bpp	 =		bits per pixel
	 *		_depth	 =		depth buffer bits
	 *		_stencil =		stencil bits
	 *		_samples =		AntiAliasing samples
	 *
	 */
	public this( uint glmajor = 4, uint glminor = 2, uint bpp = 32, uint depth = 24, uint stencil = 0, uint samples = 0 ) {
		
		impl = new ContextImpl( glmajor, glminor, bpp, depth, stencil, samples );

	}
	
	
	/****************************
	 * constructor for OpenGL context
	 *
	 * Params:
	 *		shared_context  =	OpenGL context to get resources from
	 *
	 */
	public this( dml_context shared_context ) {
		impl = new ContextImpl(shared_context);
	}
}
