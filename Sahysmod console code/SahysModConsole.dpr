program SahysModConsole;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Forms,
  Windows,
  TLHelp32,
  UMain in 'UMain.pas',
  UDataMod in 'UDataMod.pas',
  UExtraUtils in 'UExtraUtils.pas',
  UInputData in 'UInputData.pas',
  UDataTest in 'UDataTest.pas',
  UInitialCalc in 'UInitialCalc.pas',
  UMainCalc in 'UMainCalc.pas';

var
  InitDir, OutDir: string;
  InitDirStr, OutDirStr: string;
  key: string;
  step: boolean;
  Max, Coord : TCoord;
  ConHandle : THandle;
  tmp : cardinal;
  i: Integer;
  KillProcIn, KillProcOut: boolean;

procedure Clrscr;
begin
	Coord.X := 0;
	Coord.Y := 0;
	FillConsoleOutputCharacter(ConHandle, ' ', Max.X * Max.Y, Coord, tmp);
	SetConsoleCursorPosition(ConHandle, Coord);
end;

function KillProcess(ExeName: string): LongBool;
var
 B: BOOL;
 ProcList: THandle;
 PE: TProcessEntry32;
begin
 Result := False;
 ProcList := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
 PE.dwSize := SizeOf(PE);
 B := Process32First(ProcList, PE);
 while B do begin
   if (UpperCase(PE.szExeFile) = UpperCase(ExtractFileName(ExeName))) then
     Result := TerminateProcess(OpenProcess($0001, False, PE.th32ProcessID), 0);
    B := Process32Next(ProcList, PE);
 end;
 CloseHandle(ProcList);
end;

begin
  Application.CreateForm(TDataMod, DataMod);
  KillProcIn:= false;
  KillProcOut:= false;
  step:= true;
  while step do
  begin
    Clrscr;
    KillProcIn:= false;
    KillProcOut:= false;
    for i := 1 to ParamCount do
    begin
      InitDirStr:= ParamStr(1);
      OutDirStr:=  ParamStr(2);
    end;

    InitDir:= InitDirStr;
    OutDir:= OutDirStr;

	  ConHandle := GetStdHandle(STD_OUTPUT_HANDLE);
	  Max := GetLargestConsoleWindowSize(ConHandle);
    if InitDir = '' then
    begin
      Write('InputFile = ');
      Readln(InitDir);
      InputOpened:=false;
    end;
    while InputOpened = false do
    begin
      if FileExists (InitDir) then
        InputOpened:=true
      else
        begin
          //Writeln ('File does not exist, please select another one,');
          //Write('InputFile = ');
          //Readln(InitDir);
          KillProcIn:= true;
          InputOpened:=true;
        end;
    end;

    if OutDir = '' then
    Begin
      Write('OutFile = ');
      Readln(OutDir);
      OutSave:=false;
    end;
    while OutSave = false do
    begin
      if DirectoryExists(ExtractFileDir(OutDir)) AND (ExtractFileName(OutDir) <> '') AND (ExtractFileExt(OutDir) <> '') then
        OutSave:=true
      else
        begin
          //Writeln ('Directory does not exist or incorrectly entered the file extension,');
          //Writeln ('please enter another one,');
          //Write('OutFile = ');
          //Readln(OutDir);
          KillProcOut:= true;
          OutSave:=true;
        end;
    end;

    if  not KillProcIn AND not KillProcOut then
      InputOpen_Execute(InitDir, OutDir);

    if (InitDirStr = '') and (OutDirStr = '') then
    begin
      Write('If you want to have to do the calculation, press key "Y". Key = ');
      Readln(key);
      if AnsiUpperCase(key) = 'Y' then
        step:= True
      else step:= False;
    end else
      step:= False;

  end;
  //Readln;
  sleep(1500);
  KillProcess('cmd.exe');
end.
