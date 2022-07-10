// vi: syntax=c
#version 430
#define iTime fpar[0].x
#define xrot fpar[0].y
#define TAU 6.283185
#define PI 3.141592
#define debugmov 1
layout (location=0) uniform vec4 fpar[2];
layout (location=2) uniform vec4 debug[2];
out vec4 c;
in vec2 v;
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
	p.x -= 25;
	//op.y-=80;
	vec3 q = p;
	p.x += (1.-cos((op.y/50)/2)) * 25.;
	q.x += (1.-cos(((op.y-mod(op.y, 9)+4.5)/50)/2)) * 25.;
	p.x = abs(p.x) - 7.;
	q.x = abs(q.x) - 7.;
	return min(
		length(max(abs(p) - vec3(1.6,1.7,.7),0.)), //pads
		min(
			railrail(p),
			length(max(abs(q)-vec3(4.5,2.5,.5),0.)) // bottombar
		)
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
	return min(
		length(max(abs(p) - vec3(13.,2.5,.5),0.)), // bottombar
		mirroredrail(p)
	);
}

float allrail(vec3 p) {
	p.z += .5;
	p.y = mod(p.y, 9.)-4.5;
	vec3 q = p;
	p.x = abs(p.x)-25;
	return min(
		rail(p),
		mr2(q)
	);
}

float support(vec2 p) {
	float a = length(max(abs(p)-3.5,0));
	//return a;
	if (a > .2) {
		return a;
	}
	vec2 q=p,s=p,z=vec2(3,.3);
	vec3 r,t;
	q.x=abs(q.x)-2.8;
	r.xy=q;r.y=abs(r.y)-1.7;r.z=mod(op.z,2)-1;
	t.xy=p;t.x=abs(t.x)-1.3;t.z=mod(op.z,2)-1;
	return max(
		dot(op,vec3(0,0,-1))-50,
		min(
			min(
				min(
					length(max(abs(p)-z.xy,0.)),
					length(max(abs(q)-z.yx,0.))
				),
				length(t)-.6
			),
			length(r)-.6
		)
	);
}

float topsupport(vec2 p) { //p.xy = y/z
	p.y += 63;
	float v=length(max(abs(p)-vec2(1,5),0)),
		h=length(max(abs(vec3(mod(op.x,20)-10,p.xy))-vec3(1,3,5),0)),//(length(vec3(mod(op.x,10)-5,p.xy))-3),
		v2;
	p.y=abs(p.y)-5.5;
	v2=length(max(abs(p)-vec2(3,.5),0));
	return min(h, su(v,v2,1));
}
float ts2(vec3 p) {
	p.z += 53.5;
	float v=length(max(abs(p)-vec3(35,1,3),0)),
		v2;
	p.z=abs(p.z)-3;
	v2=length(max(abs(p)-vec3(35,3,.5),0));
	return min(v,v2);
}

float supports(vec3 p) {
	p.y=mod(p.y,100)-50;
	float top=topsupport(p.yz);
	p.x=mod(abs(p.x),160)-80;
	float top2=ts2(p);
	float b=length(max(abs(vec2(p.x,p.z+70))-vec2(20,13),0));
	p.x=abs(p.x)-20;
	float sup=min(support(p.xy), min(top,top2));
	return min(sup,b);
}

float tunnel(vec3 p) {
	p.z+=25;
	return min(
		dot(p,vec3(0,0,1))+44,
		max(
			dot(p,vec3(0,1,0)),
			30.-length(vec2(p.x/1.8,p.z>0.?0:p.z*1.3))
		)
	);
}

float map(vec3 p) {
	return min(
		supports(p),
		min(
			allrail(p),
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

float flopine_shade;
vec3 p;
vec3 march(vec3 o,vec3 v){ // x=hit y=dist_to_p z=tot_dist
	vec3 r=vec3(0);
	for(int i=0;i<200;i++){
		p=o+r.z*v;

		//p.y += 100.;
		//p.z -= 10.;
		//p.yz *= rot2(-.9);
		//p = mod(p, 30.) - 15.;
		op = p;
		//p.xy *= rot2(iTime/2.);
		//p.yz *= rot2(iTime/3.);
		//p.xz*=rot2(sin(p.z*0.2)*0.2+iTime);
		float d=map(p);
		if (d < .008) {
			//vec3 n = norm(p, d);
			//vec3 r = reflect(rd, n);

			//col = n; // norm colors
			r.y=d;
			flopine_shade=1.-float(i)/100.;
			//float dif = dot(n, normalize(vec3(1,2,-3)))*.5+.5;
			//col = vec3(dif);
			//col = vec3(1.,.745,.07);
			//col *= 1.-float(i)/90.;

/*
			col = vec3(.1);
			//col += .02 * dot(n,normalize(-rd));
			vec3 lightsrc = vec3(16.,10.,-10.);
			col += vec3(1.,.92,.71) * .2 * dot(n,normalize(lightsrc-p)) / pow(length(p-lightsrc) / 125., 2);
			lightsrc = vec3(-16.,10.,-10.);
			col += vec3(1.,.92,.71) * .2 * dot(n,normalize(lightsrc-p)) / pow(length(p-lightsrc) / 15., 2.);
			//col = vec3(.05 + .05 * dot(n,normalize(-rd)));
			*/

			r.x=1;
			break;
		}
		r.z+=d;
	}
	return r;
}

float lit(vec3 h,vec2 a, vec3 n) {
	vec3 b=vec3(a,-55),
		r=march(b,normalize(h-b));
	if (r.x>0 && length(p-h)<.1) {
		return .2 * dot(n,normalize(b-h)) / pow(r.z / 65., 4.);
	}
	return 0.;
}

void main()
{
	vec2 uv=v;uv.y/=1.77;
	/*
	if (mod(gl_FragCoord.x, 2.) < 1.) {
		uv.y += .1;
	}
	*/

	float ttt = rand(v)*.001 + iTime;
	vec3 ro = vec3(10*sin(ttt), -30*cos(ttt), -20);

	//vec3 ro = vec3(20, -50, -20);
	//ro.x = fpar[0].y/10.;
	//vec2 m = iMouse.xy/iResolution.xy;
	//ro.yz *= rot2(-m.y*PI+1.);
	//ro.xy *= rot2(-m.x*TAU);
	vec3 rd = GetRayDir(uv, ro, vec3(0,0,0), 1.);


	vec3 at = vec3(0,0,-25);

#if debugmov
	ro = debug[0].xyz;
	float down = debug[1].y/20.;
	if (abs(down) < .001) down = .001;
	float xylen = sin(down);
	down = cos(down);
	at.x = ro.x+cos(debug[1].x/20.)*xylen;
	at.y = ro.y+sin(debug[1].x/20.)*xylen;
	at.z = ro.z+down;
#endif

	// TODO: 1st way of defining rd (above) gives a bit of tilt
	// TODO: 2nd way (below) doesn't...?
	//ro = vec3(cos(time*.2)*5.,2,sin(time*.2)*5.);
	vec3 cameraForward=normalize(at-ro);
	vec3 cameraLeft=normalize(cross(cameraForward,vec3(0,0,-1)));
	vec3 cameraUp=normalize(cross(cameraLeft,cameraForward));
	vec3 rayDirection=mat3(cameraLeft,cameraUp,cameraForward)*normalize(vec3(uv,1));
	rd = rayDirection;

	vec3 col = vec3(.1);//vec3(.1-length(uv)*.1);
	vec3 r = march(ro,rd);
	if (r.x>0) {
		// hit
		col=vec3(flopine_shade);
		if (p.y>-99) {
			col = vec3(.1);
			col+=vec3(.05*rand(p.xy));
			//col=vec3(flopine_shade);
			vec3 n = norm(p, r.y);
			vec2 lo=p.xy,of=vec2(80,100),mu=vec2(-1,1);
			lo.y-=mod(lo.y+50,200)-100;
			lo.x-=mod(lo.x-160,320)-160;
			vec3 xx=p;
			//col += vec3(1.,.92,.71) * lit(xx,lo+0*of*mu.xy,n);
			col += vec3(1.,.92,.71) * lit(xx,lo/*+of*mu.yx*/,n);
			//col += vec3(1.,.92,.71) * lit(xx,lo+vec2(0,200),n);
			//col += vec3(1.,.92,.71) * lit(xx,lo+vec2(0,-200),n);
			//col += vec3(1.,.92,.71) * lit(xx,lo+of*mu.yy,n);
			//col += vec3(1.,.92,.71) * lit(xx,lo+of*mu.xy,n);
			//col += vec3(1.,.92,.71) * lit(xx,lo+of*mu.xx,n);
			//l=vec3(75,100,-55);
			/*
			vec3 xx=p;
			r = march(l,normalize(xx-l));
			if (r.x>0 && length(p-xx)<.1) {
				//col = vec3(r.z/100);
				col += vec3(1.,.92,.71) * .2 * dot(n,normalize(l-xx)) / pow(r.z / 75., 1.4);
			}
			/*
			vec3 xx=p;
			l=vec3(75,100,-55);
			r = march(l,normalize(xx-l));
			if (r.x>0 && length(p-xx)<.1) {
				//col = vec3(r.z/100);
				col += vec3(1.,.92,.71) * .2 * dot(n,normalize(l-xx)) / pow(r.z / 75., 1.4);
			}
			l=vec3(-75,100,-55);
			r = march(l,normalize(xx-l));
			if (r.x>0 && length(p-xx)<.1) {
				//col = vec3(r.z/100);
				col += vec3(1.,.92,.71) * .2 * dot(n,normalize(l-xx)) / pow(r.z / 75., 1.4);
			}
			/*
			l=vec3(-80,50,-48);
			r = march(l,normalize(xx-l));
			if (r.x>0 && length(p-xx)<.1) {
				//col = vec3(r.z/100);
				col += vec3(1.,.92,.71) * .2 * dot(n,normalize(l-xx)) / pow(r.z / 95., 1.4);
			}
			*/
		}
	}

	//if (!hit) {
		//col = pow(col, vec3(.4545));	// gamma correction
	//}

	c = vec4(col,1.0);
}
