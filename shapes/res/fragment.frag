#version 330 core
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265359
#define TWO_PI 6.28318530718

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    st.x *= u_resolution.x/u_resolution.y;
    vec3 color = vec3(0.0);
    float d = 0.0;

    st = st * 2.-1.;

    int N = 5;
    
    float a = atan(st.x, st.y)+PI;
    float r = TWO_PI/float(N);

    d = cos(floor(.5+a/r)*r-a)*length(st);
    
    color = vec3(1.0 - smoothstep(0.4, 0.41, d));
    gl_FragColor = vec4(color,1.0);
}
