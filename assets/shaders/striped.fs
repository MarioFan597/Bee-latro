#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 striped;
extern MY_HIGHP_OR_MEDIUMP float dissolve;
extern MY_HIGHP_OR_MEDIUMP float time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;
extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;
extern MY_HIGHP_OR_MEDIUMP float hovering; 

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.0) : tex.rgb, shadow ? tex.a * 0.3 : tex.a);
    }

    return vec4(shadow ? vec3(0.0) : tex.rgb, tex.a);
}

vec4 effect(vec4 fragColor, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 uv = texture_coords * image_details.xy / max(image_details.y, 1.0);

    // Incorporate mouse_screen_pos subtly
    float mouse_effect = length(uv - mouse_screen_pos / image_details.xy) * hovering * 0.05;

    // Use texture_details to normalize stripe width
    float stripeWidth = 0.1 * screen_scale * texture_details.x; // Ensures stripes scale with texture

    // Minor time-based variation to satisfy compiler
    float time_variation = 0.05 * sin(time * 0.5);  

    // Generate static vertical stripes based on y-coordinate, adjusted using texture_details
    float stripeIndex = mod(floor((uv.y * texture_details.y + time_variation) / stripeWidth), 2.0);

    // Set colors based on stripe index (Alternating Black & Yellow)
    if (stripeIndex == 0.0) {
        fragColor = mix(burn_colour_1, vec4(1.0, 1.0, 0.0, 0.7 - mouse_effect), 0.5);  // Yellow (Translucent)
    } else {
        fragColor = mix(burn_colour_2, vec4(0.0, 0.0, 0.0, 0.7 - mouse_effect), 0.5);  // Black (Translucent)
    }

    fragColor.rgb += vec3(striped, 0.0) * 0.1; 

    return dissolve_mask(fragColor, texture_coords, texture_coords);
}
