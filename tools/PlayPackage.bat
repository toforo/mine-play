@echo off
title play package
color A
rem 开启变量延迟
setlocal enabledelayedexpansion

rem 获取命令行输入的项目路径
set /p IN_PATH=请输入项目所在路径或主模块路径: 
set IN_PATH=%IN_PATH:/=\%
set IN_PATH=%IN_PATH:\\=\%

rem 打包路径>D:\PlayPackage
set OUT_PATH=D:\PlayPackage
rem 打包路径>桌面
rem set OUT_PATH=%userprofile%\Desktop
rem 打包路径>项目所在路径
rem set OUT_PATH=

set DT=%date:~2,2%%date:~5,2%%date:~8,2%
set TM=%time:~0,2%%time:~3,2%
set TM=%TM: =0%

rem 输入路径是否为主模块路径
if exist "%IN_PATH%\conf\application.conf" (
	set IS_MAIN=1
) else (
	set IS_MAIN=0
)

cd /d "%IN_PATH%"

if "%IS_MAIN%" == "1" (
	cd ..
	set SPLIT_PATH="%IN_PATH%"
	
	rem 获取项目所在目录名(截取最后一级路径名)
	:SPLIT
	for /f "delims=\ tokens=1,*" %%i in (!SPLIT_PATH!) do (
		if "%%j" == "" (
			set MAIN=%%i
			goto PACK
		)
		
		set SPLIT_PATH="%%j"
		goto SPLIT
	)
) else (
	for /f "delims= tokens=*" %%i in ('dir /b') do (
		set MODULE=%%i
		rem set ATTR=%%~ai

		rem 是否为目录
		rem if "!ATTR:~0,1!" == "d" (
			if exist "%IN_PATH%\!MODULE!\conf\application.conf" (
				set MAIN=!MODULE!
				goto PACK
			)
		rem )
	)
)

:PACK
if "%OUT_PATH%" == "" set OUT_PATH=%cd%
set OUT_PATH=%OUT_PATH%\%MAIN:.main=%_%DT%%TM%

echo.    
echo      / )
echo    /  /________
echo _/      _______)打包路径:%OUT_PATH%
echo         __)
echo _       _)
echo  \______)
echo.

rem 打包
rem 不使用call调用时,会在打包命令执行完后自动退出
call play war %MAIN% --exclude .svn:logs:target:tmp -o %OUT_PATH%
if not "%errorlevel%" == "0" echo 打包失败... && goto FAIL

rem 去源码
if not exist "%OUT_PATH%\WEB-INF\application\app" echo 去源码失败... && goto END
if not exist "%OUT_PATH%\WEB-INF\application\modules" echo 去源码失败... && goto END

cd /d "%OUT_PATH%\WEB-INF\application\app"
:CLEAR
for /f "delims= tokens=*" %%i in ('dir /s /b') do (
	set FILE=%%i
	
	rem 删除包内.java文件
	if "!FILE:~-5!" == ".java" (
		echo 删除 %%i
		del /a /f /q %%i
	)
	rem 清空包内.html源码内容
	if "!FILE:~-5!" == ".html" (
		echo 清空 %%i
		cd. > %%i
	)
)
if "%cd%" == "%OUT_PATH%\WEB-INF\application\app" cd /d "%OUT_PATH%\WEB-INF\application\modules" && goto CLEAR

:END
echo.    
echo      / )
echo    /  /________
echo _/      _______)打包路径:%OUT_PATH%
echo         __)
echo _       _)
echo  \______)
echo.

:FAIL
pause
