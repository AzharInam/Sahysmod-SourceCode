unit UInputData;

interface

uses Dialogs, SysUtils, UdataMod, UMain;

var
    InputFile : textfile;
    TmpFile   : textfile;
    ExtraFile : textfile;
    invoer    : string;
    DoIt      : boolean;
    Save08    : boolean;
    Write08   : boolean;
    DumReal   : array [1..5] of array of real;
    Nr1Real   : array [1..4] of array of real;
    Nr2Real   : array [1..4] of array of real;
    Nr3Real   : array [1..4] of array of real;
    Nr4Real   : array [1..4] of array of real;
    Aindex    : array [1..4] of array of byte;
    Bindex    : array [1..4] of array of byte;
    Uindex    : array [1..4] of array of byte;
    WellIndex : array [1..4] of array of byte;

{Making Name files}
procedure ReadInputs (var SelfDone : boolean);
procedure ReadFile ( var FileToRead: Text; var uitvoer: string);
procedure FromInpToTmp1Intern (var NrOfVar : byte);
procedure FromInpToTmp2Intern (var NrOfVar : byte);
procedure FromInpToTmpExtern;
{Composing InputFile from Name files}
procedure SaveInputs;
procedure ToInpGeneral;
procedure FromTmpToInp1Tot;
procedure FromTmpToInp1Intern (var NrOfVar : byte);
procedure FromTmpToInp2Intern (var NrOfVar : byte);
procedure FromTmpToInpExtern;
{Making a a text file for input data}
procedure SaveText;
procedure GeneralText;
procedure OverallText;
procedure NetworkText;
procedure SeasonalAreaText;
procedure SeasonalClimaText;
procedure SeasonalSurfDrText;
procedure SeasonalGwFcdText;
procedure SeasonalIrrigText;
procedure SeasonalReuseText;
procedure SeasonalStorageText;


implementation

{**************************************************************************}

procedure ReadFile ( var FileToRead: Text; var uitvoer: string);
var DumChar: char;
begin
  DumChar:=' ';
  Uitvoer :=' ';
  repeat
    if (EOLN(FileToRead)) then
      readln (FileToRead)
    else
      read (FileToRead, DumChar);
  until ((DumChar<>' ') or (EOF(FileToRead)));
 // Out:=false;
  Uitvoer:=DumChar;
  while (DumChar<>' ') and (not(EOF(FileToRead))) and (not(EOLN(FileToRead))) do
    begin
      read (FileToRead, DumChar);
      if (dumchar<>' ') then
        Uitvoer:=Uitvoer + DumChar;
    end;
end;

{**********************************************************************}

procedure FromInpToTmp1Intern (var NrOfVar : byte);
var i, ii : integer;
begin
  for ii:=1 to NrOfVar do
  begin
    for i:=1 to DataMod.NrOfIntPoly do
    begin
      ReadFile (InputFile,Invoer);
      write (TmpFile,Invoer+'  ');
    end;
    readln (InputFile);
    writeln (TmpFile);
  end;
  if Write08 and not DataMod.FarmAddOK then
  begin
     for i:=1 to DataMod.NrOfIntPoly do write (TmpFile,'1  ');
     writeln (TmpFile);
  end;
end;

{**********************************************************************}

procedure FromTmpToInp1Int (NrOfVar : byte);         {under SaveToInpFile}
var i, ii : integer;
begin

  for ii:=1 to NrOfVar do
  begin
    for i:=1 to DataMod.NrOfIntPoly do
    begin
      ReadFile (TmpFile,invoer);
      write (InputFile,invoer+'  ');
    end;
    writeln (InputFile);
  end;

end;

{**********************************************************************}

procedure FromInpToTmp2Intern (var NrOfVar : byte);
var i, ii, j : integer;
begin
  for j:=1 to NrOfVar do
    for ii:=1 to DataMod.NrOfSeasons do
    begin
      for i:=1 to DataMod.NrOfIntPoly do
        begin
          ReadFile (InputFile, Invoer);
          write (TmpFile,invoer+'  ');
        end;
      readln (InputFile);
      writeln (TmpFile);
    end;
end;

{**********************************************************************}

procedure FromInpToTmpExtern;
var i, ii : integer;
begin
  for i:=1 to DataMod.NrOfExtPoly do
  begin
    ReadFile (InputFile,invoer);
    write (TmpFile,invoer+'  ');
  end;
  readln (inputFile);
  writeln (TmpFile);
  for ii:=1 to DataMod.NrOfSeasons do
  begin
    for i:=1 to DataMod.NrOfExtPoly do
    begin
      ReadFile (InputFile,invoer);
      write (TmpFile,invoer+'  ');
    end;
    readln (inputFile);
    writeln (TmpFile);
  end;
end;

{**********************************************************************}

procedure ReadInputs (var SelfDone : boolean);
var FileToOpen, Reading : string;
    i, j, k : integer;
    NrOfParam : byte;
    OK : boolean;

begin
with DataMod do
begin
  FileToOpen:=OpenFileName;
  if AnnualCalc and (YearNr>0) then
  begin
    FileToOpen:=AnnualFileName;
    if AnnualFileName='' then FileToOpen:=OpenFileName;
  end;
  assignfile(InputFile,FileToOpen);
  {$I-}
  reset (InputFile);
  {$I+}
  readln (InputFile,Title1);
  readln (InputFile,Title2);
  Try readln (InputFile,NrOfYears,NrOfSeasons,AnnualIndex,Reading);
      Except on E: exception do Reading:='0';
  end;
  SeasonalStorEffOK:=false;
  while Pos(' ',Reading) > 0 do delete(Reading,Pos(' ',Reading),1);
  if Reading='99' then SeasonalStorEffOK:=true;
  AnnualCalc := false;
  if AnnualIndex=1 then AnnualCalc:=true;
  for i:=1 to NrOfSeasons do  read (InputFile,SeasonDuration[i]);
  readln(InputFile);
  Try readln (InputFile,TotNrOfPoly,NrOfIntPoly,NrOfExtPoly,Reading);
      Except on E: exception do Reading:='0';
  end;
  FarmAddOK:=false;
  Write08:=false;
  while Pos(' ',Reading) > 0 do delete(Reading,Pos(' ',Reading),1);
  if Reading='1' then FarmAddOK:=true;
  setlength (NrOfSides,NrOfIntPoly);
  setlength (NodeNr,TotNrOfPoly);
  setlength (Xcoord,TotNrOfPoly);
  setlength (Ycoord,TotNrOfPoly);
  setlength (Bottomlevel,TotNrOfPoly);
  setlength (Int_Ext_Index,TotNrOfPoly);
  for i:=0 to NrOfIntPoly-1 do read(InputFile,NrOfSides[i]);
  readln (InputFile,Scale,OutputTimestep,AccuracyLevel);
  SaveGeneralGroup (OK);
  for k:=0 to NrOfIntPoly-1 do read (InputFile,NodeNr[k]);
  readln (InputFile);
  for k:=0 to NrOfExtPoly-1 do read (InputFile,NodeNr[k+NrOfIntPoly]);
  readln (InputFile);
  for k:=0 to NrOfIntPoly-1 do read (InputFile,Xcoord[k]);
  readln (InputFile);
  for k:=0 to NrOfExtPoly-1 do read (InputFile,Xcoord[k+NrOfIntPoly]);
  readln (InputFile);
  for k:=0 to NrOfIntPoly-1 do read (InputFile,Ycoord[k]);
  readln (InputFile);
  for k:=0 to NrOfExtPoly-1 do read (InputFile,Ycoord[k+NrOfIntPoly]);
  readln (InputFile);
  for k:=0 to NrOfIntPoly-1 do read (InputFile,BottomLevel[k]);
  readln (InputFile);
  for k:=0 to NrOfExtPoly-1 do read (InputFile,BottomLevel[k+NrOfIntPoly]);
  readln (InputFile);
  for k:=0 to NrOfIntPoly-1 do read (InputFile,Int_Ext_Index[k]);
  readln (InputFile);
  for k:=0 to NrOfExtPoly-1 do read (InputFile,Int_Ext_Index[k+NrOfIntPoly]);
  readln (InputFile);
  SaveOverallGroup;

  for k:=1 to 6 do
  begin
    setlength (Neighbor[k],NrOfIntPoly);
    setlength (Conduct[k],NrOfIntPoly);
    setlength (TopCond[k],NrOfIntPoly);
  end;
  setlength (TopLayer,NrOfIntPoly);
  setlength (VertCond,NrOfIntPoly);
  assignfile(TmpFile,'Name02');                        {Internal Geo System}
  rewrite (TmpFile);
  NrOfParam:=4;
  FromInpToTmp1Intern (NrOfParam);
  close (TmpFile);
  for k:=0 to NrOfIntPoly-1 do                  {Network & hydr. cond., Name03}
  begin
    read (InputFile,NodeNr[k]);
    for j:=1 to NrOfSides[k] do
        read (InputFile,Neighbor[j,k],Conduct[j,k],TopCond[j,k]);
    readln(InputFile);
  end;
  for k:=0 to NrOfIntPoly-1 do
      read (InputFile,TopLayer[k]);
  readln (InputFile);
  for k:=0 to NrOfIntPoly-1 do
      read (InputFile,VertCond[k]);
  readln (InputFile);
  SaveNetworkGroup (SelfDone);

  assignfile(TmpFile,'Name04');                        {total porosities}
  rewrite (TmpFile);
  NrOfParam:=3;
  FromInpToTmp1Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name05');                        {effective porosities}
  rewrite (TmpFile);
  NrOfParam:=4;
  FromInpToTmp1Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name06');                        {leaching efficiencies}
  rewrite (TmpFile);
  NrOfParam:=3;
  FromInpToTmp1Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name07');                        {storage efficiencies}
  rewrite (TmpFile);
  NrOfParam:=3;
  if SeasonalStorEffOK then
     FromInpToTmp2Intern (NrOfParam)
  else
    FromInpToTmp1Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name08');                        {agricultural indices}
  rewrite (TmpFile);
  NrOfParam:=3;
  Write08:=true;
  if DataMod.FarmAddOK then NrOfParam:=4;
  FromInpToTmp1Intern (NrOfParam);
  Write08:=false;
  close (TmpFile);

  assignfile(TmpFile,'Name08');                        {agricultural indices}
  reset (TmpFile);
  setlength (DrainIndex, NrOfIntPoly+1);
  for k:=1 to NrOfIntPoly do read (TmpFile,DrainIndex[k-1]);
  close (TmpFile);

  assignfile(TmpFile,'Name09');                   {properties subs. dr. syst.}
  rewrite (TmpFile);
  NrOfParam:=3;
  FromInpToTmp1Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name15');                          {climatic data}
  rewrite (TmpFile);
  NrOfParam:=4;
  FromInpToTmp2Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name19');                       {irrigation applications}
  rewrite (TmpFile);
  NrOfParam:=4;
  FromInpToTmp2Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name16');                          {surface drainage}
  rewrite (TmpFile);
  NrOfParam:=4;
  FromInpToTmp2Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name18');                   {irrigated area fractions}
  rewrite (TmpFile);
  NrOfParam:=4;
  FromInpToTmp2Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name20');                       {re-use fractions}
  rewrite (TmpFile);
  NrOfParam:=2;
  FromInpToTmp2Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name17');                          {Well, Fcd}
  rewrite (TmpFile);
  NrOfParam:=2;
  FromInpToTmp2Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name12');             {initial water level & crit. depth}
  rewrite (TmpFile);
  NrOfParam:=3;
  FromInpToTmp1Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name10');                  {initial salinity topsoil}
  rewrite (TmpFile);
  NrOfParam:=3;
  FromInpToTmp1Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name11');                  {initial salinity subsoil}
  rewrite (TmpFile);
  NrOfParam:=4;
  FromInpToTmp1Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name13');                  {inflow/outflow conditions}
  rewrite (TmpFile);
  NrOfParam:=3;
  FromInpToTmp1Intern (NrOfParam);
  close (TmpFile);

  assignfile(TmpFile,'Name14');                  {Salt. Conc. Aquifer Extern}
  rewrite (TmpFile);                             {Seasonal Hydr. head Extern}
    FromInpToTmpExtern;
  close (TmpFile);

  closefile (InputFile);

end; {with DataMod do}
end; {ReadInputs}

{**************************************************************************}

procedure ToInpGeneral;
var i : integer;
begin
with DataMod do
begin
  writeln (InputFile,Title1);
  writeln (InputFile,Title2);
  writeln (InputFile,NrOfYears,' ',NrOfSeasons,' ',AnnualIndex,' ',' 99');
  for i:=1 to NrOfSeasons do  write (InputFile,SeasonDuration[i]:7:1);
  writeln(InputFile);
  writeln(InputFile,TotNrOfPoly,' ',NrOfIntPoly,' ',NrOfExtPoly,'   1');
  for i:=0 to NrOfIntPoly-1 do write(InputFile,NrOfSides[i],' ');
  writeln(InputFile);
  writeln (InputFile,Scale,' ',OutputTimestep,' ',AccuracyLevel);
end;
end;

{**************************************************************************}

procedure FromTmpToInp1Tot;
var i, ii : integer;
begin
with Datamod do
begin
  for ii:=1 to 5 do
  begin
    for i:= 1 to  NrOfIntPoly do
    begin
      ReadFile (TmpFile,invoer);
      write (InputFile,invoer+'  ');
    end;
    writeln (InputFile);
    for i:= 1 to  NrOfExtPoly do
    begin
      ReadFile (TmpFile,invoer);
      write (InputFile,invoer+'  ');
    end;
    writeln (InputFile);
  end;
end;
end;

{**************************************************************************}

procedure ToInpNetwork;
var k,j:integer;
begin
with DataMod do
begin
  for k:=0 to NrOfIntPoly-1 do
  begin
    write (InputFile,NodeNr[k]);
    for j:=1 to NrOfSides[k] do
        write (InputFile,Neighbor[j,k]:4,Conduct[j,k]:8:3,TopCond[j,k]:8:3);
    writeln(InputFile);
  end;
  for k:=0 to NrOfIntPoly-1 do
      write (InputFile,DataMod.TopLayer[k]:8:2);
  writeln (InputFile);
  for k:=0 to NrOfIntPoly-1 do
      write (InputFile,DataMod.VertCond[k]:10:4);
  writeln (InputFile);
end;
end;

{**********************************************************************}

procedure FromTmpToInp1Intern (var NrOfVar : byte);
var i, ii : integer;
begin
  for ii:=1 to NrOfVar do
  begin
    for i:=1 to DataMod.NrOfIntPoly do
    begin
      ReadFile (TmpFile,Invoer);
      if (ii=4) and Save08 and not DataMod.FarmAddOK then
      begin
        Invoer:='1';
      end;
      write (InputFile,Invoer+'  ');
    end;
    readln (TmpFile);
    writeln (InputFile);
  end;
end;

{**********************************************************************}


procedure FromTmpToInp2Intern (var NrOfVar : byte);
var i, ii, j : integer;
begin
  for j:=1 to NrOfVar do
  begin
    for ii:=1 to DataMod.NrOfSeasons do
    begin
      for i:=1 to DataMod.NrOfIntPoly do
      begin
        ReadFile (TmpFile, Invoer);
        write (InputFile,invoer+'  ');
      end;
      readln (TmpFile);
      writeln (InputFile);
    end;
  end;
end;

{**********************************************************************}

procedure FromTmpToInpExtern;
var i, ii : integer;
begin
  for i:=1 to DataMod.NrOfExtPoly do
  begin
    ReadFile (TmpFile,invoer);
    write (InputFile,invoer+'  ');
  end;
  readln (TmpFile);
  writeln (InputFile);
  for ii:=1 to DataMod.NrOfSeasons do
  begin
    for i:=1 to DataMod.NrOfExtPoly do
    begin
      ReadFile (TmpFile,invoer);
      write (InputFile,invoer+'  ');
    end;
    readln (TmpFile);
    writeln (InputFile);
  end;
end;

{**********************************************************************}

procedure SaveInputs;
var FileToOpen : string;
    NrOfParam : byte;
begin
with DataMod do
begin
  Save08:=false;
  FileToOpen:=SaveFilename;
  assignfile(InputFile,FileToOpen);
  {$I-}
  rewrite (InputFile);
  {$I+}

  ReadGeneralGroup;
  ToInpGeneral;

  assignfile(TmpFile,'Name01');                             {Overall data}
  {$I-}
  reset (TmpFile);
  {$I+}
  FromTmpToInp1Tot;
  closefile (TmpFile);

  assignfile(TmpFile,'Name02');                          {Internal Geo System}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=4;
  FromTmpToInp1Intern (NrOfParam);
  closefile (TmpFile);

  assignfile(TmpFile,'Name03');                 {Network & hydr. cond., Name03}
  {$I-}
  reset (TmpFile);
  {$I+}
  ReadNetworkGroup ('Starting');
  ToInpNetwork;
  closefile (TmpFile);

  assignfile(TmpFile,'Name04');                       {total porosities}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=3;
  FromTmpToInp1Intern (NrOfParam);
  closefile (TmpFile);

  assignfile(TmpFile,'Name05');                       {effective porosities}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=4;
  FromTmpToInp1Intern (NrOfParam);
  closefile (TmpFile);

  assignfile(TmpFile,'Name06');                       {leaching efficiencies}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=3;
  FromTmpToInp1Intern (NrOfParam);
  closefile (TmpFile);

  assignfile(TmpFile,'Name07');                       {storage efficiencies}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=3;
  FromTmpToInp2Intern (NrOfParam);                      {Seasonal values}
  closefile (TmpFile);

  assignfile(TmpFile,'Name08');                       {agricultural indices}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=4;
  Save08:=true;
  FromTmpToInp1Intern (NrOfParam);
  Save08:=false;
  closefile (TmpFile);

  assignfile(TmpFile,'Name09');                   {properties subs. dr. syst.}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=3;
  FromTmpToInp1Intern (NrOfParam);
  closefile (TmpFile);

  assignfile(TmpFile,'Name15');                           {climatic data}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=4;
  FromTmpToInp2Intern (NrOfParam);                       {Seasonal values}
  closefile (TmpFile);

  assignfile(TmpFile,'Name19');                       {irrigation applications}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=4;
  FromTmpToInp2Intern (NrOfParam);                       {Seasonal values}
  closefile (TmpFile);

  assignfile(TmpFile,'Name16');                          {surface drainage}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=4;
  FromTmpToInp2Intern (NrOfParam);                       {Seasonal values}
  closefile (TmpFile);

  assignfile(TmpFile,'Name18');                     {irrigated area fractions}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=4;
  FromTmpToInp2Intern (NrOfParam);                       {Seasonal values}
  closefile (TmpFile);

  assignfile(TmpFile,'Name20');                          {re-use fractions}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=2;
  FromTmpToInp2Intern (NrOfParam);                       {Seasonal values}
  closefile (TmpFile);

  assignfile(TmpFile,'Name17');                          {Well, Fcd}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=2;
  FromTmpToInp2Intern (NrOfParam);                       {Seasonal values}
  closefile (TmpFile);

  assignfile(TmpFile,'Name12');    {init. water level, crit. depth & pressure}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=3;
  FromTmpToInp1Intern (NrOfParam);
  closefile (TmpFile);

  assignfile(TmpFile,'Name10');                  {initial salinity topsoil}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=3;
  FromTmpToInp1Intern (NrOfParam);
  closefile (TmpFile);

  assignfile(TmpFile,'Name11');                  {initial salinity subsoil}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=4;
  FromTmpToInp1Intern (NrOfParam);
  closefile (TmpFile);

  assignfile(TmpFile,'Name13');                  {inflow/outflow conditions}
  {$I-}
  reset (TmpFile);
  {$I+}
  NrOfParam:=3;
  FromTmpToInp1Intern (NrOfParam);
  closefile (TmpFile);

  assignfile(TmpFile,'Name14');                 {Salt. Conc. Aquifer Extern}
  {$I-}                                         {Seasonal Hydr. head Extern}
  reset (TmpFile);
  {$I+}
  FromTmpToInpExtern;
  closefile (TmpFile);

  closefile (InputFile);

end; {with DataMod do}
end; {SaveInputs}

{**************************************************************************}

procedure GeneralText;
var i : integer;
begin
with DataMod do
begin
  writeln (ExtraFile,Title1);
  writeln (ExtraFile,Title2);
  writeln (ExtraFile);
  writeln (ExtraFile,'General_data:');
  writeln (ExtraFile,'  NrOfYears NrOfSeasons  Calc. index');
  writeln (ExtraFile,NrOfYears:7,NrOfSeasons:10,AnnualIndex:9);
  writeln (Extrafile, '   Season   Duration (months)');
  for i:=1 to NrOfSeasons do writeln (ExtraFile,i:7,SeasonDuration[i]:10:1);
  writeln (ExtraFile, ' TotNrOfPoly NrOfIntPoly NrOfExtPoly');
  writeln (ExtraFile, TotNrOfPoly:7, NrOfIntPoly:10, NrOfExtPoly:9);
  writeln (ExtraFile, '    Scale  Time step  Accuracy');
  writeln (ExtraFile,Scale:7,OutputTimestep:10,AccuracyLevel:9);
  writeln (ExtraFile);
end;
end;

{**************************************************************************}

procedure OverallText;
var k:integer;
begin
with DataMod do
begin
  writeln (ExtraFile, 'Overall_system_geometry:');
  writeln (ExtraFile, '   Node      X        Y         BL      Ki/e');
  for k:=0 to TotNrOfPoly-1 do
      writeln (ExtraFile,NodeNr[k]:7,Xcoord[k]:10:2,Ycoord[k]:9:2,
               BottomLevel[k]:9:1,Int_Ext_Index[k]:9);
  writeln (ExtraFile);
end;
end;

{**************************************************************************}

procedure NetworkText;
var i, j : integer;
begin
with DataMod do
begin
  writeln (ExtraFile, 'Hydraulic_conductivity:');
  writeln (ExtraFile,
           ' From_Node to_Node  K_hori    K_top    K_vert   D_top');
  setlength (AquiferType,NrOfIntPoly);
  for j:=0 to NrOfIntPoly-1 do
  begin
    for i:=1 to NrOfSides[j] do
    begin
      write (ExtraFile,NodeNr[j]:8);
      if AquiferType[j]=1 then
      begin
        write (ExtraFile,Neighbor[i,j]:6,'  ',Conduct[i,j]:9:3,
               TopCond[i,j]:9:3,TopLayer[j]:9:3,VertCond[j]:9:3);
        writeln (ExtraFile);
      end else
      begin
        write (ExtraFile,Neighbor[i,j]:6,'  ',Conduct[i,j]:9:3,'     n.a.',
               '     n.a.', '     n.a.');
        writeln (ExtraFile);
      end;
    end;
  end;
  writeln (ExtraFile);
end;
end;

{**************************************************************************}

procedure SeasonalAreaText;
var i, j : integer;
begin
with DataMod do
begin
  for i:=1 to DataMod.NrOfSeasons do setlength (Aindex[i],DataMod.NrOfIntPoly);
  for i:=1 to DataMod.NrOfSeasons do setlength (Bindex[i],DataMod.NrOfIntPoly);
  for i:=1 to DataMod.NrOfSeasons do setlength (Uindex[i],DataMod.NrOfIntPoly);
  for i:=1 to DataMod.NrOfSeasons do for j:=0 to DataMod.NrOfIntPoly-1 do
  begin
    Aindex[i,j]:=1;
    Bindex[i,j]:=1;
    Bindex[i,j]:=1;
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do
    begin
      read (TmpFile,Nr1Real[i,j]);
      if Nr1Real[i,j]<0.001 then Aindex[i,j]:=0;
    end;
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do
    begin
      read (TmpFile,Nr2Real[i,j]);
      if Nr2Real[i,j]<0.001 then Bindex[i,j]:=0;
    end;
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr3Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr4Real[i,j]);
    readln (TmpFile);
  end;
  for j:=0 to NrOfIntPoly-1 do for i:=1 to NrOfSeasons do
  begin
    if Nr1Real[i,j]<0.001 then Aindex[i,j]:=0;
    if Nr1Real[i,j]<0.001 then Bindex[i,j]:=0;
    Uindex[i,j]:=1;
  end;
  for j:=0 to NrOfIntPoly-1 do
  begin
    for i:=1 to NrOfSeasons do
    begin
      if Nr1Real[i,j]+Nr2Real[i,j]>0.999 then Uindex[i,j]:=0;
//      if i=1 then
//      begin
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:12:3,'      n.a.',Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.','      n.a.');
(*
      end else
      begin
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:12:3,'      n.a.',Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.','      n.a.');
      end;
*)
    end;
  end;
  writeln (ExtraFile);
end;
end;

{**************************************************************************}

procedure SeasonalClimaText;
var i, j : integer;
begin
with DataMod do
begin
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr1Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr2Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr3Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr4Real[i,j]);
    readln (TmpFile);
  end;
  for j:=0 to NrOfIntPoly-1 do
  begin
    for i:=1 to NrOfSeasons do
    begin
//      if i=1 then
//      begin
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    '      n.a.',Nr3Real[i,j]:12:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.',Nr4Real[i,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    '      n.a.','      n.a.',Nr4Real[i,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    '      n.a.',Nr3Real[i,j]:12:3,'      n.a.');
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.','      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    '      n.a.','      n.a.','      n.a.');
(*
      end else
      begin
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    '      n.a.',Nr3Real[i,j]:12:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.',Nr4Real[i,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    '      n.a.','      n.a.',Nr4Real[i,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:6,Nr1Real[i,j]:12:3,
                    '      n.a.',Nr3Real[i,j]:12:3,'      n.a.');
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.','      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    '      n.a.','      n.a.','      n.a.');
      end;
*)
    end;
  end;
  writeln (ExtraFile);
end;
end;

{**************************************************************************}

procedure SeasonalSurfDrText;
var i, j : integer;
begin
with DataMod do
begin
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr1Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr2Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr3Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr4Real[i,j]);
    readln (TmpFile);
  end;
  for j:=0 to NrOfIntPoly-1 do
  begin
    for i:=1 to NrOfSeasons do
    begin
//      if i=1 then
//      begin
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.',Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,'       n.a. ',
                    '      n.a.',Nr3Real[i,j]:10:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.','      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,'       n.a. ',
                    '      n.a.','      n.a.',Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,'       n.a. ',
                    '      n.a.',Nr3Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,'       n.a. ',
                    '      n.a.','      n.a.','       n.a. ');
(*
      end else
      begin
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.',Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,'       n.a. ',
                    '      n.a.',Nr3Real[i,j]:10:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.','      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,'       n.a. ',
                    '      n.a.','      n.a.',Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,'       n.a. ',
                    '      n.a.',Nr3Real[i,j]:10:3,'       n.a. ');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,'       n.a. ',
                    '      n.a.','      n.a.','      n.a.');
      end;
*)
    end;
  end;
  writeln (ExtraFile);
end;
end;

{**************************************************************************}

procedure SeasonalGwFcdText;
var i, j : integer;
begin
with DataMod do
begin
  for i:=1 to DataMod.NrOfSeasons do
      setlength (Wellindex[i],DataMod.NrOfIntPoly);
  for i:=1 to DataMod.NrOfSeasons do for j:=0 to DataMod.NrOfIntPoly-1 do
      WellIndex[i,j]:=1;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do
    begin
      read (TmpFile,Nr1Real[i,j]);
      if Nr1Real[i,j]<0.001 then Wellindex[i,j]:=0;
    end;
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr2Real[i,j]);
    readln (TmpFile);
  end;
  for j:=0 to NrOfIntPoly-1 do
  begin
    for i:=1 to NrOfSeasons do
    begin
//      if i=1 then
//      begin
        if DrainIndex[j]=1 then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3);
        if DrainIndex[j]=0 then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    '      n.a.');
(*
      end else
      begin
        if (Wellindex[i,j]=1) and (DrainIndex[j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3);
        if (Wellindex[i,j]=1) and (DrainIndex[j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    '      n.a.');
        if (Wellindex[i,j]=0) and (DrainIndex[j]=1) then
           writeln (ExtraFile,i:16,'       n.a.',
                    Nr3Real[i,j]:11:3);
        if (Wellindex[i,j]=0) and (DrainIndex[j]=0) then
           writeln (ExtraFile,i:16,'       n.a. ',
                    '      n.a.');
      end;
*)
    end;
  end;
  writeln (ExtraFile);
end;
end;

{**************************************************************************}

procedure SeasonalIrrigText;
var i, j : integer;
begin
with DataMod do
begin
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr1Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr2Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr3Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr4Real[i,j]);
    readln (TmpFile);
  end;
  for j:=0 to NrOfIntPoly-1 do
  begin
    for i:=1 to NrOfSeasons do
    begin
//      if i=1 then
//      begin
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:12:3,'      n.a.',Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.','      n.a.');
(*
      end else
      begin
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:12:3,'      n.a.',Nr4Real[1,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.','      n.a.');
      end;
*)
    end;
  end;
  writeln (ExtraFile);
end;
end;

{**************************************************************************}

procedure SeasonalReuseText;
var i, j : integer;
begin
with DataMod do
begin
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr2Real[i,j]);
    readln (TmpFile);
  end;
  for j:=0 to NrOfIntPoly-1 do
  begin
    for i:=1 to NrOfSeasons do
    begin
      if Nr1Real[i,j]+Nr2Real[i,j]>0.999 then Uindex[i,j]:=0;
//      if i=1 then
//      begin
        if (Wellindex[i,j]=1) and (DrainIndex[j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3);
        if (Wellindex[i,j]=1) and (DrainIndex[j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    '      n.a.');
        if (Wellindex[i,j]=0) and (DrainIndex[j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,'      n.a.',
                    Nr2Real[i,j]:10:3);
        if (Wellindex[i,j]=0) and (DrainIndex[j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,'       n.a. ',
                    '      n.a.');
(*
      end else
      begin
        if (Wellindex[i,j]=1) and (DrainIndex[j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3);
        if (Wellindex[i,j]=1) and (DrainIndex[j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    '      n.a.');
        if (Wellindex[i,j]=0) and (DrainIndex[j]=1) then
           writeln (ExtraFile,i:16,'      n.a.',
                    Nr2Real[i,j]:10:3);
        if (Wellindex[i,j]=0) and (DrainIndex[j]=0) then
           writeln (ExtraFile,i:19,'       n.a. ',
                    '      n.a.');
      end;
*)
    end;
  end;
  writeln (ExtraFile);
end;
end;

{**************************************************************************}

procedure SeasonalStorageText;
var i, j : integer;
begin
with DataMod do
begin
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr1Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr2Real[i,j]);
    readln (TmpFile);
  end;
  for i:=1 to NrOfSeasons do
  begin
    for j:=0 to NrOfIntPoly-1 do read (TmpFile,Nr3Real[i,j]);
    readln (TmpFile);
  end;
  for j:=0 to NrOfIntPoly-1 do
  begin
    for i:=1 to NrOfSeasons do
    begin
//      if i=1 then
//      begin
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,'       n.a. ',
                    Nr2Real[i,j]:12:3,Nr3Real[i,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    '      n.a.',Nr3Real[i,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,'       n.a. ',
                    '      n.a.',Nr3Real[i,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,'       n.a. ',
                    Nr2Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,Nr1Real[i,j]:12:3,
                    '      n.a.','      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,NodeNr[j]:7,i:9,'       n.a. ',
                    '      n.a.','      n.a.');
(*
      end else
      begin
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,Nr3Real[i,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,'       n.a. ',
                    Nr2Real[i,j]:12:3,Nr3Real[i,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    '      n.a.',Nr3Real[i,j]:10:3);
        if (Aindex[i,j]=1) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    Nr2Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=1) then
           writeln (ExtraFile,i:16,'       n.a. ',
                    '      n.a.',Nr3Real[i,j]:10:3);
        if (Aindex[i,j]=0) and (Bindex[i,j]=1) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,'       n.a. ',
                    Nr2Real[i,j]:10:3,'      n.a.');
        if (Aindex[i,j]=1) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,Nr1Real[i,j]:12:3,
                    '      n.a.','      n.a.');
        if (Aindex[i,j]=0) and (Bindex[i,j]=0) and (Uindex[i,j]=0) then
           writeln (ExtraFile,i:16,'       n.a. ',
                    '      n.a.','      n.a.');
      end;
*)
    end;
  end;
  writeln (ExtraFile);
end;
end;

{**************************************************************************}

procedure SaveText;
var FileToOpen, DumStr : string;
    i, j, NrOfPoly, KfrInt : integer;
    RotationKey : array of integer;
begin
  DumStr:=DataMod.SaveFilename;
  DumStr:=ChangeFileExt(DumStr,'');
  DumStr:=Dumstr+'Inp';
  FileToOpen:=ChangeFileExt(DumStr,'.txt');
  assignfile(ExtraFile,FileToOpen);
  {$I-}
  rewrite (ExtraFile);
  {$I+}

  DataMod.ReadGeneralGroup;                                 {General data}
  GeneralText;

  DataMod.ReadOverallGroup;
  OverallText;

  NrOfPoly:=DataMod.NrOfIntPoly;
  if DataMod.NrOfExtPoly>DataMod.NrOfIntPoly then NrOfPoly:=DataMod.NrOfExtPoly;
  for i:=1 to 5 do setlength(DumReal[i],NrOfPoly);

  assignfile(TmpFile,'Name02');                          {Internal Geo System}
  {$I-}
  reset (TmpFile);
  {$I+}
  for i:=1 to 4 do
  begin
    for j:=0 to DataMod.NrOfIntPoly-1 do read (TmpFile,DumReal[i,j]);
    readln (TmpFile);
  end;
  writeln ( ExtraFile, 'Internal_system_geometry:');
  writeln ( ExtraFile, '    Node       SL       Dr       Dx      Ksc');
  for j:=0 to DataMod.NrOfIntPoly-1 do
    writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:3,DumReal[2,j]:9:3,
             DumReal[3,j]:9:3,DumReal[4,j]:9:0);
  writeln (ExtraFile);
  closefile (TmpFile);

  DataMod.ReadNetworkGroup('Starting');        {Network & hydr. cond., Name03}
  NetworkText;

  assignfile(TmpFile,'Name04');                          {total porosities}
  {$I-}
  reset (TmpFile);
  {$I+}
  for i:=1 to 3 do
  begin
    for j:=0 to DataMod.NrOfIntPoly-1 do read (TmpFile,DumReal[i,j]);
    readln (TmpFile);
  end;
  writeln (ExtraFile, 'Total_porosity:');
  writeln (ExtraFile,'    Node      Ptr      Ptx      Ptq');
  for j:=0 to DataMod.NrOfIntPoly-1 do
      writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:3,DumReal[2,j]:9:3,
               DumReal[3,j]:9:3);
  writeln (ExtraFile);
  closefile (TmpFile);

  assignfile(TmpFile,'Name05');                        {effective porosities}
  {$I-}
  reset (TmpFile);
  {$I+}
  for i:=1 to 4 do
  begin
    for j:=0 to DataMod.NrOfIntPoly-1 do read (TmpFile,DumReal[i,j]);
    readln (TmpFile);
  end;
  writeln (ExtraFile, 'Effective_porosity/storage_coefficient:');
  writeln (ExtraFile,'    Node      Per      Pex      Peq     Psq');
  for j:=0 to DataMod.NrOfIntPoly-1 do
  begin
    write (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:3,DumReal[2,j]:9:3,
           DumReal[3,j]:9:3);
    if DataMod.AquiferType[j]=1 then
       writeln (ExtraFile,DumReal[4,j]:9:4)
    else
       writeln (ExtraFile,'    n.a.');
  end;
  writeln (ExtraFile);
  closefile (TmpFile);

  assignfile(TmpFile,'Name06');                        {leaching efficiencies}
  {$I-}
  reset (TmpFile);
  {$I+}
  for i:=1 to 3 do
  begin
    for j:=0 to DataMod.NrOfIntPoly-1 do read (TmpFile,DumReal[i,j]);
    readln (TmpFile);
  end;
  writeln (ExtraFile, 'Leaching_efficiencies:');
  writeln (ExtraFile,'    Node      Flr      Flx      Flq');
  for j:=0 to DataMod.NrOfIntPoly-1 do
    writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:3,DumReal[2,j]:9:3,
             DumReal[3,j]:9:3);
  writeln (ExtraFile);
  closefile (TmpFile);

  assignfile(TmpFile,'Name08');                        {agricultural indices}
  {$I-}
  reset (TmpFile);
  {$I+}
  setlength (RotationKey,DataMod.NrOfIntPoly);
  for i:=1 to 4 do
  begin
    for j:=0 to DataMod.NrOfIntPoly-1 do
    begin
      read (TmpFile,DumReal[i,j]);
      if i=3 then
         RotationKey[j]:=Trunc(DumReal[i,j]);
    end;
    readln (TmpFile);
  end;
  writeln (ExtraFile, 'Indices_of_agricultural_practices:');
  writeln (ExtraFile,'    Node       Kd       Kf       Kr      Krf');
  DoIt:= false;
  setlength (DataMod.DrainIndex,DataMod.NrOfIntPoly);
  for j:=0 to DataMod.NrOfIntPoly-1 do
  begin
    KfrInt:=trunc(DumReal[4,j]);
    if DumReal[2,j]>0 then
      writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:0,DumReal[2,j]:9:0,
               DumReal[3,j]:9:0,KfrInt:9)
    else
      writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:0,DumReal[2,j]:9:0,
               DumReal[3,j]:9:0,'     n.a.');
    if DataMod.DrainIndex[j]>0 then DoIt:=true;
  end;
  writeln (ExtraFile);
  closefile (TmpFile);

  if DoIt then
  begin
    assignfile(TmpFile,'Name09');                   {properties subs. dr. syst.}
    {$I-}
    reset (TmpFile);
    {$I+}
    for i:=1 to 3 do
    begin
      for j:=0 to DataMod.NrOfIntPoly-1 do read (TmpFile,DumReal[i,j]);
      readln (TmpFile);
    end;
    writeln (ExtraFile,'Subsurface_drainage_system:');
    writeln (ExtraFile,'    Node       Dd       QH1      QH2');
    for j:=0 to DataMod.NrOfIntPoly-1 do
    begin
      if DataMod.DrainIndex[j]=1 then
      writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:0,DumReal[2,j]:9:0,
               DumReal[3,j]:9:0);
      if DataMod.DrainIndex[j]<>1 then writeln (ExtraFile,DataMod.NodeNr[j]:7,
                                           '      n.a.','     n.a.','     n.a.');
    end;
    writeln (ExtraFile);
    closefile (TmpFile);
  end; {if DoIt then}


  assignfile(TmpFile,'Name12');     {init. water level, crit. depth & pressure}
  {$I-}
  reset (TmpFile);
  {$I+}
  for i:=1 to 3 do
  begin
    for j:=0 to DataMod.NrOfIntPoly-1 do read (TmpFile,DumReal[i,j]);
    readln (TmpFile);
  end;
  writeln (ExtraFile,'Initial_hydraulic_head_and_critical_depth_watertable:');
  writeln (ExtraFile,'    Node       H        Dc     H conf');
  for j:=0 to DataMod.NrOfIntPoly-1 do
  begin
    write (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:3,DumReal[2,j]:9:3);
    if DataMod.AquiferType[j]=1 then writeln (ExtraFile,DumReal[3,j]:9:2);
    if DataMod.AquiferType[j]<>1 then writeln (ExtraFile,'     n.a.');
  end;
  writeln (ExtraFile);
  closefile (TmpFile);

  assignfile(TmpFile,'Name10');                    {initial salinity topsoil}
  {$I-}
  reset (TmpFile);
  {$I+}
  for i:=1 to 3 do
  begin
    for j:=0 to DataMod.NrOfIntPoly-1 do read (TmpFile,DumReal[i,j]);
    readln (TmpFile);
  end;
  writeln (ExtraFile, 'Initial_salinity_conditions_root_zone:');
  Writeln (ExtraFile,'    Node      CAo      CBo      CUo');
  for j:=0 to DataMod.NrOfIntPoly-1 do
  begin
    if RotationKey[j]=0 then
    writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:3,DumReal[2,j]:9:3,
             DumReal[3,j]:9:3);
    if RotationKey[j]=1 then
    writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:3,'     n.a.',
             DumReal[3,j]:9:3);
    if (RotationKey[j]>1) and (RotationKey[j]<4) then
    writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:3,DumReal[2,j]:9:3,
             '    n.a. ');
    if RotationKey[j]=4 then
    writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:3,'     n.a.',
             '    n.a. ');
    if RotationKey[j]<0 then
    writeln (ExtraFile,DataMod.NodeNr[j]:7,'     n.a. ','     n.a.',
             '    n.a. ');
  end;
  writeln (ExtraFile);
  closefile (TmpFile);

  assignfile(TmpFile,'Name11');                    {initial salinity subsoil}
  {$I-}
  reset (TmpFile);
  {$I+}
  for i:=1 to 4 do
  begin
    for j:=0 to DataMod.NrOfIntPoly-1 do read (TmpFile,DumReal[i,j]);
    readln (TmpFile);
  end;
  writeln (ExtraFile, 'Initial_salinity_conditions_subsoil:');
  Writeln (ExtraFile,'   Node     Cxa0     Cxb0     Cx0     Cq0');
  for j:=0 to DataMod.NrOfIntPoly-1 do
  begin
    if DataMod.DrainIndex[j]=1 then
    writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:10:3,
             DumReal[2,j]:9:3,'     n.a.',DumReal[4,j]:9:3)
    else
    writeln (ExtraFile,DataMod.NodeNr[j]:7,'     n.a. ','    n.a. ',
             DumReal[3,j]:9:3,DumReal[4,j]:9:3)
  end;
  writeln (ExtraFile);
  closefile (TmpFile);

  assignfile(TmpFile,'Name13');                  {inflow/outflow conditions}
  {$I-}
  reset (TmpFile);
  {$I+}
  for i:=1 to 3 do
  begin
    for j:=0 to DataMod.NrOfIntPoly-1 do read (TmpFile,DumReal[i,j]);
    readln (TmpFile);
  end;
  writeln (ExtraFile,'Aquifer_inflow/outflow_conditions:');
  writeln (ExtraFile,'    Node      Qinf     Cinf     Qout');
  for j:=0 to DataMod.NrOfIntPoly-1 do
    writeln (ExtraFile,DataMod.NodeNr[j]:7,DumReal[1,j]:11:3,DumReal[2,j]:9:1,
             DumReal[3,j]:9:3);
  writeln (ExtraFile);
  closefile (TmpFile);

  assignfile(TmpFile,'Name14');                 {Salt. Conc. Aquifer Extern}
  {$I-}                                         {Seasonal Hydr. head Extern}
  reset (TmpFile);
  {$I+}
  for j:=0 to DataMod.NrOfExtPoly-1 do read (TmpFile,DumReal[1,j]);
  readln (TmpFile);
  for i:=1 to DataMod.NrOfSeasons do
  begin
    for j:=0 to DataMod.NrOfExtPoly-1 do read (TmpFile,DumReal[i+1,j]);
    readln (TmpFile);
  end;
  writeln ( ExtraFile,'Boundary_conditions:');
  write ( ExtraFile,'    Node      Cq0');
  for i:=1 to DataMod.NrOfSeasons do
  begin
    Dumstr:='    H(s=' + IntToStr(i) + ')';
    write (ExtraFile, Dumstr);
  end;
  writeln (ExtraFile);
  for j:=0 to DataMod.NrOfExtPoly-1 do
  begin
    i:=DataMod.NrOfIntPoly+j;
    write (ExtraFile,DataMod.NodeNr[i]:7,DumReal[1,j]:10:3);
    for i:=1 to DataMod.NrOfSeasons do write (ExtraFile,DumReal[i+1,j]:10:2);
    writeln (ExtraFile);
  end;
  writeln (ExtraFile);
  closefile (TmpFile);
(*
The next routine finds if the hydr. cond. from internal to external node
is zero, then writes 'n.a.' for the external head if so
      ExtNr:=i+DataMod.NrOfIntPoly;
      Nr1:=round(DataMod.NodeNr[ExtNr]);
      if Flag[Nr1]=0 then
         write (ExtraFile, NodeNr[ExtNr]:7:0, DumReal[1,i]:10:3)
      else
         write (ExtraFile, NodeNr[ExtNr]:7:0, '      n.a.');
      for ii:=1 to NrOfSeasons do
           if Flag[Nr1]=0 then
              write (ExtraFile, DumReal[ii+1,i]:10:2)
           else write (ExtraFile, '      n.a.');
      writeln (OutputFile);
*)

  for i:=1 to DataMod.NrOfSeasons do setlength (Nr1Real[i],DataMod.NrOfIntPoly);
  for i:=1 to DataMod.NrOfSeasons do setlength (Nr2Real[i],DataMod.NrOfIntPoly);
  for i:=1 to DataMod.NrOfSeasons do setlength (Nr3Real[i],DataMod.NrOfIntPoly);
  for i:=1 to DataMod.NrOfSeasons do setlength (Nr4Real[i],DataMod.NrOfIntPoly);

  assignfile(TmpFile,'Name18');                 {Irrig. areas & rice cropping}
  {$I-}
  reset (TmpFile);
  {$I+}
  Writeln (ExtraFile,'Irrigated_area_and_rice_crop_index:');
  Writeln (ExtraFile,
  '    Node   Season          A         B       KcA       KcB');
  SeasonalAreaText;
  closefile(TmpFile);

  assignfile(TmpFile,'Name15');                        {Climatic data}
  {$I-}
  reset (TmpFile);
  {$I+}
  Writeln (ExtraFile,'Rainfall_and_crop_evapotranspiration:');
  Writeln (ExtraFile,
  '    Node   Season         Pp       EpA       EpB       EpU');
  SeasonalClimaText;
  closefile(TmpFile);

  assignfile(TmpFile,'Name16');                          {surface drainage}
  {$I-}
  reset (TmpFile);
  {$I+}
  Writeln (ExtraFile,'Surface_inflow/outflow/drainage:');
  Writeln (ExtraFile,
  '    Node   Season        SiU       SoU       SoA       SoB');
  SeasonalSurfDrText;
  closefile (TmpFile);

  assignfile(TmpFile,'Name17');                          {Well, Fcd}
  {$I-}
  reset (TmpFile);
  {$I+}
  Writeln (ExtraFile,'Well_discharge_and_drainage_reduction_factor:');
  Writeln (ExtraFile,'    Node   Season         Gw       Fcd');
  SeasonalGwFcdText;
  closefile (TmpFile);

  assignfile(TmpFile,'Name19');                      {irrigation applications}
  {$I-}
  reset (TmpFile);
  {$I+}
  Writeln (ExtraFile,'Data_on_irrigation_water:');
  Writeln (ExtraFile,
  '    Node   Season         Lc       Cic       IaA       IaB');
  SeasonalIrrigText;
  closefile (TmpFile);

  if not DoIt then for i:=1 to DataMod.NrOfSeasons do
     for j:=0 to DataMod.NrOfIntPoly-1 do
        if WellIndex[i,j]=1 then DoIt:=true;
  if DoIt then
  begin
  assignfile(TmpFile,'Name20');                               {Reuse}
  {$I-}
  reset (TmpFile);
  {$I+}
  Writeln (ExtraFile,'Re-use_of_drain_and_well_water:');
  Writeln (ExtraFile,
  '    Node   Season         Gu        Fw');
  SeasonalReuseText;
  closefile (TmpFile);
  end;

  assignfile(TmpFile,'Name07');                         {storage efficiencies}
  {$I-}
  reset (TmpFile);
  {$I+}
  Writeln (ExtraFile,'Storage/irrigation_efficiency:');
  Writeln (ExtraFile,
  '    Node   Season        FsA       FsB       FsU');
  SeasonalStorageText;
  closefile (TmpFile);

  closefile (ExtraFile);

  for i:=1 to DataMod.NrOfSeasons do setlength (Aindex[i],1);
  for i:=1 to DataMod.NrOfSeasons do setlength (Bindex[i],1);
  for i:=1 to DataMod.NrOfSeasons do setlength (Uindex[i],1);
  for i:=1 to DataMod.NrOfSeasons do setlength (Wellindex[i],1);
  for i:=1 to 5 do setlength(DumReal[i],1);
  setlength (RotationKey,1);
  for i:=1 to DataMod.NrOfSeasons do setlength (Nr1Real[i],1);
  for i:=1 to DataMod.NrOfSeasons do setlength (Nr2Real[i],1);
  for i:=1 to DataMod.NrOfSeasons do setlength (Nr3Real[i],1);
  for i:=1 to DataMod.NrOfSeasons do setlength (Nr4Real[i],1);

end; {SaveText}

{**************************************************************************}

end.
