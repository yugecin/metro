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
float s;
float rand(vec2 p){return fract(sin(dot(p.xy,vec2(12.9898,78.233)))*43758.5453);}

mat2 rot2(float a){float s=sin(a),c=cos(a);return mat2(c,s,-s,c);}

float su(float d1, float d2, float k) {
	float h = clamp(.5+.5*(d2-d1)/k,0.,1.);
	return mix(d2,d1,h)-k*h*(1.-h);
}

vec3 op = vec3(1.);
float railrail(vec3 p) {
	p.z = abs(p.z+1.7) - .8;
	float a=su(
		length(max(abs(p+vec3(0.,0.,.5)) - vec3(.6,5.,.7),0.)), //mid
		length(max(abs(p) - vec3(1.,5.,.2),0.)) //bot/top
		,.3
	);
	if (a<.01)s=1;
	return a;
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
	s=0;
	p.z += .5;
	p.x=mod(p.x+80,160)-80;
	float t=length(max(abs(p.xz)-vec2(39,3),0));
	if (t>1)return t;
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
	return min(h, min(v,v2));
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
	float c=length(max(abs(p.y)-3,0));
	if (c>1) {
		return c;
	}
	float top=topsupport(p.yz);
	p.x=mod(abs(p.x),160)-80;
	float top2=ts2(p);
	p.x=abs(p.x)-20;
	float sup=min(support(p.xy), min(top,top2));
	return sup;
}

float tunnel(vec3 p) {
	p.x=mod(p.x-80,160)-80;
	p.z+=25;
	return max(
		dot(p,vec3(0,1,0)),
		30.-length(vec2(p.x/1.8,p.z>0.?0:p.z*1.3))
	);
}

float map(vec3 p) {
	s=length(max(abs(p-vec3(-80,1000,-35))-vec3(190,1000,36),0));
	if (s < 2) {
		s = supports(p);
	}
	vec2 
		t=vec2(s,0),
		//ceil
		c=vec2(dot(p,vec3(0,0,1))+69,1),
		//floor
		f=vec2(dot(p,vec3(0,0,-1)),2),
		//walls
		w=vec2(min(dot(p,vec3(-1,0,0))+103,dot(p,vec3(1,0,0))+263),3), // l/r
		r=vec2(allrail(p),4), // 5 is rail itself
		u=vec2(tunnel(p),6);

	t=c.x<t.x?c:t;
	t=f.x<t.x?f:t;
	t=w.x<t.x?w:t;
	t=r.x<t.x?vec2(r.x,4+s):t;
	t=u.x<t.x?u:t;
	s=t.y;
	return t.x;
}

vec3 norm(vec3 p, float dist_to_p) {
	vec2 e = vec2(.001, 0);

	return normalize(dist_to_p - vec3(
		map(p-e.xyy),
		map(p-e.yxy),
		map(p-e.yyx)
	));
}

float flopine_shade;
vec3 p;
vec3 march(vec3 o,vec3 v,int s){ // x=hit y=dist_to_p z=tot_dist
	vec3 r=vec3(0);
	for(int i=0;i<s&&r.z<350;i++){
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
	vec3 b=vec3(a,-55), // TODO: 68.9?
		r=march(b,normalize(h-b),50);
	if (r.x>0 && length(p-h)<.1) {
		float pw=75;
		if (s==1.) { // if surface=ceiling, pw=25
			float t = smoothstep(0,-15,p.z-b.z);
			pw-=t*t*50;
		}
		return .3 * dot(n,normalize(b-h)) / pow(r.z / pw, 2.9);
	}
	return 0.;
	//vec3 b=vec3(a,-55);
	//return .2 * dot(n,normalize(b-h)) / pow(length(h-b) / 65., 2.4);
}

void main()
{
	vec2 uv=v;uv.y/=1.77;
	//if (mod(gl_FragCoord.x, 2.) < 1.) {
		//uv.y += .01;
	//}

	float ttt = rand(v)*.001 + iTime;
	vec3 ro = vec3(10*sin(ttt), -30*cos(ttt), -20);

	//vec3 ro = vec3(20, -50, -20);
	//ro.x = fpar[0].y/10.;
	//vec2 m = iMouse.xy/iResolution.xy;
	//ro.yz *= rot2(-m.y*PI+1.);
	//ro.xy *= rot2(-m.x*TAU);
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
	vec3 cf=normalize(at-ro),
		cl=normalize(cross(cf,vec3(0,0,-1))),
	rd=mat3(cl,normalize(cross(cl,cf)),cf)*normalize(vec3(uv,1));

	vec3 col = vec3(.05);//vec3(.1-length(uv)*.1);
	vec3 r = march(ro,rd,200);
	if (r.x>0) {
		// hit
		float e=rand(mod(p.xy,10));
		//col=vec3(flopine_shade);
		col=vec3(.05+.05*e);
		if (p.y>-99) {
			// big area lights
			vec3 n = norm(p, r.y),
				xx=p,
				l = vec3(1.,.92,.71);
			//if (s==0.) l+=.2*e;
			if (s==2.) l*=.2;
			if (s==4.) l*=vec3(.22,.14,.04)+.05*e;
			if (s==5.) l*=vec3(.6)+.05*e;
			vec2 lo=p.xy;
			lo.y+=100;
			lo.y-=mod(lo.y,400)-100;
			//lo.y+=75;
			//lo.y+=20;
			//lo.y-=mod(lo.y,200)-100;
			lo.x-=mod(lo.x,160);
			col += l * lit(xx,lo/*+of*mu.yx*/,n);
			col += l * lit(xx,lo+vec2(160,0),n);
			col += l * lit(xx,lo+vec2(-160,0),n);
			// TODO: remove these last 2 if needed
			//if (p.y<0) { // check because otherwise the light doesn't go in the tunnel
				//col += vec3(1.,.92,.71) * lit(xx,lo+vec2(0,100),n);
				//col += vec3(1.,.92,.71) * lit(xx,lo+vec2(0,-100),n);
			//}
		}
		col=mix(col,vec3(.05),smoothstep(300,350,r.z));
	}

	//if (!hit) {
		//col = pow(col, vec3(.4545));	// gamma correction
	//}

	c = vec4(col,1.0);
}
