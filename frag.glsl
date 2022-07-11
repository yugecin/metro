// vi: syntax=c
#version 430
#define iTime fpar[0].x
#define xrot fpar[0].y
#define TAU 6.283185
#define PI 3.141592
#define debugmov 1
layout (location=0) uniform vec4 fpar[2];
layout (location=2) uniform vec4 debug[2];
layout (location=4) uniform sampler2D tex;
out vec4 c;
in vec2 v;
float s;

const float[] so = float[] (
// flopine evvvil blackle yx
0.358,16.16,11.14,11.30,11.50,
0.064,9.26,10.25,13.28,15.27,
0.297,19.23,18.40,16.52,20.52,
0.332,28.38,15.58,38.55,29.38,
0.298,34.68,35.57,35.48,36.38,
0.206,36.37,40.34,46.51,35.51,
0.134,46.37,46.40,46.46,45.51,
0.137,50.37,50.42,50.48,49.51,
0.174,50.41,53.39,56.34,55.52,
0.217,60.46,66.30,52.48,62.53,
0.224,43.75,50.62,31.76,45.82,
0.261,48.70,50.87,51.88,54.70,
0.270,57.70,59.87,59.90,62.70,
0.284,66.71,68.90,68.90,71.71,
0.277,75.72,76.90,76.91,79.72,
0.148,83.72,83.78,83.82,83.87,
0.242,88.64,87.83,87.87,90.88,
0.378,35.02,31.47,46.13,35.15,
0.183,42.07,42.15,42.22,44.25,
0.244,47.24,48.09,51.07,52.24,
0.050,47.19,49.20,50.20,52.19,
0.128,58.13,52.17,56.23,58.23,
0.160,62.07,62.14,62.16,62.23,
0.134,66.11,62.18,61.16,66.23,
0.175,70.06,70.17,69.22,71.23,
0.163,76.16,79.10,68.11,76.23,
0.217,15.76,11.92,16.84,8.96,
0.096,11.75,11.81,11.80,13.85,
0.105,19.76,20.80,21.81,22.86,
0.117,24.76,22.79,19.84,17.85,
-1,
// LJ virgill lug00ber iq
0.291,10.12,15.31,2.34,20.31,
0.316,24.17,23.41,32.36,14.40,
0.099,18.17,23.17,21.18,28.16,
0.347,45.14,50.36,50.35,53.12,
0.174,57.12,56.18,56.25,56.30,
0.181,60.12,60.17,60.24,61.30,
0.075,60.18,62.14,64.14,66.12,
0.341,70.31,57.22,78.01,72.30,
0.225,72.30,68.53,66.36,60.40,
0.143,77.15,77.20,77.24,77.29,
0.264,80.07,80.20,80.29,82.33,
0.259,84.07,83.23,84.28,86.33,
0.248,7.59,7.77,6.82,9.83,
0.265,12.72,12.90,19.87,17.72,
0.254,24.83,14.81,28.59,25.83,
0.235,25.83,27.98,12.98,26.88,
0.408,30.62,24.85,38.91,30.61,
0.427,37.61,33.94,46.83,37.61,
0.341,43.58,40.98,55.71,44.73,
0.204,55.73,62.62,43.78,57.80,
0.123,60.68,60.71,60.76,61.81,
0.059,60.72,62.68,63.68,64.68,
0.132,82.67,82.71,82.76,82.80,
0.171,89.81,84.82,86.65,90.67,
0.261,90.68,91.82,90.89,91.94,
-1,
// logicoma
0.374,19.52,0.57,16.52,13.26,
0.253,19.44,19.26,35.53,20.47,
0.369,34.38,38.42,43.67,20.61,
0.248,37.48,27.60,29.27,36.41,
0.161,41.52,42.46,40.43,41.36,
0.204,51.52,43.54,44.37,51.37,
0.304,58.40,46.41,63.69,59.40,
0.267,63.54,63.36,67.35,68.53,
0.164,66.41,70.37,72.44,72.53,
0.296,75.54,74.30,81.39,79.54,
0.076,74.45,76.48,77.48,81.48,
-1.
);

vec3 graf()
{
	if (iTime < 2) {
		return vec3(0);
	}
	vec2 w=(v+1.)/2.;
	int i = 0;
	float t=(iTime-2)/1.7,T=0,ts=0,col=0,j,_a,a,b;
	while (t>0) {
		T += so[i];
		if (t < T) {
			_a = (t - ts) / so[i];
			for (j=0;j<.15;j+=.01) { // TODO: tweak
				a=clamp(_a+j-.075,0,1);b = 1. - a;
				vec2 p = vec2(
					b*b*b*floor(so[i+1])/100+3*b*b*a*floor(so[i+2])/100+3.*b*a*a*floor(so[i+3])/100+a*a*a*floor(so[i+4])/100,
					b*b*b*fract(so[i+1])+3.*b*b*a*fract(so[i+2])+3.*b*a*a*fract(so[i+3])+a*a*a*fract(so[i+4])
				);
				col += step(distance(p, w), .015);
			}
			break;
		}
		ts += so[i];
		i += 5;
		if (so[i] == -1.) {
			break;
		}
	}
	return texture(tex,w).xyz + col;
}

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
	float a= op.y;
	a=mod(a-315,630)-315;
	//a=mod(a-157.5,630)-315;
	//return length(max(abs(op.y)-157.5,0));
	float b=op.y;
	b+=int(op.y/630)*315;
	//if (mod(b,630)<315)
	//b=mod(b,315)-5;
	p.x += (1.-cos((b/50)/2)) * 25.;
	q.x += (1.-cos(((b-mod(b, 9)+4.5)/50)/2)) * 25.;
	p.x = abs(p.x) - 7.;
	q.x = abs(q.x) - 7.;
	return max(
		length(max(abs(a-157.5)-157.5,0)),
		min(
			length(max(abs(p) - vec3(1.6,1.7,.7),0.)), //pads
			min(
				railrail(p),
				length(max(abs(q)-vec3(4.5,2.5,.5),0.)) // bottombar
			)
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
	vec2 t=vec2(s,0),
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
	if (fpar[0].y>0) {
		// rendering grafitti to texture
		//uv.x=(uv.x+1.)*10;
		//815
		//c=vec4(step(-.99,uv.x),0.,0.,1.);
		//uv.x=(uv.x+1.)/.185;
		c=vec4(graf(),0);
		//c=vec4(vec3(0.),1.);
		return;
	}
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
		col=vec3(.05+.05*e);
		//col=vec3(flopine_shade);
		if (p.y>-99) {
			// big area lights
			vec3 n = norm(p, r.y),
				xx=p,
				l = vec3(1.,.92,.71);
			//if (s==0.) l+=.2*e;
			if (s==2.) l*=.2; // darker floor
			if (s==3.) {
				vec2 q=(p.yz-vec2(60,-50))/vec2(80,45);
				if (q.x>.01&&q.y>.01&&q.x<.99&&q.y<.99) {
					if(p.x<0)q.x=1-q.x; // other direction for other side
					//l*=q.x; // add color here
					vec3 t=texture(tex,q).xyz;
					l+=t*3.;
					if (length(t)>.1) l+=.9*e; // TODO is this needed
					//l=vec3(graf(q))*7.;
				}
			}
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
