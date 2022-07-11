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
102.,0.155,0.519,0.1523333,0.5021334,0.1496667,0.4852667,0.152,0.472,
74.,0.152,0.472,0.1543333,0.4587333,0.1616667,0.4490666,0.175,0.454,
148.,0.175,0.454,0.1883333,0.4589334,0.2076667,0.4784667,0.227,0.498,
143.,0.231,0.519,0.2259555,0.4858889,0.2209111,0.4527777,0.228,0.455,
137.,0.228,0.455,0.2350889,0.4572222,0.2543111,0.4947778,0.265,0.506,
72.,0.265,0.506,0.2756889,0.5172222,0.2778444,0.5021111,0.28,0.487,
69.,0.28,0.487,0.2803778,0.4707111,0.2807556,0.4544222,0.288,0.462,
121.,0.288,0.462,0.2952444,0.4695777,0.3093555,0.5010222,0.318,0.509,
72.,0.318,0.509,0.3266445,0.5169778,0.3298222,0.5014889,0.333,0.486,
50.,0.333,0.486,0.3354445,0.4775555,0.3378889,0.4691111,0.342,0.465,
35.,0.342,0.465,0.3461111,0.4608889,0.3518889,0.4611111,0.357,0.464,
43.,0.357,0.464,0.3621111,0.4668888,0.3665555,0.4724445,0.371,0.478,
75.,0.485,0.525,0.4758222,0.5161111,0.4666445,0.5072222,0.469,0.496,
83.,0.469,0.496,0.4713555,0.4847777,0.4852445,0.4712222,0.484,0.461,
93.,0.484,0.461,0.4827555,0.4507778,0.4663778,0.4438889,0.45,0.437,
199.,0.484,0.459,0.5119333,0.4851333,0.5398666,0.5112666,0.556,0.515,
87.,0.556,0.515,0.5721334,0.5187333,0.5764667,0.5000666,0.574,0.487,
77.,0.574,0.487,0.5715333,0.4739333,0.5622666,0.4664667,0.553,0.459,
55.,0.554,0.461,0.5444223,0.4574667,0.5348444,0.4539333,0.53,0.459,
65.,0.53,0.459,0.5251556,0.4640667,0.5250444,0.4777333,0.529,0.488,
68.,0.529,0.488,0.5329556,0.4982666,0.5409778,0.5051333,0.549,0.512,
44.,0.57,0.508,0.5764667,0.5063555,0.5829333,0.5047112,0.59,0.504,
48.,0.59,0.504,0.5970667,0.5032889,0.6047333,0.5035111,0.612,0.505,
48.,0.612,0.505,0.6192667,0.5064889,0.6261333,0.5092444,0.633,0.512,
151.,0.633,0.518,0.6281778,0.4842445,0.6233556,0.4504889,0.626,0.449,
112.,0.626,0.449,0.6286444,0.4475111,0.6387555,0.4782889,0.651,0.494,
100.,0.651,0.494,0.6632445,0.5097111,0.6776223,0.5103556,0.692,0.511,
159.,0.715,0.523,0.7110444,0.4876,0.7070889,0.4522,0.709,0.45,
108.,0.709,0.45,0.7109112,0.4478,0.7186889,0.4788001,0.73,0.495,
102.,0.73,0.495,0.7413111,0.5112,0.7561555,0.5125999,0.771,0.514,
83.,0.8,0.507,0.7932222,0.4933111,0.7864445,0.4796222,0.787,0.471,
53.,0.787,0.471,0.7875555,0.4623778,0.7954444,0.4588223,0.806,0.461,
89.,0.806,0.461,0.8165556,0.4631777,0.8297778,0.4710889,0.843,0.479,
85.,0.856,0.52,0.8524222,0.5073333,0.8488444,0.4946666,0.845,0.482,
86.,0.845,0.482,0.8411556,0.4693334,0.8370444,0.4566667,0.833,0.444,
86.,0.833,0.444,0.8289556,0.4313333,0.8249778,0.4186666,0.821,0.406,
303.,0.477,0.164,0.4408222,0.2076,0.4046445,0.2512,0.402,0.28,
154.,0.402,0.28,0.3993555,0.3088,0.4302444,0.3228,0.449,0.323,
97.,0.449,0.323,0.4677556,0.3232,0.4743778,0.3096,0.481,0.296,
303.,0.477,0.164,0.5131778,0.2076,0.5493555,0.2512,0.552,0.28,
154.,0.552,0.28,0.5546445,0.3088,0.5237556,0.3228,0.505,0.323,
97.,0.505,0.323,0.4862444,0.3232,0.4796222,0.3096,0.473,0.296,
52.,0.164,0.567,0.1557555,0.5604222,0.1475111,0.5538445,0.15,0.549,
47.,0.15,0.549,0.1524889,0.5441555,0.1657111,0.5410445,0.17,0.544,
49.,0.17,0.544,0.1742889,0.5469556,0.1696444,0.5559778,0.165,0.565,
-1.
);

vec4 graf()
{
	vec2 w=(v+1.)/2.;
	int idx = 0;
	float t = iTime * 500., T = 0., ts = 0., col=0.;
	while (true) {
		T += so[idx];
		if (t < T) {
			float a = (t - ts) / so[idx];
			float b = 1. - a;
			vec2 p = vec2(
				b*b*b*so[idx+1]+3.*b*b*a*so[idx+3]+3.*b*a*a*so[idx+5]+a*a*a*so[idx+7],
				b*b*b*so[idx+2]+3.*b*b*a*so[idx+4]+3.*b*a*a*so[idx+6]+a*a*a*so[idx+8]
			);
			col += step(distance(p, w), .01);
			break;
		}
		ts += so[idx];
		idx += 9;
		if (so[idx] == -1.) {
			break;
		}
	}
	return vec4(texture(tex,w).xyz + col, 1.);
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
		c=graf();
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
					q.y=1-q.y;
					//l*=q.x; // add color here
					vec3 t=texture(tex,q).xyz;
					l+=t * 3.;
					if (length(t)>.1) l+=.3*e;
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
