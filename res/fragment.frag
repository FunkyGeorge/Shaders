#version 330 core
uniform vec2 u_resolution;

float plot(vec2 st, float pct) {
    return smoothstep(pct-0.02, pct, st.y) -
            smoothstep(pct, pct+0.02, st.y);
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    float y = clamp(mod(st.x, 0.5), 0.0, 0.2);

    vec3 color = vec3(y);

    // Plot a line
    float pct = plot(st, y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color, 1.0);
}
