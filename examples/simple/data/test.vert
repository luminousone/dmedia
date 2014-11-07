#version 330

in  vec3 position;

void main(void) {

	gl_Position.xyz = position.xyz;
	gl_Position.w   = 1.0;
}