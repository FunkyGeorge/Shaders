#version 330 core
uniform vec2 u_resolution;

float edge(in vec2 st, in vec2 origin) {
    float x = step(origin.x + 0.01, st.x) +
        step(st.x, origin.x - 0.01) +
        step(st.y, origin.y);
    float y = step(origin.y + 0.01, st.y) +
        step(st.y, origin.y - 0.01) +
        step(st.x, origin.x);
    return x * y;
}

void main()
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec3 color = vec3(0.0);
    
    float r = 1.0;
    float g = 1.0;
    float b = 1.0;

    r *= step(st.x, 0.8) + step(0.1, st.y) * step(0.1, st.y);

    g *= step(0.2, st.x) + step(st.y, 0.6) * step(st.y, 0.6);
    g *= step(st.x, 0.8) + step(0.1, st.y) * step(0.1, st.y);

    b *= step(0.2, st.x) + step(st.y, 0.6) * step(st.y, 0.6);
    b *= step(st.x, 0.95) + step(st.y, 0.6) * step(st.y, 0.6);

    float pct = edge(st, vec2(0.2, 0.8));
    pct *= edge(st, vec2(0.05, 0.6));
    pct *= edge(st, vec2(0.2, 0.1));
    pct *= edge(st, vec2(0.8, 0.1));
    pct *= edge(st, vec2(0.95, 0.8));

    pct *= edge(1 - st, vec2(0.05, 0.2));
    pct *= edge(1 - st, vec2(0.8, 0.2));
    pct *= edge(1 - st, vec2(0.2, 0.4));
    
    color = vec3(r,g,b) * vec3(pct);
    gl_FragColor = vec4(color,1.0);
}
