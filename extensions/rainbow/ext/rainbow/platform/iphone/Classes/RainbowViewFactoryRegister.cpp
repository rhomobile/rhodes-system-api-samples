
// rhodes/platform/shared/common/RhoNativeViewManager.h
#include "RhoNativeViewManager.h"

#include "RainbowViewFactory.h"

extern "C"
{
	
	extern "C" void Init_RainbowRuby(void);	

void Init_Rainbow() {
    NativeViewFactory* factory = RainbowViewFactorySingletone::instance();
    RhoNativeViewManager::registerViewType("rainbow_view", factory);
	
	Init_RainbowRuby();
};
	
}
