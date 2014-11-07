/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.videomode;

final class dml_videoMode
{
	private ushort _width, _height;
	private bool _fullScreen;
	
	public this( ushort _width, ushort _height, bool _fullScreen = false) {
		this._width		 = _width;
		this._height	 = _height;
		this._fullScreen = _fullScreen;
	}
	
	@property {
		public pure ushort width     () nothrow { return _width;      }
		public pure ushort height    () nothrow { return _height;     }
		public pure uint fullScreen() nothrow { return _fullScreen; }
	}
	
	invariant() {
		assert( _width > 0 );
		assert( _height > 0 );
	}
}
