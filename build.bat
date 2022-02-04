@echo off

gcc test.c bus.c -o test.exe -Iinclude
gcc bus.c --shared -o bindings/cbs.dll -Iinclude

exit /B