unit UMainCalc;

interface

  uses SysUtils, UDataMod;

  var AccErr : boolean; AccFile: textfile;

  procedure MainCalculations;
  procedure SetSalinity;
  procedure TopWaterBalances (j, i, m : integer);
  procedure GroundWaterModel (j, i : integer);
  procedure SaltBalances (j, i : integer);
  procedure ReduceIrr (j, i : integer);
  procedure FarmResponses (j, i : integer);
//Auxilary procedures
  procedure ConvertToDaily (j : integer);
  procedure SetToZero;
  procedure ConvToSeasonal (j : integer);
  procedure Summations (j, i : integer);
  procedure SeasonalRename (j, i :integer);
//Sub-procedures under procedure Saltbalances
  procedure AuxSB1 (var DOWNx,UPWAx,IRAx,IRBx,RAINx,SCMAx,SCMBx,SCMUx,SCXx,
                  SDAx,SDBx,SDLAx,SDLBx,SDLUx,SRIx,SROx,SSIx : real;
                  ii : integer);
  procedure AuxSB2 (var AUB,SCR1,SCM1,SC01,SCR2,SCM2,SC02,TSC1,TSC2,TSI1,TSI2,
            TPL1,TPL2: real; ii : integer);
  procedure AuxSB3 (var PLF,SCRAx,SCMAx,TSIx : real; ii : integer);
  procedure AuxSB4A (var PLC,SCTMx,TSPx,VDDx,VUSx : real;
                     ii : integer);
  procedure AuxSB4B (var PLC,SCAx,SCLx,SCLMx,SCUx,SCUMx,TSPx,
            VDDx,VUSx : real; ii : integer);
  procedure AuxSB5 (var HIG,HOG,PLC,PLF,SCLMx,SCTMx,VDDx,VUSx,WELx,
            ZIGx,ZIRx : real; ii : integer);

implementation

  uses UMainForm, UDataTest, UInitialCalc, UExtraUtils, UWarningForm;

  var MonthlySteps : integer;
      CaAT, CaBT, CaUT, CirT, CitT, DrAT, DrBT, DwtT, EpAT, EpBT, EpUT,
      HIGT, HOGT, HITT, HOTT, PLaT, PLbT, PLuT, SGiT, PlcT, STiT, StoT,
      ZirT, ZwlT, ZdrT, RechT, BypT, StorAq, IrAT, IrBT,
      EffPor                     : array of real;
      SCRA0, SCRB0, SCRU0, SCRZ0 : real;
      Again, Error               : boolean;
      ReUseReduced, IrrReduced   : boolean;
      AreaReduced, WellReduced   : boolean;
      StoreFile                  : textfile;
      Year                       : integer;

procedure  MainCalculations;
label 1 ;
var i, j, ij, K, M, Start, Y, Days, Number, CountIt, Advance,
    OutputIndex        : integer;
    NrOfDays, Wel0, CF : real;
    Progr1, Progr2     : boolean;
    WellTxt            : string;

begin with DataMod do
begin

//Iitial settings
  IrrReduced:=false;
  WellReduced:=false;
  ReUseReduced:=false;
  AreaReduced:=false;

//Opening the errorfile just in case of errors
  assignfile(ErrorFile,'error.lst');
  rewrite (ErrorFile);
  writeln (ErrorFile, ' THE FOLLOWING ERRORS WERE FOUND IN: ',SaveFileName);
  writeln (ErrorFile);

//Writing data to a storage file required when time step changes
  assignfile(StoreFile,'Storage.dat');
  rewrite (StoreFile);
  for i:=1 to NrOfIntPoly do
  begin
    writeln (StoreFile,WaterLevel[i],' ',WaterPress[i],' ','   0');
    writeln (StoreFile,SCrA[i],' ',SCrB[i],' ',SCrU[i]);
    writeln (StoreFile,SCtU[i],' ',SCtL[i],' ',SCtr[i],' ',SCaq[i]);
  end;
  closefile (StoreFile);

//setting intial values of area fractions and field irrigation
  for i:=1 to NrofIntpoly do for j:=1 to NrOfSeasons do
  begin
    AA0[j,i]:=AreaA[j,i];
    BB0[j,i]:=AreaB[j,i];
    AreaU[j,i]:=1-AreaA[j,i]-AreaB[j,i];
  end;

//Setting soil salinity depending on rotation type
  SetSalinity;
  
//Append output data to output files in later years of annual calculations
  if AnnualCalc and (YearNr>1) then
  begin
    assignfile (OutputFile,OutputFileName);
    Append(OutputFile);
    OutputFileName:=changefileext (SaveFileName,'.frq');
    Assignfile (FrqFile,OutputFileName);
    Append(FrqFile);
    OutputFileName:=changefileext (SaveFileName,'.gwt');
    Assignfile (GwtFile,OutputFileName);
    Append(GwtFile);
    OutputFileName:=ChangeFileExt (SaveFileName,'.out');
  end;

//The following is triplicated from UDataTest and UInitialCalc, can be removed
//Setting real node numbers to serial node numbers
  for i:=1 to NrOfIntPoly do for j:=1 to NrOfNextNodes[i] do   {first internal}
      BorderNode[i,j]:=Neighbor[j,i];
  for i:=1 to NrOfIntPoly do for j:=1 to NrOfNextNodes[i] do    {then external}
      for k:=NrOfIntPoly+1 to TotNrOfPoly do
          if BorderNode[i,j]=k then
             BorderNode[k,j]:=i;

//Calculations for all years (M)
  MonthlySteps:=30;
  Progr1:=false;
  Progr2:=false;
  Error:=false;
  AccErr:=false;
//  AllWarning:=false;
  for M:=1 to NrOfYears do
  begin
    Start:=1;
    Y:=1;
    Again:=false;

//TEMPORARY FOR CHECK
//    DataMod.YearNr:=M;

//If accuracy is insufficient (see GWMOD) then increasing steps per month
//and starting seasonal calculations again
1:  if Again then
    begin
//Restoring initial water levels and salinities
      Assignfile (StoreFile,'Storage.dat');
      reset (StoreFile);
      for i:=1 to NrOfIntPoly do
      begin
        readln (StoreFile,WaterLevel[i],WaterPress[i],SalY[i]);
        readln (StoreFile,SCrA[i],SCrB[i],SCrU[i]);
        readln (StoreFile,SCtU[i],SCtL[i],SCtr[i],SCaq[i]);
      end;
      closefile(StoreFile);
      Again:=false;
      Start:=Y;
    end; {if Again then}

//Calculations for the seasons within the year
    for Y:=Start to NrOfSeasons do
    begin

//Progress notifications
      Number:=NrOfYears;
      Advance:=M;
      if not Progr1 and (Advance>=Number/3) then
      begin
        MainForm.GeneralWait_Memo.Lines.Add(' Still busy ....');
        Progr1:=true;
        sleep (500);
      end;
      if not Progr2 and (Advance>=2*Number/3) then
      begin
        MainForm.GeneralWait_Memo.Lines.Add(' Almost done ...');
        Progr2:=true;
        sleep (500);
      end;
      if Advance>Number/4 then
      begin
        MainForm.ProgressBar1.Position:=40;
      end;
      if Advance>Number/2 then
      begin
        MainForm.ProgressBar1.Position:=50;
      end;
      if Advance>3*Number/4 then
      begin
        MainForm.ProgressBar1.Position:=60;
      end;
      if Advance>9*Number/10 then
      begin
        MainForm.ProgressBar1.Position:=70;
      end;

//Converting seasonal hydrologic data into averages per time step
      ConvertToDaily (Y);

//Zero settings of seasonal sums of values
      SetToZero;

//Setting real node numbers to serial node numbers

      for i:=1 to TotNrOfPoly do
      begin
        NodeNr[i]:=SerialNodeNr[i];
        for j:=1 to NrOfNextNodes[SerialNodeNr[i]] do
            BorderNode[i,j]:=BorderNode[SerialNodeNr[i],j];
      end;

//Define external water levels depending on the season
      for K:=1 to NrOfExtPoly do
          WaterLevel[K+NrOfIntPoly]:=ExtWaterLevel[Y,K];
      for i:=1 to NrOfIntPoly do for k:=1 to NrOfNextNodes[i] do Qaq[i,k]:=0;

//Calculations per time step (day or less, depending on accuracy)
//within the season
      NrOfDays:=SeasonDuration[Y]*MonthlySteps;
      Days:=round(NrOfDays);
      for CountIt:=1 to Days do
      begin

//Calculations per time step over the nodal areas (K)
        for K:=1 to NrOfIntPoly do
        begin
//Resetting evaporation to the original values, it might have been changed
          EvapA[Y,K]:=EpA0[Y,K];
          EvapB[Y,K]:=EpB0[Y,K];
          EvapU[Y,K]:=EpU0[Y,K];
//Reducing evaporation from unirrigated land when the land becomes
//very salty
          if SCrU[K]>25 then EvapU[Y,K]:=EPu0[Y,K]*5/sqrt(SCrU[K]);

//Water balances above aquifer with secondary procedures
          TopWaterbalances (Y,K,M);

//Water balances in the aquifer with secondary procedures
          GroundWaterModel (Y,K);
          if AccErr then exit;

//In case of insufficient accuracy, Again=true, adjust values, and start again
          if Again then
          begin
            ConvToSeasonal (Y);         {convert daily values back to seasonal}
            MonthlySteps:=2*MonthlySteps;    {increase the number of timesteps}
            CF:=MonthlySteps/30;
//Adjusting time dependent parameters
            for j:=1 to NrOfIntPoly do
            begin
              ReactAbove[j]:=ReactAbove[j]/CF;     {red. drain. react. fact. 1}
              ReactBelow[j]:=ReactBelow[j]/CF;     {red. drain. react. fact. 2}
              VertCond[j]:=Vertcond[j]/CF;      {red. vert. hydr. cond. s.conf}
              for ij:=1 to NrOfNextNodes[j] do
              begin                                     {red. hor. hydr. cond.}
                Conduct[ij,j]:=Conduct[ij,j]/CF;      {red. hydr. cond. aquif.}
                TopCond[ij,j]:=TopCond[ij,j]/CF;      {red. hydr. cond tr.zone}
              end;
            end;
            goto 1;
          end; {if Again then}

//Calculating salt conc. of incoming grwt. flow per time step for use in
//salt balance
          if HIGD>0 then ZIG:=SGID/HIGD;                      {through aquifer}
          if HITD>0 then ZIT:=STID/HITD;                  {through trans. zone}
          SCRA0:=ScrA[K];
          SCRB0:=ScrB[K];
          SCRU0:=ScrU[K];

//Calculating salt balances
          SaltBalances (Y, K);

//Summation of daily into seasonal values
          Summations (Y, K);

//Proceed with the next internal node (K=K+1) at the same timestep
//Timestep = 30/MonthlySteps
        end; {for K:=1 to NrOfIntPoly do}

//At the end of the time step: new water levels
        for k:=1 to NrOfIntPoly do
        begin
          WaterLevel[k]:=WaterLevel[k]+StorWL[k]/EffPor[k];
          if Aquifertype[k]=1 then                              {semi confined}
             WaterPress[k]:=WaterPress[k]+StorAq[k]/EffPorSc[k];
        end;

//Proceed with the next day or timestep within the season (CountIt=CountIt+1)
//Timestep:=30/MonthlySteps
      end; {for CountIt:=1 to Days do}

//START OF END-OF-SEASON CHECKS AND CALCULATIONS

//At the end of the season: Checking waterlevel
      for k:=1 to NrOfIntPoly do
          if WaterLevel[k]<BottomLevel[k] then
          begin
            Error:=true;
            writeln (ErrorFile,' Watertable in season ',Y:3,' in node ',K:3,
                               ' reached bottom of aquifer.');
            writeln (ErrorFile,'     Abstraction is excessive.');
            writeln (ErrorFile);
          end;

//At the end of the season: re-converting hydrologic values per time step
//into seasonal data
      ConvToSeasonal (Y);

//At the end of the season: Determining index for output writing
      OutputIndex:=0;
      if AnnualCalc then OutputIndex:=1;
      if not AnnualCalc then if (M=1) or (OutputTimestep=1) then OutputIndex:=1;
      if OutputTimestep>1 then
         for j:=1 to NrOfYears do
             if M=j+OutputTimestep then OutputIndex:=1;
//At the end of the season: final calculations and output writing per polygon K
      for K:=1 to NrOfIntPoly do
      begin
//At the end of the season: Rename seasonal values for output writing
        SeasonalRename (Y,K);
        PLT:=PLA*AreaA[Y,K]+PLB*AreaB[Y,K]+PLU*AreaU[Y,K];
        CAT:=CAA*AreaA[Y,K]+CAB*AreaB[Y,K]+CAU*AreaU[Y,K];
//Seasonal average depth of water table
        DWT:=DwtT[K]/Days;
//Preparations for output writing
        if OutputIndex=1 then                         {Output is to be written}
        begin
//At the end of the season: calculating seasonal irrigation efficiencies
//and sufficiencies for the outputfile
          IrrEff_Suff (K, Y);                            {In unit UInitialCalc}
//At the end of the season: calculating seasonal average salt conc. of
//incoming grwt. flow through aquifer (ZIG) and trans. zone (ZIT) for output
          ZIG:=0;
          IF HIGT[K]>0.000001 then ZIG:=SGIT[K]/HIGT[K];
          ZIT:=0;
          IF HITT[K]>0.000001 then ZIT:=STIT[K]/HITT[K];
//At the end of the season: calculating seasonal salt conc. of
//drain, irrigation and well water for output
          ZDR:=0;
          IF DRT>0.000001 then ZDR:=ZDRT[K]/DRT;
          ZIR:=0;
          IF CITT[K]>0.0000001 then ZIR:=ZIRT[K]/CITT[K];
          Zwell:=0;
          IF WellDis[Y,K]>0.0000001 then Zwell:=ZWLT[K]/WellDis[Y,K];
//Resetting serial node numbers to real node numbers
          setlength (NodalNr,TotNrOfPoly+1);
          if YearNr=1 then for i:=1 to NrOfIntPoly do
          begin
            NodeNr[i]:=NodalNr[i];
            for j:=1 to NrOfNextNodes[SerialNodeNr[i]] do
               BorderNode[i,j]:=NextNode[i,j];
          end;

//Writing output
          WriteOutput (K, Y, M);                         {In unit UInitialCalc}
//Writing frequency distribution of soil salinity to the *.Frq file
          WriteFrequency (K, Y, M);                      {In unit UInitialCalc}
//Writing groundwater flow from one node to the neighbor in m3/season
//to the *.Gwt file
          WriteGwtFile (K, Y, M);                        {In unit UInitialCalc}
        end; {if OutputIndex=1 then}

//At the end of the season: reducing irrigation when the water table rises
//to the soil surface
//          if DWT<0.3 then ReduceIrr (Y,K);
// {this comes under farmers responses}

//Reference value of WellDischarge
          Wel0:=WellDis[Y,K];
//At the end of the season: reducing the pumping from wells when the waterlevel
//drops
          if not WellWarning and (WaterLevel[K]>10) and
             (HF0[K]<5) and (Wel0>0.1) then
          begin
//              WellDis[Y,K]:=1.1*WellDis[Y,K]*WaterLevel[K]/HF0[K];
//              if WellDis[Y,K]<0.001 then WellDis[Y,K]:=0;
              WellReduced:=true;
              AllWarning:=true;
              WellTxt := inttostr (K);
              WellTxt := ' As the water table drops in polygon: '+WellTxt+
                         ', the well discharge needs to be reduced here.';
              WarningForm.WarningMemo.Lines.Add ('');
              WarningForm.WarningMemo.Lines.Add (WellTxt);
              WarningForm.WarningMemo.Lines.Add ('');
          end;
(*
//Restoring pumping when the water table rises again
          if {(ResponsIndex[K]=1) and} (WaterLevel[K]>HFR[K]) then
              WellDis[Y,K]:=1.1*WellDis[Y,K];
          if WellDis[Y,K]>WEL0 then WellDis[Y,K]:=WEL0;
          if WaterLevel[K]<HFR[K] then HFR[K]:=WaterLevel[K];
*)
//At the end of the season: Calculating unirrigated area fractions and
//the smallest yearly area fractions, and changing the value of
//of RotationType if required by the ResponsIndex
        if ResponsIndex[K]=1 then
        begin

//Decreasing the seasonal irrigated area fractions when no reclamation
//takes place (ResponsIndex=1) and salinization occurs, reducing the irrigation,
//the reverse when salinity decreases again
//Reducing the irrigation when waterlogging occurs
          FarmResponses (Y, K);

          if (Y=NrOfSeasons) and (InclIndex[k]=1) then
//At the end of the last season: Calculating unirrigated area fractions and
//the smallest yearly area fractions, and changing the value of the rotation
//index if required,
//setting the initial salinity conditions depending on rotation index though
//procedure InitSalinity in procedure AdjustRotation
           begin
             AdjustRotation;
             AreaU[Y,K]:=1-AreaA[Y,K]-AreaB[Y,K];
           end;

        end; {if ResponsIndex[K]=1 then}

      end;{for k:=1 to NrOfIntPoly do}

      if RotaChanged then RotaWarning:=true;
      if IrrReduced then IrrWarning:=true;
      if WellReduced then WellWarning:=true;
      if ReUseReduced then ReUseWarning:=true;
      if AreaReduced then AreaWarning:=true;
      if ExcessNoted then ExcessWarning:=true;

//At the end of the season and after dealing with all polygons: writing
//transfer values to storage file used when increasing nr. of time steps
      Assignfile (StoreFile,'Storage.dat');
      rewrite (StoreFile);
      for i:=1 to NrOfIntPoly do
      begin
        writeln (StoreFile,WaterLevel[i],' ',WaterPress[i],' ',SalY[i]);
        writeln (StoreFile,SCrA[i],' ',SCrB[i],' ',SCrU[i]);
        writeln (StoreFile,SCtU[i],' ',SCtL[i],' ',SCtr[i],' ',SCaq[i]);
      end;
      closefile(StoreFile);

//Restoring time dependent parameters when nr. of timesteps was increased
      if MonthlySteps>30 then
      begin
        CF:=MonthlySteps/30;
        for j:=1 to NrOfIntPoly do
        begin
          ReactAbove[j]:=ReactAbove[j]*CF;    {restoring drain. react. fact. 1}
          ReactBelow[j]:=ReactBelow[j]*CF;    {restoring drain. react. fact. 2}
          VertCond[j]:=Vertcond[j]*CF;     {restoring vert. hydr. cond. s.conf}
          for ij:=1 to NrOfNextNodes[j] do
          begin                                    {restoring hor. hydr. cond.}
            Conduct[ij,j]:=Conduct[ij,j]*CF;     {restoring hydr. cond. aquif.}
            TopCond[ij,j]:=TopCond[ij,j]*CF;     {restoring hydr. cond tr.zone}
          end;
        end;
        MonthlySteps:=30;
      end;

//Proceed with the next season (Y=Y+1) within the year
    end; {for Y:=Start to NrOfSeasons do}

//At the start of a new year: closing outputfiles in case of error, then exit
    if Error then
    begin
      closefile (ErrorFile);
      closefile (OutputFile);
      closefile (FrqFile);
      closefile (GwtFile);
      if fileexists ('Storage.dat') then deletefile ('Storage.dat');
      exit;
    end;

//Proceed to next year (M=M+1)
  end; {for M:=1 to NrOfYears do}

//AT END OF LAST YEAR: END OF CALCULATIONS
  closefile (ErrorFile);
  closefile (OutputFile);
  closefile (FrqFile);
  closefile (GwtFile);
  if fileexists ('Storage.dat') then deletefile ('Storage.dat');
  if not AnnualCalc and (YearNr=NrOfYears) then YearNr:=0;

end; {with DataMod do}
end; {procedure  MainCalculations}


//Procedures used inside procedure MainCalculations

procedure SetSalinity;
var i : integer; Uarea : real;
begin

  for i:=1 to DataMod.NrOfIntPoly do with DataMod do
  begin
    Uarea:=1-AreaA[1,i]-AreaB[1,i];               {Sum=Uarea}
    begin
      if (RotationType[i]=1) then
         if (Uarea>0.999) then                    {Sum=Uarea}
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
end; {with DataMod do}



procedure TopWaterBalances (j, i, m : integer);
//label 1;
var
    YearTxt, PolyTxt, SeasonTxt : string;
    
begin with DataMod do
begin
  DWT:=SurfLevel[i]-WaterLevel[i];
  DWT0:=DWT;
  RootzoneHydrology (i,j);                               {in unit UInitialCalc}
  DrainDischarge (i,j);                                  {in unit UInitialCalc}
//Adjusting excess drainage reuse DRR. Giving warning in year m=1
  if not ReUseWarning then if (DrainIndex[i]=1) and (DRT<ReUseDr[j,i]) then
  if m=1 then
  begin
    ReUseDr[j,i]:=DrT;
    AllWarning:=true;
    ReUseReduced:=true;
    WarningForm.Visible:=false;
    YearTxt := inttostr (m);
    PolyTxt := inttostr (i);
    SeasonTxt := inttostr (j);
    YearTxt := ' The total drainage in year '+Yeartxt;
    SeasonTxt := ' in season '+SeasonTxt;
    PolyTxT:= ' and node '+YearTxt+' is less than the drainage water'+
              ' re-used for irrigation.';
    WarningForm.WarningMemo.Lines.Add ('');
    WarningForm.WarningMemo.Lines.Add (YearTxt+PolyTxt+SeasonTxt);
    SeasonTxt := '   The drainage re-use (DRR) is adjusted.';
    WarningForm.WarningMemo.Lines.Add (SeasonTxt);
  end; {if (DrainIndex[i]=1) and (DRT<ReUseDr[j,i]) then if m=1 then}
end; {with Datamod do}
end; {procedure TopWaterBalances}


procedure GroundWaterModel (j, i : integer);
var Href, D1, D2, D3, Qseep, CC : real;
begin with DataMod do
begin
  GroundwaterFlow (i,j);                         {in unit UinitialCalc}
//Determining applicable effective porosity
  Href:=WaterLevel[i]-BottomLevel[i];
  D1:=Aqu1;
  D2:=D1+TranZone[i];
  D3:=D2+RootZone[i];
  if Href<D1 then EffPor[i]:=EffPorAq[i]
  else
    if Href<D2 then
    begin
      if AquiferType[i]=0 then EffPor[i]:=EffPorTr[i]
      else EffPor[i]:=EffPorSc[i];
    end
      else
      if Href<D3 then EffPor[i]:=EffPorRo[i]
      else
        EffPor[i]:=1;
//Determining semi-confined seepage flow, storages and waterlevels
  Qseep:=0;
  StorWL[i]:=0;
  if Aquifertype[i]=1 then                           {aquifer is semi-confined}
  begin
    if WaterLevel[i]>Ltr1 then                          {flow is semi-confined}
    begin
      CC:=Dsc1/VertCond[i];                          {resistence to vert. flow}
      if CC>0 then
         Qseep:=(WaterPress[i]-WaterLevel[i]/CC);            {vertical seepage}
      StorAq[i]:=
         HIGD+Qinf[i]-HOGD-Qseep-WellDis[j,i]-Qout[i];     {storage in aquifer}
      StorWL[i]:=Rech+HITD+Qseep+PLCC-HOTD;             {storage at watertable}
    end else {WaterLevel[i]<=Ltr1}
//The water table is inside the aquifer and the flow is unconfined
    begin
      StorAq[i]:=0;
      StorWL[i]:=Rech+HIGD+PLCC+Qinf[i]-HOGD-WellDis[j,i]-Qout[i];
    end;
  end {if Aquifertype=1}
  else
    StorWL[i]:=Rech+HIGD+HITD+PLCC+Qinf[i]-HOGD-HOTD-WellDis[j,i]-Qout[i];
//Adjustment incoming salt for seepage flow
  if AquiferType[i]=1 then
  begin
    STID:=STID+Qseep*LeachEffTr[i];
    SGID:=SGID-Qseep*LeachEffTr[i];
  end;
//Restarting calculations if insufficient accuracy occurs
  if (AccuracyLevel=1) and (abs(StorWL[i])>0.1) then Again:=true;
  if (AccuracyLevel=2) and (abs(StorWL[i])>0.03) then Again:=true;
  if (AccuracyLevel=3) and (abs(StorWL[i])>0.01) then Again:=true;

  if MonthlySteps>6000 then
  begin
    AssignFile (AccFile,'accuracy.err');
    rewrite (AccFile);
    writeln (AccFile, ' THE FOLLOWING ERRORS WERE FOUND IN: ',SaveFileName);
    writeln (AccFile);
    writeln (AccFile,' SahysMod is unable to reach'+
                       ' sufficient accuracy due to unstability.');
    writeln (AccFile,' Perhaps some data are unrealistic.');
    writeln (AccFile,' Please check the data including the'+
                       ' initial conditions.');
    writeln (AccFile,' Check also the accuracy level'+
                       ' (see general data, model properties).');
    writeln (AccFile);
    closefile (AccFile);
    closefile (OutputFile);
    closefile (FrqFile);
    closefile (GwtFile);
    OutputFileName:=ChangeFileExt (SaveFileName,'.out');
    deletefile (OutputFileName);
    OutputFileName:=ChangeFileExt (SaveFileName,'.frq');
    deletefile (OutputFileName);
    OutputFileName:=ChangeFileExt (SaveFileName,'.gwt');
    deletefile (OutputFileName);
    AccErr:=true;
    exit;
  end;

end; {with DataMod do}
end; {procedure GroundWaterModel}


procedure SaltBalances (j, i : integer);
label 1, 2;
var Q1, Q2, SDLA, SDLB, SDLU, TotIrr, IrrT, ZIRR, SdrT, WaterIn, Zinf, Zout,
    INFA, INFB, INFU, SDAA, SDBB, SROO, PLCC, DOWN, UPWA, SCX, SCRy,
    SCMA, SCMB, SCMU, TIR, TSP, TDR, TSIU, TSCU, TSI, TSO, TSIA, TSIB,
    TCAA, TCAB, TSCA, TSCB, TPLA, TPLB, VF, VDD, VUS, SCTM, SCLM, SCUM,
    UU, IRA, IRB, IRU, SSI, TPL : real;
    XareaA,XareaB,xAreaU,TSIAx,TSIBx,TSIUx,TSCAx,TSCBx,TSCUx : real;
    SCMZ, ACC,ACCI,ACCO,TPLAx,TPLBx,TPLU,TPLUx,TCAU,Divider : real;

BEGIN with DataMod do
begin

//Salt concentration of the irrigation (ZIR) drainage (ZDR) and
//well water (Zwell)
  ZDR:=0;
  IF (DrainIndex[i]=1) AND (DRT>0.001) THEN
      ZDR:=(DRA*SCtU[i]+DRB*SCtL[i])*LeachEffTr[i]/DRT;
  Zwell:=LeachEffAq[i]*SCaq[i];
  IF WellDis[j,i]<0.001 THEN Zwell:=0;
	Q1:=CIT[j,i]-ReUseDr[j,i]-ReUseWell[j,i]*WellDis[j,i];
	Q2:=ReUseWell[j,i]*WellDis[j,i];
	TotIrr:=Q1+Q2+ReUseDr[j,i];
  if TotIrr>0.001 THEN ZIR:=(Q1*Zir+Q2*Zwell+ReUseDr[j,i]*ZDR)/(TotIrr);
  ZIRR:=ZIR;

//Surface drainage leaching efficiency
  SDLA:=(10+SCrA[i])/100;
  SDLB:=(10+SCrB[i])/100;
  SDLU:=(10+SCrU[i])/100;

//Infiltration,rainfall and surface drainage provision for waterlogging
  INFA:=IrrA[j,i];
  INFB:=IrrB[j,i];
  INFU:=SurfInflow[j,i];
  SDAA:=SurfDrA[j,i];
  SDBB:=SurfDrB[j,i];
  SROO:=SurfOutflow[j,i];
  PLCC:=PercLoss[j,i];
  DOWN:=HOGD+WellDis[j,i]+DRT-HIGD;
  UPWA:=0;
  IF DOWN<0 THEN
  BEGIN
    UPWA:=-DOWN;
    DOWN:=0;
  END;
  IF DWT<RootZone[i] THEN PLCC:=0.5*PercLoss[j,i];
  IF DWT<0 then PLCC:=0;
  IF DWT<0 THEN
  BEGIN
    INFA:=DOWN;
    INFB:=DOWN;
    INFU:=DOWN;
  END;
//Incoming water over the surface

//Salt accumulation above the soil surface and adjustment of ZIR
  UU:=1-AreaA[j,i]-AreaB[j,i];
  IrrT:=IrrA[j,i]*AreaA[j,i]+IrrB[j,i]*AreaB[j,i]+SurfInflow[j,i]*UU;
  SdrT:=SDAA*AreaA[j,i]+SDBB*AreaB[j,i]+SROO*UU;
  SCRy:=0;

  if RotationType[i]=10 THEN
     SCRy := ACarea[i]*SCrA[i]+BCarea[i]*SCrB[i]+UCarea[i]*SCrU[i]
             + (1-ACarea[i]-BCarea[i]-UCarea[i])*SCrZ[i];
  if RotationType[i]=0 THEN
     SCRy := AreaA[j,i]*SCrA[i]+AreaB[j,i]*SCrB[i]+UU*SCrU[i];
  if RotationType[i]=1 THEN SCRy := (1-UCarea[i])*SCrA[i]+UCarea[i]*SCrU[i];
  if RotationType[i]=2 THEN SCRy := ACarea[i]*SCrA[i]+(1-ACarea[i])*SCrB[i];
  if RotationType[i]=3 THEN SCRy := BCarea[i]*SCrB[i]+(1-BCarea[i])*SCrA[i];
  if RotationType[i]=4 THEN SCRy := SCrA[i];
  if RotationType[i]=5 THEN SCRy := ACarea[i]*SCrA[i]+BCarea[i]*SCrB[i]
                                    +(1-ACarea[i]-BCarea[i])*SCrZ[i];
  if RotationType[i]=6 THEN SCRy := ACarea[i]*SCrA[i]+UCarea[i]*SCrU[i]
                                    +(1-ACarea[i]-UCarea[i])*SCrZ[i];
  if RotationType[i]=7 THEN SCRy := BCarea[i]*SCrA[i]+UCarea[i]*SCrU[i]
                                    +(1-BCarea[i]-UCarea[i])*SCrZ[i];

  Zinf:=ZIR*IrrT+SCRy*UPWA;
  if SurfConc[i]=0 then SurfConc[i]:=ZIR;
  Zout:=ZIR*SDrT+SurfConc[i]*DOWN;
  SALY[i]:=SALY[i]+Zinf-Zout;                  {Storage of salt on the surface}
  WaterIn:=IrrT+Rain[j,i]-SdrT;
  SurfConc[i]:=SALY[i]/(WaterIn-DWT);
  IF (DWT>=0) AND (Dwt0>=0) THEN SurfConc[i]:=0;
  if SurfConc[i]<0 then SurfConc[i]:=0;
  SSI:=WaterIn*SurfConc[i];

//Salt concentration of water in the transition zone depending on DrainIndex
  IF DrainIndex[i]=0 THEN SCX:=SCtr[i]
  ELSE SCX:=SCtU[i];

  IRA:=IrrA[j,i];
  IRB:=IrrB[j,i];
  IRU:=SurfInflow[j,i];
  if DWT<0 then
  begin
    IRA:=0;
    IRB:=0;
    PLA:=0;
    PLB:=0;
    PLU:=0;
    CAA:=0;
    CAB:=0;
    CAU:=0;
    SDAA:=0;
    SDBB:=0;
    SROO:=0;
    IRU:=0;
  end;

//Salt concentrations in the irrigated areas (SCRA in A area, SCRB in B area)
//and in the unirrigated area (SCRU) when RotationType[i]=0
  IF RotationType[i]=0 THEN
  BEGIN
//Salt accumulation (ACC) and concentration (SCRA) in the rootzone of A area
    AuxSB1 (DOWN,UPWA,IRA,IRB,RAIN[j,i],SCMA,SCMB,SCMU,SCX,
            SDAA,SDBB,SDLA,SDLB,SDLU,IRU,SROO,SSI,i);
//Total salt percolating
    TSP:=LeachEffRo[i]*(PLA*SCMA*AreaA[j,i]+PLB*SCMB*AreaB[j,i]+PLU*SCMU*UU);
    IF DWT<0 THEN TSP:=LeachEffRo[i]*(DOWN*SCMA*AreaA[j,i]
                       +DOWN*SCMB*AreaB[j,i]+DOWN*SCMU*UU);
  END;

//Total irrigation, surface drainage
  TIR:=INFA*AreaA[j,i]+INFB*AreaB[j,i]+INFU*UU;
  TDR:=SDAA*AreaA[j,i]+SDBB*AreaB[j,i]+SROO*UU;


//Salt concentration of the fixed A (SCRA), B (SCRB) and U (SCRU) areas
//and outside (SCRZ) when RotationType=10
  IF RotationType[i]=10 THEN
  BEGIN

//Salt accumulation (ACC) and concentration (SCRA) in the rootzone of A area
   ACCI:=INFA*ZIR+CAA*LeachEffTr[i]*SCX;
   IF DWT<0 THEN ACCI:=ACCI-CAA*LeachEffRo[i]*SCRA0;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=SurfDrA[j,i]*(SDLA*SCRA0)+SCRA0*LeachEffRo[i]*PLA;
   ACC:=ACCI-ACCO;
   SCrA[i]:=SCRA0+ACC/(TotPorRo[i]*RootZone[i]);
//Finding the average salt concentration of rootzone of A
   IF ACC<0 THEN
   BEGIN
     if SCRA0<=0 then SCRA0:=0.001;
     IF SCrA[i]<=0 THEN SCrA[i]:=0.1*SCRA0;
     SCMA:=sqrt(SCRA0*SCrA[i]);
   END ELSE
     SCMA:=(SCRA0+SCrA[i])/2;

//Salt accumulation (ACC) and concentration (SCRB) in the rootzone of B area
   ACCI:=INFB*ZIR+CAB*LeachEffTr[i]*SCX;
   IF DWT<0 THEN ACCI:=ACCI-CAB*LeachEffRo[i]*SCRB0;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=SurfDrB[j,i]*(SDLB*SCRB0)+SCRB0*LeachEffRo[i]*PLB;
   ACC:=ACCI-ACCO;
   SCrB[i]:=SCRB0+ACC/(TotPorRo[i]*RootZone[i]);
//Finding the average salt concentration of rootzone of B
   IF ACC<0 THEN
   BEGIN
     if SCRB0<=0 then SCRB0:=0.001;
     IF SCrB[i]<=0 THEN SCrB[i]:=0.1*SCRB0;
     SCMB:=sqrt(SCRB0*SCrB[i]);
   END ELSE
     SCMB:=(SCRB0+SCrB[i])/2;

//Salt accumulation (ACC) and concentration (SCRU) in the rootzone of U area
   ACCI:=INFU*ZIR+CAU*LeachEffTr[i]*SCX;
   IF DWT<0 THEN ACCI:=ACCI-CAU*LeachEffRo[i]*SCRU0;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=SurfOutflow[j,i]*(SDLU*SCRU0)+SCRU0*LeachEffRo[i]*PLU;
   ACC:=ACCI-ACCO;
   SCrU[i]:=SCRU0+ACC/(TotPorRo[i]*RootZone[i]);
//Finding the average salt concentration of rootzone of U
   IF ACC<0 THEN
   BEGIN
     if SCRU0<=0 then SCRU0:=0.001;
     IF SCrU[i]<=0 THEN SCrU[i]:=0.1*SCRU0;
     SCMU:=sqrt(SCRU0*SCrU[i]);
   END ELSE
     SCMU:=(SCRU0+SCrU[i])/2;

//Salt accumulation (ACC) and concentration (SCRZ) in rootzone of outside area
   XareaA:=AreaA[j,i]-ACarea[i];
   XareaB:=AreaB[j,i]-BCarea[i];
   XareaU:=AreaU[j,i]-UCarea[i];
   Divider:=XareaU+XareaA+XareaB;
   ACCI:=(INFU*XareaU+INFA*XareaA+INFB*XareaB)*ZIR/Divider
         +(CAU*XareaU+CAA*XareaA+CAB*XareaB)*LeachEffTr[i]*SCX/Divider;
   IF DWT<0 THEN
      ACCI:=ACCI-(CAA*XareaA+CAB*XareaB+CAU*XareaU)*LeachEffRo[i]*SCRZ0/Divider;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=(SurfDrA[j,i]*XareaA*SDLA+SurfDrB[j,i]*XareaB*SDLB
         +SurfOutflow[j,i]*XareaU*SDLU+PLA*XareaA*LeachEffRo[i]
         +PLB*XareaB*LeachEffRo[i]+PLU*XareaU*LeachEffRo[i])*ScrZ0/Divider;
   ACC:=ACCI-ACCO;
   SCrZ[i]:=SCRZ0+ACC/(TotPorRo[i]*RootZone[i]);
//Finding the average salt concentration of rootzone of outside area
   IF ACC<0 THEN
   BEGIN
     if SCRZ0<=0 then SCRZ0:=0.001;
     IF SCrZ[i]<=0 THEN SCrZ[i]:=0.1*SCRZ0;
     SCMZ:=sqrt(SCRZ0*SCrZ[i]);
   END ELSE
     SCMZ:=(SCRZ0+SCrZ[i])/2;

//Total salt percolating
    TSP:=LeachEffRo[i]*(PLA*SCMA*AreaA[j,i]+PLB*SCMB*AreaB[j,i]
         + PLU*SCMU*AreaU[j,i]+SCMZ*(PLA*XareaA+PLB*XareaB+PLU*XareaU));

  END; {IF RotationType[i]=10 THEN}

//Salt concentration of the fixed A (SCRA) and B (SCRB) areas
//and outside (SCRZ) when RotationType=5
  IF RotationType[i]=5 THEN
  BEGIN
//Salt accumulation (ACC) and concentration (SCRA) in the rootzone of A area
   ACCI:=INFA*ZIR+CAA*LeachEffTr[i]*SCX;
   IF DWT<0 THEN ACCI:=ACCI-CAA*LeachEffRo[i]*SCRA0;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=SurfDrA[j,i]*(SDLA*SCRA0)+SCRA0*LeachEffRo[i]*PLA;
   ACC:=ACCI-ACCO;
   SCrA[i]:=SCRA0+ACC/(TotPorRo[i]*RootZone[i]);
   IF (SCrA[i]=0) OR (SCRA0=0) THEN SCMA:=0;
//Finding the average salt concentration of rootzone of A
   IF ACC<0 THEN
   BEGIN
     if SCRA0<=0 then SCRA0:=0.001;
     IF SCrA[i]<=0 THEN SCrA[i]:=0.1*SCRA0;
     SCMA:=sqrt(SCRA0*SCrA[i]);
   END ELSE
     SCMA:=(SCRA0+SCrA[i])/2;
//Salt accumulation (ACC) and concentration (SCRB) in the rootzone of B area
   ACCI:=INFB*ZIR+CAB*LeachEffTr[i]*SCX;
   IF DWT<0 THEN ACCI:=ACCI-CAB*LeachEffRo[i]*SCRB0;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=SurfDrB[j,i]*(SDLB*SCRB0)+SCRB0*LeachEffRo[i]*PLB;
   ACC:=ACCI-ACCO;
   SCrB[i]:=SCRB0+ACC/(TotPorRo[i]*RootZone[i]);
   IF (SCrB[i]=0) OR (SCRB0=0) THEN SCMB:=0;
//Finding the average salt concentration of rootzone of B
   IF ACC<0 THEN
   BEGIN
     if SCRB0<=0 then SCRB0:=0.001;
     IF SCrB[i]<=0 THEN SCrB[i]:=0.1*SCRB0;
     SCMB:=sqrt(SCRB0*SCrB[i]);
   END ELSE
     SCMB:=(SCRB0+SCrB[i])/2;
//Salt accumulation (ACC) and concentration (SCRZ) in rootzone of outside area
   XareaA:=AreaA[j,i]-ACarea[i];
   XareaB:=AreaB[j,i]-BCarea[i];
   Divider:=AreaU[j,i]+XareaA+XareaB;
   ACCI:=(INFU*AreaU[j,i]+INFA*XareaA+INFB*XareaB)*ZIR/Divider
         +(CAU*AreaU[j,i]+CAA*XareaA+CAB*XareaB)*LeachEffTr[i]*SCX/Divider;
   IF DWT<0 THEN
      ACCI:=ACCI-(CAA*XareaA+CAB*XareaB+CAU*AreaU[j,i])
            *LeachEffRo[i]*SCRZ0/Divider;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=(SurfDrA[j,i]*XareaA*SDLA+SurfDrB[j,i]*XareaB*SDLB
         +SurfOutflow[j,i]*AreaU[j,i]*SDLU+PLA*XareaA*LeachEffRo[i]
         +PLB*XareaB*LeachEffRo[i]+PLU*AreaU[j,i]*LeachEffRo[i])*ScrZ0/Divider;
   ACC:=ACCI-ACCO;
   SCrZ[i]:=SCRZ0+ACC/(TotPorRo[i]*RootZone[i]);
//Finding the average salt concentration of rootzone of outside area
   IF ACC<0 THEN
   BEGIN
     if SCRZ0<=0 then SCRZ0:=0.001;
     IF SCrZ[i]<=0 THEN SCrZ[i]:=0.1*SCRZ0;
     SCMZ:=sqrt(SCRZ0*SCrZ[i]);
   END ELSE
     SCMZ:=(SCRZ0+SCrZ[i])/2;

//Total salt percolating
    TSP:=LeachEffRo[i]*(TPLA*SCMA*AreaA[j,i]+TPLB*SCMB*AreaB[j,i]
         +TPLU*SCMU*AreaU[j,i]+SCMZ*(TPLAx*XareaA+TPLBx*XareaB));

  END; {IF RotationType[i]=5 THEN}

//Salt concentration of the fixed A (SCRA) and U (SCRU) areas
//and outside (SCRZ) when RotationType=6
  IF RotationType[i]=6 THEN
  BEGIN

//Salt accumulation (ACC) and concentration (SCRB) in the rootzone of B area
   ACCI:=INFB*ZIR+CAB*LeachEffTr[i]*SCX;
   IF DWT<0 THEN ACCI:=ACCI-CAB*LeachEffRo[i]*SCRB0;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=SurfDrB[j,i]*(SDLB*SCRB0)+SCRB0*LeachEffRo[i]*PLB;
   ACC:=ACCI-ACCO;
   SCrB[i]:=SCRB0+ACC/(TotPorRo[i]*RootZone[i]);
   IF (SCrB[i]=0) OR (SCRB0=0) THEN SCMB:=0;
//Finding the average salt concentration of rootzone of B area
   IF ACC<0 THEN
   BEGIN
     if SCRB0<=0 then SCRB0:=0.001;
     IF SCrB[i]<=0 THEN SCrB[i]:=0.1*SCRB0;
     SCMB:=sqrt(SCRB0*SCrB[i]);
   END ELSE
     SCMB:=(SCRB0+SCrB[i])/2;

//Salt accumulation (ACC) and concentration (SCRU) in the rootzone of U area
   ACCI:=INFU*ZIR+CAU*LeachEffTr[i]*SCX;
   IF DWT<0 THEN ACCI:=ACCI-CAU*LeachEffRo[i]*SCRU0;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=SurfOutflow[j,i]*(SDLU*SCRU0)+SCRU0*LeachEffRo[i]*PLU;
   ACC:=ACCI-ACCO;
   SCrU[i]:=SCRU0+ACC/(TotPorRo[i]*RootZone[i]);
   IF (SCrU[i]=0) OR (SCRU0=0) THEN SCMU:=0;
//Finding the average salt concentration of rootzone of U
   IF ACC<0 THEN
   BEGIN
     if SCRU0<=0 then SCRU0:=0.001;
     IF SCrU[i]<=0 THEN SCrU[i]:=0.1*SCRU0;
     SCMU:=sqrt(SCRU0*SCrU[i]);
   END ELSE
     SCMU:=(SCRU0+SCrU[i])/2;

//Salt accumulation (ACC) and concentration (SCRZ) in rootzone of outside area
   XareaA:=AreaA[j,i]-ACarea[i];
   XareaU:=AreaU[j,i]-UCarea[i];
   Divider:=XareaU+XareaA+AreaB[j,i];
   ACCI:=(INFU*XareaU+INFA*XareaA+INFB*AreaB[j,i])*ZIR/Divider
         +(CAU*XareaU+CAA*XareaA+CAB*AreaB[j,i])*LeachEffTr[i]*SCX/Divider;
   IF DWT<0 THEN
      ACCI:=ACCI-(CAA*XareaA*SCRA0+CAB*AreaB[j,i]*SCRB0+CAU*XareaU*SCRU0)
                 *LeachEffRo[i]*SCRZ0/Divider;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=(SurfDrA[j,i]*XareaA*SDLA+SurfDrB[j,i]*AreaB[j,i]*SDLB
         +SurfOutflow[j,i]*XareaU*SDLU+PLA*XareaA*LeachEffRo[i]
         +PLB*AreaB[j,i]*LeachEffRo[i]+PLU*XareaU*LeachEffRo[i])*ScrZ0/Divider;
   ACC:=ACCI-ACCO;
   SCrZ[i]:=SCRZ0+ACC/(TotPorRo[i]*RootZone[i]);
   IF (SCrZ[i]=0) OR (SCRZ0=0) THEN SCRZ0:=0;

//Finding the average salt concentration of rootzone of outside area
   IF ACC<0 THEN
   BEGIN
     if SCRZ0<=0 then SCRZ0:=0.001;
     IF SCrZ[i]<=0 THEN SCrZ[i]:=0.1*SCRZ0;
     SCMZ:=sqrt(SCRZ0*SCrZ[i]);
   END ELSE
     SCMZ:=(SCRZ0+SCrZ[i])/2;

//Total salt percolating
    TSP:=LeachEffRo[i]*(TPLA*SCMA*AreaA[j,i]+TPLB*SCMB*AreaB[j,i]
         + TPLU*SCMU*AreaU[j,i]+SCMZ*(TPLAx*XareaA+TPLUx*XareaU));

  END; {IF RotationType[i]=6 THEN}


//Salt concentration 0f the fixed B (SCRB) and U (SCRU) areas
//and outside (SCRZ) when RotationType=7
  IF RotationType[i]=7 THEN
  BEGIN

//Salt accumulation (ACC) and concentration (SCRB) in the rootzone of B area
   ACCI:=INFB*ZIR+CAB*LeachEffTr[i]*SCX;
   IF DWT<0 THEN ACCI:=ACCI-CAB*LeachEffRo[i]*SCRB0;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=SurfDrB[j,i]*(SDLB*SCRB0)+SCRB0*LeachEffRo[i]*PLB;
   ACC:=ACCI-ACCO;
   SCrB[i]:=SCRB0+ACC/(TotPorRo[i]*RootZone[i]);
   IF (SCrB[i]=0) OR (SCRB0=0) THEN SCMB:=0;
//Finding the average salt concentration of rootzone of B
   IF ACC<0 THEN
   BEGIN
     if SCRB0<=0 then SCRB0:=0.001;
     IF SCrB[i]<=0 THEN SCrB[i]:=0.1*SCRB0;
     SCMB:=sqrt(SCRB0*SCrB[i]);
   END ELSE
     SCMB:=(SCRB0+SCrB[i])/2;

//Salt accumulation (ACC) and concentration (SCRU) in the rootzone of U area
   ACCI:=INFU*ZIR+CAU*LeachEffTr[i]*SCX;
   IF DWT<0 THEN ACCI:=ACCI-CAU*LeachEffRo[i]*SCRU0;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=SurfOutflow[j,i]*(SDLU*SCRU0)+SCRU0*LeachEffRo[i]*PLU;
   ACC:=ACCI-ACCO;
   SCrU[i]:=SCRU0+ACC/(TotPorRo[i]*RootZone[i]);
   IF (SCrU[i]=0) OR (SCRU0=0) THEN SCMU:=0;
//Finding the average salt concentration of rootzone of U
   IF ACC<0 THEN
   BEGIN
     if SCRU0<=0 then SCRU0:=0.001;
     IF SCrU[i]<=0 THEN SCrU[i]:=0.1*SCRU0;
     SCMU:=sqrt(SCRU0*SCrU[i]);
   END ELSE
     SCMU:=(SCRU0+SCrU[i])/2;

//Salt accumulation (ACC) and concentration (SCRZ) in rootzone of outside area
   XareaB:=AreaB[j,i]-BCarea[i];
   XareaU:=AreaU[j,i]-UCarea[i];
   Divider:=XareaU+AreaA[j,i]+XareaB;
   ACCI:=(INFU*XareaU+INFA*AreaA[j,i]+INFB*XareaB)*ZIR/Divider
         +(CAU*XareaU+CAA*AreaA[j,i]+CAB*XareaB)*LeachEffTr[i]*SCX/Divider;
   IF DWT<0 THEN
      ACCI:=ACCI-(CAA*AreaA[j,i]*SCRA0+CAB*XareaB*SCRB0+CAU*XareaU*SCRU0)
                 *LeachEffRo[i]*SCRZ0/Divider;
   IF (DWT>=0) AND (Dwt0<0) THEN ACCI:=ACCI+SALY[i];
   ACCO:=(SurfDrA[j,i]*AreaA[j,i]*SDLA+SurfDrB[j,i]*XareaB*SDLB
         +SurfOutflow[j,i]*XareaU*SDLU+PLA*AreaA[j,i]*LeachEffRo[i]
         +PLB*XareaB*LeachEffRo[i]+PLU*XareaU*LeachEffRo[i])*SCRZ0/Divider;
   ACC:=ACCI-ACCO;
   SCrZ[i]:=SCRZ0+ACC/(TotPorRo[i]*RootZone[i]);
   IF (SCrZ[i]=0) OR (SCRZ0=0) THEN SCRZ0:=0;
//Finding the average salt concentration of rootzone of outside area
   IF ACC<0 THEN
   BEGIN
     if SCRZ0<=0 then SCRZ0:=0.001;
     IF SCrZ[i]<=0 THEN SCrZ[i]:=0.1*SCRZ0;
     SCMZ:=sqrt(SCRZ0*SCrZ[i]);
   END ELSE
     SCMZ:=(SCRZ0+SCrZ[i])/2;

//Total salt percolating
    TSP:=LeachEffRo[i]*(TPLA*SCMA*AreaA[j,i]+TPLB*SCMB*AreaB[j,i]
         + TPLU*SCMU*AreaU[j,i]+SCMZ*(TPLBx*XareaB+TPLUx*XareaU));

  END; {IF RotationType[i]=7 THEN}


//Salt concentration (SCRU) in the permanent fallow area and in the
//rotationally irrigated A and B area (SCrA) when RotationType=1
  IF RotationType[i]=1 THEN
  BEGIN

    if i=10 then
       ZIR:=ZIR+0.001;

    TSIU:=INFU*ZIR-SurfOutflow[j,i]*(SDLU*SCrU[i]);
    IF DWT<0 THEN TSIU:=DOWN*ZIR+UPWA*LeachEffTr[i]*SCX;
    IF (DWT>0) AND (DWT0<=0) THEN TSIU:=SSI;
    TSCU:=CAU*LeachEffTr[i]*SCX;
    IF DWT<0 THEN TSCU:=UPWA*LeachEffTr[i]*SCX;
    IF UCarea[i]<0.999 THEN
    BEGIN
      TSI:=(TIR-INFU*UCarea[i])*ZIR;
      TSO:=(TDR-SurfOutflow[j,i]*UCarea[i])*(SDLA*SCrA[i]);
      TSIA:=(TSI-TSO)/(1-UCarea[i]);
      IF DWT<0 THEN TSIA:=DOWN*ZIR+UPWA*LeachEffTr[i]*SCX;
      IF (DWT>0) AND (DWT0<=0) THEN TSIA:=SSI;
      TCAA:=(CAT-CAU*UCarea[i])/(1-UCarea[i]);
      TSCA:=TCAA*LeachEffTr[i]*SCX;
      IF DWT<0 THEN TSCA:=UPWA*LeachEffTr[i]*SCX;
      TPLA:=(PLT-PLU*UCarea[i])/(1-UCarea[i]);
      if DWT<0 then TPLA:=DOWN;
    END ELSE
    BEGIN
      TSIA:=0;
      TSCA:=0;
      TPLA:=0;
    END;
    AuxSB2 (UCarea[i],SCrA[i],SCMA,SCRA0,SCrU[i],SCMU,SCRU0,TSCA,TSCU,
            TSIA,TSIU,TPLA,PLU,i);
//Total salt percolating
    TSP:=LeachEffRo[i]*(TPLA*SCMA*(1-UCarea[i])+PLU*SCMU*UCarea[i]);
    IF DWT<0 THEN TSP:=LeachEffRo[i]*(DOWN*SCMA*(1-UCarea[i])
                       +DOWN*SCMU*UCarea[i]);
  END; {IF RotationType[i]=1 THEN}

  IF RotationType[i]=2 THEN
  BEGIN

    TSIA:=INFA*ZIR-SurfDrA[j,i]*(SDLA*SCrA[i]);
    IF DWT<0 THEN TSIA:=DOWN*ZIR+UPWA*LeachEffTr[i]*SCX;
    IF (DWT>0) AND (DWT0<=0) THEN TSIA:=SSI;
    TSCA:=CAA*LeachEffTr[i]*SCX;
    IF DWT<0 THEN TSCA:=UPWA*LeachEffTr[i]*SCX;
    TPLA:=PLA;
    if DWT<0 then TPLA:=DOWN;
    IF ACarea[i]<0.999 THEN        {Incoming and outgoing salt in mixed area}
    BEGIN
      TSI:=(TIR-INFA*ACarea[i])*ZIR;
      TSO:=(TDR-SurfDrA[j,i]*ACarea[i])*(SDLA*SCrA[i]);
      TSIB:=(TSI-TSO)/(1-ACarea[i]);
      IF DWT<0 THEN TSIB:=DOWN*ZIR+UPWA*LeachEffTr[i]*SCX;
      IF (DWT>0) AND (DWT0<=0) THEN TSIB:=SSI;
      TCAB:=(CAT-CAA*ACarea[i])/(1-ACarea[i]);
      TSCB:=TCAB*LeachEffTr[i]*SCX;
      IF DWT<0 THEN TSCB:=UPWA*LeachEffTr[i]*SCX;
      TPLB:=(PLT-PLA*ACarea[i])/(1-ACarea[i]);
      if DWT<0 then TPLB:=DOWN;
    END ELSE
    BEGIN
      TSIB:=0;
      TSCB:=0;
      TPLB:=0;
    END;

    AuxSB2 (ACarea[i],SCrB[i],SCMB,SCRB0,SCrA[i],SCMA,SCRA0,TSCB,TSCA,
            TSIB,TSIA,TPLB,PLA,i);
(*

//The code hereunder can replace the call to AUXSB2

   IF ACarea[i]>0.999 THEN
   BEGIN
     SCrB[i]:=SCRB0;
     GOTO 2;
   END;

//Salt accumulation and concentration in the rootzone, mixed area
   ACC:=TSIB-TPLB*LeachEffRo[i]*SCRB0+TSCB;
   SCrB[i]:=SCRB0+ACC/(TotPorRo[i]*RootZone[i]);
   IF (SCrB[i]=0) OR (SCRB0=0) THEN
   BEGIN
     SCMB:=0;
     GOTO 1;
   END;

//Finding the average salt conc. of rootzone stepwise, mixed area
   IF ACC<0 THEN
   BEGIN
     if SCrB[i]<=0 then SCrB[i]:=0.001;
     SCMB:=sqrt(SCRB0*SCrB[i]);
   END ELSE
     SCMB:=(SCRB0+SCrB[i])/2;

1: IF ACarea[i]<0.001 THEN
   BEGIN
     SCrA[i]:=SCRA0;
     exit;
   END;

//Salt accumulation and concentration in the rootzone, fixed area
2: ACC:=TSIA-TPLA*LeachEffRo[i]*SCRA0+TSCA;
   if SCrA[i]>16 then ACC:=4*ACC/sqrt(SCrA[i]);
   SCrA[i]:=SCRA0+ACC/(TotPorRo[i]*RootZone[i]);
   IF (SCrA[i]=0) OR (SCRA0=0) THEN
   BEGIN
     SCMA:=0;
     exit;
   END;

//Finding the average salt conc. in the rootzone fixed area
   IF ACC<0 THEN
   BEGIN
     if SCrA[i]<=0 then SCrA[i]:=0.001;
     SCMA:=sqrt(SCRA0*SCrA[i]);
   END ELSE
     SCMA:=(SCRA0*SCrA[i])/2;
*)

//Total salt percolating
    TSP:=LeachEffRo[i]*(PLA*SCMA*ACarea[i]+TPLB*SCMB*(1-ACarea[i]));
    IF DWT<0 THEN TSP:=LeachEffRo[i]*(DOWN*SCMA*ACarea[i]
                       +DOWN*SCMB*(1-ACarea[i]));
  END; {IF RotationType[i]=2 THEN}

  IF RotationType[i]=3 THEN
  BEGIN
    TSIB:=INFB*ZIR-SurfDrB[j,i]*(SDLB*SCrB[i]);
    IF DWT<0 THEN TSIB:=DOWN*ZIR+UPWA*LeachEffTr[i]*SCX;
    IF (DWT>0) AND (DWT0<=0) THEN TSIB:=SSI;
    TSCB:=CAB*LeachEffTr[i]*SCX;
    IF DWT<0 THEN TSCB:=UPWA*LeachEffTr[i]*SCX;
    IF ACarea[i]<0.999 THEN
    BEGIN
      TSI:=(TIR-INFB*BCarea[i])*ZIR;
      TSO:=(TDR-SurfDrB[j,i]*BCarea[i])*(SDLB*SCrB[i]);
      TSIA:=(TSI-TSO)/(1-BCarea[i]);
      IF DWT<0 THEN TSIA:=DOWN*ZIR+UPWA*LeachEffTr[i]*SCX;
      IF (DWT>0) AND (DWT0<=0) THEN TSIA:=SSI;
      TCAA:=(CAT-CAB*BCarea[i])/(1-BCarea[i]);
      TSCA:=TCAA*LeachEffTr[i]*SCX;
      IF DWT<0 THEN TSCA:=UPWA*LeachEffTr[i]*SCX;
      TPLA:=(PLT-PLB*BCarea[i])/(1-BCarea[i]);
      if DWT<0 then TPLA:=DOWN;
    END ELSE
    BEGIN
      TSIA:=0;
      TSCA:=0;
      TPLA:=0;
    END;
    AuxSB2 (BCarea[i],SCrA[i],SCMA,SCRA0,SCrB[i],SCMB,SCRB0,TSCA,TSCB,
            TSIA,TSIB,TPLA,PLB,i);
//Total salt percolating
    TSP:=LeachEffRo[i]*(TPLA*SCMA*(1-BCarea[i])+PLB*SCMB*BCarea[i]);
    IF DWT<0 THEN TSP:=LeachEffRo[i]*(DOWN*SCMA*(1-BCarea[i])
                       +DOWN*SCMB*BCarea[i]);
  END; {IF RotationType[i]=3 THEN}

//Salt concentration in the rootzone (SCRA) when full rotation occurs
  IF RotationType[i]=4 THEN
  BEGIN
    TSI:=TIR*ZIR+CAT*LeachEffTr[i]*SCX-TDR*(SDLA*SCrA[i]);
    IF DWT<0 THEN TSI:=UPWA*LeachEffTr[i]*SCX;
    IF (DWT>=0) AND (Dwt0<0) then TSI:=SSI;
    TPL:=PLT;
    IF DWT<0 THEN TPL:=DOWN;
    AuxSB3 (TPL,SCrA[i],SCMA,TSI,i);
//Total salt percolating
    TSP:=LeachEffRo[i]*PLT*SCMA;
    IF DWT<0 THEN TSP:=LeachEffRo[i]*DOWN*SCMA;
  END;

//Determining the vertical upward seepage from or the vertical downward
//drainage to the aquifer
  VF:=HIGD-HOGD-WellDis[j,i];
  IF VF<0 THEN
  BEGIN
    VDD:=ABS(VF);
    VUS:=0;
  END ELSE
  BEGIN
    VUS:=VF;
    VDD:=0;
  END;

//Salt concentration in of the water in the transition zone (SCtr) when
//there is no drainage system (DrainIndex=0)
  IF DrainIndex[i]=0 THEN
     AuxSB4A (PLCC,SCTM,TSP,VDD,VUS,i)
  ELSE
//Salt concentration in the upper (SCU) and lower (SCtL) transition zone
//when a drainage system is present (DrainIndex=1)
     AuxSB4B (PLCC,SCaq[i],SCtL[i],SCLM,SCtU[i],SCUM,TSP,VDD,VUS,i);

//Salt concentration of the drainage water
  ZDR:=0;
  IF (DrainIndex[i]=1) AND (DRT>0.001) THEN
      ZDR:=(DRA*SCUM+DRB*SCLM)*LeachEffTr[i]/DRT;

//Salt concentration of the water in the aquifer (SCaq)
  AuxSB5 (HIGD,HOGD,PLCC,PLT,SCLM,SCTM,VDD,VUS,WellDis[j,i],ZIG,ZIR,i);
//Final corrections
  IF (DWT>=0) AND (Dwt0<0) THEN ZIR:=ZIR+SALY[i]/(TIR+RAIN[j,i]-TDR-Dwt0);
  NoIrr:=false;
  IF (DWT>=0) AND (Dwt0>=0) THEN
      IF (INFA*AreaA[j,i]=0) AND (INFB*AreaB[j,i]=0) THEN NoIrr:=true;
  IF DWT>=0 THEN SALY[i]:=0;
  ZIR:=ZIRR;
end; {with DataMod do}
END; {SaltBalances}
{-----------------}



//Auxiliary procedures

procedure ConvertToDaily (j : integer);
var n : integer;
begin with DataMod do
begin
  for n:=1 to NrOfIntPoly do
  begin
    CIR[j,n]:=CIR[j,n]/(MonthlySteps*SeasonDuration[j]);
    CIT[j,n]:=CIT[j,n]/(MonthlySteps*SeasonDuration[j]);
    EvapA[j,n]:=EpA0[j,n]/(MonthlySteps*SeasonDuration[j]);
    EvapB[j,n]:=EpB0[j,n]/(MonthlySteps*SeasonDuration[j]);
    EvapU[j,n]:=EpU0[j,n]/(MonthlySteps*SeasonDuration[j]);
    EpA0[j,n]:=EpA0[j,n]/(MonthlySteps*SeasonDuration[j]);
    EpB0[j,n]:=EpB0[j,n]/(MonthlySteps*SeasonDuration[j]);
    EpU0[j,n]:=EpU0[j,n]/(MonthlySteps*SeasonDuration[j]);
    IrrA[j,n]:=IrrA[j,n]/(MonthlySteps*SeasonDuration[j]);
    IrrB[j,n]:=IrrB[j,n]/(MonthlySteps*SeasonDuration[j]);
    IrA0[j,n]:=IrA0[j,n]/(MonthlySteps*SeasonDuration[j]);
    IrB0[j,n]:=IrB0[j,n]/(MonthlySteps*SeasonDuration[j]);
    PercLoss[j,n]:=PercLoss[j,n]/(MonthlySteps*SeasonDuration[j]);
    Rain[j,n]:=Rain[j,n]/(MonthlySteps*SeasonDuration[j]);
    ReuseDr[j,n]:=ReUseDr[j,n]/(MonthlySteps*SeasonDuration[j]);
    SurfDrA[j,n]:=SurfDrA[j,n]/(MonthlySteps*SeasonDuration[j]);
    SurfDrB[j,n]:=SurfDrB[j,n]/(MonthlySteps*SeasonDuration[j]);
    SurfInflow[j,n]:=SurfInFlow[j,n]/(MonthlySteps*SeasonDuration[j]);
    SurfOutFlow[j,n]:=SurfOutFlow[j,n]/(MonthlySteps*SeasonDuration[j]);
    WellDis[j,n]:=WellDis[j,n]/(MonthlySteps*SeasonDuration[j]);
    Byp[j,n]:=Byp[j,n]/(MonthlySteps*SeasonDuration[j]);
    Qinf[n]:=Qinf[n]/(MonthlySteps*12);
    Qout[n]:=Qout[n]/(MonthlySteps*12);
  end; {for n:=1 to NrOfIntPoly do}
end; {with DataMod do}
end; {procedure ConvertToDaily}


procedure SetToZero;
var n, jn : integer;
begin
  for n:=1 to DataMod.NrOfIntPoly do
  begin
    setlength (CaAT,n+1);
    CaAT[n]:=0;
    setlength (CaBT,n+1);
    CaBT[n]:=0;
    setlength (CaUT,n+1);
    CaUT[n]:=0;
    setlength (CirT,n+1);
    CirT[n]:=0;
    setlength (CitT,n+1);
    CitT[n]:=0;
    setlength (DrAT,n+1);
    DrAT[n]:=0;
    setlength (DrBT,n+1);
    DrBT[n]:=0;
    setlength (DwtT,n+1);
    DwtT[n]:=0;
    setlength (EpAT,n+1);
    EpAT[n]:=0;
    setlength (EpBT,n+1);
    EpBT[n]:=0;
    setlength (EpUT,n+1);
    EpUT[n]:=0;
    setlength (IrAT,n+1);
    IrAT[n]:=0;
    setlength (IrBT,n+1);
    IrBT[n]:=0;
    setlength (HIGT,n+1);
    HIGT[n]:=0;
    setlength (HOGT,n+1);
    HOGT[n]:=0;
    setlength (HITT,n+1);
    HITT[n]:=0;
    setlength (HOTT,n+1);
    HOTT[n]:=0;
    setlength (PlAT,n+1);
    PlAT[n]:=0;
    setlength (PlBT,n+1);
    PlBT[n]:=0;
    setlength (PlUT,n+1);
    PlUT[n]:=0;
    setlength (BypT,n+1);
    BypT[n]:=0;
    setlength (SGIT,n+1);
    SGIT[n]:=0;
    setlength (PLCT,n+1);
    PLCT[n]:=0;
    setlength (STiT,n+1);
    STiT[n]:=0;
    setlength (StoT,n+1);
    StoT[n]:=0;
    setlength (ZirT,n+1);
    ZirT[n]:=0;
    setlength (ZdrT,n+1);
    ZdrT[n]:=0;
    setlength (ZwlT,n+1);
    ZwlT[n]:=0;
    setlength (RechT,n+1);
    RechT[n]:=0;
    setlength (StorAq,n+1);
    setlength (EffPor,n+1);
    for jn:=1 to NrOfNextNodes[n] do
        Qaq[n,jn]:=0;
  end; {for n:=1 to DataMod.NrOfIntPoly do}
end; {procedure SetToZero}


procedure ConvToSeasonal (j : integer);
var n : integer;
begin with DataMod do
begin
  for n:=1 to NrOfIntPoly do
  begin
    CIR[j,n]:=CIR[j,n]*MonthlySteps*SeasonDuration[j];
    CIT[j,n]:=CIT[j,n]*MonthlySteps*SeasonDuration[j];
    EpA0[j,n]:=EpA0[j,n]*MonthlySteps*SeasonDuration[j];
    EpB0[j,n]:=EpB0[j,n]*MonthlySteps*SeasonDuration[j];
    EpU0[j,n]:=EpU0[j,n]*MonthlySteps*SeasonDuration[j];
    EvapA[j,n]:=EpA0[j,n];
    EvapB[j,n]:=EpB0[j,n];
    EvapU[j,n]:=EpU0[j,n];
    IrrA[j,n]:=IrrA[j,n]*MonthlySteps*SeasonDuration[j];
    IrrB[j,n]:=IrrB[j,n]*MonthlySteps*SeasonDuration[j];
    IrA0[j,n]:=IrA0[j,n]*MonthlySteps*SeasonDuration[j];
    IrB0[j,n]:=IrB0[j,n]*MonthlySteps*SeasonDuration[j];
    PercLoss[j,n]:=PercLoss[j,n]*MonthlySteps*SeasonDuration[j];
    Rain[j,n]:=Rain[j,n]*MonthlySteps*SeasonDuration[j];
    ReuseDr[j,n]:=ReUseDr[j,n]*MonthlySteps*SeasonDuration[j];
    SurfDrA[j,n]:=SurfDrA[j,n]*MonthlySteps*SeasonDuration[j];
    SurfDrB[j,n]:=SurfDrB[j,n]*MonthlySteps*SeasonDuration[j];
    SurfInflow[j,n]:=SurfInFlow[j,n]*MonthlySteps*SeasonDuration[j];
    SurfOutFlow[j,n]:=SurfOutFlow[j,n]*MonthlySteps*SeasonDuration[j];
    WellDis[j,n]:=WellDis[j,n]*MonthlySteps*SeasonDuration[j];
    Byp[j,n]:=Byp[j,n]*MonthlySteps*SeasonDuration[j];
    Qinf[n]:=Qinf[n]*MonthlySteps*12;
    Qout[n]:=Qout[n]*MonthlySteps*12;
  end; {for n:=1 to NrOfIntPoly do}
end; {with DataMod do}
end; {procedure ConvToSeasonal}


procedure Summations (j,i : integer);
begin
//Summation of daily groundwater and salt flows to obtain seasonal values
          HIGT[i]:=HIGT[i]+HIGD;         {total incoming water through aquifer}
          HOGT[i]:=HOGT[i]+HOGD;         {total outgoing water through aquifer}
          HITT[i]:=HITT[i]+HITD;     {total incoming water through trans. zone}
          HOTT[i]:=HOTT[i]+HOTD;     {total outgoing water through trans. zone}
          SGIT[i]:=SGIT[i]+SGID;          {total incoming salt through aquifer}
          STIT[i]:=STIT[i]+STID;      {total incoming salt through trans. zone}
          STOT[i]:=STOT[i]+StorWL[i];                 {total storage of water}
//Summation of daily irrigation, evaporation, percolation, capillary rise,
//and drainage, to obtain seasonal values
          CitT[i]:=CitT[i]+Cit[j,i];             {irrigation water including re-use}
          CirT[i]:=CirT[i]+Cir[j,i];             {irrigation water excluding re-use}
          CaAT[i]:=CaAT[i]+CaA;               {cap. rise in area under A crops}
          CaBT[i]:=CaBT[i]+CaB;               {cap. rise in area under B crops}
          CaUT[i]:=CaUT[i]+CaU;                 {cap. rise in unirrigated area}
          DrAT[i]:=DrAT[i]+DrA;                    {drainage above drain level}
          DrBT[i]:=DrBT[i]+DrB;                    {drainage below drain level}
          EpAT[i]:=EpAT[i]+EvapA[j,i];         {evapotr. in area under A crops}
          EpBT[i]:=EPBT[i]+EvapB[j,i];         {evapotr. in area under B crops}
          EPUT[i]:=EPUT[i]+EvapU[j,i];           {evapotr. in unirrigated area}
          IrAT[i]:=IrAT[i]+IrrA[j,i];            {irrig. in area under A crops}
          IrBT[i]:=IrBT[i]+IrrB[j,i];            {irrig. in area under B crops}
          PLAT[i]:=PLAT[i]+PlA;           {percolation from area under A crops}
          PLBT[i]:=PLBT[i]+PlB;           {percolation from area under B crops}
          PLUT[i]:=PLUT[i]+PlU;             {percolation from unirrigated area}
 	        PLCT[i]:=PLCT[i]+PlCC;               {percolation losses from canals}
      		RechT[i]:=RechT[i]+Rech;        {Recharge to watertable before Evap.}
		      BypT[i]:=BypT[i]+ByP[j,i];     {Bypass of water in irr. canal system}
//Summation of daily depths of watertable
          DWTT[i]:=DWTT[i]+DwT;
//Summation of daily salt transport in irrigation, drainage and well water
//into seasonal values
          ZDRT[i]:=ZDRT[i]+ZDR*DRT;                    {amount of salt drained}
          ZIRT[i]:=ZIRT[i]+ZIR*CIT[j,i];     {amount of salt brought in by Irr}
          ZWLT[i]:=ZWLT[i]+
                   Zwell*WellDis[j,i];       {amount of salt pumped by wells}
end;  {procedure Summations (j,i)}


procedure SeasonalRename (j, i : integer);
begin
        Byp[j,i]:=BypT[i];
        CAA:=CAAT[i];
        CAB:=CABT[i];
        CAU:=CAUT[i];
        Cir[j,i]:=CirT[i];
        Cit[j,i]:=CitT[i];
        DRA:=DRaT[i];
        DRB:=DRbT[i];
        DRT:=DRA+DRB;
        EvapA[j,i]:=EPAT[i];
        EvapB[j,i]:=EPBT[i];
        EvapU[j,i]:=EPUT[i];
        HIGD:=HIGT[i];
        HOGD:=HOGT[i];
        HITD:=HITT[i];
        HOTD:=HOTT[i];
        IrrA[j,i]:=IrAT[i];
        IrrB[j,i]:=IrBT[i];
        PercLoss[j,i]:=PlcT[i];
        PLA:=PLAT[i];
        PLB:=PLBT[i];
        PLU:=PLUT[i];
        Rech:=RechT[i];

//adjusting percolation and capillary rise
        if PLA>CAA then
        begin
          PLA:=PLA-CAA;
          CAA:=0;
        end else
        begin
          CAA:=CAA-PLA;
          PLA:=0;
        end;
        if PLB>CAB then
        begin
          PLB:=PLB-CAB;
          CAB:=0;
        end else
        begin
          CAB:=CAB-PLB;
          PLB:=0;
        end;
        if PLU>CAU then
        begin
          PLU:=PLU-CAU;
          CAU:=0;
        end else
        begin
          CAU:=CAU-PLU;
          PLU:=0;
        end;
end;  {procedure SeasonalRename (j,i)}



procedure ReduceIrr (j, i : integer);
var FAC, DWTC, IRAI, IRBI : real;
    PolyTxt : string;
begin with DataMod do
begin
//Initial settings
  IRAI:=IrrA[j,i];
  if IRAI<0.01 then IRAI:=0;
  IRBI:=IrrB[j,i];
  if IRBI<0.01 then IRBI:=0;
  FAC:=0;
  IF DWT<0.350 THEN FAC:=0.05;
  IF DWT<0.300 THEN FAC:=0.10;
  IF DWT<0.250 THEN FAC:=0.15;
  IF DWT<0.200 THEN FAC:=0.20;
  IF DWT<0.150 THEN FAC:=0.25;
  IF DWT<=0.100 THEN FAC:=0.30;

  IF RiceIndA[j,i]=1 THEN                                     {paddy on A land}
  BEGIN
    FAC:=0;
    IF DWT<-0.1001 THEN FAC:=0.05;
    IF DWT<-0.2001 THEN FAC:=0.10;
    IF DWT<-0.2501 THEN FAC:=0.15;
    IF DWT<-0.3001 THEN FAC:=0.20;
    IF DWT<-0.3501 THEN FAC:=0.25;
    IF DWT<-0.4001 THEN FAC:=0.30;
  END;

//Reducing irrigation IRA at shallow DWT, famers' response, adjusting bypass
  BYP[j,i]:=BYP[j,i]+FAC*IrrA[j,i]*AreaA[j,i];
  IrrA[j,i]:=IrrA[j,i]-FAC*IrrA[j,i];
  if IrrA[j,i]<0.001 then IrrA[j,i]:=0;

//Increasing IRa when the permanently unirrigated area
//has been increased and DWT has therefore increased
  DWTC:=0.6;
  IF RiceIndA[j,i]=1 THEN DWTC:=-0.1;                         {paddy on A land}
  if (AreaA[j,i]>0.001) and (RotationType[i]<>3) then
     IF (IrrA[j,i]<IRA0[j,i]) AND (DWT>=DWTC) THEN if SUA<1 then
     BEGIN
       BYP[j,i]:=BYP[j,i]-FAC*IRAI*AreaA[j,i];
       IrrA[j,i]:=IRAI+FAC*IRAI;
       IF BYP[j,i]<0 THEN
       BEGIN
         IrrA[j,i]:=IRAI+BYP[j,i];
         BYP[j,i]:=0;
       END;
       if IrrA[j,i]>IRA0[j,i] then
       begin
         BYP[j,i]:=BYP[j,i]+IrrA[j,i]-IRA0[j,i];
         IrrA[j,i]:=IRA0[j,i];
       end;
    END;

  FAC:=0;
  IF DWT<0.350 THEN FAC:=0.05;
  IF DWT<0.300 THEN FAC:=0.10;
  IF DWT<0.250 THEN FAC:=0.15;
  IF DWT<0.200 THEN FAC:=0.20;
  IF DWT<0.150 THEN FAC:=0.25;
  IF DWT<=0.100 THEN FAC:=0.30;

  IF RiceIndB[j,i]=1 THEN                                    {paddy on B land}
  BEGIN
    FAC:=0;
    IF DWT<-0.1001 THEN FAC:=0.05;
    IF DWT<-0.2001 THEN FAC:=0.10;
    IF DWT<-0.2501 THEN FAC:=0.15;
    IF DWT<-0.3001 THEN FAC:=0.20;
    IF DWT<-0.3501 THEN FAC:=0.25;
    IF DWT<-0.4001 THEN FAC:=0.30;
  END;

//Reducing irrigation IRB at shallow DWT, famers' response, adjusting bypass
  BYP[j,i]:=BYP[j,i]+FAC*IrrB[j,i]*AreaB[j,i];
  IrrB[j,i]:=IrrB[j,i]-FAC*IrrB[j,i];
  if IrrB[j,i]<0.001 then IrrB[j,i]:=0;
//Increasing IRB when the permanently unirrigated area
//has been increased and DWT has therefore increased
  DWTC:=0.6;
  IF RiceIndB[j,i]=1 THEN DWTC:=-0.1;                         {paddy on B land}
  if (AreaB[j,i]>0.001) and (RotationType[i]<>3) then
     IF (IrrB[j,i]<IRB0[j,i]) AND (DWT>=DWTC) THEN  if SUB<1 then
     BEGIN
       BYP[j,i]:=BYP[j,i]-FAC*IRBI*AreaB[j,i];
       IrrB[j,i]:=IRBI+FAC*IRBI;
       IF ABS(BYP[j,i])<0.001 THEN BYP[j,i]:=0;
       IF BYP[j,i]<0 THEN
       BEGIN
         IrrB[j,i]:=IRBI+BYP[j,i];
         BYP[j,i]:=0;
       END;
      if IrrB[j,i]>IRB0[j,i] then
      begin
        BYP[j,i]:=BYP[j,i]+IrrB[j,i]-IRB0[j,i];
        IrrB[j,i]:=IRB0[j,i];
      end;
  END;

  if BYP[j,i]<0.001 then BYP[j,i]:=0;

  if ((IrrA[j,i]<IRAI) or (IrrB[j,1]<IRBI)) and not IrrWarning then
  begin
    AllWarning := true;
    IrrReduced := true;
    PolyTxt := inttostr (i);
    PolyTxt := ' As the watertable rises to the soil surface'+
               ' in Polygon: '+PolyTxt+', the irrigation is reduced here.';
    WarningForm.WarningMemo.Lines.Add ('');
    WarningForm.WarningMemo.Lines.Add (PolyTxt);
  end;

end; {with DataMod do}
end; {procedure ReduceIrr}



procedure FarmResponses (j, i : integer);
var FA, FB, FAC, {DWTC,} IRAI, IRBI : real;
    PolyTxt : string;
begin with DataMod do
begin

  if Watch then
  begin
    if RotationType[i]=1 then SCRB[i]:=SCRA[i];
    if RotationType[i]=2 then SCRU[i]:=SCRB[i];
    if RotationType[i]=3 then SCRU[i]:=SCRA[i];
    if RotationType[i]=4 then
    begin
      SCRU[i]:=SCRA[i];
      SCRB[i]:=SCRA[i];
    end;
  end;

//  AI:=AreaA[j,i];
//  BI:=AreaB[j,i];

//Reducing the seasonal irrigated A area
  if (AreaA[j,i]>0.001) and (RotationType[i]<>3) then
      if (SCRA[i]>8) and (SUA<0.8) then
      begin
        if SCRA[i]>8 then Watch:=true;
        FA:=0.95;
        if (SCRA[i]>12) or (SUA<0.7) then FA:=0.9;
        AreaA[j,i]:=FA*AreaA[j,i];
        if AreaA[j,i]<0.01 then AreaA[j,i]:=0;
        if (EFA<0.8*StoEffA[j,i]) and (SUA=1) then
            Byp[j,i]:=(1/FA-1)*AreaA[j,i]*IrrA[j,i]
        else
            IrrA[j,i]:=IrrA[j,i]/FA;
      end;
//Reducing the seasonal irrigated B area
  if (AreaB[j,i]>0.001) and (RotationType[i]<>2) then
      if (SCRB[i]>8) and (SUB<0.8) then
      begin
        if SCRB[i]>8 then Watch:=true;
        FB:=0.95;
        if (SCRB[i]>12) or (SUB<0.7) then FB:=0.9;
        AreaB[j,i]:=FB*AreaB[j,i];
        if AreaB[j,i]<0.01 then AreaB[j,i]:=0;
        if (EFB<0.8*StoEffB[j,i]) and (SUB=1) then
            Byp[j,i]:=(1/FB-1)*AreaB[j,i]*IrrB[j,i]
        else
            IrrB[j,i]:=IrrB[j,i]/FB;
      end;
(*
//Area warning not really necessary as it is under farmers' responses
  if not AreaWarning and ((AreaA[j,i]<AI) or (AreaB[j,i]<BI)) then
  begin
    AllWarning := true;
    AreaReduced := true;
    PolyTxt := inttostr (i);
    PolyTxt := 'to soil salinization in Polygon: '+PolyTxt;
    WarningForm.WarningMemo.Lines.Add
                  (' Irrigated area is abandoned as a response of the farmers'+
                   ' to salinization.');
    WarningForm.WarningMemo.Lines.Add (PolyTxt);
  end;
*)
//Increasing the irrigated A area when it was reduced previously
//but the soil salinity improves due to the presence of permanently
//unirrigated area
  if (AreaA[j,i]<AA0[j,i]) and (AreaA[j,i]>0.001) and (RotationType[i]<>3) then
      if (SCRA[i]<7) and (SUA>0.9) then
      begin
        FA:=1/0.95;
        if (SCRA[i]<7) then FA:=1/0.9;
        AreaA[j,i]:=FA*AreaA[j,i];
        if AreaA[j,i]>AA0[j,i] then
        begin
          AreaA[j,i]:=AA0[j,i];
          Watch:=false;
        end;
        Byp[j,i]:=Byp[j,i]-(1-1/FA)*AreaA[j,i]*IrrA[j,i];
        if Byp[j,i]<0.001 then
        begin
          IrrA[j,i]:=IrrA[j,i]+Byp[j,i];
          Byp[j,i]:=0;
        end;
      end;
//Increasing the irrigated B area when it was reduced previously
//but the soil salinity improves due to the presence of permanently
//unirrigated area
  if (AreaB[j,i]<BB0[j,i]) and (AreaB[j,i]>0.001) and (RotationType[i]<>2) then
      if (SCRB[i]<7) and (SUB>0.9) then
      begin
        FB:=1/0.95;
        if (SCRB[i]<7) then FB:=1/0.9;
        AreaB[j,i]:=FB*AreaB[j,i];
        if AreaB[j,i]>BB0[j,i] then
        begin
          AreaB[j,i]:=BB0[j,i];
          Watch:=false;
        end;
        Byp[j,i]:=Byp[j,i]-(1-1/FB)*AreaB[j,i]*IrrB[j,i];
        if Byp[j,i]<0 then
        begin
          IrrB[j,i]:=IrrB[j,i]+Byp[j,i];
          Byp[j,i]:=0;
        end;
      end;

//Reducing irrigation IRA at shallow DWT, famers' response, adjusting bypass
//is no longer done in main caluclations
  IRAI:=IrrA[j,i];
  if IRAI<0.01 then IRAI:=0;
  IRBI:=IrrB[j,i];
  if IRBI<0.01 then IRBI:=0;

  FAC:=0;
  IF DWT<0.6001 THEN FAC:=0.05;
  IF DWT<0.5001 THEN FAC:=0.10;
  IF DWT<0.4001 THEN FAC:=0.15;
  IF DWT<0.3001 THEN FAC:=0.20;
  IF DWT<0.2001 THEN FAC:=0.25;
  IF DWT<=0.1001 THEN FAC:=0.30;

  IF RiceIndA[j,i]=1 THEN                                     {paddy on A land}
  BEGIN
    FAC:=0;
    IF DWT<-0.1001 THEN FAC:=0.05;
    IF DWT<-0.2001 THEN FAC:=0.10;
    IF DWT<-0.2501 THEN FAC:=0.15;
    IF DWT<-0.3001 THEN FAC:=0.20;
    IF DWT<-0.3501 THEN FAC:=0.25;
    IF DWT<-0.4001 THEN FAC:=0.30;
  END;

  BYP[j,i]:=BYP[j,i]+FAC*IrrA[j,i]*AreaA[j,i];
  IrrA[j,i]:=IrrA[j,i]-FAC*IrrA[j,i];
(*
  if IrrA[j,i]<0.001 then IrrA[j,i]:=0;
//Increasing IRA when the permanently unirrigated area
//has been increased and DWT has therefore increased
  DWTC:=0.6;
  IF RiceIndA[j,i]=1 THEN DWTC:=-0.1;                         {paddy on A land}
  if (AreaA[j,i]>0.001) and (RotationType[i]<>3) then
     IF (IrrA[j,i]<IRA0[j,i]) AND (DWT>=DWTC) THEN if SUA<1 then
     BEGIN
       BYP[j,i]:=BYP[j,i]-0.05*IRAI*AreaA[j,i];
       IrrA[j,i]:=IRAI+0.05*IRAI;
       IF BYP[j,i]<0 THEN
       BEGIN
         IrrA[j,i]:=IRAI+BYP[j,i];
         BYP[j,i]:=0;
       END;
       if IrrA[j,i]>IRA0[j,i] then
       begin
         BYP[j,i]:=BYP[j,i]+IrrA[j,i]-IRA0[j,i];
         IrrA[j,i]:=IRA0[j,i];
       end;
     END;
*)
  FAC:=0;
  IF DWT<0.6001 THEN FAC:=0.05;
  IF DWT<0.5001 THEN FAC:=0.10;
  IF DWT<0.4001 THEN FAC:=0.15;
  IF DWT<0.3001 THEN FAC:=0.20;
  IF DWT<0.2001 THEN FAC:=0.25;
  IF DWT<0.1001 THEN FAC:=0.30;

  IF RiceIndB[j,i]=1 THEN                                    {paddy on B land}
  BEGIN
    FAC:=0;
    IF DWT<-0.1001 THEN FAC:=0.05;
    IF DWT<-0.2001 THEN FAC:=0.10;
    IF DWT<-0.2501 THEN FAC:=0.15;
    IF DWT<-0.3001 THEN FAC:=0.20;
    IF DWT<-0.3501 THEN FAC:=0.25;
    IF DWT<-0.4001 THEN FAC:=0.30;
  END;

//Reducing irrigation IRB at shallow DWT, famers' response, adjusting bypass
  BYP[j,i]:=BYP[j,i]+FAC*IrrB[j,i]*AreaB[j,i];
  IrrB[j,i]:=IrrB[j,i]-FAC*IrrB[j,i];
  if IrrB[j,i]<0.001 then IrrB[j,i]:=0;
(*
//Increasing IRB when the permanently unirrigated area
//has been increased and DWT has therefore increased
  DWTC:=0.6;
  IF RiceIndB[j,i]=1 THEN DWTC:=-0.1;                         {paddy on B land}
  if (AreaB[j,i]>0.001) and (RotationType[i]<>3) then
     IF (IrrB[j,i]<IRB0[j,i]) AND (DWT>=DWTC) THEN  if SUB<1 then
     BEGIN
       BYP[j,i]:=BYP[j,i]-0.05*IRBI*AreaB[j,i];
       IrrB[j,i]:=IRBI+0.05*IRBI;
       IF ABS(BYP[j,i])<0.001 THEN BYP[j,i]:=0;
       IF BYP[j,i]<0 THEN
       BEGIN
         IrrB[j,i]:=IRBI+BYP[j,i];
         BYP[j,i]:=0;
       END;
      if IrrB[j,i]>IRB0[j,i] then
      begin
        BYP[j,i]:=BYP[j,i]+IrrB[j,i]-IRB0[j,i];
        IrrB[j,i]:=IRB0[j,i];
      end;
    END;
  if BYP[j,i]<0.001 then BYP[j,i]:=0;
*)


//  if (IrrA[j,i]<IRAini+0.001) {or (IrrB[j,1]<IRBI+0.001)} then
  if (IrrA[j,i]<IRAI) or (IrrB[j,i]<IRBI) then
  if not IrrWarning then
  begin
    AllWarning := true;
    IrrReduced := true;
    PolyTxt := inttostr (i);
    PolyTxt := ' As the watertable rises to the soil surface'+
               ' in Polygon: '+PolyTxt+', the irrigation is reduced here.';
    WarningForm.WarningMemo.Lines.Add ('');
    WarningForm.WarningMemo.Lines.Add (PolyTxt);
  end;


end; {with DataMod do}
end; {procedure FarmResponses}


//Sub-procedures under SaltBalances}

//Salt concentrations in the irrigated and unirrigated areas
procedure AuxSB1 (var DOWNx,UPWAx,IRAx,IRBx,RAINx,SCMAx,SCMBx,SCMUx,SCXx,
                  SDAx,SDBx,SDLAx,SDLBx,SDLUx,SRIx,SROx,SSIx : real;
                  ii : integer);
{-----------------------------------------------------------------------------}
label 1,2,3;
var ACC, ACCI, ACCO : real;

BEGIN with DataMod do
begin

//Salt accumulation (ACC) and concentration (SCRA) in the rootzone of A area
1: ACCI:=IRAx*ZIR+CAA*LeachEffTr[ii]*SCXx;
   IF DWT<0 THEN ACCI:=DOWNx*ZIR+UPWAx*LeachEffTr[ii]*SCXx;
   IF (DWT>0) AND (Dwt0<=0) THEN ACCI:=SSIx;
   ACCO:=SDAx*SDLAx*SCRA0+SCRA0*LeachEffRo[ii]*PLA;
   IF (DWT<0) THEN ACCO:=SDAx*SDLAx*SCRA0+DOWNx*SCRA0*LeachEffRo[ii];
   ACC:=ACCI-ACCO;
   SCrA[ii]:=SCRA0+ACC/(TotPorRo[ii]*RootZone[ii]);
   IF (SCrA[ii]=0) OR (SCRA0=0) THEN
   BEGIN
     SCMAx:=0;
     GOTO 2;
   END;
//Finding the average salt concentration of rootzone of A stepwise
   IF ACC<0 THEN
   BEGIN
     if SCRA0<=0 then SCRA0:=0.001;
     IF SCrA[ii]<=0 THEN SCrA[ii]:=0.1*SCRA0;
     SCMAx:=sqrt(SCRA0*SCrA[ii]);
   END ELSE
     SCMAx:=(SCRA0+SCrA[ii])/2;

//Salt accumulation (ACC) and concentration (SCRB) in the rootzone of B area
2: ACCI:=IRBx*ZIR+CAB*LeachEffTr[ii]*SCXx;
   IF DWT<0 THEN ACCI:=DOWNx*ZIR+UPWAx*LeachEffTr[ii]*SCXx;
   IF (DWT>0) AND (Dwt0<=0) THEN ACCI:=SSIx;
   ACCO:=SDBx*SDLBx*SCRB0+SCRB0*LeachEffRo[ii]*PLB;
   IF (DWT<0) THEN ACCO:=SDBx*SDLBx*SCRB0+DOWNx*SCRB0*LeachEffRo[ii];
   ACC:=ACCI-ACCO;
   SCrB[ii]:=SCRB0+ACC/(TotPorRo[ii]*RootZone[ii]);
   IF (SCrB[ii]=0) OR (SCRB0=0) THEN
   BEGIN
     SCMBx:=0;
     GOTO 3;
   END;
//Finding the average salt concentration of rootzone of B stepwise
   IF ACC<0 THEN
   BEGIN
     if SCRB0<=0 then SCRB0:=0.001;
     IF SCrB[ii]<=0 THEN SCrB[ii]:=0.1*SCRB0;
     SCMBx:=sqrt(SCRB0*SCrB[ii]);
   END ELSE
     SCMBx:=(SCRB0+SCrB[ii])/2;

//Salt accumulation (ACC) and concentration (SCRU) in the rootzone of U area
3: ACCI:=SRIx*ZIR+CAU*LeachEffTr[ii]*SCXx;
   IF DWT<0 THEN ACCI:=DOWNx*ZIR+UPWAx*LeachEffTr[ii]*SCXx;
   IF (DWT>0) AND (Dwt0<=0) THEN ACCI:=SSIx;
   ACCO:=SROx*SDLUx*SCRU0+SCRU0*LeachEffRo[ii]*PLU;
   IF (DWT<0) THEN ACCO:=SROx*SDLUx*SCRU0+DOWNx*SCRU0*LeachEffRo[ii];
   ACC:=ACCI-ACCO;
   if SCRU[ii]>16 then ACC:=4*ACC/sqrt(SCRU[ii]);
   SCrU[ii]:=SCRU0+ACC/(TotPorRo[ii]*RootZone[ii]);
   IF (SCrU[ii]=0) OR (SCRU0=0) THEN
   BEGIN
     SCMUx:=0;
     exit;
   END;
//Finding the average salt concentration of rootzone of B stepwise
   IF ACC<0 THEN
   BEGIN
     if SCRU0<=0 then SCRU0:=0.001;
     IF SCrU[ii]<=0 THEN SCrU[ii]:=0.1*SCRU0;
     SCMUx:=sqrt(SCRU0*SCrU[ii]);
   END ELSE
     SCMUx:=(SCRU0+SCrU[ii])/2;

end; {with DataMod do}
END; {procedure AuxSB1}
{---------------------}


//AuxSB2 is part of SaltBalances}
//Salt concentration in the root zone of A, B and/or U areas when
//the rotation key (RotationType[i]) is 1, 2 or 3
procedure AuxSB2 (var AUB,SCR1,SCM1,SC01,SCR2,SCM2,SC02,TSC1,TSC2,TSI1,TSI2,
                      TPL1,TPL2: real; ii : integer);
{--------------------------------------------------------------------------}
label 1, 2;
var ACC : real;

BEGIN with DataMod do
begin

   IF AUB>0.999 THEN
   BEGIN
     SCR1:=SC01;
     GOTO 2;
   END;

//Salt accumulation and concentration in the rootzone, mixed area
   ACC:=TSI1-TPL1*LeachEffRo[ii]*SC01+TSC1;
   SCR1:=SC01+ACC/(TotPorRo[ii]*RootZone[ii]);
   IF (SCR1=0) OR (SC01=0) THEN
   BEGIN
     SCM1:=0;
     GOTO 1;
   END;

//Finding the average salt conc. of rootzone stepwise, mixed area
   IF ACC<0 THEN
   BEGIN
     if SC01<=0 then SC01:=0.001;
     IF SCR1<=0 THEN SCR1:=0.1*SC01;
     SCM1:=sqrt(SC01*SCR1);
   END ELSE
     SCM1:=(SC01+SCR1)/2;

1: IF AUB<0.001 THEN
   BEGIN
     SCR2:=SC02;
     exit;
   END;

//Salt accumulation and concentration in the rootzone, fixed area
2: ACC:=TSI2-TPL2*LeachEffRo[ii]*SC02+TSC2;
   if SCR2>16 then ACC:=4*ACC/sqrt(SCR2);
   SCR2:=SC02+ACC/(TotPorRo[ii]*RootZone[ii]);
   IF (SCR2=0) OR (SC02=0) THEN
   BEGIN
     SCM2:=0;
     exit;
   END;

//Finding the average salt conc. in the rootzone fixed area
   IF ACC<0 THEN
   BEGIN
     if SC02<=0 then SC02:=0.001;
     IF SCR2<=0 THEN SCR2:=0.1*SC02;
     SCM2:=sqrt(SC02*SCR2);
   END ELSE
     SCM2:=(SC02+SCR2)/2;

end; {with DataMod do}
END; {procedure AuxSB2}
{---------------------}


//AuxSB3 is part of SaltBalances}
//Salt concentration in the rootzone (SCRA) when full rotation occurs
//(RotationType[i]=4)
procedure AuxSB3 (var PLF,SCRAx,SCMAx,TSIx : real; ii : integer);
{---------------------------------------------------------------}
var ACCA : real;

BEGIN with DataMod do
begin

//Salt accumulation and concentration in the rootzone
   ACCA:=TSIx-PLF*LeachEffRo[ii]*SCRA0;
   SCRAx:=SCRA0+ACCA/(TotPorRo[ii]*RootZone[ii]);

//Finding the average salt concentration of rootzone of total irrigated
//area stepwise
   IF ACCA<0 THEN
   BEGIN
     if SCRA0<=0 then SCRA0:=0.001;
     if SCRAx<=0 then SCRAx:=0.1*SCRA0;
     SCMAx:=sqrt(SCRA0*SCRAx);
   END ELSE
     SCMAx:=(SCRA0+SCRAx)/2;

end; {with DataMod do}
END; {procedure AuxSB3}
{---------------------}


//AuxSB4A is part of SaltBalances}
//Salt concentration in of the water in the transition zone (SCtr) when
//there is no drainage system (DrainIndex=0)
procedure AuxSB4A (var PLC,SCTMx,TSPx,VDDx,VUSx : real; ii : integer);
{--------------------------------------------------------------------}
var  ACC,SCI : real;

BEGIN with DataMod do
begin

//Setting initial values
  SCI:=SCtr[ii];

//Salt accumulation and concentration (SCtr[ii]) in the transition zone
   ACC:=TSPx+PLC*ZIR+VUSx*LeachEffAq[ii]*SCaq[ii]
        -(CAT+VDDx)*LeachEffTr[ii]*SCtr[ii];
   IF DWT>=RootZone[ii]+TranZone[ii] THEN
      ACC:=TSPx-PLT*LeachEffTr[ii]*SCtr[ii]-CAT*(LeachEffTr[ii]*SCtr[ii]
           -LeachEffAq[ii]*SCaq[ii]);
   SCtr[ii]:=SCI+ACC/(TotPorTr[ii]*TranZone[ii]);
   IF (SCtr[ii]=0) OR (SCI=0) THEN
   BEGIN
     SCTMx:=0;
     exit;
   END;
//Finding the average salt concentration stepwise
  IF ACC<0 THEN
  BEGIN
    if SCI<=0 then SCI:=0.001;
    IF SCtr[ii]<=0 THEN SCtr[ii]:=0.1*SCI;
    SCTMx:=sqrt(SCI*SCtr[ii]);
  END ELSE
    SCTMx:=(SCI+SCtr[ii])/2;

end; {with DataMod do}
END; {procedure AuxSB4A}
{----------------------}


//AuxSB4B is part of SaltBalances}
//Salt concentration in the upper (SCU) and lower (SCL) transition zone
//when a drainage system is present (DrainIndex=1)
procedure AuxSB4B (var PLC,SCAx,SCLx,SCLMx,SCUx,SCUMx,TSPx,VDDx,VUSx : real;
                   ii : integer);
{---------------------------------------------------------------------------}
label 1;
var VUX, VDX, VAX, VUB, SCI, ACC, PO, TR : real;

BEGIN with DataMod do
begin

//Auxiliary waterbalance factors
  VUX:=VUSx-DRB;
  IF VUX<0 THEN VUX:=0;
  VDX:=PLT-DRA;
  IF VDX<0 THEN VDX:=0;
  VAX:=CAT+VDX+DRA;
  VUB:=VUX+VDDx+DRB;
//Starting value of the salt concentration in the upper part of
//the transition zone used for iterative calculations
  SCI:=SCtU[ii];
//Salt accumulation and concentration (SCU) in the upper part of
//the transition zone
   ACC:=TSPx+VUX*LeachEffTr[ii]*SCtL[ii]-VAX*LeachEffTr[ii]*SCtU[ii];
   IF DWT>=DrainDepth[ii] THEN
      ACC:=TSPx-PLT*LeachEffTr[ii]*SCtU[ii]+CAT*LeachEffTr[ii]*(SCtL[ii]-SCtU[ii]);
   PO:=totPorTr[ii]*(DrainDepth[ii]-RootZone[ii]);
   SCtU[ii]:=SCI+ACC/PO;
   IF (SCtU[ii]=0) OR (SCI=0) THEN
   BEGIN
     SCUMx:=0;
     GOTO 1;
   END;
//Finding the average salt concentration in the upper part of the
//transition zone stepwise
  IF ACC<0 THEN
  BEGIN
    if SCI<=0 then SCI:=0.001;
    IF SCtU[ii]<=0 THEN SCtU[ii]:=0.1*SCI;
    SCUMx:=sqrt(SCI*SCtU[ii]);
  END ELSE
    SCUMx:=(SCI+SCtU[ii])/2;

//Starting value of the salt concentration in the lower part of
//the transition zone used for iterative calculations
1: SCI:=SCtL[ii];
//Salt accumulation and concentration (SCL) in lower transition zone
   ACC:=VDX*LeachEffTr[ii]*SCUMx+PLC*ZIR+VUSx*LeachEffAq[ii]*SCaq[ii]
        -VUB*LeachEffTr[ii]*SCtL[ii];
   IF DWT>=RootZone[ii]+TranZone[ii] THEN
      ACC:=PLT*LeachEffTr[ii]*(SCUMx-SCtL[ii])+CAT*(LeachEffAq[ii]*SCaq[ii]
           -LeachEffTr[ii]*SCtL[ii]);
   TR:=RootZone[ii]+TranZone[ii]-DrainDepth[ii];
   PO:=TotPorTr[ii]*TR;
   SCtL[ii]:=SCI+ACC/PO;
   IF (SCtL[ii]=0) OR (SCI=0) THEN
   BEGIN
     SCLMx:=0;
     exit;
   END;
//Finding the average salt concentration in the lower part of
//the transition zone stepwise
  IF ACC<0 THEN
  BEGIN
    if SCI<=0 then SCI:=0.001;
    IF SCtL[ii]<=0 THEN SCtL[ii]:=0.1*SCI;
    SCLMx:=sqrt(SCI*SCtL[ii]);
  END ELSE
    SCLMx:=(SCI+SCtL[ii])/2;

end; {with DataMod do}
END; {procedure AuxSB4B}
{----------------------}


//AuxSB5 is part of SaltBalances}
//Salt concentration of the water in the aquifer (SCaq[ii])
procedure AuxSB5 (var HIG,HOG,PLC,PLF,SCLMx,SCTMx,VDDx,VUSx,WELx,
                      ZIGx,ZIRx : real; ii : integer);
{---------------------------------------------------------------}
label 1;
var ACC, ACCU, SCI, SCX : real;

BEGIN with DataMod do
begin

//Determining salinity of the transition zone
  SCX:=SCTMx;
  IF DrainIndex[ii]=1 THEN SCX:=SCLMx;
//Starting value of the salt concentration in the aquifer used for
//iterative calculations
  SCI:=SCaq[ii];
//Salt accumulation (ACC) and concentration (SCaq[ii]) in the aquifer
1: ACCU:=HIG*ZIG-(HOG+WELx*LeachEffAq[ii])*SCaq[ii];
  ACC:=ACCU+VDDx*LeachEffTr[ii]*SCX-VUSx*LeachEffAq[ii]*SCaq[ii];
  IF DWT>RootZone[ii]+TranZone[ii]
     THEN ACC:=ACCU+PLF*LeachEffTr[ii]*SCX+PLC*ZIR-CAT*LeachEffAq[ii]*SCaq[ii];
  SCaq[ii]:=SCI+ACC/(TotPorAq[ii]*Aqu1);
//Finding the average salt concentration in the aquifer stepwise
  IF ACC<0 THEN
  BEGIN
    if SCI<=0 then SCI:=0.001;
    IF SCaq[ii]<0 THEN SCaq[ii]:=0.1*SCI;
    SCaq[ii]:=sqrt(SCI*SCaq[ii]);
  END;

end; {with DataMod do}
END; {procedure AuxSB5}
{---------------------}


end.



