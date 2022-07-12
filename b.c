
#define dbg
#define messages // so it doesn't freeze when clicking (unnecessary but ok)
//#define nopopup // then screenshot works :^) (when also using "registerclass" and "messages")
//#define registerclass
#define fpslimit
#define XRES 1920
#define YRES 1080

#define WIN32_LEAN_AND_MEAN
#define WIN32_EXTRA_LEAN
#include "windows.h"
#include "mmsystem.h"
#include "mmreg.h"
#include <GL/gl.h>
#include <GL/glext.h>
char *vsh=
"#version 430\n"
"layout (location=0) in vec2 i;"
"out vec2 p;"
"out gl_PerVertex"
"{"
"vec4 gl_Position;"
"};"
"void main() {"
"gl_Position=vec4(p=i,0.,1.);"
"}"
;
#include "frag.glsl.c"

PIXELFORMATDESCRIPTOR pfd={0,1,PFD_SUPPORT_OPENGL|PFD_DOUBLEBUFFER, 32, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0, 0};

#ifdef registerclass
WNDCLASSEX wc = {0};
#endif

/*
DEVMODE dmScreenSettings={ {0},0,0,sizeof(DEVMODE),0,DM_PELSWIDTH|DM_PELSHEIGHT,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1024,768,0,0,0,0,0,0,0,0,0,0};

/*
static DEVMODE dmScreenSettings = { {0},
    #if _MSC_VER < 1400
    0,0,148,0,0x001c0000,{0},0,0,0,0,0,0,0,0,0,{0},0,32,XRES,YRES,0,0,      // Visual C++ 6.0
    #else
    0,0,156,0,0x001c0000,{0},0,0,0,0,0,{0},0,32,XRES,YRES,{0}, 0,           // Visuatl Studio 2005
    #endif
    #if(WINVER >= 0x0400)
    0,0,0,0,0,0,
    #if (WINVER >= 0x0500) || (_WIN32_WINNT >= 0x0400)
    0,0
    #endif
    #endif
    };
    */

// define this if you have a multicore cpu and can spare ~10 bytes for realtime playback
// undef for sound precalc
#define USE_SOUND_THREAD

////////////////////////////////////////////////
// sound
////////////////////////////////////////////////

// some song information
#include "4klang.h"

// MAX_SAMPLES gives you the number of samples for the whole song. we always produce stereo samples, so times 2 for the buffer
SAMPLE_TYPE	lpSoundBuffer[MAX_SAMPLES*2];  
HWAVEOUT	hWaveOut;

/////////////////////////////////////////////////////////////////////////////////
// initialized data
/////////////////////////////////////////////////////////////////////////////////

#pragma data_seg(".wavefmt")
WAVEFORMATEX WaveFMT =
{
#ifdef FLOAT_32BIT	
	WAVE_FORMAT_IEEE_FLOAT,
#else
	WAVE_FORMAT_PCM,
#endif		
    2, // channels
    SAMPLE_RATE, // samples per sec
    SAMPLE_RATE*sizeof(SAMPLE_TYPE)*2, // bytes per sec
    sizeof(SAMPLE_TYPE)*2, // block alignment;
    sizeof(SAMPLE_TYPE)*8, // bits per sample
    0 // extension not needed
};

#pragma data_seg(".wavehdr")
WAVEHDR WaveHDR = 
{
	(LPSTR)lpSoundBuffer, 
	MAX_SAMPLES*sizeof(SAMPLE_TYPE)*2,			// MAX_SAMPLES*sizeof(float)*2(stereo)
	0, 
	0, 
	0, 
	0, 
	0, 
	0
};

MMTIME MMTime = 
{ 
	TIME_SAMPLES,
	0
};

/////////////////////////////////////////////////////////////////////////////////
// crt emulation
/////////////////////////////////////////////////////////////////////////////////

	int _fltused = 1;

/////////////////////////////////////////////////////////////////////////////////
// Initialization
/////////////////////////////////////////////////////////////////////////////////

#pragma code_seg(".initsnd")
void  InitSound()
{
#ifdef USE_SOUND_THREAD
	// thx to xTr1m/blu-flame for providing a smarter and smaller way to create the thread :)
	CreateThread(0, 0, (LPTHREAD_START_ROUTINE)_4klang_render, lpSoundBuffer, 0, 0);
#else
	_4klang_render(lpSoundBuffer);
#endif
	waveOutOpen			( &hWaveOut, WAVE_MAPPER, &WaveFMT, NULL, 0, CALLBACK_NULL );
	waveOutPrepareHeader( hWaveOut, &WaveHDR, sizeof(WaveHDR) );
	waveOutWrite		( hWaveOut, &WaveHDR, sizeof(WaveHDR) );	
}

/////////////////////////////////////////////////////////////////////////////////
// entry point for the executable if msvcrt is not used
/////////////////////////////////////////////////////////////////////////////////
#pragma code_seg(".main")
//gcc+ld? int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd)
//gcc+link? int WINAPI _WinMainCRTStartup(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd)
//gcc+crinkler void mainCRTStartup(void)
//gcc+crinkler subsystem:windows
void WinMainCRTStartup(void)
{
#ifdef dbg
	char log[1024];
	int logsize;
#endif
#ifdef messages
	MSG msg;
#endif
#ifdef nopopup
	RECT rect;
#endif
	DEVMODE dm = {0};
	dm.dmSize = sizeof(DEVMODE);
	dm.dmFields = DM_PELSHEIGHT | DM_PELSWIDTH;
	dm.dmPelsWidth = XRES;
	dm.dmPelsHeight = YRES;

	float fparams[4*2];
	int it,t,
#ifdef fpslimit
		t2=-1004,
#endif
		k,tex;
	ChangeDisplaySettings(&dm,CDS_FULLSCREEN);

#ifdef registerclass
	wc.cbSize = sizeof(WNDCLASSEX);
	wc.style = 0;
	wc.lpfnWndProc = DefWindowProc;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.hInstance = (HINSTANCE)0x400000;
	wc.hIcon = LoadIcon(NULL, IDI_APPLICATION); /*large icon (alt tab)*/
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground = (HBRUSH) COLOR_WINDOW;
	wc.lpszMenuName = NULL;
	wc.lpszClassName = "metroclass";
	wc.hIconSm = LoadIcon(NULL, IDI_APPLICATION); /*small icon (taskbar)*/

	if (!RegisterClassEx(&wc)) {
		ExitProcess(0);
	}

	HANDLE hWnd = CreateWindowEx(WS_EX_APPWINDOW,wc.lpszClassName,"title",
#ifndef nopopup
		WS_POPUP |
#endif
		WS_VISIBLE | WS_MAXIMIZE, 0, 0, XRES, YRES, 0, 0, wc.hInstance, 0);
#else
	HANDLE hWnd = CreateWindow("static",0,
#ifndef nopopup
		WS_POPUP |
#endif
		WS_VISIBLE | WS_MAXIMIZE, 0, 0, XRES, YRES, 0, 0, 0, 0);
#endif
	HDC hDC = GetDC(hWnd);
	SetPixelFormat(hDC, ChoosePixelFormat(hDC, &pfd) , &pfd);
	wglMakeCurrent(hDC, wglCreateContext(hDC));
	/*
	GLuint p = ((PFNGLCREATEPROGRAMPROC)wglGetProcAddress("glCreateProgram"))();
	GLuint s = k =((PFNGLCREATESHADERPROC)(wglGetProcAddress("glCreateShader")))(GL_VERTEX_SHADER);
	((PFNGLSHADERSOURCEPROC)wglGetProcAddress("glShaderSource"))(s,1, &vsh,0);
	((PFNGLCOMPILESHADERPROC)wglGetProcAddress("glCompileShader"))(s);
	((PFNGLATTACHSHADERPROC)wglGetProcAddress("glAttachShader"))(p,s);
	s = ((PFNGLCREATESHADERPROC)
	wglGetProcAddress("glCreateShader"))(GL_FRAGMENT_SHADER);
	((PFNGLSHADERSOURCEPROC)wglGetProcAddress("glShaderSource"))(s,1, &fsh,0);
	((PFNGLCOMPILESHADERPROC)wglGetProcAddress("glCompileShader"))(s);
	((PFNGLATTACHSHADERPROC)wglGetProcAddress("glAttachShader"))(p,s);
	((PFNGLLINKPROGRAMPROC)wglGetProcAddress("glLinkProgram"))(p);
	((PFNGLUSEPROGRAMPROC)wglGetProcAddress("glUseProgram"))(p);
	*/
	GLuint p = ((PFNGLCREATESHADERPROGRAMVPROC)wglGetProcAddress("glCreateShaderProgramv"))(GL_VERTEX_SHADER, 1, &vsh);
	GLuint s = ((PFNGLCREATESHADERPROGRAMVPROC)wglGetProcAddress("glCreateShaderProgramv"))(GL_FRAGMENT_SHADER, 1, &fragSource);
	((PFNGLGENPROGRAMPIPELINESPROC)wglGetProcAddress("glGenProgramPipelines"))(1, &k);
	((PFNGLBINDPROGRAMPIPELINEPROC)wglGetProcAddress("glBindProgramPipeline"))(k);
	((PFNGLUSEPROGRAMSTAGESPROC)wglGetProcAddress("glUseProgramStages"))(k, GL_VERTEX_SHADER_BIT, p);
	((PFNGLUSEPROGRAMSTAGESPROC)wglGetProcAddress("glUseProgramStages"))(k, GL_FRAGMENT_SHADER_BIT, s);
#ifdef dbg
	logsize = 0;
	((PFNGLGETPROGRAMINFOLOGPROC)wglGetProcAddress("glGetProgramInfoLog"))(s, sizeof(log), &logsize, log);
	if (log[0] && logsize) {
		MessageBoxA(NULL, log, "hi", MB_OK);
		ExitProcess(1);
	}
#endif
	ShowCursor(0);
	//glActiveTexture(GL_TEXTURE0);
	((PFNGLACTIVETEXTUREPROC)wglGetProcAddress("glActiveTexture"))(GL_TEXTURE0); // TODO: seems to work without, remove?
	glGenTextures(1, &tex);
	glBindTexture(GL_TEXTURE_2D, tex);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	//((PFNGLGENTEXTURESEXTPROC)wglGetProcAddress("glGenTexturesEXT"))(1, &tex);
	//((PFNGLBINDTEXTURESPROC)wglGetProcAddress("glBindTextures"))(GL_TEXTURE_2D, 1, &tex);
	//int x=GL_LINEAR;
	//((PFNGLTEXPARAMETERIIVPROC)wglGetProcAddress("glTexParameterIiv"))(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, &x);
	//((PFNGLTEXPARAMETERIIVPROC)wglGetProcAddress("glTexParameterIiv"))(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, &x);
	/*
	GetClientRect(hWnd, &rect);
	for (t=0;t<6;t++){
		log[t]='0' + (rect.right%10);
		rect.right/=10;
	}
	log[6]=0;
	MessageBoxA(NULL, log, "hi", MB_OK);
	ExitProcess(1);
	*/

	/*
	HMONITOR monitor = MonitorFromWindow(hWnd, MONITOR_DEFAULTTONEAREST);
	MONITORINFO info;
	info.cbSize = sizeof(MONITORINFO);
	GetMonitorInfo(monitor, &info);
	rect.right = info.rcMonitor.right - info.rcMonitor.left;
	rect.bottom = info.rcMonitor.bottom - info.rcMonitor.top;
	*/

	//glViewport(0, 0, XRES, YRES);

	InitSound();
	it=GetTickCount();
	do
	{
		// get sample position for timing
		waveOutGetPosition(hWaveOut, &MMTime, sizeof(MMTIME));

		t=GetTickCount()-it;

#ifdef messages
		while (PeekMessage(&msg, 0, 0, 0, PM_REMOVE)) {
			if (msg.message == WM_QUIT) {
				goto done;
			}
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
#endif

#ifdef fpslimit
		if (t - t2 > 50) {
#endif

			// should technically also bind the texture ... but it works without ..
			fparams[0] = t/1000.0f;
			fparams[1] = 2.f;
			((PFNGLPROGRAMUNIFORM4FVPROC)wglGetProcAddress("glProgramUniform4fv"))(s, 0, 2, fparams);
			glRecti(1,1,-1,-1);
#ifdef nopopup
			GetClientRect(hWnd, &rect);
			glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 0, 0, rect.right, rect.bottom, 0);
#else
			glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 0, 0, XRES, YRES, 0);
#endif

			fparams[1] = .0f;
			//fparams[4] = (&_4klang_envelope_buffer)[((MMTime.u.sample >> 8) << 5) + 2*2+0] > .9f ? .7f : .1f;
			//fparams[4] = (&_4klang_note_buffer)[((MMTime.u.sample >> 8) << 5) + 2*3+0] > 0 ? .3f : .1f;
			((PFNGLPROGRAMUNIFORM4FVPROC)wglGetProcAddress("glProgramUniform4fv"))(s, 0, 2, fparams);
			glRecti(1,1,-1,-1);
			SwapBuffers(hDC);
#ifdef fpslimit
			t2 = t;
		}
#endif

		// do your intro mainloop here
		// RenderIntro(MMTime.u.sample);

	} while (MMTime.u.sample < MAX_SAMPLES && !GetAsyncKeyState(VK_ESCAPE));
done:
	ChangeDisplaySettings(0,0);
	ShowCursor(1);
	ExitProcess(0);
}
