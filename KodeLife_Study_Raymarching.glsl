#version 150

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform vec3 spectrum;

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform sampler2D texture3;
uniform sampler2D prevFrame;
uniform sampler2D prevPass;

in VertexData
{
    vec4 v_position;
    vec3 v_normal;
    vec2 v_texcoord;
} inData;

out vec4 fragColor;

vec3 L = normalize(vec3(1., 1., -.5));

float sdSphere(vec3 p, float s)
{
    return length(p) - s;
}

mat2 rot(float a)
{
    return mat2(cos(a), sin(a), -sin(a), cos(a));
}

float map(vec3 p)
{
    p = mod( p, 5.0 ) - 2.5;
    return sdSphere(p, 1.);
}

vec3 makeN(vec3 p)
{
    vec2 eps = vec2(.001, 0.);
    return normalize(vec3(map(p + eps.xyy) - map(p - eps.xyy), 
                          map(p + eps.yxy) - map(p - eps.yxy), 
                          map(p + eps.yyx) - map(p - eps.yyx)));
}

void main(void)
{
    vec2 uv = (2. * gl_FragCoord.xy - resolution.xy) / min(resolution.x, resolution.y);
    
    vec3 ro = vec3(0., 0., 5.);
    vec3 rd = normalize(vec3(uv, -1));
    vec3 col = vec3(0.);
    
    float dist = 0.;
    float hit;
    vec3 rp = ro + rd * dist;
    
    
    for(int i=0;i<64;i++)
    {
        dist = map(rp);
        
        if(dist < 0.0001)
        {
            vec3 N = makeN(rp);
            float diff = dot(N, L);
            col = vec3(1., 1., 1.) + diff;
            break;
        }
        
        hit += dist;
        rp = ro + rd * hit;
    }
    
    fragColor = vec4(col, 1.0);
}