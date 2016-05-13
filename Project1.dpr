library Project1;

uses
  Windows, Messages, SysUtils, Forms;

{$R *.res}

const
  // Constants for gamepad buttons
  XINPUT_GAMEPAD_DPAD_UP          = 1;
  XINPUT_GAMEPAD_DPAD_DOWN        = 2;
  XINPUT_GAMEPAD_DPAD_LEFT        = 4;
  XINPUT_GAMEPAD_DPAD_RIGHT       = 8;
  XINPUT_GAMEPAD_START            = 16;
  XINPUT_GAMEPAD_BACK             = 32;
  XINPUT_GAMEPAD_LEFT_THUMB       = 64;
  XINPUT_GAMEPAD_RIGHT_THUMB      = 128;
  XINPUT_GAMEPAD_LEFT_SHOULDER    = 256;
  XINPUT_GAMEPAD_RIGHT_SHOULDER   = 512;
  XINPUT_GAMEPAD_A                = 4096;
  XINPUT_GAMEPAD_B                = 8192;
  XINPUT_GAMEPAD_X                = 16384;
  XINPUT_GAMEPAD_Y                = 32768;

  //Flags for battery status level
  BATTERY_TYPE_DISCONNECTED       = $00;

  //User index definitions
  XUSER_MAX_COUNT                 = 4;
  XUSER_INDEX_ANY                 = $000000FF;

  //Other
  ERROR_DEVICE_NOT_CONNECTED = 1167;
  ERROR_SUCCESS = 0;

  //Types and headers taken from XInput.pas
  //https://casterprojects.googlecode.com/svn/Delphi/XE2/Projects/DX/DirectXHeaders/Compact/XInput.pas

  type
  //Structures used by XInput APIs
    PXInputGamepad = ^TXInputGamepad;
    _XINPUT_GAMEPAD = record
    wButtons: Word;
    bLeftTrigger: Byte;
    bRightTrigger: Byte;
    sThumbLX: Smallint;
    sThumbLY: Smallint;
    sThumbRX: Smallint;
    sThumbRY: Smallint;
  end;
  XINPUT_GAMEPAD = _XINPUT_GAMEPAD;
  TXInputGamepad = XINPUT_GAMEPAD;

  PXInputState = ^TXInputState;
  _XINPUT_STATE = record
    dwPacketNumber: DWORD;
    Gamepad: TXInputGamepad;
  end;
  XINPUT_STATE = _XINPUT_STATE;
  TXInputState = XINPUT_STATE;

  PXInputVibration = ^TXInputVibration;
  _XINPUT_VIBRATION = record
    wLeftMotorSpeed:  integer; //dword is problem, type?
    wRightMotorSpeed: integer; //dword is problem, type?
  end;
  XINPUT_VIBRATION = _XINPUT_VIBRATION;
  TXInputVibration = _XINPUT_VIBRATION;

  PXInputCapabilities = ^TXInputCapabilities;
  _XINPUT_CAPABILITIES = record
    _Type: Byte;
    SubType: Byte;
    Flags: Word;
    Gamepad: TXInputGamepad;
    Vibration: TXInputVibration;
  end;
  XINPUT_CAPABILITIES = _XINPUT_CAPABILITIES;
  TXInputCapabilities = _XINPUT_CAPABILITIES;

  PXInputBatteryInformation = ^TXInputBatteryInformation;
  _XINPUT_BATTERY_INFORMATION = record
    BatteryType: Byte;
    BatteryLevel: Byte;
  end;
  XINPUT_BATTERY_INFORMATION = _XINPUT_BATTERY_INFORMATION;
  TXInputBatteryInformation = _XINPUT_BATTERY_INFORMATION;

  PXInputKeystroke = ^TXInputKeystroke;
  _XINPUT_KEYSTROKE = record
    VirtualKey: Word;
    Unicode: WideChar;
    Flags: Word;
    UserIndex: Byte;
    HidCode: Byte;
  end;
  XINPUT_KEYSTROKE = _XINPUT_KEYSTROKE;
  TXInputKeystroke = _XINPUT_KEYSTROKE;

//Example https://github.com/r57zone/Standard-modular-program
{function SendLog(str:string):boolean;
var
  CDS: TCopyDataStruct;
begin
  CDS.dwData:=0;
  CDS.cbData:=(length(str)+ 1)*sizeof(char);
  CDS.lpData:=PChar(str);
  SendMessage(FindWindow(nil, 'Show Xinput'),WM_COPYDATA, Integer(Application.Handle), Integer(@CDS));
end;}

function DllMain(inst:LongWord; reason:DWORD; const reserved): boolean;
begin
  Result:=true;
end;

function XInputGetState(
    dwUserIndex: DWORD;      //Index of the gamer associated with the device
    out pState: TXInputState //Receives the current state
 ): DWORD; stdcall;
var
  keys:DWORD;
begin
  pState.Gamepad.bRightTrigger:=0;
  pState.Gamepad.bLeftTrigger:=0;
  pState.Gamepad.sThumbLX:=0;
  pState.Gamepad.sThumbLY:=0;
  pState.Gamepad.sThumbRX:=0;
  pState.Gamepad.sThumbRY:=0;
  keys:=0;

  if GetAsyncKeyState(VK_SPACE)<>0 then keys:=keys+XINPUT_GAMEPAD_A;
  if GetAsyncKeyState(69)<>0 then keys:=keys+XINPUT_GAMEPAD_X; //E
  if GetAsyncKeyState(81)<>0 then keys:=keys+XINPUT_GAMEPAD_Y; //Q
  if GetAsyncKeyState(17)<>0 then keys:=keys+XINPUT_GAMEPAD_B; //CTRL

  //Тригеры мышь
  if GetAsyncKeyState(VK_LBUTTON)<>0 then pState.Gamepad.bRightTrigger:=255;
  if GetAsyncKeyState(VK_RBUTTON)<>0 then pState.Gamepad.bLeftTrigger:=255;
  //Клик правый стик - средняя кнопка мыши
  if GetAsyncKeyState(VK_MBUTTON)<>0 then keys:=keys+XINPUT_GAMEPAD_RIGHT_THUMB;
  //Клик левый стик - SHIFT
  if GetAsyncKeyState(VK_LSHIFT)<>0 then keys:=keys+XINPUT_GAMEPAD_LEFT_THUMB;

  //Левый бампер, 1
  if GetAsyncKeyState(49)<>0 then keys:=keys+XINPUT_GAMEPAD_LEFT_SHOULDER;
  //Правый бампер, 2
  if GetAsyncKeyState(50)<>0 then keys:=keys+XINPUT_GAMEPAD_RIGHT_SHOULDER;

  //Back, s
  if GetAsyncKeyState(VK_ESCAPE)<>0 then keys:=keys+XINPUT_GAMEPAD_BACK;
  //Start
  if GetAsyncKeyState(VK_RETURN)<>0 then keys:=keys+XINPUT_GAMEPAD_START;

  //Вверх
  if GetAsyncKeyState(38)<>0 then keys:=keys+XINPUT_GAMEPAD_DPAD_UP;
  //Вниз
  if GetAsyncKeyState(40)<>0 then keys:=keys+XINPUT_GAMEPAD_DPAD_DOWN;
  //Влево
  if GetAsyncKeyState(37)<>0 then keys:=keys+XINPUT_GAMEPAD_DPAD_LEFT;
  //Вправо
  if GetAsyncKeyState(39)<>0 then keys:=keys+XINPUT_GAMEPAD_DPAD_RIGHT;

  //Левый стик вверх
  if GetAsyncKeyState(87)<>0 then pState.Gamepad.sThumbLY:=32767;
  //Левый стик вниз
  if GetAsyncKeyState(83)<>0 then pState.Gamepad.sThumbLY:=-32768;
  //Левый стик влево
  if GetAsyncKeyState(65)<>0 then pState.Gamepad.sThumbLX:=-32768;
  //Левый стик вправо
  if GetAsyncKeyState(68)<>0 then pState.Gamepad.sThumbLX:=32767;


  //Правый стик вверх
  if GetAsyncKeyState(VK_NUMPAD8)<>0 then pState.Gamepad.sThumbRY:=32767;
  //Правый стик вниз
  if GetAsyncKeyState(VK_NUMPAD2)<>0 then pState.Gamepad.sThumbRY:=-32768;
  //Правый стик влево
  if GetAsyncKeyState(VK_NUMPAD4)<>0 then pState.Gamepad.sThumbRX:=-32768;
  //Правый стик вправо
  if GetAsyncKeyState(VK_NUMPAD6)<>0 then pState.Gamepad.sThumbRX:=32767;

  pState.dwPacketNumber:=GetTickCount;
  pState.Gamepad.wButtons:=keys;
  //SendLog('XInputGetState '+IntToStr(dwUserIndex));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;


function XInputSetState(
    dwUserIndex: DWORD;
    const pVibration: TXInputVibration  //The vibration information to send to the controller
 ): DWORD; stdcall;
begin
  //SendLog('XInputSetState '+IntToStr(dwUserIndex));

  //Temporary solution
  if (pVibration.wLeftMotorSpeed<>0) and (pVibration.wRightMotorSpeed<>0) then
  //Send vibration true or false to other devices
  //SendLog('Motor L='+IntToStr(pVibration.wLeftMotorSpeed)+' R='+IntToStr(pVibration.wRightMotorSpeed)); //incorrect data
  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputGetCapabilities(
    dwUserIndex: DWORD;
    dwFlags: DWORD;                         //Input flags that identify the device type
    out pCapabilities: TXInputCapabilities  //Receives the capabilities
 ): DWORD; stdcall;
begin
  //SendLog('XInputGetCapabilities '+IntToStr(dwUserIndex)+' '+IntToStr(dwFlags));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

procedure XInputEnable(
    enable: BOOL     //Indicates whether xinput is enabled or disabled.
); stdcall;
begin
  //if enable then
  //SendLog('XInputEnable true') else SendLog('XInputEnable false');
end;

function XInputGetDSoundAudioDeviceGuids(
    dwUserIndex: DWORD;
    out pDSoundRenderGuid: TGUID; //DSound device ID for render
    out pDSoundCaptureGuid: TGUID //DSound device ID for capture
 ): DWORD; stdcall;
begin
  //SendLog('XInputGetDSoundAudioDeviceGuids '+IntToStr(dwUserIndex));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputGetBatteryInformation(
    dwUserIndex: DWORD;
    devType: Byte;               //Which device on this user index
    out pBatteryInformation: TXInputBatteryInformation //Contains the level and types of batteries
 ): DWORD; stdcall;
begin
  //SendLog('XInputGetBatteryInformation '+IntToStr(dwUserIndex)+' '+IntToStr(devType));
  Result:=BATTERY_TYPE_DISCONNECTED;
end;

function XInputGetKeystroke(
    dwUserIndex: DWORD;
    dwReserved: DWORD;                // Reserved for future use
    var pKeystroke: TXInputKeystroke  //Pointer to an XINPUT_KEYSTROKE structure that receives an input event.
 ): DWORD; stdcall;
begin
  //SendLog('XInputGetKeystroke '+IntToStr(dwUserIndex)+' '+IntToStr(dwReserved));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputGetStateEx(
    dwUserIndex: DWORD;
    out pState: TXInputState
 ): DWORD; stdcall;
var
  keys:DWORD;
begin
  //SendLog('XInputGetStateEx '+IntToStr(dwUserIndex));

  if dwUserIndex=0 then result:=ERROR_SUCCESS
  else result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputWaitForGuideButton(
    dwUserIndex: DWORD;
    dwFlags: DWORD;
    const LPVOID
 ): DWORD; stdcall;
begin
  //SendLog('XInputWaitForGuideButton '+IntToStr(dwUserIndex)+' '+IntToStr(dwFlags));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputCancelGuideButtonWait(
    dwUserIndex: DWORD               
): DWORD; stdcall;
begin
  //SendLog('XInputCancelGuideButtonWait '+IntToStr(dwUserIndex));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputPowerOffController(
    dwUserIndex: DWORD
): DWORD; stdcall;
begin
  //SendLog('XInputPowerOffController '+IntToStr(dwUserIndex));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

exports
  //XInput 1.3
  DllMain index 1, XInputGetState index 2, XInputSetState index 3, XInputGetCapabilities index 4, XInputEnable index 5,
  XInputGetDSoundAudioDeviceGuids index 6, XInputGetBatteryInformation index 7, XInputGetKeystroke index 8,
  //XInput 1.3 undocumented
  XInputGetStateEx index 100, XInputWaitForGuideButton index 101, XInputCancelGuideButtonWait index 102, XInputPowerOffController index 103;
begin

end.
