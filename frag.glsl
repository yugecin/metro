// vi: syntax=c
#version 430
#define iTime fpar[0].x
#define xrot fpar[0].y
#define TAU 6.283185
#define PI 3.141592
layout (location=0) uniform vec4 fpar[2];
out vec4 c;
in vec2 p;
float rand(vec2 p){return fract(sin(dot(p.xy,vec2(12.9898,78.233)))*43758.5453);}

mat2 rot2(float a){float s=sin(a),c=cos(a);return mat2(c,s,-s,c);}

float su(float d1, float d2, float k) {
	float h = clamp(.5+.5*(d2-d1)/k,0.,1.);
	return mix(d2,d1,h)-k*h*(1.-h);
}

vec3 op = vec3(1.);
float railrail(vec3 p) {
	p.z = abs(p.z+1.7) - .8;
	return su(
		length(max(abs(p+vec3(0.,0.,.5)) - vec3(.6,5.,.7),0.)), //mid
		length(max(abs(p) - vec3(1.,5.,.2),0.)) //bot/top
		,.3
	);
}

float mr2(vec3 p) {
	op.y-=80;
	float t = op.y / 30.;
	t = 1.-cos((t)/2.);
	p.x += t * 20.;
	p.x = abs(p.x) - 7.;
	return min(
		length(max(abs(p) - vec3(1.6,1.7,.7),0.)), //pads
		railrail(p)
	);
}

float mirroredrail(vec3 p) {
	p.x = abs(p.x) - 7.;
	return min(
		length(max(abs(p) - vec3(1.6,1.7,.7),0.)), //pads
		railrail(p)
	);
}

float rail(vec3 p) {
	p.y = mod(p.y, 9.)-4.5;
	p.z += .5;
	return min(
		length(max(abs(p) - vec3(13.,2.5,.5),0.)), // bottombar
		min(mirroredrail(p), mr2(p))
		//mirroredrail(p)
	);
}

float support(vec3 p) {
	float a = length(max(abs(p)-vec3(2,2,24),0));
	if (a > 1.4) { // TODO: lighting might be better when this is bigger (~1.4), is it required?
		//return a;
	}
	vec3 q=p,r,s=p,t=p;
	q.x=abs(q.x)-2.8;
	r=q;r.y=abs(r.y)-1.7;r.z=mod(r.z,2)-1;
	t.x=abs(t.x)-1.3;t.z=mod(t.z,2)-1;
	return min(
		min(
			min(
				length(max(abs(p)-vec3(3.,.3,54.),0.)),
				length(max(abs(q)-vec3(.3,3,54.),0.))
			),
			length(t)-.6
		),
		length(r)-.6
	);
}

float tunnel(vec3 p) {
	p.z+=25;
	return max(
		dot(p,vec3(0,1,0)),
		30.-length(vec2(p.x/1.8,p.z>0.?0:p.z*1.3))
	);
}

float map(vec3 p) {
	return min(
		support(p),
		min(
			rail(p),
			min(
				dot(p,vec3(0,0,-1)),
				tunnel(p)
			)
		)
	);
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
	/*
	if (mod(gl_FragCoord.x, 2.) < 1.) {
		uv.y += .1;
	}
	*/

	float ttt = rand(p)*.01 + iTime;
	vec3 ro = vec3(10*sin(ttt), -30*cos(ttt), -20);

	//vec3 ro = vec3(20, -50, -20);
	//ro.x = fpar[0].y/10.;
	//vec2 m = iMouse.xy/iResolution.xy;
	//ro.yz *= rot2(-m.y*PI+1.);
	//ro.xy *= rot2(-m.x*TAU);
	vec3 rd = GetRayDir(uv, ro, vec3(0,0,0), 1.);


	vec3 at = vec3(0);

	/*
	ro = fpar[0].yzw;
	float down = fpar[1].y/20.;
	if (abs(down) < .001) down = .001;
	float xylen = sin(down);
	down = cos(down);
	at.x = ro.x+cos(fpar[1].x/20.)*xylen;
	at.y = ro.y+sin(fpar[1].x/20.)*xylen;
	at.z = ro.z+down;
	*/

	// TODO: 1st way of defining rd (above) gives a bit of tilt
	// TODO: 2nd way (below) doesn't...?
	//ro = vec3(cos(time*.2)*5.,2,sin(time*.2)*5.);
	vec3 cameraForward=normalize(at-ro);
	vec3 cameraLeft=normalize(cross(cameraForward,vec3(0,0,-1)));
	vec3 cameraUp=normalize(cross(cameraLeft,cameraForward));
	vec3 rayDirection=mat3(cameraLeft,cameraUp,cameraForward)*normalize(vec3(uv,1));
	rd = rayDirection;

	vec3 col = vec3(.05);//vec3(.1-length(uv)*.1);
	float tot_dist = 0.;
	bool hit = false;
	for(int i=0; i < 200 /*&& tot_dist < 400.*/; i++) {
		vec3 p = ro + tot_dist * rd;

		//p.y += 100.;
		//p.z -= 10.;
		//p.yz *= rot2(-.9);
		//p = mod(p, 30.) - 15.;
		op = p;
		//p.xy *= rot2(iTime/2.);
		//p.yz *= rot2(iTime/3.);
		//p.xz*=rot2(sin(p.z*0.2)*0.2+iTime);
		float d = map(p);
		if (d < .001) {
			vec3 n = norm(p, d);
			//vec3 r = reflect(rd, n);

			//col = n; // norm colors
			col = vec3(1.-float(i)/100.); // flopine shade
			//float dif = dot(n, normalize(vec3(1,2,-3)))*.5+.5;
			//col = vec3(dif);
			//col = vec3(1.,.745,.07);
			//col *= 1.-float(i)/90.;

			/*
			col = vec3(.05);
			//col += .02 * dot(n,normalize(-rd));
			vec3 lightsrc = vec3(16.,10.,-10.);
			col += vec3(1.,.92,.71) * .2 * dot(n,normalize(lightsrc-p)) / pow(length(p-lightsrc) / 15., 2.);
			lightsrc = vec3(-16.,10.,-10.);
			col += vec3(1.,.92,.71) * .2 * dot(n,normalize(lightsrc-p)) / pow(length(p-lightsrc) / 15., 2.);
			//col = vec3(.05 + .05 * dot(n,normalize(-rd)));
			*/

			hit = true;
			break;
		}
		tot_dist += d;
	}

	//if (!hit) {
		//col = pow(col, vec3(.4545));	// gamma correction
	//}

	c = vec4(col,1.0);
}
