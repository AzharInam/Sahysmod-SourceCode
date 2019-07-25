unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls;

procedure InputOpen_Execute(AInitDir, AOutDir: string);
procedure PresentData;
procedure InputSave_Execute;
function SetAndVerifySaveName : boolean;
procedure DoCalculations;
procedure RestrictInputArrays (const DataSheet : string);
procedure ReduceOutputArrays;

var
  InitDir, DataDir, OutDir : string;
  NrOfErrorLines          : integer;

  NoSave, GraphOpened, GroupOpened, DoItSelf,
  SelfDone, InternalDataDone, CalcButtonUsed,
  NoRead, RunTimeError, InflowChange,
  SetToGroupSelection, ChangeOfSeasonDuration,
  AreasChecked, SetInitialDrainage,
  SetInitAquiConditions, SetInitialAreas,
  CallFirst, Critical, StartUp, SkipAgri,
  DrainChange, ResponsChange, AquiferChange,
  NrOfSeasonsChange, MakeCorrection,
  OverallSaved, NetworkSaved,
  SeasonsAdded, AgriRevised : boolean;

  GuidedOK, AreaChange,
  GuideEnded,GuideStop,
  Pasted, Destroyed : boolean;

  Identity : string;

implementation

uses  UDataMod, UExtraUtils, UInputData, UDataTest, UInitialCalc, UMainCalc;

{Action: FileOpen, Menu: InputOpen}
{---------------------------------}
procedure InputOpen_Execute(AInitDir, AOutDir: string);
{-----------------------------------------------------}
var DoItSelf : boolean;
begin
  InitDir:=Getcurrentdir;
  CalcButtonUsed:=false;
  OutputOpened := false;
  GroupOpened := false;
  InputOpened := false;
  GraphOpened := false;
  InternalDataDone:=false;
  SelfDone:=false;
  NoRead:=false;
  SkipAgri:=false;
  SetToGroupSelection:=false;
  ChangeOfSeasonDuration:=false;
  AreasChecked:=false;
  MakeCorrection:=false;
  OverallSaved:=false;
  NetworkSaved:=false;
  ResponsChange:=false;
  AgriRevised:=false;
  NrOfSeasonsChange:=false;
  GuideEnded:=true;
  GuideStop:=true;
  StartUp := true;
  SetInitialDrainage:=true;
  SetInitAquiConditions:=true;
  SetInitialAreas:=true;
  CallFirst:=true;
  Destroyed:=true;
  Identity:='None';

  if DirectoryExists (InitDir) then chdir (InitDir);
  DeleteGroupFiles;                                {GroupFiles are "Name"files}
  if DirectoryExists (DataDir) then chdir (DataDir);
  DeleteGroupFiles;
  with DataMod do
  begin
    begin
      OpenFileName:= AInitDir;
      DataDir:=extractfilepath(OpenFileName);
      SaveFileName:='';
         chdir (DataDir);
         ReadInputs (DoItSelf);
         NrOfNodesAdded:=0;
         NrOfNodesRemoved:=0;
         NrOfSeasonsAdded:=0;
         Critical:=false;
         PresentData;
    end
  end; {with DataMod do}
  CalcDone:=false;
  InputOpened := true;
  DataMod.YearNr:=0;
  OutDir:=AOutDir;
  InputSave_Execute;

end; {InputOpen_Execute}
{--------------------------------}

procedure PresentData;
{------------------------------}
begin
  with DataMod do
      if not CalcButtonUsed then
      begin
        DataMod.ReadGeneralGroup;
        InitNrOfSeasons:=NrOfSeasons; {probably not required. Nodig?}
        DataMod.ReadOverallGroup;
//        MakeGeneralStrings;         //This is the main aim of PresentData
       //makes strings of general data ('Name0' file) tbv GeneralInput_Tabsheet
        InitNrOfIntPoly:=NrOfIntPoly;
        InitNrOfExtPoly:=NrOfExtPoly;
//This is a good place for the initial values because an input file was just
//opened and it may be that they may be changed
        CalcButtonUsed:=false;
      end;
end; {TMainForm.PresentData}

{Action: InputSave, Menu: InputSave}
{----------------------------------}
procedure InputSave_Execute;
{------------------------------------------------------}
label 1;
var DataOK : boolean;
    OriginalDir, PreviousDir, NewDataDir : string;
    Count, k       : integer;

begin
   with DataMod do
   begin
     SaveGeneralGroup(DataOK);
     if not DataOK then exit;
     if SaveFileName<>'' then PreviousDir:=ExtractFilePath(SaveFileName)
     else PreviousDir:=ExtractFilePath(OpenFileName);
     if PreviousDir='' then PreviousDir:=getcurrentdir;
1:   if (SetAndVerifySaveName) and not NoSave then
        CheckGeneralData (DataOK)
     else
     begin
       Write ('The input data were not saved');
       Readln;
       exit;
     end;
     BriefFileName:= ExtractFileName (SaveFileName);
     Count:=0;
     for k:=1 to length(BriefFileName) do
       if SaveFileName[k]='.' then Count:=Count+1;
     if Count>1 then
     begin
       Writeln ('The number of dots (.) in the file name'+
                ' should not be greater than 1. Please adjust.');
       goto 1;
     end;
//Provisions for annual calculations
     if YearNr<1 then OriginalName:=OpenFileName;
     OriginalDir := ExtractFilePath(OriginalName);
     if OriginalDir='' then OriginalDir:=Initdir+'\';
     NewDataDir := ExtractFilePath(SaveFileName);
     if OriginalDir<>NewDataDir then if AnnualCalc and (YearNr>1) then
     begin
       if fileexists (SaveFileName) then deletefile (SaveFileName);
       Writeln (' During calculations with annual input changes,'+
                ' the data-path cannot be changed. Please save'+
                ' the input file in '+OriginalDir);
       goto 1;
     end;
//Actions for old and new data directory which may be different in case of
//not-annual calculations
     sleep (500);
     DataDir:=NewDataDir;                         {for use in other procedures}
//Move the "Name" files (GroupFiles) from the old DataDir to the new DataDir
     if PreviousDir<>NewDataDir then
        MoveGroupFiles (PreviousDir, NewDataDir);
     if AnsiUpperCase(PreviousDir)<>AnsiUpperCase(NewDataDir) then
     begin
       chdir (PreviousDir);
       DeleteGroupFiles;                           {GroupFiles are "Name"files}
     end;
     chdir (NewDataDir);
     if FileExists ('Name0') then
     begin
       //Compose Input file from the "Name" files
       SaveInputs;
       //Make text file from the input file
       SaveText;
     end else
     begin
       Write ('Input file could not be saved due to missing temporary files');
       Readln;
       exit;
     end;
     if YearNr<1 then OriginalName:=SaveFileName;
     BriefFileName:=ChangeFileExt (SaveFileName,'');

     GuidedOK:=false;
     SelfDone:=false;
     ChDir(InitDir);
     DoCalculations;
     begin
       chdir(AnsiUpperCase(PreviousDir));
       DeleteGroupFiles;
     end;
  end; {with DataMod do}
end; {TMainForm.InputSave_Execute}
{--------------------------------}

function SetAndVerifySaveName;
{--------------------------------------}
begin
  Result := false;
  NoSave := false;
  with DataMod do
    begin
      DataMod.SaveFileName := ExtractFilePath(OutDir) + StringReplace(ExtractFileName(OutDir),ExtractFileExt(OutDir),'',[]) + '.inp';
      SaveFileName := ChangeFileExt(SaveFileName,'.inp');         {nodig?}
      Result := true;
    end;
      if not Result then NoSave:=true;
end; {TMainForm.SetAndVerifySaveName}
{-----------------------------------}

procedure DoCalculations;
{---------------------------------}
var OldYear, NewYear, Nx : string;
    OrigStr              : string;
    YesOK                : boolean;
begin
  with DataMod do
  begin
    EndOfAnnual := false;
    chdir (InitDir);
    RestrictInputArrays ('Polygonal');
    RestrictInputArrays ('Seasonal');
    ReduceOutputArrays;

    TestData;
    ReadErrorLines (RunTimeError,NrOfErrorLines);
    if RunTimeError then
    begin
      CalcDone:=true;
      OutputOpened:=false;
      Writeln ('There are one or more input errors, calculations could'+
               ' not be done. The errors will be shown be shown.');
      exit;
    end;

    if YearNr<1 then InitialActions;
    if not AnnualCalc then YearNr:=NrOfYears;
    Writeln(' Calculating ... ');
    Writeln(' Please wait ... ');
    sleep(1000);
    AnnualNr:=NrOfYears;
    if AnnualCalc then
    begin
      NrOfYears:=1;
      SaveFileName:=OriginalName;
    end;
    if YearNr=0 then YearNr:=1;
    MainCalculations;
    NrOfYears:=AnnualNr;
    CalcDone:=true;

    if AccErr then
    begin
      Assignfile (AccFile,'accuracy.err');
      reset (AccFile);
      NrOfErrorLines:=0;
      while not eof (Accfile) do
      begin
        NrOfErrorLines:=NrOfErrorLines+1;
        setlength (ErrorLines,NrOfErrorLines+1);
        readln (Accfile,ErrorLines[NrOfErrorLines]);
      end;
      closefile (AccFile);
      CalcDone:=true;
      OutputOpened:=false;
    end else
    begin
      Writeln(' Finalizing ....');
      sleep(500);
      ReadErrorLines (RunTimeError,NrOfErrorLines);
      if RunTimeError then
      begin
        CalcDone:=true;
        OutputOpened:=false;
      end;
    end;
    OrigStr:=OriginalName;
    OrigStr:=ChangeFileExt(OrigStr,'.out');
//Messages
    if AnnualCalc and (YearNr<NrOfYears) then
    begin
      OldYear := IntToStr(YearNr);
      NewYear := IntToStr(YearNr+1);
      YearNr:=YearNr+1;
      Nx := IntToStr(NrOfYears);
      Writeln ('By setting the yearly calculation index Ky equal'+
      ' to 1 you have requested SaltMod calculations using the input'+
      ' file  '+OpenFileName+' for a time series of '+Nx+' years with the'+
      ' option to introduce annual input changes.  The end of the'+
      ' intermediate annual calculations of year '+OldYear+ ' is'+
      ' reached. The intermediate results can be seen in output file '
        +OrigStr);
      begin
        Writeln ('Go to the input menu to continue. It is not'+
        ' necessary to adjust the initial values of soil salinity'+
        ' and water level, this is done automatically. To keep'+
        ' record if input changes, the input file may be saved' +
        ' in the same folder under a different (sequential) name' +
        ' at each annual run.');
        chdir (DataDir);
        ReadInputs (DoItSelf);
        PresentData;
        //makes strings of general data ('Name0' file) tbv GeneralInput_Tabsheet
        exit;
      end;
    end; {if AnnualCalc and YearNr<NrOfYears}

    if AnnualCalc and (YearNr=NrOfYears) then
    begin
      Writeln ('The end of the time series is reached.');
      Writeln ('The results can be seen in ' + OrigStr);
      EndOfAnnual := true;
    end;
    chdir (InitDir);
    if not AnnualCalc then
    begin
      OutputOpened:=true;
    end;
    if AnnualCalc and EndOfAnnual then
    begin
      OutputOpened:=true;
    end;
    if not AnnualCalc then
       if RuntimeError or AccErr then
          Writeln ('An runtime error message will be displayed.')
      else
      begin
         Writeln ('The calculations are completed.');
         Writeln ('The results can be seen in the output file: '+OrigStr);
      end;
  end; {with DataMod do}
end; {TMainForm.DoCalculations}
{-----------------------------}

procedure RestrictInputArrays (const DataSheet : string);
{-----------------------------------------------------------------}
var i, j : byte;
begin
  with DataMod do
  begin
    if not (DataSheet='Polygonal') then
    begin
      for i:=1 to 8 do setlength(HlpValue[i],1);
      for i:=1 to 6 do setlength(AuxInt[i],1);
      setlength (NodalNr,1);
    end;
    if not (DataSheet='Seasonal') then
    begin
      for i:=1 to 4 do for j:=1 to 4 do setlength(AuxValue[i,j],1);
      //for j:=1 to 4 do setlength (InitAreaA[j],1);
      //for j:=1 to 4 do setlength (InitAreaB[j],1);
    end;
  end; {with DataMod do}
end; {TMainForm.RestrictInputArrays}
{----------------------------------}

procedure ReduceOutputArrays;
{-------------------------------------}
var i:byte;
begin
  for i:=1 to 7 do setlength(DataMod.Mainstr[i],1);
  for i:=1 to 7 do setlength(DataMod.Variable[i],1);
end; {TMainForm.ReduceOutputArrays}
{---------------------------------}

begin
end.

