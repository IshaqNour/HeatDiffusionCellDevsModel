@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0run_nonuniform_initial_heat_diffusion.ps1" %*
exit /b %ERRORLEVEL%
