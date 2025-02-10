#define LOWMEMORYMODE //uncomment this to load just titlescreen and runtime town

#include "map_files\generic\titlescreen.dmm"
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
