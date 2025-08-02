// Converted Godot 4 Toon/Cel Shader
shader_type spatial;

// --- Uniforms updated for Godot 4 syntax ---
uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, filter_linear_mipmap, repeat_enable;

// This feature is now functional again because we are using the light() pass.
uniform bool clamp_diffuse_to_max = false;

uniform int cuts : hint_range(1, 8, 1) = 3;
uniform float wrap : hint_range(-2.0, 2.0) = 0.0;
uniform float steepness : hint_range(1.0, 8.0) = 1.0;

uniform bool use_attenuation = true;

uniform bool use_specular = true;
uniform float specular_strength : hint_range(0.0, 1.0) = 1.0;
uniform float specular_shininess : hint_range(0.0, 32.0) = 16.0;
uniform sampler2D specular_map : source_color, filter_linear_mipmap, repeat_enable;

uniform bool use_rim = true;
uniform float rim_width : hint_range(0.0, 16.0) = 8.0;
uniform vec4 rim_color : source_color = vec4(1.0);

uniform bool use_ramp = false;
uniform sampler2D ramp : source_color, filter_linear_mipmap, repeat_enable;

uniform bool use_borders = false;
uniform float border_width : hint_range(0.0, 0.1) = 0.01;

// Helper function for specular calculation remains the same.
float split_specular(float specular) {
	return step(0.5, specular);
}

void fragment() {
	// In Godot 4, the fragment function runs first to set up base material properties.
	// We set the base ALBEDO here, which will then be used in the light() function.
	ALBEDO = albedo.rgb * texture(albedo_texture, UV).rgb;
}

void light() {
	// The light() function is executed for each light affecting the object.
	// This is where all lighting calculations should happen for a lit shader.

	// Attenuation.
	// The ATTENUATION built-in is available in the light() pass.
	float attenuation = 1.0;
	if (use_attenuation) {
		attenuation = ATTENUATION;
	}

	// Diffuse lighting.
	// This uses the original, more correct formula with attenuation.
	float NdotL = dot(NORMAL, LIGHT);
	float diffuse_amount = NdotL + (attenuation - 1.0) + wrap;
	diffuse_amount *= steepness;

	// Cel-shading cuts, using the original formula.
	float cuts_inv = 1.0 / float(cuts);
	float diffuse_stepped = clamp(diffuse_amount + mod(1.0 - diffuse_amount, cuts_inv), 0.0, 1.0);

	// Calculate borders for the cel-shading.
	float border = 0.0;
	if (use_borders) {
		// Calculate a corrected border width based on the light angle to keep it consistent.
		float corr_border_width = length(cross(NORMAL, LIGHT)) * border_width * steepness;
		border = step(diffuse_stepped - corr_border_width, diffuse_amount)
			   - step(1.0 - corr_border_width, diffuse_amount);
	}

	// Apply the diffuse result based on the chosen style (ramp or stepped).
	// ALBEDO is available here because it was set in the fragment() pass.
	vec3 diffuse_contribution = ALBEDO * LIGHT_COLOR / PI;
	if (use_ramp) {
		diffuse_contribution *= texture(ramp, vec2(diffuse_stepped * (1.0 - border), 0.0)).rgb;
	} else {
		diffuse_contribution *= diffuse_stepped * (1.0 - border);
	}

	// The clamp_diffuse_to_max logic now works correctly.
	if (clamp_diffuse_to_max) {
		DIFFUSE_LIGHT = max(DIFFUSE_LIGHT, diffuse_contribution);
	} else {
		DIFFUSE_LIGHT += diffuse_contribution;
	}

	// Specular lighting calculation.
	if (use_specular) {
		vec3 H = normalize(LIGHT + VIEW);
		float NdotH = dot(NORMAL, H);
		float specular_amount = pow(max(NdotH, 0.0), specular_shininess * specular_shininess)
							  * texture(specular_map, UV).r
							  * attenuation; // Attenuation is correctly applied here.
		specular_amount = split_specular(specular_amount);
		SPECULAR_LIGHT += specular_strength * specular_amount * LIGHT_COLOR;
	}

	// Rim lighting calculation.
	// As per the original shader, this is added to the diffuse light.
	if (use_rim) {
		float NdotV = dot(NORMAL, VIEW);
		float rim_light = pow(1.0 - NdotV, rim_width);
		DIFFUSE_LIGHT += rim_light * rim_color.rgb * rim_color.a * LIGHT_COLOR / PI;
	}
}
