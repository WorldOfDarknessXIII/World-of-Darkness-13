//#define LOWMEMORYMODE //uncomment this to load just centcom and runtime town

#include "map_files\generic\CentCom.dmm"
// #include "map_files\Mining\Lavaland.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\Vampire\runtimetown.dmm"
		#include "map_files\Vampire\SanFrancisco.dmm"
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
