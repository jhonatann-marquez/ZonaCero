shader_type spatial;

uniform vec3 color_bajo : source_color = vec3(0.145, 0.165, 0.176); // #252A2D
uniform vec3 color_alto : source_color = vec3(0.545, 0.573, 0.580);  // #8B9294

uniform float amplitud = 0.03;
uniform float longitud = 1.0;
uniform float periodo = 2.2;

uniform float amplitud2 = 0.01;
uniform float longitud2 = 0.37;
uniform float periodo2 = 0.9;

varying float altura;

float onda(float x, float t, float a, float l, float p) {
	return a * sin((TAU / l) * x - (TAU / p) * t);
}

float pendiente(float x, float t, float a, float l, float p) {
	return a * (TAU / l) * cos((TAU / l) * x - (TAU / p) * t);
}

void vertex() {
	float h1 = onda(VERTEX.x, TIME, amplitud, longitud, periodo);
	float h2 = onda(VERTEX.x, TIME, amplitud2, longitud2, periodo2);
	
	float s1 = pendiente(VERTEX.x, TIME, amplitud, longitud, periodo);
	float s2 = pendiente(VERTEX.x, TIME, amplitud2, longitud2, periodo2);
	
	float h_total = h1 + h2;
	float s_total = s1 + s2;
	
	VERTEX.y += h_total;
	NORMAL = normalize(vec3(-s_total, 1.0, 0.0));
	altura = h_total;
}

void fragment() {
	float alt_max = amplitud + amplitud2;
	float m = clamp(altura / (2.0 * alt_max) + 0.5, 0.0, 1.0);
	
	ALBEDO = mix(color_bajo, color_alto, m);
	ROUGHNESS = 0.2;
}