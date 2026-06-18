#version 330 core
#define PI 3.14159265359
#define TWO_PI 6.28318530718
uniform vec2 u_resolution;
uniform float u_time;

vec3 colorA = vec3(0.149, 0.141, 0.912);
vec3 colorB = vec3(1.000, 0.833, 0.224);

float plot (vec2 st, float pct) {
    return smoothstep(pct-0.01, pct, st.y) -
        smoothstep(pct, pct+0.01, st.y);
}

vec3 hsb2rgb( in vec3 c ) {
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                    6.0)-3.0)-1.0,
            0.0,
            1.0);
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

void main()
{
    // Gradients
    // vec2 st = gl_FragCoord.xy/u_resolution.xy;
    // vec3 color = vec3(0.0);
    // vec3 pct = vec3(st.x);
    //
    // pct.r = smoothstep(0.0, 1.0, st.x);
    // pct.g = sin(st.x*PI);
    // pct.b = pow(st.x,0.5);
    //
    // color = mix(colorA, colorB, pct);
    //
    // // Plot transition lines for each channel
    // color = mix(color, vec3(1.0, 0.0, 0.0), plot(st, pct.r));
    // color = mix(color, vec3(0.0, 1.0, 0.0), plot(st, pct.g));
    // color = mix(color, vec3(0.0, 0.0, 1.0), plot(st, pct.b));
    //
    // gl_FragColor = vec4(color, 1.0);

    // HSB
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec3 color = vec3(0.0);

    vec2 toCenter = vec2(0.5)-st;
    float angle = atan(toCenter.y, toCenter.x) + u_time;
    float radius = length(toCenter)*2.0;

    color = hsb2rgb(vec3((angle/TWO_PI)+0.5,radius,1.0));
    gl_FragColor = vec4(color,1.0);
}
