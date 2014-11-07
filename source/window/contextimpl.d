/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module window.contextimpl;

import std.algorithm;

class dml_contextImpl {

	protected uint	_glmajor;
	protected uint	_glminor;
	protected uint	_bpp; 
	protected uint	_depth; 
	protected uint	_stencil; 
	protected uint	_samples;
	protected uint	_isShared;
	
	public this( uint _glmajor = 4, uint _glminor = 2, uint _bpp = 32, uint _depth = 24, uint _stencil = 0, uint _samples = 0 ) {

		this._glmajor   = _glmajor;
		this._glminor   = _glminor;
		this._bpp       = _bpp;
		this._depth     = _depth;
		this._stencil   = _stencil;
		this._samples   = _samples;
		this._isShared   = false;
	}

	@property {
		
		public pure uint glmajor  () nothrow { return _glmajor;   }
		public pure uint glminor  () nothrow { return _glminor;   }
		public pure uint bpp      () nothrow { return _bpp;       }
		public pure uint depth    () nothrow { return _depth;     }
		public pure uint stencil  () nothrow { return _stencil;   }
		public pure uint samples  () nothrow { return _samples;   }
		public pure uint isShared () nothrow { return _isShared;  }
	}
	
	invariant() {
		
		assert( _bpp     >  0 && _bpp     <= 128 );
		assert( _depth   >= 0 && _depth   <=  32 );
		assert( _stencil >= 0 && _stencil <=   8 );
		assert( _samples >= 0 && _samples <=  16 );
		assert( 
	       ( _glmajor == 2 ? ( find( [ 0, 1 ], _glminor ).count ? true: false ) :
	 ( _glmajor == 3 ? ( find( [ 0, 1, 2, 3 ], _glminor ).count ? true: false ) :
	 ( _glmajor == 4 ? ( find( [ 0, 1, 2, 3 ], _glminor ).count ? true: false ) : false ) ) ),
	       "unsupported version of opengl"
	       );
		
	}
}
