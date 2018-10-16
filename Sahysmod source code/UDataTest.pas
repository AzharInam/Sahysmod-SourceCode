unit UDataTest;

//Note that here data are read from [1] to [NrOfPoly] whereas in UDataMod
//they are read from [0] to [NrOfPoly-1]

interface
var InputFile, ErrorFile                           : textfile;
    Rota0, Counter, SerialNodeNr, NrOfNextNodes    : array of integer;
    BorderNode                                     : array of array of integer;
    SUM, Uarea                                     : real;
    SurfArea, RootZone, TranZone, AquiZone,
    SurfLevel, LeachEffRo, LeachEffTr, LeachEffAq,
    TotPorRo, TotPorTr, TotPorAq, EffPorRo,
    EffPorTr, EffPorAq, EffPorSc, DrainDepth,
    ReactAbove, ReactBelow, CritDepth,
    SCrA, SCrB, SCrU, SCtU, SCtL, SCtr, SCaq, SCrZ,
    ACarea, BCarea, UCarea, ACParea, BCParea, UCParea,
    Qinf, Cinf, Qout, WaterLevel, WaterPress, HF0  : array of real;
    IrrA, IrrB, StoEffA, StoEffB, StoEffU,
    EvapA, EvapB, EvapU, PercLoss, IrrSal, Rain,
    SurfInFlow, SurfOutFlow, SurfDrA, SurfDrB,
    ReUseDr, ReUseWell, WellDis, WTcontrol,
    ExtWaterLevel, RiceIndA, RiceIndB              : array of array of real;
    GeoTestPassed                                  : boolean;

    procedure TestData;
    procedure Geometry;

implementation

    uses UDataMod;

procedure TestData;
var i, ii, j, jj, j2, k, m : integer;
    Annual : byte;

begin with DataMod do
begin
//Opening input file
  if AnnualCalc and (YearNr>1) then
     assignfile(InputFile,DataMod.AnnualFileName)
  else
     assignfile(InputFile,DataMod.SaveFileName);
  reset (InputFile);
  for i:=1 to 2 do readln (InputFile);                    {skipping the titles}
  AnnualCalc:=false;
  readln (InputFile,NrOfYears,NrOfSeasons,Annual);
  if Annual=1 then AnnualCalc:=true;
  GeoTestPassed:=false;
  assignfile(ErrorFile,'error.lst');
  rewrite (ErrorFile);
  writeln (ErrorFile, ' THE FOLLOWING ERRORS WERE FOUND IN: ',SaveFileName);
  writeln (ErrorFile);
//Start testing data
  for i:=1 to NrOfSeasons do read (InputFile,SeasonDuration[i]);
  readln (InputFile);
  SUM:=0;
  for i:=1 to  NrOfSeasons do
  begin
    if SeasonDuration[i]<0.5 then
       writeln (ErrorFile, ' The duration Ts of the season ',i:2,
                           ' must be > 0.5');
    SUM:=SUM+SeasonDuration[i];
  end;
  if SUM<>12 then
     writeln (ErrorFile, ' The annual sum of season durations Ts'+
                         ' must be 12 months');
  readln (InputFile,TotNrOfPoly,NrOfIntPoly,NrOfExtPoly);
  if TotNrOfPoly<4 then
     writeln (ErrorFile, ' The total number of nodes must be at least 4');
  if NrOfIntPoly<1 then
     writeln (ErrorFile, ' The number of internal nodes must be > 0');
  if NrOfExtPoly<3 then
     writeln (ErrorFile, ' There must be at least 3 external nodes');
  setlength (NrOfSides,NrOfIntPoly+1);
  for i:=1 to  NrOfIntPoly do read (InputFile,NrOfSides[i]);
  readln (InputFile);
  readln (InputFile,Scale,OutputTimestep{,AccuracyLevel});
  if Scale<200 then
       writeln (ErrorFile, ' The scale should be at least 200');
  if (OutputTimestep<1) or (OutputTimestep>NrOfYears) then
     writeln (ErrorFile, ' The time step should be at least 1'+
                         ' and less than the number of years');
  setlength (NodeNr,TotNrOfPoly+1);
  for i:=1 to  NrOfIntPoly do read (InputFile,NodeNr[i]);
  readln (InputFile);
  for i:=1 to  NrOfExtPoly do read (InputFile,NodeNr[i+NrOfIntPoly]);
  readln (InputFile);
  setlength (Xcoord,TotNrOfPoly+1);
  for i:=1 to  NrOfIntPoly do read (InputFile,Xcoord[i]);
  readln (InputFile);
  for i:=1 to  NrOfExtPoly do read (InputFile,Xcoord[i+NrOfIntPoly]);
  readln (InputFile);
  setlength (Ycoord,TotNrOfPoly+1);
  for i:=1 to  NrOfIntPoly do read (InputFile,Ycoord[i]);
  readln (InputFile);
  for i:=1 to  NrOfExtPoly do read (InputFile,Ycoord[i+NrOfIntPoly]);
  readln (InputFile);
  setlength (BottomLevel,TotNrOfPoly+1);
  for i:=1 to  NrOfIntPoly do read (InputFile,BottomLevel[i]);
  readln (InputFile);
  for i:=1 to  NrOfExtPoly do read (InputFile,BottomLevel[i+NrOfIntPoly]);
  readln (InputFile);
  setlength (Int_Ext_Index,TotNrOfPoly+1);
  for i:=1 to  NrOfIntPoly do read (InputFile,Int_Ext_Index[i]);
  readln (InputFile);
  for i:=1 to  NrOfExtPoly do read (InputFile,Int_Ext_Index[i+NrOfIntPoly]);
  readln (InputFile);
  for i:=1 to TotNrOfPoly do
      if (Int_Ext_Index[i]<>1) and (Int_Ext_Index[i]<>2) then
         writeln (ErrorFile, ' The index Kei for internal/external nodes'+
                             ' in polygon ',NodeNr[i]:3,' should be 1 or 2');
  j:=0;
  for i:=1 to TotNrOfPoly do if (Int_Ext_Index[i]=1) then
  begin
    j:=j+1;
    if NrOfSides[j]<3 then
       writeln (ErrorFile, ' The number of sides of polygon',NodeNr[i]:3,
                           ' should be at least 3');
    if NrOfSides[j]>6 then
       writeln (ErrorFile, ' The number of sides of polygon',NodeNr[i]:3,
                           ' should not be more than 6');
  end;
//Reading internal geometrical data
  setlength (SurfLevel,NrOfIntPoly+1);
  for i:=1 to  NrOfIntPoly do read (InputFile,SurfLevel[i]);
  readln (InputFile);
  setlength (RootZone,NrOfIntPoly+1);
  for i:=1 to  NrOfIntPoly do read (InputFile,RootZone[i]);
  readln (InputFile);
  setlength (TranZone,NrOfIntPoly+1);
  for i:=1 to  NrOfIntPoly do read (InputFile,TranZone[i]);
  readln (InputFile);
  setlength (AquiferType,TotNrOfPoly+1);
  for i:=1 to  NrOfIntPoly do read (InputFile,AquiferType[i]);
  readln (InputFile);
//Testing internal geometrical data
  for i:=1 to NrOfIntPoly do
  begin
    if RootZone[i]<0.1 then
      writeln (ErrorFile,' The rootzone thickness Dr in node ',NodeNr[i]:3,
                         ' should be greater than 0.1 m');
    if TranZone[i]<0.1 then
      writeln (ErrorFile,' The transition zone thickness Tra in node ',
               NodeNr[i]:3,' should be greater than 0.1 m');
    if BottomLevel[i]>=SurfLevel[i]-RootZone[i]-TranZone[i] then
      writeln (ErrorFile,' The bottom level in node ',NodeNr[i]:3,
                         ' is too high, take care that SL-Dr-Tra>BL');
    if (AquiferType[i]>1) or (AquiferType[i]<0) then
       writeln (ErrorFile,' The aquifer type in node ',NodeNr[i]:3,
                          ' should only be 0 or 1');
  end;
//Reading and checking hydr. conductivities and neighbor node numbers
  for i:=1 to 6 do setlength (Neighbor[i],TotNrOfPoly+1);
  for i:=1 to 6 do setlength (Conduct[i],TotNrOfPoly+1);
  for i:=1 to 6 do setlength (TopCond[i],TotNrOfPoly+1);
  for i:=1 to NrOfIntPoly do
  begin
    read (InputFile,SUM);
    for j:=1 to NrOfsides[i] do
        read (InputFile,Neighbor[j,i],Conduct[j,i],TopCond[j,i]);
    readln (InputFile);
  end;
  setlength (Counter,TotNrOfPoly+1);
  for i:=1 to NrOfIntPoly do Counter[i]:=0;
  for i:=1 to NrOfIntPoly do
  begin
    j:=NrOfSides[i];
    for m:=1 to j do
    begin
      if Neighbor[m,i]<=0 then
         writeln (ErrorFile,' A neighbouring node number of node ',
                  NodeNr[i]:3,' is inconsistent.');
      if m<j then for k:=m+1 to j do if Neighbor[k]=Neighbor[m] then
         writeln (ErrorFile,' Duplicate neighbor nodes of node ',
                  NodeNr[i]:3,' should be avoided.');
       if Conduct[m,i]<0 then
         writeln (ErrorFile,' The conductivity Khor from node ',
                  NodeNr[i]:3,' to ',Neighbor[m,i]:3,' should be >0.');
      if (TopCond[m,i]<0) and (AquiferType[i]=1) then
         writeln (ErrorFile,' The conductivity TopCond from node ',
                  NodeNr[i]:3,' to ',Neighbor[m,i]:3,' should be >0.');
      for k:=1 to TotNrOfPoly do if Neighbor[m,i]=NodeNr[k] then
          Counter[i]:=Counter[i]+1;
    end; {for m:=1 to j do}
  end; {for i:=1 to NrOfIntPoly do}
  for i:=1 to NrOfIntPoly do
      if NrOfSides[i]<>Counter[i] then
         writeln (ErrorFile,' The number of neighbouring nodes of node ',
                NodeNr[i]:3,' is inconsistent.');

//replacing the neighbor array (giving the j-th neighbour of all internal nodes)
//into the BorderNode array giving all neighbors per node, inluding externals
  setlength (BorderNode, TotNrOfPoly+1, 8);                    {first internal}
//Bordernode[i,j] is not really required, it can be replaced by Neighbor[j,i]
  for i:=1 to NrOfIntPoly do for j:=1 to NrOfSides[i] do
      BorderNode[i,j]:=Neighbor[j,i];
  for i:=1 to NrOfIntPoly do for j:=1 to NrOfSides[i] do        {then external}
      for k:=NrOfIntPoly+1 to TotNrOfPoly do
          if BorderNode[i,j]=k then
             BorderNode[k,j]:=i;

//Giving neighbour nodes serial numbers (Count) to match the coordinates,
//counting how often an internal poly occurs as a neighbour
  for i:=1 to NrOfIntPoly do Counter[i]:=0;
  for i:=1 to NrOfIntPoly do
  begin
    for j:=1 to NrOfSides[i] do for k:=1 to TotNrOfPoly do
    begin
      if BorderNode[i,j]=NodeNr[k] then
         Counter[i]:=Counter[i]+1;
      if (k>NrOfIntPoly) and (BorderNode[NodeNr[k],j]=i) then
          Counter[k]:=Counter[k]+1;
    end; {for j:=1 to NrOfSides[i] do for k:=1 to TotNrOfPoly do}
  end; {for m:=1 to NrOfIntPoly do}

//Checking network configuration
  for i:=1 to NrOfIntPoly-1 do
      if Counter[i]<>NrOfSides[i] then
         writeln (ErrorFile,' The configuration of neighbour nodes'+
                            ' around node ',NodeNr[i]:3,' is inconsistent');

//Calculating polygonal characteristics
  Geometry;

//reading vert. hydr. cond.
  setlength (VertCond,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do
      read (InputFile,VertCond[i]);
  readln (InputFile);
//checking vert. hydr. cond.
  for i:=1 to NrOfIntPoly do if (AquiferType[i]=1) and (VertCond[i]<0) then
         writeln (ErrorFile, ' The hydr. cond. Kver of node ',NodeNr[i]:3,
                             ' should not be negative');
//reading depth semi conf. layer
  setlength (TopLayer,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do
      read (InputFile,TopLayer[i]);
  readln (InputFile);
//checking depth semi conf. layer
  for i:=1 to NrOfIntPoly do if (AquiferType[i]=1) and (TopLayer[i]<0) then
         writeln (ErrorFile, ' The depth Dtop of the semi-conf. layer in node ',
                 NodeNr[i]:3,' should not be negative');
  for i:=1 to NrOfIntPoly do
      if (AquiferType[i]=1) and (TopLayer[i]>RootZone[i]+TranZone[i]) then
      begin
         writeln (ErrorFile, ' The depth Dtop of the semi-conf. layer in node ',
                 NodeNr[i]:3);
         writeln (ErrorFile, ' cannot be greater than its bottom depth Dr+Dx.');
      end;
//reading total porosity rootzone
  setlength (TotPorRo,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do
      read (InputFile,TotPorRo[i]);
  readln (InputFile);
//reading total porosity transition zone
  setlength (TotPorTr,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do
      read (InputFile,TotPorTr[i]);
  readln (InputFile);
//reading total porosity aquifer
  setlength (TotPorAq,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do
      read (InputFile,TotPorAq[i]);
  readln (InputFile);
//reading effective porosity rootzone
  setlength (EffPorRo,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do
      read (InputFile,EffPorRo[i]);
  readln (InputFile);
//reading effective porosity transition zone
  setlength (EffPorTr,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do
      read (InputFile,EffPorTr[i]);
  readln (InputFile);
//reading effective porosity aquifer
  setlength (EffPorAq,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do
      read (InputFile,EffPorAq[i]);
  readln (InputFile);
//reading effective porosity toplayer semiconfined aquifer
  setlength (EffPorSc,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do
      read (InputFile,EffPorSc[i]);
  readln (InputFile);
//Checking total porosity
  ii:=0;
  for i:=1 to NrOfIntPoly do
  begin
    if (TotPorRo[i]<=0) or (TotPorRo[i]>=1) then ii:=1;
    if (TotPorTr[i]<=0) or (TotPorTr[i]>=1) then ii:=1;
    if (TotPorAq[i]<=0) or (TotPorAq[i]>=1) then ii:=1;
  end;
  if ii=1 then writeln (ErrorFile,' The total porosity must be >0 and <1');
//Checking effective porosity
  ii:=0;
  for i:=1 to NrOfIntPoly do
  begin
    if (EffPorRo[i]<=0) or (EffPorRo[i]>=TotPorRo[i]) then ii:=1;
    if (EffPorTr[i]<=0) or (EffPorTr[i]>=TotPorTr[i]) then ii:=1;
    if (EffPorAq[i]<=0) or (EffPorAq[i]>=TotPorAq[i]) then ii:=1;
  end;
  if ii=1 then writeln (ErrorFile,' The effective porosity must be >0 and'+
                                  ' < total the porosity');
//Checking effective porosity semi confined
  ii:=0;
  for i:=1 to NrOfIntPoly do if AquiferType[i]>0 then
      if (EffPorSc[i]<=0) or (EffPorSc[i]>TotPorAq[i]) then ii:=1;
  if ii=1 then writeln (ErrorFile,' The storativity Psq of the semi'+
                    ' confining layer must be >0 and < total the porosity');
//reading leaching efficiency rootzone
  setlength (LeachEffRo,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do
      read (InputFile,LeachEffRo[i]);
  readln (InputFile);
//Checking leaching efficiency rootzone
  ii:=0;
  for i:=1 to NrOfIntPoly do
      if (LeachEffRo[i]<=0) then ii:=1;
  if ii=1 then writeln (ErrorFile,' The leaching efficiency Flr of the root'+
                    ' zone must be >0');
//Reading other leaching efficiencies
  setlength (LeachEffTr,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,LeachEffTr[i]);
  readln (InputFile);
  setlength (LeachEffAq,TotNrOfPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,LeachEffAq[i]);
  readln (InputFile);
//Checking other leaching efficiencies
  ii:=0;
  for i:=1 to NrOfIntPoly do
  begin
    if LeachEffTr[i]<=0 then ii:=1;
    if LeachEffAq[i]<=0 then ii:=1;
  end;
  if ii=1 then writeln (ErrorFile,' Leaching efficiencies Flx and/or Flq'+
                                  ' should be >0');
//Reading storage efficiencies
  setlength (StoEffA,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, StoEffA[j,i]);
    readln (InputFile);
  end;
  setlength (StoEffB,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, StoEffB[j,i]);
    readln (InputFile);
  end;
  setlength (StoEffU,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, StoEffU[j,i]);
    readln (InputFile);
  end;
//Reading keys for farming practices
  setlength (DrainIndex,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,DrainIndex[i]);
  readln (InputFile);
  setlength (ResponsIndex,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,ResponsIndex[i]);
  readln (InputFile);
  setlength (RotationType,NrOfIntPoly+1);
  setlength (Rota0,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,RotationType[i]);
  readln (InputFile);
  for i:=1 to NrOfIntPoly do
  begin
    if not RotationType[i] in [0,1,2,3,4,5,6,7,10] then
    writeln (ErrorFile,'The rotation type Kr in polygon ',i,' is not valid.');
  end;
  setlength (InclIndex,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,InclIndex[i]);
  readln (InputFile);
//Checking keys for farming practices
  ii:=0;
  for i:=1 to NrOfIntPoly do
  begin
    if (DrainIndex[i]<>0) and (DrainIndex[i]<>1) then ii:=1;
    if not AnnualCalc then
       if (ResponsIndex[i]<>0) and (ResponsIndex[i]<>1) then ii:=1;
    if (RotationType[i]<0) or (RotationType[i]>10) then ii:=1;
    if not AnnualCalc and (ResponsIndex[i]=1) then
       if (InclIndex[i]<>0) and (InclIndex[i]<>1) then ii:=1;
  end;
  if ii=1 then writeln (ErrorFile,' Keys for agr. pract. (Kd, Kf, Kr, Kw)'+
                                  ' have irregular values (not 0 or 1)');
//Reading drain depth, drainage reaction factors below and above drain level
  setlength (DrainDepth,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,DrainDepth[i]);
  readln (InputFile);
//Checking drain depth when needed
  ii:=0;
  for i:=1 to NrOfIntPoly do if DrainIndex[i]>0 then
      if (DrainDepth[i]<=RootZone[i])
         or (DrainDepth[i]>=RootZone[i]+TranZone[i])then ii:=1;
  if ii=1 then writeln (ErrorFile,' The drains should be in the transition'+
                                  ' zone: Dr < Dd < Dr+Dx');

  setlength (ReactBelow,NrOfIntPoly+1);
  setlength (ReactAbove,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,ReactBelow[i]);
  readln (InputFile);
  for i:=1 to NrOfIntPoly do read (InputFile,ReactAbove[i]);
  readln (InputFile);
//Checking reaction factors
  ii:=0;
  for i:=1 to NrOfIntPoly do if DrainIndex[i]=1 then
  begin
    if ReactAbove[i]<0 then ii:=1;
    if ReactBelow[i]<0 then ii:=1;
  end;
  if ii=1 then writeln (ErrorFile,' Drainage reaction factors QH1 and QH2'+
                                  ' cannot be negative');
//Reading rainfall data
  setlength (Rain,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, Rain[j,i]);
    readln (InputFile);
  end;
//Checking rainfall data
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
      if (Rain[j,i]<0) then ii:=1;
  if ii=1 then
     writeln (ErrorFile,' Rainfall (Rain) cannot be negative');
//Reading evaporation data
  setlength (EvapA,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, EvapA[j,i]);
    readln (InputFile);
  end;
  setlength (EvapB,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, EvapB[j,i]);
    readln (InputFile);
  end;
  setlength (EvapU,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, EvapU[j,i]);
    readln (InputFile);
  end;
//Reading percolation losses from canals
  setlength (PercLoss,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, PercLoss[j,i]);
    readln (InputFile);
  end;
//Reading salinity of irrigation water
  setlength (IrrSal,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, IrrSal[j,i]);
    readln (InputFile);
  end;
//Reading irrigation applications
  setlength (IrrA,NrOfSeasons+1,NrOfIntPoly+1);
  for i:=1 to NrOfSeasons do
  begin
    for j:=1 to NrOfIntPoly do read (InputFile,IrrA[i,j]);
    readln (InputFile);
  end;
  setlength (IrrB,NrOfSeasons+1,NrOfIntPoly+1);
  for i:=1 to NrOfSeasons do
  begin
    for j:=1 to NrOfIntPoly do read (InputFile,IrrB[i,j]);
    readln (InputFile);
  end;
//Reading in/out surface flow
  setlength (SurfInFlow,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, SurfInFlow[j,i]);
    readln (InputFile);
  end;
  setlength (SurfOutFlow,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, SurfOutFlow[j,i]);
    readln (InputFile);
  end;
//Reading surface drainage
  setlength (SurfDrA,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, SurfDrA[j,i]);
    readln (InputFile);
  end;
  setlength (SurfDrB,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, SurfDrB[j,i]);
    readln (InputFile);
  end;
//Reading area fractions
  for i:=1 to NrOfSeasons do setlength (AreaA[i],NrOfIntPoly+1);
  for i:=1 to NrOfSeasons do
  begin
    for j:=1 to NrOfIntPoly do read (InputFile,AreaA[i,j]);
    readln (InputFile);
  end;
  for i:=1 to NrOfSeasons do setlength (AreaB[i],NrOfIntPoly+1);
  for i:=1 to NrOfSeasons do
  begin
    for j:=1 to NrOfIntPoly do read (InputFile,AreaB[i,j]);
    readln (InputFile);
  end;
//Checking area fractions
  ii:=0;
  for M:=1 to NrOfIntPoly do
  begin
    for j:=1 to NrOfSeasons do
    begin
      if (AreaA[j,M]>1) or (AreaA[j,M]<0) then ii:=1;
      if (AreaB[j,M]>1) or (AreaB[j,M]<0) then ii:=1;
      SUM:=AreaA[j,M]+AreaB[j,M];
      if SUM>1 then
      begin
        writeln (ErrorFile,' The sum of the irrigated area'+
                           ' fractions A and B of node',NodeNr[m]:3);
        writeln (ErrorFile,' and in season ',J:2,' must be >=0 and =<1');
      end;
    end;
  end;
  if ii=1 then writeln (ErrorFile,' Area fractions must be >=0 and =<1');
//Checking field irrigation
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    if (AreaA[j,i]>0) and (IrrA[j,i]<0) then ii:=1;
    if (AreaB[j,i]>0) and (IrrB[j,i]<0) then ii:=1;
  end;
  if ii=1 then writeln (ErrorFile,' Field irrigation should be >=0');
//Reading rice crop indices
  setlength (RiceIndA,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, RiceIndA[j,i]);
    readln (InputFile);
  end;
  setlength (RiceIndB,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, RiceIndB[j,i]);
    readln (InputFile);
  end;
//Reading re-use of drainage water
  setlength (ReUseDr,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, ReUseDr[j,i]);
    readln (InputFile);
  end;
//Checking re-use of drainage water
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
      if (DrainIndex[i]>0) and (ReUseDr[j,i]<0) then ii:=1;
  if ii=1 then
     writeln (ErrorFile,' Drain water re-use Gu cannot be negative');
//Reading reuse fraction of well water
  setlength (ReUseWell,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, ReUseWell[j,i]);
    readln (InputFile);
  end;
//Reading well discharge
  setlength (WellDis,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, WellDis[j,i]);
    readln (InputFile);
  end;
//Checking well discharge
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
      if WellDis[j,i]<0 then ii:=1;
  if ii=1 then
     writeln (ErrorFile,' The well discharge Gw cannot be negative');
//Checking reuse fraction of well water
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
      if (WellDis[j,i]>0) then
         if (ReUseWell[j,i]<0) and (ReUseWell[j,i]>1) then ii:=1;
  if ii=1 then
    writeln (ErrorFile,' Re-use fraction Fw of well water must be >=0 and =<1');
//Reading watertable control factor in drainage systems
  setlength (WTcontrol,NrOfSeasons+1,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfIntPoly do read (InputFile, WTcontrol[j,i]);
    readln (InputFile);
  end;
//Checking watertable control factor in drainage systems
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
      if DrainIndex[i]=1 then if (WTcontrol[j,i]<0) or (WTcontrol[j,i]>1) then
         ii:=1;
  if ii=1 then writeln (ErrorFile,
               ' The drainage control factor Fcd must be >=0 and =<1');
//Reading initial water level
  setlength (Waterlevel,TotNrOfPoly+1);
  if YearNr<1 then
     for i:=1 to NrOfIntPoly do read (InputFile,Waterlevel[i]);
  readln (InputFile);
//Reading crit. depth WT in internal polygons
  setlength (CritDepth,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,CritDepth[i]);
  readln (InputFile);
//Checking critical depth WT
  ii:=0;
  for i:=1 to NrOfIntPoly do
      if (CritDepth[i]<=0) then ii:=1;
  if ii=1 then writeln (ErrorFile,' The critical depth Dc of the water'+
                    ' water table must be >0');
//Reading water pressure
  setlength (WaterPress,NrOfIntPoly+1);
  if YearNr<1 then
     for i:=1 to NrOfIntPoly do read (InputFile,WaterPress[i]);
  readln (InputFile);
//Reading initial salt concentration rootzone in irr. area A
  setlength (SCrA,NrOfIntPoly+1);
  if YearNr<1 then
     for i:=1 to NrOfIntPoly do read (InputFile,SCrA[i]);
  readln (InputFile);
//Reading initial salt concentration rootzone in irr. area B
  setlength (SCrB,NrOfIntPoly+1);
  if YearNr<1 then
     for i:=1 to NrOfIntPoly do read (InputFile,SCrB[i]);
  readln (InputFile);
//Reading initial salt concentration rootzone in unirrigated land
  setlength (SCrU,NrOfIntPoly+1);
  if YearNr<1 then
     for i:=1 to NrOfIntPoly do read (InputFile,SCrU[i]);
  readln (InputFile);
  setlength (SCrZ,NrOfIntPoly+1);
//Reading initial salt concentration transition zone above drain level
  setlength (SCtU,NrOfIntPoly+1);
  if YearNr<1 then
     for i:=1 to NrOfIntPoly do read (InputFile,SCtU[i]);
  readln (InputFile);
//Reading initial salt concentration transition zone below drain level
  setlength (SCtL,NrOfIntPoly+1);
  if YearNr<1 then
     for i:=1 to NrOfIntPoly do read (InputFile,SCtL[i]);
  readln (InputFile);
//Reading initial salt concentration transition zone
  setlength (SCtr,NrOfIntPoly+1);
  if YearNr<1 then
     for i:=1 to NrOfIntPoly do read (InputFile,SCtr[i]);
  readln (InputFile);
//Reading initial salt concentration aquifer, internal nodes
  setlength (SCaq,TotNrOfPoly+1);    {includes external nodes to be read later}
  if YearNr<1 then
     for i:=1 to NrOfIntPoly do read (InputFile,SCaq[i]);
  readln (InputFile);
//Reading underground inflow
  setlength (Qinf,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,Qinf[i]);
  readln (InputFile);
//Reading salinity of underground inflow
  setlength (Cinf,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,Cinf[i]);
  readln (InputFile);
//Reading underground outflow
  setlength (Qout,NrOfIntPoly+1);
  for i:=1 to NrOfIntPoly do read (InputFile,Qout[i]);
  readln (InputFile);
//Checking underground in/outflow, its salinity
  for i:=1 to NrOfIntPoly do
  begin
    ii:=0;
    if Qinf[i]<0 then ii:=1;
    if Qout[i]<0 then ii:=1;
    if ii=1 then writeln (ErrorFile,' The aquifer inflow/outflow conditions'+
            ' in node ',NodeNr[i]:3,' cannot be negative');
    ii:=0;
    if Cinf[i]<0 then ii:=1;
    if ii=1 then writeln (ErrorFile,' The aquifer inflow salinity'+
            ' in node ',NodeNr[i]:3,' cannot be negative');
  end;
//Checking underground in/outflow, and its salinity
  for i:=1 to NrOfIntPoly do
  begin
    ii:=0;
    if Qinf[i]<0 then ii:=1;
    if Qout[i]<0 then ii:=1;
    if ii=1 then writeln (ErrorFile,' The aquifer inflow/outflow conditions'+
            ' in node ',NodeNr[i]:3,' cannot be negative');
    ii:=0;
    if Cinf[i]<0 then ii:=1;
    if ii=1 then writeln (ErrorFile,' The aquifer inflow salinity'+
            ' in node ',NodeNr[i]:3,' cannot be negative');
  end;
//Reading external salinity of the aquifer, setlength was done before
  for i:=NrOfIntPoly+1 to TotNrOfPoly do read (InputFile,SCaq[i]);
  readln (InputFile);
//Checking external salinity of the aquifer
  ii:=0;
  for i:=NrOfIntPoly+1 to TotNrOfPoly do
      if SCaq[i]<0 then ii:=1;
  if ii=1 then writeln (ErrorFile,' Aquifer salinities of the'+
                                  ' external nodes should be >0');
//Reading external waterlevels, setlength was done before
  setlength (ExtWaterLevel,NrOfSeasons+1,NrOfExtPoly+1);
  for j:=1 to NrOfSeasons do
  begin
    for i:=1 to NrOfExtPoly do read (InputFile,ExtWaterLevel[j,i]);
    readln (InputFile);
  end;

//CHECKING REMAINING DATA DEPENDING ON IRRIGATED AREAS A AND B
//Checking field irrigation
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    if (AreaA[j,i]>0) and (IrrA[j,i]<0) then ii:=1;
    if (AreaB[j,i]>0) and (IrrB[j,i]<0) then ii:=1;
  end;
  if ii=1 then writeln (ErrorFile,' Field irrigation should be >=0');
//Determining permanent area fractions AC, BC, UC for checking salinity data
  setlength (ACarea,NrOfIntPoly+1);
  setlength (BCarea,NrOfIntPoly+1);
  setlength (UCarea,NrOfIntPoly+1);
  setlength (ACParea,NrOfIntPoly+1);
  setlength (BCParea,NrOfIntPoly+1);
  setlength (UCParea,NrOfIntPoly+1);
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    if j=1 then
    begin
      ACarea[i]:=AreaA[j,i];
      BCarea[i]:=AreaA[j,i];
      Uarea:=1-AreaA[j,i]-AreaB[j,i];
      UCarea[i]:=Uarea;
    end else
    begin
      if AreaA[j,i]<ACArea[i] then ACarea[i]:=AreaA[j,i];
      ACParea[i]:=ACarea[i];
      if AreaB[j,i]<BCArea[i] then BCarea[i]:=AreaB[j,i];
      BCParea[i]:=BCarea[i];
      if Uarea<UCArea[i] then UCarea[i]:=Uarea;
      UCParea[i]:=UCarea[i];
    end;
  end;
//Checking salinity data
  if YearNr<1 then for i:=1 to NrOfIntPoly do
  begin
    ii:=0;
    if ResponsIndex[i]=0 then
    begin
      if (ACarea[i]>0) and (SCRA[i]<0) then ii:=1;
      if (BCarea[i]>0) and (SCRB[i]<0) then ii:=1;
      if (UCarea[i]>0) and (SCRU[i]<0) then ii:=1;
    end;
    if ResponsIndex[i]=1 then
    begin
      if (ACarea[i]>0) and (SCrA[i]<0) then ii:=1;
      if (UCarea[i]>0) and (SCrU[i]<0) then ii:=1;
    end;
    if (ResponsIndex[i]=2) or (ResponsIndex[i]=3) then
    begin
      if (ACarea[i]>0) and (SCrA[i]<0) then ii:=1;
      if (BCarea[i]>0) and (SCrB[i]<0) then ii:=1;
    end;
    if ResponsIndex[i]=4 then
       if (ACarea[i]>0) and (SCrA[i]<0) then ii:=1;
    if ii=1 then writeln (ErrorFile,' The initial root zone salinity in node ',
                        NodeNr[i]:3,' cannot be negative');
    ii:=0;
    if (DrainIndex[i]=1) and (SCtU[i]<0) then ii:=1;
    if (DrainIndex[i]=1) and (SCtL[i]<0) then ii:=1;
    if (DrainIndex[i]=0) and (SCtr[i]<0) then ii:=1;
    if ii=1 then writeln (ErrorFile,' The initial transition zone salinity'+
                         ' in node ',NodeNr[i]:3,' cannot be negative');
    ii:=0;
    if SCaq[i]<0 then ii:=1;
    if ii=1 then writeln (ErrorFile,' The initial aquifer salinity SCa'+
                         ' in node ',NodeNr[i]:3,' cannot be negative');
  end; {if YearNr<1 then for i:=1 to NrOfIntPoly do}
//Checking storage efficiencies
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    if (AreaA[j,i]>0) then if (StoEffA[j,i]<=0) or (StoEffA[j,i]>1) then ii:=1;
    if (AreaB[j,i]>0) then if (StoEffB[j,i]<=0) or (StoEffB[j,i]>1) then ii:=1;
    SUM:=AreaA[j,i]+AreaB[j,i];
    if (1-SUM>0) then if (StoEffU[j,i]<=0) or (StoEffU[j,i]>1) then ii:=1;
  end;
  if ii=1 then writeln (ErrorFile,' Storage efficiencies FsA, FsB and/or FsU'+
                                  ' must be >0 and <1');
//Checking evaporation data
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    if (AreaA[j,i]>0) and (EvapA[j,i]<0) then ii:=1;
    if (AreaB[j,i]>0) and (EvapB[j,i]<0) then ii:=1;
    SUM:=AreaA[j,i]+AreaB[j,i];
    if (1-SUM>0) and (EvapU[j,i]<0) then ii:=1;
    if (EvapU[j,i]<=0) and (ResponsIndex[i]>0) then ii:=1;
  end;
  if ii=1 then
     writeln (ErrorFile,' Evaporation EPa, EPb and/or EPu must be >0');
//Checking percolation losses
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    SUM:=AreaA[j,i]+AreaB[j,i];
    if (SUM>0) and (PercLoss[j,i]<0) then ii:=1;
  end;
  if ii=1 then
     writeln (ErrorFile,' Irrigation canal losses Lc must be >0');
//Checking salinity of irrigation water
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    SUM:=AreaA[j,i]+AreaB[j,i];
    if (SUM>0) and (IrrSal[j,i]<0) then ii:=1;
  end;
  if ii=1 then
     writeln (ErrorFile,' The salinity of the irrigation water must be >0');
//Checking in/out surface flow
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    SUM:=1-AreaA[j,i]-AreaB[j,i];
    if (SUM>0) and (SurfInFlow[j,i]<0) then ii:=1;
    if (SurfInFlow[j,i]<0) and (ResponsIndex[i]>0) then ii:=1;
    if (SUM>0) and (SurfOutFlow[j,i]<0) then ii:=1;
    if (SurfOutFlow[j,i]<0) and (ResponsIndex[i]>0) then ii:=1;
  end;
  if ii=1 then
     writeln (ErrorFile,' Surface flows SiU and SoU cannot be negative');
//Checking surface drainage
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    if (AreaA[j,i]>0) and (SurfDrA[j,i]<0) then ii:=1;
    if (AreaB[j,i]>0) and (SurfDrB[j,i]<0) then ii:=1;
  end;
  if ii=1 then
     writeln (ErrorFile,' Surface drainage SoA and/or SoB cannot be negative');
//Checking rice crop indices
  ii:=0;
  for j:=1 to NrOfSeasons do for i:=1 to NrOfIntPoly do
  begin
    if (AreaA[j,i]>0) then
        if (RiceIndA[j,i]<>0) and (RiceIndA[j,i]<>1) then ii:=1;
    if (AreaB[j,i]>0) then
        if (RiceIndB[j,i]<>0) and (RiceIndB[j,i]<>1) then ii:=1;
  end;
  if ii=1 then
     writeln (ErrorFile,' Rice crop indices RcA and RcB can only be 0 or 1');
//Checking initial waterlevels and aquifer depth
  setlength (HF0,NrOfIntPoly+1);
  setlength (AquiZone,NrOfIntPoly+1);
  for i :=1 to NrOfIntPoly do
  begin
    if AquiferType[i]=1 then
    begin
      HF0[i]:= WaterPress[i];
      SUM := SurfLevel[i]-WaterPress[i];
    end else
    begin
      HF0[i]:=WaterLevel[i];
      SUM := SurfLevel[i]-WaterLevel[i];
    end;
    if SUM>SurfLevel[i]-BottomLevel[i] then
       writeln (ErrorFile,' The water table in polygon in node ',NodeNr[i]:3,
                          ' is below the aquifer bottom');
    AquiZone[i]:=SurfLevel[i]-BottomLevel[i]-RootZone[i]-TranZone[i];
    if AquiZone[i]<0.1 then
       writeln (ErrorFile,' The thickness of the aquifer in node ',NodeNr[i]:3,
                          ' is less than 0.1 m');
    if SurfLevel[i]-BottomLevel[i]<0.1 then
       writeln (ErrorFile,' The aquifer bottom in node ',NodeNr[i]:3,
                          ' is less than 0.1 m below the soil surface');
  end;

  closefile (ErrorFile);
  closefile (InputFile);
end; {with DataMod do}
end; {procedure TestData}


procedure Geometry;
var TotArea, Dummy, X, Y, A, B, C, D, E,
    abd, ace, Len, Wid, Wid1, Wid2                 : real;
    LenSq                                          : array of real;
    i, ii, j, jj, J2, K, m                         : integer;
    NSI                                            : array of integer;
begin with DataMod do
begin
  TotArea:=0;
  setlength (NSI,8);
  setlength (LenSq,8);
  setlength (SurfArea,NrOfIntPoly+1);
  setlength (SerialNodeNr,TotNrOfPoly+1);
  setlength (NrOfSides,TotNrOfPoly+1);
  for k:=1 to TotNrOfPoly do SerialNodeNr[NodeNr[k]]:=k;
  setlength (NrOfNextNodes,TotNrOfPoly+1);
  for k:=1 to TotNrOfPoly do NrOfNextNodes[k]:=NrOfSides[k];
  for K:=1 to NrOfIntPoly do
  begin
    Dummy:=0;
    J2:=NrOfNextNodes[K];
    for j:=1 to J2 do
    begin
      NSI[1]:=SerialNodeNr[BorderNode[K,j]];
      if j=1 then NSI[2]:=SerialNodeNr[BorderNode[K,J2]];
      if j<>1 then NSI[2]:=SerialNodeNr[BorderNode[K,j-1]];
      if j=J2 then NSI[3]:=SerialNodeNr[BorderNode[K,1]];
      if j<>J2 then NSI[3]:=SerialNodeNr[BorderNode[K,j+1]];
      for i:=1 to 3 do
      begin
        X:=Xcoord[K] - Xcoord[NSI[i]];
        Y:=Ycoord[K] - Ycoord[NSI[i]];
        LenSq[i]:=sqr(X)+sqr(Y);
      end;
      for I:=2 to 3 do
      begin
        X:=Xcoord[NSI[1]] - Xcoord[NSI[i]];
        Y:=Ycoord[NSI[1]] - Ycoord[NSI[i]];
        LenSq[i+2]:=sqr(X)+sqr(Y);
      end;
      A:=LenSq[1];
      B:=sqr(LenSq[4]+LenSq[2]-LenSq[1]);
      C:=sqr(LenSq[3]+LenSq[5]-LenSq[1]);
      D:=4*LenSq[4]*LenSq[2];
      E:=4*LenSq[3]*LenSq[5];
      ii:=0;
      if not GeoTestPassed then
      begin
        if (A<0) or (B<0) or (C<0) then
        begin
          ii:=1;
          writeln (ErrorFile, ' The coordinates of polygon ',K:3,
                              ' and/or ',BorderNode[K,j]:3,' are incorrect,');
          writeln (ErrorFile, ' or the nodal network relations are wrong here.');
        end;
        if (ii=0) and (D-B<=0) or (E-C<=0) then
        begin
          ii:=1;
          writeln (ErrorFile, ' The coordinates of polygon ',K:3,
                            ' and/or ',BorderNode[K,j]:3,' are incorrect,');
          writeln (ErrorFile, ' or the nodal network relations are wrong here.');
        end;
      end; {if not GeoTestPassed then}
      abd:=-1;
      ace:=-1;
      if (D-B<>0) and (E-C<>0) then
      begin
        abd:=A*B/(D-B);
        ace:=A*C/(E-C);
      end;
      if not GeoTestPassed then
      begin
        if (ii=0) then if (abd<0) or (ace<0) or (A<=0) then
        begin
           ii:=1;
           writeln (ErrorFile, ' The coordinates of polygon ',K:3,
                               ' and/or ',BorderNode[K,j]:3,' are incorrect,');
           writeln (ErrorFile, ' or the nodal network relations are wrong here.');
        end;
      end; {if YearNr<1 then}
      Len:=0;
      Wid:=0;
      if (D-B<>0) and (C-E<>0) and (A>0) then
      begin
        Len:=sqrt(A);
        Wid1:=0.25*A*B/(D-B);
        Wid2:=0.25*A*C/(E-C);
        if (Wid1>0) and (Wid2>0) then
           Wid:=sqrt(Wid1)+sqrt(Wid2);
      end;
      if not GeoTestPassed then
      begin
        if (ii=0) then if (Wid=0) or (Len=0) then
        begin
           writeln (ErrorFile, ' The coordinates of polygon ',K:3,
                               ' and/or ',BorderNode[K,j]:3,' are incorrect,');
           writeln (ErrorFile, ' or the nodal network relations are wrong here.');
        end;
      end; {if YearNr<1 then}
      if (Wid>0) and (Len>0) then
      begin
        Conduct[j,K]:=Conduct[j,K]*Wid/Len;
        TopCond[j,K]:=TopCond[j,K]*Wid/Len;
        Dummy:=Dummy+Wid*Len;
      end;
      SurfArea[K]:=Dummy*sqr((Scale/100))/J2;
      TotArea:=TotArea+SurfArea[K];
    end; {for j:=1 to J2 do}
  end;{for jj:=1,NrOfIntPoly}
  GeoTestPassed:=true;
end; {with DataMod do}
end; {procedure Geometry}


end.
