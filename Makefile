all:
	gcc -x c -c b.c -o b.o
	"Crinkler\crinkler.exe" b.o 4klang.obj "/LIBPATH:C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib" kernel32.lib user32.lib opengl32.lib gdi32.lib winmm.lib
