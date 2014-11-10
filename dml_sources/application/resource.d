/********
 * 
 * Authors: Ronald D. Hunt
 * Copywrite: 2014
 * Date: October 13, 2014
 * History:
 *		1.0 initial version
 * License: see license.txt
 */
module application.resource;

enum resource;

interface dml_resource {
	
	public void onCreate ( );
	public void onStart  ( );
	public void onStop   ( );
	public void onDestroy( );
}

