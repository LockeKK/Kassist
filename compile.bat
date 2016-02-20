@if not exist .\out md .\out
@if "%TOOLSET%"=="" goto NoToolset
@if not "%CHANNELS%"=="" goto ChannelOK
@set COSMIC=8
:ChannelOK
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\services\auto_gear.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\services\battery.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\services\config.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\services\host_service.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\services\input_service.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\services\security.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\services\rc_monitor.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\services\servo_output.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\services\notification.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac main.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\driver\board.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\driver\storage.c
::cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\driver\oled.c
::cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\driver\pwm.c
::cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\driver\spi.c
::cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\driver\timer.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\driver\uart.c
cxstm8 +warn +proto +mods0 -i. -i.\driver\ -i.\services\ -i"%TOOLSET%\Hstm8" -co.\out -l  -pxp -ac .\driver\vector.c
clnk -l"%TOOLSET%/Lib" -o kassit.sm8 -mkassit.map compile.lkf
cvdwarf kassit.sm8
chex -o kassit.s19 kassit.sm8
@goto:EOF

:NoToolset
@echo TOOLSET variable is not set, set it with "set TOOLSET=path"
