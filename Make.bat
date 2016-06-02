@Echo off
Del C:\Temp\Borland\*.* /q
Del .\Bin\VS3.exe /q
Del .\Bin\Web.cgi /q
Del .\Setup\VS3.exe /q
Del .\Setup\Web\VS3.cgi /q
Echo.
Echo =============================
Echo  Compiling modules
Echo =============================
Echo.
cd Sources
DCC32 VS3
Echo.
DCC32 Web
Echo.
cd ..
cd Bin
Copy VS3.exe ..\Setup\ /y
Copy Web.cgi ..\Setup\Web\VS3.cgi /y
Copy VS3EN.lang ..\Setup\ /y
Copy VS3FR.lang ..\Setup\ /y
Echo.
Echo =============================
Echo  Done
Echo =============================
Echo.
Pause