// #define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\generic\CentCom.dmm"
// #include "map_files\Mining\Lavaland.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
//		#include "map_files\debug\runtimestation.dmm"
//		#include "map_files\Vampire\SanFrancisco.dmm"
		#include "map_files\Vampire\LongBeachPractice.dmm"
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
