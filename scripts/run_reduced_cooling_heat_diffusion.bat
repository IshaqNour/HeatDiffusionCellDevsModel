@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0run_reduced_cooling_heat_diffusion.ps1" %*
exit /b %ERRORLEVEL%
