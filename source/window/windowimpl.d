/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.windowimpl;

interface dml_windowImpl {
	
	import window.videomode;
	import window.context;

	public void Create		( dml_videoMode mode, string title, uint style, dml_context context );
	public void Open		( );
	public void Close  		( );
	public void _Use		( );
	public void SetTitle	( string title );
	public void _Swap		( );
	
	@property {
		public pure nothrow uint	GetWidth ( );
		public pure nothrow uint	GetHeight( );
		public pure nothrow uint	GetWidth ( uint );
		public pure nothrow uint	GetHeight( uint );
	}
}
