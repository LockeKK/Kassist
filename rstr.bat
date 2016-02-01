:: rstr.bat --- 生成随机字符串
:: v1.00 / 2013-6-12 / tmplinshi

@echo off
setlocal enabledelayedexpansion

if "%~1" == "/?" goto usage

:: ------------------- 默认值 -------------------
set d_len=10
set d_StrList=abcdefghijklmnopqrstuvwxyz0123456789
:: ----------------------------------------------



:: =================
:: 生成随机字符串
:: =================
::

rem ############## 获取字符个数
if "%~1" == "" (set len=%d_len%) else (set "len=%~1")

rem 随机“最小字符个数-最大字符个数”
if "%len:-=%" neq "%len%" (
        for /f "tokens=1,2 delims=- " %%a in ("%len%") do (
                set /a min_len = %%a, max_len = %%b
                set /a "len = %random% %% (max_len-min_len+1) + min_len"
        )
)

rem ############## 获取字符串
if "%~2" == "" (
        set StrList=%d_StrList%
) else (
        set "StrList=%~2"

        rem 替换正则
        set StrList=!StrList:\d=0123456789!
        set StrList=!StrList:[0-9]=0123456789!
        set StrList=!StrList:[a-z]=abcdefghijklmnopqrstuvwxyz!
        set StrList=!StrList:[a-zA-Z]=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!
)

rem ############## 计算字符串长度
call :StrLen "%StrList%"

rem ############## 生成随机字符串
set _out=
for /l %%n in (1 1 %len%) do (
        set /a pos = !random! %% StrLen
        for %%p in (!pos!) do set _out=!_out!!StrList:~%%p,1!
)

rem ############## 输出结果
echo,!_out!
exit /b



:: =================
:: 计算字符串长度
:: =================
::
:StrLen <string>
set "_StrList=%~1"
set StrLen=1

for %%a in (2048 1024 512 256 128 64 32 16) do (
        if "!_StrList:~%%a!" neq "" (
                set /a StrLen += %%a
                set _StrList=!_StrList:~%%a!
        )
)
set _StrList=!_StrList!fedcba9876543210
set /a StrLen += 0x!_StrList:~16,1!
goto :eof



:: =================
:: 显示帮助
:: =================
::
:usage
echo %~nx0 --- 生成随机字符串
echo,
echo 用法: %~n0 [字符个数 ^| 最小字符个数-最大字符个数] [字符串]
echo         [字符个数]        默认值: 10
echo         [字符串]        默认值: abcdefghijklmnopqrstuvwxyz0123456789
echo                         可以使用四个正则: \d [0-9] [a-z] [a-zA-Z]
echo,
echo 示例: %~n0
echo       %~n0 10
echo       %~n0 10-15
echo       %~n0 10 "0123&abc"
echo       %~n0 "" \d@-_