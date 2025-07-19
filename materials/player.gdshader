shader_type spatial;
render_mode specular_toon;

uniform sampler2D albedo_texture;
uniform vec3 light_direction = vec3(-0.5, -1.0, -0.3); // Directional light
uniform int shading_steps : hint_range(1, 5) = 3;

void fragment() {
    // Surface normal
    vec3 normal = normalize(NORMAL);

    // Light direction
    vec3 light_dir = normalize(light_direction);

    // Lambertian lighting
    float NdotL = max(dot(normal, -light_dir), 0.0);

    // Quantize lighting into bands
    float band = floor(NdotL * float(shading_steps)) / float(shading_steps);

    // Sample texture using UV
    vec3 tex_color = texture(albedo_texture, UV).rgb;

    // Final cel-shaded color
    ALBEDO = tex_color * band;
}
