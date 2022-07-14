// vi: syntax=c
#version 430
#define iTime fpar[0].x
#define TAU 6.283185 //noexport
#define PI 3.141592 //noexport
#define debugmov 1 //noexport
#define cam(t,ca,mm,nn) for(i=0;ttt>ca[i+1]&&ca[i+6]!=-1;i+=6);g=(ttt-ca[i])/(ca[i+1]-ca[i]);s=1-g;t=(s*s*s*ca[i+2]+s*s*g*3*ca[i+3]+s*g*g*3*ca[i+4]+g*g*g*ca[i+5])*mm-nn;
layout (location=0) uniform vec4 fpar[2];
layout (location=2) uniform vec4 debug[2]; //noexport
layout (location=4) uniform sampler2D tex;
out vec4 c;
in vec2 v;
float s,ttt,g;
int i;

const float[] so = float[] (
// logicoma (22=111)
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
0.201,34.71,25.77,41.85,31.88,
0.181,43.75,38.73,36.91,43.88,
0.230,48.81,54.65,38.86,50.88,
0.137,53.75,54.82,54.85,54.89,
0.147,54.78,56.77,59.74,58.89,
0.229,64.82,72.67,54.82,66.89,
0.189,73.75,62.80,81.85,70.89,
0.286,77.89,76.73,83.68,83.90,
0.050,77.83,79.83,80.83,82.83,
0.213,86.71,86.82,86.91,90.90,
0.035,86.76,87.76,88.76,90.76,
-1,
// flopine evvvil blackle yx (30=151)
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
//eos loonies prismbeings (28=141)
0.261,11.28,23.14,0.19,13.33,
0.222,19.22,12.41,27.27,20.22,
0.184,29.20,18.24,36.29,24.34,
0.253,47.24,45.38,46.45,48.49,
0.215,54.38,46.43,58.58,55.39,
0.214,61.40,54.56,69.48,61.40,
0.099,67.41,67.45,67.48,67.51,
0.118,67.43,70.43,72.42,71.52,
0.110,76.42,75.46,75.50,75.53,
0.176,80.49,86.44,73.40,81.56,
0.152,89.47,82.45,92.58,84.58,
0.249,9.68,9.78,9.86,10.93,
0.167,9.68,14.67,17.77,9.80,
0.114,18.66,18.70,18.74,18.78,
0.055,18.71,18.69,21.67,22.68,
0.123,25.67,25.71,25.75,25.79,
0.160,31.67,25.72,35.77,29.81,
0.245,34.81,35.62,39.68,38.81,
0.136,38.72,41.70,42.71,42.81,
0.225,47.59,46.70,46.76,46.81,
0.138,48.74,52.71,53.83,46.82,
0.168,56.77,62.69,49.75,57.83,
0.121,61.72,61.76,61.80,61.84,
0.119,65.73,65.78,65.82,65.85,
0.131,65.76,68.74,70.74,69.85,
0.146,76.85,70.85,73.74,76.74,
0.295,77.74,75.82,85.97,67.96,
0.176,83.74,73.81,90.82,81.89,
-1,
// LJ virgill lug00ber iq (25=126)
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
//black valley 2022 (23=115)
0.423,10.45,3.02,24.25,9.31,
0.233,11.31,21.29,20.45,10.45,
0.275,18.26,29.37,12.51,28.44,
0.342,25.38,25.26,30.11,33.43,
0.058,26.32,28.33,30.33,31.33,
0.233,41.44,33.47,34.26,41.26,
0.283,44.15,45.25,44.36,46.43,
0.207,52.42,41.30,47.31,49.24,
0.431,23.54,30.86,31.78,33.54,
0.350,34.76,38.49,39.57,41.76,
0.045,36.67,38.68,39.67,40.68,
0.215,44.55,44.67,44.74,47.76,
0.215,49.55,49.67,49.75,52.76,
0.242,55.70,63.56,45.63,58.76,
0.139,60.62,60.70,61.74,64.75,
0.296,67.62,67.80,63.82,52.82,
0.243,67.22,67.06,81.25,61.23,
0.106,61.22,63.26,65.28,66.32,
0.300,70.39,71.13,85.39,70.40,
0.218,79.45,83.32,88.55,73.47,
0.103,73.46,74.50,75.53,77.56,
0.243,86.62,89.47,96.76,79.63,
0.119,79.63,81.68,82.72,83.74,
-1
);

const float[] ax=float[](
.07,21.13,.58,.58,.58,.58,
21.13,25.88,.58,.58,.69,.71,
25.88,30.63,.71,.72,.7,.73,
30.63,36.5,.73,.74,.92,.92,
36.5,41.12,.92,.92,.8,.8,
41.12,45.03,.8,.81,.89,.89,
45.03,50.39,.89,.89,.89,.89,
50.39,59.39,.89,.89,.57,.57,
59.39,65.03,.57,.57,.57,.57,
65.03,71.84,.57,.57,.24,.21,
71.84,76.48,.21,.19,.17,.17,
76.48,79.84,.17,.17,.24,.24,
79.84,86.34,.24,.24,.24,.24,
86.34,88.75,.24,.24,.15,.15,
88.75,93.75,.15,.15,.15,.15,
93.75,98.75,.15,.15,.15,.15,
98.75,103.75,.15,.15,.15,.15,
-1);
const float[] ay=float[](
-0.1,21.81,.02,.12,.26,.33,
21.81,27.44,.33,.35,.35,.37,
27.44,45.07,.37,.4,.49,.52,
45.07,49.41,.52,.53,.54,.55,
49.41,59.39,.55,.56,.7,.7,
59.39,66.39,.7,.7,.56,.55,
66.39,71.75,.55,.54,.54,.54,
71.75,76.94,.54,.54,.5,.46,
76.94,79.63,.46,.44,.4,.4,
79.63,85.56,.4,.4,.4,.4,
85.56,91.43,.4,.4,.25,.25,
91.43,97.,.25,.25,.25,.25,
97.,102.,.25,.25,.25,.25,
102.,107.,.25,.25,.25,.25,
-1);
const float[] az=float[](
-0.07,6.38,.17,.26,.38,.37,
6.38,30.96,.37,.37,.37,.37,
30.96,44.65,.37,.37,.12,.12,
44.65,49.65,.12,.12,.12,.12,
49.65,59.48,.12,.12,.57,.57,
59.48,64.48,.57,.57,.57,.57,
64.48,71.48,.57,.57,.43,.43,
71.48,76.48,.43,.43,.43,.43,
-1);
const float[] ah=float[](
.05,21.17,.37,.37,.37,.37,
21.17,27.4,.37,.37,.26,.26,
27.4,40.39,.26,.26,.44,.39,
40.39,45.44,.39,.37,.33,.3,
45.44,48.93,.3,.27,.24,.21,
48.93,52.21,.21,.19,.19,.19,
52.21,59.57,.19,.19,.24,.24,
59.57,62.89,.24,.24,.25,.29,
62.89,66.53,.29,.33,.45,.46,
66.53,80.16,.46,.5,.55,.55,
80.16,86.66,.55,.55,.55,.55,
86.66,93.31,.55,.55,.64,.64,
93.31,98.31,.64,.64,.64,.64,
98.31,103.31,.64,.64,.64,.64,
103.31,108.31,.64,.64,.64,.64,
-1);
const float[] av=float[](
-0.13,5.32,.99,.99,.91,.71,
5.32,9.15,.71,.57,.53,.53,
9.15,30.8,.53,.53,.53,.53,
30.8,39.65,.53,.53,.49,.46,
39.65,47.85,.46,.43,.35,.35,
47.85,52.81,.35,.35,.35,.35,
52.81,59.3,.35,.35,.49,.49,
59.3,64.39,.49,.49,.49,.49,
-1);

vec3 graf()
{
	float t,T=0,ts=0,col=0,j,_a,a,b;
	i = 0;
	if(iTime>76){
		i=529;
		t=(iTime-76)*1.5;
	}else if(iTime>74.7){
		return vec3(0);
	}else if(iTime>67){
		i=403;
		t=(iTime-67)*1.5;
	}else if(iTime>65.65){
		return vec3(0);
	}else if(iTime>57.5){
		i=262;
		t=(iTime-57.5)*1.5;
	}else if(iTime>56.2){
		return vec3(0);
	}else if(iTime>44){
		i=111;
		t=(iTime-44)*1.5;
	}else if(iTime>31.7){
		return vec3(0);
	}else if(iTime>24){
		i=0;
		t=(iTime-24)*1.5;
	}else{
		return vec3(0);
	}
	vec2 w=(v+1.)/2.;
	while (t>0) {
		T += so[i];
		if (t < T) {
			_a = (t - ts) / so[i];
			for (j=0;j<.80;j+=.01) { // TODO: tweak
				a=clamp(_a+j-.4,0,1);
				b = 1. - a;
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

vec3 op=vec3(1.),p=op,n;
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
vec3 march(vec3 o,vec3 v,int s){ // x=hit y=dist_to_p z=tot_dist
	vec3 r=vec3(0);
	for(i=0;i<s&&r.z<350;i++){
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
			r.y=d;
			flopine_shade=1.-float(i)/100.;
			r.x=1;
			break;
		}
		r.z+=d;
	}
	return r;
}

float lit(vec3 h,vec2 a) {
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
	vec2 q,lo,uv=v;uv.y/=1.77;
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

	ttt = rand(v)*.001 + iTime;
	vec3 ro = vec3(10*sin(ttt), -30*cos(ttt), -20);

	//vec3 ro = vec3(20, -50, -20);
	//ro.x = fpar[0].y/10.;
	//vec2 m = iMouse.xy/iResolution.xy;
	//ro.yz *= rot2(-m.y*PI+1.);
	//ro.xy *= rot2(-m.x*TAU);
	vec3 at = vec3(0,0,-25);

	float h,down,xylen;
#if debugmov //noexport
	ro = debug[0].xyz; //noexport
	down = debug[1].y/20.; //noexport
	if (abs(down) < .001) down = .001; //noexport
	xylen = sin(down); //noexport
	down = cos(down); //noexport
	at.x = ro.x+cos(debug[1].x/20.)*xylen; //noexport
	at.y = ro.y+sin(debug[1].x/20.)*xylen; //noexport
	at.z = ro.z+down; //noexport
#endif //noexport
	//ro=vec3(-25,-750,-20);
	//ro.y+=iTime*10;
	//at=vec3(-25,20,-20);
	if(fpar[1].w>1){ //noexport
		cam(ro.x,ax,300,200);
		cam(ro.y,ay,2400,800);
		cam(ro.z,az,-80,0);
		cam(h,ah,12,6);
		cam(down,av,3,3);
	} else { //noexport
		ro=fpar[1].xyz; //noexport
		h=fpar[0].z; //noexport
		down=fpar[0].w; //noexport
	} //noexport
	if (abs(down) < .001) down = .001;
	xylen = sin(down);
	down = cos(down);
	at.x = ro.x+cos(h)*xylen;
	at.y = ro.y+sin(h)*xylen;
	at.z = ro.z+down;

	vec3 xx,l,cf=normalize(at-ro),
		cl=normalize(cross(cf,vec3(0,0,-1))),
		rd=mat3(cl,normalize(cross(cl,cf)),cf)*normalize(vec3(uv,1)),
		b,col,//vec3(.1-length(uv)*.1);
		r=march(ro,rd,200);
	if (r.x>0) {
		// hit
		float e=rand(mod(p.xy,10));
		col=b=vec3(.05+.05*e);
		//col=vec3(flopine_shade);
		// big area lights
		n=norm(p, r.y);
		xx=p;
		l=vec3(1.,.92,.71);
		//if (s==0.) l+=.2*e;
		if(s==2.)l*=.2; // darker floor
		if(s==3.){
			q=p.yz;
			q.x=mod(q.x,400);
			q=(q-vec2(60,-50))/vec2(80,45);
			if (q.x>.01&&q.y>.01&&q.x<.99&&q.y<.99) {
				if(p.x<0)q.x=1-q.x; // other direction for other side
				//l*=q.x; // add color here
				vec3 t=texture(tex,q).xyz;
				l+=t*3.;
				if(length(t)>.1) l+=.9*e; // TODO is this needed
				//l=vec3(graf(q))*7.;
			}
		}
		if(s==4.)l*=vec3(.22,.14,.04)+.05*e;
		if(s==5.)l*=vec3(.6)+.05*e;
		if (p.y>-99) {
			lo=p.xy;
			lo.y+=100;
			lo.y-=mod(lo.y,400)-100;
			//lo.y+=75;
			//lo.y+=20;
			//lo.y-=mod(lo.y,200)-100;
			lo.x-=mod(lo.x,160);
			col+=l*lit(xx,lo);
			col+=l*lit(xx,lo+vec2(160,0));
			col+=l*lit(xx,lo+vec2(-160,0));
		}
		if(p.y<-50){
			lo=p.xy;
			//lo.y+=100;
			lo.y-=mod(lo.y,400)-200;
			lo.x=lo.x<-80?-160:0;
			xx.xy=lo;
			xx.z=-30;
			col+=l*.2*dot(n,normalize(xx-p))/pow(length(p-xx)/40,3);
		}
		col=mix(col,b,smoothstep(300,350,r.z));
	}else{
		col=vec3(.05+.05*rand(mod(vec2(r.z,r.y),10)));
	}

	//if (!hit) {
		//col = pow(col, vec3(.4545));	// gamma correction
		col = pow(col, vec3(.8545));	// gamma correction
	//}

	c = vec4(col,1.0);
}
