
if "%RHO_PLATFORM%" == "android" (

cd nlist\platform\android
rake --trace

)

if "%RHO_PLATFORM%" == "iphone" (

cd nlist\platform\phone
rake --trace

)

if "%RHO_PLATFORM%" == "wm" (

cd nlist\platform\wm
rake --trace

)

if "%RHO_PLATFORM%" == "win32" (

cd nlist\platform\wm
rake --trace

)

if "%RHO_PLATFORM%" == "bb" (

cd nlist\platform\bb
rake --trace

)

