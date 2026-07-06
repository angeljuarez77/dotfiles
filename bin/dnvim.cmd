@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0dnvim.ps1" %*
