@echo off

gcc test.c ../bus.o -I../include -o c_test.exe

cd ada
gcc -c test_component.adb -I../../bindings/ada
gcc -c test.adb -I../../bindings/ada
gnatbind test -I../../bindings/ada
gnatlink test ../../bus.o
del test_component.ali
del test_component.o
del test.ali
del test.o
cd ..

exit /B
