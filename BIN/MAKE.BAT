@ECHO OFF
BREAK ON

:: set PL/M tools and sources paths
set SOURCES=..\SOURCE

if %PLM80% == "" goto nodef
set PLMBIN=%PLM80%\BIN
set PLMLIB=%PLM80%\LIB
goto clearprev

:nodef
:: !!! predefined path not found, use default !!!
set PLMBIN=C:\PLMTOOL\BIN
set PLMLIB=C:\PLMTOOL\LIB

:clearprev
:: clear previous files
del %SOURCES%\*.obj
del %SOURCES%\*.lst
del iview.com


:: set sources and plm80 paths with ISIS-II style
set :F0:=%PLMBIN%
set :F1:=%SOURCES%
set :F2:=%PLMLIB%

cls
%PLMBIN%\ASM80 :f1:keyb.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:vidasm.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:viewer.m80 MACROFILE
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:util.m80 SYMBOLS NOXREF MACROFILE
if errorlevel == 1 goto error

%PLMBIN%\PLM80 :f1:iview.plm DEBUG PAGEWIDTH(120)
if errorlevel == 1 goto error

echo ===========================================
echo = Yeehaw! All compiled! No Errors! Ready! =
echo ===========================================

pause
cls
@ECHO ON
%PLMBIN%\LINK :f1:iview.obj,:f1:util.obj,:f1:vidasm.obj,:f1:keyb.obj,:f1:viewer.obj,:f2:plm80.lib TO :f1:iview.lnk
%PLMBIN%\LOCATE :f1:iview.lnk TO :f1:iview.kz CODE(100H) STACKSIZE(100) MAP PRINT(:f1:iview.tra)
%PLMBIN%\OBJCPM :f1:iview.kz
@ECHO OFF
copy /b %SOURCES%\iview.com .\iview.com
if errorlevel == 1 goto error

:: copy to HDD image file, for emulator EMU80
:: if exist "D:\EMU80\PK8000\cf.cpm" %PLMBIN%\c8000w.exe -r "D:\EMU80\PK8000\cf.cpm" A: iview.com

goto end

:error
echo ######################################
echo ######################################
echo ######### AN ERROR OCCURED! ##########
echo ######################################
echo ######################################

:end
pause
del %SOURCES%\*.lst
del %SOURCES%\*.obj
del %SOURCES%\iview.kz
del %SOURCES%\iview.lin
del %SOURCES%\iview.lnk
del %SOURCES%\iview.sym
del %SOURCES%\iview.tra
del %SOURCES%\iview.com
