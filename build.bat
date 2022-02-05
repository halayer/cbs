@echo off

gcc -c bus.c -o bus.o -Iinclude
gcc bus.c --shared -o bindings/cbs.dll -Iinclude

cd bindings/ada
gcc -c components.ads
gcc -c buses.ads
cd ../..

exit /B
