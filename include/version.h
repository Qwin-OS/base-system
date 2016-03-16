#define UNAME "Qwin"
#define KVERSION "0.99"
#define CODENAME "live"
#define PREFIX "-git"

#define DATE __DATE__
#define TIME __TIME__
#if defined(__x86_64__) || defined(_M_X64)
#define ARCH "x86_64"
#elif defined(__i386) || defined(_M_IX86)
#define ARCH "i386"
#endif

