@echo off
title play build
color A

rem 获取命令行输入的项目路径
set /p IN_PATH=请输入项目所在路径: 
set IN_PATH=%IN_PATH:/=\%
set IN_PATH=%IN_PATH:\\=\%

cd /d "%IN_PATH%"

rem 构建环境
for /f "delims= tokens=*" %%i in ('dir /b') do (
	if exist "%IN_PATH%\%%i\conf\dependencies.yml" (
		rem 构建依赖
		call play dependencies %%i
		
		rem 创建eclipse配置文件
		call play eclipsify %%i
		rem 创建IntelliJ Idea配置文件
		rem call play idealize %%i
	)
)

pause
