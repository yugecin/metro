#version 430
layout (location=0) uniform vec4 fpar[2];
#define iTime fpar[0].x
#define xrot fpar[0].y
out vec4 c;
in vec2 p;

#define TAU 6.283185
#define PI 3.141592

mat2 rot2(float a){float s=sin(a),c=cos(a);return mat2(c,s,-s,c);}

float su(float d1, float d2, float k) {
	float h = clamp(.5+.5*(d2-d1)/k,0.,1.);
	return mix(d2,d1,h)-k*h*(1.-h);
}


float railrail(vec3 p) {
	p.z = abs(p.z+1.7) - .8;
	return su(
		length(max(abs(p+vec3(0.,0.,.5)) - vec3(.6,5.,.7),0.)), //mid
		length(max(abs(p) - vec3(1.,5.,.2),0.)) //bot/top
		,.3
	);
}

float mirroredrail(vec3 p) {
	p.x = abs(p.x) - 6.;
	return min(
		length(max(abs(p) - vec3(1.6,.6,.7),0.)), //pads
		railrail(p)
	);
}

float rail(vec3 p) {
	//p.y += iTime;
	p.y = mod(p.y, 9.)-4.5;
	return min(
		length(max(abs(p) - vec3(10.,1.5,.5),0.)), // bottombar
		mirroredrail(p)
	);
}

float map(vec3 p) {
	return min(rail(p), 50.-length(p.xz));
}

vec3 norm(vec3 p, float dist_to_p) {
	vec2 e = vec2(.001, 0);

	return normalize(dist_to_p - vec3(
		map(p-e.xyy),
		map(p-e.yxy),
		map(p-e.yyx)
	));
}

vec3 GetRayDir(vec2 uv, vec3 p, vec3 l, float zoom) {
	vec3 f = normalize(l-p),
	     r = normalize(cross(vec3(0,1,0), f)),
	     u = cross(f,r),
	     c = f*zoom,
	     i = c + uv.x*r + uv.y*u,
	     d = normalize(i);
	return d;
}

void main()
{
	vec2 uv = vec2(p.x,p.y/1.77);

	vec3 ro = vec3(10, -300, -30);
	//ro.x = fpar[0].y/10.;
	//vec2 m = iMouse.xy/iResolution.xy;
	//ro.yz *= rot2(-m.y*PI+1.);
	//ro.xy *= rot2(-m.x*TAU);
	vec3 rd = GetRayDir(uv, ro, vec3(0,0,0), 1.);

	// TODO: 1st way of defining rd (above) gives a bit of tilt
	// TODO: 2nd way (below) doesn't...?
	vec3 rayOrigin=ro; //vec3(cos(time*.2)*5.,2,sin(time*.2)*5.);
	vec3 cameraForward=normalize(vec3(0)-rayOrigin);
	vec3 cameraLeft=normalize(cross(cameraForward,vec3(0,0,-1)));
	vec3 cameraUp=normalize(cross(cameraLeft,cameraForward));
	vec3 rayDirection=mat3(cameraLeft,cameraUp,cameraForward)*normalize(vec3(uv,1.));
	rd = rayDirection;

	vec3 col = vec3(.1-length(uv)*.1);
	float tot_dist = 0.;
	bool hit = false;
	for(int i=0; i < 200 && tot_dist < 400.; i++) {
		vec3 p = ro + tot_dist * rd;
		//p.z -= 10.;
		//p.yz *= rot2(-.9);
		//p = mod(p, 30.) - 15.;
		vec3 op = p;
		//p.xy *= rot2(iTime/2.);
		//p.yz *= rot2(iTime/3.);
		//p.xz*=rot2(sin(p.z*0.2)*0.2+iTime);
		float d = map(p);
		if (d < .001) {
			vec3 n = norm(p, d);
			vec3 r = reflect(rd, n);

			float dif = dot(n, normalize(vec3(1,2,-3)))*.5+.5;
			col = n; // norm colors
			//col = vec3(1.-float(i)/100.); // flopine shade
			col = vec3(dif);
			//col = vec3(1.,.745,.07);
			//col *= 1.-float(i)/90.;
			hit = true;
			break;
		}
		tot_dist += d;
	}

	if (!hit) {
		col = pow(col, vec3(.4545));	// gamma correction
	}

	c = vec4(col,1.0);
}
