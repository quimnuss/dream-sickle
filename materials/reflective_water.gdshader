shader_type spatial;
render_mode unshaded;

uniform vec4 tint_color : source_color = vec4(0.5, 0.8, 0.9, 1.0);
uniform float tint_strength : hint_range(0.0, 1.0) = 0.3;
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.02;
uniform float normal_scale : hint_range(0.1, 5.0) = 1.0;
uniform float normal_speed : hint_range(0.0, 2.0) = 0.1;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D normal_map : hint_normal;

varying vec3 world_position;
varying vec3 view_direction;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    view_direction = normalize(CAMERA_POSITION_WORLD - world_position);
}

void fragment() {
    // Get base normal (water surface normal)
    vec3 base_normal = vec3(0.0, 1.0, 0.0);
    
    // Animate the normal map for subtle water movement
    vec2 animated_uv = UV * normal_scale + TIME * normal_speed;
    
    // Sample normal map for surface detail
    vec3 normal_sample = texture(normal_map, animated_uv).rgb;
    vec3 surface_normal = normalize(base_normal + (normal_sample.xyz - 0.5) * 0.1);
    
    // Calculate reflection vector using proper view direction
    vec3 reflected_view = reflect(-view_direction, surface_normal);
    
    // For proper ground reflections, we need to mirror the world position
    // Calculate the mirrored position relative to the water plane
    vec3 mirror_pos = world_position;
    mirror_pos.y = -mirror_pos.y; // Flip Y to mirror below water plane
    
    // Transform mirrored position to screen space
    vec4 mirror_screen = PROJECTION_MATRIX * (VIEW_MATRIX * vec4(mirror_pos, 1.0));
    vec2 reflected_uv = (mirror_screen.xy / mirror_screen.w) * 0.5 + 0.5;
    
    // Add distortion from normal map
    vec2 distortion = (normal_sample.xy - 0.5) * distortion_strength;
    reflected_uv += distortion;
    
    // Clamp to screen bounds
    reflected_uv = clamp(reflected_uv, vec2(0.0), vec2(1.0));
    
    // Sample the reflected scene
    vec3 reflection = texture(SCREEN_TEXTURE, reflected_uv).rgb;
    
    // Mix reflection with water tint
    vec3 final_color = mix(reflection, tint_color.rgb, tint_strength);
    
    ALBEDO = final_color;
}