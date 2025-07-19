shader_type spatial;
render_mode specular_toon;

uniform vec4 albedo_color : source_color = vec4(1.0, 0.8, 0.4, 1.0);
uniform vec3 light_direction = vec3(-0.5, -1.0, -0.3); // Directional light (normalized)
uniform int shading_steps : hint_range(1, 5) = 3;

void fragment() {
    // Normalize light direction
    vec3 light_dir = normalize(light_direction);

    // Get surface normal
    vec3 normal = normalize(NORMAL);

    // Compute basic Lambert lighting
    float NdotL = max(dot(normal, -light_dir), 0.0);

    // Quantize lighting into bands
    float band = floor(NdotL * float(shading_steps)) / float(shading_steps);

    // Final color
    ALBEDO = albedo_color.rgb * band;
    ALPHA = albedo_color.a;
}
