<h2>EN:</h2>
XInput emulation DLL library, which allows to control the game from any device pretending Xbox controller.
<br><br>
For example, you can connect the old game pad or any other controller, and make a homemade gamepad from Arduino.
Also can be used to intercept the vibration of the library.
<br><br>
The most compatible way is to intercept the XInputGetState function. You can intercept it using [this DLL](https://github.com/r57zone/XInputInjectDLL) and an [injector](https://github.com/r57zone/X360Advance#setup-first-method-recommended).
<br><br>
There is also such a way: after compiling renamed file to "xinput1_3.dll", copy the folder with the game or in "C:\Windows\System32". XInput library files exist with several different names and some games require a change in its name. Known names:
<ul>
<li>xinput1_4.dll (Windows 8 / metro apps only)</li>
<li>xinput1_3.dll</li>
<li>xinput1_2.dll</li>
<li>xinput1_1.dll</li>
<li>xinput9_1_0.dll</li>
</ul>
<h2>RU:</h2>
DLL библиотека для эмуляции XInput, позволяющая управлять игрой с любого устройства, притворяясь Xbox контроллером. 
<br><br>
Например, можно подключить старый геймпад или любой другой контроллер, а также сделать самодельный геймпад из Arduino.
Также с помощью библиотеки можно перехватить вибрацию.
<br><br>
Наиболее совместимым способом является перехват функции XInputGetState. Перехватывать её можно, с помощью вот [этой DLL](https://github.com/r57zone/XInputInjectDLL) и [инжектора](https://github.com/r57zone/X360Advance/blob/master/README.RU.md#%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0-%D0%BF%D0%B5%D1%80%D0%B2%D1%8B%D0%B9-%D1%81%D0%BF%D0%BE%D1%81%D0%BE%D0%B1-%D1%80%D0%B5%D0%BA%D0%BE%D0%BC%D0%B5%D0%BD%D0%B4%D1%83%D0%B5%D1%82%D1%81%D1%8F).
<br><br>
Также существует такой способ: после компиляции нужно переименовать файл в "xinput1_3.dll", скопировать в папку с игрой или в "C:\Windows\System32". Xinput библиотеки существуют с несколькими разными именами и некоторые игры требуют другое имя. Известные имена:
<ul>
<li>xinput1_4.dll (Windows 8 / приложения metro)</li>
<li>xinput1_3.dll</li>
<li>xinput1_2.dll</li>
<li>xinput1_1.dll</li>
<li>xinput9_1_0.dll</li>
</ul>
