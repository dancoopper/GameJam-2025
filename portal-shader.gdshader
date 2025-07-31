shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D portal_view;

void fragment() {
    vec2 uv = SCREEN_UV;

    vec4 color = texture(portal_view, uv);
    ALBEDO = color.rgb;
    ALPHA = color.a;
}
