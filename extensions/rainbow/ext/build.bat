
if "%RHO_PLATFORM%" == "android" (

cd rainbow\platform\android
rake --trace

)

if "%RHO_PLATFORM%" == "iphone" (

cd rainbow\platform\phone
rake --trace

)

if "%RHO_PLATFORM%" == "wm" (

cd rainbow\platform\wm
rake --trace

)

if "%RHO_PLATFORM%" == "bb" (

cd rainbow\platform\bb
rake --trace

)

