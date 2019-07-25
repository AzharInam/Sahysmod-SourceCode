unit UInitialCalc;

interface

  uses SysUtils;

  var Qaq, Byp, EpU0, AreaU, AA0, BB0,
      IRA0, IRB0, EpA0, EpB0                : array of array of real;
      SALY, SurfConc, Dw0, StorWL           : array of real;
      NextNode                              : array of array of integer;
      DWT, DRT, DRA, DRB, CAT, PLCC, PLT,
      Aqu1, Ltr1, Dsc1,HIGD, HOGD, HITD, HOTD,
      STID, SGID, Rech, Zit, Zig, ZDr, Zwell,
      Zir, CIR, CIT, PLA, PLB, PLU,
      CAA, CAB, CAU, DwT0, SUA, SUB,
      EFA, EFB, PLC                         : real;
      OutputFile, FrqFile, GwtFile          : textfile;
      Warning, NoIrr, Watch                 : boolean;

  procedure InitialActions;
  procedure AdjustRotation;
  procedure InitSalinity;
  procedure GroundwaterFlow (i, j : integer);
  procedure RootzoneHydrology (i, j : integer);
  procedure DrainDischarge (i, j : integer);
  procedure IrrEff_Suff (i, j : integer);
  procedure WriteOutput (i, j, m : integer);
  procedure WriteFrequency (i, j, m : integer);
  procedure WriteGwtFile (i, j, m : integer);

implementation

  uses UDataMod, UDataTest, UExtraUtils;//, UWarningForm;

  var InitRota : array of integer;
      RotaPassed     : boolean; 
      EFT, ZZ        : real;
      Duration, Year : integer;

procedure InitialActions;
var i, j, k : integer;
begin
with DataMod do
begin

//First lines to WarningMemo
//  WarningForm.WarningMemo.Lines.Clear;
//  WarningForm.WarningMemo.Lines.Add ('THE FOLLOWING INITIAL WARNING(S) ARE'+
//                                     ' GIVEN. THESE ARE NO ERRORS.');
//Opening 3 output files
  OutputFileName:=ChangeFileExt (SaveFileName,'.out');
  Assignfile (OutputFile,OutputFileName);
  rewrite (OutputFile);
  OutputFileName:=changefileext (SaveFileName,'.frq');
  Assignfile (FrqFile,OutputFileName);
  rewrite (FrqFile);
  OutputFileName:=changefileext (SaveFileName,'.gwt');
  Assignfile (GwtFile,OutputFileName);
  rewrite (GwtFile);

//Writing a header in the *.OUT output file
  writeln (OutputFile);
  writeln (OutputFile,' SAHYSMOD: A predictive computation method for'+
                      ' soil and groundwater,');
  writeln (OutputFile,' salinity and the watertable depth'+
                      ' in agricultural lands using');
  writeln (OutputFile,' varying hydrologic conditions and'+
                      ' watermanagement options.');
  writeln (OutputFile,' The first version of the ILRI working group:');
  writeln (OutputFile,' K.V.G.K. Rao, R.J. Oosterbaan, J. Boonstra,'+
                      ' H. Ramnandanlal, and R.A.L. Kselik,');
  writeln (OutputFile,' was regularly updated by R.J. Oosterbaan');
  writeln (OutputFile,' and he brought it from DOS to Windows.'+
                      ' Consult the manual.');
  writeln (OutputFile);
//Writing a header in the *.FRQ output file for the areal frequency
//distribution of salinity
  writeln (FrqFile);
  writeln (FrqFile,' SAHYSMOD: A predictive computation method for'+
                      ' soil and groundwater,');
  writeln (FrqFile,' salinity and the watertable depth'+
                      ' in agricultural lands using');
  writeln (FrqFile,' varying hydrologic conditions and'+
                      ' watermanagement options.');
  writeln (FrqFile,' The first version of the ILRI working group:');
  writeln (FrqFile,' K.V.G.K. Rao, R.J. Oosterbaan, J. Boonstra,'+
                      ' H. Ramnandanlal, and R.A.L. Kselik,');
  writeln (FrqFile,' was regularly updated by R.J. Oosterbaan');
  writeln (FrqFile,' and he brought it from DOS to Windows.'+
                      ' Consult the manual.');
  writeln (FrqFile,' This file is meant for spreadsheet use.');
  writeln (FrqFile);

  OutputFileName:=changefileext (SaveFileName,'.frq');
  writeln (FrqFile,' "Name of this file: ',OutputFileName);
  writeln (FrqFile);
  OutputFileName:=changefileext (SaveFileName,'.out');

//Writing a header in the *.GWT output file for the groundwater flow between
//nodes in terms of m3/season
  writeln (GwtFile);
  writeln (GwtFile,' SAHYSMOD: A predictive computation method for'+
                      ' soil and groundwater,');
  writeln (GwtFile,' salinity and the watertable depth'+
                      ' in agricultural lands using');
  writeln (GwtFile,' varying hydrologic conditions and'+
                      ' watermanagement options.');
  writeln (GwtFile,' The first version of the ILRI working group:');
  writeln (GwtFile,' K.V.G.K. Rao, R.J. Oosterbaan, J. Boonstra,'+
                      ' H. Ramnandanlal, and R.A.L. Kselik,');
  writeln (GwtFile,' was regularly updated by R.J. Oosterbaan');
  writeln (GwtFile,' and he brought it from DOS to Windows.'+
                      ' Consult the manual.');
  writeln (GwtFile,' This file is meant for spreadsheet use.');
  writeln (GwtFile);
  OutputFileName:=changefileext (SaveFileName,'.gwt');
  writeln (GwtFile,' "Name of this file: ',OutputFileName);
  OutputFileName:=changefileext (SaveFileName,'.out');
  writeln (GwtFile);

//Physical conditions and geohydrology
//Setting initial values of the rotation key
  for i:=1 to NrOfIntPoly do
  begin
    setlength (InitRota,i+1);
    InitRota[i]:=RotationType[i];
  end;
  if (YearNr<1) then
  begin
    Watch:=false;
    RotaPassed:=false;
  end;
//Set length reference values needed in procedure MainCalculations
//in unit UMainCalc
  setlength (AreaU,NrOfSeasons+1,NrOfIntPoly+1);
  setlength (Byp,NrOfSeasons+1,NrOfIntPoly+1);
  setlength (AA0,NrOfSeasons+1,NrOfIntPoly+1);
  setlength (BB0,NrOfSeasons+1,NrOfIntPoly+1);
  setlength (IRA0,NrOfSeasons+1,NrOfIntPoly+1);
  setlength (IRB0,NrOfSeasons+1,NrOfIntPoly+1);
  setlength (EpA0,NrOfSeasons+1,NrOfIntPoly+1);
  setlength (EpB0,NrOfSeasons+1,NrOfIntPoly+1);
  setlength (EpU0,NrOfSeasons+1,NrOfIntPoly+1);
  setlength (NextNode,TotNrOfPoly+1,8);
  setlength (NodalNr,TotNrOfPoly+1);
  setlength (SalY,NrOfIntPoly+1);
  setlength (SurfConc,NrOfIntPoly+1);
  setlength (StorWL,NrOfIntPoly+1);
  for i:=1 to TotNrOfPoly do NodalNr[i]:=NodeNr[i];
  for i:=1 to TotNrOfPoly do for j:=1 to NrOfSides[i] do
      NextNode[i,j]:=BorderNode[i,j];

//Setting permanent areas A, B and U, adjusting the rotation type
//and initial salinity accordingly
  AdjustRotation;

//Settings for groundwaterflow
  setlength (Qaq,NrOfIntPoly+1,8);                              {Aquifer flow}
  for i:=1 to NrOfExtPoly do for j:=1 to NrOfSeasons do
      WaterLevel[i+NrOfIntPoly]:=ExtWaterLevel[j,i];
  for i:=NrOfIntPoly+1 to TotNrOfPoly do
      AquiferType[i]:=0;                   {external aquifer types unconfined}
  for i:=1 to NrOfIntPoly do SALY[i]:=0;     {salt storage above soil surface}
  for i:=1 to NrOfIntPoly do SALY[i]:=0;     {salt storage above soil surface}

//The following comes from UDataTest, can be removed
//Setting real node numbers to serial node numbers
  for i:=1 to NrOfIntPoly do for j:=1 to NrOfSides[i] do
      BorderNode[i,j]:=Neighbor[j,i];
  for i:=1 to NrOfIntPoly do for j:=1 to NrOfSides[i] do        {then external}
      for k:=NrOfIntPoly+1 to TotNrOfPoly do
          if BorderNode[i,j]=k then
             BorderNode[k,j]:=i;

//Calculate groundwater flow
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfExtPoly do
        WaterLevel[i+NrOfIntPoly]:=ExtWaterLevel[j,i];
    for i:=1 to NrOfIntPoly do for k:=1 to NrOfSides[i] do Qaq[i,k]:=0;
    for i:=1 to NrOfIntPoly do GroundwaterFlow (i,j);
  end;

//Resetting serial node numbers to real node numbers
  for i:=1 to TotNrOfPoly do
  begin
    NodeNr[i]:=NodalNr[i];
    for j:=1 to NrOfSides[i] do
        BorderNode[i,j]:=NextNode[i,j];
  end;
//When warnings are given
  if Warning then
  begin
    //WarningForm.Visible:=true;
    Warning:=false;
  end;

end; {with DataMod do}
end; {procedure InitialActions}


procedure AdjustRotation;
var i, j : integer;
    HlpTxt1,HlpTxt2,HlpTxt3 : string;

begin with DataMod do
begin
//Repetition from procedure TestData in UDataTest, but required more often
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    Uarea:=1-AreaA[j,i]-AreaB[j,i];
    if j=1 then
    begin
      ACarea[i]:=AreaA[j,i];
      BCarea[i]:=AreaB[j,i];
      UCarea[i]:=Uarea;
    end else
    begin
      if AreaA[j,i]<ACArea[i] then ACarea[i]:=AreaA[j,i];
      if AreaB[j,i]<BCArea[i] then BCarea[i]:=AreaB[j,i];
      if Uarea<UCArea[i] then UCarea[i]:=Uarea;
    end;
  end;

  if AnnualCalc then
  For i:=1 to NrOfIntPoly do
  begin
     if DataMod.YearNr<2 then
        Rota0[i]:=RotationType[i];
     if DataMod.YearNr>1 then
        InitRota[i]:=Rota0[i];
  end;

//Setting safe rotation type
  for i:=1 to NrOfIntPoly do RotationType[i]:=4;
//Changing safe rotation type if possible when given rotation type is 0
  for i:=1 to NrOfIntPoly do if InitRota[i]=0 then
  begin
    if ACarea[i]+BCarea[i]+UCarea[i]>0.999 then RotationType[i]:=0;
    if ACarea[i]+BCarea[i]+UCarea[i]<1 then
    begin
      if UCarea[i]>0 then RotationType[i]:=1;
      if UCarea[i]<0.001 then
      begin
        if (ACarea[i]>0) and (ACarea[i]>=BCarea[i]) then RotationType[i]:=2;
        if (BCarea[i]>0) and (BCarea[i]>ACarea[i]) then RotationType[i]:=3;
      end;
    end;
  end;
//Changing safe rotation type if possible when given rotation type is 1
  for i:=1 to NrOfIntPoly do if InitRota[i]=1 then
  begin
    if UCarea[i]>0 then RotationType[i]:=1;
    if UCarea[i]<0.001 then
    begin
      if (ACarea[i]>0) and (ACarea[i]>=BCarea[i]) then RotationType[i]:=2;
      if (BCarea[i]>0) and (BCarea[i]>ACarea[i]) then RotationType[i]:=3;
    end;
  end;
//Changing safe rotation type if possible when given rotation type is 2
  for i:=1 to NrOfIntPoly do if InitRota[i]=2 then
  begin
    if ACarea[i]>0 then RotationType[i]:=2;
    if ACarea[i]<0.001 then
    begin
      if (UCarea[i]>0) and (UCarea[i]>=BCarea[i]) then RotationType[i]:=1;
      if (BCarea[i]>0) and (BCarea[i]>UCarea[i]) then RotationType[i]:=3;
    end;
  end;
//Changing safe rotation type if possible when given rotation type is 3
  for i:=1 to NrOfIntPoly do if InitRota[i]=3 then
  begin
    if BCarea[i]>0 then RotationType[i]:=3;
    if BCarea[i]<0.001 then
    begin
      if (UCarea[i]>0) and (UCarea[i]>=ACarea[i]) then RotationType[i]:=1;
      if (ACarea[i]>0) and (ACarea[i]>UCarea[i]) then RotationType[i]:=2;
    end;
  end;

  For i:=1 to NrOfIntPoly do
  begin
//When area reductions were made due to salinity
    if Watch and (UCarea[i]>0.001) then RotationType[i]:=1;
//Restoring rotation type when area reductions have been undone
    if (RotationType[i]=1) and (UCarea[i]<0.001) then
    begin
      Watch:=false;
      RotationType[i]:=InitRota[i];
    end;
//Restoring false settings
    if (RotationType[i]=2) and (ACarea[i]<0.001) then
        RotationType[i]:=InitRota[i];
    if (RotationType[i]=3) and (BCarea[i]<0.001) then
        RotationType[i]:=InitRota[i];
  end; {for i:=1 to NrOfIntPoly do}

  for i:=1 to NrOfIntPoly do
  if (YearNr=0) and (RotationType[i]<>InitRota[i]) then
  begin
    Warning:=true;
    HlpTxt1 := inttostr (i);
    HlpTxt2 := inttostr (InitRota[i]);
    HlpTxt3 := inttostr (RotationType[i]);
    //WarningForm.WarningMemo.Lines.Add ('');
    //WarningForm.WarningMemo.Lines.Add ('The initial rotation key Kr ='+HlpTxt2+
    //' in polygon '+HlpTxt1+' is changed into Kr = '+HlpTxt3);

  end;

//Setting initial values of soil salinities depending on rotation
  InitSalinity;
//Adjusting salinity settings in case of incomplete data input
  if not RotaPassed then for i:=1 to NrOfIntPoly do
  begin
    Uarea:=1-AreaA[1,i]-AreaB[1,i];        
    if (RotationType[i]=0) then
        if (ACarea[i]>=BCarea[i]) and (Uarea<0.001) then SCrU[i]:=SCrA[i];
    if (RotationType[i]=0) then
        if (ACarea[i]<BCarea[i]) and (Uarea<0.001) then SCrU[i]:=SCrB[i];
    if (RotationType[i]=1) then
        if (ACarea[i]>=BCarea[i]) and (Uarea<0.001) then SCrU[i]:=SCrA[i];
    if (RotationType[i]=1) then
        if (ACarea[i]<BCarea[i]) and (Uarea<0.001) then SCrU[i]:=SCrB[i];
  end;

end; {with DataMod do}
end; {procedure AdjustRotation}


procedure InitSalinity;
var i : integer;
    DA, DB, DU : real;
begin with DataMod do
begin
//This part is for salinity adjustment after change in permanent,
//not rotated area.
  for i:=1 to NrOfIntPoly do if ResponsIndex[i]=1 then
  begin
    DA:=ACarea[i]-ACParea[i];
    DB:=BCarea[i]-BCParea[i];
    DU:=UCarea[i]-UCParea[i];
    if RotationType[i]=1 then
    begin
      if DU>0 then
         SCrU[i]:=(UCParea[i]*SCrU[i]+DU*SCrA[i])/(UCParea[i]+DU);
      if DA>0 then
         SCrA[i]:=(ACParea[i]*SCrA[i]+DA*SCrU[i])/(ACParea[i]+DA);
    end;
    if RotationType[i]=2 then
    begin
      if DA>0 then
         SCrA[i]:=(ACParea[i]*SCrA[i]+DA*SCrB[i])/(ACParea[i]+DA);
      if DB>0 then
         SCrB[i]:=(BCParea[i]*SCrB[i]+DB*SCrA[i])/(BCParea[i]+DB);
    end;
    if RotationType[i]=3 then
    begin
      if DB>0 then
          SCrB[i]:=(BCParea[i]*SCrB[i]+DB*SCrA[i])/(BCParea[i]+DB);
      if DA>0 then
          SCrA[i]:=(ACParea[i]*SCrA[i]+DA*SCrB[i])/(ACParea[i]+DA);
    end;
  end; {for i:=1 to NrOfIntPoly do if ResponsIndex[i]=1 then}

//Setting initial values of soil salnity depending on rotation type
  for i:=1 to NrOfIntPoly do
  begin
//for certainty
    if (ResponsIndex[i]=1) and (SCrU[i]<=0) then SCrU[i]:=SCrA[i];
    if (ResponsIndex[i]=2) and (SCrB[i]<=0) then SCrB[i]:=SCrA[i];
    if (ResponsIndex[i]=3) and (SCrA[i]<=0) then SCrA[i]:=SCrB[i];

    Uarea:=1-AreaA[1,i]-AreaB[1,i];               
    if (YearNr<1) and (ResponsIndex[i]=0) then
//Is it not necessary to do the following every year in case of annual calc?
    begin
      if (RotationType[i]=1) then
         if (Uarea>0.999) then                 
            SCrA[i]:=SCrU[i]
         else
            SCrA[i]:=(AreaA[1,i]*ScrA[i]+AreaB[1,i]*SCrB[i])/(1-Uarea);
      if (RotationType[i]=2) then
         if (AreaA[1,i]>0.999) then
            SCrB[i]:=SCrA[i]
         else
            SCrB[i]:=(AreaB[1,i]*ScrB[i]+Uarea*SCrU[i])/(1-AreaA[1,i]);
      if (RotationType[i]=3) then
         if (AreaB[1,i]>0.999) then
            SCrA[i]:=SCrB[i]
        else
            SCrA[i]:=(AreaA[1,i]*ScrA[i]+Uarea*SCrU[i])/(1-AreaB[1,i]);
      if RotationType[i]=4 then
         SCrA[i]:=AreaA[1,i]*SCrA[i]+AreaB[1,i]*SCrB[i]+Uarea*SCrU[i];
    end;
  end; {for i:=1 to NrOfIntPoly do}

//Setting en values of permanent (not rotated) area fractions
//to check for change later
  for i:=1 to NrOfIntPoly do
  begin
    ACParea[i]:=ACarea[i];
    BCParea[i]:=BCarea[i];
    UCParea[i]:=BCarea[i];
  end;

end; {with DataMod do}
end; {procedure InitSalinity}


procedure GroundwaterFlow (i, j : integer);
var k, Nod, M                                            : integer;
    Condu, Daq1, Dtr1, Ltop1,
    Ltr2, Aqu2, Daq2, Dtr2, Ltop2, Dtr, Daq, Qaqu, Qtop,
    GtopIn, GtopOut,GaquIn, GaquOut, WLi, WLn            : real;
    SCtrI, SCtlI, LEtrI, SalTopIn, LEaqI, SalAquIn       : real;
begin
  with DataMod do
  begin

//STARTING THE GROUNDWATER FLOW CALCULATIONS
//Initial setting for summation
    HIGD:=0;       {total horiz. incoming groundwater through aquifer per node}
    HOGD:=0;       {total horiz. outgoing groundwater through aquifer per node}
    SGID:=0;                       {total horiz. incoming salt through aquifer}
    HITD:=0;        {total horiz. incoming groundwater through transition zone}
    HOTD:=0;        {total horiz. outgoing groundwater through transition zone}
    STID:=0;                {total horiz. incoming salt through transition zone}
//Determining flow thickness in transition zone and aquifer of the internal node
    Ltr1:=SurfLevel[i]-RootZone[i]-TranZone[i];      {level bottom trans. zone}
    Aqu1:=Ltr1-BottomLevel[i];                              {thickness aquifer}
    Daq1:=Aqu1;
    if AquiferType[i]=0 then                                 {phreatic aquifer}
    begin
      Dtr1:=WaterLevel[i]-Ltr1;                 {flow thickness in trans. zone}
      if WaterLevel[i]>SurfLevel[i] then                     {water on surface}
         Dtr1:=SurfLevel[i]-Ltr1;
      if WaterLevel[i]<Ltr1 then                      {water below trans. zone}
         Daq1:=Waterlevel[i]-BottomLevel[i];
    end else                                     {semi confined (s.c.) aquifer}
    begin
      Ltop1:=SurfLevel[i]-Toplayer[i];                   {top level s.c. layer}
      Dtr1:=WaterLEvel[i]-Ltop1;          {thickness tr. zone above s.c. layer}
      if WaterLevel[i]>SurfLevel[i] then                     {water on surface}
         Dtr1:=SurfLevel[i]-Ltr1;
      Dsc1:=Ltop1-Ltr1;                            {thickness semi conf. layer}
      if WaterLevel[i]<Ltr1 then                      {water below trans. zone}
         Daq1:=WaterPress[i]-BottomLevel[i];
    end; {if AquiferType[i]=0 then else ..}

//Determining flow depth in trans. zone and aquifer of neighour node (Nod)
    for k:=1 to NrOfSides[i] do
    begin
//      Nod:=BorderNode[i,k];                                {neighbour node nr.}
      Nod:=SerialNodeNr[NextNode[i,k]];                  {neighbour node nr.}
      if Nod<=NrOfIntPoly then                             {internal neighbour}
      begin
        Ltr2:=SurfLevel[Nod]-RootZone[Nod]-TranZone[Nod]; {level bottom TRzone}
        Aqu2:=Ltr2-BottomLevel[Nod];                     {thickness of aquifer}
        Daq2:=Aqu2;                                 {flow thickness in aquifer}
        if AquiferType[i]=0 then                             {phreatic aquifer}
        begin
          Dtr2:=WaterLevel[Nod]-Ltr2;           {flow thickness in trans. zone}
          if WaterLevel[Nod]>SurfLevel[Nod] then             {water on surface}
             Dtr2:=SurfLevel[Nod]-Ltr2;
          if WaterLevel[Nod]<Ltr2 then                {water below trans. zone}
             Daq2:=Waterlevel[Nod]-BottomLevel[Nod];
        end else                                 {semi confined (s.c.) aquifer}
        begin
          Ltop2:=SurfLevel[Nod]-Toplayer[Nod];           {top level s.c. layer}
          Dtr2:=WaterLevel[Nod]-Ltop2;    {thickness tr. zone above s.c. layer}
          if WaterLevel[Nod]>SurfLevel[Nod] then             {water on surface}
             Dtr2:=SurfLevel[Nod]-Ltr2;
          if WaterLevel[Nod]<Ltr2 then                {water below trans. zone}
             Daq2:=WaterLevel[Nod]-BottomLevel[Nod];
        end; {if AquiferType[i]=0 then else ..}
      end else                                        {if Nod>NrOfIntPoly then}
      begin
        Ltr2:=BottomLevel[Nod]+Aqu1;                 {level bottom trans. zone}
        Dtr2:=WaterLevel[Nod]-Ltr2;                  {thickness of trans. zone}
        Daq2:=Aqu1;                                 {flow thickness in aquifer}
        if Dtr2<0 then
           Daq2:=WaterLevel[Nod]-BottomLevel[Nod];
        if WaterLevel[Nod]>SurfLevel[i] then                 {water on surface}
           Dtr2:=SurfLevel[i]-Ltr2;
        if WaterLevel[Nod]<Ltr2 then                  {water below trans. zone}
           Daq2:=WaterLevel[Nod]-BottomLevel[Nod];
      end; {if Nod<=NrOfIntPloy then else ..}
      if Dtr1<0 then Dtr1:=0;
      if Dtr2<0 then Dtr2:=0;
//Average flow thickness between two nodes
      Dtr:=0.5*(Dtr1+Dtr2);                                       {trans. zone}
      Daq:=0.5*(Daq1+Daq2);                                       {aquifer}
//Flow in aquifer to or from a neighbor
      Qaqu:=0;
      if (AquiferType[i]=0) and (AquiferType[Nod]=0) then
         Qaqu:=Conduct[k,i]*Daq*(WaterLevel[Nod]-WaterLevel[i]);
      if (AquiferType[i]=1) and (AquiferType[Nod]=1) then
         Qaqu:=Conduct[k,i]*Daq*(WaterPress[Nod]-WaterPress[i]);
      if (AquiferType[i]=1) and (AquiferType[Nod]=0) then
         Qaqu:=Conduct[k,i]*Daq*(WaterPress[Nod]-WaterLevel[i]);
      if (AquiferType[i]=0) and (AquiferType[Nod]=1) then
         Qaqu:=Conduct[k,i]*Daq*(WaterLevel[Nod]-WaterPress[i]);
//Flow in trans. zone to or from a neighbor
      WLi:=WaterLevel[i];
      WLn:=WaterLevel[Nod];
      if AquiferType[i]= 0 then
         Qtop:=Conduct[k,i]*Dtr*(WLn-WLi)
      else
         Qtop:=TopCond[k,i]*Dtr*(WLn-WLi);
      if Dtr<0 then Qtop:=0;
//Flow through each polygonal side from internal node to neighbor
      Qaq[i,k]:=Qaq[i,k]+Qtop+Qaqu;                     //in m3/season
//Incoming/outgoing flow im m3/season
      if WaterLevel[Nod]>WaterLevel[i] then
      begin
        GtopIn:=Qtop/SurfArea[i];                       {Gtop: transition zone}
        GtopOut:=0;
        if Nod<=NrOfIntPoly then
        begin
          SCtrI:=SCtr[Nod];
          SCtlI:=SCtl[Nod];
          LEtrI:=LeachEffTr[Nod];
        end else
        begin
          SCtrI:=SCaq[Nod];
          SCtlI:=SCaq[Nod];
          LEtrI:=1;
        end;
        if DrainIndex[i]=0 then
           SalTopIn:=GtopIn*SCtrI*LEtrI
        else
           SalTopIn:=GtopIn*SCtlI*LEtrI;
      end                               {if WaterLevel[Nod]>WaterLevel[i]}
      else
      begin
        GtopOut:=-Qtop/SurfArea[i];
        GtopIn:=0;
        SalTopIn:=0;
      end;                 {if WaterLevel[Nod]>WaterLevel[i] then ... else ...}
      WLi:=WaterLevel[i];
      WLn:=WaterLevel[Nod];
      if AquiferType[i]=1 then WLi:=WaterPress[i];
      if AquiferType[Nod]=1 then WLn:=WaterPress[Nod];
      if WLn>WLi then
      begin
        GaquIn:=Qaqu/SurfArea[i];                               {Gaqu: aquifer}
        GaquOut:=0;
        if Nod>NrOfIntPoly then LeachEffAq[Nod]:=LeachEffAq[i];
        LEaqI:=LeachEffAq[Nod];
        if Nod>NrOfIntPoly then LEaqI:=1;
        SalAquIn:=GaquIn*SCaq[Nod]*LEaqI;
      end else
      begin
        GaquOut:=-Qaqu/SurfArea[i];
        GaquIn:=0;
        SalAquIn:=0;
      end;
//Summation of incoming and outgoing flows                       {in m3/season}
      HITD:=HITD+GtopIn;                   {incoming water through trans. zone}
      HOTD:=HOTD+GtopOut;                  {outgoing water through trans. zone}
      HIGD:=HIGD+GaquIn;                       {incoming water through aquifer}
      HOGD:=HOGD+GaquOut;                      {outgoing water through aquifer}
      STID:=STID+SalTopIn;                  {incoming salt through trans. zone}
      SGID:=SGID+SalAquIn;                      {incoming salt through aquifer}
    end; {for k:=1 to NrOfSides[i] do}
    if YearNr<1 then
    begin
//Conversion of daily into seasonal flows in year 0
      HITD:=HITD*30*SeasonDuration[j];
      HOTD:=HOTD*30*SeasonDuration[j];
      HIGD:=HIGD*30*SeasonDuration[j];
      HOGD:=HOGD*30*SeasonDuration[j];
//In other years the following procedures are used separately
      Warning:=false;
      DWT:=SurfLevel[i]-WaterLevel[i];
      DWT0:=DWT;
      RootzoneHydrology (i,j);
      M:=0;
      WriteOutput (i,j,m);
      WriteFrequency (i,j,m);
      WriteGwtFile (i,j,m);
    end; {if YearNr<1 then}
  end; {with DataMod do}
end; {procedure GroundwaterFlow}


procedure RootzoneHydrology (i, j : integer);
var CDWR, ES {, SstA, SstB, SstU, SstT } : real;
    SeasonTxt, PolyTxt :string;
begin with DataMod do
begin
//Initial Settings
  if YearNr<1 then
  begin
    IRA0[j,i]:=IrrA[j,i];
    IRB0[j,i]:=IrrB[j,i];
    AA0[j,i]:=AreaA[j,i];
    BB0[j,i]:=AreaB[j,i];
    EpA0[j,i]:=EvapA[j,i];
    EpB0[j,i]:=EvapB[j,i];
    EpU0[j,i]:=EvapU[j,i];
    setlength (Dw0,i+1);
    BYP[j,i]:=0;
    Rech:=0;
  end;
  Zir:=IrrSal[j,i];
  Zit:=SCtr[i];
  Zig:=SCaq[i];
  Zdr:=SCtr[i];
  Zwell:=SCaq[i];
//Setting depth of the watertable
  Dw0[i]:=DWT;                                            {required for checks}
//Choosing factor ZZ in dependance of DWT and CDW for determining
//capillary rise and adjustment of surface runoff
  CDWR:=CritDepth[i]-0.5*Rootzone[i];
  if CDWR<=0 then
     ZZ:=0
  else
  begin
    ZZ:=(CritDepth[i]-DWT)/CDWR;
    if ZZ<0 then ZZ:=0;
    if ZZ>1 then ZZ:=1;
  end;
//Determining act. evapotr. and cap. rise in irrigated A land
  CAA:=0;
  EvapA[j,i]:=EpA0[j,i];
  if AreaA[j,i]>0 then
  begin
    ES:=Rain[j,i]+IrrA[j,i]-SurfDrA[j,i];
    if ES<EvapA[j,i]/StoEffA[j,i] then
    begin
//      EvapA[j,i]:=StoEffA[j,i]*ES+ZZ*(EvapA[j,i]-StoEffA[j,i]*ES);
      EvapA[j,i]:=StoEffA[j,i]*ES+ZZ*(EpA0[j,i]-StoEffA[j,i]*ES);
      CAA:=EvapA[j,i]-ES;
      if CAA<0 then
      begin
        CAA:=0;
//        EvapA[j,i]:=EpA0[j,i];
      end;
    end;
  end;
//Determining act. evapotr. and cap. rise in irrigated B land
  CAB:=0;
  EvapB[j,i]:=EpB0[j,i];
  if AreaB[j,i]>0 then
  begin
    ES:=Rain[j,i]+IrrB[j,i]-SurfDrB[j,i];
    if ES<EvapB[j,i]/StoEffB[j,i] then
    begin
//      EvapB[j,i]:=StoEffB[j,i]*ES+ZZ*(EvapB[j,i]-StoEffB[j,i]*ES);
      EvapB[j,i]:=StoEffB[j,i]*ES+ZZ*(EpB0[j,i]-StoEffB[j,i]*ES);
      CAB:=EvapB[j,i]-ES;
      if CAB<0 then
      begin
        CAB:=0;
//        EvapB[j,i]:=EpB0[j,i];
      end;
    end;
  end;
//Determining act. evapotr. and cap. rise in unirrigated U land
  AreaU[j,i]:=1-AreaA[j,i]-AreaB[j,i];
  CAU:=0;
  if (SCRU[i]>16) then EpU0[j,i]:=4*EpU0[j,i]/sqrt(SCRU[i]);
  EvapU[j,i]:=EpU0[j,i];
  if AreaU[j,i]>0 then
  begin
    ES:=Rain[j,i]+SurfInflow[j,i]-SurfOutFlow[j,i];
    if ES<EvapU[j,i]/StoEffU[j,i] then
    begin
//      EvapU[j,i]:=StoEffU[j,i]*ES+ZZ*(EvapU[j,i]-StoEffU[j,i]*ES);
      EvapU[j,i]:=StoEffU[j,i]*ES+ZZ*(EpU0[j,i]-StoEffU[j,i]*ES);
      CAU:=EvapU[j,i]-ES;
      if CAU<0 then
      begin
        CAU:=0;
//        EvapU[j,i]:=EpU0[j,i];
      end;
    end;
  end;
//Reducing percolation losses from the canals when watertable is shallow
  PLC:=PercLoss[j,i];
  IF AreaU[j,i]>0.999 then PLC:=0;
  PLCC:=PLC;
  IF DWT<RootZone[i] then PLCC:=0.5*PLC;
//  SstA:=0;
//  SstB:=0;
//  SstU:=0;
  IF DWT<0 then
  begin
    PLCC:=0;
//    SstA:=Rain[j,i]+IrrA[j,i]-EvapA[j,i]-SurfDrA[j,i];
//    SstB:=Rain[j,i]+IrrB[j,i]-EvapB[j,i]-SurfDrB[j,i];
//    SstU:=Rain[j,i]-EvapU[j,i]+SurfInflow[j,i]-SurfOutFlow[j,i];
  end;
//Percolation losses in irrigated A fields
  PLA:=Rain[j,i]+IrrA[j,i]{-SstA}-EvapA[j,i]-SurfDrA[j,i];
  if AreaA[j,i]<0.001 then
  begin
    CAA:=0;
    PLA:=0;
    IrrA[j,i]:=0;
    EvapA[j,i]:=0;
  end;
//Percolation losses in irrigated B fields
  PLB:=Rain[j,i]+IrrB[j,i] {-SstB} -EvapB[j,i]-SurfDrB[j,i];
  if AreaB[j,i]<0.001 then
  begin
    CAB:=0;
    PLB:=0;
    IrrB[j,i]:=0;
    EvapB[j,i]:=0;
  end;
//Percolation losses in unirrigated U fields
  PLU:=Rain[j,i] {-SstU} +SurfInflow[j,i]-EvapU[j,i]-SurfOutFlow[j,i];
  if AreaU[j,i]<0.001 then
  begin
    CAU:=0;
    PLU:=0;
    EvapU[j,i]:=0;
  end;
//Total amount of canal irrigation water including re-use
  CIT:=PLCC+IrrA[j,i]*AreaA[j,i]+IrrB[j,i]*AreaB[j,i];
//Canal water excluding re-use
  if ReUseDr[j,i]<0 then ReUseDr[j,i]:=0;
  if ReUseWell[j,i]<0 then ReUseWell[j,i]:=0;
  CIR:=CIT-ReuseDr[j,i]-ReUseWell[j,i]*WellDis[j,i];
  if (CIR<0) and (YearNr<1) then
  begin
    Warning:=true;
    PolyTxt := inttostr (i);
    SeasonTxt := inttostr (j);
    PolyTxt := ' The field irrigation IRa or IRb in node '+Polytxt;
    SeasonTxt := ' in season ' +SeasonTxt+' does not incorporate all drain or'+
      ' well water used  for irrigation';
    //WarningForm.WarningMemo.Lines.Add ('');
    //WarningForm.WarningMemo.Lines.Add (PolyTxt+SeasonTxt);
    SeasonTxt := '   The excess is added to the bypass (Io).';
    //WarningForm.WarningMemo.Lines.Add (SeasonTxt);
    Byp[j,i]:=Byp[j,i]-CIR;
    CIR:=0;
  end;
//Determining net values of percolation and capillary rise
  if CAA>=PLA then
  begin
    CAA:=CAA-PLA;
    PLA:=0;
  end else
  begin
    PLA:=PLA-CAA;
    CAA:=0;
  end;
  if CAB>=PLB then
  begin
    CAB:=CAB-PLB;
    PLB:=0;
  end else
  begin
    PLB:=PLB-CAB;
    CAB:=0;
  end;
  if CAU>=PLU then
  begin
    CAU:=CAU-PLU;
    PLU:=0;
  end else
  begin
    PLU:=PLU-CAU;
    CAU:=0;
  end;
  CAT:=CAA*AreaA[j,i]+CAB*AreaB[j,i]+CAU*AreaU[j,i];
  PLT:=PLA*AreaA[j,i]+PLB*AreaB[j,i]+PLU*AreaU[j,i];
//  SstT:=SstA*AreaA[j,i]+SstB*AreaB[j,i]+SstU*AreaU[j,i];
  Rech:=PLCC+PLT{-SstT}-CaT-DrT;

  if DWT<0 then   {necessary for salt balances}
  begin
    PLA:=0;
    PLB:=0;
    PLU:=0;
    PLT:=0;
    CAA:=0;
    CAB:=0;
    CAU:=0;
    CAT:=0;
  end;
  if PLA<0 then PLA:=0;
  if PLB<0 then PLB:=0;
  if PLU<0 then PLU:=0;
  if PLT<0 then PLT:=0;
  if CAA<0 then CAA:=0;
  if CAB<0 then CAB:=0;
  if CAU<0 then CAU:=0;
  if CAT<0 then CAT:=0;

  if YearNr<1 then
  begin
    DrainDischarge (i,j);
    IrrEff_Suff (i, j);
  end; {if YearNr<1 then}

end; {with DataMod do}
end; {procedure RootzoneHydrology}


procedure DrainDischarge (i, j : integer);
begin with DataMod do
begin
//Determining the subsurface drainage
  if (DrainDepth[i]-DWT<=0) or (DrainIndex[i]=0) then
  begin
    DRA:=0;
    DRB:=0;
    DRT:=0;
  end;
  if (DrainDepth[i]-DWT>0) and (DrainIndex[i]=1) then
  begin
    DRA:=(1-WTcontrol[j,i])*ReactAbove[i]*sqr(DrainDepth[i]-DWT);
    DRB:=(1-WTcontrol[j,i])*ReactBelow[i]*(DrainDepth[i]-DWT);
    DRT:=DRA+DRB;
  end;
end; {with DataMod do}
end; {procedure DrainDischarge}


procedure IrrEff_Suff (i, j : integer);
begin with DataMod do
begin
//Field irrigation efficiencies in A lands
    if IrrA[j,i]<>0 then EFA:=(EvapA[j,i]-CAA)/(IrrA[j,i]+Rain[j,i]);
    if IrrA[j,i]*AreaA[j,i]=0 then EFA:=0;
    if EFA>1 then EFA:=1;
//Field irrigation efficiencies in B lands
    if IrrB[j,i]<>0 then EFB:=(EvapB[j,i]-CAB)/(IrrB[j,i]+Rain[j,i]);
    if IrrB[j,i]*AreaB[j,i]=0 then EFB:=0;
    if EFB>1 then EFB:=1;
//Total irrigation efficiency
    EFT:=0;
    if CIT>0.001 then
       EFT:=((EvapA[j,i]-CAA)*AreaA[j,i]+(EvapB[j,i]-CAB)*AreaB[j,i])/(CIT+Rain[j,i]);
    if EFT>1 then EFT:=1;
    if  IrrA[j,i]+IrrB[j,i]=0 then EFT:=0;
//Sufficiency of irrigation water in A land
    SUA:=0;
    if (EvapA[j,i]>0.001) and (EvapA[j,i]>0.001) then
        SUA:=EvapA[j,i]/EpA0[j,i];
	  if IrrA[j,i]=0 then SUA:=0;
//Sufficiency of irrigation water in B land
    SUB:=0;
    if (EvapB[j,i]>0.001) and (EvapB[j,i]>0.001) then
        SUB:=EvapB[j,i]/EpB0[j,i];
	  if IrrB[j,i]=0 then SUB:=0;
  end; {with DataMod do}
end; {procedure IrrEff_Suff (i, j)}


procedure WriteOutput (i, j, m : integer);
var Year : integer; //Later this will be defined in the all calculations program
    AIR, BIR, QQN, GQN : real;
begin
with DataMod do
begin

//WRITING RESULTS WITH THE GIVEN TIMESTEP
  Year:=m;
  if AnnualCalc then Year:=YearNr;
//Writing year and season in the output file
  OutputFileName:=ChangeFileExt (SaveFileName,'.out');
  writeln (OutputFile,'  YEAR:  ',Year:5,'    Name of output file:   ',
                      OutputFileName);
  writeln (OutputFile,'  ************');
  writeln (OutputFile,'  Season: ',j:4,'    Duration: ',SeasonDuration[j]:6:1,
                      '  months.');
  writeln (OutputFile,'  ************');
  writeln (OutputFile,'  Polygon: ',NodeNr[i]:3,'    X (cm): ',Xcoord[i]:8:3,
                      '      Y (cm): ',Ycoord[i]:8:3);
  writeln (OutputFile,'                                    ',' Area (m2): ',
                      SurfArea[i]:10:3);
//Irrigation output
  AIR:=IrrA[j,i];
  BIR:=IrrB[j,i];
  if AreaA[j,i]<0.001 then AIR:=0;
  if AreaB[j,i]<0.001 then BIR:=0;
  if AIR+BIR<0.001 then CIT:=0;
  if AIR+BIR<0.001 then CIR:=0;
  if (AreaA[j,i]>0) and (AreaB[j,i]>0) then
     writeln (OutputFile,'  It  = ',format('%10.3e',[CIT]),'    Is  = ',
               format('%10.3e',[CIR]),'    IaA = ',format('%10.3e',[AIR]),
               '    IaB = ',format('%10.3e',[BIR]));
  if (AreaA[j,i]>0) and (AreaB[j,i]<0.001) then
      Writeln (OutputFile,'  It  = ',format('%10.3e',[CIT]),'    Is  = ',
               format('%10.3e',[CIR]),'    IaA = ',format('%10.3e',[AIR]),
               '    IaB = ','     -    ');
  if (AreaA[j,i]<0.001) and (AreaB[j,i]>0) then
      Writeln (OutputFile,'  It  = ',format('%10.3e',[CIT]),'    Is  = ',
               format('%10.3e',[CIR]),'    IaA = ','     -    ',
               '    IaB = ',format('%10.3e',[BIR]));
  if (AreaA[j,i]<0.001) and (AreaB[j,i]<0.001) then
      Writeln (OutputFile,'  It  = ','     -    ','    Is  = ',
               '     -    ','    IaA = ','     -    ',
               '    IaB = ','     -    ');
//Efficiencies and sufficiencies
  if (AreaA[j,i]>0) and (AreaB[j,i]>0) then
  begin
    Writeln (OutputFile,'  FfA = ',format('%10.3e',[EFA]),'    FfB = ',
             format('%10.3e',[EFB]),'    FfT = ',format('%10.3e',[EFT]),
             '    Io  = ',format('%10.3e',[BYP[j,i]]));
    if AreaU[j,i]>0.001 then
       Writeln (OutputFile,'  FfA = ',format('%10.3e',[EFA]),'    FfB = ',
                format('%10.3e',[EFB]),'    FfT = ',format('%10.3e',[EFT]),
                '    Io  = ',format('%10.3e',[BYP[j,i]]))
    else
       Writeln (OutputFile,'  JsA = ',format('%10.3e',[SUA]),'    JsB = ',
                format('%10.3e',[SUB]),'    EaU = ','     -    ');
  end;
  if (AreaA[j,i]>0) and (AreaB[j,i]<0.001) then
  begin
      Writeln (OutputFile,'  FfA = ',format('%10.3e',[EFA]),'    FfB = ',
               '     -    ','    FfT = ',format('%10.3e',[EFT]),
               '    Io  = ',format('%10.3e',[BYP[j,i]]));
      if AreaU[j,i]>0.001 then
         Writeln (OutputFile,'  JsA = ',format('%10.3e',[SUA]),'    JsB = ',
                  '     -    ','    EaU = ',format('%10.3e',[EvapU[j,i]]))
      else
         Writeln (OutputFile,'  JsA = ',format('%10.3e',[SUA]),'    JsB = ',
                  '     -    ','    EaU = ','     -    ');
  end;
  if (AreaA[j,i]<0.001) and (AreaB[j,i]>0.001) then
  begin
    Writeln (OutputFile,'  FfA = ','     -    ','    FfB = ',
             format('%10.3e',[EFB]),'    FfT = ',format('%10.3e',[EFT]),
             '    Io  = ',format('%10.3e',[BYP[j,i]]));
    if AreaU[j,i]>0.001 then
       Writeln (OutputFile,'  JsA = ','     -    ','    JsB = ',
                format('%10.3e',[SUB]),'    EaU = ',format('%10.3e',[EvapU[j,i]]))
    else
       Writeln (OutputFile,'  JsA = ','     -    ','    JsB = ',
                format('%10.3e',[SUB]),'    EaU = ','     -    ');
  end;
  if (AreaA[j,i]<0.001) and (AreaB[j,i]<0.001) then
  begin
      Writeln (OutputFile,'  FfA = ','     -    ','    FfB = ',
               '     -    ','    FfT = ','     -    ',
               '    Io  = ',format('%10.3e',[BYP[j,i]]));
      Writeln (OutputFile,'  JsA = ','     -    ','    JsB = ',
               '     -    ','    EaU = ',format('%10.3e',[EvapU[j,i]]));
  end;
//Percolation and Capillary rise
  if AreaU[j,i]>0.001 then
  begin
    if (AreaA[j,i]>0) and (AreaB[j,i]>0) then
    begin
      Writeln (OutputFile,'  LrA = ',format('%10.3e',[PLA]),'    LrB = ',
               format('%10.3e',[PLB]),'    LrU = ',format('%10.3e',[PLU]),
               '    LrT = ',format('%10.3e',[PLT]));
      Writeln (OutputFile,'  RrA = ',format('%10.3e',[CAA]),'    RrB = ',
               format('%10.3e',[CAB]),'    RrU = ',format('%10.3e',[CAU]),
               '    RrT = ',format('%10.3e',[CAT]));
    end;
    if (AreaA[j,i]>0) and (AreaB[j,i]<0.001) then
    begin
      Writeln (OutputFile,'  LrA = ',format('%10.3e',[PLA]),'    LRB = ',
               '     -    ','    LrU = ',format('%10.3e',[PLU]),
               '    RrT = ',format('%10.3e',[PLT]));
      Writeln (OutputFile,'  RrA = ',format('%10.3e',[CAA]),'    RrB = ',
               '     -    ','    RrU = ',format('%10.3e',[CAU]),
               '    RrT = ',format('%10.3e',[CAT]));
    end;
    if (AreaA[j,i]<0.001) and (AreaB[j,i]>0.001) then
    begin
     writeln (OutputFile,'  LrA = ','     -    ','    LrB = ',PLB:10:3,
                         '    LrU = ',PLU:10:3,'    LrT = ',PLT:10:3);
     writeln (OutputFile,'  RrA = ','     -    ','    RrB = ',CAB:10:3,
                         '    RrU = ',CAU:10:3,'    RrT = ',CAT:10:3);
    end;
    if (AreaA[j,i]<0.001) and (AreaB[j,i]<0.001) then
    begin
      Writeln (OutputFile,'  LrA = ','     -    ','    LRB = ',
               '     -    ','    LrU = ',format('%10.3e',[PLU]),
               '    RrT = ',format('%10.3e',[PLT]));
      Writeln (OutputFile,'  RrA = ','     -    ','    RrB = ',
               '     -    ','    RrU = ',format('%10.3e',[CAU]),
               '    RrT = ',format('%10.3e',[CAT]));
    end;
  end else
  begin
    if (AreaA[j,i]>0) and (AreaB[j,i]>0) then
    begin
      Writeln (OutputFile,'  LrA = ',format('%10.3e',[PLA]),'    LrB = ',
               format('%10.3e',[PLB]),'    LrU = ','     -    ',
               '    LrT = ',format('%10.3e',[PLT]));
      Writeln (OutputFile,'  RrA = ',format('%10.3e',[CAA]),'    RrB = ',
               format('%10.3e',[CAB]),'    RrU = ','     -    ',
               '    RrT = ',format('%10.3e',[CAT]));
    end;
    if (AreaA[j,i]>0) and (AreaB[j,i]<0.001) then
    begin
      Writeln (OutputFile,'  LrA = ',format('%10.3e',[PLA]),'    LrB = ',
               '     -    ','    LrU = ','     -    ',
               '    LrT = ',format('%10.3e',[PLT]));
      Writeln (OutputFile,'  RrA = ',format('%10.3e',[CAA]),'    RrB = ',
               '     -    ','    RrU = ','     -    ',
               '    RrT = ',format('%10.3e',[CAT]));
    end;
    if (AreaA[j,i]<0.001) and (AreaB[j,i]>0.001) then
    begin
      Writeln (OutputFile,'  LrA = ','     -    ','    LRB = ',
               format('%10.3e',[PLB]),'    LrU = ','     -    ',
               '    RrT = ',format('%10.3e',[PLT]));
      Writeln (OutputFile,'  RrA = ','     -    ','    RrB = ',
               format('%10.3e',[CAB]),'    RrU = ','     -    ',
               '    RrT = ',format('%10.3e',[CAT]));
    end;

  end; {if AreaU[j,i]>0.001 then else ...}
//Groundwater inflow and outflow, net percolation and
//net recharge to the aquifer (m/season)
  QQN:=HIGD-HOGD-WellDis[j,i];
  GQN:=QQN+HITD-HOTD-DRT;
  writeln (OutputFile,'  Gti = ',format('%10.3e',[HITD]),
  '    Gto = ',format('%10.3e',[HOTD]),'    Qv  = ',format('%10.3e',[Rech]));
  writeln (OutputFile,'  Gqi = ',format('%10.3e',[HIGD]),
  '    Gqo = ',format('%10.3e',[HOGD]),'    Gaq = ',format('%10.3e',[QQN]),
  '    Gnt = ',format('%10.3e',[GQN]));
//Drain and well discharge
  if DrainIndex[i]=1 then
     writeln (OutputFile,'  Gd  = ',format('%10.3e',[DRT]),
     '    Ga  = ',format('%10.3e',[DRA]),
     '    Gb  = ',format('%10.3e',[DRB]),
     '    Gw  = ',format('%10.3e',[WellDis[j,i]]))
  else
     writeln (OutputFile,'  Gd  = ','     -    ','    Ga  = ','     -    ',
                         '    Gb  = ','     -    ',
                         '    Gw = ',format('%10.3e',[WellDis[j,i]]));
//Depth/height of watertable
  if AquiferTYpe[i]=1 then
     writeln (OutputFile,'  Dw  = ',format('%10.3e',[DWT]),
     '    Hw  = ',format('%10.3e',[WaterLevel[i]]),
     '    Hq  = ',format('%10.3e',[WaterPress[i]]))
  else
     writeln (OutputFile,'  Dw  = ',format('%10.3e',[DWT]),
     '    Hw  = ',format('%10.3e',[WaterLevel[i]]),
     '    Hq  = ','     -    ');
  if SalY[i]<=0 then
     writeln (OutputFile,'  Sto = ','     -    ','    Zs  = ','     -    ')
  else
     writeln (OutputFile,'  Sto = ',format('%10.3e',[StorWL[i]]),
                         '    Zs  = ',format('%10.3e',[SalY[i]]));

//Areas
  if AreaU[j,i]<0.01 then AreaU[j,i]:=0;
  if (AreaA[j,i]>0) and (AreaB[j,i]>0) and (AreaU[j,i]>0) then
  writeln (OutputFile,'  A   = ',format('%10.3e',[AreaA[j,i]]),
  '    B   = ',format('%10.3e',[AreaB[j,i]]),
  '    U   = ',format('%10.3e',[AreaU[j,i]]));
  if (AreaA[j,i]>0) and (AreaB[j,i]>0) and (AreaU[j,i]<0.001) then
  writeln (OutputFile,'  A   = ',format('%10.3e',[AreaA[j,i]]),
  '    B   = ',format('%10.3e',[AreaB[j,i]]),'    U   = ','     -    ');
  if (AreaA[j,i]>0) and (AreaB[j,i]<0.001) and (AreaU[j,i]>0) then
  writeln (OutputFile,'  A   = ',format('%10.3e',[AreaA[j,i]]),
  '    B   = ','     -    ','    U   = ',format('%10.3e',[AreaU[j,i]]));
  if (AreaA[j,i]>0) and (AreaB[j,i]<0.001) and (AreaU[j,i]<0.001) then
  writeln (OutputFile,'  A   = ',format('%10.3e',[AreaA[j,i]]),
  '    B   = ','     -    ','    U   = ','     -    ');
  if (AreaA[j,i]<0.001) and (AreaB[j,i]>0) and (AreaU[j,i]>0) then
  writeln (OutputFile,'  A   = ','     -    ',
  '    B   = ',format('%10.3e',[AreaB[j,i]]),
  '    U   = ',format('%10.3e',[AreaU[j,i]]));
  if (AreaA[j,i]<0.001) and (AreaB[j,i]>0) and (AreaU[j,i]<0.001) then
  writeln (OutputFile,'  A   = ','     -    ',
  '    B   = ',format('%10.3e',[AreaB[j,i]]),
  '    U   = ','     -    ');
  if (AreaA[j,i]<0.001) and (AreaB[j,i]<0.001) and (AreaU[j,i]>0) then
  writeln (OutputFile,'  A   = ','     -    ',
  '    B   = ','     -    ', '    U   = ',format('%10.3e',[AreaU[j,i]]));
  if RotationType[i]=1 then
     writeln (OutputFile,'  Uc  = ',UCarea[i]:10:3,'    Kr  = ',
                          RotationType[i]:3)
  else
     writeln (OutputFile,'  Uc  = ','     -    ','    Kr  = ',
                          RotationType[i]:3);
//Soil salinities in rootzone, depending on rotationtype
  if RotationType[i]=0 then
  begin
    if AreaA[j,i]<0.001 then SCrA[i]:=0;
    if AreaB[j,i]<0.001 then SCrB[i]:=0;
    if AreaU[j,i]<0.001 then SCrU[i]:=0;
	   IF (ACarea[i]>0.001) AND (BCarea[i]>0.001) AND (UCarea[i]>0.001) THEN
        Writeln (OutputFile,'  CrA = ',format('%10.3e',[SCrA[i]]),
        '    CrB = ',format('%10.3e',[SCrB[i]]),'    CrU = ',
        format('%10.3e',[SCrU[i]]),'    Cr4 = ','     -    ');
	   IF (ACarea[i]<0.001) AND (BCarea[i]>0.001) AND (UCarea[i]>0.001) THEN
        Writeln (OutputFile,'  CrA = ','     -    ','    CrB = ',
        format('%10.3e',[SCrB[i]]),'    CrU = ',
        format('%10.3e',[SCrU[i]]),
                 '    Cr4 = ','     -    ');
	   IF (ACarea[i]>0.001) AND (BCarea[i]<0.001) AND (UCarea[i]>0.001) THEN
        Writeln (OutputFile,'  CrA = ',format('%10.3e',[SCrA[i]]),
        '    CrB = ','     -    ','    CrU = ',format('%10.3e',[SCrU[i]]),
        '    Cr4 = ','     -    ');
	   IF (ACarea[i]>0.001) AND (BCarea[i]>0.001) AND (UCarea[i]<0.001) THEN
        Writeln (OutputFile,'  CrA = ',format('%10.3e',[SCrA[i]]),
        '    CrB = ',format('%10.3e',[SCrB[i]]),'    CrU = ','     -    ',
        '    Cr4 = ','     -    ');
	   IF (ACarea[i]>0.001) AND (BCarea[i]<0.001) AND (UCarea[i]<0.001) THEN
        Writeln (OutputFile,'  CrA = ',format('%10.3e',[SCrA[i]]),
        '    CrB = ','     -    ','    CrU = ','     -    ',
        '    Cr4 = ','     -    ');
	   IF (ACarea[i]<0.001) AND (BCarea[i]>0.001) AND (UCarea[i]<0.001) THEN
        Writeln (OutputFile,'  CrA = ','     -    ','    CrB = ',
        format('%10.3e',[SCrB[i]]),'    CrU = ','     -    ',
        '    Cr4 = ','     -    ');
	   IF (ACarea[i]<0.001) AND (BCarea[i]<0.001) AND (UCarea[i]>0.001) THEN
        Writeln (OutputFile,'  CrA = ','     -    ','    CrB = ',
        '     -    ','    CrU = ',format('%10.3e',[SCrU[i]]),
        '    Cr4 = ','     -    ');
     Writeln (OutputFile,'  C1* = ','     -    ','    C2* = ',
                         '     -    ','    C3* = ','     -    ');
  end;
  if RotationType[i]=1 then
  begin
    writeln (OutputFile,'  CrA = ','     -    ','    CrB = ','     -    ',
                        '    CrU = ',format('%10.3e',[SCrU[i]]),
                        '    Cr4 = ','     -    ');
    if UCArea[i]<1 then
       writeln (OutputFile,'  C1* = ',format('%10.3e',[SCrA[i]]),
                           '    C2* = ','     -    ',
                           '    C3* = ','     -    ')
    else
       writeln (OutputFile,'  C1* = ','     -    ','    C2* = ','     -    ',
                           '    C3* = ','     -    ');
  end;
  if RotationType[i]=2 then
  begin
    writeln (OutputFile,'  CrA = ',format('%10.3e',[SCrA[i]]),
    '    CrB = ','     -    ','    CrU = ','     -    ',
    '    Cr4 = ','     -    ');
    if ACArea[i]<1 then
       writeln (OutputFile,'  C1* = ','     -    ','    C2* = ',
       format('%10.3e',[SCrB[i]]),'    C3* = ','     -    ')
    else
       writeln (OutputFile,'  C1* = ','     -    ','    C2* = ',
       '     -    ','    C3* = ','     -    ');
  end;
  if RotationType[i]=3 then
  begin
    writeln (OutputFile,'  CrA = ','     -    ','    CrB = ',
    format('%10.3e',[SCrB[i]]),'    CrU = ','     -    ',
    '    Cr4 = ','     -    ');
    if BCArea[i]<1 then
       writeln (OutputFile,'  C1* = ','     -    ','    C2* = ',
       '     -    ','    C3* = ',format('%10.3e',[SCrA[i]]))
    else
       writeln (OutputFile,'  C1* = ','     -    ','    C2* = ','     -    ',
                           '    C3* = ','     -    ');
  end;
  if RotationType[i]=4 then
  begin
    writeln (OutputFile,'  CrA = ','     -    ','    CrB = ','     -    ',
                        '    CrU = ','     -    ','    Cr4 = ',
                        format('%10.3e',[SCrA[i]]));
    writeln (OutputFile,'  C1* = ','     -    ','    C2* = ','     -    ',
                        '    C3* = ','     -    ');
  end;
//Salinities transition zone and aquifer
  if DrainIndex[i]=1 then
    writeln (OutputFile,'  Cxf = ','     -    ',
    '    Cxa = ',format('%10.3e',[SCtU[i]]),
    '    Cxb = ',format('%10.3e',[SCtL[i]]),
    '    Cqf = ',format('%10.3e',[SCaq[i]]))
  else
    writeln (OutputFile,'  Cxf = ',format('%10.3e',[SCtr[i]]),
    '    Cxa = ','     -    ','    Cxb = ','     -    ',
    '    Cqf = ',format('%10.3e',[SCaq[i]]));
//Other salt concentrations
  writeln (OutputFile,'  Cti = ',format('%10.3e',[Zit]),
  '    Cqi = ',format('%10.3e',[Zig]));
  NoIrr:=false;
  if (IrrA[j,i]<0.001) and (IrrB[j,i]<0.001) then NoIrr:=true;
  if (DrainIndex[i]=1) and not NoIrr then
  if WellDis[j,i]>0.0005 then
  begin
    if AreaU[j,i]<1 then
      writeln (OutputFile,'  Ci  = ',format('%10.3e',[Zir]),
      '    Cd  = ',format('%10.3e',[Zdr]),
                          '    Cw  = ',format('%10.3e',[Zwell]))
    else
      writeln (OutputFile,'  Ci  = ','     -    ',
                          '    Cd  = ',format('%10.3e',[Zdr]),
                          '    Cw  = ',format('%10.3e',[Zwell]));
  end else
  begin
    if AreaU[j,i]<1 then
      writeln (OutputFile,'  Ci  = ',format('%10.3e',[Zir]),
      '    Cd  = ',format('%10.3e',[Zdr]),'    Cw  = ','     -    ')
    else
      writeln (OutputFile,'  Ci  = ','     -    ',
      '    Cd  = ',format('%10.3e',[Zdr]),'    Cw  = ','     -    ');
  end;
  if (DrainIndex[i]=1) and NoIrr then
  if WellDis[j,i]>0.0005 then
  begin
    if AreaU[j,i]<1 then
      writeln (OutputFile,'  Ci  = ',format('%10.3e',[Zir]),
      '    Cd  = ',format('%10.3e',[Zdr]),
      '    Cw  = ',format('%10.3e',[Zwell]))
    else
      writeln (OutputFile,'  Ci  = ','     -    ',
      '    Cd  = ',format('%10.3e',[Zdr]),
      '    Cw  = ',format('%10.3e',[Zwell]));
  end else
  begin
    if AreaU[j,i]<1 then
      writeln (OutputFile,'  Ci  = ',format('%10.3e',[Zir]),
      '    Cd  = ',format('%10.3e',[Zdr]),'    Cw  = ','     -    ')
    else
      writeln (OutputFile,'  Ci  = ','     -    ',
      '    Cd  = ',format('%10.3e',[Zdr]),'    Cw  = ','     -    ');
  end;
  if (DrainIndex[i]=0) and not NoIrr then
  if WellDis[j,i]>0.0005 then
  begin
    if AreaU[j,i]<1 then
      writeln (OutputFile,'  Ci  = ',format('%10.3e',[Zir]),
      '    Cd  = ','     -    ','    Cw  = ',format('%10.3e',[Zwell]))
    else
      writeln (OutputFile,'  Ci  = ','     -    ',
      '    Cd  = ','     -    ','    Cw  = ',format('%10.3e',[Zwell]));
  end else
  begin
    if AreaU[j,i]<1 then
      writeln (OutputFile,'  Ci  = ',format('%10.3e',[Zir]),
      '    Cd  = ','     -    ','    Cw  = ','     -    ')
    else
       writeln (OutputFile,'  Ci  = ','     -    ',
      '    Cd  = ','     -    ','    Cw  = ','     -    ');
  end;
  if (DrainIndex[i]=0) and NoIrr then if WellDis[j,i]>0.0005 then
  begin
    if AreaU[j,i]<1 then
      writeln (OutputFile,'  Ci  = ',format('%10.3e',[Zir]),
                          '    Cd  = ','     -    ',
                          '    Cw  = ',format('%10.3e',[Zwell]))
    else
      writeln (OutputFile,'  Ci  = ','     -    ','    Cd  = ','     -    ',
                          '    Cw  = ',format('%10.3e',[Zwell]));
  end else
  begin
    if AreaU[j,i]<1 then
      writeln (OutputFile,'  Ci  = ',format('%10.3e',[Zir]),
                          '    Cd  = ','     -    ',
                          '    Cw  = ','     -    ')
    else
      writeln (OutputFile,'  Ci  = ','     -    ','    Cd  = ','     -    ',
                          '    Cw  = ','     -    ');
  end;
   writeln (OutputFile,' #');
//Calculating and writing frequency distributions of soil salinities

end; {with DataMod do}
end; {procedure WriteOutput}


procedure WriteFrequency (i, j, m : integer);
var Alf, Bet, A1, A2, A3, A4, B1, B2, B3, B4, U1, U2, U3, U4 : real;
begin with DataMod do
begin
//Calculating and writing frequency distributions of soil salinities
  if SurfArea[i]<=100 then
  begin
    Alf:=0.25;
    Bet:=0.84;
  end else
  if SurfArea[i]<=1000 then
  begin
    Alf:=0.32;
    Bet:=0.81;
  end else
  if SurfArea[i]<=10000 then
  begin
    Alf:=0.41;
    Bet:=0.76;
  end else
  begin
    Alf:=0.52;
    Bet:=0.69;
  end;
//Calculating the cumulative frequencies at 20%, 40%, 60%, and 80%
  A1:=SCrA[i]*(Bet-Alf*(ln(-ln(0.2))));
  A2:=SCrA[i]*(Bet-Alf*(ln(-ln(0.4))));
  A3:=SCrA[i]*(Bet-Alf*(ln(-ln(0.6))));
  A4:=SCrA[i]*(Bet-Alf*(ln(-ln(0.8))));
  B1:=SCrB[i]*(Bet-Alf*(ln(-ln(0.2))));
  B2:=SCrB[i]*(Bet-Alf*(ln(-ln(0.4))));
  B3:=SCrB[i]*(Bet-Alf*(ln(-ln(0.6))));
  B4:=SCrB[i]*(Bet-Alf*(ln(-ln(0.8))));
  U1:=SCrU[i]*(Bet-Alf*(ln(-ln(0.2))));
  U2:=SCrU[i]*(Bet-Alf*(ln(-ln(0.4))));
  U3:=SCrU[i]*(Bet-Alf*(ln(-ln(0.6))));
  U4:=SCrU[i]*(Bet-Alf*(ln(-ln(0.8))));
//Writing frequencies to *.FRQ
  Year:=m;
  if AnnualCalc then Year:=YearNr;
  if (i=1) { and (j=1) } then
  begin
     writeln (FrqFile,'  YEAR:  ',Year:4);
     writeln (FrqFile,' ************');
  end;
  if i=1 then
  begin
     writeln (FrqFile,'  Season: ',j:3,' -   "Duration:  ',
                       SeasonDuration[j]:5:1,'  months"');
     writeln (FrqFile,' ************');
     writeln (FrqFile,'- - -                "Cumulative'+
                      ' frequency of soil salinity"');
     writeln (FrqFile,'- Salinity-type/node -',
                      '  20%   ','    40%   ','    60%   ','    80%    ');
     writeln (FrqFile,'- -----------------------------',
                      '-------------------------------');
  end;
  if RotationType[i]=4 then
     writeln (FrqFile,'  "Cr4 in NODE"',i:4,'  ',format('%8.3e',[A1]),
     format('%10.3e',[A2]),format('%10.3e',[A3]),format('%10.3e',[A4]));
  if RotationType[i]=1 then
  begin
     writeln (FrqFile,'  "C1* in NODE"',i:4,'  ',format('%8.3e',[A1]),
           format('%10.3e',[A2]),format('%10.3e',[A3]),
           format('%10.3e',[A4]));
     writeln (FrqFile,'  "CrU in NODE"',i:4,'  ',format('%8.3e',[U1]),
           format('%10.3e',[U2]),format('%10.3e',[U3]),
           format('%10.3e',[U4]));
  end;
  if RotationType[i]=2 then
  begin
     writeln (FrqFile,'  "C2* in NODE"',i:4,'  ',format('%8.3e',[A1]),
           format('%10.3e',[A2]),format('%10.3e',[A3]),
           format('%10.3e',[A4]));
     writeln (FrqFile,'  "CrA in NODE"',i:4,'  ',format('%8.3e',[B1]),
           format('%10.3e',[B2]),format('%10.3e',[B3]),
           format('%10.3e',[B4]));
  end;
  if RotationType[i]=3 then
  begin
     writeln (FrqFile,'  "C3* in NODE"',i:4,'  ',format('%8.3e',[A1]),
           format('%10.3e',[A2]),format('%10.3e',[A3]),
           format('%10.3e',[A4]));
     writeln (FrqFile,'  "CrB in NODE"',i:4,'  ',format('%8.3e',[B1]),
           format('%10.3e',[B2]),format('%10.3e',[B3]),
           format('%10.3e',[B4]));
  end;
  if RotationType[i]=0 then
  begin
     writeln (FrqFile,'  "CrA in NODE"',i:4,'  ',format('%8.3e',[A1]),
           format('%10.3e',[A2]),format('%10.3e',[A3]),
           format('%10.3e',[A4]));
     writeln (FrqFile,'  "CrB in NODE"',i:4,'  ',format('%8.3e',[B1]),
           format('%10.3e',[B2]),format('%10.3e',[B3]),
           format('%10.3e',[B4]));
     writeln (FrqFile,'  "CrU in NODE"',i:4,'  ',format('%8.3e',[U1]),
           format('%10.3e',[U2]),format('%10.3e',[U3]),
           format('%10.3e',[U4]));
  end;
//Writing # at the end of each season
  if i=NrOfIntPoly then
  begin
    writeln (FrqFile,' #');
    writeln (FrqFile);
  end;

end; {with DataMod do}
end; {procedure procedure WriteFrequency }


procedure WriteGwtFile (i, j, m : integer);
var k : integer;
begin with DataMod do
begin
// OutputFileName:=ChangeFileExt (SaveFileName,'.Gwt');
//Writing groundwaterflow between polygons in m3/season to *.Gwt
  Year:=m;
  if AnnualCalc then Year:=YearNr;
  if (i=1) { and (j=1) }then
  begin
     writeln (GwtFile,'  YEAR:  ',Year:4);
     writeln (GwtFile,' ************');
  end;
  if i=1 then
  begin
     writeln (GwtFile,'  Season: ',j:3,' -   "Duration:  ',
                       SeasonDuration[j]:5:1,'  months"');
     writeln (GwtFile,' ************');
     writeln (GwtFile,'- - -                "Flow of the'+
                      ' groundwater (m3/season)"');
     writeln (GwtFile,'- - -             "------------',
                      '---------------------------"');
  end;
  writeln (GwtFile,'  "from node"',NodeNr[i]:4);
  write (GwtFile,'- - ','"to node:"');
  for k:=1 to NrOfSides[i] do
      write (GwtFile,BorderNode[i,k]:11);
  writeln (GwtFile);
  write (GwtFile,'- - -             ');
  for k:=1 to NrOfSides[i] do
      write (GwtFile,format('%11.3e',[Qaq[i,k]]));
  writeln (GwtFile);
  if i=NrOfIntPoly then
  begin
    writeln (GwtFile,' #');
    writeln (GwtFile);
  end;

end; {with DataMod do}
end; {procedure WriteGwtFile}


//End of UInitialCalc
end.



