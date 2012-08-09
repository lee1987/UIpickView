
#ifndef the080_TECSOLDEBUG_h
#define the080_TECSOLDEBUG_h



#endif

#define DEBUG_1 //for username
#define DEBUG_2 //for NSlogs (Application flow)
#define DEBUG_3 // NSlogs (flow descroption)
#define DEBUG_4 //other NSlogs

#ifdef __APPLE__
#include "TargetConditionals.h"
#endif
#if (TARGET_IPHONE_SIMULATOR)
#define DEBUG_S //debug in simulator
#endif
