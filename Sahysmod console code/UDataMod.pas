unit UDataMod;

interface

uses
  SysUtils, Classes, Dialogs, Forms, Controls;

type
  DataSetR  = array of real;
  DataSetI  = array of integer;
  DataSetR4 = array [1..4] of DataSetR;
  DataSetR6 = array [1..6] of DataSetR;
  DataSetVar = array [1..7] of DataSetR;
  DataSetR8 = array [1..8] of DataSetR;
  DataSetI4 = array [1..4] of DataSetI;
  DataSetI6 = array [1..6] of DataSetI;
  LineSet  = array of string;
  ShortStr = string [9];
type
  TDataMod = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OpenFileName, SaveFileName,
    AnnualFileName,
    GroupName, Title1, Title2,
    GrTitle1, GrTitle2, GrTitle3,
    GrTitle4,  OutputFileName    : string;
    SeasonDuration               : array[1..4] of real;
    OutputTimeStep, YearNr,
    NrOfSeasons, NrOfYears, AnnualNr,
    TotNrOfPoly, NrOfNodesAdded,
    NrOfNodesRemoved,
    InitNrOfSeasons,
    NrOfSeasonsAdded,
    NrOfIntPoly, NrOfExtPoly,
    InitNrOfIntPoly,
    InitNrOfExtPoly,
    InitTotNrOfPoly,
    NrOfitems, NrOfLines,
    NrOfData, NrOfPolySelected,
    YearWanted, SeasonWanted,
    PolyWanted, NrOfWarnings     : integer;
//NrOfSeasonsAdded is a dummy used for a check
    GroupMark                    : string[5];
    Scale                        : longint;
    AccuracyLevel, AnnualIndex   : byte;
//NrOfSides is used in groupfiles in UExtraUtils
    NrOfSides, NodeNr,
    Int_Ext_Index, AquiferType,
    DrainIndex, ResponsIndex,
    InclIndex, RotationType      : DataSetI;
    Xcoord, Ycoord, BottomLevel,
    VertCond, TopLayer,
    OrigInflowValue              : DataSetR;
    Neighbor, AuxInt             : DataSetI6;
    Conduct, TopCond             : DataSetR6;
    HlpValue                     : DataSetR8;
    AuxValue                     : array [1..4] of DataSetR4;
    AreaA, AreaB,
    Pumpage, TotalIrr            : DataSetR4;
    Variable                     : DataSetVar;
    NodalNr                      : array of integer;
    NrOfNeighbors, PolySelected  : array of integer;
//NrOfNeighbors is same as NrOfSides but used in main program
    Xvalue, Yvalue, AreaT        : array of real;
    FileLine, ErrorLines,
    WarningLines                 : LineSet;
    DumStr                       : string[10];
    MainStr                      : array [1..7] of string[12];
    AnnualCalc, EndOfAnnual,
    RemovalStage, RemovalError,
    SeasonalStorEffOK, PolyData,
    NodesAdded, FarmAddOk, NoGraph : boolean;

        {General Input}
    procedure ReadGeneralGroup;
    procedure SaveGeneralGroup(var CheckOK : boolean);

        {Polygonal input}
    procedure ReadOverallGroup;
    procedure ReadOverallData;
    procedure SaveOverallGroup;
    procedure ReadNetworkGroup(const Phase:string);
    procedure SaveNetworkGroup (var SelfMade:boolean);
    procedure ReadPolyGroup (const GroupName:string;
                             const GroupCount:byte);
    procedure SavePolyGroup (const GroupName:string;
                             const GroupCount:byte);
    procedure ReadExternalGroup;
    procedure SaveExternalGroup;
    procedure MakeGroupFiles;
    procedure AddToGroupFiles;
    procedure RemoveNodesFromFiles;

        {Seasonal input}
    procedure AddToSeasonGroups;
    procedure ReadSeasonGroup (const GroupName:string;
                               const GroupCount:byte);
    procedure SaveSeasonGroup (const GroupName:string;
                               const GroupCount:byte);
        {Output}
    procedure ReadErrorLines
              (var ErrorPresent : boolean; var NrOfErrors : integer);
    procedure ReadWarningLines
              (var WarningPresent : boolean; var NrOfWarnings : integer);
    procedure ReadInputData;
    procedure ReadTimeDataOfPoly(Signal : string);
    procedure ReadPolyDataOfTime(Signal : string);
    procedure ReadSelectedPolyData(Signal : string);
    procedure ReadOutputLines(const DocName: string; var Reading : boolean);
    procedure PolyCharact (const DocName: string; var Reading : boolean);

        {Graphics}
    procedure ReadGroupData;

         {General}
    function StringToFlo(Str : string) : double;
    function Question(const Query: string): boolean;
  end;

var
  DataMod: TDataMod;

implementation

{$R *.dfm}


{******************************************************************************
 read/write input : General Group
 ******************************************************************************}


procedure TDataMod.ReadGeneralGroup;
{----------------------------------}
var  GroupFile : textfile;
     i : integer;
     Extra : string;

begin
  Assignfile(GroupFile,'Name0');
  {$I-} Reset(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A reading error occurred');
    exit;
  end;
  readln (GroupFile,Title1);
  readln (GroupFile,Title2);
  Try readln (GroupFile,NrOfYears,NrOfSeasons,AnnualIndex,Extra);
      Except on E: exception do Extra:='0';
  end;
  while Pos(' ',Extra) > 0 do delete(Extra,Pos(' ',Extra),1);
  SeasonalStorEffOK:=false;
  if Extra='99' then SeasonalStorEffOK:=true;
  AnnualCalc := false;
  if AnnualIndex=1 then AnnualCalc:=true;
  for i:=1 to NrOfSeasons do  read (GroupFile,SeasonDuration[i]);
  readln (GroupFile);
  readln (GroupFile,TotNrOfPoly,NrOfIntPoly,NrOfExtPoly,Extra);
  setlength(NrOfSides,NrOfIntPoly);
  for i:=0 to NrOfIntPoly-1 do read(GroupFile,NrOfSides[i]);
  readln(GroupFile);
  readln (GroupFile,Scale,OutputTimestep,AccuracyLevel);
  closefile(GroupFile);
end; {TDataMod.ReadGeneralGroup}
{------------------------------}



procedure TDataMod.SaveGeneralGroup (var CheckOK : boolean);
{----------------------------------------------------------}
var  GroupFile: textfile;
     i : integer;
     Error : boolean;
begin
  Error := false;
  Assignfile(GroupFile,'Name0');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A file could not be opened. Data cannot be shown');
    exit;
  end;
  writeln (GroupFile,Title1);
  writeln (GroupFile,Title2);
  if NrOfYears<1 then Error:=true;
  if NrOfNodesAdded<0 then Error:=true;
  if NrOfNodesRemoved<0 then Error:=true;
  if (AnnualIndex<>0) and (AnnualIndex<>1) then Error:=false;
  if (OutputTimeStep<1) or (OutputTimeStep>NrOfYears) then Error:=true;
  if (AccuracyLevel<1) or (AccuracyLevel>3) then Error:=true;
  if Error then
  begin
    Showmessage ('There is an input error. Please check.');
    CheckOK:=false;
    exit;
  end;
  writeln (GroupFile,NrOfYears,' ',NrOfSeasons,' ',AnnualIndex,' ',' 99');
  for i:=1 to NrOfSeasons do  write (GroupFile,SeasonDuration[i]:7:1);
  writeln(GroupFile);
  writeln(GroupFile,TotNrOfPoly,' ',NrOfIntPoly,' ',NrOfExtPoly,'   1');
  setlength(NrOfSides,NrOfIntPoly);
  for i:=0 to NrOfIntPoly-1 do write(GroupFile,NrOfSides[i],' ');
  writeln(GroupFile);
  writeln (GroupFile,Scale,' ',OutputTimestep,' ',AccuracyLevel);
  closefile(GroupFile);
  CheckOK:=true;
end; {TDataMod.SaveGeneralGroup}
{------------------------------}


{******************************************************************************
 read/write input : Polygonal Groups
*******************************************************************************}


procedure TDataMod.ReadOverallGroup;
{----------------------------------}
var GroupFile : textfile;
    k : integer;
begin
  ReadGeneralGroup;
  Assignfile(GroupFile,'Name01');
  {$I-} Reset(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A reading error occurred. Data cannot be shown');
    exit;
  end;
  setlength(NodeNr,TotNrOfPoly+NrOfNodesAdded);
  setlength(Xcoord,TotNrOfPoly+NrOfNodesAdded);
  setlength(Ycoord,TotNrOfPoly+NrOfNodesAdded);
  setlength(BottomLevel,TotNrOfPoly+NrOfNodesAdded);
  setlength(Int_Ext_Index,TotNrOfPoly+NrOfNodesAdded);
  for k:=0 to NrOfIntPoly-1 do read (GroupFile,NodeNr[k]);
  readln (GroupFile);
  for k:=0 to NrOfExtPoly-1 do read (GroupFile,NodeNr[k+NrOfIntPoly]);
  readln (GroupFile);
  for k:=0 to NrOfIntPoly-1 do read (GroupFile,Xcoord[k]);
  readln (GroupFile);
  for k:=0 to NrOfExtPoly-1 do read (GroupFile,Xcoord[k+NrOfIntPoly]);
  readln (GroupFile);
  for k:=0 to NrOfIntPoly-1 do read (GroupFile,Ycoord[k]);
  readln (GroupFile);
  for k:=0 to NrOfExtPoly-1 do read (GroupFile,Ycoord[k+NrOfIntPoly]);
  readln (GroupFile);
  for k:=0 to NrOfIntPoly-1 do read (GroupFile,BottomLevel[k]);
  readln (GroupFile);
  for k:=0 to NrOfExtPoly-1 do read (GroupFile,BottomLevel[k+NrOfIntPoly]);
  readln (GroupFile);
  for k:=0 to NrOfIntPoly-1 do read (GroupFile,Int_Ext_Index[k]);
  readln (GroupFile);
  for k:=0 to NrOfExtPoly-1 do read (GroupFile,Int_Ext_Index[k+NrOfIntPoly]);
  readln (GroupFile);
  closefile(GroupFile);
end; {TDataMod.ReadOverallGroup}
{------------------------------}



procedure TDataMod.ReadOverallData;
{---------------------------------}
var GroupFile : textfile;
    k : integer;
begin
  Assignfile(GroupFile,'Name01');
  {$I-} Reset(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A reading error occurred. Data cannot be shown');
    exit;
  end;
  setlength(NodeNr,TotNrOfPoly+NrOfNodesAdded);
  setlength(Xcoord,TotNrOfPoly+NrOfNodesAdded);
  setlength(Ycoord,TotNrOfPoly+NrOfNodesAdded);
  setlength(BottomLevel,TotNrOfPoly+NrOfNodesAdded);
  setlength(Int_Ext_Index,TotNrOfPoly+NrOfNodesAdded);
  for k:=0 to NrOfIntPoly-1 do read (GroupFile,NodeNr[k]);
  readln (GroupFile);
  for k:=0 to NrOfExtPoly-1 do read (GroupFile,NodeNr[k+NrOfIntPoly]);
  readln (GroupFile);
  for k:=0 to NrOfIntPoly-1 do read (GroupFile,Xcoord[k]);
  readln (GroupFile);
  for k:=0 to NrOfExtPoly-1 do read (GroupFile,Xcoord[k+NrOfIntPoly]);
  readln (GroupFile);
  for k:=0 to NrOfIntPoly-1 do read (GroupFile,Ycoord[k]);
  readln (GroupFile);
  for k:=0 to NrOfExtPoly-1 do read (GroupFile,Ycoord[k+NrOfIntPoly]);
  readln (GroupFile);
  for k:=0 to NrOfIntPoly-1 do read (GroupFile,BottomLevel[k]);
  readln (GroupFile);
  for k:=0 to NrOfExtPoly-1 do read (GroupFile,BottomLevel[k+NrOfIntPoly]);
  readln (GroupFile);
  for k:=0 to NrOfIntPoly-1 do read (GroupFile,Int_Ext_Index[k]);
  readln (GroupFile);
  for k:=0 to NrOfExtPoly-1 do read (GroupFile,Int_Ext_Index[k+NrOfIntPoly]);
  readln (GroupFile);
  closefile(GroupFile);
end; {TDataMod.ReadOverallData}
{-----------------------------}



procedure TDataMod.SaveOverallGroup;
{----------------------------------}
var GroupFile : textfile;
    k, NrOfPoly : integer;
begin
  Assignfile(GroupFile,'Name01');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A file could not be opened. Data cannot be shown');
    exit;
  end;
  NrOfPoly:=TotNrOfPoly;
  if RemovalStage then
  begin
    RemovalError:=false;
    if InitTotNrOfPoly-TotNrOfPoly<>NrOfNodesRemoved then
       RemovalError:=true;
    NrOfPoly:=InitTotNrOfPoly;
  end;
  setlength(NodeNr,NrOfPoly);
  setlength(Xcoord,NrOfPoly);
  setlength(Ycoord,NrOfPoly);
  setlength(BottomLevel,NrOfPoly);
  setlength(Int_Ext_Index,NrOfPoly);
  for k:=0 to NrOfPoly-1 do if Int_Ext_Index[k]=1 then
      write (GroupFile,NodeNr[k]:5);
  writeln (GroupFile);
  for k:=0 to NrOfPoly-1 do if Int_Ext_Index[k]=2 then
      write (GroupFile,NodeNr[k]:5);
  writeln (GroupFile);
  for k:=0 to NrOfPoly-1 do if Int_Ext_Index[k]=1 then
      write (GroupFile,Xcoord[k]:8:2);
  writeln (GroupFile);
  for k:=0 to NrOfPoly-1 do if Int_Ext_Index[k]=2 then
      write (GroupFile,Xcoord[k]:8:2);
  writeln (GroupFile);
  for k:=0 to NrOfPoly-1 do if Int_Ext_Index[k]=1 then
      write (GroupFile,Ycoord[k]:8:2);
  writeln (GroupFile);
  for k:=0 to NrOfPoly-1 do if Int_Ext_Index[k]=2 then
      write (GroupFile,Ycoord[k]:8:2);
  writeln (GroupFile);
  for k:=0 to NrOfPoly-1 do if Int_Ext_Index[k]=1 then
      write (GroupFile,BottomLevel[k]:8:2);
  writeln (GroupFile);
  for k:=0 to NrOfPoly-1 do if Int_Ext_Index[k]=2 then
      write (GroupFile,BottomLevel[k]:8:2);
  writeln (GroupFile);
  for k:=0 to NrOfPoly-1 do if Int_Ext_Index[k]=1 then
      write (GroupFile,Int_Ext_Index[k]:3);
  writeln (GroupFile);
  for k:=0 to NrOfPoly-1 do if Int_Ext_Index[k]=2 then
      write (GroupFile,Int_Ext_Index[k]:3);
  writeln (GroupFile);
  closefile(GroupFile);
end; {TDataMod.SaveOverallGroup}
{------------------------------}



procedure TDataMod.ReadNetworkGroup(const Phase : string);
{--------------------------------------------------------}
var GroupFile : textfile;
    j,k, NrOfPoly : integer;
begin
  AssignFile(GroupFile,'Name03');
  {$I-} Reset(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be opened, SahysMod cannot proceed');
    exit;
  end;
  if NrOfNodesAdded>0 then
  begin
    setlength (NrOfSides,NrOfIntPoly);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do NrOfSides[k]:=6;
  end else
    if not RemovalStage then InitNrOfIntPoly:=NrOfIntPoly;
  NrOfPoly:=NrOfIntPoly;
  if RemovalStage then NrOfPoly:=InitNrOfIntPoly;
  for j:=1 to 6 do
  begin
    setlength(Neighbor[j],NrOfPoly);
    setlength(Conduct[j],NrOfPoly);
    setlength(TopCond[j],NrOfPoly);
  end;
  for k:=0 to InitNrOfIntPoly-1 do
  begin
    read (GroupFile,DataMod.NodeNr[k]);
    for j:=1 to NrOfSides[k] do
        read (GroupFile,Neighbor[j,k],Conduct[j,k],TopCond[j,k]);
    readln(groupFile);
  end;
  setlength (DataMod.TopLayer,NrOfPoly);
  for k:=0 to InitNrOfIntPoly-1 do
      read (GroupFile,DataMod.TopLayer[k]);
  readln (GroupFile);
  setlength (DataMod.VertCond,NrOfPoly);
  for k:=0 to InitNrOfIntPoly-1 do
      read (GroupFile,DataMod.VertCond[k]);
  readln (GroupFile);
  closefile(GroupFile);
  if Phase='Started' then
  begin
    for k:=0 to InitNrOfIntPoly-1 do if AquiferType[k]<1 then
        for j:=1 to NrOfSides[k] do TopCond[j,k]:=-1;
    for k:=0 to InitNrOfIntPoly-1 do if AquiferType[k]<1 then
    begin
      TopLayer[k]:=-1;
      VertCond[k]:=-1;
    end;
  end;
end;{TDataMod.ReadNetworkGroup}
{-----------------------------}



procedure TDataMod.SaveNetworkGroup (var SelfMade : boolean);
{-----------------------------------------------------------}
var GroupFile : textfile;
    j,k : integer;
begin
  AssignFile(GroupFile,'Name03');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be opened, SahysMod cannot proceed');
    exit;
  end;
  if SelfMade or (NrOfNodesAdded>0) then
  begin
    for j:=1 to 6 do
    begin
      setlength (Neighbor[j],NrOfIntPoly);
      setlength (Conduct[j],NrOfIntPoly+1);
      setlength (TopCond[j],NrOfIntPoly);
    end;
    setlength (TopLayer,NrOfIntPoly+1);
    setlength (VertCond,NrOfIntPoly+1);
    setlength (NrOfSides,NrOfIntPoly+1);
    setlength (AquiferType,TotNrOfPoly+1);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do
    begin                                           {make new values negative}
      for j:=1 to 6 do
      begin
        Conduct[j,k]:=-1;
        TopCond[j,k]:=-1;
      end;
      TopLayer[k]:=-1;
      VertCond[k]:=-1;                    {is done again under AddToGroupFiles}
      AquiferType[k]:=-1;
    end;
  end;
  if length(AquiferType)<NrOfIntPoly then
  begin
    setlength (AquiferType,NrOfIntPoly);
    for k:=0 to NrOfIntPoly-1 do AquiferType[k]:=0;
  end;
  for k:=0 to NrOfIntPoly-1 do if AquiferType[k]<1 then
  begin                                              {semi-conf. aquif. absent}
    for j:=1 to NrOfSides[k] do TopCond[j,k]:=-1;
    TopLayer[k]:=-1;
    VertCond[k]:=-1;
  end;
  for k:=0 to NrOfIntPoly-1 do
  begin
    write (GroupFile,DataMod.NodeNr[k]);
    for j:=1 to NrOfSides[k] do
        write (GroupFile,Neighbor[j,k]:5,Conduct[j,k]:8:2,TopCond[j,k]:8:2);
    writeln(groupFile);
  end;
  for k:=0 to NrOfIntPoly-1 do
      write (GroupFile,DataMod.TopLayer[k]:8:2);
  writeln (GroupFile);
  for k:=0 to NrOfIntPoly-1 do
      write (GroupFile,DataMod.VertCond[k]:10:4);
  writeln (GroupFile);
  closefile(GroupFile);
end;{TDataMod.SaveNetworkGroup}
{-----------------------------}



procedure TDataMod.ReadPolyGroup (const GroupName:string;
                                  const GroupCount:byte);
{-------------------------------------------------------}
var j : byte;
    k, Number : integer;
    GroupFile : Text;
begin
  AssignFile (GroupFile,GroupName);
  if not fileexists (GroupName) then exit;
  reset (GroupFile);
  for j:=1 to GroupCount do
  begin
    if GroupName='Name14' then
    begin
      setlength(HlpValue[j],InitNrOfExtPoly);
      for k:=0 to InitNrOfExtPoly-1 do
      read (GroupFile,HlpValue[j,k]);
      readln (GroupFile);
    end else
    begin
      setlength(HlpValue[j],InitNrOfIntPoly);
      for k:=0 to InitNrOfIntPoly-1 do
      read (GroupFile,HlpValue[j,k]);
      readln (GroupFile);
    end;
  end;
  closefile (GroupFile);
  if GroupName='Name02' then
  begin
    setlength (AquiferType,InitNrOfIntPoly);
    for k:=0 to InitNrOfIntPoly-1 do AquiferType[k]:=round(HlpValue[4,k]);
  end;
  Number:=InitNrOfIntPoly;
  if NrOfIntPoly>InitNrOfIntPoly then Number:=NrOfIntPoly;
  if GroupName='Name14' then
  begin
    Number:=InitNrOfExtPoly;
    if NrOfExtPoly>InitNrOfExtPoly then Number:=NrOfExtPoly;
  end;
  for j:=1 to GroupCount do setlength(HlpValue[j],Number);
  if GroupName='Name08' then
  begin
    setlength (DrainIndex,Number);
    for k:=0 to InitNrOfIntPoly-1 do DrainIndex[k]:=round(HlpValue[1,k]);
    setlength (ResponsIndex,Number);
    for k:=0 to InitNrOfIntPoly-1 do ResponsIndex[k]:=round(HlpValue[2,k]);
    setlength (RotationType,Number);
    for k:=0 to InitNrOfIntPoly-1 do RotationType[k]:=round(HlpValue[2,k]);
    setlength (InclIndex,Number);
    if FarmAddOK then
       for k:=0 to InitNrOfIntPoly-1 do
          InclIndex[k]:=round(HlpValue[4,k])
       else
       for k:=0 to InitNrOfIntPoly-1 do
       begin
         InclIndex[k]:=1;
         HlpValue[4,k]:=1;
       end;
  end;
  if GroupName='Name09' then for k:=0 to InitNrOfIntPoly-1 do
  begin
    setlength (DrainIndex,Number);
    if DrainIndex[k]<1 then for j:=1 to GroupCount do HlpValue[j,k]:=-1;
  end;
  if GroupName='Name13' then
  begin
    setlength(OrigInflowValue,Number);
    for k:=0 to InitNrOfIntPoly-1 do OrigInflowValue[k]:=HlpValue[1,k];
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do OrigInflowValue[k]:=-1;
  end;
end; {TDataMod.ReadPolyGroup}
{---------------------------}



procedure TDataMod.SavePolyGroup (const GroupName:string;
                                  const GroupCount:byte);
{-------------------------------------------------------}
var j, Head,Tail : byte;
    k         : integer;
    GroupFile : Text;
begin
  Head:=8;
  Tail:=3;
  if GroupName='Name08' then
  begin
    Head:=3;
    Tail:=0;
  end;
  AssignFile (GroupFile,GroupName);
  rewrite (GroupFile);
  DecimalSeparator := '.';
  
  for j:=1 to GroupCount do
  begin
    if (GroupName='Name02') and (j=4) then Tail:=0;
    for k:=0 to NrOfIntPoly-1 do
        write (GroupFile,HlpValue[j,k]:Head:Tail);
    writeln (GroupFile);
  end;
  closefile (GroupFile);
  if GroupName='Name08' then
  begin
    setlength (DrainIndex,NrOfIntPoly);
    for k:=0 to NrOfIntPoly-1 do DrainIndex[k]:=round(HlpValue[1,k]);
    setlength (ResponsIndex,NrOfIntPoly);
    for k:=0 to NrOfIntPoly-1 do ResponsIndex[k]:=round(HlpValue[2,k]);
  end;
end; {TDataMod.SavePolyGroup}
{---------------------------}



procedure TDataMod.ReadExternalGroup;
{-----------------------------------}
var j : byte; k : integer;
    GroupFile : Text;
begin
  AssignFile (GroupFile,'Name14');
  reset (GroupFile);
  if InitNrOfExtPoly>InitNrOfIntPoly then
     for j:=1 to NrOfSeasons+1 do setlength(HlpValue[j],InitNrOfExtPoly);
  for k:=0 to InitNrOfExtPoly-1 do read (GroupFile,HlpValue[1,k]);
  readln (GroupFile);
  for j:=1 to NrOfSeasons do
    begin
      for k:=0 to InitNrOfExtPoly-1 do read (GroupFile,HlpValue[j+1,k]);
      readln (GroupFile);
    end;
  closefile (GroupFile);
end; {TDataMod.ReadExternalGroup}
{-------------------------------}



procedure TDataMod.SaveExternalGroup;
{-----------------------------------}
var j : byte; k : integer;
    GroupFile : Text;
begin
  AssignFile (GroupFile,'Name14');
  rewrite (GroupFile);
  for k:=0 to NrOfExtPoly-1 do write (GroupFile,HlpValue[1,k]:10:3);
  writeln (GroupFile);
  for j:=2 to NrOfSeasons+1 do
    begin
      for k:=0 to NrOfExtPoly-1 do write (GroupFile,HlpValue[j,k]:8:3);
      writeln (GroupFile);
    end;
  closefile (GroupFile);
end; {TDataMod.SaveExternalGroup}
{-------------------------------}



procedure TDataMod.MakeGroupFiles;
{--------------------------------}
var GroupFile : textfile;
    i, j, k : integer;
begin

  AssignFile(GroupFile,'Name02');                   {internal syst. properties}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 4 do
  begin
    for k:=0 to NrOfIntPoly-1 do write(GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name03');             {Network relations, hydr. cond.}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for k:=0 to NrOfIntPoly-1 do
  begin
    write (GroupFile,NodeNr[k]:5);
    for j:=1 to NrOfSides[k] do
        write(GroupFile,Neighbor[j,k]:5,' -1 ',' -1 ');
    writeln(GroupFile);
  end;
  for j:=1 to 2 do
  begin
    for k:=0 to NrOfIntPoly-1 do write(GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name04');                          {tot. porosity}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name05');                       {effective porosity}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 4 do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);
                                                         {leaching efficiemcy}
  AssignFile(GroupFile,'Name06');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);                              {Name07 see further down}
                                                          {Agric. practices}
  AssignFile(GroupFile,'Name08');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 4 do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name09');                 {drainage system properteis}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name10');                    {soil salinity root zone}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);
                                                         {subsoil salinity}
  AssignFile(GroupFile,'Name11');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 4 do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name12');          {water level/pressure, crit. depth}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name13');                   {inflow/outflow conditions}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name14');               {external: aquifer salinity}
  {$I-} Rewrite(GroupFile); {$I+}                {and seasonal water level}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for k:=0 to NrOfExtPoly-1 do write (GroupFile,' -1 ');
      writeln(GroupFile);
  for j:=1 to NrOfSeasons do
  begin
     for k:=0 to NrOfExtPoly-1 do write (GroupFile,' -1 ');
     writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name15');               {Seasonal rainfall/evaporation}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name16');             {Seasonal surface inflow/outflow}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name17');                {Seasonal well discharge and}
  {$I-} Rewrite(GroupFile); {$I+}                   {drainage control}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name18');                {Seasonal crop area fractions}
  {$I-} Rewrite(GroupFile); {$I+}                 {and rice cropping indices}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name19');                        {Seasonal irrigation}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name20');         {Seasonal reuse of drain/well water}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  AssignFile(GroupFile,'Name07');                {Seasonal storage efficiency}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 3 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

end; {TDataMod.MakeGroupFiles}
{----------------------------}



procedure TDataMod.AddToGroupFiles;
{---------------------------------}
var GroupFile : textfile;
    i, j, k : integer;
begin
  ReadPolyGroup('Name02',4);                     {internal system properties}
  AssignFile(GroupFile,'Name02');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do
        write (GroupFile,HlpValue[j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do
        write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  for k:=0 to InitNrOfIntPoly-1 do
      write (GroupFile,HlpValue[4,k]:4:0);
  for k:=InitNrOfIntPoly to NrOfIntPoly-1 do
      write (GroupFile,' -1 ');
  closefile (GroupFile);
  setlength (AquiferType,NrOfIntPoly);
  for k:=0 to InitNrOfIntPoly-1 do AquiferType[k]:=round(HlpValue[4,k]);
  for k:=InitNrOfIntPoly to NrOfIntPoly-1 do AquiferType[k]:=-1;

  ReadPolyGroup('Name04',3);                            {Total porosity}
  AssignFile(GroupFile,'Name04');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,HlpValue[j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name05',4);                            {Eff. porosity}
  AssignFile(GroupFile,'Name05');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 4 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,HlpValue[j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name06',3);                           {Leaching efficiency}
  AssignFile(GroupFile,'Name06');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,HlpValue[j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  j:=3;
  if FarmAddOK then j:=4;
  ReadPolyGroup('Name08',j);                             {Agric. practices}
  AssignFile(GroupFile,'Name08');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 4 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,HlpValue[j,k]:4:0);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);
  setlength (DrainIndex,NrOfIntPoly);
  setlength (ResponsIndex,NrOfIntPoly);
  setlength (RotationType,NrOfIntPoly);
  setlength (InclIndex,NrOfIntPoly);
  for k:=0 to InitNrOfIntPoly-1 do DrainIndex[k]:=round(HlpValue[1,k]);
  for k:=InitNrOfIntPoly to NrOfIntPoly-1 do DrainIndex[k]:=-1;
  setlength (ResponsIndex,NrOfIntPoly);
  for k:=0 to InitNrOfIntPoly-1 do ResponsIndex[k]:=round(HlpValue[2,k]);
  for k:=InitNrOfIntPoly to NrOfIntPoly-1 do ResponsIndex[k]:=-1;
  for k:=0 to InitNrOfIntPoly-1 do RotationType[k]:=round(HlpValue[3,k]);
  for k:=InitNrOfIntPoly to NrOfIntPoly-1 do RotationType[k]:=-1;
  for k:=0 to InitNrOfIntPoly-1 do InclIndex[k]:=round(HlpValue[4,k]);
  for k:=InitNrOfIntPoly to NrOfIntPoly-1 do InclIndex[k]:=-1;

  ReadPolyGroup('Name09',3);                       {Drainage system properties}
  AssignFile(GroupFile,'Name09');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,HlpValue[j,k]:10:5);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name10',3);                       {soil salinity rootzone}
  AssignFile(GroupFile,'Name10');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,HlpValue[j,k]:7:2);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name11',4);
  AssignFile(GroupFile,'Name11');                         {subsoil salinity}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 4 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,HlpValue[j,k]:7:2);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name12',3);
  AssignFile(GroupFile,'Name12');      {init. waterlevel/pressure, crit. depth}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,HlpValue[j,k]:8:2);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name13',3);
  AssignFile(GroupFile,'Name13');          {aquifer inflow/outflow conditions}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,HlpValue[j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadExternalGroup;                        {external: aquifer salinity and }
  AssignFile(GroupFile,'Name14');           {seasonal water level conditions}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for k:=0 to InitNrOfExtPoly-1 do write (GroupFile,HlpValue[1,k]:7:2);
  for k:=InitNrOfExtPoly to NrOfExtPoly-1 do write (GroupFile,' -1 ');
  writeln(GroupFile);
  for j:=2 to NrOfSeasons+1 do
  begin
    for k:=0 to InitNrOfExtPoly-1 do write (GroupFile,HlpValue[j,k]:8:2);
    for k:=InitNrOfExtPoly to NrOfExtPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name15',4);
  AssignFile(GroupFile,'Name15');               {Seasonal rainfall/evaporation}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name16',4);
  AssignFile(GroupFile,'Name16');             {Seasonal surface inflow/outflow}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name17',2);                   {Seasonal well discharge and}
  AssignFile(GroupFile,'Name17');                   {drainage control}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name18',4);                    {Seasonal area fractions and}
  AssignFile(GroupFile,'Name18');                  {and rice cropping indices}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
    if i=1 then
    begin
      setlength (AreaA[j],NrOfIntPoly);
      for k:=0 to NrOfIntPoly-1 do AreaA[j,k]:=AuxValue[i,j,k];
    end;
    if i=2 then
    begin
      setlength (AreaB[j],NrOfIntPoly);
      for k:=0 to NrOfIntPoly-1 do AreaB[j,k]:=AuxValue[i,j,k];
    end;
  end;
  for i:=3 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:4:0);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name19',4);
  AssignFile(GroupFile,'Name19');                      {Seasonal irrigation}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name20',2);
  AssignFile(GroupFile,'Name20');         {Seasonal reuse of drain/well water}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name07',3);
  AssignFile(GroupFile,'Name07');                {Seasonal storage efficiency}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 3 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do write (GroupFile,' -1 ');
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  InitNrOfIntPoly:=NrOfIntPoly;
  InitNrOfExtPoly:=NrOfExtPoly;

end; {TDataMod.AddToGroupFiles}
{-----------------------------}



procedure TDataMod.RemoveNodesFromFiles;
{--------------------------------------}
var GroupFile : textfile;
    Count, i, j, k : integer;
begin

  ReadPolyGroup('Name02',4);                     {internal system properties}
  AssignFile(GroupFile,'Name02');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:8:3);
    writeln(GroupFile);
  end;
  for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
      write (GroupFile,HlpValue[4,k]:4:0);
  writeln(GroupFile);
  closefile (GroupFile);

  if NrOfNodesRemoved>0 then
     ReadNetworkGroup('Starting')
  else ReadNetworkGroup('Started');
  AssignFile(GroupFile,'Name03');       {Network relations, Hydr. Conductivity}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
  begin
    write (GroupFile,NodeNr[k]:5);
    for j:=1 to NrOfSides[k] do
        write(GroupFile,Neighbor[j,k]:4,Conduct[j,k]:8:3,TopCond[j,k]:8:3);
    writeln(GroupFile);
  end;
  for k:=0 to   InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
      write(GroupFile,TopLayer[k]:8:3);
  writeln(GroupFile);
  for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_index[k]=1 then
      write(GroupFile,VertCond[k]:10:5);
  writeln(GroupFile);
  closefile (GroupFile);

  ReadPolyGroup('Name04',3);                            {Total porosity}
  AssignFile(GroupFile,'Name04');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:8:3);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name05',4);                            {Eff. porosity}
  AssignFile(GroupFile,'Name05');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 4 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:8:3);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name06',3);                           {Leaching efficiency}
  AssignFile(GroupFile,'Name06');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:8:3);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name08',3);                             {Agric. practices}
  AssignFile(GroupFile,'Name08');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:4:0);
    writeln(GroupFile);
    Count:=0;
    if j=1 then for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
    begin
      Count:=Count+1;
      setlength (DrainIndex,Count);
      DrainIndex[Count-1]:=round(HlpValue[1,Count-1]);
      setlength (ResponsIndex,Count);
      ResponsIndex[Count-1]:=round(HlpValue[2,Count-1]);
    end;
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name09',3);                       {Drainage system properties}
  AssignFile(GroupFile,'Name09');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:10:5);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name10',3);
  AssignFile(GroupFile,'Name10');                   {soil salinity rootzone}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:7:2);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name11',4);
  AssignFile(GroupFile,'Name11');                         {subsoil salinity}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 4 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:7:2);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name12',3);
  AssignFile(GroupFile,'Name12');      {init. waterlevel/pressure, crit. depth}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:8:2);
        writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadPolyGroup('Name13',3);
  AssignFile(GroupFile,'Name13');          {aquifer inflow/outflow conditions}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for j:=1 to 3 do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:8:3);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadExternalGroup;                         {external: aquifer salinity and }
  AssignFile(GroupFile,'Name14');            {seasonal water level conditions}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for k:=0 to InitNrOfExtPoly-1 do
      if Int_Ext_Index[k+NrOfIntPoly]=2 then
      write (GroupFile,HlpValue[1,k]:7:2);
  writeln(GroupFile);
  for j:=2 to NrOfSeasons+1 do
  begin
    for k:=0 to InitNrOfExtPoly-1 do
        if Int_Ext_Index[k+NrOfIntPoly]=2 then
        write (GroupFile,HlpValue[j,k]:8:2);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name15',4);                  {Seasonal rainfall/evaporation}
  AssignFile(GroupFile,'Name15');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,HlpValue[j,k]:8:3);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name16',4);                {Seasonal surface inflow/outflow}
  AssignFile(GroupFile,'Name16');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,AuxValue[i,j,k]:8:3);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name17',2);                  {Seasonal well discharge and}
  AssignFile(GroupFile,'Name17');                   {drainage control}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,AuxValue[1,j,k]:8:3);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name18',4);                   {Seasonal area fractions and}
  AssignFile(GroupFile,'Name18');                 {and rice cropping indices}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,AuxValue[i,j,k]:8:3);
    writeln(GroupFile);
    Count:=0;
    if i=1 then
    begin
      for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
      begin
        Count:=Count+1;
        setlength (AreaA[j],Count);
        AreaA[j,Count-1]:=AuxValue[i,j,Count-1];
      end;
    end;
    if i=2 then
    begin
      for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
      begin
        Count:=Count+1;
        setlength (AreaB[j],Count);
        AreaB[j,Count-1]:=AuxValue[i,j,Count-1];
      end;
    end;
  end;
  for i:=3 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,AuxValue[i,j,k]:4:0);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name19',4);                         {Seasonal irrigation}
  AssignFile(GroupFile,'Name19');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,AuxValue[i,j,k]:8:3);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name20',2);            {Seasonal reuse of drain/well water}
  AssignFile(GroupFile,'Name20');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,AuxValue[i,j,k]:8:3);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name07',3);                   {Seasonal storage efficiency}
  AssignFile(GroupFile,'Name07');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 3 do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to InitNrOfIntPoly-1 do if Int_Ext_Index[k]=1 then
        write (GroupFile,AuxValue[i,j,k]:8:3);
    writeln(GroupFile);
  end;
  closefile (GroupFile);

  InitNrOfIntPoly:=NrOfIntPoly;
  InitNrOfExtPoly:=NrOfExtPoly;

end; {TDataMod.RemoveNodesFromFiles}
{----------------------------------}



{******************************************************************************
 Seasonal input
*******************************************************************************}


procedure TDataMod.AddToSeasonGroups;
{-----------------------------------}
var GroupFile : textfile;
    i, j, k : integer;
begin

  ReadExternalGroup;                      {external: aquifer salinity and}
  AssignFile(GroupFile,'Name14');         {seasonal water level conditions}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for k:=0 to NrOfExtPoly-1 do write (GroupFile,HlpValue[1,k]:7:2);
  writeln(GroupFile);
  for j:=1 to InitNrOfSeasons do
    begin
      for k:=0 to NrOfExtPoly-1 do write (GroupFile,HlpValue[j+1,k]:8:3);
      writeln (GroupFile);
    end;
  for j:=InitNrOfSeasons+1 to NrOfSeasons do
    begin
      for k:=0 to NrOfExtPoly-1 do write (GroupFile,' 0 ');
      writeln (GroupFile);
    end;
  closefile (GroupFile);

  ReadSeasonGroup('Name15',4);                 {Seasonal rainfall/evaporation}
  AssignFile(GroupFile,'Name15');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do
  begin
    for j:=1 to InitNrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
      writeln (GroupFile);
    end;
    for j:=InitNrOfSeasons+1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
      writeln (GroupFile);
    end;
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name16',4);                {Seasonal surface inflow/outflow}
  AssignFile(GroupFile,'Name16');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do
  begin
    for j:=1 to InitNrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
      writeln (GroupFile);
    end;
    for j:=InitNrOfSeasons+1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
      writeln (GroupFile);
    end;
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name17',2);                  {Seasonal well discharge and}
  AssignFile(GroupFile,'Name17');                  {drainage control}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do
  begin
    for j:=1 to InitNrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
      writeln (GroupFile);
    end;
    for j:=InitNrOfSeasons+1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
      writeln (GroupFile);
    end;
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name18',4);                   {Seasonal area fractions and}
  AssignFile(GroupFile,'Name18');                 {and rice cropping indices}
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do
  begin
    for j:=1 to InitNrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
      writeln (GroupFile);
    end;
    for j:=InitNrOfSeasons+1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
      writeln (GroupFile);
    end;
    if i=1 then for j:=1 to NrOfSeasons do
    begin
      setlength (AreaA[j],NrOfIntPoly);
      for k:=0 to NrOfIntPoly-1 do AreaA[j,k]:= AuxValue[i,j,k];
    end;
    if i=2 then for j:=1 to NrOfSeasons do
    begin
      setlength (AreaB[j],NrOfIntPoly);
      for k:=0 to NrOfIntPoly-1 do AreaB[j,k]:= AuxValue[i,j,k];
    end;
  end;
  for i:=3 to 4 do
  begin
    for j:=1 to InitNrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:4:0);
      writeln (GroupFile);
    end;
    for j:=InitNrOfSeasons+1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
      writeln (GroupFile);
    end;
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name19',4);                         {Seasonal irrigation}
  AssignFile(GroupFile,'Name19');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 4 do
  begin
    for j:=1 to InitNrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
      writeln (GroupFile);
    end;
    for j:=InitNrOfSeasons+1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
      writeln (GroupFile);
    end;
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name20',2);            {Seasonal reuse of drain/well water}
  AssignFile(GroupFile,'Name20');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 2 do
  begin
    for j:=1 to InitNrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
      writeln (GroupFile);
    end;
    for j:=InitNrOfSeasons+1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
      writeln (GroupFile);
    end;
  end;
  closefile (GroupFile);

  ReadSeasonGroup('Name07',3);                   {Seasonal storage efficiency}
  AssignFile(GroupFile,'Name07');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be created,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for i:=1 to 3 do
  begin
    for j:=1 to InitNrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:8:3);
      writeln (GroupFile);
    end;
    for j:=InitNrOfSeasons+1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,' -1 ');
      writeln (GroupFile);
    end;
  end;
  closefile (GroupFile);

  InitNrOfSeasons:=NrOfSeasons;
  NrOfSeasonsAdded:=0;
  Showmessage ('The number of seasons was increased. Please adjust all'+
               ' seasonal data on the Seasonal Input tabsheet starting'+
               ' with the irrigated area fractions.');

end; {TDataMod.AddToSeasonGroups}
{-------------------------------}


{****************************************************************************
           End of Polygonal data, start of Seasonal data
*****************************************************************************}


procedure TDataMod.ReadSeasonGroup (const GroupName:string;
                                    const GroupCount:byte);
{---------------------------------------------------------}
var i, j : byte; k : integer;
    GroupFile : Text;
begin
  for i:=1 to 4 do for j:=1 to 4 do
      setlength (AuxValue[i,j],DataMod.NrOfIntPoly);
  AssignFile (GroupFile,GroupName);
  reset (GroupFile);
  if (GroupName='Name07') then
  begin
    if not SeasonalStorEffOK then
    begin
      for i:=1 to 3 do
      begin
        for k:=0 to NrOfIntPoly-1 do read (GroupFile,AuxValue[i,1,k]);
        readln (GroupFile);
      end;
      for i:=1 to 3 do for j:=2 to InitNrOfSeasons do
      for k:=0 to NrOfIntPoly-1 do AuxValue[i,j,k]:=AuxValue[i,1,k];
      SeasonalStorEffOK:=true;
    end else
    begin
      for i:=1 to 3 do
      for j:=1 to InitNrOfSeasons do
      begin
        for k:=0 to NrOfIntPoly-1 do read (GroupFile,AuxValue[i,j,k]);
        readln (GroupFile);
      end;
    end;
  end else
  begin
      for i:=1 to GroupCount do
      for j:=1 to InitNrOfSeasons do
      begin
        for k:=0 to NrOfIntPoly-1 do
        begin
          Try
          read (GroupFile,AuxValue[i,j,k]);
          Except on E: exception do
             AuxValue[i,j,k]:=0;
          end;
        end;
        readln (GroupFile);
      end;
  end;
  closefile (GroupFile);

//Setting initial values

  if GroupName='Name18' then                         {seasonal area fractions}
  begin
    for j:=1 to NrOfSeasons do setlength (AreaA[j],NrOfIntPoly);
    for j:=1 to NrOfSeasons do setlength (AreaB[j],NrOfIntPoly);
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
    begin
      AreaA[j,k]:=AuxValue[1,j,k];
      AreaB[j,k]:=AuxValue[2,j,k];
      if AreaA[j,k]=0 then AuxValue[3,j,k]:=-1;
      if AreaB[j,k]=0 then AuxValue[4,j,k]:=-1;
    end;
  end;

  if GroupName='Name17' then                {well discharge, drainage control}
  begin
    for j:=1 to NrOfSeasons do setlength(Pumpage[j],NrOfIntPoly);
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        Pumpage[j,k]:=AuxValue[1,j,k];
    for k:=0 to NrOfIntPoly-1 do if DrainIndex[k]<1 then
        for j:=1 to NrOfSeasons do AuxValue[2,j,k]:=-1;
  end;

  if GroupName='Name19' then                             {seasonal irrigation}
  begin
    for j:=1 to NrOfSeasons do setlength(TotalIrr[j],NrOfIntPoly);
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        TotalIrr[j,k]:=AuxValue[1,j,k]+AreaA[j,k]*AuxValue[3,j,k]
                       +AreaB[j,k]*AuxValue[4,j,k];
  end;

  if GroupName='Name20' then                         {seasonal drainage reuse}
  begin
    for k:=0 to NrOfIntPoly-1 do if DrainIndex[k]<1 then
        for j:=1 to NrOfSeasons do AuxValue[1,j,k]:=-1;
  end;

end; {TDataMod.ReadSeasonGroup}
{-----------------------------}



procedure TDataMod.SaveSeasonGroup (const GroupName:string;
                                    const GroupCount:byte);
{---------------------------------------------------------}
var i, j : byte; k : integer;
    GroupFile : Text;
    PumpChange : boolean;
begin
  AssignFile (GroupFile,GroupName);
  rewrite (GroupFile);
  DecimalSeparator := '.';

  if GroupName='Name15' then                     {seasonal rain & evaporation}
  begin
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        if AreaA[j,k]<=0 then AuxValue[2,j,k]:=-1;
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        if AreaB[j,k]<=0 then AuxValue[3,j,k]:=-1;
    for k:=0 to NrOfIntPoly-1 do if ResponsIndex[k]<1 then
        for j:=1 to NrOfSeasons do if AreaA[j,k]+AreaB[j,k]=1 then
            AuxValue[4,j,k]:=-1;
  end;

  if GroupName='Name16' then                         {surface inflow/outflow}
  begin
    for k:=0 to NrOfIntPoly-1 do if ResponsIndex[k]<1 then
        for j:=1 to NrOfSeasons do if AreaA[j,k]+AreaB[j,k]=1 then
        begin
          AuxValue[1,j,k]:=-1;
          AuxValue[2,j,k]:=-1;
        end;
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        if AreaA[j,k]<=0 then AuxValue[3,j,k]:=-1;
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        if AreaB[j,k]<=0 then AuxValue[4,j,k]:=-1;
  end;

  if GroupName='Name17' then            {well discharge and drainage control}
  begin
    for j:=1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do write (GroupFile,AuxValue[1,j,k]:8:3);
      writeln (GroupFile);
    end;
    for j:=1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do
      begin
        if DrainIndex[k]>0 then write (GroupFile,AuxValue[2,j,k]:8:3)
        else write (GroupFile,' -1 ');
      end;
      writeln (GroupFile);
    end;
    PumpChange:=false;
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        if (AuxValue[1,j,k]>0) and (Pumpage[j,k]<>AuxValue[1,j,k]) then
            PumpChange:=true;
    if PumpChange then
       Showmessage ('The pumping from wells was changed.'+
                    '  Please check the re-use data.');
  end; {if GroupName='Name17' then}

  if (GroupName='Name18') or                    {area fractions, rice cropping}
     (GroupName='Name19') then                            {seasonal irrigation}
  begin
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        if AreaA[j,k]<=0 then AuxValue[3,j,k]:=-1;
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        if AreaB[j,k]<=0 then AuxValue[4,j,k]:=-1;
  end;

  if GroupName='Name20' then                      {well and drainage re-use}
  begin
    for j:=1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do
      begin
        if DrainIndex[k]>0 then write (GroupFile,AuxValue[1,j,k]:8:3)
        else write (GroupFile,' -1 ');
      end;
      writeln (GroupFile);
    end;
    for j:=1 to NrOfSeasons do
    begin
      for k:=0 to NrOfIntPoly-1 do
      begin
        if Pumpage[j,k]>0 then write (GroupFile,AuxValue[2,j,k]:8:3)
        else write (GroupFile,' -1 ');
      end;
      writeln (GroupFile);
    end;
  end; {if GroupName='Name20' then}

  if GroupName='Name07' then                            {storage efficiency}
  begin
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        if AreaA[j,k]=0 then AuxValue[1,j,k]:=-1;
    for j:=1 to NrOfSeasons do for k:=0 to NrOfIntPoly-1 do
        if AreaB[j,k]=0 then AuxValue[2,j,k]:=-1;
    for k:=0 to NrOfIntPoly-1 do if ResponsIndex[k]<1 then
        for j:=1 to NrOfSeasons do if AreaA[j,k]+AreaB[j,k]=1 then
            AuxValue[3,j,k]:=-1;
  end;

  if (GroupName<>'Name17') and (GroupName<>'Name20') then
  for i:=1 to GroupCount do for j:=1 to NrOfSeasons do
  begin
    for k:=0 to NrOfIntPoly-1 do write (GroupFile,AuxValue[i,j,k]:10:3);
    writeln (GroupFile);
  end;

  closefile (GroupFile);

end; {TDataMod.SaveSeasonGroup}
{-----------------------------}


{******************************************************************************
 read/write output file
 ******************************************************************************}


procedure TDataMod.ReadErrorLines
          (var ErrorPresent : boolean; var NrOfErrors : integer);
{---------------------------------------------------------------}
var ErrorFile : textfile;
    i, k : integer;
    DumLine : string;
begin
    Assignfile (ErrorFile,'error.lst');
    reset (ErrorFile);
    k:=0;
    while not eof (ErrorFile) do
    begin
      readln (ErrorFile,DumLine);
      k:=k+1;
    end;
    ErrorPresent:=false;
    if k<3 then deletefile ('error.lst')
    else
    begin
      reset (ErrorFile);
      ErrorPresent:=true;
      setlength (ErrorLines,k);
      for i:=0 to k-1 do readln (ErrorFile,ErrorLines[i]);
      NrOfErrors:=k;
    end;
    closefile (ErrorFile);
end; {procedure TDataMod.ReadErrorData}
{-------------------------------------}



procedure TDataMod.ReadWarningLines
          (var WarningPresent : boolean; var NrOfWarnings : integer);
{-------------------------------------------------------------------}
var WarningFile : textfile;
    i, k : integer;
    DumLine : string;
begin
    Assignfile (WarningFile,'warning.lst');
    reset (WarningFile);
    k:=0;
    while not eof (WarningFile) do
    begin
      readln (WarningFile,DumLine);
      k:=k+1;
    end;
    WarningPresent:=false;
    if k>=3 then
    begin
      reset (WarningFile);
      WarningPresent:=true;
      setlength (WarningLines,k);
      for i:=0 to k-1 do readln (WarningFile,WarningLines[i]);
      NrOfWarnings:=k;
    end;
    closefile (WarningFile);
end; {procedure TDataMod.ReadWarningLines}
{----------------------------------------}



procedure TDataMod.ReadInputData;
{-------------------------------}
var TmpName:string;
    InFile:textFile;
    i,j : integer;
    Dummy : real;
begin
  TmpName:=ChangeFileExt(OutputFileName,'.inp');
  if not fileexists (TmpName) then
  begin
    Showmessage ('The input file ' + TmpName + ' could not be found.' +
                 ' Output data cannot be retrieved.');
    exit;
  end;
  assignfile (InFile,TmpName);
  reset (InFile);
  for i:=1 to 2 do
  readln(InFile);
  readln (InFile,NrOfYears,NrOfSeasons);
  for i:=1 to NrOfSeasons do read (InFile,SeasonDuration[i]);
  readln (InFile);
  readln (InFile, TotNrOfPoly,NrOfIntPoly,NrOfExtPoly);
  setlength (NrOfNeighbors,NrOfIntPoly);
  for i:=1 to NrOfIntPoly do read (InFile,NrOfNeighbors[i-1]);
  readln (InFile);
  readln (InFile);
  setlength (NodalNr,TotNrOfPoly);
  for i:=0 to NrOfIntPoly-1 do read (InFile,NodalNr[i]);
  readln (InFile);
  for i:=NrOfIntPoly to TotNrOfPoly-1 do read (InFile,NodalNr[i]);
  readln (InFile);
  setlength (Xcoord,TotNrOfPoly);
  for i:=0 to NrOfIntPoly-1 do read (InFile,Xcoord[i]);
  readln (InFile);
  for i:=NrOfIntPoly to TotNrOfPoly-1 do read (InFile,Xcoord[i]);
  readln (InFile);
  setlength (Ycoord,TotNrOfPoly);
  for i:=0 to NrOfIntPoly-1 do read (InFile,Ycoord[i]);
  readln (InFile);
  for i:=NrOfIntPoly to TotNrOfPoly-1 do read (InFile,Ycoord[i]);
  readln (InFile);
  for i:=1 to 8 do readln (InFile,Dummy);
  setlength (Xvalue,1);
  Xvalue[0]:=Dummy;
  for i:=1 to 6 do setlength (Neighbor[i],NrOfIntPoly);
  for i:=0 to NrOfIntPoly-1 do
  begin
    read (InFile,Dummy);
    Xvalue[0]:=Dummy;
    for j:=1 to NrOfNeighbors[i] do
    begin
      read (InFile,Neighbor[j,i],Dummy);
      Xvalue[0]:=Dummy;
      read (InFile,Dummy);
      Xvalue[0]:=Dummy;
    end;
    readln (InFile);
  end;
  closefile (InFile);
end; {procedure TDataMod.ReadInputData;}
{--------------------------------------}



procedure TDataMod.ReadTimeDataOfPoly(Signal : string);
{-----------------------------------------------------}
var OutFile : textfile;
    HlpStr  : string[8];
    PolyStr : string[8];
    i, k, PolyNr, SkipNr : integer;
begin
  AssignFile(OutFile,OutputFileName);
  {$I-} Reset(OutFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('The file "'+OutputFileName+'"could not be opened. It may be ' +
      'damaged or in use by another program.');
    exit;
  end;
  NrOfData:=(NrOfYears+1)*NrOfSeasons;
  for k:=1 to 7 do setlength (Variable[k],NrOfData);
  i:=-1;
  SkipNr:=13;                   {if Signal='CrA'}
  NrOfItems:=7;
  if Signal='Cxf' then
  begin
    NrOfItems:=4;
    SkipNr:=15;
  end;
  if Signal='Cti' then
  begin
    NrOfItems:=5;
    SkipNr:=16;
  end;
  if Signal='Dw' then
  begin
    NrOfItems:=5;
    SkipNr:=9;
  end;
  if Signal='Gti' then
  begin
    NrOfItems:=7;
    SkipNr:=6;
  end;
  if Signal='Gd' then
  begin
    NrOfItems:=4;
    SkipNr:=8;
  end;
  if Signal='LrA' then
  begin
    NrOfItems:=4;
    SkipNr:=4;
  end;
  if Signal='RrA' then
  begin
    NrOfItems:=4;
    SkipNr:=5;
  end;
  if Signal='It' then
  begin
    NrOfItems:=5;
    SkipNr:=1;
  end;
  if (Signal='FfA') then
  begin
    NrOfItems:=5;
    SkipNr:=2;
  end;
  if Signal='EaU' then
  begin
    NrOfItems:=6;
    SkipNr:=2;
  end;
  if Signal='A' then
  begin
    NrOfItems:=4;
    SkipNr:=11;
  end;
  while i<(NrOfData-1) do
  begin
    DumStr:='';
    while not (Dumstr='Season:') do
    begin
      readln (OutFile,DumStr);
      while Pos(' ',dumstr) > 0 do
            delete(dumstr,Pos(' ',dumstr),1);
    end;
    readln (OutFile);
    readln (OutFile,DumStr,PolyStr);
    while Pos(' ',PolyStr) > 0 do
            delete(PolyStr,Pos(' ',PolyStr),1);
    PolyNr:=StrToInt(PolyStr);
    if PolyNr=PolyWanted then
    begin
      i:=i+1;
      for k:=1 to SkipNr do readln (OutFile);
      if Signal='CrA' then
      begin
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3],HlpStr,MainStr[4]);
        readln (OutFile,HlpStr,MainStr[5],HlpStr,MainStr[6],
                        HlpStr,MainStr[7]);
      end;
      if Signal='Gti' then
      begin
        readln (OutFile,PolyStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3]);
        readln (OutFile,PolyStr,MainStr[4],HlpStr,MainStr[5],
                        HlpStr,MainStr[6],HlpStr,MainStr[7]);
      end;
      if Signal='Cxf' then
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3],HlpStr,MainStr[4]);
      if Signal='Cti' then
      begin
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2]);
        readln (OutFile,HlpStr,MainStr[3],HlpStr,MainStr[4],
                        HlpStr,MainStr[5]);
      end;
      if (Signal='Dw') or (Signal='A') then
      begin
        readln (OutFile,PolyStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3]);
        readln (OutFile,PolyStr,MainStr[4],HlpStr,MainStr[5]);
      end;
      if (Signal='Gd') or (Signal='LrA') or (Signal='RrA')  then
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3],HlpStr,MainStr[4]);
      if Signal='It' then
      begin
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3],HlpStr,MainStr[4]);
        read (OutFile,HlpStr,MainStr[6],HlpStr,MainStr[6],
                        HlpStr,MainStr[6],HlpStr);
        while Pos(' ',HlpStr) > 0 do delete(HlpStr,Pos(' ',HlpStr),1);
        if HlpStr='Io=' then
           readln (OutFile,MainStr[5])
        else
          begin
            MainStr[5]:='-';
            readln (OutFile);
          end;
      end;
      if (Signal='FfA') or (Signal='EaU') then
      begin
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3]);
        readln (OutFile,HlpStr,MainStr[4],HlpStr,MainStr[5],
                        HlpStr,MainStr[6]);
      end;
      for k:=1 to NrOfitems do
      begin
        while Pos(' ',MainStr[k])>0 do
              delete(MainStr[k],Pos(' ',MainStr[k]),1);
        if (MainStr[k]='-') or (MainStr[k]='')then
           DataMod.Variable[k,i]:=-1
        else
           DataMod.Variable[k,i]:=StringToFlo(MainStr[k]);
      end;
    end;  {if PolyNr=PolyWanted then}
  end; {while i<(NrOfData-1) do}
  closefile (OutFile);
end; {TDataMod.ReadTimeDataOfPoly}
{---------------------------------}



procedure TDataMod.ReadPolyDataOfTime(Signal : string);
{-----------------------------------------------------}
label 1,2;
var OutFile : textfile;
    i, k, NrOfYear, SeasonNr : integer;
    YearStr, SeasonStr, SearchStr: string[6];
    HlpStr : string[8];
    PolyStr : string[8];
    Detect : string;
begin
  AssignFile(OutFile,OutputFileName);
  {$I-} Reset(OutFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('The file "'+OutputFileName+'"could not be opened. It may be ' +
      'damaged or in use by another program.');
    exit;
  end;
  for k:=1 to 9 do readln (OutFile);
  readln (OutFile,Dumstr,YearStr);
  if YearStr='utput ' then
  begin
    readln(OutFile);
    readln (OutFile);
    readln (OutFile,Dumstr,YearStr);
  end;
  while Pos(' ',YearStr) > 0 do delete(YearStr,Pos(' ',YearStr),1);
  NrOfYear:=StrToInt(YearStr);
  if NrOfYear=YearWanted then goto 1
  else while not (NrOfYear=YearWanted) do
  begin
    while not (DumStr='#') do
    begin
      readln (OutFile,DumStr);
      while Pos(' ',DumStr) > 0 do delete(DumStr,Pos(' ',DumStr),1);
    end;
// hier iets doen aan oude files waarbij geen frequentiegegevens zijn
    readln (OutFile,DumStr,YearStr);
    while Pos(' ',YearStr) > 0 do delete(YearStr,Pos(' ',YearStr),1);
    NrOfYear:=StrToInt(YearStr);
  end;
1:readln (OutFile);
  SeasonStr:='';
  readln (OutFile,DumStr,SeasonStr);
  while Pos(' ',SeasonStr) > 0 do delete(SeasonStr,Pos(' ',SeasonStr),1);
  SeasonNr:=StrToInt(SeasonStr);
  if SeasonNr=SeasonWanted then goto 2
  else
  while not (SeasonNr=SeasonWanted) do
  begin
    DumStr:='';
    while not (DumStr='Season:') do
    begin
      readln (OutFile,DumStr,SeasonStr);
      while Pos(' ',DumStr) > 0 do delete(DumStr,Pos(' ',DumStr),1);
    end;
    while Pos(' ',SeasonStr) > 0 do delete(SeasonStr,Pos(' ',SeasonStr),1);
    SeasonNr:=StrToInt(SeasonStr);
  end;
2:NrOfItems:=7;
  Detect := 'Uc';
  if Signal='Cxf' then
  begin
    NrOfItems:=4;
    Detect:='C1*';
  end;
  if Signal='Cti' then
  begin
    NrOfItems:=5;
    Detect:='Cxf';
  end;
  if Signal='Gti' then
  begin
    NrOfItems:=7;
    Detect:='RrA';
  end;
  if Signal='Dw' then
  begin
    NrOfItems:=5;
    Detect:='Gd';
  end;
  if Signal='Gd' then
  begin
    NrOfItems:=4;
    Detect:='Gqi';
  end;
  if Signal='LrA' then
  begin
    NrOfItems:=4;
    Detect:='JsA';
  end;
  if Signal='RrA' then
  begin
    NrOfItems:=4;
    Detect:='LrA';
  end;
  if Signal='It' then
  begin
    NrOfItems:=5;
    Detect:='Poly';
  end;
  if Signal='FfA' then
  begin
    NrOfItems:=5;
    Detect:='It';
  end;
  if Signal='EaU' then
  begin
    NrOfItems:=6;
    Detect:='It';
  end;
  if Signal='A' then
  begin
    NrOfItems:=4;
    Detect:='Sto';
  end;
  NrOfData:=DataMod.NrOfIntPoly;
  for k:=1 to 7 do setlength (Variable[k],NrOfData);
  SearchStr:='?';
  i:=-1;
  while i < NrOfIntPoly-1 do
  begin
    i:=i+1;
    while not (SearchStr=Detect) do
    begin
      readln (OutFile,SearchStr);
      while Pos(' ',SearchStr) > 0 do delete(SearchStr,Pos(' ',SearchStr),1);
    end;
    if Signal='CrA' then
    begin
      readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                      HlpStr,MainStr[3],HlpStr,MainStr[4]);
      readln (OutFile,HlpStr,MainStr[5],HlpStr,MainStr[6],
                      HlpStr,MainStr[7]);
    end;
    if Signal='Cxf' then
      readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                      HlpStr,MainStr[3],HlpStr,MainStr[4]);
    if Signal='Cti' then
    begin
      readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2]);
      readln (OutFile,HlpStr,MainStr[3],HlpStr,MainStr[4],
                      HlpStr,MainStr[5]);
    end;
    if Signal='Gti' then
    begin
      readln (OutFile,PolyStr,MainStr[1],HlpStr,MainStr[2],
                      HlpStr,MainStr[3]);
      readln (OutFile,PolyStr,MainStr[4],HlpStr,MainStr[5],
                      HlpStr,MainStr[6],HlpStr,MainStr[7]);
    end;
    if (Signal='Dw') or (Signal='A') then
    begin
      readln (OutFile,PolyStr,MainStr[1],HlpStr,MainStr[2],
                      HlpStr,MainStr[3]);
      readln (OutFile,PolyStr,MainStr[4],HlpStr,MainStr[5]);
    end;
    if (Signal='Gd') or (Signal='LrA') or (Signal='RrA') or (Signal='It') then
    begin
      if Signal='It' then readln (OutFile);
      readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                      HlpStr,MainStr[3],HlpStr,MainStr[4]);
      if Signal='It' then
      begin
        read (OutFile,HlpStr,MainStr[6],HlpStr,MainStr[6],
                      HlpStr,MainStr[6],HlpStr);
        while Pos(' ',HlpStr) > 0 do delete(HlpStr,Pos(' ',HlpStr),1);
        if HlpStr='Io=' then readln (OutFile,MainStr[5])
        else
        begin
          MainStr[5]:='-';
          readln (OutFile);
        end;
      end;
    end;
    if (Signal='FfA') or (Signal='EaU') then
    begin
      readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                      HlpStr,MainStr[3]);
      readln (OutFile,HlpStr,MainStr[4],HlpStr,MainStr[5],
                      HlpStr,MainStr[6]);
    end;
    for k:=1 to NrOfItems do
    begin
      while Pos(' ',MainStr[k])>0 do
            delete(MainStr[k],Pos(' ',MainStr[k]),1);
      if (MainStr[k]='-') then
          DataMod.Variable[k,i]:=-1
      else
          DataMod.Variable[k,i]:=StringToFlo(MainStr[k]);
    end;
    SearchStr:='?';
  end; {while i < DataMod.NrOfPolySelected-1 do}
  closefile (OutFile);
end; {TDataMod.ReadPolyDataOfTime}
{--------------------------------}



procedure TDataMod.ReadSelectedPolyData(Signal : string);
{------------------------------------------------------}
label 1,2,3;
var OutFile : textfile;
    i, k, AuxNr, NrOfYear, SeasonNr : integer;
    YearStr, SeasonStr, SearchStr: string[6];
    HlpStr : string[9];
    AuxStr : string[10];
    Detect : string;
begin
  NrOfItems:=7;
  Detect := 'Uc';
  if Signal='Cxf' then
  begin
    NrOfItems:=4;
    Detect:='C1*';
  end;
  if Signal='Cti' then
  begin
    NrOfItems:=5;
    Detect:='Cxf';
  end;
  if Signal='Gti' then
  begin
    NrOfItems:=7;
    Detect:='RrA';
  end;
  if Signal='Dw' then
  begin
    NrOfItems:=5;
    Detect:='Gd';
  end;
  if Signal='Gd' then
  begin
    NrOfItems:=4;
    Detect:='Gqi';
  end;
  if Signal='LrA' then
  begin
    NrOfItems:=4;
    Detect:='JsA';
  end;
  if Signal='RrA' then
  begin
    NrOfItems:=4;
    Detect:='LrA';
  end;
  if Signal='It' then
  begin
    NrOfItems:=5;
    Detect:='';
  end;
  if Signal='FfA' then
  begin
    NrOfItems:=5;
    Detect:='It';
  end;
  if Signal='EaU' then
  begin
    NrOfItems:=6;
    Detect:='It';
  end;
  if Signal='A' then
  begin
    NrOfItems:=4;
    Detect:='Sto';
  end;
  i:=0;
  AssignFile(OutFile,OutputFileName);
3:{$I-} Reset(OutFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('The file "'+OutputFileName+'"could not be opened. It may be ' +
      'damaged or in use by another program.');
    exit;
  end;
  for k:=1 to 9 do readln (OutFile);
  readln (OutFile,Dumstr,YearStr);
  while Pos(' ',YearStr) > 0 do delete(YearStr,Pos(' ',YearStr),1);
  NrOfYear:=StrToInt(YearStr);
  if NrOfYear=YearWanted then goto 1 
  else
  while not (NrOfYear=YearWanted) do
  begin
    while not (DumStr='#') do
    begin
      readln (OutFile,DumStr);
      while Pos(' ',DumStr) > 0 do delete(DumStr,Pos(' ',DumStr),1);
    end;
    readln (OutFile,DumStr,YearStr);
    while Pos(' ',YearStr) > 0 do delete(YearStr,Pos(' ',YearStr),1);
    NrOfYear:=StrToInt(YearStr);
  end;
1: readln (OutFile);
  readln (OutFile,DumStr,SeasonStr);
  DumStr:='';
  while Pos(' ',SeasonStr) > 0 do delete(SeasonStr,Pos(' ',SeasonStr),1);
  SeasonNr:=StrToInt(SeasonStr);
  if SeasonNr=SeasonWanted then
  begin
  end else
  while not (SeasonNr=SeasonWanted) do
  begin
    DumStr:='';
    while not (DumStr='Season:') do
    begin
      readln (OutFile,DumStr,SeasonStr);
      while Pos(' ',DumStr) > 0 do delete(DumStr,Pos(' ',DumStr),1);
    end;
    while Pos(' ',SeasonStr) > 0 do delete(SeasonStr,Pos(' ',SeasonStr),1);
    SeasonNr:=StrToInt(SeasonStr);
  end;
  NrOfData:=NrOfPolySelected;
  for k:=1 to 7 do setlength (Variable[k],NrOfData);
  SearchStr:='?';
  while i<NrOfPolySelected do
  begin
2:  AuxStr:='';
    while not (AuxStr='Polygon:') do
    begin
      read (OutFile,AuxStr);
      while Pos(' ',AuxStr) > 0 do delete(AuxStr,Pos(' ',AuxStr),1);
      if AuxStr<>'Polygon:' then readln (OutFile);
    end;
    readln (OutFile,AuxNr);
    if (AuxNr=PolySelected[i]) then
    begin
      while not (SearchStr=Detect) do
      begin
        readln (OutFile,SearchStr);
        while Pos(' ',SearchStr) > 0 do delete(SearchStr,Pos(' ',SearchStr),1);
      end;
      if Signal='CrA' then
      begin
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3],HlpStr,MainStr[4]);
        readln (OutFile,HlpStr,MainStr[5],HlpStr,MainStr[6],
                        HlpStr,MainStr[7]);
      end;
      if Signal='Cxf' then
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3],HlpStr,MainStr[4]);
      if Signal='Cti' then
      begin
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2]);
        readln (OutFile,HlpStr,MainStr[3],HlpStr,MainStr[4],
                        HlpStr,MainStr[5]);
      end;
      if Signal='Gti' then
      begin
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3]);
        readln (OutFile,HlpStr,MainStr[4],HlpStr,MainStr[5],
                        HlpStr,MainStr[6],HlpStr,MainStr[7]);
      end;
      if (Signal='Dw') or (Signal='A') then
      begin
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3]);
        readln (OutFile,HlpStr,MainStr[4],HlpStr,MainStr[5]);
      end;
      if (Signal='Gd') or (Signal='LrA') or (Signal='RrA') or (Signal='It')
      then
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3],HlpStr,MainStr[4]);
      if Signal='It' then
        readln (OutFile,HlpStr,MainStr[6],HlpStr,MainStr[6],
                        HlpStr,MainStr[6],HlpStr,MainStr[5]);
      if (Signal='FfA') or (Signal='EaU') then
      begin
        readln (OutFile,HlpStr,MainStr[1],HlpStr,MainStr[2],
                        HlpStr,MainStr[3]);
        readln (OutFile,HlpStr,MainStr[4],HlpStr,MainStr[5],
                        HlpStr,MainStr[6]);
      end;
      for k:=1 to NrOfItems do
      begin
        while Pos(' ',MainStr[k])>0 do
              delete(MainStr[k],Pos(' ',MainStr[k]),1);
        if (MainStr[k]='-') then
            DataMod.Variable[k,i]:=-1
        else
            DataMod.Variable[k,i]:=StringToFlo(MainStr[k]);
        if Signal='Dw' then DataMod.Variable[k,i]:=-DataMod.Variable[k,i];
      end;
      i:=i+1;
      goto 3;
    end {if AuxNr=PolySelected[i] then}
    else goto 2;
    SearchStr:='?';
  end; {while i<DataMod.NrOfPolySelected-1 do}
  closefile (OutFile);
end; {TDataMod.ReadSelectedPolyData}
{----------------------------------}



procedure TDataMod.ReadOutputLines(const DocName: string;
                                   var Reading : boolean);
{--------------------------------------------------------}
var  OutFile: textfile;
     k: integer;
begin
  Reading:=true;
  AssignFile(OutFile,DocName);
  {$I-} Reset(OutFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('The file "' + DocName + '"could not be opened. It may be ' +
      'damaged or in use by another program.');
    Reading:=false;
    exit;
  end;
  k:=0;
  while not eof(OutFile) do
  begin
    k:=k+1;
    SetLength (FileLine,k);
    readln(OutFile,FileLine[k-1]);
  end;
  NrOfLines:=k;
  GrTitle1:=FileLine[0];
  GrTitle2:=FileLine[2];
  GrTitle3:=FileLine[3];
  closefile(OutFile);
end; {TDataMod.ReadOutputLines}
{-----------------------------}



procedure TDataMod.PolyCharact (const DocName: string; var Reading : boolean);
{-----------------------------------------------------------------------------}
var  OutFile: textfile;
     i : integer;
     Colon : string[1];
begin
  Reading:=true;
  AssignFile(OutFile,DocName);
  {$I-} Reset(OutFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('The file "' + DocName + '"could not be opened. It may be ' +
      'damaged or in use by another program.');
    Reading:=false;
    exit;
  end;
  setlength (NodalNr,TotNrOfPoly);
  setlength (Xvalue,NrOfIntPoly);
  setlength (Yvalue,NrOfIntPoly);
  setlength (AreaT,NrOfIntPoly);
  DumStr:='';
  for i:=0 to NrOfIntPoly-1 do
  begin
    while not (Dumstr='Season:') do
    begin
      readln (OutFile,DumStr);
      while Pos(' ',dumstr) > 0 do
           delete(dumstr,Pos(' ',dumstr),1);
    end;
    readln (OutFile);
    read (OutFile,DumStr,NodalNr[i]);
    Colon:='';
    while not (Colon=':') do read (OutFile,Colon);
    read (OutFile,Xvalue[i]);
    Colon:='';
    while not (Colon=':') do read (OutFile,Colon);
    readln (OutFile,Yvalue[i]);
    Colon:='';
    while not (Colon=':') do read (OutFile,Colon);
    readln (OutFile,AreaT[i]);
    DumStr:='';
   end;
   closefile (OutFile);
end; {TDataMod.ReadPolyChar}
{--------------------------}



procedure TDataMod.ReadGroupData;
{-------------------------------}
var i, j, k   : integer;
    SeasonNr : integer;
    SerialNr  : integer;
    GroupFile : textfile;
    HlpStr    : string[14];
    TypeStr   : string[4];
    CodeStr   : string[7];
    ItemStr   : string[10];
    SeasonStr : string[16];
begin
  AssignFile(GroupFile,GroupName);
  {$I-} Reset(GroupFile); {$I+}
  NrOfLines:=0;
  while not eof (GroupFile) do
  begin
    readln (GroupFile);
    NrOfLines:=NrOflines+1;
  end;
  reset (GroupFile);
  readln (GroupFile,TypeStr);
  NoGraph:=false;
  if (TypeStr<>' YEA') and (TypeStr<>'POLY') then
  begin
    NoGraph:=true;
    showmessage ('This *.prn file is meant only for spreadsheet use.'+
                 ' Graph cannot be shown.');
    closefile (GroupFile);
    exit;
  end;
  PolyData:=true;
  if TypeStr='POLY' then PolyData:=false;
  if PolyData then NrOfData := NrOfLines-8
  else NrOfData := NrOfLines-9;
  for i:=1 to 4 do readln (GroupFile);
  if not PolyData then readln (GroupFile,CodeStr,CodeStr,CodeStr)
  else readln (GroupFile,TypeStr,CodeStr,CodeStr);
  while Pos(' ',CodeStr)>0 do
        delete(CodeStr,Pos(' ',CodeStr),1);
  GroupMark:=CodeStr;
  readln (GroupFile);
  if not PolyData then
  begin
    NrOfSeasons:=0;
    NrOfYears:=0;
    for k:=1 to 4 do
    begin
      readln (GroupFile,CodeStr,SeasonNr);
      while Pos(' ',CodeStr)>0 do
            delete(CodeStr,Pos(' ',CodeStr),1);
      if CodeStr<>'' then NrOfYears:=StrToInt(CodeStr);
      if SeasonNr>NrOfSeasons then NrOfSeasons := SeasonNr;
    end;
    CodeStr:='';
    while not (CodeStr='"---') do                // this can be simplipified
    begin
      readln (GroupFile,CodeStr);
      while Pos(' ',CodeStr)>0 do delete(CodeStr,Pos(' ',CodeStr),1);
      if (CodeStr<>'') and (CodeStr<>'"---') then NrOfYears:=StrToInt(CodeStr);
    end;
    read (GroupFile,SeasonStr);
    for k:=1 to NrOfSeasons do read (GroupFile,SeasonDuration[k]);
  end else
  begin
    CodeStr:='';
    NrOfIntPoly:=0;
    while not (CodeStr='"---') do
    begin
      readln (GroupFile,CodeStr);
      while Pos(' ',CodeStr)>0 do delete(CodeStr,Pos(' ',CodeStr),1);
      if CodeStr<>'"---' then NrOfIntPoly:=NrOfIntPoly+1;
    end;
  end;
  NrOfitems := 7;
  if GroupMark='Cxf' then NrOfitems := 4;
  if GroupMark='Cti' then NrOfitems := 5;
  if (GroupMark='Zs') or (GroupMark='Dw') then
     NrOfitems := 1;
  if GroupMark='Gti' then NrOfitems := 7;
  if GroupMark='Gd' then NrOfitems := 4;
  if (GroupMark='LrA') or (GroupMark='RrA') then
      NrOfitems := 4;
  if GroupMark='It' then NrOfitems := 5;
  if GroupMark='FfA' then NrOfitems := 5;
  if GroupMark='A' then NrOfitems := 4;
  if GroupMark='EaU' then NrOfitems := 1;
  Reset (GroupFile);
  for k:=1 to 7 do readln (GroupFile);
  Serialnr:=0;
  if not PolyData then
  begin
    for i:=0 to NrOfYears do
    begin
      for j:=1 to NrOfSeasons do
      begin
        for k:=1 to NrOfitems do
        begin
          if k=1 then read (GroupFile,HlpStr);
          read (GroupFile,ItemStr);
          setlength (Variable[k],SerialNr+1);
          if GroupMark='EaU' then setlength (Variable[6],SerialNr+1);
          while Pos(' ',ItemStr)>0 do delete(ItemStr,Pos(' ',ItemStr),1);
          if (ItemStr='-') or (ItemStr='n.a.') then
             Variable[k,SerialNr]:=0
          else
          begin
            Variable[k,SerialNr]:=StringToFlo(ItemStr);
            if GroupMark='EaU' then
               Variable[6,SerialNr]:=Variable[1,SerialNr];
          end;
        end; {for k:=1 to NrOfitems do}
        readln(GroupFile);
        SerialNr:=SerialNr+1;
      end; {for j:=1 to NrOfSeasons do}
    end; {for i:=1 to NrOfYears do}
  {end if not PolyData}
  end else
  begin
    setlength (NodalNr,NrOfIntPoly+1);
    for k:=1 to 7 do setlength (Variable[k],NrOfIntPoly);
    for j:=1 to NrOfIntPoly do
    begin
      read (GroupFile,Itemstr);
      while Pos(' ',ItemStr)>0 do delete(ItemStr,Pos(' ',ItemStr),1);
      NodalNr[j-1]:= StrToInt(ItemStr);
      for k:=1 to NrOfItems do
      begin
        read (GroupFile,ItemStr);
        while Pos(' ',ItemStr)>0 do delete(ItemStr,Pos(' ',ItemStr),1);
        if (ItemStr='-') or (ItemStr='n.a.') then
            Variable[k,j-1]:=0
        else
        begin
          Variable[k,j-1]:=StringToFlo(ItemStr);
          if GroupMark='EaU' then
             Variable[6,j-1]:=Variable[1,j-1];
        end;
      end;
      readln (GroupFile);
    end;
  end; {if PolyData}
  closefile (GroupFile);
end; {TDataMod.ReadGroupData;}
{----------------------------}


{******************************************************************************
 Diverse routines
 ******************************************************************************}


function TDataMod.StringToFlo(Str : string) : double;
{---------------------------------------------------}
//accepts comma or point for decimal separator
var
  OldDecSep : char;
begin
  try
    Result := StrToFloat(Str);
  except
    on EConvertError do begin
      OldDecSep := DecimalSeparator;
      {change to other decimal separator}
      if DecimalSeparator = ',' then
        DecimalSeparator := '.'
      else
        DecimalSeparator := ',';
      Result := StrToFloat(Str);
      {revert to original decimal separator}
      DecimalSeparator := OldDecSep;
    end;
  end;
end; {TSegRegForm.StringToFlo}
{----------------------------}



function TDataMod.Question(const Query: string): boolean;
{-------------------------------------------------------}
begin
  Result := MessageDlg(Query, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;


procedure TDataMod.DataModuleCreate(Sender: TObject);
{---------------------------------------------------}
begin
  OutputFilename := '';
end;


end.

