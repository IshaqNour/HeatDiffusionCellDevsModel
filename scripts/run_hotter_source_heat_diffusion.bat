@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0run_hotter_source_heat_diffusion.ps1" %*
exit /b %ERRORLEVEL%
