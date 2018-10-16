unit UMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBaseForm, ComCtrls, StdCtrls, StdActns, ActnList, Menus,
  ExtCtrls, ShellApi, Grids, Clipbrd;

Type

  TSeasonDurationEdits = array[1..4] of Tedit;
  TSeasonDurationLabels = array[1..4] of TLabel;
  TLabelArray = array [1..8] of Tlabel;

  TMainForm = class(TBaseForm)
                                            {Menu bar}
    ActionList1: TActionList;
    InputOpen: TAction;
    InputSave: TAction;
    OutputOpen: TAction;
    GraphOpen: TAction;
    GraphSave: TAction;
    FilePrint: TAction;
    GroupSave: TAction;
    GroupOpen: TAction;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    InputOpen1: TMenuItem;
    OpenOutput: TMenuItem;
    GraphOpen1: TMenuItem;
    ProgramExit1: TMenuItem;
    Edit: TMenuItem;
    Cut: TMenuItem;
    CopyIt: TMenuItem;
    Paste: TMenuItem;
    DeleteIt: TMenuItem;
    FilePrint1: TMenuItem;
    OpenGroup: TMenuItem;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditDelete1: TEditDelete;
    EditPaste1: TEditPaste;
    FileExit1: TFileExit;
    PageControl1: TPageControl;
    InputOpen_Dialog: TOpenDialog;
    GraphOpen_Dialog: TOpenDialog;
    GraphSave_Dialog: TSaveDialog;
    GroupOpen_Dialog: TOpenDialog;
    InputSave_Dialog: TSaveDialog;
    OutputOpen_Dialog: TOpenDialog;
    GroupSave_Dialog: TSaveDialog;
                                             {Intro tabsheet}
    Intro_Tabsheet: TTabSheet;
    Intro_Memo: TMemo;
    Logo_Image: TImage;
                                            {Figure tabsheet}
    Figure_TabSheet: TTabSheet;
    Figure_Image: TImage;
                                            {General input tabsheet}
    GeneralInput_TabSheet: TTabSheet;
    InputSave_Button: TButton;
    GenFileOpen_Button: TButton;
    Restart_Button: TButton;
    Calculate_Button: TButton;
    GeneralInputSymbols_Button: TButton;
    NodalHelp_Button: TButton;
    Title1_Edit: TEdit;
    Title2_Edit: TEdit;
    GeneralExplanation1_Edit: TEdit;
    GeneralExplanation2_Edit: TEdit;
    NrOfPoly_Edit: TEdit;
    NrAdded_Edit: TEdit;
    NrRemoved_Edit: TEdit;
    Scale_Edit: TEdit;
    NrOfYears_Edit: TEdit;
    AnnualCalc_Combo: TComboBox;
    TimeStep_Edit: TEdit;
    Accuracy_Combo: TComboBox;
    GeneralFile_Label: TLabel;
    Title1_Label: TLabel;
    Title2_Label: TLabel;
    GeneralFileName_Label: TLabel;
    GenralExplanation1_Label: TLabel;
    GeneralExplanation2_Label: TLabel;
    NrOfPoly_Label: TLabel;
    NrAdded_Label: TLabel;
    NrRemoved_Label: TLabel;
    Scale_Label: TLabel;
    NrOfYears_Label: TLabel;
    NrOfSeasons_Label: TLabel;
    AnnualCalc_Label: TLabel;
    TimeStep_Label: TLabel;
    Accuracy_Label: TLabel;
    PolyFile_Label: TLabel;
    SeasFile_Label: TLabel;
    General_GroupBox: TGroupBox;
    SeasonDurations_GroupBox: TGroupBox;
    GeneralWait_Memo: TMemo;
    AnnualGen_Memo: TMemo;
    ProgressBar1: TProgressBar;
                                         {Polygonal data tabsheet}
    PolygonalInput_TabSheet: TTabSheet;
    PolyFileOpen_Button: TButton;
    KrHelp_Button: TButton;
    PolyGroupSave_Button: TButton;
    PolyInputSymbols_Button: TButton;
    PolyShowMap_Button: TButton;
    PolyCol_Button: TButton;
    MakeNetwork_Button: TButton;
    NetworkCancel_Button: TButton;
    PolyGroupCancel_Button: TButton;
    PolyGroup_Button: TButton;
    PolyPanelCancel_Button: TButton;
    PolyExplanation1_Edit: TEdit;
    PolyExplanation2_Edit: TEdit;
    PolyFileName_Label: TLabel;
    PolyExplanation1_Label: TLabel;
    PolyExplanation2_Label: TLabel;
    PolyHeader_Panel: TPanel;
    PolyNetwork_RadioGroup: TRadioGroup;
    Self_RadioButton: TRadioButton;
    Guided_RadioButton: TRadioButton;
    Poly_StringGrid: TStringGrid;
    PolyNetwork_Panel: TPanel;
    PolySelection_Panel: TPanel;
    PolyCol_Memo: TMemo;
    PolyComment_Memo: TMemo;
    AnnualPoly_Memo: TMemo;
    PolyComment_Panel: TPanel;
    PolyCol_Panel: TPanel;
    PolyGroup_Panel: TPanel;
    PolyData_RadioGroup: TRadioGroup;
    Overall_RadioButton: TRadioButton;
    Network_RadioButton: TRadioButton;
    Internal_RadioButton: TRadioButton;
    Conductivity_RadioButton: TRadioButton;
    TotPor_RadioButton: TRadioButton;
    EffPor_RadioButton: TRadioButton;
    Leaching_RadioButton: TRadioButton;
    Agricult_RadioButton: TRadioButton;
    Drainage_RadioButton: TRadioButton;
    SaltRoot_RadioButton: TRadioButton;
    SaltDeep_RadioButton: TRadioButton;
    ExtSal_RadioButton: TRadioButton;
    CritDepth_RadioButton: TRadioButton;
    HydHead_RadioButton: TRadioButton;
    Qinflow_RadioButton: TRadioButton;
    Resistence_RadioButton: TRadioButton;
                                           {Seasonal data tabsheet}
    SeasonalInput_TabSheet: TTabSheet;
    SeasGroup_Button: TButton;
    SeasGroupCancel_Button: TButton;
    SeasInputSymbols_Button: TButton;
    SeasonGroupSave_Button: TButton;
    SeasFileOpen_Button: TButton;
    SeasonCol_Button: TButton;
    SeasShowMap_Button: TButton;
    SeasExplanation1_Edit: TEdit;
    SeasExplanation2_Edit: TEdit;
    SeasFileName_Label: TLabel;
    SeasExplanation1_Label: TLabel;
    SeasExplanation2_Label: TLabel;
    SeasGroup_Panel: TPanel;
    SeasonHeader_Panel: TPanel;
    Seasonal_RadioGroup: TRadioGroup;
    Durations_RadioButton: TRadioButton;
    Areas_RadioButton: TRadioButton;
    Climate_RadioButton: TRadioButton;
    SurfDrain_RadioButton: TRadioButton;
    Irrigation_RadioButton: TRadioButton;
    StorEff_RadioButton: TRadioButton;
    Wells_RadioButton: TRadioButton;
    Reuse_RadioButton: TRadioButton;
    ExternHead_RadioButton: TRadioButton;
    DurationPanel: TPanel;
    DurationGrid: TStringGrid;
    DurationLabel1: TLabel;
    DurationLabel2: TLabel;

                                           {Output tabsheet}
    Output_TabSheet: TTabSheet;
    OutputOpenFile_Button: TButton;
    OutputSymbols_Button: TButton;
    GotoInput_Button: TButton;
    OutputGroupOpen_Button: TButton;
    OutputSelection_Button: TButton;
    SaveGroup_Button: TButton;
    MainSelection_Button: TButton;
    TypeSelection_Button: TButton;
    TimeSelection_Button: TButton;
    OutputCancel_Button: TButton;
    SeeGraph_Button: TButton;
    Mapping_Button: TButton;
    OutputShowMap_Button: TButton;
    PolyNr_Edit: TEdit;
    YearNr_Edit: TEdit;
    SeasNr_Edit: TEdit;
    YearNr_Label: TLabel;
    SeasNr_Label: TLabel;
    PolyNr_Label: TLabel;
    Dash1_Label: TLabel;
    Dash2_Label: TLabel;
    DashP_Label: TLabel;
    OutputWait_Memo: TMemo;
    SeasonCol_Memo: TMemo;
    SeasComment_Memo: TMemo;
    Output_Memo: TMemo;
    Season_StringGrid: TStringGrid;
    SeasonCol_Panel: TPanel;
    SeasComment_Panel: TPanel;
    MainSelection_Panel: TPanel;
    TypeSelection_Panel: TPanel;
    TimeSelection_Panel: TPanel;
    Output_RadioGroup: TRadioGroup;
    Char_RadioButton: TRadioButton;
    SoilSal_RadioButton: TRadioButton;
    SubSal_RadioButton: TRadioButton;
    OtherSal_RadioButton: TRadioButton;
    SaltSto_RadioButton: TRadioButton;
    GroundWater_RadioButton: TRadioButton;
    Discharge_RadioButton: TRadioButton;
    DepthWT_RadioButton: TRadioButton;
    Percol_RadioButton: TRadioButton;
    Capil_RadioButton: TRadioButton;
    CanalIrr_RadioButton: TRadioButton;
    IrrEff_RadioButton: TRadioButton;
    Evapo_RadioButton: TRadioButton;
    CropArea_RadioButton: TRadioButton;
    Frequency_RadioButton: TRadioButton;
    GrwtFlows_RadioButton: TRadioButton;
    Type_RadioGroup: TRadioGroup;
    Poly_RadioButton: TRadioButton;
    Time_RadioButton: TRadioButton;
    YrandSeas_GroupBox: TGroupBox;
    PolyNr_GroupBox: TGroupBox;
    OutputSalt_Image: TImage;
                                            {Graphics Tabsheet}
    Graphics_TabSheet: TTabSheet;
    BackToInputButton: TButton;
    GraphShowSymbols_Button: TButton;
    SaveGraph_Button: TButton;
    GraphOpenOutput_Button: TButton;
    GraphOpenGroup_Button: TButton;
    OpenGraph_Button: TButton;
    Graphics_Image: TImage;
    GraphSalt_Image: TImage;
    NrOfSeasons_Combo: TComboBox;
    SaveInput: TMenuItem;
    SeasPanelCancel_Button: TButton;
    ColorMapButton: TButton;
    PolyColorMap_Button: TButton;
    AvSal_RadioButton: TRadioButton;
    Select_Button: TButton;

        {General}
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShowNetworkMap(Sender: TObject);
    procedure PolyColorMap_ButtonClick(Sender: TObject);
    procedure ShowInputColumns(Sender: TObject);

        {Intro}
    procedure Intro_TabsheetShow(Sender: TObject);

        {Figure}
    procedure Figure_TabSheetShow(Sender: TObject);

        {GeneralInput_Tabsheet : Public Section}
    procedure GeneralInput_TabSheetShow(Sender: TObject);
    procedure Title1_EditExit(Sender: TObject);
    procedure Title2_EditExit(Sender: TObject);
    procedure EditEnter(Sender: TObject);
    procedure ComboEnter(Sender: TObject);
    procedure ComboAnnualIndexExit(Sender: TObject);
    procedure EditNrAddedExit (Sender: TObject);
    procedure NrAdded_EditChange(Sender: TObject);
    procedure EditNrRemovedExit (Sender: TObject);
    procedure NrRemoved_EditChange(Sender: TObject);
    procedure EditScaleExit (Sender: TObject);
    procedure EditNrOfYearsExit(Sender: TObject);
    procedure ComboNrOfSeasonsEnter(Sender: TObject);
    procedure ComboNrOfSeasonsExit(Sender: TObject);
    procedure ComboNrOfSeasonsChange(Sender: TObject);
    procedure EditOutputTimeStepExit(Sender: TObject);
    procedure ComboAccuracyLevelExit(Sender: TObject);
    procedure EditSeasonDurationExit1(Sender: TObject);
    function  StringToFloat(Str : string) : double;
    procedure EditSeasonDurationExit2(Sender: TObject);
    procedure EditSeasonDurationExit3(Sender: TObject);
    procedure EditSeasonDurationExit4(Sender: TObject);
    procedure InputOpen_Execute(Sender: TObject);
    procedure InputSave_Execute (Sender: TObject);
    procedure ShowInputSymbols(Sender: TObject);
    procedure Calculate_ButtonClick(Sender: TObject);
    procedure Restart_ButtonClick(Sender: TObject);
    procedure NodalHelp_ButtonClick(Sender: TObject);
    procedure InputSave_ButtonClick(Sender: TObject);

        {PolygonalInput_Tabsheet : Public Section}
    procedure PolygonalInput_TabSheetShow(Sender: TObject);
    procedure Poly_StringGridSelectCell(Sender: TObject; ACol,
              ARow: Integer; var CanSelect: Boolean);
    procedure MakeNetwork_ButtonClick(Sender: TObject);
    procedure ShowExplainEdit2(Sender: TObject);
    procedure HideExplainEdit2(Sender: TObject);
    procedure KrHelp_ButtonClick(Sender: TObject);
    procedure PolyGroup_ButtonClick(Sender: TObject);
    procedure PolyGroupCancel_ButtonClick(Sender: TObject);
    procedure PolyGroupSave_ButtonClick(Sender: TObject);
    procedure PolyPanelCancel_ButtonClick(Sender: TObject);
    procedure NetworkCancel_ButtonClick(Sender: TObject);
    procedure Poly_StringGridSetEditText(Sender: TObject; ACol,
              ARow: Integer; const Value: String);
    procedure HandlePasteMultiCell(Sender: TObject; ACol,
                     ARow: Integer; const Value: String);

        {SeasonalInput_Tabsheet : Public Section}
    procedure SeasonalInput_TabSheetShow(Sender: TObject);
    procedure Season_StringGridSetEditText(Sender: TObject; ACol,
              ARow: Integer; const Value: String);
    procedure SeasGroup_ButtonClick(Sender: TObject);
    procedure ShowExplainEdit3(Sender: TObject);
    procedure HideExplainEdit3(Sender: TObject);
    procedure SeasGroupCancel_ButtonClick(Sender: TObject);
    procedure SeasonGroupSave_ButtonClick(Sender: TObject);

        {Output}
    procedure Output_TabSheetShow(Sender: TObject);
    procedure OutputOpen_Execute(Sender: TObject);
    procedure OutputSymbols_ButtonClick(Sender: TObject);
    procedure Mapping_ButtonClick(Sender: TObject);
    procedure OutputSelection_ButtonClick(Sender: TObject);
    procedure MainSelection_ButtonClick(Sender: TObject);
    procedure TypeSelection_ButtonClick(Sender: TObject);
    procedure TimeSelection_ButtonClick(Sender: TObject);
    procedure PolySelection_ButtonClick(Sender: TObject);
    procedure OutputCancel_ButtonClick(Sender: TObject);
    procedure GroupOpen_Execute(Sender: TObject);
    procedure GroupSave_Execute(Sender: TObject);
    procedure SeeGraph_ButtonClick(Sender: TObject);
    procedure ReturnToInput(Sender: TObject);
    procedure Output_TabSheetExit(Sender: TObject);

        {Graphics}
    procedure Graphics_TabSheetShow(Sender: TObject);
    procedure GraphOpen_Execute(Sender: TObject);
    procedure GraphSave_Execute(Sender: TObject);
    procedure ColorMapButtonClick(Sender: TObject);

        {Finish}
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Select_ButtonClick(Sender: TObject);

        {Remaining Menu items and Actions}

  private

       {Input}
    OutFile                     : textfile;
    NoSave, GraphOpened, DoItSelf,
    SelfDone, InternalDataDone, CalcButtonUsed,
    NoRead, RunTimeError, InflowChange,
    SetToGroupSelection, ChangeOfSeasonDuration,
    AreasChecked, SetInitialDrainage,
    SetInitAquiConditions, SetInitialAreas,
    CallFirst, Critical, StartUp, SkipAgri,
    DrainChange, ResponsChange, AquiferChange,
    NrOfSeasonsChange, MakeCorrection,
    OverallSaved, NetworkSaved,
    SeasonsAdded, AgriRevised   : boolean;
    NrOfErrorLines              : integer;
    SeasonNr                    : byte;
    SeasonDurationEdit          : TSeasonDurationEdits;
    SeasonDurationLabel         : TSeasonDurationLabels;
    PolyHeaderLabel,
    SeasonHeaderLabel           : TlabelArray;


        {GeneralInput_Tabsheet : private section}
    procedure SetSeasonsGroupBoxStandards;
    procedure MakeGeneralStrings;
    procedure PresentData;
    procedure GeneralGroupSave;

        {PolygonalInput_Tabsheet : private section}
    procedure InitialDrainageSettings;
    procedure InitialAquiferSettings;
    procedure MakeOverallValues (var CheckOK : boolean);
    procedure ShowNetworkTable;
    procedure MakeNetWorkValues (var CheckOK : boolean);
    procedure ShowInternalTable;
    procedure MakeInternalValues (var CheckOK : boolean);
    procedure ShowConductivityTable;
    procedure MakeConductivityValues (var CheckOK : boolean);
    procedure ShowResistenceTable;
    procedure MakeResistenceValues (var CheckOK : boolean);
    procedure MakePolyValues (var DataOK : boolean);
    procedure ShowTotPorTable;
    procedure ShowEffPorTable;
    procedure ShowLeachingTable;
    procedure ShowAgricultTable;
    procedure ShowDrainageTable;
    procedure ShowSaltRootTable;
    procedure ShowSaltDeepTable;
    procedure ShowExtSalTable;
    procedure ShowCritDepthTable;
    procedure ShowHydHeadTable;
    procedure ShowQinflowTable;
    procedure SetPolyComponents (const Switch : string);
    procedure SetPoly_StringGridStandards;
    function  SetAndVerifySaveName : boolean;
    procedure DoCalculations;

        {SeasonalInput_Tabsheet : private section}
    procedure InitialAreaSettings;
    procedure SeeAreasTableFirst;
    procedure ShowAreasTable;
    procedure ShowClimateTable;
    procedure ShowSurfDrainTable;
    procedure ShowIrrigationTable;
    procedure ShowStorEffTable;
    procedure ShowWellDisTable;
    procedure ShowReuseTable;
    procedure ShowExtHeadTable;
    procedure MakeSeasonValues (var DataOK : boolean);
    procedure SetSeasonStringGridStandards (const Job : string);
    procedure SetSeasonComponents (const Switch : string);

        {Output_Tabsheet : private section}
    procedure SearchForData;
    procedure ShowPolyDataOfTime(Signal : string);
    procedure ShowTimeDataOfPoly(Signal : string);
    procedure FillOutputWaitMemo;

        {Graphics_Tabsheet : private section}
    procedure ShowGraphics;
    procedure FillGraphics (var Sum, Mid, Nr : integer);
    procedure HideColPanels;

        {General Items private section}
    procedure SetInitialDir (SetDir : string);
    procedure RestrictInputArrays (const DataSheet : string);
    procedure ReduceOutputArrays;

  public
    Identity, GroupsType    : string;
    GuidedOK, AreaChange,
    GuideEnded,GuideStop,
    OverallBlocked,
    NetBlocked, GroupOpened : boolean;
    InitDecSep              : char;

    procedure ShowOverallTable;

end; {end of MainForm declarations}


var
  MainForm: TMainForm;
  InitDir, DataDir : string;

implementation

uses UDataMod, UCloseForm, UExtraUtils, USymbolsForm, UColumnsForm,
     UGuidedForm, UMappingForm, UNetworkForm, USelectPolyForm, UInputData,
     UWarningForm, UDataTest, UInitialCalc, UMainCalc, UNodalHelp,
     USelectColumnForm, USelectClassesForm;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
{----------------------------------------------}
var k : integer;
begin
  inherited;
  PageControl1.ActivePageIndex := 0;                 {Introduction tabsheet}
  PolygonalInput_Tabsheet.TabVisible:=false;
  SeasonalInput_Tabsheet.TabVisible:=false;
  InitDir:=Getcurrentdir;
  SetInitialDir (InitDir);
//  DecimalSeparator := '.';
  CalcButtonUsed:=false;
  InputSave_Button.Caption:='Save general input';
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
  OverallBlocked:=false;
  NetBlocked:=false;
  AllWarning:=false;
  IrrWarning:=false;
  WellWarning:=false;
  ReUseWarning:=false;
  AreaWarning:=false;
  InitWarning:=false;
  RotaWarning:=false;
  GuideEnded:=true;
  GuideStop:=true;
  StartUp := true;
  SetInitialDrainage:=true;
  SetInitAquiConditions:=true;
  SetInitialAreas:=true;
  CallFirst:=true;
  Identity:='None';
  Poly_StringGrid.EditorMode:=true;
  Season_StringGrid.EditorMode:=true;
  GeneralExplanation2_Edit.Text:='Provisional values are shown.'+
                                 ' Move mouse over edit boxes for hints.';
  NrOfPoly_Edit.Text := '5';
//  NrOfPoly_Edit.Enabled:=false;
  NrAdded_Edit.Text := '0';
  NrRemoved_Edit.Text := '0';
  Scale_Edit.Text := '10000';
  NrOfYears_Edit.Text := '10';
  TimeStep_Edit.Text := '1';
  NrOfPoly_Edit.Hint := 'Total number of polygons, maximum 300 (200 internal'+
                  ' 100 external),  minimum 4 (1 internal, 3 external.'+
                  ' A larger version can be made available.';
  NrAdded_Edit.Hint := 'The total nr. of polygons (internal plus external)'+
                  ' can be increased   on the basis of your polygonal map';
  NrRemoved_Edit.Hint := 'The total nr. of polygons (internal plus external)'+
                  ' can be reduced on  the basis of your polygonal map';
  Scale_Edit.Hint := 'Scale of coordinates used in the polygonal map,'+
                  ' 1 cm on the map       equals "Scale" cm in the field';
  NrOfYears_Edit.Hint := 'Nr. of years for which calculations must be done,'+
                  ' maximum 99';
  AnnualCalc_Combo.Hint := 'Index indicating whether calculations'+
                  ' must be done year by  year with annual input changes.'+
                  ' 0=No, 1=Yes';
  TimeStep_Edit.Hint := 'Interval for output writing in years to reduce the'+
                  ' size of the output file when many polygons and years'+
                  ' are used.';
  Accuracy_Combo.Hint := 'Accuracy level (1-3, 3 is the most accurate)'+
                  ' for calculating ground water flow, usually level 1'+
                  ' is amply sufficient';
  NrAdded_Edit.OnEnter := EditEnter;
  NrRemoved_Edit.OnEnter := EditEnter;
  Scale_Edit.OnEnter := EditEnter;
  NrOfYears_Edit.OnEnter := EditEnter;
  AnnualCalc_Combo.OnEnter := ComboEnter;
  TimeStep_Edit.OnEnter := EditEnter;
  Accuracy_Combo.OnEnter := ComboEnter;
  NrAdded_Edit.OnExit := EditNrAddedExit;
  NrRemoved_Edit.OnExit := EditNrRemovedExit;
  Scale_Edit.OnExit := EditScaleExit;
  NrOfYears_Edit.OnExit := EditNrOfYearsExit;
  NrOfSeasons_Combo.OnEnter := ComboNrOfSeasonsEnter;
  NrOfSeasons_Combo.OnChange := ComboNrOfSeasonsChange;
  NrOfSeasons_Combo.OnExit := ComboNrOfSeasonsExit;
  AnnualCalc_Combo.OnExit := ComboAnnualIndexExit;
  TimeStep_Edit.OnExit := EditOutputTimeStepExit;
  Accuracy_Combo.OnExit := ComboAccuracyLevelExit;

  SeasonDurations_GroupBox.Height:= 96;
  for k:=1 to 4 do
  begin
    SeasonDurationEdit[k]:= TEdit.Create(self);
    SeasonDurationEdit[k].Parent:= SeasonDurations_GroupBox;
    SeasonDurationEdit[k].Left:= 112;
    SeasonDurationEdit[k].Height:= 24;
    SeasonDurationEdit[k].Width:= 57;
    SeasonDurationEdit[k].Hint:= 'Duration of season '+IntToStr(k)+
                        ' in whole months, annual sum of durations is 12';
    SeasonDurationEdit[k].OnEnter := EditEnter;
    SeasonDurationLabel[k]:= TLabel.Create(self);
    SeasonDurationLabel[k].Parent:= SeasonDurations_GroupBox;
    SeasonDurationLabel[k].Left:= 16;
    SeasonDurationLabel[k].Width:= 81;
    SeasonDurationLabel[k].Height:=24;
    SeasonDurationLabel[k].Caption:= 'Season '+IntToStr(k);
    if k<3 then
    begin
      SeasonDurationEdit[k].Text:= '6';
      SeasonDurationEdit[k].Visible:= true;
    end else
    begin
      SeasonDurationEdit[k].Text:= '0';
      SeasonDurationEdit[k].Visible:= false;
    end;
    if k=1 then
    begin
       SeasonDurationEdit[k].Top:= 32;
       SeasonDurationLabel[k].Top:= 32;
    end else
    begin
       SeasonDurationEdit[k].Top:=SeasonDurationEdit[k-1].Top +32;
       SeasonDurationLabel[k].Top:=SeasonDurationLabel[k-1].Top +32;
    end;
//    DurationOfSeason := SeasonDurationEdit[k].Text;
    SeasonNr:=k;
    if k=1 then SeasonDurationEdit[1].OnExit:=EditSeasonDurationExit1;
    if k=2 then SeasonDurationEdit[2].OnExit:=EditSeasonDurationExit2;
    if k=3 then SeasonDurationEdit[3].OnExit:=EditSeasonDurationExit3;
    if k=4 then SeasonDurationEdit[4].OnExit:=EditSeasonDurationExit4;
  end; {for k:=1 to 4 do}
  DurationGrid.Cells[0,0]:='  1';
  DurationGrid.Cells[0,1]:='  2';
  DurationGrid.Cells[0,2]:='  3';
  DurationGrid.Cells[0,3]:='  4';
  Left := 100;
  if screen.Width > 860 then
            Width := 760
     else if screen.Width < width then
     begin
            Left := 5;
            Width := screen.Width-5;
     end;
   InitDecSep := DecimalSeparator;
end;{TMainForm.FormCreate}
{------------------------}


{******************************************************************************
 Introduction TabSheet
 ******************************************************************************}


procedure TMainForm.Intro_TabsheetShow(Sender: TObject);
begin
  inherited;
  StatusText ('Use the Input tabsheet to continue');
end; {TMainForm.Intro_TabsheetShow}
{---------------------------------}


{******************************************************************************
 End of Intro Tabsheet, start of Figure TabSheet
 ******************************************************************************}


procedure TMainForm.Figure_TabSheetShow(Sender: TObject);
begin Inherited;
  StatusText ('The figure gives explanations of symbols used in the' +
              ' input tabsheet');
end;{TMainForm.Figure_TabSheetShow}


{******************************************************************************
 End of Figure Tabsheet, start of Input TabSheets
 ******************************************************************************}


procedure TMainForm.ShowInputSymbols(Sender: TObject);
{-------------------------------------------------------------}
begin
  inherited;
  Mode:='Input';
  SymbolsForm.Show;
end; {TMainForm.InputSymbols_ButtonClick}
{---------------------------------------}



procedure TMainForm.NodalHelp_ButtonClick(Sender: TObject);
{-------------------------------------------------------------}
begin
  inherited;
  NodalHelpForm.Show;
end; {TMainForm.NodalHelp_ButtonClick}
{---------------------------------------}



procedure TMainForm.ShowNetworkMap(Sender: TObject);
{---------------------------------------------------}
begin
  inherited;
  NetworkForm.Hide;
  if SelfDone or InputOpened then
  begin
    DataMod.ReadOverallGroup;
    if not (Identity='None') then DataMod.ReadNetworkGroup('Starting');
  end;
  if (DataMod.Title1='') and (DataMod.Title2='') then
  begin
    DataMod.Title1:='NO TITLES WERE GIVEN.  This is the network map';
    DataMod.Title2:='Internal nodes are surrounded by polygonal boundaries';
  end;
  if Internal_RadioButton.Checked then
  begin
    DataMod.ColorMap:=true;
    SelectClassesForm.Classes_ComboBox.ItemIndex:=0;
    DataMod.ReadPolyGroup ('Name02',4);
    DataMod.ColorMap:=true;
  end;
  NetworkForm.Show;
end; {TMainForm.ShowNetworkmap}
{-----------------------------}


procedure TMainForm.PolyColorMap_ButtonClick(Sender: TObject);
begin
  inherited;
(*
  NetworkForm.Hide;
  MappingForm.Hide;
  DataMod.ColorMap:=true;

    DataMod.ColorMap:=true;
    SelectClassesForm.Classes_ComboBox.ItemIndex:=0;
    DataMod.ReadPolyGroup ('Name02',4);
*)
    NetworkForm.Hide;
    MappingForm.Hide;
    DataMod.ReadPolyGroup ('Name02',4);
    DataMod.ColorMap:=true;
    SelectClassesForm.Classes_ComboBox.ItemIndex:=0;
    SelectClassesForm.Classes_ComboBoxChange (Sender);
    SelectClassesForm.Visible:=true;

    with NetWorkForm do
    begin
      MaxMin;
      if (Ymax[1]=-10000000) or (Ymin[1]=1000000) then
      begin
        showmessage ('This column contains no data. Please select another one.');
        exit;
      end;
      Xrel:=abs(Ymax[1]);
      Yrel:=abs(Ymin[1]);
      Limit[1]:=Yrel+(Xrel-Yrel)/7;
      Limit[2]:=Yrel+2*(Xrel-Yrel)/7;
      Limit[3]:=Yrel+3*(Xrel-Yrel)/7;
      Limit[4]:=Yrel+4*(Xrel-Yrel)/7;
      Limit[5]:=Yrel+5*(Xrel-Yrel)/7;
      Limit[6]:=Yrel+6*(Xrel-Yrel)/7;
      SelectClassesForm.Classes_Grid.Cells[1,1]:=
                        format('%4.2f',[Limit[1]]);
      SelectClassesForm.Classes_Grid.Cells[1,2]:=
                        format('%4.2f',[Limit[2]]);
      SelectClassesForm.Classes_Grid.Cells[1,3]:=
                        format('%4.2f',[Limit[3]]);
      SelectClassesForm.Classes_Grid.Cells[1,4]:=
                        format('%4.2f',[Limit[4]]);
      SelectClassesForm.Classes_Grid.Cells[1,5]:=
                        format('%4.2f',[Limit[5]]);
      SelectClassesForm.Classes_Grid.Cells[1,6]:=
                        format('%4.2f',[Limit[6]]);
    end;
//  ShowNetworkMap(Sender);
end;



procedure TMainForm.Mapping_ButtonClick(Sender: TObject);
{-------------------------------------------------------}
begin
  inherited;
  MappingForm.Show;
end; {TMainForm.Mapping_ButtonClick}
{-------------------------------}



procedure TMainForm.ShowInputColumns(Sender: TObject);
{----------------------------------------------------}
begin
  inherited;
  ColumnsForm.Show;
end; {TMainForm.ShowInputColumns}
{-------------------------------}



procedure TMainForm.ReturnToInput(Sender: TObject);
{-------------------------------------------------}
begin
  inherited;
  SetPolyComponents ('ToGroupSelection');
  GeneralInput_Tabsheet.TabVisible:=true;
  OutputOpened:=false;
  Output_Memo.Lines.Clear;
  GroupOpened:=false;
  Output_Memo.Visible:=false;
  SeeGraph_Button.Enabled:=false;
  SaveGroup_Button.Enabled:=false;
  Graphics_Image.Visible:=false;
  GraphSalt_Image.Visible:=true;
  TypeSelection_Panel.Visible := false;
  TimeSelection_Panel.Visible := false;
  PolySelection_Panel.Visible := false;
  OutputShowMap_Button.Visible:= false;
  Mapping_Button.Visible := false;
  OutputCancel_Button.Visible := false;
  InputOpened:=false;
  DataMod.YearNr:=0;
  if CalcDone then
  begin
    chdir (InitDir);
    ReduceOutputArrays;
  end; {if CalcDone then}
  showmessage ('Initial standard input will be shown. You may edit this or'+
               ' open an existing input file.');
  Restart_ButtonClick(Sender);
  GeneralInput_TabsheetShow (Sender);
  GeneralInput_Tabsheet.Show;
end; {TMainForm.ReturnToInput}
{----------------------------}



{******************************************************************************
 General Input TabSheet : Public Section
*******************************************************************************}


procedure TMainForm.GeneralInput_TabSheetShow(Sender: TObject);
{-------------------------------------------------------------}
begin Inherited;
      DataMod.RemovalStage:=false;
      GuidedOK:=false;
      progressbar1.Visible:=false;
      if not Datamod.AnnualCalc or DataMod.EndOfAnnual then DataMod.YearNr:=0;
      AllWarning:=false;
      IrrWarning:=false;
      WellWarning:=false;
      ReUseWarning:=false;
      AreaWarning:=false;
      InitWarning:=false;
      RotaWarning:=false;
      if not InputOpened then
      begin
        InputSave_Button.Caption:='Save general input';
        StatusText('Enter data or use "Open input" to see examples in any' +
                   ' folder or to edit existing files. Thereafter use' +
                   ' "Save general input".');
        NrRemoved_Edit.Enabled:=false;
        PolygonalInput_Tabsheet.TabVisible:=false;
        SeasonalInput_Tabsheet.TabVisible:=false;
      end else
      begin
        GeneralExplanation2_Edit.Text:='';
        InputSave_Button.Caption:='Save all/calculate';
        NrRemoved_Edit.Enabled:=true;
        PolygonalInput_Tabsheet.TabVisible:=true;
        SeasonalInput_Tabsheet.TabVisible:=true;
        StatusText('Enter data, then use "Save data" and proceed to other'+
           ' data tabsheets, or use "Save/calculate" to save all data and do'+
           ' calculations.');
      end;

      if not InputOpened and not CalcDone then with DataMod do
//When does this occur? When coming in from another tabsheet
      begin
        if not SelfDone then
        begin
          if not StartUp then Restart_ButtonClick (Sender);
          StartUp:=False;
          DataMod.AnnualCalc:=false;
        end;
        if DataMod.AnnualCalc then
        begin
          GenFileOpen_Button.Enabled := false;
          InputOpen.Enabled := false;
         end else
         begin
          GenFileOpen_Button.Enabled := true;
          InputOpen.Enabled := true;
         end;
      end;

      AnnualGen_Memo.Visible:=false;
      NrAdded_Edit.Enabled:=true;
      NrRemoved_Edit.Enabled:=true;
      Scale_Edit.Enabled:=true;
      NrOfYears_Edit.Enabled:=true;
      AnnualCalc_Combo.Enabled:=true;
      TimeStep_Edit.Enabled:=true;
      Accuracy_Combo.Enabled:=true;
      if DataMod.AnnualCalc and (DataMod.YearNr>0) then
      begin
        AnnualGen_Memo.Visible:=true;
        NrAdded_Edit.Enabled:=false;
        NrRemoved_Edit.Enabled:=false;
        Scale_Edit.Enabled:=false;
        NrOfYears_Edit.Enabled:=false;
        AnnualCalc_Combo.Enabled:=false;
        TimeStep_Edit.Enabled:=false;
        Accuracy_Combo.Enabled:=false;
      end;
      SeeGraph_Button.Enabled:=false;
      SaveGroup_Button.Enabled:=false;
      TypeSelection_Panel.Visible := false;
      TimeSelection_Panel.Visible := false;
      PolySelection_Panel.Visible := false;
      OutputCancel_Button.Visible := false;
      if OutputOpened then
      begin
        OutputSelection_Button.Enabled := true;
        MainSelection_Button.Visible := true;
      end;
end; {TMainForm.GeneralInput_TabSheetShow}
{----------------------------------------}


procedure TMainForm.Title1_EditExit(Sender: TObject);
begin
  inherited;
  DataMod.Title1:=Title1_Edit.Text;
end;


procedure TMainForm.Title2_EditExit(Sender: TObject);
begin
  inherited;
  DataMod.Title2:=Title2_Edit.Text;
end;


procedure TMainForm.EditEnter(Sender: TObject);
{---------------------------------------------}
var MemoLine, MemoLine1, MemoLine2 : string;
begin Inherited;
      MemoLine := (Sender as Tedit).Hint;
      if length(MemoLine)>70 then
      begin
        MemoLine1 := copy(MemoLine,1,70);
        MemoLine2 := copy(MemoLine,71,length(MemoLine));
        GeneralExplanation1_Edit.Visible := true;
        GeneralExplanation1_Edit.Text := Memoline1;
        GeneralExplanation2_Edit.Text := MemoLine2;
      end else
      begin
        GeneralExplanation2_Edit.Text := MemoLine;
        GeneralExplanation1_Edit.Visible := false;
      end;
end; {TMainForm.EditEnter}
{------------------------}



procedure TMainForm.ComboEnter(Sender: TObject);
{---------------------------------------------}
var MemoLine, MemoLine1, MemoLine2 : string;
begin Inherited;
      MemoLine := (Sender as TComboBox).Hint;
      if length(MemoLine)>70 then
      begin
        MemoLine1 := copy(MemoLine,1,70);
        MemoLine2 := copy(MemoLine,71,length(MemoLine));
        GeneralExplanation1_Edit.Visible := true;
        GeneralExplanation1_Edit.Text := Memoline1;
        GeneralExplanation2_Edit.Text := MemoLine2;
      end else
      begin
        GeneralExplanation2_Edit.Text := MemoLine;
        GeneralExplanation1_Edit.Visible := false;
      end;
end; {TMainForm.EditEnter}
{------------------------}



procedure TMainForm.EditNrAddedExit (Sender: TObject);
{----------------------------------------------------}
var HlpInt : integer;
begin
  Try
    begin
      HlpInt := StrToInt (NrAdded_Edit.Text);      {nr to be added}
      NrAdded_Edit.Text := IntToStr(HlpInt);
    end;
    Except on E: exception do
    begin
      Showmessage ('The Nr to be added is not a true integer');
      NrAdded_Edit.Text := '0';
      exit;
    end;
  end;
  if InputOpened then
  begin
    if HlpInt<0 then
    begin
      Showmessage ('Negative values are not permitted.');
      exit;
    end;
    if (HlpInt>0) then
    begin
      PolygonalInput_Tabsheet.TabVisible:=false;
      SeasonalInput_Tabsheet.TabVisible:=false;
    end else
    begin
      PolygonalInput_Tabsheet.TabVisible:=true;
      SeasonalInput_Tabsheet.TabVisible:=true;
    end;
  end;
  DataMod.NrOfNodesAdded:=StrToInt(NrAdded_Edit.Text);
  InputSave_Button.Caption:='Save general input';
  StatusText('Enter data or use "Open input" to see examples in any' +
             ' folder or to edit existing files. Thereafter use' +
             ' "Save general input".');
end; {TMainForm.EditNrAddedExit}
{------------------------------}



procedure TMainForm.NrAdded_EditChange(Sender: TObject);
{------------------------------------------------------}
begin
  if InputOpened then
  begin
    PolygonalInput_Tabsheet.TabVisible:=false;
    SeasonalInput_Tabsheet.TabVisible:=false;
  end;
  InputSave_Button.Caption:='Save general input';
  StatusText('Enter data or use "Open input" to see examples in any' +
             ' folder or to edit existing files. Thereafter use' +
             ' "Save general input".');
end;{TMainForm.NrAdded_EditChange}
{--------------------------------}



procedure TMainForm.EditNrRemovedExit (Sender: TObject);
{------------------------------------------------------}
var HlpInt : integer;
begin
  Try
    HlpInt := StrToInt (NrRemoved_Edit.Text);      {nr to be removed}
    Except on E: exception do
    begin
      Showmessage ('The Nr to be removed is not a true integer');
      NrRemoved_Edit.Text := '0';
      exit;
    end;
  end;
  if HlpInt<0 then
  begin
    Showmessage ('Negative values are not permitted.');
    exit;
  end;
  DataMod.NrOfNodesRemoved:=HlpInt;
  InputSave_Button.Caption:='Save general input';
  StatusText('Enter data or use "Open input" to see examples in any' +
             ' folder or to edit existing files. Thereafter use' +
             ' "Save general input".');
end; {TMainForm.EditNrRemovedExit}
{--------------------------------}



procedure TMainForm.NrRemoved_EditChange(Sender: TObject);
{--------------------------------------------------------}
begin
  inherited;
    InputSave_Button.Caption:='Save general input';
    StatusText('Enter data or use "Open input" to see examples in any' +
               ' folder or to edit existing files. Thereafter use' +
               ' "Save general input".');
    PolygonalInput_Tabsheet.TabVisible:=false;
    SeasonalInput_Tabsheet.TabVisible:=false;
end; {TMainForm.NrRemoved_EditChange}
{-----------------------------------}



procedure TMainForm.EditScaleExit (Sender: TObject);
{--------------------------------------------------}
var HlpInt : longint;
begin
  Try
    begin
      HlpInt := StrToInt (Scale_Edit.Text);
      Scale_Edit.Text := IntToStr(HlpInt);
    end;
    Except on E: exception do
    begin
      Showmessage ('The Scale is not a true integer');
      exit;
    end;
  end;
  if HlpInt<0 then
  begin
    Showmessage ('Negative values are not permitted.');
    exit;
  end;
  DataMod.Scale:=HlpInt;
end; {TMainForm.EditScaleExit}
{----------------------------}



procedure TMainForm.EditNrOfYearsExit(Sender: TObject);
{-----------------------------------------------------}
var HlpInt : integer;
begin
  inherited;
  Try
    HlpInt := StrToInt (NrOfYears_Edit.Text);      {nr of years}
    Except on E: exception do
    begin
      Showmessage ('The number of years is not a true integer');
      NrOfYears_Edit.Text := IntToStr(DataMod.NrOfYears);
      exit;
    end;
  end;
  if HlpInt>99 then
  begin
    Showmessage ('The number of years for calculations must be'+
                 ' less than 100');
    exit;
  end;
  if HlpInt<1 then
  begin
    Showmessage ('The number of years must be at least 1.');
    exit;
  end;
  DataMod.NrOfYears := HlpInt;
end; {TMainForm.EditNrOfYearsExit}
{--------------------------------}



procedure TMainForm.ComboNrOfSeasonsEnter(Sender: TObject);
{---------------------------------------------------------}
var MemoLine, MemoLine1, MemoLine2 : string;
begin
  inherited;
      DataMod.InitNrOfSeasons := NrOfSeasons_Combo.ItemIndex+1;
      MemoLine := (Sender as TComboBox).Hint;
      if length(MemoLine)>70 then
      begin
        MemoLine1 := copy(MemoLine,1,70);
        MemoLine2 := copy(MemoLine,71,length(MemoLine));
        GeneralExplanation1_Edit.Visible := true;
        GeneralExplanation1_Edit.Text := Memoline1;
        GeneralExplanation2_Edit.Text := MemoLine2;
      end else
      begin
        GeneralExplanation2_Edit.Text := MemoLine;
        GeneralExplanation1_Edit.Visible := false;
      end;
end; {ComboNrOfSeasonsEnter}
{--------------------------}



procedure TMainForm.ComboNrOfSeasonsExit(Sender: TObject);
{--------------------------------------------------------}
begin
  inherited;
  SetSeasonsGroupBoxStandards;
  InputSave_Button.Caption:='Save general input';
  StatusText('Enter data or use "Open input" to see examples in any' +
             ' folder or to edit existing files. Thereafter use' +
             ' "Save general input".');
end;{TMainForm.ComboNrOfSeasonsExit}
{----------------------------------}



procedure TMainForm.ComboNrOfSeasonsChange(Sender: TObject);
{----------------------------------------------------------}
var j, HlpInt : integer;
begin
  inherited;
    HlpInt := NrOfSeasons_Combo.ItemIndex+1;                    {nr of seasons}
    NrOfSeasons_Combo.Text:=IntToStr(HlpInt);
    DataMod.NrOfSeasonsAdded:=HlpInt-DataMod.InitNrOfSeasons;
    DataMod.NrOfSeasons:=HlpInt;
    SeasonsAdded:=false;
    for j:=HlpInt to 4 do DataMod.SeasonDuration[j]:=0;
    if DataMod.NrOfSeasonsAdded<>0 then SeasonsAdded:=true;
    SetSeasonsGroupBoxStandards;
    if InputOpened and (DataMod.NrOfSeasonsAdded<>0) then
    begin
       Showmessage ('The number of seasons was changed. The season'+
       ' durations, the external boundary conditions in the polygonal data'+
       ' tabsheet and all data groups in the seasonal data tabsheet need'+
       ' to be adjusted.');
       PolygonalInput_Tabsheet.TabVisible:=false;
       SeasonalInput_Tabsheet.TabVisible:=false;
    end;
end;{TMainForm.ComboNrOfSeasonsChange}
{------------------------------------}



procedure TMainForm.ComboAnnualIndexExit(Sender: TObject);
{-------------------------------------------------------}
begin
  inherited;
  DataMod.AnnualIndex := AnnualCalc_Combo.ItemIndex;
end; {TMainForm.ComboAnnualIndexExit}
{-----------------------------------}



procedure TMainForm.EditOutputTimeStepExit(Sender: TObject);
{----------------------------------------------------------}
var HlpInt : integer;
begin
  inherited;
  Try
    HlpInt := StrToInt(TimeStep_Edit.Text);
    Except on E: exception do
    begin
      Showmessage ('The output time step is not a valid integer');
      exit;
    end;
  end;
  if (HlpInt<1) or ((DataMod.NrOfYears>0) and (HlpInt>DataMod.NrOfYears)) then
  begin
    Showmessage ('The output time step is at least 1 and maximum'+
                 ' the nr. years for calculations');
    exit;
  end;
  DataMod.OutputTimeStep := HlpInt;
end; {TMainForm.EditOutputTimeStepExit}
{-------------------------------------}



procedure TMainForm.ComboAccuracyLevelExit(Sender: TObject);
{---------------------------------------------------------}
var HlpInt : integer;
begin
  inherited;
  HlpInt := Accuracy_Combo.ItemIndex+1;
  DataMod.AccuracyLevel := HlpInt;;
end; {TMainForm.EditOutputTimeStepExit}
{-------------------------------------}



procedure TMainForm.SetSeasonsGroupBoxStandards;
{----------------------------------------------}
var k : byte;
begin
  SeasonDurations_GroupBox.Height:= 32+DataMod.NrOfSeasons*32;
  for k:=1 to 4 do
  begin
    if k<=DataMod.NrOfSeasons then
    begin
      SeasonDurationEdit[k].Text:= FloatToStr(DataMod.SeasonDuration[k]);
      SeasonDurationEdit[k].Visible:= true;
    end else
    begin
      SeasonDurationEdit[k].Text:= '0';
      SeasonDurationEdit[k].Visible:= false;
    end;
    if DataMod.NrOfSeasons=1 then SeasonDurationEdit[k].Text:='12'
  end; {for k:=1 to 4 do}
end;{TMainForm.SetSeasonsGroupBoxStandards}
{-----------------------------------------}



procedure TMainForm.EditSeasonDurationExit1;
{------------------------------------------}
var InitSeasonDuration : real;
begin Inherited;
      InitSeasonDuration:=DataMod.SeasonDuration[1];
      Try
         (Sender as TEdit).Text :=
             IntToStr(StrToInt((Sender as TEdit).Text));
         Except on E: exception do
         begin
           ShowMessage
             ((Sender as TEdit).Text + ' is not a valid integer');
            (Sender as TEdit).Text :=
                              FloatToStr(DataMod.SeasonDuration[SeasonNr]);
            exit;
         end;
      end;
      if (StrToInt((Sender as TEdit).Text)<1) or
         (StrToInt((Sender as TEdit).Text)>13-DataMod.NrOfSeasons) then
         begin
           Showmessage ('The duration of the season ranges from 1 to '+
                         FloatToStr(13-DataMod.NrOfSeasons));
            (Sender as TEdit).Text :=
                              FloatToStr(DataMod.SeasonDuration[SeasonNr]);
            exit;
          end;
      DataMod.SeasonDuration[1]:=StringToFloat((Sender as TEdit).Text);
      DecimalSeparator:=InitDecSep;
      if DataMod.SeasonDuration[1]<>InitSeasonDuration then
         ChangeOfSeasonDuration:=true;
end; {TMainForm.EditSeasonDurationExit1}
{--------------------------------------}



function TMainForm.StringToFloat(Str : string) : double;
{------------------------------------------------------}
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
end; {TSegRegForm.StringToFloat}
{------------------------------}



procedure TMainForm.EditSeasonDurationExit2;
{------------------------------------------}
var InitSeasonDuration : real;
begin Inherited;
      InitSeasonDuration:=DataMod.SeasonDuration[2];
      Try
         (Sender as TEdit).Text :=
             IntToStr(StrToInt((Sender as TEdit).Text));
         Except on E: exception do
         begin
           ShowMessage
             ((Sender as TEdit).Text + ' is not a valid integer');
            (Sender as TEdit).Text :=
                              FloatToStr(DataMod.SeasonDuration[SeasonNr]);
            exit;
         end;
      end;
      if (StrToInt((Sender as TEdit).Text)<1) or
         (StrToInt((Sender as TEdit).Text)>13-DataMod.NrOfSeasons) then
         begin
           Showmessage ('The duration of the season ranges from 1 to '+
                         FloatToStr(13-DataMod.NrOfSeasons));
            (Sender as TEdit).Text :=
                              FloatToStr(DataMod.SeasonDuration[SeasonNr]);
            exit;
          end;
      DataMod.SeasonDuration[2]:=StringToFloat((Sender as TEdit).Text);
      DecimalSeparator:=InitDecSep;
      if DataMod.SeasonDuration[2]<>InitSeasonDuration then
         ChangeOfSeasonDuration:=true;
end; {TMainForm.EditSeasonDurationExit2}
{--------------------------------------}



procedure TMainForm.EditSeasonDurationExit3;
{------------------------------------------}
var InitSeasonDuration : real;
begin Inherited;
      InitSeasonDuration:=DataMod.SeasonDuration[3];
      Try
         (Sender as TEdit).Text :=
             IntToStr(StrToInt((Sender as TEdit).Text));
         Except on E: exception do
         begin
           ShowMessage
             ((Sender as TEdit).Text + ' is not a valid integer');
            (Sender as TEdit).Text :=
                              FloatToStr(DataMod.SeasonDuration[SeasonNr]);
            exit;
         end;
      end;
      if (StrToInt((Sender as TEdit).Text)<1) or
         (StrToInt((Sender as TEdit).Text)>13-DataMod.NrOfSeasons) then
         begin
           Showmessage ('The duration of the season ranges from 1 to '+
                         FloatToStr(13-DataMod.NrOfSeasons));
            (Sender as TEdit).Text :=
                              FloatToStr(DataMod.SeasonDuration[SeasonNr]);
            exit;
          end;
      DataMod.SeasonDuration[3]:=StringToFloat((Sender as TEdit).Text);
      DecimalSeparator:=InitDecSep;
      if DataMod.SeasonDuration[3]<>InitSeasonDuration then
         ChangeOfSeasonDuration:=true;
end; {TMainForm.EditSeasonDurationExit3}
{--------------------------------------}



procedure TMainForm.EditSeasonDurationExit4;
{------------------------------------------}
var InitSeasonDuration : real;
begin Inherited;
      InitSeasonDuration:=DataMod.SeasonDuration[4];
      Try
         (Sender as TEdit).Text :=
             IntToStr(StrToInt((Sender as TEdit).Text));
         Except on E: exception do
         begin
           ShowMessage
             ((Sender as TEdit).Text + ' is not a valid integer');
            (Sender as TEdit).Text :=
                              FloatToStr(DataMod.SeasonDuration[SeasonNr]);
            exit;
         end;
      end;
      if (StrToInt((Sender as TEdit).Text)<1) or
         (StrToInt((Sender as TEdit).Text)>13-DataMod.NrOfSeasons) then
         begin
           Showmessage ('The duration of the season ranges from 1 to '+
                         FloatToStr(13-DataMod.NrOfSeasons));
            (Sender as TEdit).Text :=
                              FloatToStr(DataMod.SeasonDuration[SeasonNr]);
            exit;
          end;
      DataMod.SeasonDuration[4]:=StringToFloat((Sender as TEdit).Text);
      DecimalSeparator:=InitDecSep;
      if DataMod.SeasonDuration[4]<>InitSeasonDuration then
         ChangeOfSeasonDuration:=true;
end; {TMainForm.EditSeasonDurationExit4}
{--------------------------------------}

(*
procedure TMainForm.SeasonDurations_GroupBoxExit(Sender: TObject);
begin
  inherited;
  if InputOpened then if ChangeOfSeasonDuration then
     showmessage ('The season durations were changed. Please adjust '+
                  'the seasonal data.');
end;
*)

{Action: FileOpen, Menu: InputOpen}
{---------------------------------}
procedure TMainForm.InputOpen_Execute(Sender: TObject);
{-----------------------------------------------------}
var YesOK : boolean;
begin Inherited;
  if DirectoryExists (InitDir) then chdir (InitDir);
  DeleteGroupFiles;                                {GroupFiles are "Name"files}
  if DirectoryExists (DataDir) then chdir (DataDir);
  DeleteGroupFiles;
  NrRemoved_Edit.Enabled:=true;
  with DataMod do
  begin
(*
    if AnnualCalc and (YearNr<1) and not EndOfAnnual then
    begin
      YesOK:=Question('By opening an input file the annual calculations'+
                       ' will be interrupted and the present data will not'+
                       ' be saved.  Is that OK?');
      if not YesOK then exit;
    end else
*)

//    if InputOpened then
    if InputOpened and not AnnualCalc then
    begin
      YesOK:=Question('By opening an input file the present data will'+
                       ' not be saved. Is that OK?');
      if not YesOK then exit;
    end;
    if MainForm.InputOpen_Dialog.Execute then
    begin
      OpenFilename := MainForm.InputOpen_Dialog.Files.Strings[0];
      DataDir:=extractfilepath(OpenFileName);
      SaveFileName:='';
      SetInitialDir (DataDir);                  {does not always work properly}
      if FileExists (OpenFilename) then
      begin
         chdir (DataDir);
         ReadInputs (DoItSelf);
         SetSeasonsGroupBoxStandards;
         NrOfNodesAdded:=0;
         NrOfNodesRemoved:=0;
         NrOfSeasonsAdded:=0;
         Critical:=false;
         PresentData;
        //makes strings of general data ('Name0' file) for GeneralInput_Tabsheet
      end else
      begin
        NrRemoved_Edit.Enabled:=false;
        InputOpened:=false;
        Showmessage ('File does not exist, please select another one,');
        exit;
      end;
    end
    else
    begin
      NrRemoved_Edit.Enabled:=false;
      InputOpened:=false;
      ShowMessage('No input file was selected');
      exit;
    end;
    GeneralFileName_Label.Caption:=OpenFileName;
    GeneralFileName_Label.Visible:=true;
    GeneralFile_Label.Visible:=true;
    PolyFileName_Label.Caption:=OpenFileName;
    SeasFileName_Label.Caption:=OpenFileName;
    Title1_Edit.Text:=Title1;
    Title2_Edit.Text:=Title2;
  end; {with DataMod do}
  CalcDone:=false;
  InputSave_Button.Caption:='Save all/calculate';
  StatusText('Enter data, then use "Save data" and proceed to other'+
             ' data tabsheets, or use "Save/calculate" to save all data and'+
             ' do calculations.');
  InputOpened := true;
  PolygonalInput_Tabsheet.TabVisible:=true;
  SeasonalInput_Tabsheet.TabVisible:=true;
  GraphSalt_Image.Visible:=true;
  OutputSalt_Image.Visible:=true;
  Output_Memo.Visible:=false;
  Graphics_Image.Visible:=false;
  WarningForm.Visible:=false;
  GeneralWait_Memo.Visible:=false;
  AnnualGen_Memo.Visible:=false;
  NodalHelp_Button.Visible:=false;
  DataMod.ColorMap:=false;
  NrAdded_Edit.Enabled:=true;
  NrRemoved_Edit.Enabled:=true;
  Scale_Edit.Enabled:=true;
  NrOfYears_Edit.Enabled:=true;
  AnnualCalc_Combo.Enabled:=true;
  TimeStep_Edit.Enabled:=true;
  Accuracy_Combo.Enabled:=true;
  DataMod.YearNr:=0;
  NetWorkForm.Hide;

end; {TMainForm.InputOpen_Execute}
{--------------------------------}



{Action: InputSave, Menu: InputSave}
{----------------------------------}
procedure TMainForm.InputSave_Execute (Sender: TObject);
{------------------------------------------------------}
label 1;
var DataOK, YesOK : boolean;
    OriginalDir, PreviousDir, NewDataDir : string;
    Count, k       : integer;

begin Inherited;
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
       Showmessage ('The input data were not saved');
       exit;
     end;
     BriefFileName:= ExtractFileName (SaveFileName);
     Count:=0;
     for k:=1 to length(BriefFileName) do
       if SaveFileName[k]='.' then Count:=Count+1;
     if Count>1 then
     begin
       Showmessage ('The number of dots (.) in the file name'+
                    ' should not be greater than 1. Please adjust.');
       goto 1;
     end;
//Provisions for annual calculations
     WarningForm.Visible:=false;
     if YearNr<1 then OriginalName:=OpenFileName;
     OriginalDir := ExtractFilePath(OriginalName);
     if OriginalDir='' then OriginalDir:=Initdir+'\';
     NewDataDir := ExtractFilePath(SaveFileName);
     if OriginalDir<>NewDataDir then if AnnualCalc and (YearNr>1) then
     begin
       if fileexists (SaveFileName) then deletefile (SaveFileName);
       Showmessage (' During calculations with annual input changes,'+
                    ' the data-path cannot be changed. Please save'+
                    ' the input file in '+OriginalDir);
       goto 1;
     end;
//Actions for old and new data directory which may be different in case of
//not-annual calculations
     GeneralWait_Memo.Lines.Clear;
     GeneralWait_Memo.Lines.Add(' Saving the data');
     sleep (500);
     GeneralWait_Memo.Visible:=true;
     SetInitialDir (NewDataDir);
     DataDir:=NewDataDir;                         {for use in other procedures}
//Move the "Name" files (GroupFiles) from the old DataDir to the new DataDir
     if PreviousDir<>NewDataDir then
        MoveGroupFiles (PreviousDir, NewDataDir);
     if PreviousDir<>NewDataDir then
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
       Showmessage ('Input file could not be saved due to missing temporary'+
                    ' files');
       exit;
     end;
     if YearNr<1 then OriginalName:=SaveFileName;
     BriefFileName:=ChangeFileExt (SaveFileName,'');
     BriefFileName:=extractfilename(BriefFileName);
     GeneralFileName_Label.Caption := DataMod.SaveFileName;
     PolyFileName_Label.Caption := DataMod.SaveFileName;
     SeasFileName_Label.Caption := DataMod.SaveFileName;
     GuidedOK:=false;
     SelfDone:=false;
     YesOK := Question ('The data were saved as  '+BriefFileName+'.inp and  '
                        +BriefFileName+'Input.txt  The latter gives a record'+
                        ' of input data.  A cross check will be done'+
                        ' during calculations.  Do you wish to do the'+
                        ' calculations?');
     if YesOK then
     begin
       if AnnualCalc and (YearNr>0) then
       begin
         NrOfYears:=1;
         AnnualFileName:=SaveFileName;
         SaveFileName:=OriginalName;
       end;
       ChDir(InitDir);
       DoCalculations;
     end else
     begin
       chdir (InitDir);
       GeneralWait_Memo.Visible:=false;
     end;
  end; {with DataMod do}
end; {TMainForm.InputSave_Execute}
{--------------------------------}


procedure TMainForm.GeneralGroupSave;
{-----------------------------------}
var DataOK : boolean;
    k : byte;
begin
  inherited;
  Critical:=false;
  if not InputOpened then
  begin
    StartUp:=true;
    DataMod.TotNrOfPoly := StrToInt (NrOfPoly_Edit.Text);
    DataMod.NrOfNodesAdded := StrToInt (NrAdded_Edit.Text);
    DataMod.NrOfNodesRemoved := StrToInt (NrRemoved_Edit.Text);
    DataMod.Scale := StrToInt (Scale_Edit.Text);
    DataMod.NrOfYears := StrToInt (NrOfYears_Edit.Text);
    DataMod.NrOfSeasons := NrOfSeasons_Combo.ItemIndex+1;
    DataMod.AnnualIndex := AnnualCalc_Combo.ItemIndex;
    DataMod.OutputTimeStep := StrToInt (TimeStep_Edit.Text);
    DataMod.AccuracyLevel := Accuracy_Combo.ItemIndex+1;
    for k:=1 to DataMod.NrOfSeasons {+ DataMod.NrOfSeasonsAdded} do
    begin
    //Somewhere the NrOfSeasons added was already incorporated in NrOfSeasons
      DataMod.SeasonDuration[k]:= StringToFloat(SeasonDurationEdit[k].Text);
    end;
    DecimalSeparator:=InitDecSep;
  end;
  CheckGeneralData (DataOK);
  if DataOk then
  begin
    DataMod.SaveGeneralGroup(DataOK);
    Showmessage ('The general input data were saved. Please continue to the'+
                 ' next phase: polygonal (nodal) network construction');
  end
  else exit;
// The following NrOfSeasons is only used in the General Tabsheet and the
// Polygonal Tabsheet. In the Seasonal Tabsheet the necessary distinction
// between NrOfSeasons and InitNrOfSeasons is made again.

  if InputOpened and (DataMod.NrOfSeasonsAdded<>0) then
  begin
    Critical:=true;
    SeasonsAdded:=false;
    NrOfSeasonsChange:=true;
    if InputOpened then
    begin
      SetToGroupSelection:=true;
      Identity:='Durations';
      SeasonGroupSave_ButtonClick(Sender);
      SetPolyComponents('ToGroupSelection');
      if not DataOK then exit;
    end;
  end;

  if InputOpened then
  begin
    SetPolyComponents('ToGroupSelection');
    SetToGroupSelection:=true;
  end;// else SetPolyComponents ('ToSetupNetwork');

  InputSave_Button.Caption:='Save all/calculate';
  StatusText('Enter data, then use "Save data" and proceed to other'+
             ' data tabsheets, or use "Save/calculate" to save all data and'+
             ' do calculations.');

  if InputOpened and (DataMod.NrOfNodesAdded>0) then
  begin
    Critical:=true;
    ShowOverallTable;
    Showmessage ('You wish to add polygons.  Please complete the additional'+
                 ' data at the bottom of the following overall data group'+
                 ' table and adjust the internal/external (Ki/e) index where'+
                 ' needed to obtain proper nodal network relations.');
  end;

  if InputOpened and (DataMod.NrOfNodesAdded=0) and
                     (DataMod.NrOfNodesRemoved>0) then
  begin
    Critical:=true;
    DataMod.RemovalStage:=true;
    DataMod.InitTotNrOfPoly:=DataMod.TotNrOfPoly;
    ShowOverallTable;
    Showmessage ('You wish to remove polygons.  Enter the value -1 in the'+
                 ' last (Ki/e index) column of the following overall data'+
                 ' group table precisely on the lines of the node numbers'+
                 ' to be removed.  Also, adjust the internal/external node'+
                 ' settings (1 resp.2) where required');
  end;
  InputSave_Button.Caption:='Save all/calculate';
  PolygonalInput_Tabsheet.TabVisible:=true;
  PolygonalInput_Tabsheet.Show;
end; {TMainForm.GeneralGroupSave}
{-------------------------------}



procedure TMainForm.Calculate_ButtonClick(Sender: TObject);
{---------------------------------------------------------}
var YesOK : boolean;
begin
  inherited;
  if not InputOpened then
  begin
    YesOK:=DataMod.Question ('You will be asked to open an existing input file'+
                     ' to do the calculations with. The current input'+
                     ' data will not be saved.  Do you wish to do the'+
                     ' calculations?');
    if YesOK then
    begin
      CalcButtonUsed:=true;
      InputOpen_Execute (Sender);
      DataMod.SaveFileName:=DataMod.OpenFileName;
      if DataMod.AnnualCalc then
      begin
        DataMod.NrOfYears:=1;
        DataMod.AnnualFileName:=DataMod.SaveFileName;
        DataMod.SaveFileName:=OriginalName;
      end;
      DoCalculations;
    end;
  end else
  begin
    if DataMod.AnnualCalc then
    begin
      DataMod.NrOfYears:=1;
      DataMod.AnnualFileName:=DataMod.SaveFileName;
      DataMod.SaveFileName:=OriginalName;
    end;
    DoCalculations;
  end;
end; {TMainForm.Calculate_ButtonClick}
{------------------------------------}



procedure TMainForm.DoCalculations;
{---------------------------------}
var OldYear, NewYear, Nx : string;
    OrigStr,File1,File2  : string;
    YesOK, Disrupt       : boolean;
begin
  with DataMod do
  begin
    EndOfAnnual := false;
    chdir (InitDir);
    GeneralWait_Memo.Visible:=true;
    GeneralWait_Memo.Lines.Add(' Checking data ');
    sleep (500);
    RestrictInputArrays ('Polygonal');
    RestrictInputArrays ('Seasonal');
    ReduceOutputArrays;
    if not AnnualCalc and (NrOfYears*NrOfIntPoly>200) then
    begin
      ProgressBar1.Visible:=true;
      ProgressBar1.Position:=10;
      sleep(500);
    end;

    TestData;
    ReadErrorLines (RunTimeError,NrOfErrorLines);
    if RunTimeError then
    begin
      CalcDone:=true;
      OutputOpened:=false;
      OutputGroupOpen_Button.Visible:=false;
      SeeGraph_Button.Enabled:=false;
      SaveGroup_Button.Enabled:=false;
      GeneralWait_Memo.Visible:=false;
      Output_Tabsheet.Show;
      exit;
    end;
    ProgressBar1.Position:=20;
    sleep (500);

    if YearNr<1 then InitialActions;
    ProgressBar1.Position:=30;
    sleep (500);
    if not AnnualCalc then YearNr:=NrOfYears;
    GeneralWait_Memo.Lines.Add(' Calculating ...');
    GeneralWait_Memo.Lines.Add(' Please wait ...');
    sleep(500);
    AnnualNr:=NrOfYears;
    if AnnualCalc then NrOfYears:=1;
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
      OutputGroupOpen_Button.Visible:=false;
      SeeGraph_Button.Enabled:=false;
      SaveGroup_Button.Enabled:=false;
      GeneralWait_Memo.Visible:=false;
      Output_Tabsheet.Show;
      exit;
    end else
    begin
      GeneralWait_Memo.Lines.Add(' Finalizing ....');
      ProgressBar1.Position:=80;
      ReadErrorLines (RunTimeError,NrOfErrorLines);
      if RunTimeError then
      begin
        CalcDone:=true;
        OutputOpened:=false;
        OutputGroupOpen_Button.Visible:=false;
        SeeGraph_Button.Enabled:=false;
        SaveGroup_Button.Enabled:=false;
        GeneralWait_Memo.Visible:=false;
        Output_Tabsheet.Show;
        exit;
      end;
    end;
    OrigStr:=OriginalName;
    OrigStr:=ChangeFileExt(OrigStr,'.out');
    File1:=extractfilename(OrigStr);
//Messages
    Disrupt:=false;
    if AnnualCalc and (YearNr<NrOfYears) then
    begin
      if YearNr=1 then AnnualFileName:=SaveFileName;
      OldYear := IntToStr(YearNr);
      NewYear := IntToStr(YearNr+1);
      YearNr:=YearNr+1;
      Nx := IntToStr(NrOfYears);
      File2:=extractfilename(AnnualFileName);
      Showmessage ('By setting the yearly calculation index Ky equal'+
      ' to 1 you have requested SahysMod calculations using the input'+
      ' file  '+File2+' for a time series of '+Nx+' years with the'+
      ' option to introduce annual input changes.  The end of the'+
      ' intermediate annual calculations of year '+OldYear+ ' is'+
      ' reached. The intermediate results can be seen in output file '
        +File1);
      YesOK := Question ('Do you wish to continue with the next'+
      ' year Nr '+NewYear);
      if YesOK then
      begin
        Showmessage ('Use the input tab sheets again to continue. It is not'+
        ' necessary to adjust the initial values of soil salinity'+
        ' and water level, this is done automatically. To keep'+
        ' record of input changes, the input file will be saved' +
        ' keeping the same name but with year number attached.');
        chdir (DataDir);
        ReadInputs (DoItSelf);
        PresentData;
        //makes strings of general data ('Name0' file) tbv GeneralInput_Tabsheet
        GeneralInput_Tabsheet.TabVisible:=true;
        GeneralInput_Tabsheet.Show;
        exit;
      end else
      begin
        Showmessage ('The calculations for the time series are'+
        ' discontinued. Yet the intermediate results can be seen'+
        ' in  '+File1);
        NrOfYears:=YearNr-1;
        EndOfAnnual := true;
        Disrupt:=true;
      end; {if YesOK}
    end; {if AnnualCalc and YearNr<NrOfYears}

    if AnnualCalc and (YearNr=NrOfYears) then
       EndOfAnnual := true;
    chdir (InitDir);
    if not AnnualCalc then
    begin
      OutputOpened:=true;
      OutputSymbols_Button.Enabled := true;
      SeeGraph_Button.Enabled:=false;
      SaveGroup_Button.Enabled := false;
      GotoInput_Button.Enabled := false;
    end;
    if AnnualCalc and EndOfAnnual then
    begin
      OutputOpened:=true;
      OutputSymbols_Button.Enabled := true;
      SeeGraph_Button.Enabled:=false;
      SaveGroup_Button.Enabled := false;
      GotoInput_Button.Enabled := false;
    end;
    if not AnnualCalc or (not Disrupt and EndOfAnnual) then
       showmessage ('The calculations are completed.'+
                    ' The results can be seen in the output file: '+File1);
    if AllWarning then
       if not AnnualCalc or (AnnualCalc and EndOfAnnual) then
       begin
         showmessage ('One or more runtime comments will be shown.');
         WarningForm.Visible:=true;
         AllWarning:=false;
       end;
  end; {with DataMod do}
  GeneralWait_Memo.Visible:=false;
  Output_Tabsheet.Show;
end; {TMainForm.DoCalculations}
{-----------------------------}



procedure TMainForm.Restart_ButtonClick(Sender: TObject);
{-------------------------------------------------------}
begin
  chdir (InitDir);
  FormCreate(Sender);
  Title1_Edit.Text:='New data file';
  Title2_Edit.Text:='Titles are yet to be given. Please do so.';
  if DirectoryExists (DataDir) then chdir (DataDir);
  DeleteGroupFiles;                                {GroupFiles are "Name"files}
  StatusText('Enter data or use "Open input" to see examples in any' +
             ' folder or to edit existing files. Thereafter use' +
             ' "Save general input".');
  NodalHelp_Button.Visible:=true;
  GeneralInput_Tabsheet.TabVisible:=true;
//  GeneralInput_Tabsheet.Show;
end; {TMainForm.Restart_ButtonClick}
{----------------------------------}


{******************************************************************************
 General Input TabSheet : Private Section
*******************************************************************************}


procedure TMainForm.MakeGeneralStrings;
{-------------------------------------}
var k : integer;
begin
  with Datamod do
  begin
    Title1_Edit.Text := Title1;
    Title2_Edit.Text := Title2;
    NrOfPoly_Edit.Text := IntToStr(TotNrOfPoly);
    NrAdded_Edit.Text := '0';
    NrRemoved_Edit.Text := '0';
    Scale_Edit.Text := IntToStr(Scale);
    NrOfYears_Edit.Text := IntToStr(NrOfYears);
    NrOfSeasons_Combo.ItemIndex := NrOfSeasons-1;
    AnnualCalc_Combo.ItemIndex := AnnualIndex;
    TimeStep_Edit.Text := IntToStr(OutputTimeStep);
    Accuracy_Combo.ItemIndex := AccuracyLevel;
    for k:=1 to NrOfSeasons do
        SeasonDurationEdit[k].Text:=FloatToStr(SeasonDuration[k]);
  end; {with DataMod do}
end; {TMainForm.MakeGeneralStrings}
{---------------------------------}



procedure TMainForm.PresentData;
{------------------------------}

begin
  with DataMod do
      if not CalcButtonUsed then
      begin
        GeneralWait_Memo.Visible:=true;
        GeneralWait_Memo.Lines.Add(' Retrieving data');
        sleep(500);
        GeneralWait_Memo.Visible:=false;
        DataMod.ReadGeneralGroup;
        InitNrOfSeasons:=NrOfSeasons; {probably not required. Nodig?}
        DataMod.ReadOverallGroup;
        MakeGeneralStrings;         //This is the main aim of PresentData
       //makes strings of general data ('Name0' file) tbv GeneralInput_Tabsheet
        InitNrOfIntPoly:=NrOfIntPoly;
        InitNrOfExtPoly:=NrOfExtPoly;
//This is a good place for the initial values because an input file was just
//opened and it may be that they may be changed
        CalcButtonUsed:=false;
      end;
end; {TMainForm.PresentData}
{--------------------------}


procedure TMainForm.InputSave_ButtonClick(Sender: TObject);
{---------------------------------------------------------}
begin
  inherited;
  if InputSave_Button.Caption='Save general input' then
  begin
     GeneralGroupSave;
     PolygonalInput_Tabsheet.TabVisible:=true;
     SeasonalInput_Tabsheet.TabVisible:=true;
  end else
  begin
    InputSave_Button.Caption:='Save all/calculate';
    InputSave_Execute (Sender);
  end;
end; {TMainForm.InputSave_ButtonClick}
{------------------------------------}


{******************************************************************************
End of GeneralInput_TabSheet, start of PolygonalInput_TabSheet : Public Section
*******************************************************************************}


procedure TMainForm.PolygonalInput_TabSheetShow(Sender: TObject);
begin
  inherited;
  GroupsType:='Polygonal';
  DrainChange:=false;
  AquiferChange:=false;
  PolyColorMap_Button.Visible:=false;
  if InputOpened and (DataMod.NrOfNodesAdded=0)
                 and (DataMod.NrOfNodesRemoved=0)
                      then SetPolyComponents('ToGroupSelection');
  if not SetToGroupSelection then
  begin
    SetPolyComponents('ToSetUpNetwork');
    PolyFile_Label.Visible:=false;
    PolyFileName_Label.Visible:=false;
    PolyHeader_Panel.Visible:=false;
    PolyExplanation1_Edit.Visible:=false;
    PolyExplanation2_Edit.Visible:=false;
  end else
  begin
    PolyFile_Label.Visible:=true;
    PolyFileName_Label.Visible:=true;
  end;
  if not InputOpened then
//There is no relevant file name
  begin
    PolyFile_Label.Visible:=false;
    PolyFileName_Label.Visible:=false;
  end;
  if DirectoryExists (DataDir) then chdir (DataDir)
  else chdir (InitDir);
  if not GuidedOk then
//This means the guided input menu for network consruction was not used
  begin
    if FileExists ('Name02') then
    begin
//Values n.a. due to absence of a drainage system are set to -1
      if InputOpened and SetInitialDrainage then
         InitialDrainageSettings;
//Values n.a. due to absence of a semiconfined aquifer are set to -1
      if InputOpened and SetInitAquiConditions then
         InitialAquiferSettings;
//The intial settings are done when an inputfile was opened or when the
//construction of a network was 'SelfDone'
//In the first case the InputOpened condition is not necessary
//Check why not for GuidedOK
    end;
  end;
  SeeGraph_Button.Enabled:=false;
  SaveGroup_Button.Enabled:=false;
  TypeSelection_Panel.Visible := false;
  TimeSelection_Panel.Visible := false;
  PolySelection_Panel.Visible := false;
  NetWorkForm.Hide;
end; {TMainForm.PolygonalInput_TabSheetShow}
{------------------------------------------}



procedure TMainForm.MakeNetwork_ButtonClick(Sender: TObject);
{-----------------------------------------------------------}
begin
  inherited;
  Critical:=true;
  DoItSelf:=false;
  SetPolyComponents('ToGroupEditing');
  if Self_RadioButton.Checked then with DataMod do
  begin
    DoItSelf:=true;
    Poly_StringGrid.FixedCols:=0 ;
    if (DataMod.NrOfNodesAdded=0) then
       Showmessage ('Please enter node numbers,  coordinates,  aquifer'+
                    ' bottom levels, and internal/exernal (Ki/e) indices'+
                    ' in the following overall system geometry data group');
    NrAdded_Edit.Text := '0';
    ShowOverallTable;
  end {if SelfRadioButton.Checked then with DataMod do}
  else
  begin {guided network input}
    if not GuidedOK then
//guided network consruction not yet finished
    begin
      SeasonalInput_Tabsheet.TabVisible:=true;
      MainForm.Enabled:=false;  {is enabled again at completion of GuidedForm}
      SeasonalInput_Tabsheet.TabVisible:=true;
      GuidedForm.Show;
      NrOfPoly_Edit.Text := IntToStr(DataMod.TotNrOfPoly);
      NrAdded_Edit.Text := '0';
      SelfDone:=true;
      InputOpened:=false;
    end;
  end;
  PolygonalInput_Tabsheet.Show;
end; {TMainForm.MakeMetwork_ButtonClick}
{--------------------------------------}



procedure TMainForm.ShowExplainEdit2 (Sender: TObject);
{-----------------------------------------------------}
var MemoLine, MemoLine1, MemoLine2 : string;
begin Inherited;
  MemoLine := (Sender as TLabel).Hint;
  if length(MemoLine)>70 then
  begin
    MemoLine1 := copy(MemoLine,1,70);
    MemoLine2 := copy(MemoLine,71,length(MemoLine));
    PolyExplanation1_Edit.Visible := true;
    PolyExplanation1_Edit.Text := Memoline1;
    PolyExplanation2_Edit.Text := MemoLine2;
  end else
  begin
    PolyExplanation2_Edit.Text := MemoLine;
    PolyExplanation1_Edit.Visible := false;
  end;
end; {TMainForm.ShowExplainEdit2}
{-------------------------------}



procedure TMainForm.HideExplainEdit2 (Sender: TObject);
{-----------------------------------------------------}
begin Inherited;
    PolyExplanation2_Edit.Text := 'Move mouse over symbol to see explanation';
    PolyExplanation1_Edit.Visible := false;
end; {TMainForm.HideExplainEdit2}
{-------------------------------}



procedure TMainForm.KrHelp_ButtonClick(Sender: TObject);
{------------------------------------------------------}
begin
  inherited;
  Mode:='KrHelp';
  SymbolsForm.Show;
end; {TMainForm.KrHelp_ButtonClick}
{---------------------------------}



procedure TMainForm.PolyGroup_ButtonClick(Sender: TObject);
{---------------------------------------------------------}
var j : integer;
begin
  inherited;
  AnnualPoly_Memo.Visible:=false;
  PolyColorMap_Button.Visible:=false;
  SetPolyComponents('ToGroupEditing');
  if Directoryexists (DataDir) then chdir (DataDir);
  if DataMod.NrOfIntPoly>2 then PolyCol_Panel.Visible:=true;
  if DataMod.NodeNr[0]=DataMod.NodeNr[1] then
    for j:=0 to DataMod.NrOfIntPoly-1 do DataMod.NodeNr[j]:=j+1;
  with DataMod do
  begin
    for j:=1 to 8 do
    begin
      PolyHeaderLabel[j]:=Tlabel.Create(self);
      PolyHeaderLabel[j].Parent:=PolyHeader_Panel;
      PolyHeaderLabel[j].Top:=3;
      PolyHeaderLabel[j].Width:=60;
      PolyHeaderLabel[j].Height:=30;
      if j=1 then PolyHeaderLabel[j].Left:=4
      else PolyHeaderLabel[j].Left:=PolyHeaderLabel[j-1].Left+60;
    end;
  end;

  if Overall_RadioButton.Checked then with DataMod do
  begin
    if not NoRead then ReadOverallGroup;
    ShowOverallTable;
  end
  else

  if Network_RadioButton.Checked then with DataMod do
  begin
    Identity:='Network';
    PolyCol_Panel.Visible := false;
    if GuidedOK then
    begin
      NrOfItems:=5;
      Critical:=false;
    end;
    if NoRead then NoRead:=false
    else
    if GuidedOK then ReadNetworkGroup('Starting')
    else ReadNetworkGroup('Started');
    ShowNetworkTable;
  end
  else

  if Internal_RadioButton.Checked then with DataMod do
  begin
    Identity:='Internal';
    PolyColorMap_Button.Visible:=true;
    ReadOverallGroup;
    if NoRead then NoRead:=false
    else ReadPolyGroup('Name02',4);
    NrOfItems:=5;
    ShowInternalTable;
  end
  else

  if Conductivity_RadioButton.Checked then with DataMod do
  begin
    Identity:='Conduct';
    if SelfDone and not InternalDataDone then
    begin
      Showmessage ('Please edit the internal system properties first');
      Internal_RadioButton.Checked:=true;
      PolyGroup_ButtonClick(Sender);
      exit;
    end;
    PolyComment_Panel.Visible:=true;
    PolyComment_Memo.Visible:=true;
    PolyComment_Memo.Lines.Clear;
    PolyComment_Memo.Lines.Add ('   " - " = n.a.'     );
    PolyComment_Memo.Lines.Add ('The transition zone' );
    PolyComment_Memo.Lines.Add ('conductivity is only');
    PolyComment_Memo.Lines.Add ('applicable when the' );
    PolyComment_Memo.Lines.Add ('  aquifer is semi-'  );
    PolyComment_Memo.Lines.Add (' confined, see the'  );
    PolyComment_Memo.Lines.Add ('internal system data');
    ReadOverallGroup;
    if GuidedOK then ReadNetworkGroup('Starting')
    else
    begin
      ReadPolyGroup('Name02',4);                           {internal geo data}
      ReadNetworkGroup('Started');
    end;
    NrOfItems:=4;
    ShowConductivityTable;
  end else

  if Resistence_RadioButton.Checked then with DataMod do
  begin
    Identity:='Resist';
    if SelfDone and not InternalDataDone then
    begin
      Showmessage ('Please edit the internal system properties first');
      Internal_RadioButton.Checked:=true;
      PolyGroup_ButtonClick(Sender);
      exit;
    end;
    PolyComment_Panel.Visible:=true;
    PolyComment_Memo.Visible:=true;
    PolyComment_Memo.Lines.Clear;
    PolyComment_Memo.Lines.Add ('   " - " = n.a.'    );
    PolyComment_Memo.Lines.Add ('Values in the table');
    PolyComment_Memo.Lines.Add ('are only applicable');
    PolyComment_Memo.Lines.Add ('when the aquifer is');
    PolyComment_Memo.Lines.Add ('  semi-confined,   ');
    PolyComment_Memo.Lines.Add (' see the internal  ');
    PolyComment_Memo.Lines.Add (' system properties ');
    ReadOverallGroup;
    ReadPolyGroup ('Name02',4);                          {internal geo data}
    if GuidedOK then ReadNetworkGroup('Starting')
    else ReadNetworkGroup('Started');
    NrOfItems:=3;
    ShowResistenceTable;
  end else

  if TotPor_RadioButton.Checked then with DataMod do
  begin
    Identity:='Totpor';
    ReadOverallGroup;
    if NoRead then NoRead:=false
    else ReadPolyGroup('Name04',3);
    NrOfItems:=4;
    ShowTotPorTable;
  end else

  if EffPor_RadioButton.Checked then with DataMod do
  begin
    Identity:='Effpor';
    ReadOverallGroup;
    if NoRead then NoRead:=false
    else ReadPolyGroup('Name05',5);
    NrOfItems:=5;
    ShowEffPorTable;
  end else

  if Leaching_RadioButton.Checked then with DataMod do
  begin
    Identity:='Leaching';
    ReadOverallGroup;
    if NoRead then NoRead:=false
    else ReadPolyGroup('Name06',3);
    NrOfItems:=4;
    ShowLeachingTable;
  end else
                  {Name07 is used for storage efficiency under ReadSeasonGroup}

  if Agricult_RadioButton.Checked then with DataMod do
  begin
    Identity:='Agricult';
    PolyComment_Panel.Visible:=true;
    PolyComment_Memo.Visible:=true;
    PolyComment_Memo.Lines.Clear;
    PolyComment_Memo.Lines.Add (' The Krf index is only');
    PolyComment_Memo.Lines.Add (' applicable when Kf=1.');
    PolyComment_Memo.Lines.Add ('      ');
    PolyComment_Memo.Lines.Add (' A version with MORE  ');
    PolyComment_Memo.Lines.Add (' rotation (Kr) OPTIONS');
    PolyComment_Memo.Lines.Add (' can be made available');
    PolyComment_Memo.Lines.Add (' on request.'          );
    KrHelp_Button.Visible:=true;
    ReadOverallGroup;
    if NoRead then NoRead:=false
    else if SkipAgri then SkipAgri:=false
    else ReadPolyGroup('Name08',4);
    NrOfItems:=5;
    ShowAgricultTable;
  end else

  if Drainage_RadioButton.Checked then with DataMod do
  begin
    Identity:='Drainage';
    PolyComment_Panel.Visible:=true;
    PolyComment_Memo.Visible:=true;
    PolyComment_Memo.Lines.Clear;
    PolyComment_Memo.Lines.Add ('    " - " = n.a.'      );
    PolyComment_Memo.Lines.Add ('The properties of the' );
    PolyComment_Memo.Lines.Add ('drain system are only' );
    PolyComment_Memo.Lines.Add (' applicable when the'  );
    PolyComment_Memo.Lines.Add ('Kd drainage index is 1');
    PolyComment_Memo.Lines.Add (' see the agricultural' );
    PolyComment_Memo.Lines.Add (' practices data group' );
    ReadOverallGroup;
    ReadPolyGroup('Name08',4);                     {for drainage index}
    if NoRead then NoRead:=false
    else ReadPolyGroup('Name09',3);
    if DrainChange then ReadPolyGroup('Name09',3);
    NrOfItems:=4;
    ShowDrainageTable;
  end else

  if SaltRoot_RadioButton.Checked then  with DataMod do
  begin
    Identity:='Saltroot';
    ReadOverallGroup;
    if NoRead then NoRead:=false
    else ReadPolyGroup('Name10',3);
    NrOfItems:=4;
    ShowSaltRootTable;
  end else

  if SaltDeep_RadioButton.Checked then with DataMod do
  begin
    Identity:='Saltdeep';
    PolyComment_Panel.Visible:=true;
    PolyComment_Memo.Visible:=true;
    PolyComment_Memo.Lines.Clear;
    PolyComment_Memo.Lines.Add ('   " - " = n.a.'     );
    PolyComment_Memo.Lines.Add ('The transition zone' );
    PolyComment_Memo.Lines.Add ('salinity data needed');
    PolyComment_Memo.Lines.Add (' depend on presence' );
    PolyComment_Memo.Lines.Add ('of a drainage system');
    PolyComment_Memo.Lines.Add (' See drainage index' );
    PolyComment_Memo.Lines.Add ('in Agric. Practices' );
    ReadOverallGroup;
    if not NoRead then ReadPolyGroup('Name08',4);    {Drainage index Agricult}
    if NoRead then NoRead:=false
    else ReadPolyGroup('Name11',4);
    NrOfItems:=5;
    ShowSaltDeepTable;
  end else

  if ExtSal_RadioButton.Checked then with DataMod do
  begin
    Identity:='Extsal';
    ReadOverallGroup;
    if NoRead then NoRead:=false
    else ReadExternalGroup;
    NrOfItems:=2;
    ShowExtSalTable;
  end else

  if CritDepth_RadioButton.Checked then  with DataMod do
  begin
    Identity:='Critdepth';
    ReadOverallGroup;
    if NoRead then NoRead:=false
    else ReadPolyGroup('Name12',3);
    NrOfItems:=2;
    ShowCritDepthTable;
  end else

  if HydHead_RadioButton.Checked then with DataMod do
  begin
    Identity:='Hydhead';
    PolyComment_Panel.Visible:=true;
    PolyComment_Memo.Visible:=true;
    PolyComment_Memo.Lines.Clear;
    PolyComment_Memo.Lines.Add ('  " - " = n.a.'      );
    PolyComment_Memo.Lines.Add (' The water pressure' );
    PolyComment_Memo.Lines.Add (' data needed depend' );
    PolyComment_Memo.Lines.Add (' on the presence of' );
    PolyComment_Memo.Lines.Add (' a semi-confined'    );
    PolyComment_Memo.Lines.Add (' aquifer, see under' );
    PolyComment_Memo.Lines.Add (' internal system'    );
    ReadOverallGroup;
    if not NoRead then ReadPolyGroup('Name02',4);       {internal geo data}
    if NoRead then NoRead:=false
    else ReadPolyGroup('Name12',3);
    NrOfItems:=3;
    ShowHydHeadTable;
  end else


  if QInflow_RadioButton.Checked then with DataMod do
  begin
    Identity:='Qinflow';
    PolyComment_Panel.Visible:=true;
    PolyComment_Memo.Visible:=true;
    PolyComment_Memo.Lines.Clear;
    PolyComment_Memo.Lines.Add ('  " - " = n.a.'     );
    PolyComment_Memo.Lines.Add ('');
    PolyComment_Memo.Lines.Add (' The data on salt'  );
    PolyComment_Memo.Lines.Add (' concentration are' );
    PolyComment_Memo.Lines.Add (' only needed when'  );
    PolyComment_Memo.Lines.Add (' inflow Qi is > 0'  );
    PolyComment_Memo.Lines.Add (' '                  );
    ReadOverallGroup;
    if NoRead then NoRead:=false
    else ReadPolyGroup('Name13',3);
    NrOfItems:=4;
    ShowQinflowTable;
  end;

end; {TMainForm.PolyGroup_ButtonClick}
{------------------------------------}



procedure TMainForm.PolyGroupCancel_ButtonClick(Sender: TObject);
{---------------------------------------------------------------}
var AbandonOK : boolean;
begin
  inherited;
  if not InputOpened then NoRead:=true;
  PolyColorMap_Button.Visible:=false;
  SetPolyComponents('ToGroupSelection');
  if Critical then
  begin
    Critical:=false;
    AbandonOK:=DataMod.Question ('By using the cancel button SahysMod'+
               ' will abandon further network construction.  Is that OK?');
    if not AbandonOK then
    begin
      SetPolyComponents('ToGroupEditing');
      exit;
    end else
    begin
      Showmessage ('The setup of the nodal network is abandoned');
      FormCreate(Sender);
      PolygonalInput_Tabsheet.TabVisible:=false;
      Intro_Tabsheet.TabVisible:=true;
      Figure_Tabsheet.TabVisible:=true;
      Output_Tabsheet.TabVisible:=true;
      Graphics_Tabsheet.TabVisible:=true;
      GeneralInput_Tabsheet.TabVisible:=true;
      GeneralInput_Tabsheet.Show;
      exit;
    end;
  end else
  begin
    Showmessage ('The group data were not saved');
    if not InputOpened then
//The work is guided or DoItSelf
       if ((Identity='Overall') and not OverallSaved) or
          ((Identity='Network') and not NetworkSaved) then
       begin
         InputSave_Button.Caption:='Save general input';
         StatusText('Enter data or use "Open input" to see examples in any' +
                    ' folder or to edit existing files. Thereafter use' +
                    ' "Save general input".');
         PolygonalInput_Tabsheet.TabVisible:=false;
         Intro_Tabsheet.TabVisible:=true;
         Figure_Tabsheet.TabVisible:=true;
         Output_Tabsheet.TabVisible:=true;
         Graphics_Tabsheet.TabVisible:=true;
         GeneralInput_Tabsheet.TabVisible:=true;
         GeneralInput_Tabsheet.Show;
         exit;
       end;
  end;
  if Identity='AgriCult' then SkipAgri:=true;
  Identity:='None';
end; {TMainForm.PolyGroupCancel_ButtonClick}
{------------------------------------------}



procedure TMainForm.PolyGroupSave_ButtonClick(Sender: TObject);
{-------------------------------------------------------------}
var ItIsOK : boolean;
    i : integer;
begin
  inherited;
  NoRead:=false;
  NetWorkForm.Hide;
  if not InputOpened then
//Either DoItSelf or Guided
  begin
    if DoItSelf and (Identity='Overall') then with DataMod do
//This excludes 'Guided'
    begin
      chdir (InitDir);
      if MakeCorrection then TotNrOfPoly:=TotNrOfPoly-NrOfNodesAdded;
      MakeOverallValues (ItIsOK);
      chdir (InitDir);
      if ItIsOK then
      begin
        SaveOverallGroup;
        OverallSaved:=true;
        Showmessage ('The overall data were saved.' +
                     '  Please enter the nodal network relations');
        NrOfIntPoly:=0;
        NrOfExtPoly:=0;
        for i:=0 to TotNrOfPoly-1 do
        begin
          if Int_Ext_Index[i]=1 then NrOfIntPoly:=NrOfIntPoly+1;
          if Int_Ext_Index[i]=2 then NrOfExtPoly:=NrOfExtPoly+1;
        end;
        ReadOverallData;  {TEMPORARY,
        to be replaced by ReadOverallGroup excluding ReadGeneralGroup herein)}
      end else
      begin
        NoRead:=true;
        Overall_RadioButton.Checked:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
      DataMod.NrOfItems := 7;
      if GuidedOK then ReadNetworkGroup('Starting');
      ShowNetworkTable;
      Identity:= 'Finished';
      exit;
    end; {if DoItSelf and (Identity='Overall') then}

    if DoItSelf and (Identity='Finished') then with DataMod do
    begin
      MakeCorrection:=false;
      MakeNetworkValues (ItIsOK);
      if not ItIsOK then
      begin
        NoRead:=true;
        Network_RadioButton.Checked:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
      SaveGeneralGroup(ItIsOK);
      if not ItIsOK then exit;
      SaveNetworkGroup (DoItSelf);
      ReadOverallGroup;
      CheckNetWorkData (ItIsOK);
      if ItIsOK then
        Showmessage ('The nodal network relations were saved.'+
                     ' A graphic check will follow.')
      else
      begin
        Showmessage ('Restart checking first the overall data group');
        MakeCorrection:=true;
        NoRead:=true;
        SaveGeneralGroup (ItIsOK);
        Overall_RadioButton.Checked:=true;
        Identity:='Overall';
        NrOfItems:=5;
        SetPoly_StringGridStandards;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
      NetworkSaved:=true;
      NrOfNodesAdded:=0;
      InitNrOfIntPoly:=NrOfIntPoly;    //first definition after  DoItSelf
      InitNrOfExtPoly:=NrOfExtPoly;   //first definition after  DoItSelf
      MakeGroupFiles;
      //The temporary 'Name' files are made for input data handling
      //they use the initial values
      DoItSelf:=false;
      SelfDone:=true;
      InputOpened:=true;
//if DoItSelf and (Identity='Finished') then with DataMod do
//All necessary files have been created as if the input was opened
      SeasonalInput_Tabsheet.TabVisible:=true;
      Output_Tabsheet.TabVisible:=true;
      Graphics_Tabsheet.TabVisible:=true;
      InternalDataDone:=false;
      Critical:=false;
      NrOfPoly_Edit.Text:=IntToStr(DataMod.TotNrOfPoly);
      NrAdded_Edit.Text:='0';
      SaveNetworkGroup (DoItSelf);
      ShowNetworkMap(Sender);
      Identity:='None';
      InitNrOfSeasons:=NrOfSeasons; //first definition after  DoItSelf
      if DataMod.NrOfSeasonsAdded<>0 then SeasonsAdded:=true;
      InitTotNrOfPoly:=TotNrOfPoly; //first definition after  DoItSelf
      PolygonalInput_Tabsheet.Show;
    end; {if DoItSelf and (Identity='Finished') then}

  end; {if not InputOpened then}

  if InputOpened and (DataMod.NrOfNodesAdded>0) then
//here the numberofnodes added is always zero, nodes were already added
  begin
    if (Identity='Overall') then
    begin
      MakeOverallValues (ItIsOK);
      if ItIsOK then
      begin
         DataMod.SaveGeneralGroup(ItIsOK);
         if not ItIsOK then exit;
         DataMod.SaveOverallGroup;
         OverallSaved:=true;
         Showmessage ('The overall data were checked and saved.' +
                      '  Please enter the nodal network relations');
         DataMod.ReadOverallGroup;
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        Showmessage ('The overall data were not saved due to errors');
        exit;
      end;
      DataMod.NrOfitems:=7;
      if not DoItSelf then DataMod.ReadNetworkGroup('Starting');
      DataMod.MakeGroupFiles;
      ShowNetworkTable;
      Identity:= 'Finished';
      exit;
    end; {if (Identity='Overall') then}

    if Identity='Finished' then
//After the construction of a network either 'SelfDone' or 'GuidedOK'
    begin
      MakeNetworkValues (ItIsOK);
      if not ItIsOK then
      begin
        NoRead:=true;
        Network_RadioButton.Checked:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
      CheckNetWorkData (ItIsOK);
      if ItIsOK then
        Showmessage ('The nodal network relations were saved.'+
                     ' A graphic check will follow.')
      else
      begin
        Showmessage ('Restart checking first the overall data group');
        Identity:='Overall';
        Overall_RadioButton.Checked:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
      DataMod.SaveGeneralGroup(ItIsOK);
      DataMod.SaveNetworkGroup (DoItSelf);
      Identity:='None';
      if DataMod.NrOfNodesRemoved>0 then Identity:='Overall';
      DataMod.SaveGeneralGroup(ItIsOK);
      if not ItIsOK then exit;
      if DataMod.NrOfNodesAdded>0 then DataMod.AddToGroupFiles;
      DataMod.NrOfNodesAdded:=0;
//Check why required.
      DataMod.InitNrOfIntPoly:=DataMod.NrOfIntPoly;
      DataMod.InitNrOfExtPoly:=DataMod.NrOfExtPoly;
// See also {if DoItSelf and (Identity='Finished') then} . Seems duplication
// but it may be that initial nr is to be equated with the final number after
// all adjustments were made for adding polygons to the standard intial number
//with which the inputfile comes first before a file is being opened. CHECK !!
      InputOpened:=true;
//All necessary files have been created as if the input was opened
      PolyShowMap_Button.Visible:=true;
      SelfDone:=true;
      InternalDataDone:=false;
      Critical:=false;
      NrOfPoly_Edit.Text:=IntToStr(DataMod.TotNrOfPoly);
      NrAdded_Edit.Text:='0';
      DataMod.MakeGroupFiles;
      DataMod.SaveNetworkGroup (DoItSelf);
      ShowNetworkMap (Sender);
      Showmessage ('The polgygons were added.  Their properties must'+
                   ' be entered in all other data groups');
      PolygonalInput_Tabsheet.Show;
    end; {if Identity='Finished' then}

  end; {if InputOpened and (DataMod.NrOfNodesAdded>0) then}

  if InputOpened and (DataMod.NrOfNodesRemoved>0) then
  begin
    if (Identity='Overall') then
    with DataMod do
    begin
      if Identity='Overall' then MakeOverallValues (ItIsOK)
      else ItIsOK:=true;
      if ItIsOk then
      begin
        RemoveNodesFromFiles;
        SaveGeneralGroup(ItIsOK);
        if not ItIsOK then exit;
        SaveOverallGroup;
        OverallSaved:=true;
        if RemovalError then
        begin
          Showmessage('Warning.  The number of nodes removed do not correspond'+
                      ' to the number given in the general data group.'+
                      '  Yet the overall data were checked and saved.' +
                      '  Polygons were removed.  Please adjust the nodal'+
                      ' network relations in the following table');
          RemovalError:=false;
        end else
          Showmessage ('The overall data were checked and saved.' +
                       '  Polygons were removed.  Please adjust the nodal'+
                       ' network relations in the following table');
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        Showmessage ('The overall data were not saved due to errors');
        exit;
      end;
      DataMod.NrOfitems:=7;
      DataMod.ReadNetworkGroup('Starting');
      DataMod.MakeGroupFiles;
      ShowNetworkTable;
      Identity:= 'None';
      exit;
    end; {if (Identity='Overall') or (Identity='Finished') then}

    if Identity='Finished' then
    begin
      MakeNetworkValues (ItIsOK);
      if not ItIsOK then
      begin
        NoRead:=true;
        Network_RadioButton.Checked:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
      DataMod.SaveGeneralGroup (ItIsOK);
      if not ItIsOK then exit;
      CheckNetWorkData (ItIsOK);
      if ItIsOK then
        Showmessage ('The nodal network relations were saved.'+
                     ' A graphic check will follow.')
      else
      begin
        Showmessage ('Restart checking first the overall data group');
        Identity:='Overall';
        Overall_RadioButton.Checked:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
      DataMod.SaveNetworkGroup (DoItSelf);
      Identity:='None';
      DataMod.InitTotNrOfPoly:=DataMod.TotNrOfPoly;
      DataMod.InitNrOfIntPoly:=DataMod.NrOfIntPoly;
      DataMod.InitNrOfExtPoly:=DataMod.NrOfExtPoly;
//Reference values because nodes were removed
      DataMod.NrOfNodesRemoved:=0;
      GeneralInput_Tabsheet.TabVisible:=false;
      PolyShowMap_Button.Visible:=true;
      SelfDone:=true;
      InternalDataDone:=false;
      Critical:=false;
      DataMod.MakeGroupFiles;
      DataMod.SaveNetworkGroup (DoItSelf);
      ShowNetworkMap(Sender);
      NrOfPoly_Edit.Text:=IntToStr(DataMod.TotNrOfPoly);
      NrRemoved_Edit.Text:='0';
      PolygonalInput_Tabsheet.Show;
    end; {if Identity='Finished' then}

  end; {if InputOpened and (DataMod.NrOfNodesRemoved>0) then}

  if InputOpened then  //the following need not be done when DoItSelf is in
//  progress and inputopened is still false
  begin
    if Identity='Overall' then
    begin
      MakeOverallValues(ItIsOk);
      if ItIsOK then CheckOverallData(ItIsOK);
      if ItIsOK then CheckNetworkData(ItIsOK);
      if ItIsOK then
      begin
        DataMod.SaveOverallGroup;
        OverallSaved:=true;
        Showmessage ('The overall data group data was saved allright');
        Critical:=false;
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Network' then
    begin
      MakeNetworkValues (ItIsOk);
      if ItIsOK then CheckNetWorkData (ItIsOK)
      else
      begin
        Identity:='Network';
        exit;
      end;
      if ItIsOK then
      begin
        DataMod.SaveNetworkGroup (DoItSelf);
        Showmessage ('The nodal network relations were saved.'+
                     '  The check follows.');
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
      Identity:='None';
      ShowNetworkMap(Sender);
    end;

    if Identity='Internal' then with DataMod do
    begin
      PolyColorMap_Button.Visible:=false;
      DataMod.NrOfitems:=5;
      MakeInternalValues (ItIsOk);
      if ItIsOK then CheckInternalData (ItIsOK);
      if ItIsOK then
      begin
        SavePolyGroup('Name02',4);
        GuidedOK:=false;
        InternalDataDone:=true;
        if not AquiferChange then
           Showmessage ('The internal group data were checked and saved')
        else
        begin
          Showmessage ('The internal group data were checked and saved.'+
                       '  You have changed aquifer conditions.  Please'+
                       ' check hydraulic aquifer properties.');
          Conductivity_RadioButton.Checked:=true;
          PolyGroup_ButtonClick(Sender);
          exit;
        end;
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Conduct' then
    begin
      DataMod.ReadPolyGroup('Name02',4);               {needed for Auifer type}
      MakeConductivityValues (ItIsOk);
      if ItIsOK then
      begin
        DataMod.SaveNetworkGroup (DoItSelf);
        if not AquiferChange then
           Showmessage ('The conductivity data were checked and saved')
        else
        begin
          Showmessage ('The conductivity data were checked and saved.'+
                       '  As you have changed aquifer conditions, please'+
                       ' check hydraulic resistence values.');
          Resistence_RadioButton.Checked:=true;
          PolyGroup_ButtonClick(Sender);
          exit;
        end;
      end else
      begin
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Resist' then
    begin
      DataMod.ReadPolyGroup('Name02',4);               {needed for Auifer type}
      MakeResistenceValues (ItIsOk);
      if ItIsOK then
      begin
        DataMod.SaveNetworkGroup (DoItSelf);
        if not AquiferChange then
           Showmessage ('The resistence data were checked and saved')
        else
        begin
          Showmessage ('The resistence data were checked and saved.'+
                       '  As you have changed aquifer conditions, please'+
                       ' check the hydraulic aquifer pressure.');
          AquiferChange:=false;
          HydHead_RadioButton.Checked:=true;
          PolyGroup_ButtonClick(Sender);
          exit;
        end;
      end else
      begin
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Totpor' then
    begin
      DataMod.NrOfitems:=3;
      MakePolyValues (ItIsOk);
      if ItIsOK then CheckTotPorData (ItIsOK);
      if ItIsOK then
      begin
        DataMod.SavePolyGroup('Name04',3);
        Showmessage ('The total porosity group data were checked and saved');
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Effpor' then
    begin
      DataMod.NrOfitems:=4;
      MakePolyValues (ItIsOk);
      if ItIsOK then CheckEffPorData (ItIsOK);
      if ItIsOK then
      begin
        DataMod.SavePolyGroup('Name05',4);
        Showmessage ('The effective porosity group data were checked'+
                     ' and saved');
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Leaching' then
    begin
      DataMod.NrOfitems:=3;
      MakePolyValues (ItIsOk);
      CheckLeachingData (ItIsOK);
      if ItIsOK then
      begin
        DataMod.SavePolyGroup('Name06',3);
        Showmessage ('The leaching efficiency group data were checked'+
                     ' and saved');
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;
                       {Group Name07 on storage eff. comes under seasonal data}

    if Identity='Agricult' then
    begin
      DataMod.NrOfitems:=4;
      MakePolyValues (ItIsOk);
      if ItIsOK then CheckAgricultData (ItIsOK);
      if ItIsOK then
      begin
        DataMod.SavePolyGroup('Name08',4);
        if GuidedOK or SelfDone then
          Showmessage ('The agricultural practices group data were saved.'+
                       ' A check will follow later.')
        else
        if not ResponsChange and not DrainChange then
           Showmessage ('The agricultural practices group data were saved.'+
                       ' A check will follow later.');
        if DrainChange then
        begin
          Showmessage ('The agricultural practices group data were saved.'+
              ' A check will follow later.  As you have changed the'+
              ' drainage index, please adjust the subsurface drainage'+
              ' system data group.');
          Drainage_RadioButton.Checked:=true;
          PolyGroup_ButtonClick(Sender);
          exit;
        end;
        if AgriRevised then
        begin
          AgriRevised:=false;
          Showmessage ('The farmers response index was changed. Please'+
                       ' check the Krf index.');
          DataMod.NrOfitems:=5;
//          ShowAgricultTable;
          SkipAgri:=true;
          exit;
        end;
        if ResponsChange then
        begin
          Showmessage ('The agricultural practices group data were checked'+
             ' and saved.  As you have changed the farmers response'+
             ' index, please check the climatic, surface drainage and'+
             ' and storage efficiency data on the seasonal input tabsheet.');
          Climate_RadioButton.Checked:=true;
          SeasGroup_ButtonClick (Sender);
          SeasonalInput_Tabsheet.Show;
          exit;
        end;
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
      DataMod.FarmAddOK:=true;
    end; {if Identity='Agricult' then}

    if Identity='Drainage' then
    begin
      DataMod.NrOfitems:=3;
      MakePolyValues (ItIsOk);
      if ItIsOK then CheckNegativePolyData ('Drainage',ItIsOK,3);
      if ItIsOK then
      begin
        DataMod.SavePolyGroup('Name09',3);
        if not DrainChange then
          Showmessage ('The data on drainage system properties were'+
                       ' checked and saved')
        else
        begin
          Showmessage (' The data on drainage system properties were'+
                       ' checked and saved.  As you have changed the drainage'+
                       ' index, please check the initial salinity data'+
                       ' of the transition zone.');
          SaltDeep_RadioButton.Checked:=true;
          PolyGroup_ButtonClick(Sender);
          exit;
        end;
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end; {if Identity='Drainage' then}

    if Identity='Saltroot' then
    begin
      DataMod.NrOfItems:=3;
      MakePolyValues (ItIsOk);
      if ItIsOK then CheckNegativePolyData ('Saltroot',ItIsOK,3);
      if ItIsOK then
      begin
        DataMod.SavePolyGroup('Name10',3);
        Showmessage ('The data on root zone salinity were checked'+
                     ' and saved');
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Saltdeep' then
    begin
      DataMod.NrOfitems:=4;
      MakePolyValues (ItIsOk);
      if ItIsOK then CheckNegativePolyData ('Saltdeep',ItIsOK,1);
      if ItIsOK then
      begin
        DataMod.SavePolyGroup('Name11',4);
        if not DrainChange then
           Showmessage ('The data on sub soil salinity were checked'+
                        ' and saved')
        else
        begin
          Showmessage (' The data on sub soil salinity were checked '+
                       ' As you have changed the drainage index,'+
                       ' please check the drainage control factor.');
          Wells_RadioButton.Checked:=true;
          SeasonalInput_Tabsheet.TabVisible:=true;
          SeasonalInput_Tabsheet.Show;
          SeasGroup_ButtonClick(Sender);
        end;
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Critdepth' then
    begin
      DataMod.NrOfitems:=1;
      MakePolyValues (ItIsOk);
      if ItIsOK then CheckNegativePolyData ('Critdepth',ItIsOK,1);
      if ItIsOK then
      begin
        DataMod.SavePolyGroup('Name12',3);
        Showmessage ('The data on critical depth of the water table'+
                     ' for capillary rise were partly checked and saved.'+
                     ' A further check follows when doing calculations.');
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Extsal' then
    begin
      DataMod.NrOfitems:=1;
      MakePolyValues (ItIsOk);
      if ItIsOK then CheckNegativePolyData ('Extsal',ItIsOK,1);
      if ItIsOK then
      begin
        DataMod.SaveExternalGroup;
        Showmessage ('The data on groundwater salinity of the external'+
                     ' polygons were checked and saved');
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Hydhead' then
    begin
      DataMod.NrOfitems:=3;
      MakePolyValues (ItIsOk);
      if ItIsOK then
      begin
        DataMod.SavePolyGroup('Name12',3);
        Showmessage ('The data on initial water level/pressure were saved.'+
                     ' A check follows when doing calculations.');
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

    if Identity='Qinflow' then
    begin
      DataMod.NrOfItems:=3;
      MakePolyValues (ItIsOk);
      if InflowChange then
      begin
        DataMod.NrOfItems:=4;
        ShowQinflowTable;
        exit;
      end;
      if ItIsOK then CheckNegativePolyData ('Qinflow',ItIsOK,3);
      if ItIsOK then
      begin
        DataMod.SavePolyGroup('Name13',3);
        Showmessage ('The data aquifer inflow/outflow condtions were checked'+
                     ' and saved');
      end else
      begin
        NoRead:=true;
        PolyGroup_ButtonClick(Sender);
        exit;
      end;
    end;

  end; {if InputOpened}

  SetPolyComponents('ToGroupSelection');

end; {TMainForm.PolyGroupSave_ButtonClick}
{----------------------------------------}



procedure TMainForm.MakePolyValues (var DataOK : boolean);
{--------------------------------------------------------}
var Count, j, k, NrOfPoly : integer;
begin
  InflowChange:=false;
  with Datamod do
  begin
    NrOfPoly:=NrOfIntPoly;
    if (Identity='Extsal') or (Identity='Exthead') then
        NrOfPoly:=NrOfExtPoly;
    for j:=1 to NrOfItems do setlength(HlpValue[j],NrOfPoly);

    if Identity='Qinflow' then
    begin
      setlength(OrigInflowValue,NrOfIntPoly);
      for k:=0 to NrOfIntPoly-1 do
          OrigInflowValue[k]:=HlpValue[1,k];
    end;

    if (Identity<>'Critdepth') and (Identity<>'Hydhead') and
       (Identity<>'Exthead') then
    begin
    Try
      For j:=1 to NrOfItems do
          for k:=0 to NrOfPoly-1 do
           if (Poly_StringGrid.Cells[j,k+1]<>' -') then
            if (Poly_StringGrid.Cells[j,k+1]<>'') then
              HlpValue[j,k] := StringToFloat(Poly_StringGrid.Cells[j,k+1]);
      Except on E: exception do
      begin
        Showmessage ('The data group contains invalid entries');
        DataOK:=false;
        DecimalSeparator:=InitDecSep;
        exit;
      end;
    end; {Try}
    end;

    if Identity='Critdepth' then
    Try
      for k:=0 to NrOfPoly-1 do
      begin
        if (Poly_StringGrid.Cells[1,k+1]<>' -')
        and (Poly_StringGrid.Cells[1,k+1]<>'') then
           HlpValue[2,k] := StringToFloat(Poly_StringGrid.Cells[1,k+1]);
      end;
      Except on E: exception do
      begin
        Showmessage ('The data group contains invalid entries');
        DataOK:=false;
        DecimalSeparator:=InitDecSep;
        exit;
      end;
    end; {if Identity='Critdepth' then Try}

    if Identity='Hydhead' then
    Try
      for k:=0 to NrOfPoly-1 do
      begin
        HlpValue[1,k] := StringToFloat(Poly_StringGrid.Cells[1,k+1]);
        DecimalSeparator:=InitDecSep;
        if (Poly_StringGrid.Cells[2,+1]<>' -')
        and (Poly_StringGrid.Cells[2,+1]<>'') then
               HlpValue[3,k] := StringToFloat(Poly_StringGrid.Cells[2,k+1]);
      end;
      Except on E: exception do
      begin
        Showmessage ('The data group contains invalid entries');
        DataOK:=false;
        DecimalSeparator:=InitDecSep;
        DecimalSeparator:=InitDecSep;
        exit;
      end;
    end; {if Identity='Hydhead' then Try}

    if Identity='Exthead' then
    begin
      Try
        for j:=1 to NrOfSeasons do
        begin
          Count:=j-NrOfSeasons;
          for k:=0 to NrOfPoly-1 do
          begin
            Count:=Count+NrOfSeasons;
            HlpValue[j+1,k] := StringToFloat(Season_StringGrid.Cells[2,Count]);
          end;
        end;
        Except on E: exception do
        begin
          Showmessage ('The data group contains invalid entries');
          DataOK:=false;
          DecimalSeparator:=InitDecSep;
          exit;
        end;
      end; {Try}
    end;{if Identity='Exthead' then}

    if Identity='Internal' then
    begin
      setlength (TopLevel,NrOfIntPoly);
      for k:=0 to NrOfIntPoly-1 do
          TopLevel[k]:=StrToInt(Poly_StringGrid.Cells[2,k+1]);
      setlength (AquiferType,NrOfIntPoly);
      Try
        for k:=0 to NrOfIntPoly-1 do
            AquiferType[k]:=StrToInt(Poly_StringGrid.Cells[5,k+1]);
        Except on E: exception do
        begin
          Showmessage ('The index for aquifer type must be an integer');
          DataOK:=false;
          exit;
        end;
      end; {Try}
    end; {if Identity='Internal' then}

    if Identity='Agricult' then
    begin
      For j:=1 to NrOfItems do
          setlength(AuxInt[j],NrOfIntPoly);
      Try
        For j:=1 to NrOfItems do
          for k:=0 to NrOfIntPoly-1 do
            if j<4 then AuxInt[j,k] := StrToInt(Poly_StringGrid.Cells[j,k+1])
            else
              if AuxInt[2,k]>0 then
                 if (Poly_StringGrid.Cells[4,k+1]<>' -') and
                    (Poly_StringGrid.Cells[4,k+1]<>'') then
                    AuxInt[4,k] := StrToInt(Poly_StringGrid.Cells[4,k+1])
                 else
                 begin
                    Poly_StringGrid.Cells[4,k+1]:=' 1';
                    AuxInt[4,k]:=1;
                 end;
        Except on E: exception do
        begin
          Showmessage ('The indices for agricultural practices'+
                       ' must be integers');
          DataOK:=false;
          exit;
        end;
      end; {Try}
      setlength (DrainIndex,NrOfIntPoly);
      for k:=0 to NrOfIntPoly-1 do
      begin
        if not GuidedOk and not SelfDone then
        begin
          if (DrainIndex[k]<1) and (AuxInt[1,k]>0) then
              DrainChange:=true;
          DrainIndex[k]:=AuxInt[1,k];
          if (ResponsIndex[k]<1) and (AuxInt[2,k]>0) then
          begin
              ResponsChange:=true;
              AgriRevised:=true;
          end;
          ResponsIndex[k]:=AuxInt[2,k];
          RotationType[k]:=AuxInt[3,k];
          InclIndex[k]:=AuxInt[4,k];
        end;
      end;
    end; {if Identity='Agricult' then}

    if Identity='Qinflow' then for k:=0 to NrOfIntPoly-1 do
       if (OrigInflowValue[k]=0) and (HlpValue[1,k]>0) then
       begin
         HlpValue[2,k]:=-1;
         InflowChange:=true;
       end;

  end; {with DataMod do}
  DataOK:=true;
end; {TMainForm.MakePolyValues}
{-----------------------------}


{******************************************************************************
 PolygonalInput_TabSheet : End of Public Section, start of Private Section
*******************************************************************************}


procedure TMainForm.InitialDrainageSettings;
{------------------------------------------}
var Number, j, k : integer;
begin
  with DataMod do
  begin
    if DataDir<>'' then chdir (DataDir);
    ReadGeneralGroup;                            {for nr. of polygons}
    ReadPolyGroup('Name08',4);                   {for Drainage Index}
    ReadPolyGroup('Name09',3);                   {Drainage system}
    for k:=0 to InitNrOfIntPoly-1 do if DrainIndex[k]<1 then
        for j:=1 to 3 do HlpValue[j,k]:=-1;;
//first use of InitNrOfIntPoly after DoItSelf
    SavePolyGroup('Name09',3);
    Number:=NrOfSeasons;       //Not required nodig?
//Number, Initnrofseasons, nrofseasons are all equal
    NrOfSeasons:=InitNrOfSeasons;
    if DataMod.NrOfSeasonsAdded<>0 then SeasonsAdded:=true;
// Seasons were added, NrOfSeasonsAdded=0
    ReadSeasonGroup('Name17',2);                  {for drainage control}
    SaveSeasonGroup('Name17',2);
    ReadSeasonGroup('Name20',2);                  {for drainage reuse}
    SaveSeasonGroup('Name20',2);
    SetInitialDrainage:=false;
    NrOfSeasons:=Number;            //not necessary   nodig? see above
  end;
end; {TMainForm.InitialDrainageSettings}
{--------------------------------------}



procedure TMainForm.InitialAquiferSettings;
{-----------------------------------------}
var Number : byte;
begin
  with DataMod do
  begin
    ReadGeneralGroup;                            {for nr. of polygons}
    ReadPolyGroup('Name02',4);                   {for TopLevel and AquiferType}
    ReadNetworkGroup('Started');                 {for semi conf. aquifer}
    SaveNetworkGroup (DoItSelf);
    ReadPolyGroup('Name12',3);                   {for aquifer pressure}
    SavePolyGroup('Name12',3);
    Number:=NrOfSeasons;
//    NrOfSeasons:=InitNrOfSeasons;
    if DataMod.NrOfSeasonsAdded<>0 then SeasonsAdded:=true;
//DataMod.NrOfSeasonsAdded=0, SeasonsAdded:=true
//Number, NrOfSeasons, initNrOfSeasons are all the same
    ReadSeasonGroup('Name17',2);                 {for drainage control}
    SaveSeasonGroup('Name17',2);
    ReadSeasonGroup('Name20',2);                 {for drainage reuse}
    SaveSeasonGroup('Name20',2);
    NrOfSeasons:=Number;
    SetInitAquiConditions:=false;
  end;
end; {TMainForm.InitialAquiferSettings}
{-------------------------------------}



procedure TMainForm.ShowOverallTable;
{-----------------------------------}
var j, k : integer;
begin
  Identity:='Overall';
  DataMod.NrOfitems:=5;
  SetPoly_StringGridStandards;
  SetPolyComponents ('ToGroupEditing');
  if DoItSelf then Poly_StringGrid.FixedCols:=0;
  if GuidedOK then PolyNetwork_Panel.Visible:=false;
  if not OverallSaved then NoRead:=false;
  if InputOpened then DataMod.ReadOverallGroup;
 //The Overallgroup needs not be read when 'DoItSelf' or 'Guided' because they
 //will be in the memory
  if InputOpened or MakeCorrection then
     if not GuideStop then
     begin
      OverallBlocked:=true;
      Poly_StringGridSelectCell(Sender,3,1,OverAllBlocked);
     end
     else OverallBlocked:=false;

  for j:=0 to DataMod.NrOfItems-1 do
  for k:=0 to DataMod.TotNrOfPoly do
  begin
    if k=0 then
    begin
      Poly_StringGrid.Cells[0,k]:=' -';
      Poly_StringGrid.Cells[1,k]:='cm map';
      Poly_StringGrid.Cells[2,k]:='cm map';
      Poly_StringGrid.Cells[3,k]:='m level';
      Poly_StringGrid.Cells[4,k]:='index';
    end else
    if InputOpened or MakeCorrection then with DataMod do
    begin
      if j=0 then Poly_StringGrid.Cells[0,k]:=
                  IntToStr(NodeNr[k-1]);
      if j>0 then
             if not InputOpened and not SelfDone then
                    Poly_StringGrid.Cells[j,k]:='0';
      Poly_StringGrid.Cells[1,k] := FloatToStr (Xcoord[k-1]);
      Poly_StringGrid.Cells[2,k] := FloatToStr (Ycoord[k-1]);
      Poly_StringGrid.Cells[3,k] := FloatToStr (BottomLevel[k-1]);
      Poly_StringGrid.Cells[4,k] := IntToStr(Int_Ext_Index[k-1]);
    end; {if InputOpened or MakeCorrection then}
  end; {for j:=0 to DataMod.NrOfItems-1 do for k:=0 to TotNrOfPoly do-1 do}
//  GuideStop:=true;

  if InputOpened and (DataMod.NrOfNodesAdded>0)then
  with DataMod do
  begin
    for k:=TotNrOfPoly+1 to TotNrOfPoly+NrOfNodesAdded do
    begin
      Poly_StringGrid.Cells[0,k]:='';
      Poly_StringGrid.Cells[1,k]:='';
      Poly_StringGrid.Cells[2,k]:='';
      Poly_StringGrid.Cells[3,k]:='';
      Poly_StringGrid.Cells[4,k]:='';
    end;
  end;{if InputOpened and (DataMod.NrOfNodesAdded>0)then}

  PolyHeader_Panel.Width:=6+60*DataMod.NrOfItems;
  PolyHeaderLabel[1].Caption:='Node nr.';
  PolyHeaderLabel[2].Caption:=' X-coord.';
  PolyHeaderLabel[3].Caption:=' Y-coord.';
  PolyHeaderLabel[4].Caption:=' Bottom';
  PolyHeaderLabel[5].Caption:='  K i/e';
  PolyHeaderLabel[1].Hint:='Identification number of polygonal nodal point';
  PolyHeaderLabel[2].Hint:='X coordinate as measured on the map in cm';
  PolyHeaderLabel[3].Hint:='Y coordinate as measured on the map in cm';
  PolyHeaderLabel[4].Hint:='Bottom level of the aquifer in m';
  if DataMod.RemovalStage then
     PolyHeaderLabel[5].Hint:='Index of internal/external polygons:'+
                              ' 1=internal, 2=external, -1=remove'
  else
  PolyHeaderLabel[5].Hint:='Index of internal/external polygons:'+
                           ' 1=internal, 2=external';
  for j:=1 to DataMod.NrOfItems do
  begin
    PolyHeaderLabel[j].OnMouseEnter := ShowExplainEdit2;
    PolyHeaderLabel[j].OnMouseLeave := HideExplainEdit2;
  end;

  if DataMod.AnnualCalc and (DataMod.YearNr>0) then
     AnnualPoly_Memo.Visible:=true;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowOverallTable}
{-------------------------------}



procedure TMainForm.MakeOverallValues (var CheckOK : boolean);
{------------------------------------------------------------}
var k: integer;
begin
  CheckOK:=false;
  with DataMod do
  begin
    TotNrOfPoly:=TotNrOfPoly+NrOfNodesAdded;
    setlength(NodeNr,TotNrOfPoly);
    setlength(Xcoord,TotNrOfPoly);
    setlength(Ycoord,TotNrOfPoly);
    setlength(BottomLevel,TotNrOfPoly);
    setlength(Int_Ext_Index,TotNrOfPoly);
    Try
      for k:=0 to TotNrOfPoly-1 do
      begin
        NodeNr[k] := StrToInt(Poly_StringGrid.Cells[0,k+1]);
        Xcoord[k] := StringToFloat(Poly_StringGrid.Cells[1,k+1]);
        DecimalSeparator:=InitDecSep;
        Ycoord[k] := StringToFloat(Poly_StringGrid.Cells[2,k+1]);
        DecimalSeparator:=InitDecSep;
        BottomLevel[k] := StringToFloat(Poly_StringGrid.Cells[3,k+1]);
        DecimalSeparator:=InitDecSep;
        Int_Ext_Index[k] := StrToInt(Poly_StringGrid.Cells[4,k+1]);
      end;
      Except on E: exception do
      begin
        Showmessage ('One or more of the data values are not valid');
        exit;   
      end;
    end; {Try}
    NrOfIntPoly:=0;
    for k:=0 to TotNrOfPoly-1 do if Int_Ext_Index[k]=1 then
        NrOfIntPoly:=NrOfIntPoly+1;
    NrOfExtPoly:=0;
    for k:=0 to TotNrOfPoly-1 do if Int_Ext_Index[k]=2 then
        NrOfExtPoly:=NrOfExtPoly+1;
    if RemovalStage then TotNrOfPoly:=NrOfIntPoly+NrOfExtPoly;
  end; {with DataMod do}
  CheckOK:=true;
  GuideStop:=true;
  OverallBlocked:=false;
end; {TMainForm.MakeOverallValues}
{--------------------------------}



procedure TMainForm.Poly_StringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
{------------------------------------------------------------------}
begin
  inherited;
  CanSelect:=true;
  if OverallBlocked then
     if (Acol=1) or (Acol=2) or (Acol=4) then CanSelect:=false;
  if NetBlocked then
     if (Acol>0) then CanSelect:=false;
end; {Poly_StringGridSelectCell}
{-------------------------------}



procedure TMainForm.ShowNetWorkTable;
{-----------------------------------}
var j, k {, NrOfPoly }: integer;
    MaxNrOfSides : byte;
begin
  if (Identity='Overall') and not OverallSaved then with DataMod do
      NrOfitems:=5;
//  Identity:='Network';
  PolyCol_Panel.Visible:=false;
  if not DoItSelf then
  begin
    DataMod.ReadOverallGroup;                                  {for Node Nr.}
    MaxNrOfSides:=0;
    with DataMod do
      for k:=0 to NrOfIntPoly-1 do
          if NrOfSides[k]>MaxNrOfSides then
             MaxNrOfSides:=NrOfSides[k];
  end
  else MaxNrOfSides:=6;
  DataMod.NrOfItems:=MaxNrOfSides+1;
  if DataMod.NrOfNodesAdded>0 then with DataMod do
  begin
    setlength (NrOfSides,NrOfIntPoly+1);
    for k:=InitNrOfIntPoly to NrOfIntPoly-1 do NrOfSides[k]:=6;
  end;
  SetPoly_StringGridStandards;
  Poly_StringGrid.FixedRows:=0;
  PolyHeaderLabel[1].Caption:='Poly nr.  ';
  PolyHeaderLabel[2].Caption:=' Side 1   ';
  PolyHeaderLabel[3].Caption:=' Side 2   ';
  PolyHeaderLabel[4].Caption:=' Side 3   ';
  PolyHeaderLabel[5].Caption:=' Side 4   ';
  PolyHeaderLabel[6].Caption:=' Side 5   ';
  PolyHeaderLabel[7].Caption:=' Side 6   ';
  PolyHeaderLabel[1].Hint:='Identification number of polygonal nodal point';
  if not DoItSelf then if not GuideEnded then
  begin
    NetBlocked:=true;
    Poly_StringGridSelectCell(Sender,1,1,NetBlocked);
  end else NetBlocked:=false;
  for j:=2 to MaxNrOfSides+1 do
      PolyHeaderLabel[j].Hint:='Neighbor node number at this side';
  for k:=0 to DataMod.TotNrOfPoly-1 do
      if DataMod.Int_Ext_Index[k]=1 then
         Poly_StringGrid.Cells[0,k]:=IntToStr(DataMod.NodeNr[k]);

  for j:=2 to DataMod.NrOfItems do for k:=0 to DataMod.NrOfIntPoly-1 do
      if not DoItSelf then
      begin
        if DataMod.NrOfNodesAdded=0 then
           Poly_StringGrid.Cells[j-1,k]:=IntToStr(DataMod.Neighbor[j-1,k])
        else
        begin
          if k<DataMod.InitNrOfIntPoly then
             Poly_StringGrid.Cells[j-1,k]:=IntToStr(DataMod.Neighbor[j-1,k])
          else
             Poly_StringGrid.Cells[j-1,k]:='';
        end;
      end else
      if MakeCorrection then
         Poly_StringGrid.Cells[j-1,k]:=IntToStr(DataMod.Neighbor[j-1,k+1])
      else
          Poly_StringGrid.Cells[j-1,k]:='';

  if Identity='Network' then
     for j:=2 to DataMod.NrOfItems do for k:=0 to DataMod.NrOfIntPoly-1 do
         Poly_StringGrid .Cells[j-1,k]:=IntToStr(DataMod.Neighbor[j-1,k]);

  Identity:='Network';

  if DataMod.AnnualCalc and (DataMod.YearNr>0) then
     AnnualPoly_Memo.Visible:=true;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowNetWorkTable}
{-------------------------------}



procedure TMainForm.MakeNetworkValues (var CheckOK : boolean);
{------------------------------------------------------------}
var j, k, HlpVar: integer;
begin
  with DataMod do
  begin
    CheckOK:=false;
    setlength (NrOfSides,NrOfIntPoly+1);
    Try
      for j:=2 to NrOfItems do for k:=1 to NrOfIntPoly do
      begin
        if Poly_StringGrid.Cells[j-1,k]<>'' then
           HlpVar:=strtoint(Poly_StringGrid.Cells[j-1,k])
        else
          HlpVar:=0;
        NrOfSides[k]:=HlpVar;                             {Dummy statement}
      end;
      Except on E: exception do
      begin
        Showmessage ('One or more of the data values are not valid');
        exit;
      end;
    end; {Try}

    for j:=2 to NrOfItems do for k:=0 to NrOfIntPoly-1 do
    begin
      if (j<4) and (Poly_StringGrid .Cells[j-1,k]='') then
      begin
        Showmessage ('You have added polygons.  Please complete the'+
                     ' empty spaces.');
        exit;
      end;
    end;

    for j:= 2 to NrOfItems do for k:=0 to NrOfIntPoly-1 do
    begin
       if (Poly_StringGrid .Cells[j-1,k+1]<>'-') and
          (Poly_StringGrid .Cells[j-2,k+1]='-') then
      begin
        Showmessage ('There are empty fields. Please correct.');
        exit;
      end;
    end;
    for k:=0 to NrOfIntPoly do NrOfSides[k]:=0;
    for j:=1 to 8 do Setlength (Neighbor[j],NrOfIntPoly+1);
    for j:=2 to NrOfItems do
    begin
      for k:=0 to NrOfIntPoly-1 do
      begin
        if (Poly_StringGrid .Cells[j-1,k]<>'0') and
        (Poly_StringGrid .Cells[j-1,k]<>'') then
        begin
          HlpVar := strtoint(Poly_StringGrid .Cells[j-1,k]);
          Neighbor[j-1,k]:=HlpVar;
          if HlpVar>0 then NrOfSides[k]:=NrOfSides[k]+1;
        end;
        if (Poly_StringGrid .Cells[j-1,k]='') then
            Neighbor[j-1,k]:=0;
      end;
    end;
    CheckOK:=true;
  end; {with DataMod do}
  GuideEnded:=true;
end; {TMainForm.MakeNetworkValues}
{--------------------------------}



procedure TMainForm.ShowInternalTable;
{------------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' SL       ';
    PolyHeaderLabel[3].Caption:=' Dr       ';
    PolyHeaderLabel[4].Caption:=' Dt       ';
    PolyHeaderLabel[5].Caption:='Aq. type  ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Level of the soil surface (m)';
    PolyHeaderLabel[3].Hint:='Depth of the root zone (m) equalling'+
                          ' the depth to which evaporation   can occur';
    PolyHeaderLabel[4].Hint:='Thickness of the transition zone (m)'+
              ' where flow can be intermediate   between vertical as'+
              ' in the root zone and horizontal as in the aquifer';
    PolyHeaderLabel[5].Hint:='Index for phreatic or semi-confined'+
        ' aquifer:  0 = phreatic (free),    1 = semi-confined';
    for j:=0 to DataMod.NrOfItems-1 do
        for k:=0 to DataMod.NrOfIntPoly do
        begin
            if k=0 then
            begin
              Poly_StringGrid.Cells[0,k]:='Number';
              Poly_StringGrid.Cells[1,k]:=' (m)  ';
              Poly_StringGrid.Cells[2,k]:=' (m)  ';
              Poly_StringGrid.Cells[3,k]:=' (m)  ';
              Poly_StringGrid.Cells[4,k]:=' (-)  ';
            end;
            if k>0 then
            begin
              if j=0 then Poly_StringGrid.Cells[0,k]:=
                          IntToStr(NodeNr[k-1]);
              if j>0 then
                 if not InputOpened and not SelfDone then
                    Poly_StringGrid.Cells[j,k]:='0'
//Why not ' -1 ' ?
                 else
                 begin
                   if j<4 then
                      Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1])
                   else
                      Poly_StringGrid .Cells[j,k] := IntToStr(AquiferType[k-1]);
                 end;
            end;
        end;
  end; {with DataMod do}
  Poly_StringGrid.Visible:=true;
  if DataMod.AnnualCalc and (DataMod.YearNr>0) then
     AnnualPoly_Memo.Visible:=true;
end; {TMainForm.ShowInternalTable}
{--------------------------------}



procedure TMainForm.MakeInternalValues (var CheckOK : boolean);
{-------------------------------------------------------------}
var j, k : integer;
begin
  with Datamod do
  begin
    For j:=1 to 4 do setlength(HlpValue[j],NrOfIntPoly);
    Try
      For j:=1 to NrOfItems-1 do
          for k:=0 to NrOfIntPoly-1 do
              HlpValue[j,k] := StringToFloat(Poly_StringGrid.Cells[j,k+1]);
      Except on E: exception do
      begin
        Showmessage ('The data group contains invalid entries');
        CheckOK:=false;
        DecimalSeparator:=InitDecSep;
        exit;
      end;
    end; {Try}
    setlength (AquiferType,NrOfIntPoly);                  {IS DIT NODIG ???}
    for k:=0 to NrOfIntPoly-1 do
        if (AquiferType[k]<1) and (HlpValue[4,k]>0) then AquiferChange:=true;
    Try
      for k:=0 to NrOfIntPoly-1 do
          AquiferType[k] := StrToInt(Poly_StringGrid.Cells[4,k+1]);
      Except on E: exception do
      begin
        Showmessage ('The aquifer type contains invalid entries');
        CheckOK:=false;
        exit;
      end;
    end; {Try}
  end; {with DataMod do}
  CheckOK:=true;
end; {TMainForm.MakeInternalValues}
{---------------------------------}



procedure TMainForm.ShowConductivityTable;
{----------------------------------------}
var Count,j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:='from node ';
    PolyHeaderLabel[2].Caption:=' to node  ';
    PolyHeaderLabel[3].Caption:=' Kaq      ';
    PolyHeaderLabel[4].Caption:=' Ktop     ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Neighbor node number';
    PolyHeaderLabel[3].Hint:='Horizontal hydraulic conductivity of'+
                             ' aquifer (m/day)';
    PolyHeaderLabel[4].Hint:='Horizontal hydraulic conductivity of'+
                             ' transition zone (m/day)';
    Poly_StringGrid.Visible:=false;
    Poly_StringGrid.FixedCols:=2;
    Poly_StringGrid.RowCount:=1;
    for k:= 0 to NrOfIntPoly-1 do for j:=1 to NrOfSides[k] do
        Poly_StringGrid.RowCount:=Poly_StringGrid.RowCount+1;
    Poly_StringGrid.FixedRows:=1;
    Poly_StringGrid.Width:=20+60*DataMod.NrOfItems;
    Poly_StringGrid.Height:=16+20*Poly_StringGrid.RowCount;
    if Poly_StringGrid.Height>337 then
    begin
      Poly_StringGrid.Width:=30+60*DataMod.NrOfItems;
      Poly_StringGrid.Height:=337;
    end;
    Count:=0;
    for k:=0 to DataMod.NrOfIntPoly do
    begin
      if k=0 then
      begin
        Poly_StringGrid.Cells[0,k]:='number';
        Poly_StringGrid.Cells[1,k]:='number';
        Poly_StringGrid.Cells[2,k]:=' m/day';
        Poly_StringGrid.Cells[3,k]:=' m/day';
      end else for j:=1 to NrOfSides[k-1] do
      begin
        Count:=Count+1;
        if j=1 then
           Poly_StringGrid.Cells[0,Count]:= IntToStr(NodeNr[k-1])
        else
           Poly_StringGrid.Cells[0,Count]:=' ';
        Poly_StringGrid.Cells[1,Count]:= IntToStr(Neighbor[j,k-1]);
        if not InputOpened then Poly_StringGrid.Cells[2,Count]:='0'
//Why not '-1'
           else Poly_StringGrid.Cells[2,Count]:=FloatToStr(Conduct[j,k-1]);
        if AquiferType[k-1]<1 then Poly_StringGrid.Cells[3,Count]:=' -'
           else Poly_StringGrid.Cells[3,Count]:=FloatToStr(TopCond[j,k-1]);
      end; {if k>0 then}
    end; {for k:=0 to DataMod.NrOfIntPoly-1 do for j:=1 to NrOfSides[k-1] do}
  end; {with DataMod do}
  AnnualPoly_Memo.Visible:=false;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowConductivityTable}
{------------------------------------}



procedure TMainForm.MakeConductivityValues (var CheckOK : boolean);
{-----------------------------------------------------------------}
var Count, j, k : integer;
    Negative : boolean;
begin
  with DataMod do
  begin
    CheckOK:=false;
    Count:=0;
    for k:=1 to NrOfIntPoly do for j:=1 to NrOfSides[k-1] do
    begin
      Count:=Count+1;
      Try
        begin
          Conduct[j,k-1]:=StringToFloat(Poly_StringGrid.Cells[2,Count]);
          if (j=1) and (AquiferType[k-1]>0) then
             TopCond[j,k-1]:=StringToFloat(Poly_StringGrid.Cells[3,Count])
          else TopCond[j,k-1]:=-1;
        end;
        Except on E: exception do
        begin
          Showmessage ('One or more of the data values are not valid');
          DecimalSeparator:=InitDecSep;
          exit;
        end;
      end; {Try}
    end; {for k:=0 to DataMod.NrOfIntPoly-1 do for j:=1 to NrOfSides[k-1] do}
    Negative:=false;
    for k:=0 to NrOfIntPoly-1 do for j:=1 to NrOfSides[k] do
    begin
      if Conduct[j,k]<0 then Negative:=true;
      if (j=1) and (AquiferType[k]>0) then if TopCond[j,k]<0 then Negative:=true;
    end;
    if Negative then
    begin
      Showmessage ('The aquifer type was changed.  Please check the negative'+
                   '  values.');
      exit;
    end;
  end; {with DataMod do}
  CheckOK:=true;
end; {TMainForm.MakeConductivityValues}
{-------------------------------------}



procedure TMainForm.ShowResistenceTable;
{--------------------------------------}
var k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Kvert    ';
    PolyHeaderLabel[3].Caption:=' Dtop     ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Vertical hydraulic conductivity of'+
                             ' semi-confining layer';
    PolyHeaderLabel[3].Hint:='Depth at which the semi-confining layer starts';
    for k:=0 to DataMod.NrOfIntPoly do
    begin
      if k=0 then
      begin
        Poly_StringGrid.Cells[0,k]:='number';
        Poly_StringGrid.Cells[1,k]:=' m/day';
        Poly_StringGrid.Cells[2,k]:='  m';
      end else
      begin
        Poly_StringGrid.Cells[0,k]:=IntToStr(NodeNr[k-1]);
        if not InputOpened then
        begin
          Poly_StringGrid.Cells[1,k]:='0';
          Poly_StringGrid.Cells[2,k]:='0';
//Why not '-1' ?
          if AquiferType[k-1]<1 then
          begin
             Poly_StringGrid.Cells[1,k]:='-';
             Poly_StringGrid.Cells[2,k]:='-';
          end;
        end else
        begin
          Poly_StringGrid.Cells[1,k]:=FloatToStr(VertCond[k-1]);
          Poly_StringGrid.Cells[2,k]:=FloatToStr(TopLayer[k-1]);
          if AquiferType[k-1]<1 then
          begin
             Poly_StringGrid.Cells[1,k]:='-';
             Poly_StringGrid.Cells[2,k]:='-';
          end;
        end;
      end; {if k>0 then}
    end; {for k:=0 to DataMod.NrOfIntPoly do-1 for j:=1 to NrOfSides[k-1] do}
  end; {with DataMod do}
  AnnualPoly_Memo.Visible:=false;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowRessistenceTable}
{-----------------------------------}



procedure TMainForm.MakeResistenceValues (var CheckOK : boolean);
{---------------------------------------------------------------}
var k : integer;
    Negative : boolean;
begin
  with DataMod do
  begin
    CheckOK:=false;
    for k:=1 to NrOfIntPoly do
    begin
      Try
        begin
          if AquiferType[k-1]>0 then
          begin
            VertCond[k-1]:=StringToFloat(Poly_StringGrid.Cells[1,k]);
            TopLayer[k-1]:=StringToFloat(Poly_StringGrid.Cells[2,k]);
          end else
          begin
            VertCond[k-1]:=-1;
            TopLayer[k-1]:=-1;
          end;
        end;
        Except on E: exception do
        begin
          Showmessage ('One or more of the data values are not valid');
          DecimalSeparator:=InitDecSep;
          exit;
        end;
      end; {Try}
    end; {for k:=0 to DataMod.NrOfIntPoly-1 do for j:=1 to NrOfSides[k-1] do}
    Negative:=false;
    for k:=0 to NrOfIntPoly-1 do if AquiferType[k]>0 then
    begin
      if VertCond[k]<0 then Negative:=true;
      if TopLayer[k]<0 then Negative:=true;
    end;
    if Negative then
    begin
      Showmessage ('Negative values are present.  Please correct');
      exit;
    end;
    CheckOK:=true;
  end; {with DataMod do}
end; {TMainForm.MakeResistenceValues}
{-----------------------------------}



procedure TMainForm.ShowTotPorTable;
{----------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Ptr      ';
    PolyHeaderLabel[3].Caption:=' Ptx       ';
    PolyHeaderLabel[4].Caption:=' Ptq       ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Total porosity root zone (fraction)'+
                             '  0.1<Ptr<0.9';
    PolyHeaderLabel[3].Hint:='Total porosity transition zone (fraction)'+
                             '  0.1<Ptx<0.9';
    PolyHeaderLabel[4].Hint:='Total porosity aquifer (fraction)'+
                             '  0.1<Ptq<0.9';
    for j:=0 to DataMod.NrOfItems-1 do
        for k:=0 to DataMod.NrOfIntPoly do
        begin
            if k=0 then
            begin
                Poly_StringGrid.Cells[0,k]:='Number';
                Poly_StringGrid.Cells[1,k]:=' (-)  ';
                Poly_StringGrid.Cells[2,k]:=' (-)  ';
                Poly_StringGrid.Cells[3,k]:=' (-)  ';
            end;
            if k>0 then
            begin
              if j=0 then Poly_StringGrid.Cells[0,k]:=
                          IntToStr(NodeNr[k-1]);
              if j>0 then
                 if not InputOpened and not SelfDone then
                    Poly_StringGrid.Cells[j,k]:='0'
                 else
                    Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1]);
            end;
        end;
  end; {with DataMod do}
  Poly_StringGrid.Visible:=true;
  if DataMod.AnnualCalc and (DataMod.YearNr>0) then
     AnnualPoly_Memo.Visible:=true;
end; {TMainForm.ShowTotPorTable}
{--------------------------------}



procedure TMainForm.ShowEffPorTable;
{----------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Per      ';
    PolyHeaderLabel[3].Caption:=' Pex       ';
    PolyHeaderLabel[4].Caption:=' Peq       ';
    PolyHeaderLabel[5].Caption:=' Psq       ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Effectve porosity root zone (fraction)'+
                             '  0.01<Per<Ptr<0.5';
    PolyHeaderLabel[3].Hint:='Effective porosity transition zone (fraction)'+
                             '  0.01<Pex<Ptx<0.5';
    PolyHeaderLabel[4].Hint:='Effective porosity aquifer (fraction)'+
                             '  0.1<Peq<Ptq<0.5';
    PolyHeaderLabel[5].Hint:='Storativity of the semi-confined aquifer'+
                             ' (fraction),  <Psq<Peq<0.5';
    PolyComment_Panel.Visible:=true;
    PolyComment_Memo.Visible:=true;
    PolyComment_Memo.Lines.Clear;
    PolyComment_Memo.Lines.Add ('   " - " = n.a.'    );
    PolyComment_Memo.Lines.Add ('The storativity Psq');
    PolyComment_Memo.Lines.Add ('is only applicable' );
    PolyComment_Memo.Lines.Add (' when the aquifer' ) ;
    PolyComment_Memo.Lines.Add (' is semi-confined, ');
    PolyComment_Memo.Lines.Add (' see the internal'  );
    PolyComment_Memo.Lines.Add ('    system data'    );
    for j:=0 to DataMod.NrOfItems-1 do
        for k:=0 to DataMod.NrOfIntPoly do
        begin

            if k=0 then
            begin
                Poly_StringGrid.Cells[0,k]:='Number';
                Poly_StringGrid.Cells[1,k]:=' (-)  ';
                Poly_StringGrid.Cells[2,k]:=' (-)  ';
                Poly_StringGrid.Cells[3,k]:=' (-)  ';
                Poly_StringGrid.Cells[4,k]:=' (-)  ';
            end;
            if k>0 then
            begin
              if j=0 then Poly_StringGrid.Cells[0,k]:=
                          IntToStr(NodeNr[k-1]);
              if j>0 then
                 if not InputOpened and not SelfDone then
                    Poly_StringGrid.Cells[j,k]:='0'
                 else
                 begin
                   if j<DataMod.NrOfItems-1 then
                     Poly_StringGrid.Cells[j,k] := FloatToStr(HlpValue[j,k-1]);
                   if j=DataMod.NrOfItems-1 then if AquiferType[k-1]=1 then
                     Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1])
                   else Poly_StringGrid.Cells[j,k]:=' -';
                 end;
            end;
        end;
  end; {with DataMod do}
  AnnualPoly_Memo.Visible:=false;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowEffPorTable}
{--------------------------------}



procedure TMainForm.ShowLeachingTable;
{------------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Flr      ';
    PolyHeaderLabel[3].Caption:=' Flx      ';
    PolyHeaderLabel[4].Caption:=' Flq      ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Leaching efficiency root zone (ratio)'+
                             '  0.01<Flr<2';
    PolyHeaderLabel[3].Hint:='Leaching efficiency transition zone (ratio)'+
                             '  0.01<Flx<2';
    PolyHeaderLabel[4].Hint:='Leaching efficiency aquifer (ratio)'+
                             '  0.01<Flq<2';
    for j:=0 to DataMod.NrOfItems-1 do
        for k:=0 to DataMod.NrOfIntPoly do
        begin
            if k=0 then
            begin
                Poly_StringGrid.Cells[0,k]:='Number';
                Poly_StringGrid.Cells[1,k]:=' (-)  ';
                Poly_StringGrid.Cells[2,k]:=' (-)  ';
                Poly_StringGrid.Cells[3,k]:=' (-)  ';
            end;
            if k>0 then
            begin
              if j=0 then Poly_StringGrid.Cells[0,k]:=
                          IntToStr(NodeNr[k-1]);
              if j>0 then
                 if not InputOpened and not SelfDone then
                    Poly_StringGrid.Cells[j,k]:='0'
                 else
                    Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1]);
            end;
        end;
  end; {with DataMod do}
  AnnualPoly_Memo.Visible:=false;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowLeachingTable}
{--------------------------------}



procedure TMainForm.ShowAgricultTable;
{------------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Kd      ';
    PolyHeaderLabel[3].Caption:=' Kf      ';
    PolyHeaderLabel[4].Caption:=' Kr      ';
    PolyHeaderLabel[5].Caption:=' Krf     ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:= 'Index for the presence of a horizontal'+
                              ' subsurface drainage system:    0=No, 1=Yes';
    PolyHeaderLabel[3].Hint:= 'Index for the siumulation of farmers'+
                              ' responses: 0=No, 1=Yes';
    PolyHeaderLabel[4].Hint:= 'Rotation key, Kr = 0, 1, 2, . . 7 or 10, '+
                              ' see "Kr Help"';
    PolyHeaderLabel[5].Hint:= 'Index for inclusion of rotation type Kr '+
                              ' in farmers responses Kf:     0=No, 1=Yes';
    for j:=0 to DataMod.NrOfItems-1 do
        for k:=0 to DataMod.NrOfIntPoly do
        begin
            if k=0 then
            begin
                Poly_StringGrid.Cells[0,k]:='Number';
                Poly_StringGrid.Cells[1,k]:=' (-)  ';
                Poly_StringGrid.Cells[2,k]:=' (-)  ';
                Poly_StringGrid.Cells[3,k]:=' (-)  ';
                Poly_StringGrid.Cells[4,k]:=' (-)  ';
            end;
            if k>0 then
            begin
              if j=0 then Poly_StringGrid.Cells[0,k]:=
                          IntToStr(NodeNr[k-1]);
              if j>0 then
                 if not InputOpened and not SelfDone then
                    Poly_StringGrid.Cells[j,k]:='0'
                 else
                    Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1]);
            end;
        end;
        for k:=1 to DataMod.NrOfIntPoly do
            if HlpValue[2,k-1]<1 then Poly_StringGrid .Cells[4,k]:=' -'
            else Poly_StringGrid .Cells[4,k]:=' 1';
  end; {with DataMod do}
  AnnualPoly_Memo.Visible:=false;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowAgricultTable}
{--------------------------------}



procedure TMainForm.ShowDrainageTable;
{------------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Dd      ';
    PolyHeaderLabel[3].Caption:=' QH1      ';
    PolyHeaderLabel[4].Caption:=' QH2      ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Drain depth (m), Dd > root zone depth';
    PolyHeaderLabel[3].Hint:='Q-H ratio for flow below drain level,'+
                             ' Hooghoudt equation, see symbols list';
    PolyHeaderLabel[4].Hint:='Q-H ratio for flow above drain level,'+
                             ' Hooghoudt equation, see symbols list';
    for j:=0 to DataMod.NrOfItems-1 do
        for k:=0 to DataMod.NrOfIntPoly do
        begin
            if k=0 then
            begin
                Poly_StringGrid.Cells[0,k]:='Number';
                Poly_StringGrid.Cells[1,k]:=' (m)  ';
                Poly_StringGrid.Cells[2,k]:=' 1/day';
                Poly_StringGrid.Cells[3,k]:=' 1/day';
            end;
            if k>0 then
            begin
              if j=0 then Poly_StringGrid.Cells[0,k]:=
                          IntToStr(NodeNr[k-1]);
              if j>0 then
                 if not InputOpened and not SelfDone then
                    Poly_StringGrid.Cells[j,k]:='0'
                 else
                 begin
                   if DrainIndex[k-1]>0 then
                     Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1])
                   else
                      Poly_StringGrid .Cells[j,k] := ' -';
                 end;
            end;
        end;
  end; {with DataMod do}
  AnnualPoly_Memo.Visible:=false;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowDrainageTable}
{--------------------------------}



procedure TMainForm.ShowSaltRootTable;
{------------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' CrA      ';
    PolyHeaderLabel[3].Caption:=' CrB      ';
    PolyHeaderLabel[4].Caption:=' CrU      ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Initial soil salinity of the root zone'+
                             ' in irrigated land under group A crops';
    PolyHeaderLabel[3].Hint:='Initial soil salinity of the root zone'+
                             ' in irrigated land under group B crops';
    PolyHeaderLabel[4].Hint:='Initial soil salinity of the root zone'+
                             ' in unirrigated (U) land ';
    for j:=0 to DataMod.NrOfItems-1 do
        for k:=0 to DataMod.NrOfIntPoly do
        begin
            if k=0 then
            begin
                Poly_StringGrid.Cells[0,k]:='Number';
                Poly_StringGrid.Cells[1,k]:=' dS/m ';
                Poly_StringGrid.Cells[2,k]:=' dS/m ';
                Poly_StringGrid.Cells[3,k]:=' dS/m ';
            end;
            if k>0 then
            begin
              if j=0 then Poly_StringGrid.Cells[0,k]:=
                          IntToStr(NodeNr[k-1]);
              if j>0 then
                 if not InputOpened and not SelfDone then
                    Poly_StringGrid.Cells[j,k]:='0'
                 else
                    Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1]);
            end;
        end;
  end; {with DataMod do}
  Poly_StringGrid.Visible:=true;
  if DataMod.AnnualCalc and (DataMod.YearNr>0) then
     AnnualPoly_Memo.Visible:=true;
end; {TMainForm.ShowSaltRootTable}
{--------------------------------}



procedure TMainForm.ShowSaltDeepTable;
{------------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Cxa      ';
    PolyHeaderLabel[3].Caption:=' Cxb      ';
    PolyHeaderLabel[4].Caption:=' Cx       ';
    PolyHeaderLabel[5].Caption:=' Cq       ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Initial soil salinity of the transition zone'+
                             ' above drain level';
    PolyHeaderLabel[3].Hint:='Initial soil salinity of the transition zone'+
                             ' below drain level';
    PolyHeaderLabel[4].Hint:='Initial soil salinity of the transtion zone'+
                             ' without drainage system';
    PolyHeaderLabel[5].Hint:='Initial soil salinity of the aquifer';
    for j:=0 to DataMod.NrOfItems-1 do
        for k:=0 to DataMod.NrOfIntPoly do
        begin
            if k=0 then
            begin
                Poly_StringGrid.Cells[0,k]:='Number';
                Poly_StringGrid.Cells[1,k]:=' dS/m ';
                Poly_StringGrid.Cells[2,k]:=' dS/m ';
                Poly_StringGrid.Cells[3,k]:=' dS/m ';
                Poly_StringGrid.Cells[4,k]:=' dS/m ';
            end;
            if k>0 then
            begin
              if j=0 then Poly_StringGrid.Cells[0,k]:=
                          IntToStr(NodeNr[k-1]);
              if j>0 then
                 if not InputOpened and not SelfDone then
                    Poly_StringGrid.Cells[j,k]:='0'
                 else
                 begin
                   if (j=1) or (j=2) then
                     if DataMod.DrainIndex[k-1]>0 then
                       Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1])
                     else
                       Poly_StringGrid .Cells[j,k] := ' -';
                   if j=3 then
                     if DataMod.DrainIndex[k-1]<1 then
                       Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1])
                     else
                       Poly_StringGrid .Cells[j,k] := ' -';
                   if j=4 then
                      Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1]);
                 end;
            end;
        end;
  end; {with DataMod do}
  Poly_StringGrid.Visible:=true;
  if DataMod.AnnualCalc and (DataMod.YearNr>0) then
     AnnualPoly_Memo.Visible:=true;
end; {TMainForm.ShowSaltDeepTable}
{--------------------------------}



procedure TMainForm.ShowCritDepthTable;
{-------------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Dc       ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Critical depth of the water table for'+
                             ' capillary rise: below this depthcapillary'+
                             ' rise is absent. Dc > rootzone depth';
    for j:=0 to 1 do
        for k:=0 to DataMod.NrOfIntPoly do
        begin
          if k=0 then
          begin
            Poly_StringGrid.Cells[0,k]:='Number';
            Poly_StringGrid.Cells[1,k]:=' (m) ';
          end;
          if k>0 then
          begin
            if j=0 then Poly_StringGrid.Cells[0,k]:=
                        IntToStr(NodeNr[k-1]);
            if j=1 then
            begin
              if not InputOpened and not SelfDone then
                 Poly_StringGrid.Cells[j,k]:='0'
              else
                Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[2,k-1]);
            end;
          end;
        end;
  end; {with DataMod do}
  AnnualPoly_Memo.Visible:=false;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowCrtDepthTable}
{--------------------------------}



procedure TMainForm.ShowExtSalTable;
{----------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Cq       ';
    PolyHeaderLabel[1].Hint:='Node number of external polygon';
    PolyHeaderLabel[2].Hint:='Salt concentration of the the ground water'+
                             ' in the aquifer of the      external polygons';
    for j:=0 to DataMod.NrOfItems-1 do
        for k:=0 to DataMod.NrOfExtPoly do
        begin
            if k=0 then
            begin
                Poly_StringGrid.Cells[0,k]:='Number';
                Poly_StringGrid.Cells[1,k]:=' dS/m ';
            end;
            if k>0 then
            begin
              if j=0 then Poly_StringGrid.Cells[0,k]:=
                          IntToStr(NodeNr[NrOfIntPoly+k-1]);
              if j=1 then
              begin
                if not InputOpened and not SelfDone then
                   Poly_StringGrid.Cells[j,k]:='0'
                else
                  Poly_StringGrid.Cells[j,k]:=FloatToStr(HlpValue[j,k-1]);
              end;
            end;
        end;
  end; {with DataMod do}
  AnnualPoly_Memo.Visible:=false;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowExtSalTable}
{------------------------------}



procedure TMainForm.ShowHydHeadTable;
{-----------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Hw       ';
    PolyHeaderLabel[3].Caption:=' Hp       ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Initial water level with respect to'+
                             ' reference level';
    PolyHeaderLabel[3].Hint:='Initial water pressure in semi-confined'+
                             ' aquifer with respect to       reference level';
    for j:=0 to 2 do
        for k:=0 to NrOfIntPoly do
        begin
            if k=0 then
            begin
                Poly_StringGrid.Cells[0,k]:='Number';
                Poly_StringGrid.Cells[1,k]:=' (m) ';
                Poly_StringGrid.Cells[2,k]:=' (m) ';
            end;
            if k>0 then
            begin
              if j=0 then Poly_StringGrid.Cells[0,k]:=
                          IntToStr(NodeNr[k-1]);
              if j>0 then
              begin
                if not InputOpened and not SelfDone then
                   Poly_StringGrid.Cells[j,k]:='0'
                else
                begin
                  if j=1 then
                     Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1]);
                  if j=2 then
                  begin
                    if AquiferType[k-1]>0 then
                    Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[3,k-1])
                    else
                    Poly_StringGrid .Cells[j,k] := ' -';
                  end;
                end;
              end;
            end;
        end;
  end; {with DataMod do}
  Poly_StringGrid.Visible:=true;
  if DataMod.AnnualCalc and (DataMod.YearNr>0) then
     AnnualPoly_Memo.Visible:=true;
end; {TMainForm.ShowHydHeadTable}
{-------------------------------}



procedure TMainForm.ShowQinflowTable;
{-----------------------------------}
var j,k : integer;
begin
  with DataMod do
  begin
    SetPoly_StringGridStandards;
    PolyHeaderLabel[1].Caption:=' Node     ';
    PolyHeaderLabel[2].Caption:=' Qinf     ';
    PolyHeaderLabel[3].Caption:=' Cinf     ';
    PolyHeaderLabel[4].Caption:=' Qout     ';
    PolyHeaderLabel[1].Hint:='Node number of internal polygon';
    PolyHeaderLabel[2].Hint:='Constant inflow condition into the aquifer.'+
                             ' The inflow may come       through cracks from'+
                             ' a deeper aquifer, or a geological fault line';
    PolyHeaderLabel[3].Hint:='Salt concentration of the aquifer inflow Qinf';
    PolyHeaderLabel[4].Hint:='Constant outflow condition from the aquifer.'+
                             ' The outflow may go       through cracks into,'+
                             ' a deeper aquifer, or a geological fault line';
    for j:=0 to DataMod.NrOfItems-1 do
        for k:=0 to DataMod.NrOfIntPoly do
        begin
          if k=0 then
          begin
            Poly_StringGrid.Cells[0,k]:='Number';
            Poly_StringGrid.Cells[1,k]:=' m/year';
            Poly_StringGrid.Cells[2,k]:=' dS/m ';
            Poly_StringGrid.Cells[3,k]:=' m/year';
          end;
          if k>0 then
          begin
            if j=0 then Poly_StringGrid.Cells[0,k]:=
                        IntToStr(NodeNr[k-1]);
            if j>0 then
            begin
              if not InputOpened and not SelfDone then
                 Poly_StringGrid.Cells[j,k]:='0'
              else
                Poly_StringGrid .Cells[j,k] := FloatToStr(HlpValue[j,k-1]);
            end;
            if (j=2) and (HlpValue[1,k-1]=0) then
               Poly_StringGrid.Cells[j,k]:=' -';
          end;
        end;
  end; {with DataMod do}
  AnnualPoly_Memo.Visible:=false;
  Poly_StringGrid.Visible:=true;
end; {TMainForm.ShowQinflowTable}
{-------------------------------}



procedure TMainForm.NetworkCancel_ButtonClick(Sender: TObject);
{------------------------------------------------------------}
begin
  inherited;
  GeneralInput_Tabsheet.Show;
end; {TMainForm.NetworkCancelButtonClick}
{---------------------------------------}




procedure TMainForm.Poly_StringGridSetEditText(Sender: TObject; ACol,
                    ARow: Integer; const Value: String);
{-------------------------------------------------------------}
var MultiPaste:boolean;
begin
  MultiPaste := (POS(FORMAT('%s',[#9]), Value)> 0 );
  MultiPaste := MultiPaste or (POS(FORMAT('%s',[#13]), Value)> 0 );
  if MultiPaste then
  begin
    Try
      HandlePasteMultiCell(Sender, ACol, ARow, Value) ;
      Except on E: Exception do
      begin
        Showmessage ('There are no data to be pasted or the data'+
                     ' are incompatible');
        PolygonalInput_Tabsheet.Show;
      end;
    end;
  end;
  InputOpened:=true;
end; {MainForm.StringGrid1SetEditText}


procedure TMainForm.HandlePasteMultiCell(Sender: TObject; ACol,
                    ARow: Integer; const Value: String);
{-------------------------------------------------------------}
// only accepts numbers to be pasted into the grid
  var
   i, m, j, k, startcol, CC: integer;
   c: char ;
//   InitNrOfData, FinalNrOfData: integer;
//   Result: boolean;
begin

  // MessageDlg(Value, mtInformation, [mbOK], 0);
  m := Length(Value);
  (Sender as TStringGrid).Cells[ACol,ARow] := '' ;
  startcol := ACol;
  i := 1;
  k := 1;
  while i <= m do begin
  // loop through the characters of the Value string
    c := Value[i];
    j := Integer(c);
    if j = 9 then begin // tab: Move to next column
      ACol := ACol + 1 ;
      if i < m then // empty the cell if not at end
        (Sender as TStringGrid).Cells[ACol,ARow] := '' ;
    end
    else if j = 13 then begin // CR - is followed by LF
    // Move to next row, jump back to startcolumn
      Poly_StringGrid.RowCount:=k+1;
      k:=k+1;
      ARow := ARow + 1 ;
      ACol := startcol ;
      i := i + 1 ; // skip the LF
      if i < m then // empty the cell it if not at end
        (Sender as TStringGrid).Cells[ACol,ARow] := '' ;
    end
    else // add the character to the string in the cell if a number
    if c in ['.',',','-',#48,#49,#50,#51,#52,#53,#54,#55,#56,#57] then
        (Sender as TStringGrid).Cells[ACol,ARow] :=
          ConCat((Sender as TStringGrid).Cells[ACol,ARow], c);
    i := i + 1 ;
  end;

  IF GROUPSTYPE='Polygonal' THEN
  BEGIN

  Poly_StringGrid.RowCount:=DataMod.NrOfIntPoly+1;
  if Overall_RadioButton.Checked then
     Poly_StringGrid.RowCount:=DataMod.TotNrOfPoly+1;
  if (Identity='Network') or (Identity='Finished') then
     Poly_StringGrid.RowCount:=DataMod.NrOfIntPoly;
  CC:=0;
  if Conductivity_Radiobutton.Checked then with DataMod do
  begin
    for k:= 0 to NrOfIntPoly-1 do for j:=1 to NrOfSides[k] do
        CC:=CC+1;
    Poly_StringGrid.RowCount:=CC+1;
    Poly_StringGrid.Height:=16+20*(CC+1);
  end;
  if ExtSal_RadioButton.Checked then
  begin
     Poly_StringGrid.RowCount:=DataMod.NrOfExtPoly+1;
     Poly_StringGrid.Height:=16+20*(DataMod.NrOfExtPoly+1);
 end;

  for i:=0 to Poly_StringGrid.RowCount do
      if (Identity='Network') or (Identity='Finished') then
      begin
          Poly_StringGrid.Cells[0,i]:=IntToStr(i+1);
          Poly_StringGrid.Height:=16+20*(DataMod.NrOfIntPoly);
      end else if not Conductivity_Radiobutton.Checked and
          not ExtSal_RadioButton.Checked then
      begin
          Poly_StringGrid.Cells[0,i+1]:=IntToStr(i+1);
          Poly_StringGrid.Height:=16+20*(DataMod.NrOfIntPoly+1);
      end;
  if Poly_StringGrid.Height>337 then
  begin
    if DataMod.NrOfItems=0 then DataMod.NrOfItems:=5;
    Poly_StringGrid.Width:=30+60*DataMod.NrOfItems;
    Poly_StringGrid.Height:=337;
  end;

  END; {IF GROUPSTYPE=POLYGONAL THEN}

  IF GROUPSTYPE='Seasonal'THEN
  BEGIN
  if not Durations_Radiobutton.Checked and
     not ExternHead_RadioButton.Checked then with DataMod do
  begin
    CC:=DataMod.NrOfIntPoly*NrOfSeasons;
    Season_StringGrid.RowCount:=CC+1;
    Season_StringGrid.Height:=20+20*(CC+1);
    if Season_StringGrid.Height>303 then
    begin
      if DataMod.NrOfItems=0 then DataMod.NrOfItems:=5;
      Season_StringGrid.Width:=27+60*DataMod.NrOfItems;
      Season_StringGrid.Height:=303;
    end;
  end;
  if ExternHead_Radiobutton.Checked then
  begin
    CC:=DataMod.NrOfExtPoly*DataMod.NrOfseasons;
    Season_StringGrid.RowCount:=CC+1;
    Season_StringGrid.Height:=16+20*(CC+1);
    if Season_StringGrid.Height>303 then
    begin
      if DataMod.NrOfItems=0 then DataMod.NrOfItems:=5;
      Season_StringGrid.Width:=27+60*DataMod.NrOfItems;
      Season_StringGrid.Height:=303;
    end;
  end;
(*
  if Durations_Radiobutton.Checked then
  begin
      for k:=1 to DataMod.NrOfSeasons do
      begin
          Season_StringGrid.Cells[0,k]:= IntToStr(k);
          Season_StringGrid .Cells[1,k] :=
                 FloatToStr(DataMod.DurationOfSeason[k]);
          DataMod.SeasonDuration[k] :=
                  DataMod.DurationOfSeason[k];
          Showmessage ('The data on season duration will not be changed'+
                       ' after copy/paste.');
      end;
  end;
*)

  END {IF GROUPSTYPE='Seasonal'THEN}

end; {MainForm.HandlePasteMultiCell}



procedure TMainForm.SetPolyComponents (const Switch : string);
{------------------------------------------------------------}
begin

  PolygonalInput_Tabsheet.TabVisible:=true;

  if Switch='ToSetUpNetwork' then
  begin
    PolyNetwork_Panel.Visible:=true;
    NetworkCancel_Button.Visible:=true;
    InputOpen.Enabled:=true;
    PolyGroup_Panel.Visible:=false;
    PolyPanelCancel_Button.Visible:=false;
    PolyHeader_Panel.Visible:=false;
    PolyExplanation1_Label.Visible:=false;
    PolyExplanation2_Label.Visible:=false;
    PolyExplanation2_Edit.Visible:=false;
    PolyExplanation1_Edit.Visible:=false;
    PolyCol_Panel.Visible:=false;
    PolyComment_Panel.Visible:=false;
    Poly_StringGrid.Visible:=false;
    PolyComment_Panel.Visible:=false;
    KrHelp_Button.Visible:=false;
    PolyShowMap_Button.Visible:=false;
    PolyGroupCancel_Button.Enabled:=false;
    PolyInputSymbols_Button.Enabled:=false;
    PolyGroupSave_Button.Enabled:=false;
    SeasonalInput_Tabsheet.TabVisible:=false;
    SetToGroupSelection:=false;
    StatusText ('Select whether to enter nodal network data independently'+
                ' or to use the guidance menu');
  end; {if Switch='ToSetUpNetwork' then}

  if Switch='ToGroupSelection' then
  begin
    GeneralInput_Tabsheet.TabVisible:=true;
    SeasonalInput_Tabsheet.TabVisible:=true;
    Output_Tabsheet.TabVisible:=true;
    Graphics_Tabsheet.TabVisible:=true;
    Intro_Tabsheet.TabVisible:=true;
    Figure_Tabsheet.TabVisible:=true;
    PolyGroup_Panel.Visible:=true;
    PolyPanelCancel_Button.Visible:=true;
    SetToGroupSelection:=true;
    InputOpen.Enabled:=true;
    PolyHeader_Panel.Visible:=false;
    PolyExplanation1_Label.Visible:=false;
    PolyExplanation2_Label.Visible:=false;
    PolyExplanation2_Edit.Visible:=false;
    PolyExplanation1_Edit.Visible:=false;
    PolyCol_Panel.Visible:=false;
    PolyNetwork_Panel.Visible:=false;
    NetworkCancel_Button.Visible:=false;
    PolyComment_Panel.Visible:=false;
    Poly_StringGrid.Visible:=false;
    PolyComment_Panel.Visible:=false;
    KrHelp_Button.Visible:=false;
    PolyGroupCancel_Button.Enabled:=false;
    PolyInputSymbols_Button.Enabled:=false;
    PolyGroupSave_Button.Enabled:=false;
    if InputOpened then PolyShowMap_Button.Visible:=true;
    StatusText ('Select the data group to be edited. To save all data or'+
                ' perform calculations use "Save/calculate" on the'+
                ' General Input tabsheet');
  end; {if Switch='ToGroupSelection' then}

  if Switch='ToGroupEditing' then
  begin
    GeneralInput_Tabsheet.TabVisible:=false;
    SeasonalInput_Tabsheet.TabVisible:=false;
    Output_Tabsheet.TabVisible:=false;
    Graphics_Tabsheet.TabVisible:=false;
    Intro_Tabsheet.TabVisible:=false;
    Figure_Tabsheet.TabVisible:=false;
    PolyGroup_Panel.Visible:=false;
    PolyPanelCancel_Button.Visible:=false;
    PolyNetwork_Panel.Visible:=false;
    NetworkCancel_Button.Visible:=false;
    SetToGroupSelection:=false;
    InputOpen.Enabled:=false;
    Poly_StringGrid.Visible:=true;
    PolyInputSymbols_Button.Enabled:=true;
    NetworkCancel_Button.Enabled:=false;
    PolyGroupSave_Button.Enabled:=true;
    PolyGroupCancel_Button.Enabled:=true;
    PolyHeader_Panel.Visible:=true;
    PolyExplanation1_Label.Visible:=true;
    PolyExplanation2_Label.Visible:=true;
    PolyExplanation1_Edit.Visible:=false;
    PolyExplanation2_Edit.Visible:=true;
    PolyInputSymbols_Button.Enabled:=true;
    if InputOpened then PolyShowMap_Button.Visible:=true;
    StatusText ('Use "Save group" to save the group data.');
  end; {if Switch='ToGroupEditing' then}

end; {TMainForm.SetPolyComponents}
{--------------------------------}



procedure TMainForm.SetPoly_StringGridStandards;
{----------------------------------------------}
var j, NrOfPoly : integer;
begin
  Poly_StringGrid.Visible:=false;
  PolyHeader_Panel.Visible:=true;
  PolyHeader_Panel.Width:=5+60*DataMod.NrOfItems;
  for j:=1 to DataMod.NrOfItems do
  begin
    PolyHeaderLabel[j]:=Tlabel.Create(self);
    PolyHeaderLabel[j].Parent:=PolyHeader_Panel;
    PolyHeaderLabel[j].Top:=3;
    PolyHeaderLabel[j].Width:=60;
    PolyHeaderLabel[j].Height:=30;
    if j=1 then PolyHeaderLabel[j].Left:=4
    else PolyHeaderLabel[j].Left:=PolyHeaderLabel[j-1].Left+60;
    PolyHeaderLabel[j].OnMouseEnter := ShowExplainEdit2;
    PolyHeaderLabel[j].OnMouseLeave := HideExplainEdit2;
  end;
  NrOfPoly:=DataMod.NrOfIntPoly;
  if Identity='Overall' then NrOfPoly:=DataMod.TotNrOfPoly;
  if Identity='Extsal' then NrOfPoly:=DataMod.NrOfExtPoly;
  Poly_StringGrid.RowCount:=1+NrOfPoly;
  if Identity='Network' then Poly_StringGrid.RowCount:=NrOfPoly;
  Poly_StringGrid.ColCount:=DataMod.NrOfItems;
  Poly_StringGrid.Width:=20+60*DataMod.NrOfItems;
  Poly_StringGrid.Height:=16+20*(NrOfPoly+1);
  if Identity='Network' then Poly_StringGrid.Height:=16+20*(NrOfPoly);
  if Poly_StringGrid.Height>337 then
  begin
    Poly_StringGrid.Width:=30+60*DataMod.NrOfItems;
    Poly_StringGrid.Height:=337;
  end;
  Poly_StringGrid.FixedCols:=1;
  if Identity='Network' then Poly_StringGrid.FixedRows:=0
  else  Poly_StringGrid.FixedRows:=1;
  HideExplainEdit2(Sender);
end; {TMainForm.SetPoly_StringGridStandards}
{-----------------------------------------}



function TMainForm.SetAndVerifySaveName;
{--------------------------------------}
var YearStr:string;
begin Inherited;
      Result := false;
      NoSave := false;
      if not DataMod.AnnualCalc or
            (DataMod.AnnualCalc and (DataMod.YearNr<1)) then
      begin
        Showmessage ('Please determine file and folder name for saving the data');
        if InputSave_Dialog.Execute then with DataMod do
        begin
          DataMod.SaveFileName := InputSave_Dialog.Files.Strings[0];
          SaveFileName := ChangeFileExt(SaveFileName,'.inp');         {nodig?}
          if FileExists(DataMod.SaveFileName)
          then  Result := Question('The file already exists, overwrite?')
          else  Result := true;
        end;
      end;
      if not Result then NoSave:=true;
      if DataMod.AnnualCalc and (DataMod.YearNr>1) then with DataMod do
      begin
         YearStr:=inttostr(YearNr);
         SaveFileName := ChangeFileExt(OpenFileName,'');
         SaveFileName:=SaveFileName+YearStr;
         SaveFileName := ChangeFileExt(SaveFileName,'.inp');
         Result:=true;
         NoSave:=false;
      end;
end; {TMainForm.SetAndVerifySaveName}
{-----------------------------------}



procedure TMainForm.PolyPanelCancel_ButtonClick(Sender: TObject);
{--------------------------------------------------------------------}
var AbandonOK : boolean;
begin
  inherited;
  GuidedOK:=false;
  if Critical then
  begin
    Critical:=false;
    AbandonOK:=DataMod.Question ('By using the cancel button SahysMod'+
               ' will abandon further network construction.  Is that OK?');
    if not AbandonOK then exit
    else
    begin
      Showmessage ('The setup of the nodal network is abandoned');
      FormCreate(Sender);
      PolygonalInput_Tabsheet.TabVisible:=false;
      GeneralInput_Tabsheet.TabVisible:=true;
      GeneralInput_Tabsheet.Show;
      exit;
    end;
  end else
  begin
    Showmessage ('The program will jump to the general input tabsheet.');
    PolygonalInput_Tabsheet.TabVisible:=false;
  end;
  NrOfPoly_Edit.Text:=IntToStr(DataMod.TotNrOfPoly);
  NrAdded_Edit.Text:='0';
  NrRemoved_Edit.Text:='0';
  if DataMod.RemovalStage then
  begin
    DataMod.RemovalStage:=false;
    GeneralInput_Tabsheet.TabVisible:=true;
    SeasonalInput_TabsheetShow (Sender);
    exit;
  end else
  if not InputOpened then NoRead:=true;
  GeneralInput_Tabsheet.TabVisible:=true;
  GeneralInput_Tabsheet.Show;
end; {TMainForm.PolyPanelCancel_ButtonClick}
{------------------------------------------}



{******************************************************************************
 End of PolygonalInput_Tabsheet, start of SeasonalInput_TabSheet
 ******************************************************************************}


{******************************************************************************
 SeasonalInput_TabSheet, public section
 ******************************************************************************}


procedure TMainForm.SeasonalInput_TabSheetShow(Sender: TObject);
{--------------------------------------------------------------}
var i:integer;
begin
  inherited;
  GroupsType:='Seasonal';
  if not ResponsChange then SetSeasonComponents('ToGroupSelection');
  AreaChange:=false;
  ChangeOfSeasonDuration:=false;
  if DirectoryExists (DataDir) then chdir (DataDir)
  else DataDir:=InitDir;
//After 'DoItSelf' or 'Guided', DataDir is empty and the 'Name' files are found
// in the starting directory. However, the above chdir is probably not required
  if InputOpened then
//The program may reach this point when the PolyGroupCancel_Button on the
//PolygonalInput_Tabsheet is used and the SeasonalInput_TabsheetShow is
//activated through SeasonalInput_Tabsheet.Tabvisible:=false while the
//'Name*' groupfiles were not yet created, for example when abandoning
//the ShowOverall or the ShowNetwork procedure under 'DoItSelf and then
//we don't want to read the groupfiles under InitialAreaSettings and
//under  ReadSeasonGroup
  begin
    if SetInitialAreas then InitialAreaSettings;
//Gives -1 values when a value is n.a. omdat AreaA or AreaB or AreaU are zero
(*
    if InputOpened and (DataMod.NrOfSeasonsAdded<>0) then
    begin
      DataMod.NrOfSeasons:=DataMod.NrOfSeasons + DataMod.NrOfSeasonsAdded;
      SeasonsAdded:=true;
      DataMod.AddToSeasonGroups;                             {contains message}
      DataMod.ReadSeasonGroup('Name18',4);        {for irrigated area settings}
    end else
*)
  end;
  if SelfDone or GuidedOK then
  begin
    PolyFile_Label.Visible:=false;
    SeasFileName_Label.Visible:=false;
    //no inputfile was saved yet and filename does not exist
  end;
  for i:=1 to DataMod.NrOfSeasons do
      DurationGrid.Cells[1,i-1]:=SeasonDurationEdit[i].Text;
  DurationGrid.RowCount:=DataMod.NrOfSeasons;
  DurationGrid.Height:=10+DataMod.NrOfSeasons*24;
  DurationPanel.Height:=DurationGrid.Height+60;
  SeeGraph_Button.Enabled:=false;
  SaveGroup_Button.Enabled:=false;
end;{TMainForm.SeasonalInput_TabSheetShow}
{----------------------------------------}



procedure TMainForm.Season_StringGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
{----------------------------------------------------------------------}
var MultiPaste:boolean;
begin
  inherited;
  MultiPaste := (POS(FORMAT('%s',[#9]), Value)> 0 );
  MultiPaste := MultiPaste or (POS(FORMAT('%s',[#13]), Value)> 0 );
  if MultiPaste then
  begin
    Try
      HandlePasteMultiCell(Sender, ACol, ARow, Value) ;
      Except on E: Exception do
      begin
        Showmessage ('There are no data to be pasted or the data'+
                     ' are incompatible');
        SeasonalInput_Tabsheet.Show;
      end;
    end;
  end;
end; {TMainForm.Season_StringGridSetEditText}
{-------------------------------------------}


procedure TMainForm.SeasGroup_ButtonClick(Sender: TObject);
{----------------------------------------------------------}
var i:integer;
begin
  inherited;
  SetSeasonComponents('ToGroupEditing');
  if DataMod.NrOfIntPoly>2 then SeasonCol_Panel.Visible:=true;
  if InputOpened then if not NoRead and not CalcDone then
  begin
    DataMod.ReadSeasonGroup('Name18',4);     {for area fractions}
    DataMod.ReadPolyGroup('Name08',4);        {for ResponsIndex}
  end;
  if DataMod.NodeNr[0]=DataMod.NodeNr[1] then
    for i:=0 to DataMod.NrOfIntPoly-1 do DataMod.NodeNr[i]:=i+1;
  with DataMod do
  begin
    if Areas_RadioButton.Checked and fileexists ('Name18') then
    begin
      Identity:='Areas';
      SeasComment_Panel.Visible:=true;
      SeasComment_Memo.Visible:=true;
      SeasComment_Memo.Lines.Clear;
      SeasComment_Memo.Lines.Add ('   " - " = n.a.'     );
      SeasComment_Memo.Lines.Add (' Rice crop indices'  );
      SeasComment_Memo.Lines.Add ('are only applicable' );
      SeasComment_Memo.Lines.Add ('if the corresponding');
      SeasComment_Memo.Lines.Add (' area fraction is'   );
      SeasComment_Memo.Lines.Add (' greater than zero'  );
      SeasComment_Memo.Lines.Add ('');
      if NoRead then NoRead:=false
      else ReadSeasonGroup('Name18',4);
      ShowAreasTable;
    end else

    if Climate_RadioButton.Checked then
    begin
      if SeasonsAdded and not AreasChecked then
      begin
        SeeAreasTableFirst;
        exit;
      end;
      Identity:='Climate';
      if NoRead then NoRead:=false
      else ReadSeasonGroup('Name15',4);
      SeasComment_Panel.Visible:=true;
      SeasComment_Memo.Visible:=true;
      SeasComment_Memo.Lines.Clear;
      SeasComment_Memo.Lines.Add ('   " - " = n.a.'     );
      SeasComment_Memo.Lines.Add ('The evaporation data');
      SeasComment_Memo.Lines.Add ('are only applicable' );
      SeasComment_Memo.Lines.Add ('if the area fraction');
      SeasComment_Memo.Lines.Add ('concerned is greater');
      SeasComment_Memo.Lines.Add (' than zero, see the' );
      SeasComment_Memo.Lines.Add ('area fractions data');
      ShowClimateTable;
    end else

    if SurfDrain_RadioButton.Checked then
    begin
      if SeasonsAdded and not AreasChecked then
      begin
        SeeAreasTableFirst;
        exit;
      end;
      Identity:='Surfdrain';
      if NoRead then NoRead:=false
      else ReadSeasonGroup('Name16',4);                  {surf. dr. data}
      SeasComment_Panel.Visible:=true;
      SeasComment_Memo.Visible:=true;
      SeasComment_Memo.Lines.Clear;
      SeasComment_Memo.Lines.Add ('    " - " = n.a.'    );
      SeasComment_Memo.Lines.Add ('Surface runoff data' );
      SeasComment_Memo.Lines.Add ('are only applicable' );
      SeasComment_Memo.Lines.Add ('if the area fraction');
      SeasComment_Memo.Lines.Add ('concerned is greater');
      SeasComment_Memo.Lines.Add ('than zero, see the'  );
      SeasComment_Memo.Lines.Add ('area fractions data' );
      ShowSurfDrainTable;
    end else

    if Irrigation_RadioButton.Checked then
    begin
      if SeasonsAdded and not AreasChecked then
      begin
        SeeAreasTableFirst;
        exit;
      end;
      Identity:='Irrigation';
      if NoRead then NoRead:=false
      else ReadSeasonGroup('Name19',4);                  {irrigation data}
      SeasComment_Panel.Visible:=true;
      SeasComment_Memo.Visible:=true;
      SeasComment_Memo.Lines.Clear;
      SeasComment_Memo.Lines.Add ('   " - " = n.a.'     );
      SeasComment_Memo.Lines.Add ( 'Field irrig. data'  );
      SeasComment_Memo.Lines.Add ('are only applicable' );
      SeasComment_Memo.Lines.Add ('if the area fraction');
      SeasComment_Memo.Lines.Add ('concerned is greater');
      SeasComment_Memo.Lines.Add (' than zero, see the' );
      SeasComment_Memo.Lines.Add ('area fractions data' );
      ShowIrrigationTable;
    end else

    if StorEff_RadioButton.Checked then
    begin
      if SeasonsAdded and not AreasChecked then
      begin
        SeeAreasTableFirst;
        exit;
      end;
      Identity:='Storeff';
      if NoRead then NoRead:=false
      else ReadSeasonGroup('Name07',3);                  {storage efficiency}
      SeasComment_Panel.Visible:=true;
      SeasComment_Memo.Visible:=true;
      SeasComment_Memo.Lines.Clear;
      SeasComment_Memo.Lines.Add ('   " - " = n.a.'     );
      SeasComment_Memo.Lines.Add ('Storage effic. data' );
      SeasComment_Memo.Lines.Add ('are only applicable' );
      SeasComment_Memo.Lines.Add ('if the area fraction');
      SeasComment_Memo.Lines.Add ('concerned is greater');
      SeasComment_Memo.Lines.Add (' than zero, see the' );
      SeasComment_Memo.Lines.Add ('area fractions data' );
      ShowStorEffTable;
    end else

    if Wells_RadioButton.Checked then
    begin
      if SeasonsAdded and not AreasChecked then
      begin
        SeeAreasTableFirst;
        exit;
      end;
      Identity:='Welldis';
      if NoRead then NoRead:=false
      else ReadSeasonGroup('Name17',2);        {well end drainage control data}
      SeasComment_Panel.Visible:=true;
      SeasComment_Memo.Visible:=true;
      SeasComment_Memo.Lines.Clear;
      SeasComment_Memo.Lines.Add ('   " - " = n.a.'     );
      SeasComment_Memo.Lines.Add ('The drainage control');
      SeasComment_Memo.Lines.Add (' is only applicable' );
      SeasComment_Memo.Lines.Add ('if a drainage system');
      SeasComment_Memo.Lines.Add ('is present, see agr.');
      SeasComment_Memo.Lines.Add ('  practices on the'  );
      SeasComment_Memo.Lines.Add (' polygonal tabsheet' );
      ShowWellDisTable;
    end else

    if Reuse_RadioButton.Checked then
    begin
      if SeasonsAdded and not AreasChecked then
      begin
        SeeAreasTableFirst;
        exit;
      end;
      Identity:='Reuse';
      if not NoRead then ReadSeasonGroup('Name17',2);     {pumping from wells}
      if NoRead then NoRead:=false
      else ReadSeasonGroup('Name20',2);          {well end drainage reuse data}
      SeasComment_Panel.Visible:=true;
      SeasComment_Memo.Visible:=true;
      SeasComment_Memo.Lines.Clear;
      SeasComment_Memo.Lines.Add ('   " - " = n.a.'     );
      SeasComment_Memo.Lines.Add ('The re-use data are' );
      SeasComment_Memo.Lines.Add ('required when well'  );
      SeasComment_Memo.Lines.Add (' pumping>0 resp. a'  );
      SeasComment_Memo.Lines.Add ('dr. syst. is present');
      SeasComment_Memo.Lines.Add ('See data previously ');
      SeasComment_Memo.Lines.Add ('    provided'        );
      ShowReUseTable;
    end else

    if ExternHead_RadioButton.Checked then
    begin
      Identity:='Exthead';
      if NoRead then NoRead:=false
      else ReadExternalGroup;                        {external hydraulic head}
      ShowExtHeadTable;
    end;

  end; {with DataMod do}
end; {TMainForm.SeasonButtonClick}
{--------------------------------}



procedure TMainForm.SeeAreasTableFirst;
{-------------------------------------}
begin
  Showmessage ('Please edit the irrigation area data first.');
  SeasComment_Memo.Lines.Add ('   " - " = n.a.'     );
  SeasComment_Memo.Lines.Add (' Rice crop indices'  );
  SeasComment_Memo.Lines.Add ('are only applicable' );
  SeasComment_Memo.Lines.Add ('if the corresponding');
  SeasComment_Memo.Lines.Add ('  area fraction is'  );
  SeasComment_Memo.Lines.Add (' greater than zero'  );
  SeasComment_Memo.Lines.Add ('');
  DataMod.ReadSeasonGroup('Name18',4);
  NoRead:=false;
  Identity:='Areas';
  ShowAreasTable;
end; {SeeAreasTableFirst}
{-----------------------}



procedure TMainForm.ShowExplainEdit3 (Sender: TObject);
{-----------------------------------------------------}
var MemoLine, MemoLine1, MemoLine2 : string;
begin Inherited;
  MemoLine := (Sender as TLabel).Hint;
  if length(MemoLine)>70 then
  begin
    MemoLine1 := copy(MemoLine,1,70);
    MemoLine2 := copy(MemoLine,71,length(MemoLine));
    SeasExplanation1_Edit.Visible := true;
    SeasExplanation1_Edit.Text := Memoline1;
    SeasExplanation2_Edit.Text := MemoLine2;
  end else
  begin
    SeasExplanation2_Edit.Text := MemoLine;
    SeasExplanation1_Edit.Visible := false;
  end;
end; {TMainForm.ShowExplainEdit3}
{-------------------------------}



procedure TMainForm.HideExplainEdit3(Sender: TObject);
{----------------------------------------------------}
begin Inherited;
    SeasExplanation2_Edit.Text := 'Move mouse over symbol to see explanation';
    SeasExplanation1_Edit.Visible := false;
end; {TMainForm.HideExplainEdit3}
{-------------------------------}



procedure TMainForm.SeasonGroupSave_ButtonClick(Sender: TObject);
{---------------------------------------------------------------}
var j: byte;
    TmpDuration : array[1..4] of real;
    ItIsOk, DataOK : boolean;
begin
  inherited;

  if Identity='Durations' then with DataMod do
  begin
    for j:=1 to NrOfSeasons {+ NrOfSeasonsAdded} do
        if (SeasonDuration[j]<1) or (SeasonDuration[j]>13-NrOfSeasons) then
        begin
          Showmessage ('The duration of the season ranges from 1 to '+
                         FloatToStr(13-DataMod.NrOfSeasons));
          Season_StringGrid.Cells[1,j]:=FloatToStr(TmpDuration[j]);
          SeasGroup_ButtonClick(Sender);
          exit;
        end;
    if DataMod.NrOfSeasonsAdded<>0 then
    begin
      PolygonalInput_Tabsheet.TabVisible:=true;
      SeasonalInput_Tabsheet.TabVisible:=true;
    end;
    CheckGeneralData(DataOK);
    if DataOk then
    begin
      SaveGeneralGroup(DataOK);
      if not DataOK then exit;
    end else
    begin
       for j:=1 to NrOfSeasons do
           Season_StringGrid.Cells[1,j]:=FloatToStr(TmpDuration[j]);
      SeasGroup_ButtonClick(Sender);
    end;
  end; {if Identity='Durations' then}

  if Identity='Areas' then
  begin
    Season_StringGrid.Visible:=false;
    DataMod.NrOfItems:=6;
    MakeSeasonValues (ItIsOk);
    if ItIsOK then CheckNegativeSeasonData ('Areas',ItIsOK);
    if ItIsOk then CheckAreaData (ItIsOK);
    if ItIsOK then
    begin
      DataMod.SaveSeasonGroup('Name18',4);
      if not AreaChange then
         Showmessage ('The crop area fraction group data were provisionally'+
                      ' checked and saved')
      else
      begin
        Showmessage ('The crop area fraction group data were checked'+
                     ' and saved. One or more areas were increased from'+
                     ' 0 up or the sum of A and B areas was decreased'+
                     ' from 1 down. Please check the seasonal climatic data.');
        AreasChecked:=true;
        CallFirst:=false;
        Climate_RadioButton.Checked:=true;
        SeasGroup_ButtonClick(Sender);
        exit;
      end;
    end else
    begin
      NoRead:=true;
      AreaChange:=true;
      DataMod.SaveSeasonGroup('Name18',4);
      DataMod.ReadSeasonGroup('Name18',4);
      Season_StringGrid.Visible:=true;
      SeasGroup_ButtonClick(Sender);
      exit;
    end;
  end; {if Identity='Areas' then}

  if Identity='Climate' then
  begin
    CallFirst:=true;
//CallFirst can be eliminated, it plays no role
    DataMod.NrOfitems:=6;
    MakeSeasonValues (ItIsOk);
    if ItIsOK then CheckNegativeSeasonData ('Climate',ItIsOK);
    if ItIsOK then
    begin
      if AreaChange or SeasonsAdded then
      begin
        if CallFirst then
        begin
          CheckNegativeSeasonData ('Climate',ItIsOK);
          if ItIsOK then
          begin
            DataMod.SaveSeasonGroup('Name15',4);
            Showmessage ('The climatic group data were checked and saved'+
                     '  One or more areas were increased from 0 up or'+
                     ' the sum of A and B areas was decreased from 1 down.'+
                     '  Please check the surface drainage data.');
            CallFirst:=false;
            SurfDrain_RadioButton.Checked:=true;
            SeasGroup_ButtonClick(Sender);
            exit;
          end else
          begin
            NoRead:=true;
            SeasGroup_ButtonClick(Sender);
            exit;
          end;
        end else
        begin
          CallFirst:=true;
          NoRead:=true;
          SeasGroup_ButtonClick(Sender);
          exit;
        end;
      end else
      begin
        DataMod.SaveSeasonGroup('Name15',4);
        if ResponsChange then
        begin
          CheckNegativeSeasonData ('Climate',ItIsOK);
          if ItIsOK then
          begin
            Showmessage ('The climatic group data were checked and saved'+
                         '  As the farmers response index was changed,'+
                       ' please check the surface drainage data.');
            SurfDrain_RadioButton.Checked:=true;
            SeasGroup_ButtonClick(Sender);
            NoRead:=false;
            exit;
          end else
          begin
            NoRead:=true;
            SeasGroup_ButtonClick(Sender);
            exit;
          end;
        end else
            Showmessage ('The climatic data group was provisionally'+
                         ' checked and saved');
      end;
    end else
    begin
      NoRead:=true;
      SeasGroup_ButtonClick(Sender);
      exit;
    end;
  end; {if Identity='Climate' then}

  if Identity='Surfdrain' then
  begin
    CallFirst:=true;
    DataMod.NrOfitems:=6;
    MakeSeasonValues (ItIsOk);
    if ItIsOK then CheckNegativeSeasonData ('Surfdrain',ItIsOK);
    if ItIsOK then
    begin
      if AreaChange or SeasonsAdded then
      begin
        if CallFirst then
        begin
          CheckNegativeSeasonData ('Surfdrain',ItIsOK);
          if ItIsOK then
          begin
            DataMod.SaveSeasonGroup('Name16',4);
            Showmessage ('The surface drainage data were checked and saved'+
                     '  One or more areas were increased from 0 up or'+
                     ' the sum of A and B areas was decreased from 1 down.'+
                     '  Please check the irrigation data.');
            CallFirst:=false;
            Irrigation_RadioButton.Checked:=true;
            SeasGroup_ButtonClick(Sender);
            exit;
          end else
          begin
            NoRead:=true;
            SeasGroup_ButtonClick(Sender);
            exit;
          end;
        end else
        begin
          CallFirst:=true;
          NoRead:=true;
          SeasGroup_ButtonClick(Sender);
          exit;
        end;
      end else
      begin
        DataMod.SaveSeasonGroup('Name16',4);
        if ResponsChange then
        begin
          CheckNegativeSeasonData ('Surfdrain',ItIsOK);
          if ItIsOK then
          begin
            Showmessage ('The surface drainage group data were checked and'+
                         ' saved.  As the farmers response index was changed,'+
                       ' please check the storage efficiency data.');
            Identity:='StorEff';
            StorEff_RadioButton.Checked:=true;
            NoRead:=false;
            SeasGroup_ButtonClick(Sender);
            exit;
          end else
          begin
            NoRead:=true;
            SeasGroup_ButtonClick(Sender);
            exit;
          end;
        end else
          Showmessage ('The surface drainage data group was provisionally'+
                       ' checked and saved');
      end;
    end else
    begin
      NoRead:=true;
      SeasGroup_ButtonClick(Sender);
      exit;
    end;
  end; {if Identity='Surfdrain' then}

  if Identity='Irrigation' then
  begin
    CallFirst:=true;
//CallFirst can be eliminated, it plays no role
    DataMod.NrOfitems:=6;
    MakeSeasonValues (ItIsOk);
    if ItIsOK then CheckNegativeSeasonData ('Irrigation',ItIsOK);
    if ItIsOK then
    begin
      if AreaChange or SeasonsAdded then
      begin
        if CallFirst then
        begin
          CheckNegativeSeasonData ('Irrigation',ItIsOK);
          if ItIsOK then
          begin
            DataMod.SaveSeasonGroup('Name19',4);
            Showmessage ('The irrigation data were checked and saved'+
                         '  One or more areas were increased from 0 up or'+
                         ' the sum of A and B areas was decreased from 1 down.'+
                         '  Please check the storage efficiency data.');
            CallFirst:=false;
            StorEff_RadioButton.Checked:=true;
            SeasGroup_ButtonClick(Sender);
            exit;
          end else
          begin
            NoRead:=true;
            SeasGroup_ButtonClick(Sender);
            exit;
          end;
        end else
        begin
          CallFirst:=true;
          NoRead:=true;
          SeasGroup_ButtonClick(Sender);
          exit;
        end;
      end else
      begin
        DataMod.SaveSeasonGroup('Name19',4);
        Showmessage ('The irrigation data group was provisionally checked'+
                     ' and saved');
      end;
    end else
    begin
      NoRead:=true;
      SeasGroup_ButtonClick(Sender);
      exit;
    end;
  end; {if Identity='Irrigation' then}

  if Identity='Storeff' then
  begin
    CallFirst:=true;
//CallFirst can be eliminated, it plays no role
    DataMod.NrOfitems:=6;
    MakeSeasonValues (ItIsOk);
    if ItIsOK then CheckNegativeSeasonData ('Storeff',ItIsOK);
    if ItIsOK then
    begin
      if AreaChange or SeasonsAdded then
      begin
        if CallFirst then
        begin
          CheckNegativeSeasonData ('Storeff',ItIsOK);
          if ItIsOK then
          begin
            DataMod.SaveSeasonGroup('Name07',3);
            Showmessage ('The storage efficiency data were checked and saved.');
//            CallFirst:=false;
            Wells_RadioButton.Checked:=true;
//            SeasGroup_ButtonClick(Sender);
//            exit;
          end else
          begin
            NoRead:=true;
            SeasGroup_ButtonClick(Sender);
            exit;
          end;
        end else
        begin
          CallFirst:=true;
          NoRead:=true;
          SeasGroup_ButtonClick(Sender);
          exit;
        end;
        AreaChange:=false;
        SeasonsAdded:=false;
      end  {if AreaChange or SeasonsAdded then}
      else
      begin
        DataMod.SaveSeasonGroup('Name07',3);
        if ResponsChange then
        begin
          CheckNegativeSeasonData ('Storeff',ItIsOK);
          if ItIsOK then
          begin
            Showmessage ('The storage efficiency data group was checked and'+
                         ' saved');
            ResponsChange:=false;
            NoRead:=true;
            Wells_RadioButton.Checked:=true;
          end else
          begin
            NoRead:=false;
            SeasGroup_ButtonClick(Sender);
            exit;
          end;
        end else
            Showmessage ('The storage efficiency data group was provisionally'+
                         ' cecked and saved');
      end;
    end else
    begin
      NoRead:=true;
      SeasGroup_ButtonClick(Sender);
      exit;
    end;
  end; {if Identity='Storeff' then}

  if Identity='Welldis' then
  begin
    DataMod.NrOfitems:=4;
    MakeSeasonValues (ItIsOk);
    if ItIsOK then
    begin
      DataMod.SaveSeasonGroup('Name17',2);
      if DrainChange or NrOfSeasonsChange then
      begin
        Showmessage (' The data on well discharge and drainage control were'+
                     ' checked and saved. If you have changed the drainage'+
                     ' index, please check the drainage reuse data.');
        CallFirst:=false;
        NrOfSeasonsChange:=true;
        Reuse_RadioButton.Checked:=true;
        SeasGroup_ButtonClick(Sender);
        exit;
      end
      else
        Showmessage ('The data on well discharge and drainage control were'+
                     ' checked and saved. If the well discharge data were'+
                     ' changed, check also the reuse table.');
    end else
    begin
      NoRead:=true;
      SeasGroup_ButtonClick(Sender);
      exit;
    end;
  end; {if Identity='Welldis' then}

  if Identity='Reuse' then
  begin
    DataMod.NrOfitems:=4;
    MakeSeasonValues (ItIsOk);
    CheckReuseData (ItIsOK);
    if ItIsOK then
    begin
      DataMod.SaveSeasonGroup('Name20',2);
      Showmessage (' The data on reuse of drainage and well water were'+
                   ' provisionally checked and saved.');
      CallFirst:=false;
      if DrainChange then
      begin
        NoRead:=false;
        DrainChange:=false;
        if not ResponsChange then
        begin
          PolygonalInput_Tabsheet.Show;
          exit;
        end;
      end;
      if ResponsChange then
      begin
        NoRead:=false;;
        Agricult_RadioButton.Checked:=true;
        PolygonalInput_Tabsheet.Show;
        PolyGroup_ButtonClick (Sender);
        exit;
      end;
      Reuse_RadioButton.Checked:=true;
      SeasGroup_ButtonClick(Sender);
    end else
    begin
      NoRead:=true;
      SeasGroup_ButtonClick(Sender);
      exit;
    end;

  end; {if Identity='Reuse' then}

  if Identity='Exthead' then
  begin
    DataMod.NrOfitems:=DataMod.NrOfSeasons;
    MakePolyValues (ItIsOk);
    CheckExtHeadData (ItIsOK);
    if ItIsOK then
    begin
      DataMod.SaveExternalGroup;
      Showmessage ('The external boundary head conditions were checked and'+
                   ' saved');
    end else
    begin
      NoRead:=true;
      SeasGroup_ButtonClick(Sender);
      exit;
    end;
  end;

  SetSeasonComponents('ToGroupSelection');

end;{TMainForm.SeasonGroupSave_ButtonClick}
{-----------------------------------------}




procedure TMainForm.SeasGroupCancel_ButtonClick(Sender: TObject);
{------------------------------------------------------------}
begin
  inherited;
  Showmessage ('The group data were not saved');
  SetSeasonComponents('ToGroupSelection');
end; {TMainForm.Cancel_Button3Click}
{----------------------------------}


{******************************************************************************
 SeasonalInput_TabSheet, private section
******************************************************************************}


procedure TMainForm.InitialAreaSettings;
{--------------------------------------}
var Number : byte;
begin
  with DataMod do
  begin
    ReadGeneralGroup;                         {for nr. of polygons & seasons}
    Number:=NrOfSeasons;
//    if (NrOfSeasonsAdded<>0) then
//        NrOfSeasons:=InitNrOfSeasons;
    if DataMod.NrOfSeasonsAdded<>0 then SeasonsAdded:=true;
    if DataMod.NrOfSeasonsAdded=0 then SeasonsAdded:=false;
    ReadPolyGroup('Name08',4);                    {for response index}
    ReadSeasonGroup('Name18',4);                  {for irrigated areas}
    SaveSeasonGroup('Name18',4);
    ReadSeasonGroup('Name15',4);                  {for evaporation data}
    SaveSeasonGroup('Name15',4);
    ReadSeasonGroup('Name16',4);                  {for surface drainage}
    SaveSeasonGroup('Name16',4);
    ReadSeasonGroup('Name19',4);                  {for seasonal irrigation}
    SaveSeasonGroup('Name19',4);
    ReadSeasonGroup('Name07',4);                  {for storage efficiency}
    SaveSeasonGroup('Name07',4);
    NrOfSeasons:=Number;
  end;
end; {TMainForm.InitialAreaSettings}
{----------------------------------}


procedure TMainForm.ShowAreasTable;
{---------------------------------}
var Count, i,j,k : integer;
begin
  with DataMod do
  begin
    SetSeasonComponents('ToGroupEditing');
    NrOfItems:=6;
    SetSeasonStringGridStandards ('Int');
    SeasonHeaderLabel[1].Caption:='  Node nr  ';
    SeasonHeaderLabel[2].Caption:='  Season   ';
    SeasonHeaderLabel[3].Caption:='  Area A   ';
    SeasonHeaderLabel[4].Caption:='  Area B   ';
    SeasonHeaderLabel[5].Caption:='  Rice A   ';
    SeasonHeaderLabel[6].Caption:='  Rice B   ';
    SeasonHeaderLabel[1].Hint:='Identification number of internal polygon';
    SeasonHeaderLabel[2].Hint:='Season number depending on the number of'+
                               ' seasons per year, see generaldata';
    SeasonHeaderLabel[3].Hint:='Irrigated area fraction under group A crops'+
                               ' 0 < A < 1,  0 < A+B < 1';
    SeasonHeaderLabel[4].Hint:='Irrigated area fraction under group B crops'+
                               ' 0 < B < 1,  0 < A+B < 1';
    SeasonHeaderLabel[5].Hint:='Rice cropping index A: whether the group A'+
                               ' crop is submerged rice     (paddy).'+
                               '  1 = Yes,  0 = No';
    SeasonHeaderLabel[6].Hint:='Rice cropping index B: whether the group B'+
                               ' crop is submerged rice     (paddy).'+
                               '  1 = Yes,  0 = No';
    Season_StringGrid.Cells[0,0]:='  -   ';
    Season_StringGrid.Cells[1,0]:=' number ';
    Season_StringGrid.Cells[2,0]:='fraction';
    Season_StringGrid.Cells[3,0]:='fraction';
    Season_StringGrid.Cells[4,0]:='  -   ';
    Season_StringGrid.Cells[5,0]:='  -   ';
    for i:=1 to NrOfItems-2 do
    begin
      Count:=0;
      for k:=0 to NrOfIntPoly-1 do for j:=1 to NrOfSeasons do
      begin
        Count:=Count+1;
        Season_StringGrid.Cells[1,Count]:= IntToStr(j);
        if j=1 then
           Season_StringGrid.Cells[0,Count]:= IntToStr(NodeNr[k])
        else
           Season_StringGrid.Cells[0,Count]:=' ';
        if (i=1) or (i=2) then
           Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k]);
        if i=3 then
        begin
          if AreaA[j,k]>0 then
            Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
            Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
        if i=4 then
        begin
          if AreaB[j,k]>0 then
            Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
            Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
      end;
    end;
  end; {with DataMod do}
  Season_StringGrid.Visible:=true;
end; {TMainForm.ShowAreasTable}
{-----------------------------}



procedure TMainForm.ShowClimateTable;
{-----------------------------------}
var Count, i,j,k : integer;
begin
  with DataMod do
  begin
    SetSeasonComponents('ToGroupEditing');
    NrOfItems:=6;
    SetSeasonStringGridStandards('Int');
    SeasonHeaderLabel[1].Caption:='  Node nr  ';
    SeasonHeaderLabel[2].Caption:='  Season   ';
    SeasonHeaderLabel[3].Caption:='  Rain     ';
    SeasonHeaderLabel[4].Caption:='  EpA      ';
    SeasonHeaderLabel[5].Caption:='  EpB      ';
    SeasonHeaderLabel[6].Caption:='  EpU      ';
    SeasonHeaderLabel[1].Hint:='Identification number of internal polygon';
    SeasonHeaderLabel[2].Hint:='Season number depending on the number of'+
                               ' seasons per year, see general data';
    SeasonHeaderLabel[3].Hint:='Seasonal rainfall/precipitation, m/season';
    SeasonHeaderLabel[4].Hint:='Seasonal potential evapotranspiration from'+
                               ' the land under group A     crops,  m3/season'+
                               ' per m2 A area';
    SeasonHeaderLabel[5].Hint:='Seasonal potential evapotranspiration from'+
                               ' the land under group B     crops,  m3/season'+
                               ' per m2 B land';
    SeasonHeaderLabel[6].Hint:='Seasonal potential evapotranspiration from'+
                               ' the fallow or unirrigated Uland,  m3/season'+
                               ' per m2 U area';
    Season_StringGrid.Cells[0,0]:='  -   ';
    Season_StringGrid.Cells[1,0]:=' number ';
    Season_StringGrid.Cells[2,0]:='m/season';
    Season_StringGrid.Cells[3,0]:='m/season';
    Season_StringGrid.Cells[4,0]:='m/season';
    Season_StringGrid.Cells[5,0]:='m/season';
    for i:=1 to NrOfItems-2 do
    begin
      Count:=0;
      for k:=0 to NrOfIntPoly-1 do for j:=1 to NrOfSeasons do
      begin
        Count:=Count+1;
        Season_StringGrid.Cells[1,Count]:= IntToStr(j);
        if j=1 then
           Season_StringGrid.Cells[0,Count]:= IntToStr(NodeNr[k])
        else
           Season_StringGrid.Cells[0,Count]:=' ';
        if i=1 then
           Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k]);
        if i=2 then
        begin
          if AreaA[j,k]>0 then
             Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
             Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
        if i=3 then
        begin
          if AreaB[j,k]>0 then
             Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
             Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
        if i=4 then
        begin
          if (AreaA[j,k]+AreaB[j,k]<1) or (ResponsIndex[k]>0) then
             Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
             Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
      end;
    end;
  end; {with DataMod do}
  Season_StringGrid.Visible:=true;
end; {TMainForm.ShowClimateTable}
{-------------------------------}



procedure TMainForm.ShowSurfDrainTable;
{-------------------------------------}
var Count, i,j,k : integer;
begin
  with DataMod do
  begin
    SetSeasonComponents('ToGroupEditing');
    NrOfItems:=6;
    SetSeasonStringGridStandards('Int');
    SeasonHeaderLabel[1].Caption:='  Node nr  ';
    SeasonHeaderLabel[2].Caption:='  Season   ';
    SeasonHeaderLabel[3].Caption:='  SiU      ';
    SeasonHeaderLabel[4].Caption:='  SoU      ';
    SeasonHeaderLabel[5].Caption:='  SdA      ';
    SeasonHeaderLabel[6].Caption:='  SdB      ';
    SeasonHeaderLabel[1].Hint:='Identification number of internal polygon';
    SeasonHeaderLabel[2].Hint:='Season number depending on the number of'+
                               ' seasons per year, see general data';
    SeasonHeaderLabel[3].Hint:='Seasonal surface inflow into the fallow or'+
                               ' unirrigated U land,        m3/season per m2'+
                               ' U area';
    SeasonHeaderLabel[4].Hint:='Seasonal surface outflow (runoff) from the'+
                               ' fallow or unirrigated U    land,  m3/season'+
                               ' per m2 U area';
    SeasonHeaderLabel[5].Hint:='Seasonal surface drainage from the irrigated'+
                               ' land under group A crops, m3/season per'+
                               ' m2 A area';
    SeasonHeaderLabel[6].Hint:='Seasonal surface drainage from the irrigated'+
                               ' land under group B crops, m3/season per'+
                               ' m2 B area';
    Season_StringGrid.Cells[0,0]:='  -   ';
    Season_StringGrid.Cells[1,0]:=' number ';
    Season_StringGrid.Cells[2,0]:='m/season';
    Season_StringGrid.Cells[3,0]:='m/season';
    Season_StringGrid.Cells[4,0]:='m/season';
    Season_StringGrid.Cells[5,0]:='m/season';
    for i:=1 to NrOfItems-2 do
    begin
      Count:=0;
      for k:=0 to NrOfIntPoly-1 do for j:=1 to NrOfSeasons do
      begin
        Count:=Count+1;
        Season_StringGrid.Cells[1,Count]:= IntToStr(j);
        if j=1 then
           Season_StringGrid.Cells[0,Count]:= IntToStr(NodeNr[k])
        else
           Season_StringGrid.Cells[0,Count]:=' ';
        if (i=1) or (i=2) then
        begin
          if (AreaA[j,k]+AreaB[j,k]<1) or (ResponsIndex[k]>0) then
             Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
             Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
        if i=3 then
        begin
          if AreaA[j,k]>0 then
             Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
            Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
        if i=4 then
        begin
          if AreaB[j,k]>0 then
             Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
             Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
      end;
    end;
  end; {with DataMod do}
  Season_StringGrid.Visible:=true;
end; {TMainForm.ShowSurfDrainTable}
{---------------------------------}



procedure TMainForm.ShowIrrigationTable;
{--------------------------------------}
var Count, i,j,k : integer;
begin
  with DataMod do
  begin
    SetSeasonComponents('ToGroupEditing');
    NrOfItems:=6;
    SetSeasonStringGridStandards('Int');
    SeasonHeaderLabel[1].Caption:='  Node nr  ';
    SeasonHeaderLabel[2].Caption:='  Season   ';
    SeasonHeaderLabel[3].Caption:='  Lc       ';
    SeasonHeaderLabel[4].Caption:='  Ci       ';
    SeasonHeaderLabel[5].Caption:='  IaA      ';
    SeasonHeaderLabel[6].Caption:='  IaB      ';
    SeasonHeaderLabel[1].Hint:='Identification number of internal polygon';
    SeasonHeaderLabel[2].Hint:='Season number depending on the number of'+
                               ' seasons per year, see general data';
    SeasonHeaderLabel[3].Hint:='Deep percolation losses from the irrigation'+
                               ' canal system (leakage) to the underground,'+
                               '  m3/season per m2 total area';
    SeasonHeaderLabel[4].Hint:='Salt concentration of the irrigation water';
    SeasonHeaderLabel[5].Hint:='Seasonal field irrigation application to the'+
                               ' land under group A crops m3/season per'+
                               ' m2 A area, excluding reused drain and well water';
    SeasonHeaderLabel[6].Hint:='Seasonal field irrigation application to the'+
                               ' land under group B crops m3/season per'+
                               ' m2 B area, excluding reused drain and well water';
    Season_StringGrid.Cells[0,0]:='  -   ';
    Season_StringGrid.Cells[1,0]:=' number ';
    Season_StringGrid.Cells[2,0]:='m/season';
    Season_StringGrid.Cells[3,0]:=' dS/m   ';
    Season_StringGrid.Cells[4,0]:='m/season';
    Season_StringGrid.Cells[5,0]:='m/season';
    for i:=1 to NrOfItems-2 do
    begin
      Count:=0;
      for k:=0 to NrOfIntPoly-1 do for j:=1 to NrOfSeasons do
      begin
        Count:=Count+1;
        Season_StringGrid.Cells[1,Count]:= IntToStr(j);
        if j=1 then
           Season_StringGrid.Cells[0,Count]:= IntToStr(NodeNr[k])
        else
           Season_StringGrid.Cells[0,Count]:=' ';
        if (i=1) or (i=2) then
           if (AreaA[j,k]+AreaB[j,k])>0 then
             Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
           else
             Season_StringGrid.Cells[i+1,Count]:=' -';
        if i=3 then
        begin
          if AreaA[j,k]>0 then
            Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
            Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
        if i=4 then
        begin
          if AreaB[j,k]>0 then
            Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
            Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
      end;
    end;
  end; {with DataMod do}
  Season_StringGrid.Visible:=true;
end; {TMainForm.ShowIrrigationTable}
{----------------------------------}



procedure TMainForm.ShowStorEffTable;
{-----------------------------------}
var Count, i,j,k : integer;
begin
  with DataMod do
  begin
    SetSeasonComponents('ToGroupEditing');
    NrOfItems:=5;
    SetSeasonStringGridStandards('Int');
    SeasonHeaderLabel[1].Caption:='  Node nr  ';
    SeasonHeaderLabel[2].Caption:='  Season   ';
    SeasonHeaderLabel[3].Caption:='  FsA      ';
    SeasonHeaderLabel[4].Caption:='  FsB      ';
    SeasonHeaderLabel[5].Caption:='  FsU      ';
    SeasonHeaderLabel[1].Hint:='Identification number of internal polygon';
    SeasonHeaderLabel[2].Hint:='Season number depending on the number of'+
                               ' seasons per year, see general data';
    SeasonHeaderLabel[3].Hint:='Storage efficiency of water in the root'+
                               ' zone of the irrigated land    under A group'+
                               ' crops, 0<FsA<1';
    SeasonHeaderLabel[4].Hint:='Storage efficiency of water in the root'+
                               ' zone of the irrigated land    under B group'+
                               ' crops, 0<FsB<1';
    SeasonHeaderLabel[5].Hint:='Storage efficiency of water in the root'+
                               ' zone of unirrigated or fallow U land,'+
                               '  0<FsU<1';
    Season_StringGrid.Cells[0,0]:='  -   ';
    Season_StringGrid.Cells[1,0]:=' number ';
    Season_StringGrid.Cells[2,0]:='fraction';
    Season_StringGrid.Cells[3,0]:='fraction';
    Season_StringGrid.Cells[4,0]:='fraction';
    for i:=1 to NrOfItems-2 do
    begin
      Count:=0;
      for k:=0 to NrOfIntPoly-1 do  for j:=1 to NrOfSeasons do
      begin
        Count:=Count+1;
        Season_StringGrid.Cells[1,Count]:= IntToStr(j);
        if j=1 then
           Season_StringGrid.Cells[0,Count]:= IntToStr(NodeNr[k])
        else
           Season_StringGrid.Cells[0,Count]:=' ';
        if i=1 then
        begin
          if AreaA[j,k]>0 then
            Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
            Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
        if i=2 then
        begin
          if AreaB[j,k]>0 then
            Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
            Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
        if i=3 then
        begin
          if (AreaA[j,k]+AreaB[j,k]<1) or (ResponsIndex[k]>0) then
             Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
             Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
     end;
    end;
  end; {with DataMod do}
  Season_StringGrid.Visible:=true;
end; {TMainForm.ShowStorEffTable}
{-------------------------------}



procedure TMainForm.ShowWellDisTable;
{-----------------------------------}
var Count, i,j,k : integer;
begin
  with DataMod do
  begin
    SetSeasonComponents('ToGroupEditing');
    NrOfItems:=4;
    SetSeasonStringGridStandards('Int');
    SeasonHeaderLabel[1].Caption:='  Node nr  ';
    SeasonHeaderLabel[2].Caption:='  Season   ';
    SeasonHeaderLabel[3].Caption:='  Gw       ';
    SeasonHeaderLabel[4].Caption:='  Frd      ';
    SeasonHeaderLabel[1].Hint:='Identification number of internal polygon';
    SeasonHeaderLabel[2].Hint:='Season number depending on the number of'+
                               ' seasons per year, see general data';
    SeasonHeaderLabel[3].Hint:='Pumpage from wells tapping the aquifer,'+
                               ' m3/season per m2 total area';
    SeasonHeaderLabel[4].Hint:='Drainage reduction factor to check excessive'+
                               ' drainage (0<Frd<1).      Frd=0 : no'+
                               ' reduction,  Frd=1 : 100% restricted';
    Season_StringGrid.Cells[0,0]:='  -   ';
    Season_StringGrid.Cells[1,0]:=' number ';
    Season_StringGrid.Cells[2,0]:='m/season';
    Season_StringGrid.Cells[3,0]:='fraction';
    for i:=1 to NrOfItems-2 do
    begin
      Count:=0;
      for k:=0 to NrOfIntPoly-1 do for j:=1 to NrOfSeasons do
      begin
        Count:=Count+1;
        Season_StringGrid.Cells[1,Count]:= IntToStr(j);
        if j=1 then
           Season_StringGrid.Cells[0,Count]:= IntToStr(NodeNr[k])
        else
           Season_StringGrid.Cells[0,Count]:=' ';
        if i=1 then
           Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k]);
        if i=2 then
        begin
          if DrainIndex[k]>0 then
            Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
            Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
      end;
    end;
  end; {with DataMod do}
  Season_StringGrid.Visible:=true;
end; {TMainForm.ShowWellDisTable}
{-------------------------------}



procedure TMainForm.ShowReUseTable;
{---------------------------------}
var Count, i,j,k : integer;
begin
  with DataMod do
  begin
    SetSeasonComponents('ToGroupEditing');
    NrOfItems:=4;
    SetSeasonStringGridStandards('Int');
    SeasonHeaderLabel[1].Caption:='  Node nr  ';
    SeasonHeaderLabel[2].Caption:='  Season   ';
    SeasonHeaderLabel[3].Caption:='  Gu       ';
    SeasonHeaderLabel[4].Caption:='  Fw       ';
    SeasonHeaderLabel[1].Hint:='Identification number of internal polygon';
    SeasonHeaderLabel[2].Hint:='Season number depending on the number of'+
                               ' seasons per year, see general data';
    SeasonHeaderLabel[3].Hint:='Gu: Subsurface drainage'+
                         ' water used for irrigation (m3/season per m2 total'+
                         ' area).  At first, use first Gu=0 to judge the the'+
                         ' amount available.';
    SeasonHeaderLabel[4].Hint:='Fw: Seasonal fraction of pumped well water'+
                         ' (Gw) used for irrigation.  (0 < Fw < 1).  Only'+
                         ' applicable to nodes with Gw > 0';
    Season_StringGrid.Cells[0,0]:='  -   ';
    Season_StringGrid.Cells[1,0]:=' number ';
    Season_StringGrid.Cells[2,0]:='m/season';
    Season_StringGrid.Cells[3,0]:='fraction';
    for i:=1 to NrOfItems-2 do
    begin
      Count:=0;
      for k:=0 to NrOfIntPoly-1 do for j:=1 to NrOfSeasons do
      begin
        Count:=Count+1;
        Season_StringGrid.Cells[1,Count]:= IntToStr(j);
        if j=1 then
           Season_StringGrid.Cells[0,Count]:= IntToStr(NodeNr[k])
        else
           Season_StringGrid.Cells[0,Count]:=' ';
        if i=1 then
        begin
          if DrainIndex[k]>0 then
             Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
             Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
        if i=2 then
        begin
          if Pumpage[j,k]>0 then
            Season_StringGrid.Cells[i+1,Count]:=FloatToStr(AuxValue[i,j,k])
          else
            Season_StringGrid.Cells[i+1,Count]:=' -';
        end;
      end;
    end; {for i:=1 to NrOfItems-2 do}
  end; {with DataMod do}
  Season_StringGrid.Visible:=true;
end; {TMainForm.ShowReUseTable}
{-----------------------------}



procedure TMainForm.ShowExtHeadTable;
{-----------------------------------}
var Count, j, k : integer;
begin
  with DataMod do
  begin
    SetSeasonComponents('ToGroupEditing');
    NrOfItems:=3;
    SetSeasonStringGridStandards('Ext');
    SeasonHeaderLabel[1].Caption:='  Node nr  ';
    SeasonHeaderLabel[2].Caption:='  Season   ';
    SeasonHeaderLabel[3].Caption:='  Hw       ';
    SeasonHeaderLabel[1].Hint:='Identification number of internal polygon';
    SeasonHeaderLabel[2].Hint:='Season number depending on the number of'+
                               ' seasons per year, see generaldata';
    SeasonHeaderLabel[3].Hint:='Level of the water table in the external'+
                         ' polygons, boundary condition (m above reference'+
                         ' level)';
    Season_StringGrid.Cells[0,0]:='  -   ';
    Season_StringGrid.Cells[1,0]:=' number ';
    Season_StringGrid.Cells[2,0]:='  m';
    Season_StringGrid.Cells[3,0]:='fraction';
    Count:=0;
    for k:=0 to NrOfExtPoly-1 do for j:=1 to NrOfSeasons do
    begin
      Count:=Count+1;
      if j=1 then
         Season_StringGrid.Cells[0,Count]:= IntToStr(NodeNr[k+NrOfIntPoly])
      else
         Season_StringGrid.Cells[0,Count]:=' ';
      Season_StringGrid.Cells[1,Count]:= IntToStr(j);
      Season_StringGrid.Cells[2,Count]:=FloatToStr(HlpValue[1+j,k])
    end;{for k:=0 to NrOfIntPoly-1 do}
  end; {with DataMod do}
  Season_StringGrid.Visible:=true;
end; {TMainForm.ShowExtHeadTable}
{-------------------------------}



procedure TMainForm.SetSeasonStringGridStandards (const Job : string);
{--------------------------------------------------------------------}
var j, NrOfPoly : integer;
begin
  Season_StringGrid.Visible:=false;
  SeasonHeader_Panel.Visible:=true;
  SeasonHeader_Panel.Width:=7+60*DataMod.NrOfItems;
  for j:=1 to DataMod.NrOfItems do
  begin
    SeasonHeaderLabel[j]:=Tlabel.Create(self);
    SeasonHeaderLabel[j].Parent:=SeasonHeader_Panel;
    SeasonHeaderLabel[j].Top:=3;
    SeasonHeaderLabel[j].Width:=60;
    SeasonHeaderLabel[j].Height:=30;
    if j=1 then SeasonHeaderLabel[j].Left:=4
    else SeasonHeaderLabel[j].Left:=SeasonHeaderLabel[j-1].Left+60;
    SeasonHeaderLabel[j].OnMouseEnter := ShowExplainEdit3;
    SeasonHeaderLabel[j].OnMouseLeave := HideExplainEdit3;
  end;
  Season_StringGrid.DefaultColWidth:=60;
  Season_StringGrid.DefaultRowHeight:=20;
  NrOfPoly:=DataMod.NrOfIntPoly;
  if Job='Ext' then NrOfPoly:=DataMod.NrOfExtPoly;
  Season_StringGrid.RowCount:=1+(NrOfPoly*DataMod.NrOfSeasons);
  Season_StringGrid.ColCount:=DataMod.NrOfItems;
  Season_StringGrid.Width:=12+60*DataMod.NrOfItems;
  Season_StringGrid.Height:=20+20*(NrOfPoly*DataMod.NrOfSeasons+1);
  if Season_StringGrid.Height>303 then
  begin
    Season_StringGrid.Width:=27+60*DataMod.NrOfItems;
    Season_StringGrid.Height:=303;
  end;
  Season_StringGrid.FixedCols:=2;
  Season_StringGrid.FixedRows:=1;
  HideExplainEdit3(Sender);
end; {TMainForm.SetSeason_StringGridStandards}
{-------------------------------------------}



procedure TMainForm.SetSeasonComponents (const Switch : string);
{--------------------------------------------------------------}
begin
  SeasonalInput_Tabsheet.TabVisible:=true;

  if Switch='ToGroupSelection' then
  begin
    GeneralInput_Tabsheet.TabVisible:=true;
    PolygonalInput_Tabsheet.TabVisible:=true;
    Output_Tabsheet.TabVisible:=true;
    Graphics_Tabsheet.TabVisible:=true;
    Intro_Tabsheet.TabVisible:=true;
    Figure_Tabsheet.TabVisible:=true;
    SeasGroup_Panel.Visible:=true;
    DurationPanel.Visible:=true;
    SeasPanelCancel_Button.Visible:=true;
    SeasonHeader_Panel.Visible:=false;
    SeasExplanation1_Label.Visible:=false;
    SeasExplanation2_Label.Visible:=false;
    SeasExplanation2_Edit.Visible:=false;
    SeasExplanation1_Edit.Visible:=false;
    SeasonCol_Panel.Visible:=false;
    SeasComment_Panel.Visible:=false;
    Season_StringGrid.Visible:=false;
    SeasComment_Panel.Visible:=false;
    SeasGroupCancel_Button.Enabled:=false;
    SeasInputSymbols_Button.Enabled:=false;
    SeasonGroupSave_Button.Enabled:=false;
    StatusText ('Select the data group to be edited. To save all data or'+
                ' perform calculations use "Save/calculate" on the'+
                ' General Input tabsheet');
  end;

  if Switch='ToGroupEditing' then
  begin
    GeneralInput_Tabsheet.TabVisible:=false;
    PolygonalInput_Tabsheet.TabVisible:=false;
    Output_Tabsheet.TabVisible:=false;
    Graphics_Tabsheet.TabVisible:=false;
    Intro_Tabsheet.TabVisible:=false;
    Figure_Tabsheet.TabVisible:=false;
    SeasGroup_Panel.Visible:=false;
    DurationPanel.Visible:=false;
    SeasPanelCancel_Button.Visible:=false;
    SeasInputSymbols_Button.Enabled:=true;
    SeasonGroupSave_Button.Enabled:=true;
    SeasGroupCancel_Button.Enabled:=true;
    SeasonHeader_Panel.Visible:=true;
    SeasExplanation1_Label.Visible:=true;
    SeasonCol_Panel.Visible:=true;
    SeasExplanation2_Label.Visible:=true;
    SeasExplanation1_Edit.Visible:=false;
    SeasExplanation2_Edit.Visible:=true;
    StatusText ('Use "Save group" to save the group data.');
  end;
end; {TMainForm.SetSeasonComponents}
{----------------------------------}



procedure TMainForm.MakeSeasonValues (var DataOK : boolean);
{----------------------------------------------------------}
var Count, i, j, k :integer;
begin
  DataOK:=false;
  with DataMod do
  begin
    for i:=2 to NrOfItems-1 do
    begin
      for j:=1 to NrOfSeasons do
      begin
        Count:=j-NrOfSeasons;
        for k:=0 to NrOfIntPoly-1 do
        begin
          Count:=Count+NrOfSeasons;
          Try
            if (Season_StringGrid.Cells[i,Count]<>' -')
            and (Season_StringGrid.Cells[i,Count]<>'') then
               AuxValue[i-1,j,k]:=StringToFloat(Season_StringGrid.Cells[i,Count]);
            Except on E: exception do
            begin
              Showmessage ('The seesonal data contain invalid values');
              DecimalSeparator:=InitDecSep;
              exit;
            end;
          end;
        end;
      end;
    end;
  end; {with DataMod do}
  DataOK:=true;
end; {TMainForm.MakeSeasonValues}
{-------------------------------}



{******************************************************************************
 End of SeasonalInput_Tabsheet, start of Output_TabSheet
 ******************************************************************************}


procedure TMainForm.Output_TabSheetShow(Sender: TObject);
{-------------------------------------------------------}
var TextLine : string;
    i : integer;
begin Inherited;
      StatusText (' Use "Select data for graphs" for the graphics menu, or'+
                  ' use "Open output" to retrieve an other output file.');
      GraphOpened := false;
      OutputSelection_Button.Enabled := true;
      if not OutputOpened then
      begin
        StatusText ('The output file can be inspected. Use "Open output"' +
                    ' to inspect any other output file or to see examples' +
                    ' in any folder.');
        OutputSymbols_Button.Enabled := false;
        OutputSelection_Button.Enabled := false;
        GotoInput_Button.Enabled:=false;                        {necessary ???}
        SeeGraph_Button.Enabled:=false;
        SaveGroup_Button.Enabled:=false;
        GotoInput_Button.Enabled:=false;
        Select_Button.Visible:=false;
        MainSelection_Panel.Hide;
        if not RunTimeError then
        begin
          Output_Memo.Visible:= false;
          OutputSalt_Image.Visible := true;
        end;
      end;
      if GroupOpened then
      begin
        OutputSymbols_Button.Enabled := true;
        GotoInput_Button.Enabled:=true;
        SeeGraph_Button.Enabled:=true;
        SaveGroup_Button.Enabled:=true;
        OutputSelection_Button.Enabled:=false;
      end;
      if CalcDone then with DataMod do
      begin
        OutputFileName := ChangeFileExt (SaveFileName,'.out');
        if AnnualCalc then
           OutputFileName := ChangeFileExt (OriginalName,'.out');
        chdir (InitDir);
        if fileexists ('error.lst') then deletefile ('error.lst');
        if fileexists ('accuracy.err') then deletefile ('accuracy.err');
        chdir (DataDir);
        if RunTimeError then
        begin
          Output_Memo.Lines.Clear;
          for i:=0 to NrOfErrorLines-1 do Output_Memo.Lines.Add(ErrorLines[i]);
          Output_Memo.Lines.Add('');
          Output_Memo.Lines.Add (' CALCULATIONS COULD NOT BE DONE');
          Output_Memo.Lines.Add (' Please correct the input');
          setlength (ErrorLines,1);
          if fileexists (OutputFileName) then deletefile (OutputFileName);
          chdir (InitDir);
          CalcDone:=false;
          RunTimeError:=false;
          GoToInput_Button.enabled :=false;                     {necessary ??}
          OutputSymbols_Button.Enabled := false;
        end else {RunTimeError=false}
        begin
          if AccErr then
          begin
            Output_Memo.Lines.Clear;
            for i:=0 to NrOfErrorLines-1 do
                Output_Memo.Lines.Add(ErrorLines[i]);
            Output_Memo.Lines.Add('');
            Output_Memo.Lines.Add (' CALCULATIONS COULD NOT BE DONE');
            setlength (ErrorLines,1);
            if fileexists (OutputFileName) then deletefile (OutputFileName);
            chdir (InitDir);
            CalcDone:=false;
            AccErr:=false;
            GoToInput_Button.Enabled :=false;                 {necessary ???}
            OutputSymbols_Button.Enabled := false;
          end else {AccErr=false}
          if not ColorMap then
          begin
            chdir (DataDir);                              // nodig? necessary ?
            assignfile (OutFile,OutputFileName);
            reset (OutFile);
            Output_Memo.Visible:=false;
            progressbar1.Position:=90;
            sleep (500);
            FillOutputWaitMemo;
            Output_Memo.Lines.Clear;
            i:=0;
            while not eof (OutFile) do
            begin
              readln (OutFile,TextLine);
              Output_Memo.Lines.Add(TextLine);
              i:=i+1;
              if i=20000 then
                 OutputWait_Memo.Lines.Add(' Still loading .....');
              if i=50000 then
                 OutputWait_Memo.Lines.Add(' Many data .........');
              if i=100000 then
                 OutputWait_Memo.Lines.Add(' Very big file .....');
              if i=150000 then
                 OutputWait_Memo.Lines.Add(' Enormous file .....');
              if i=200000 then
                 OutputWait_Memo.Lines.Add(' Have patience .....');
              if i=250000 then
                 OutputWait_Memo.Lines.Add(' Still running .....');
            end;
            progressbar1.Position:=100;
            closefile (OutFile);
            Output_Memo.Visible:=true;
            progressbar1.Visible:=false;
          end; {if AccErr then ... else ...}
        end; {if RunTimeError then ... else ...}
        OutputOpened:=true;
        OutputSymbols_Button.Enabled:=true;
        AreasChecked:=false;
        OutputWait_Memo.Visible:=false;
        OutputSalt_Image.Visible := false;
        Output_Memo.Visible:=true;
        MainSelection_Panel.Visible:=false;
        OutputShowMap_Button.Visible:=false;
        Mapping_Button.Visible := false;
        SeeGraph_Button.Enabled:=false;
        SaveGroup_Button.Enabled:=false;
      end  {if CalcDone then with DataMod do}
      else
      if OutputOpened then
      begin
        Output_Memo.Visible:=true;
        MainSelection_Panel.Visible:=false;
        OutputCancel_Button.Visible:=false;
        TypeSelection_Panel.Visible:=false;
        PolySelection_Panel.Visible:=false;
        TimeSelection_panel.Visible:=false;
      end;
end; {TMainForm.Output_TabSheetShow}
{----------------------------------}



procedure TMainForm.OutputOpen_Execute(Sender: TObject);
{------------------------------------------------------}
var TextLine : string;
    OutputDir : string;
    i : integer;
    YesOK : boolean;

begin
  inherited;
  CalcDone:=false;
  OutputCancel_Button.Visible:=false;
  SeeGraph_Button.Enabled:=false;
  SaveGroup_Button.Enabled:=false;
  OutputSalt_Image.Visible := false;
  InputOpened:=false;
  DataMod.ColorMap:=false;
  if DirectoryExists (InitDir) then chdir (InitDir);
  DeleteGroupFiles;                                {GroupFiles are "Name"files}
  if DirectoryExists (DataDir) then chdir (DataDir);
  DeleteGroupFiles;
  with DataMod do
  begin
    if OutputOpened then
       YesOK:=DataMod.Question('Do you want to open a new output file'+
              ' (give Yes) or return to the present output file (give No)')

    else
      YesOK:=true;
    if YesOK then
    begin
      if MainForm.OutputOpen_Dialog.Execute then
      begin
        OutputFilename := MainForm.OutputOpen_Dialog.Files.Strings[0];
        OpenFileName:=extractfilename(OutputFileName);
        if not FileExists (OutputFilename) then
        begin
          Showmessage ('File does not exist, please select another one,');
          exit;
        end;
      end else
      begin
        Showmessage('No output file was selected');
        OutputOpened:=false;
        Mapping_Button.Visible:=false;
        OutputShowMap_Button.Visible:=false;
        TypeSelection_Panel.Visible:=false;
        PolySelection_Panel.Visible:=false;
        TimeSelection_Panel.Visible:=false;
        exit;
      end;
    end;
    Output_Memo.Hide;
    FillOutputWaitMemo;
    OutputWait_Memo.Lines.Add(' Please wait .....');
    OutputDir:=getcurrentdir;
    SetInitialDir (OutputDir);
    Assignfile (OutFile,OutputFileName);
    reset (OutFile);
    Output_Memo.Lines.Clear;
    i:=0;
    Output_Memo.Hide;
    while not eof (OutFile) do
    begin
      readln (OutFile,TextLine);
      Output_Memo.Lines.Add(TextLine);
      i:=i+1;
      if i=20000 then
         OutputWait_Memo.Lines.Add(' Still loading .....');
      if i=50000 then
         OutputWait_Memo.Lines.Add(' Many data .........');
      if i=100000 then
         OutputWait_Memo.Lines.Add(' Very big file .....');
    end;
    closefile (OutFile);
    ReadInputData;
    Output_Memo.Show;
  end; {with DataMod do}
  Output_Memo.Visible:=true;
  MainSelection_Panel.Visible:=false;
  CalcDone:=false;
  Output_Memo.Show;
  OutputOpened := true;
  GroupOpened:=false;
  GraphOpened:=false;
  GotoInput_Button.Enabled := false;
  OutputSelection_Button.Enabled := true;
  OutputSymbols_Button.Enabled := true;
  MainSelection_Button.Visible := true;
  SeeGraph_Button.Enabled:=false;
  SaveGroup_Button.Enabled:=false;
  TypeSelection_Panel.Visible := false;
  TimeSelection_Panel.Visible := false;
  PolySelection_Panel.Visible := false;
  if not InputOpened then
  begin
    SeasonalInput_Tabsheet.TabVisible:=false;
    PolygonalInput_Tabsheet.TabVisible:=false;
    GeneralInput_Tabsheet.TabVisible:=false;
    GotoInput_Button.Enabled := true;
  end;
  OutputShowMap_Button.Visible:=false;
  Mapping_Button.Visible := false;
  OutputWait_Memo.Visible:=false;
  WarningForm.Visible:=false;
  MainSelection_Panel.Hide;
  NetWorkForm.Hide;
  SelectClassesForm.Visible:=false;
  SelectClassesForm.Classes_ComboBox.ItemIndex:=0;
  SelectClassesForm.Classes_ComboBoxChange(Sender);
  SelectClassesForm.NrOfClasses_ComboBox.Visible:=false;
  SelectClassesForm.NrOfClasses_ComboBox.ItemIndex:=3;
  SelectClassesForm.Classes_Grid.RowCount:=7;
  Output_Tabsheet.Show;

end; {TMainForm.OutputOpen_Execute}
{---------------------------------}



procedure TMainForm.OutputSymbols_ButtonClick(Sender: TObject);
{-------------------------------------------------------------}
begin
  inherited;
  Mode:='Output';
  SymbolsForm.Show;
end; {TMainForm.OutputSymbols_ButtonClick}
{----------------------------------------}



procedure TMainForm.OutputSelection_ButtonClick(Sender: TObject);
{---------------------------------------------------------}
begin
  inherited;
  OutputCancel_Button.Visible:=true;
  GraphSalt_Image.Visible := false;
  SeeGraph_Button.Enabled:=false;
  SaveGroup_Button.Enabled:=false;
  Output_Memo.Visible := false;
  OutputSelection_Button.Enabled:=false;
  OutputSymbols_Button.Enabled:=false;
  MainSelection_Panel.Show;
  OutputShowMap_Button.Visible:=true;
  Mapping_Button.Visible := true;
  DataMod.ColorMap:=false;
  SelectClassesForm.Visible:=false;
  NetWorkForm.Hide;
  SelectClassesForm.Classes_ComboBox.ItemIndex:=0;
  SelectClassesForm.Classes_ComboBoxChange(Sender);
  SelectClassesForm.NrOfClasses_ComboBox.Visible:=false;
  SelectClassesForm.NrOfClasses_ComboBox.ItemIndex:=3;
  SelectClassesForm.Classes_Grid.RowCount:=7;
end; {TMainForm.OutputSelectionButtonClick}
{-----------------------------------------}



procedure TMainForm.MainSelection_ButtonClick(Sender: TObject);
{-------------------------------------------------------------}
var Interrogation, ReadingOK : boolean;
    Dumstr1,DumStr2,DumStr3,DumStr4 : string;
    Blank1,Blank2,Blank3 : string;
    k:integer;
begin
  inherited;
  Interrogation := true;
  if OriginalName='' then OriginalName:=DataMod.OutputFileName;
  if Char_RadioButton.Checked then Interrogation:=false;
  if Frequency_RadioButton.Checked then Interrogation:=false;
  if GrwtFlows_RadioButton.Checked then Interrogation:=false;
  SeeGraph_Button.Enabled:=false;
  SaveGroup_Button.Enabled := false;
  if Interrogation then
  begin
    OutputSymbols_Button.Enabled:=false;
    OutputSelection_Button.Enabled:=false;
    MainSelection_Button.Visible:=false;
    TypeSelection_Panel.Visible:=true;
    TimeSelection_Panel.Visible:=false;
    PolySelection_Panel.Visible:=false;
  end else
  begin
    OutputSymbols_Button.Enabled:=true;
    OutputSelection_Button.Enabled:=true;
    SeeGraph_Button.Enabled:=true;
    SaveGroup_Button.Enabled := true;
    TypeSelection_Panel.Visible:=false;
    TimeSelection_Panel.Visible:=false;
    PolySelection_Panel.Visible:=false;
    Mapping_Button.Visible := false;
    OutputShowMap_Button.Visible:=false;
  end;
  if Char_RadioButton.Checked then
  begin
    DataMod.PolyCharact (DataMod.OutputFileName, ReadingOK);
    MainSelection_Panel.Hide;
    OutputCancel_Button.Visible:=false;
    Output_Memo.Hide;
    Output_Memo.Lines.Clear;
    setlength (DataMod.Fileline,DataMod.NrOfIntPoly+6);
    DataMod.FileLine[0] := ('Polygonal_coordinates');
    DataMod.FileLine[1] := ('');
    DataMod.FileLine[2] := (' Polygon      Nodal_coordinates in_cm.'+
                            '     Polygonal');
    DataMod.FileLine[3] := (' number          X              Y     '+
                            '     area(m2)');
    DataMod.FileLine[4] := ('"- - - - - - - - - - - - - - - - - - -'+
                            ' - - - - - - -"');
    for k:=5 to DataMod.NrOfIntPoly+4 do with DataMod do
    begin
      Blank1 :='    ';
      if Length (IntToStr(NodalNr[k-5]))=2 then
      Blank1 :='   ';
      if Length (IntToStr(NodalNr[k-5]))=3 then
      Blank1 :='  ';
      DumStr1:=Blank1+IntToStr(NodalNr[k-5]);
      Blank2 :='            ';
      if Length (FloatToStr(Xvalue[k-5]))=2 then
      Blank2 :='           ';
      if Length (FloatToStr(Xvalue[k-5]))=3 then
      Blank2 :='          ';
      if Length (FloatToStr(Xvalue[k-5]))=4 then
      Blank2 :='         ';
      if Length (FloatToStr(Xvalue[k-5]))=5 then
      Blank2 :='        ';
      DumStr2:=Blank2+FloatToStr(Xvalue[k-5]);
      Blank3 :='              ';
      if Length (FloatToStr(Yvalue[k-5]))=2 then
      Blank3 :='             ';
      if Length (FloatToStr(Yvalue[k-5]))=3 then
      Blank3 :='            ';
      if Length (FloatToStr(Yvalue[k-5]))=4 then
      Blank3 :='           ';
      if Length (FloatToStr(Yvalue[k-5]))=5 then
      Blank3 :='          ';
      DumStr3:=Blank3+FloatToStr(Yvalue[k-5]);
      DumStr4:='           '+FloatToStr(AreaT[k-5]);
      FileLine[k]:= Dumstr1 + Dumstr2 + Dumstr3 + Dumstr4;
    end;
    DataMod.FileLine [DataMod.NrOfIntPoly+5] := DataMod.FileLine[4];
    Output_Memo.Lines.Add ('Data from:_'+DataMod.OutputFileName);
    for k:=0 to DataMod.NrOfIntPoly+5 do
        Output_Memo.Lines.Add (DataMod.FileLine[k]);
    Output_Memo.Show;
  end;
  if not Interrogation then with DataMod do
  begin
    if Frequency_RadioButton.Checked then
    begin
      OutputFileName:=ChangeFileExt(OutputFileName,'.frq');
      ReadOutputLines (OutputFileName,ReadingOK);
      if not ReadingOk then exit;
      MainSelection_Panel.Hide;
      OutputCancel_Button.Visible:=false;
      Output_Memo.Hide;
      Output_Memo.Lines.Clear;
      for k:=1 to DataMod.NrOfLines do
          Output_Memo.Lines.Add(FileLine[k-1]);
      Output_Memo.Show;
      OutputFileName:=ChangeFileExt(OutputFileName,'.out');
    end else
    if GrwtFlows_RadioButton.Checked then
    begin
      OutputFileName:=ChangeFileExt(OutputFileName,'.gwt');
      ReadOutputLines (OutputFileName,ReadingOK);
      if not ReadingOk then exit;
      MainSelection_Panel.Hide;
      OutputCancel_Button.Visible:=false;
      Output_Memo.Hide;
      Output_Memo.Lines.Clear;
      for k:=1 to DataMod.NrOfLines do
          Output_Memo.Lines.Add(FileLine[k-1]);
      Output_Memo.Show;
      OutputFileName:=ChangeFileExt(OutputFileName,'.out');
    end;
  end; {with DataMod do}
  MainForm.Internal_RadioButton.Checked:=false;
  SeeGraph_Button.Enabled:=false;
  TypeSelection_Button.Visible:=true;

end; {TMainForm.MainSelection_ButtonClick}
{----------------------------------------}



procedure TMainForm.TypeSelection_ButtonClick(Sender: TObject);
{-------------------------------------------------------------}
var LastYear, LastSeason, LastPoly : string;
    YearStr : string[6];  AnyStr : string[10];
begin
  inherited;
  FillOutputWaitMemo;
  with DataMod do
  begin
    PolyData:=true;
    if Time_RadioButton.Checked then PolyData:=false;
    TypeSelection_Button.Visible:=false;
      Assignfile (OutFile,OutputFileName);
      reset(OutFile);
      while not eof(OutFile) do
      begin
        Read (OutFile, YearStr);
        if YearStr='  YEAR' then
        begin
          read (OutFile,AnyStr);
          while Pos(' ',AnyStr) > 0 do delete(AnyStr,Pos(' ',AnyStr),1);
          while Pos(':',AnyStr) > 0 do delete(AnyStr,Pos(':',AnyStr),1);
          YearNr:=strtoInt(AnyStr);
          readln(OutFile);
        end;
        readln (OutFile);
      end;
      NrOfYears:=YearNr;
      closefile (OutFile);
    if PolyData then
    begin
      TimeSelection_Panel.Visible:=true;
      LastYear:=IntToStr(NrOfYears);
      LastSeason:=IntToStr(NrOfSeasons);
      Dash1_Label.Caption:= '       0 - ' + LastYear;
      Dash2_Label.Caption:= '       1 - ' + LastSeason;
      ColorMapButton.Enabled:=true;
//      ColorMap:=true;
    end else
    begin
      PolySelection_Panel.Visible:=true;
      LastPoly:=IntToStr(NrOfIntPoly);
      DashP_Label.Caption:= '1- '+ LastPoly;
      ColorMapButton.Enabled:=false;
//      ColorMap:=false;
    end;
  end;
  OutputWait_Memo.Visible:=false;
end; {TMainForm.TypeSelection_ButtonClick}
{----------------------------------------}



procedure TMainForm.TimeSelection_ButtonClick(Sender: TObject);
{-------------------------------------------------------------}
begin
  inherited;
  with DataMod do
  begin
    Try
      YearWanted:=StrToInt(YearNr_Edit.Text);
      Except on E: exception do
      begin
        Showmessage ('The given year is not a true integer');
        YearNr_Edit.Text := ' 0';
        TypeSelection_Button.Click;
        exit;
      end;
    end;
    Try
      SeasonWanted:=StrToInt(SeasNr_Edit.Text);
      Except on E: exception do
      begin
        Showmessage ('The given season is not a true integer');
        SeasNr_Edit.Text := ' 1';
        TypeSelection_Button.Click;
        exit;
      end;
    end;
    if (YearWanted<0) or (YearWanted>NrOfYears) then
    begin
      Showmessage ('The given year is out of range');
      TypeSelection_Button.Click;
      exit;
    end;
    if (SeasonWanted<1) or (SeasonWanted>NrOfSeasons) then
    begin
      Showmessage ('The given season is out of range');
      TypeSelection_Button.Click;
      exit;
    end;
  end;
  SearchForData;
end; {TMainForm.TimeSelection_ButtonClick}
{----------------------------------------}



procedure TMainForm.PolySelection_ButtonClick(Sender: TObject);
{------------------------------------------------------------}
var k : integer;
    PolyOK : boolean;
begin
  inherited;
    Try
      DataMod.PolyWanted:=StrToInt(PolyNr_Edit.Text);
      Except on E: exception do
      begin
        Showmessage ('The given polygon number is not a true integer');
        PolyNr_Edit.Text := ' 1';
        TypeSelection_Button.Click;
        exit;
      end;
    end;
    PolyOK:=false;
    if InputOpened then
    begin
       for k:=1 to DataMod.NrOfIntPoly do
           if DataMod.PolyWanted=DataMod.NodeNr[k] then PolyOK:=true;
    end else
       for k:=0 to DataMod.NrOfIntPoly-1 do
           if DataMod.PolyWanted=DataMod.NodalNr[k] then PolyOK:=true;
    if not PolyOk then
    begin
      ShowMessage ('This is not an existing polygon number.');
      exit
    end;
    FillOutputWaitMemo;
    SearchForData;
end; {TMainForm.PolySelection_ButtonClick}
{----------------------------------------}



procedure TMainForm.SearchForData;
{--------------------------------}
var i : integer;
begin
  OutputSelection_Button.Enabled:=true;
  SeeGraph_Button.Enabled:=true;
  SaveGroup_Button.Enabled := true;
  OutputShowMap_Button.Visible:=false;
  Mapping_Button.Visible := false;
  OutputSymbols_Button.Enabled := true;
  FillOutputWaitMemo;
  with DataMod do
  begin
    ChangeFileExt(OutputFileName,'.out');
    if SoilSal_RadioButton.Checked then GroupMark := 'CrA';
    if SubSal_RadioButton.Checked then GroupMark := 'Cxf';
    if OtherSal_RadioButton.Checked then GroupMark := 'Cti';
    if AvSal_RadioButton.Checked then
    begin
      GroupMark := 'AvC';
      if PolyData then
      begin
        ReadPolyDataOfTime('AvC');
        ShowPolyDataOfTime('AvC');
      end else
      begin
        ReadTimeDataOfPoly('Uc');
        ShowTimeDataOfPoly('Uc');
      end;
    end;
    if SaltSto_RadioButton.Checked then
    begin
      GroupMark := 'Zs';
      if PolyData then
      begin
        ReadPolyDataOfTime('Dw');
        ShowPolyDataOfTime('Zs');
      end else
      begin
        ReadTimeDataOfPoly('Dw');
        ShowTimeDataOfPoly('Zs');
      end;
    end;
    if GroundWater_RadioButton.Checked then GroupMark := 'Gti';
    if Discharge_RadioButton.Checked then GroupMark := 'Gd';
    if DepthWT_RadioButton.Checked then
    begin
      GroupMark := 'Dw';
      if PolyData then
      begin
        ReadPolyDataOfTime('Dw');
        for i:=0 to DataMod.NrOfData-1 do
            DataMod.Variable[1,i]:=-DataMod.Variable[1,i];
        ShowPolyDataOfTime('Dw');
      end else
      begin
        ReadTimeDataOfPoly('Dw');
        for i:=0 to DataMod.NrOfData-1 do
            DataMod.Variable[1,i]:=-DataMod.Variable[1,i];
        ShowTimeDataOfPoly('Dw');
      end;
    end;
    if Evapo_RadioButton.Checked then
    begin
      GroupMark := 'EaU';
      if PolyData then
      begin
        ReadPolyDataOfTime('EaU');
        ShowPolyDataOfTime('EaU');
      end else
      begin
        ReadTimeDataOfPoly('EaU');
        ShowTimeDataOfPoly('EaU');
      end;
    end;
    if Percol_RadioButton.Checked then GroupMark := 'LrA';
    if Capil_RadioButton.Checked then GroupMark := 'RrA';
    if CanalIrr_RadioButton.Checked then GroupMark := 'It';
    if IrrEff_RadioButton.Checked then GroupMark := 'FfA';
    if CropArea_RadioButton.Checked then GroupMark := 'A';
    if (GroupMark<>'Dw') and (GroupMark<>'Zs') and (GroupMark<>'AvC')
    and (GroupMark<>'EaU') then
    begin
      if PolyData then
      begin
        ReadPolyDataOfTime(GroupMark);
        ShowPolyDataOfTime(GroupMark);
      end else
      begin
        ReadTimeDataOfPoly(GroupMark);
        ShowTimeDataOfPoly(GroupMark);
      end;
    end;
  end; {with DataMod do}
  OutputWait_Memo.Visible:=false;
end; {TMainForm.SearchForData}
{----------------------------}



procedure TMainForm.ShowPolyDataOfTime(Signal : string);
{------------------------------------------------------}
var i,k : integer;
    PolyStr : string[6];
    YearStr, SeasonStr, TmpName : string;
    TmpFile : textfile;
begin
  MainSelection_Panel.Hide;
  TypeSelection_Panel.Visible:=false;
  TimeSelection_Panel.Visible:=false;
  OutputCancel_Button.Visible:=false;
  Output_Memo.Hide;
  Output_Memo.Lines.Clear;
  with DataMod do
  begin
    TmpName := DataMod.OutputFileName;
    TmpName := ChangeFileExt (TmpName,'.inp');
    AssignFile (TmpFile,TmpName);
    reset (TmpFile);
    setlength (NodalNr,DataMod.TotNrOfPoly);
    for k:=1 to 7 do readln(TmpFile);
    for k:=0 to DataMod.NrOfIntPoly-1 do read (TmpFile,NodalNr[k]);
    closefile (TmpFile);
    for i:=1 to 8 do PosValues[i]:=false;
    for i:=1 to NrOfitems do for k:=0 to NrOfData-1 do
      if Variable[i,k]>0 then PosValues[i]:=true;
    if GroupMark='Dw' then PosValues[1]:=true;
    if GroupMark='Gti' then for i:=1 to NrOfitems do PosValues[i]:=true;
    setlength(FileLine,NrOfData+8);
    YearStr:=IntToStr(YearWanted);
    SeasonStr:=IntToStr(SeasonWanted);
    FileLine[0] := (' YEAR-'+YearStr);
    FileLine[1] := (' SEASON-'+SeasonStr);
    FileLine[4] := ('');
    if GroupMark='AvC' then
    begin
      FileLine[2] := ('"Weighted average salinity of the rootzone '+
                      ' in the polygon per season"');
      FileLine[3] := ('"(AvC, dS/m)"');
      FileLine[5] := (' Polygon       AvC');
      FileLine[6] := ('"- - - - - - - - - -"');
    end;
    if GroupMark='CrA' then
    begin
      PolyStr := IntToStr (PolyWanted);
      FileLine[2] := ('"Soil salinities of the root zone'+
                      ' CrA (irr. A crops), CrB (irr. B crops),"');
      FileLine[3] := ('"CrU (not irr.), Cr4 (full rotation)'+
                      ' and outside (C*) in dS/m, see symbols"');
      FileLine[5] := (' Polygon    CrA     CrB     CrU     Cr4'+
                      '     C0*     C1*     C2*     C3*');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - -'+
                      ' - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='Cxf' then
    begin
      FileLine[2] := ('"Salinity of the trans. zone (Cxf, Cxa, Cxb),'+
                      ' and aquifer (Cqf)"');
      FileLine[3] := ('"EC in dS/m, see symbols list"');
      FileLine[5] := (' Polygon    Cxf      Cxa      Cxb      Cqf');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='Cti' then
    begin
      FileLine[2] := ('"Salinity of the incoming groundwater in'+
                      ' trans. zone (Cti) and aquifer (Cqi), and of"');
      FileLine[3] := ('"irrigation (Ci), drainage (Cd), and well (Cw)'+
                      ' water, EC in dS/m, see symbols list"');
      FileLine[5] := (' Polygon    Cti      Cqi      Ci       Cd '+
                      '       Cw');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - - '+
                      '- - - - - - -"');
    end;
    if GroupMark='Zs' then
    begin
      FileLine[2] := ('"Salt storage (Zs, m.dS/m) '+
                      ' above the soil surface in m.dS/m  per season"');
      FileLine[3] := ('"only when the water table is above the'+
                      ' "surface, see symbols list"');
      FileLine[5] := (' Polygon       Zs');
      FileLine[6] := ('"- - - - - - - - - -"');
    end;
    if GroupMark='Gti' then
    begin
      FileLine[2] := ('"Groundwater flow G in m/season, suffix t= trans'+
                      'ition zone, q=aquifer,"');
      FileLine[3] := ('"i=incoming, o= outgoing, v=vertical'+
                      ' nt=net, see symbols list"');
      FileLine[5] := (' Polygon    Gti      Gto      Gtv      Gqi'+
                      '      Gqo      Gaq      Gnt');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - -'+
                      ' - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='Gd' then
    begin
      FileLine[2] := ('"Drain (Gd, Ga, Gb) and well (Gw) discharge'+
                      ' in m/season"');
      FileLine[3] := ('"Ga and Gb are drainage flows above and below'+
                      ' drain level, see symbols list"');
      FileLine[5] := (' Polygon    Gd       Ga        Gb       Gw ');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='Dw' then
    begin
      FileLine[2] := ('"Depth of the water table Dw in m"');
      FileLine[3] := ('"When the watertable is below soil surface'+
                      ' the depth is given as a negative value"');
      FileLine[5] := (' Polygon      Dw');
      FileLine[6] := ('"- - - - - - - - -"');
    end;
    if GroupMark='LrA' then
    begin
      FileLine[2] := ('"Water percolating down to the'+
                      ' water table in A land (LrA), B land (LrB),"');
      FileLine[3] := ('"unirrigated land (LrU), and total area'+
                      ' average (Lr) in m/season, see symbols list"');
      FileLine[5] := (' Polygon     LrA      LrB      LrU      Lr');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='RrA' then
    begin
      FileLine[2] := ('"Cap.rise from the water table up into'+
                      ' the root zone of A-land(RrA), B-land(RrB),"');
      FileLine[3] := ('"unirrigated land (RrU) and total'+
                      ' average (Rr) in m/season, see symbols list"');
      FileLine[5] := (' Polygon     RrA      RrB      RrU      Rr');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='It' then
    begin
      FileLine[2] := ('"Amounts of irrigation water (m/season),'+
                      ' It = total, Is = net"');
      FileLine[3] := ('"IaA and IaB are field applications'+
                      ' to land under A and B crops, see symbols"');
      FileLine[5] := (' Polygon     It       Is       IaA'+
                      '      IaB      Io');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - -' +
                      ' - - - - - - - - -"');
    end;
    if GroupMark='FfA' then
    begin
      FileLine[2] := ('"Irrigation efficiency in A (FfA) and B land (FfB)'+
                      ' and total (Fft)"');
      FileLine[3] := ('"sufficiency in A (JsA) and B land (JsB),'+
                      ' fractions, see symbols list"');
      FileLine[5] := (' Polygon    FfA      FfB      Fft'+
                      '      JsA      JsB');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - ' +
                      '- - - - - - - - - - -"');
    end;
    if GroupMark='EaU' then
    begin
      FileLine[2] := ('"Net evaporation from unirrigated land '+
                      ' EaU in m/season,"');
      FileLine[3] := ('"see symbols list"');
      FileLine[5] := (' Polygon     EaU');
      FileLine[6] := ('"- - - - - - - - -"');
    end;
    if GroupMark='A' then
    begin
      FileLine[2] := ('"Area fraction of irrigated A land, B land, '+
                      ' un-irrigated land (U), and"');
      FileLine[3] := ('"permanently fallow land (Uc),'+
                      ' see symbols list"');
      FileLine[5] := (' Polygon    A        B        U'+
                      '        Uc');
      FileLine[6] := ('"- - - - - - - - - - - - - - - ' +
                      '- - - - - - -"');
    end;
    for k:=1 to NrOfData do
    begin
      if NodalNr[k-1]<10 then FileLine[k+6]:=('  '+IntToStr(NodalNr[k-1])+
                                              '       ')
      else
      if NodalNr[k-1]<100 then FileLine[k+6]:=(' '+IntToStr(NodalNr[k-1])+
                                               '       ')
      else
      FileLine[k+6]:=(IntToStr(NodalNr[k-1])+'       ');
      for i:= 1 to DataMod.NrOfitems do
      begin
        if (GroupMark<>'Dw') and (GroupMark<>'CrA') and (GroupMark<>'AvC')
        and (GroupMark<>'EaU')then
        begin
          if (DataMod.Variable[i,k-1]<0) and PosValues[i] then
              MainStr[i]:='   -     ';
          if (DataMod.Variable[i,k-1]<0) and not PosValues[i] then
              MainStr[i]:='  n.a.   ';
          if DataMod.Variable[i,k-1]>=0 then
          begin
            MainStr[i]:=FloatToStr(DataMod.Variable[i,k-1]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
          end;
        end; {if GroupMark<>'Dw' etc. then}
        if GroupMark='AvC' then if i=3 then
        begin
           MainStr[3]:=FloatToStr(DataMod.Variable[3,k-1]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            FileLine[k+6]:= FileLine[k+6]+MainStr[3];
        end;
        if GroupMark='CrA' then
        begin
          if DataMod.Variable[i,k-1]>0 then
          begin
            MainStr[i]:=FloatToStr(DataMod.Variable[i,k-1]);
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
          end;
            if (DataMod.Variable[i,k-1]<0) and PosValues[i] then
              MainStr[i]:='   -    ';
            if (DataMod.Variable[i,k-1]<0) and not PosValues[i] then
                MainStr[i]:='  n.a.  ';
            if (DataMod.Variable[i,k-1]>0) and (DataMod.Variable[i,k-1]<0.001)
            and PosValues[i] then
              MainStr[i]:='   0.0    ';
            FileLine[k+6]:= FileLine[k+6]+MainStr[i];
//          end;
        end; {if GroupMark='CrA' then}
        if (GroupMark<>'Zs') and (GroupMark<>'Dw') and (GroupMark<>'CrA') and
           (GroupMark<>'EaU') and (GroupMark<>'AvC') then
             FileLine[k+6]:= FileLine[k+6]+MainStr[i];
//        if GroupMark='AvC' then if i=3 then
//           FileLine[k+6]:= FileLine[k+6]+MainStr[3];
        if GroupMark='Zs' then if i=5 then
           FileLine[k+6]:= FileLine[k+6]+MainStr[5];
        if GroupMark='Dw' then if i=1 then
        begin
           MainStr[1]:=FloatToStr(DataMod.Variable[1,k-1]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            FileLine[k+6]:= FileLine[k+6]+MainStr[1];
        end;
        if GroupMark='EaU' then if i=7 then
        begin
           MainStr[7]:=FloatToStr(DataMod.Variable[7,k-1]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if (DataMod.Variable[i,k-1]<0) and PosValues[i] then
                MainStr[i]:='   -     ';
            if (DataMod.Variable[i,k-1]<0) and not PosValues[i] then
                MainStr[i]:='  n.a.   ';
            if (DataMod.Variable[i,k-1]>0) and (DataMod.Variable[i,k-1]<0.001)
            and PosValues[i] then
              MainStr[i]:='  0.0    ';
            FileLine[k+6]:= FileLine[k+6]+MainStr[7];
        end;
      end; {for i:= 1 to DataMod.NrOfitems do}
    end; {for k:=1 to NrOfData do}
    FileLine[NrOfData+7]:=FileLine[6];
    Output_Memo.Lines.Add('Data_from:_'+OutputFileName);
    for k:=0 to NrOfData+7 do
        Output_Memo.Lines.Add(FileLine[k]);
    GrTitle1 := FileLine[0];
    GrTitle4 := FileLine[1];
    GrTitle2 := FileLine[2];
    GrTitle3 := FileLine[3];
  end; {with DataMod do}
  SeeGraph_Button.Enabled:=true;
  SaveGroup_Button.Enabled:=true;
  MainSelection_Button.Visible:=true;
  Output_Memo.Show;
end; {TMainForm.ShowPolyDataOfTime}
{---------------------------------}



procedure TMainForm.ShowTimeDataOfPoly(Signal : string);
{------------------------------------------------------}
var i,k, YearNumber : integer;
    PolyStr, DurationStr, SeasonStr : string;
begin
  MainSelection_Panel.Hide;
  TypeSelection_Panel.Visible:=false;
  PolySelection_Panel.Visible:=false;
  OutputCancel_Button.Visible:=false;
  Output_Memo.Hide;
  Output_Memo.Lines.Clear;
  with DataMod do
  begin
    for i:=1 to 8 do PosValues[i]:=false;
    for i:=1 to NrOfitems do for k:=0 to NrOfData-1 do
      if Variable[i,k]>0 then PosValues[i]:=true;
    if GroupMark='Dw' then PosValues[1]:=true;
    if GroupMark='Gti' then for i:=1 to NrOfitems do PosValues[i]:=true;
    setlength(FileLine,NrOfData+9);
    PolyStr:=IntToStr(PolyWanted);
    FileLine[0] := ('POLYGON_Nr_'+PolyStr);
    FileLine[1] := ('');
    FileLine[4] := ('');
    if GroupMark='AvC' then
    begin
      PolyStr := IntToStr (PolyWanted);
      FileLine[2] := ('"Weighted average salinity of the rootzone '+
                      ' in the polygon per season"');
      FileLine[3] := ('"(AvC, dS/m)"');
      FileLine[5] := (' Year Season    AvC');
      FileLine[6] := ('"- - - - - - - - - -"');
    end;
    if GroupMark='CrA' then
    begin
      PolyStr := IntToStr (PolyWanted);
      FileLine[2] := ('"Soil salinities of the root zone'+
                      ' CrA (irr. A crops), CrB (irr. B crops),"');
      FileLine[3] := ('"CrU (not irr.), Cr4 (full rotation)'+
                      ' and outside (C*) in dS/m, see symbols"');
      FileLine[5] := (' Year Season    CrA     CrB     CrU     Cr4'+
                      '     C0*     C1*     C2*     C3*');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - - - -'+
                      ' - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='Cxf' then
    begin
      FileLine[2] := ('"Salinity of the trans. zone (Cxf, Cxa, Cxb),'+
                      ' and aquifer (Cqf)"');
      FileLine[3] := ('"EC in dS/m, see symbols list"');
      FileLine[5] := (' Year Season    Cxf      Cxa     Cxb     Cqf');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='Cti' then
    begin
      FileLine[2] := ('"Salinity of the incoming groundwater in'+
                      ' trans. zone (Cti) and aquifer (Cqi), and of"');
      FileLine[3] := ('"irrigation (Ci), drainage (Cd), and well (Cw)'+
                      ' water, EC in dS/m, see symbols list"');
      FileLine[5] := (' Year Season    Cti      Cqi      Ci       Cd'+
                      '       Cw');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - - - '+
                      '- - - - - -"');
    end;
    if GroupMark='Zs' then
    begin
      FileLine[2] := ('"Salt storage (Zs, m.dS/m) '+
                      'above the soil surface in m.dS/m  per season"');
      FileLine[3] := ('"only when the water table is above the'+
                      ' surface, see symbols list"');
      FileLine[5] := (' Year Season    Zs');
      FileLine[6] := ('"- - - - - - - - - - -"');
    end;
    if GroupMark='Gti' then
    begin
      FileLine[2] := ('"Groundwater flow G in m/season, suffix t= trans'+
                      'ition zone, q=aquifer,"');
      FileLine[3] := ('"i=incoming, o= outgoing, v=vertical'+
                      ' nt=net, see symbols list"');
      FileLine[5] := (' Year Season    Gti      Gto      Gtv      Gqi'+
                      '      Gqo      Gaq      Gnt');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - -  -- - - - '+
                      '- - - - - - - - - - - - - - -"');
    end;
    if GroupMark='Gd' then
    begin
      FileLine[2] := ('"Drain (Gd, Ga, Gb) and well (Gw) discharge'+
                      ' in m/season"');
      FileLine[3] := ('"Ga and Gb are drainage flows above and below'+
                      ' drain level, see symbols list"');
      FileLine[5] := (' Year Season    Gd       Ga       Gb        Gw ');
      FileLine[6] := ('"- - - - - - - - - - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='Dw' then
    begin
      FileLine[2] := ('"Depth of the water table Dw in m"');
      FileLine[3] := ('"When the watertable is below soil surface'+
                      ' the depth is given as a negative value"');
      FileLine[5] := (' Year Season    Dw');
      FileLine[6] := ('"- - - - - - - - - - -"');
    end;
    if GroupMark='LrA' then
    begin
      FileLine[2] := ('"Water percolating down to the'+
                      ' water table in A land (LrA), B land (LrB),"');
      FileLine[3] := ('"unirrigated land (LrU), and total area'+
                      ' average (Lr) in m/season, see symbols list"');
      FileLine[5] := (' Year Season    LrA      LrB      LrU      Lr');
      FileLine[6] := ('"- - - - - - -  - - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='RrA' then
    begin
      FileLine[2] := ('"Cap.rise from the water table up into'+
                      ' the root zone of A-land(RrA), B-land(RrB),"');
      FileLine[3] := ('"unirrigated land (RrU) and total area'+
                      ' average (Rr) in m/season, see symbols list"');
      FileLine[5] := (' Year Season    RrA      RrB      RrU      Rr');
      FileLine[6] := ('"- - - - - - -  - - - - - - - - - - - - - - - -"');
    end;
    if GroupMark='It' then
    begin
      FileLine[2] := ('"Amounts of irrigation water (m/season),'+
                      ' It = total, Is = net, Io=bypass"');
      FileLine[3] := ('"IaA and IaB are field applications'+
                      ' to land under A and B crops, see symbols"');
      FileLine[5] := (' Year Season     It       Is       IaA '+
                      '    IaB        Io');
      FileLine[6] := ('" - - - - - -  - - - - - - - - - - - - ' +
                      '- - - - - - - - - -"');
    end;
    if GroupMark='FfA' then
    begin
      FileLine[2] := ('"Irrigation efficiency in A (FfA) and B land (FfB)'+
                      ' and total (Fft)"');
      FileLine[3] := ('"sufficiency in A (JsA) and B land (JsB),'+
                      ' fractions, see symbols list"');
      FileLine[5] := (' Year Season     FfA      FfB      Fft'+
                      '      JsA      JsB');
      FileLine[6] := ('"- - - - - - -  - - - - - - - - - - - ' +
                      '- - - - - - - - - - -"');
    end;
    if GroupMark='EaU' then
    begin
      FileLine[2] := ('"Net evaporation from unirrigated land '+
                      ' EaU in m/season,"');
      FileLine[3] := ('"see symbols list"');
      FileLine[5] := (' Year Season    EaU');
      FileLine[6] := ('"- - - - - - -  - - -"');
    end;
    if GroupMark='A' then
    begin
      FileLine[2] := ('"Area fraction of irrigated A land, B land, '+
                      ' un-irrigated land (U), and"');
      FileLine[3] := ('"permanently fallow land (Uc),'+
                      ' see symbols list"');
      FileLine[5] := (' Year Season      A        B        U'+
                      '        Uc');
      FileLine[6] := ('"- - - - - - -  - - - - - - - - - - - ' +
                      '- - - - - -"');
    end;

    YearNumber:=1;
    SeasonNr:=0;
    for k:=1 to NrOfData do
    begin
      SeasonNr:=SeasonNr+1;
      if SeasonNr>NrOfSeasons then
      begin
        YearNumber:=YearNumber+1;
        SeasonNr:=1;
      end;
      if YearNumber<11 then
          FileLine[k+6]:=('  '+IntToStr(YearNumber-1)+'       '+
                          IntToStr(SeasonNr)+'   ')
      else
          FileLine[k+6]:=(' '+IntToStr(YearNumber-1)+'       '+
                          IntToStr(SeasonNr)+'   ');
      for i:= 1 to DataMod.NrOfitems do
      begin
        if (GroupMark<>'Dw') and (GroupMark<>'Gti') and (GroupMark<>'CrA')
        and (GroupMark<>'AvC') and (GroupMark<>'EaU') then
        begin
          if (DataMod.Variable[i,k-1]<0) and PosValues[i] then
            MainStr[i]:='    -    ';
          if (DataMod.Variable[i,k-1]<0) and not PosValues[i] then
              MainStr[i]:='  n.a.   ';
          if DataMod.Variable[i,k-1]>=0 then
          begin
            MainStr[i]:=FloatToStr(DataMod.Variable[i,k-1]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if (DataMod.Variable[i,k-1]>0) and (DataMod.Variable[i,k-1]<0.001)
            and PosValues[i] then
              MainStr[i]:='   0.0    ';
          end;
        end; {if (GroupMark<>'Dw') and (GroupMark<>'Gti')}

        if (GroupMark='CrA') then
        begin
          if (DataMod.Variable[i,k-1]<0) and PosValues[i] then
            MainStr[i]:='   -    ';
          if (DataMod.Variable[i,k-1]<0) and not PosValues[i] then
              MainStr[i]:='  n.a.  ';
          if DataMod.Variable[i,k-1]>=0 then
          begin
            MainStr[i]:=FloatToStr(DataMod.Variable[i,k-1]);
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<8 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if (DataMod.Variable[i,k-1]>0) and (DataMod.Variable[i,k-1]<0.001)
            and PosValues[i] then
              MainStr[i]:='   0.0  ';
          end;
        end; {if (GroupMark='CrA') then}

        if GroupMark='Dw' then
        begin
          MainStr[1]:=FloatToStr(DataMod.Variable[1,k-1]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if length(MainStr[1])>10 then delete (MainStr[1],10,1);
        end; {if GroupMark='Dw' then}

        if GroupMark='Gti' then
        begin
          MainStr[i]:=FloatToStr(DataMod.Variable[i,k-1]);
          if (DataMod.Variable[i,k-1]<0) and PosValues[i] then
             MainStr[i]:='    -     ';
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if (DataMod.Variable[i,k-1]>0) and (DataMod.Variable[i,k-1]<0.001)
               and PosValues[i] then
                   MainStr[i]:='   0.0    ';
        end; {if GroupMark='Gti' then}

        if GroupMark='AvC' then  if i=3 then
        begin
          MainStr[3]:=FloatToStr(DataMod.Variable[3,k-1]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if length(MainStr[1])>10 then delete (MainStr[1],10,1);
        end; {if GroupMark='Dw' then}
        if GroupMark='EaU' then if i=7 then
        begin
          MainStr[7]:=FloatToStr(DataMod.Variable[7,k-1]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
              MainStr[i]:=ConCat(' ',DataMod.MainStr[i]);
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if Length(MainStr[i])<9 then
               MainStr[i]:=ConCat(DataMod.MainStr[i],' ');
            if length(MainStr[7])>10 then delete (MainStr[7],10,1);
            if (DataMod.Variable[i,k-1]<0) and PosValues[i] then
                MainStr[i]:='    -    ';
            if (DataMod.Variable[i,k-1]<0) and not PosValues[i] then
                MainStr[i]:='  n.a.   ';
        end; {if GroupMark='Dw' then}
        if (GroupMark<>'Zs') and (GroupMark<>'Dw') and
           (GroupMark<>'EaU') and (GroupMark<>'AvC') then
              FileLine[k+6]:= FileLine[k+6]+MainStr[i];
        if GroupMark='AvC' then if i=3 then
           FileLine[k+6]:= FileLine[k+6]+MainStr[3];
        if GroupMark='Zs' then if i=5 then
           FileLine[k+6]:= FileLine[k+6]+MainStr[5];
        if GroupMark='Dw' then if i=1 then
           FileLine[k+6]:= FileLine[k+6]+MainStr[1];
        if GroupMark='EaU' then if i=7 then
           FileLine[k+6]:= FileLine[k+6]+MainStr[7];
      end; {for i:=1 to DataMod.NrOfitems do}
    end; {for k:=1 to NrOfData do}
    FileLine[NrOfData+7]:=FileLine[6];
    SeasonStr:='';
    for k:=1 to NrOfSeasons do
    begin
      DurationStr:=FloatToStr(SeasonDuration[k]);
      SeasonStr:=SeasonStr+'  '+DurationStr;
    end;
    FileLine[NrOfData+8]:=('Season_durations '+SeasonStr+'  months');
    Output_Memo.Lines.Add('Data_from_'+OutputFileName);
    for k:=0 to NrOfData+8 do
        Output_Memo.Lines.Add(FileLine[k]);
    GrTitle1 := FileLine[0];
    GrTitle4 := FileLine[1];
    GrTitle2 := FileLine[2];
    GrTitle3 := FileLine[3];
  end; {with DataMod do}
//  SeeGraph_Button.Visible:=true;
  SeeGraph_Button.Enabled:=true;
//  SaveGroup_Button.Visible:=true;
  SaveGroup_Button.Enabled:=true;
  MainSelection_Button.Visible:=true;
  Output_Memo.Show;
end; {TMainForm.ShowTimeDataOfPoly}
{---------------------------------}



procedure TMainForm.FillOutputWaitMemo;
{-------------------------------------}
begin
  OutputWait_Memo.Lines.Clear;
  OutputWait_Memo.Lines.Add('');
  OutputWait_Memo.Lines.Add(' Retrieving output data');
  OutputWait_Memo.Lines.Add(' This may take a few minutes');
//  OutputWait_Memo.Lines.Add(' Please wait .....');
  OutputWait_Memo.Visible:=true;
end;
{TMainForm.FillOutputWaitMemo}
{----------------------------}



procedure TMainForm.OutputCancel_ButtonClick(Sender: TObject);
{------------------------------------------------------------}
begin
  inherited;
  if MainSelection_Button.Visible then
  begin
    GeneralInput_Tabsheet.Show;
    exit;
  end;
  if TypeSelection_Button.Visible then
  begin
    TypeSelection_Panel.Visible:=false;
    MainSelection_Button.Visible:=true;
  end else
  if TimeSelection_Button.Visible then
  begin
    TimeSelection_Panel.Visible:=false;
    PolySelection_Panel.Visible:=false;
    TypeSelection_Button.Visible:=true;
  end;
end; {TMainForm.Cancel_ButtonClick}
{---------------------------------}



procedure TMainForm.GroupOpen_Execute(Sender: TObject);
{-----------------------------------------------------}
var ReadingOK : boolean;
    i,k : integer;
begin
  inherited;
    with DataMod do
    begin
      if MainForm.GroupOpen_Dialog.Execute then
        GroupName := GroupOpen_Dialog.Files.Strings[0]
      else
      begin
        Showmessage('No group file was selected');
        OutputOpened:=false;
        exit;
      end;
      ReadOutputLines (GroupName,ReadingOK);
      if not ReadingOk then exit;
      MainSelection_Panel.Hide;
      OutputCancel_Button.Visible:=false;
      Output_Memo.Hide;
      Output_Memo.Lines.Clear;
      for k:=1 to DataMod.NrOfLines do
          Output_Memo.Lines.Add(FileLine[k-1]);
    end; {with DataMod do}
    DataMod.ReadGroupData;
    if DataMod.NoGraph then
    begin
      DataMod.Nograph:=false;
      OutputOpened:=false;
      Output_Memo.Show;
      SeeGraph_Button.Enabled:=false;
      SaveGroup_Button.Enabled:=false;
      exit;
    end;
    for k:=1 to 8 do PosValues[k]:=false;   {Only PosValues 1, 5 and 6 are used}
    for k:=1 to DataMod.NrOfitems do for i:=0 to DataMod.NrOfData-1 do
        if DataMod.Variable[k,i]>0 then PosValues[k]:=true;
    if DataMod.GroupMark='Dw' then PosValues[1]:=true;
    if DataMod.GroupMark='Gti' then for i:=1 to DataMod.NrOfitems do
       PosValues[i]:=true;
    if DataMod.GroupMark='EaU' then PosValues[7]:=PosValues[1];
    GroupOpened:=true;
    OutputSelection_Button.Enabled:=false;
    GotoInput_Button.Enabled:=true;
    OutputSymbols_Button.Enabled:=true;
    SeeGraph_Button.Enabled:=true;
    SaveGroup_Button.Enabled:=true;
    GraphOpened:=false;
    OutputShowMap_Button.Visible:=false;
    Mapping_Button.Visible := false;
    OutputCancel_Button.Visible := false;
    MainSelection_Panel.Visible := false;
    TypeSelection_Panel.Visible := false;
    TimeSelection_Panel.Visible := false;
    PolySelection_Panel.Visible := false;
    Output_Memo.Show;
end; {TMainForm.GroupOpen_Execute}
{--------------------------------}



procedure TMainForm.GroupSave_Execute(Sender: TObject);
{-----------------------------------------------------}
var GroupFile : textfile;
    Result : boolean;
    k : integer;
begin
  inherited;
    with DataMod do
    begin
      if MainForm.GroupSave_Dialog.Execute then
      begin
        GroupName := GroupSave_Dialog.Files.Strings[0];
        if FileExists(DataMod.GroupName) then
           Result := Question('The file already exists, overwrite?')
        else
           Result := true;
      end
      else
      begin
        Showmessage('No group file was saved');
        OutputOpened:=false;
        exit;
      end;
      if Result then
      begin
        assignfile (GroupFile,GroupName);
        rewrite (GroupFile);
        writeln (GroupFile,'Filename:_'+GroupName);
        if Char_RadioButton.Checked then
        begin
          for k:=0 to DataMod.NrOfIntPoly+5 do
              writeln (GroupFile,FileLine[k]);
        end else
        if Frequency_RadioButton.Checked or
          GrwtFlows_RadioButton.Checked then
        begin
          MainSelection_ButtonClick(Sender);
          for k:=1 to NrOfLines-1 do  writeln (GroupFile,FileLine[k]);
        end else
        begin
          if PolyData then
             for k:=0 to NrOfData+7 do writeln (GroupFile,FileLine[k])
          else
             for k:=0 to NrOfData+8 do writeln (GroupFile,FileLine[k]);
        end;
        closefile (GroupFile);
        showmessage ('The group file is saved as ' + GroupName);
      end; {if Result then}
    end; {with DataMod do}
    MainSelection_Button.Visible:=true;
end; {TMainForm.GroupSave_Execute}
{--------------------------------}



procedure TMainForm.SeeGraph_ButtonClick(Sender: TObject);
{--------------------------------------------------------}
//var YesOK : boolean;
begin
  inherited;
  NumberWanted:=DataMod.NrOfIntPoly;
  GroupOpened:=true;
  SelectClassesForm.Visible:=false;
  SelectClassesForm.Classes_ComboBox.ItemIndex:=0;
  SelectClassesForm.Classes_ComboBoxChange(Sender);
  SelectClassesForm.NrOfClasses_ComboBox.Visible:=false;
  SelectClassesForm.NrOfClasses_ComboBox.ItemIndex:=3;
  SelectClassesForm.Classes_Grid.RowCount:=7;
  DataMod.NrOfPolySelected:=0;
  Select_Button.Visible:=false;
  if DataMod.NrOfData>20 then
     Select_Button.Visible:=true;
(*
  if DataMod.PolyData and (DataMod.NrOfIntPoly>20) then
  begin

//      Showmessage ('The number of internal polygons is greater than 20.'+
//                   ' Select minimum 3 and maximum 20 polygons in a'+
//                   ' suitable cross-section in the next table.');

      YesOK:=
      DataMod.Question('The number of internal polygons is greater than 20.'+
      ' Would you prefer to make a selection of polygons in a suitable'+
      ' cross-section');

      if YesOK then
         SelectPolyForm.Show
      else
         Graphics_Tabsheet.Show;
  end else
         Graphics_Tabsheet.Show;
*)

  Graphics_Tabsheet.Show;

end; {TMainForm.SeeGraph_ButtonClick}
{-----------------------------------}



procedure TMainForm.ColorMapButtonClick(Sender: TObject);
{-------------------------------------------------------}
var {Aux : real;} i : integer;
begin
  inherited;
  DataMod.ColorMap:=true;
  Output_TabSheet.Show;
  DataMod.PolyData:=true;
  NetWorkForm.Visible:=false;
  HideColPanels;
  SelectClassesForm.Visible:=false;
  SelectClassesForm.Classes_Grid.ColCount:=2;
  SelectClassesForm.Width:=347;
  SelectClassesForm.Color_Panel.Visible:=false;
  if SoilSal_RadioButton.Checked then
  begin
    if not SelectColumnForm.ColSelected then
    begin
      SelectColumnForm.Visible:=true;
      SelectColumnForm.SoilSal_Panel.Visible:=true;
    end;
  end;
  if SubSal_RadioButton.Checked then
  begin
    if not SelectColumnForm.ColSelected then
    begin
      SelectColumnForm.Visible:=true;
      SelectColumnForm.SubSal_Panel.Visible:=true;
    end;
  end;
  if OtherSal_RadioButton.Checked then
  begin
    if not SelectColumnForm.ColSelected then
    begin
      SelectColumnForm.Visible:=true;
      SelectColumnForm.OtherSal_Panel.Visible:=true;
    end;
  end;
  if AvSal_RadioButton.Checked then
  begin
    SelectClassesForm.Visible:=true;
    TypeSelection_ButtonClick(Sender);
    SearchForData;
    with NetWorkForm do
    begin
      MaxMin;
      Xrel:=abs(Ymax[1]);
      Yrel:=abs(Ymin[1]);
      Limit[1]:=Yrel+(Xrel-Yrel)/7;
      Limit[2]:=Yrel+2*(Xrel-Yrel)/7;
      Limit[3]:=Yrel+3*(Xrel-Yrel)/7;
      Limit[4]:=Yrel+4*(Xrel-Yrel)/7;
      Limit[5]:=Yrel+5*(Xrel-Yrel)/7;
      Limit[6]:=Yrel+6*(Xrel-Yrel)/7;
      SelectClassesForm.Classes_Grid.Cells[1,1]:=
                        format('%4.2f',[Limit[1]]);
      SelectClassesForm.Classes_Grid.Cells[1,2]:=
                        format('%4.2f',[Limit[2]]);
      SelectClassesForm.Classes_Grid.Cells[1,3]:=
                        format('%4.2f',[Limit[3]]);
      SelectClassesForm.Classes_Grid.Cells[1,4]:=
                        format('%4.2f',[Limit[4]]);
      SelectClassesForm.Classes_Grid.Cells[1,5]:=
                        format('%4.2f',[Limit[5]]);
      SelectClassesForm.Classes_Grid.Cells[1,6]:=
                        format('%4.2f',[Limit[6]]);
    end;
  end;
  if DepthWT_RadioButton.Checked then
  begin
    SelectClassesForm.Visible:=true;
    TypeSelection_ButtonClick(Sender);
    SearchForData;
    with NetWorkForm do
    begin
      for i:=0 to DataMod.NrOfData-1 do
          DataMod.Variable[1,i]:=-DataMod.Variable[1,i];
      MaxMin;
      Xrel:=(Ymax[1]);
      Yrel:=(Ymin[1]);
      Limit[1]:=Yrel+(Xrel-Yrel)/7;
      Limit[2]:=Yrel+2*(Xrel-Yrel)/7;
      Limit[3]:=Yrel+3*(Xrel-Yrel)/7;
      Limit[4]:=Yrel+4*(Xrel-Yrel)/7;
      Limit[5]:=Yrel+5*(Xrel-Yrel)/7;
      Limit[6]:=Yrel+6*(Xrel-Yrel)/7;
      SelectClassesForm.Classes_Grid.Cells[1,1]:=
                        format('%4.2f',[Limit[1]]);
      SelectClassesForm.Classes_Grid.Cells[1,2]:=
                        format('%4.2f',[Limit[2]]);
      SelectClassesForm.Classes_Grid.Cells[1,3]:=
                        format('%4.2f',[Limit[3]]);
      SelectClassesForm.Classes_Grid.Cells[1,4]:=
                        format('%4.2f',[Limit[4]]);
      SelectClassesForm.Classes_Grid.Cells[1,5]:=
                        format('%4.2f',[Limit[5]]);
      SelectClassesForm.Classes_Grid.Cells[1,6]:=
                        format('%4.2f',[Limit[6]]);
    end;
  end;
  if SaltSto_RadioButton.Checked then
  begin
    SelectClassesForm.Visible:=true;
    TypeSelection_ButtonClick(Sender);
    SearchForData;
    with NetWorkForm do
    begin
      for i:=0 to DataMod.NrOfData-1 do
          DataMod.Variable[5,i]:=DataMod.Variable[5,i];
      MaxMin;
      Xrel:=(Ymax[1]);
      Yrel:=(Ymin[1]);
      Limit[1]:=Yrel+(Xrel-Yrel)/7;
      Limit[2]:=Yrel+2*(Xrel-Yrel)/7;
      Limit[3]:=Yrel+3*(Xrel-Yrel)/7;
      Limit[4]:=Yrel+4*(Xrel-Yrel)/7;
      Limit[5]:=Yrel+5*(Xrel-Yrel)/7;
      Limit[6]:=Yrel+6*(Xrel-Yrel)/7;
      SelectClassesForm.Classes_Grid.Cells[1,1]:=
                        format('%4.2f',[Limit[1]]);
      SelectClassesForm.Classes_Grid.Cells[1,2]:=
                        format('%4.2f',[Limit[2]]);
      SelectClassesForm.Classes_Grid.Cells[1,3]:=
                        format('%4.2f',[Limit[3]]);
      SelectClassesForm.Classes_Grid.Cells[1,4]:=
                        format('%4.2f',[Limit[4]]);
      SelectClassesForm.Classes_Grid.Cells[1,5]:=
                        format('%4.2f',[Limit[5]]);
      SelectClassesForm.Classes_Grid.Cells[1,6]:=
                        format('%4.2f',[Limit[6]]);
    end;
  end;
  if Evapo_RadioButton.Checked then
  begin
    SelectClassesForm.Visible:=true;
    TypeSelection_ButtonClick(Sender);
    SearchForData;
    with NetWorkForm do
    begin
      MaxMin;
      Xrel:=(Ymax[7]);
      Yrel:=(Ymin[7]);
      Limit[1]:=Yrel+(Xrel-Yrel)/7;
      Limit[2]:=Yrel+2*(Xrel-Yrel)/7;
      Limit[3]:=Yrel+3*(Xrel-Yrel)/7;
      Limit[4]:=Yrel+4*(Xrel-Yrel)/7;
      Limit[5]:=Yrel+5*(Xrel-Yrel)/7;
      Limit[6]:=Yrel+6*(Xrel-Yrel)/7;
      SelectClassesForm.Classes_Grid.Cells[1,1]:=
                        format('%4.2f',[Limit[1]]);
      SelectClassesForm.Classes_Grid.Cells[1,2]:=
                        format('%4.2f',[Limit[2]]);
      SelectClassesForm.Classes_Grid.Cells[1,3]:=
                        format('%4.2f',[Limit[3]]);
      SelectClassesForm.Classes_Grid.Cells[1,4]:=
                        format('%4.2f',[Limit[4]]);
      SelectClassesForm.Classes_Grid.Cells[1,5]:=
                        format('%4.2f',[Limit[5]]);
      SelectClassesForm.Classes_Grid.Cells[1,6]:=
                        format('%4.2f',[Limit[6]]);
    end;
  end;
  if Groundwater_RadioButton.Checked then
  begin
    if not SelectColumnForm.ColSelected then
    begin
      SelectColumnForm.Visible:=true;
      SelectColumnForm.Grwt_Panel.Visible:=true;
    end;
  end;
  if Discharge_RadioButton.Checked then
  begin
    if not SelectColumnForm.ColSelected then
    begin
      SelectColumnForm.Visible:=true;
      SelectColumnForm.Disch_Panel.Visible:=true;
    end;
  end;
  if Percol_RadioButton.Checked then
  begin
    if not SelectColumnForm.ColSelected then
    begin
      SelectColumnForm.Visible:=true;
      SelectColumnForm.Perco_Panel.Visible:=true;
    end;
  end;
  if Capil_RadioButton.Checked then
  begin
    if not SelectColumnForm.ColSelected then
    begin
      SelectColumnForm.Visible:=true;
      SelectColumnForm.Capil_Panel.Visible:=true;
    end;
  end;
  if CanalIrr_RadioButton.Checked then
  begin
    if not SelectColumnForm.ColSelected then
    begin
      SelectColumnForm.Visible:=true;
      SelectColumnForm.Irr_Panel.Visible:=true;
    end;
  end;
  if IrrEff_RadioButton.Checked then
  begin
    if not SelectColumnForm.ColSelected then
    begin
      SelectColumnForm.Visible:=true;
      SelectColumnForm.Eff_Panel.Visible:=true;
    end;
  end;
  if CropArea_RadioButton.Checked then
  begin
    if not SelectColumnForm.ColSelected then
    begin
      SelectColumnForm.Visible:=true;
      SelectColumnForm.Area_Panel.Visible:=true;
    end;
  end;

  if SelectColumnForm.ColSelected then
  begin
    SelectColumnForm.ColSelected:=false;
    TypeSelection_ButtonClick(Sender);
    SearchForData;
    SelectClassesForm.Visible:=true;
    with NetWorkForm do
    begin
      MaxMin;
      if (Ymax[DataMod.ColNr]=-1000000) or (Ymin[DataMod.ColNr]=1000000) then
      begin
        Ymax[DataMod.ColNr]:=7;
        Ymin[DataMod.ColNr]:=0;
      end;
      if MainForm.SaltSto_RadioButton.Checked then DataMod.ColNr:=5;
      if MainForm.Evapo_RadioButton.Checked then DataMod.ColNr:=7;
      if DataMod.ColNr=0 then DataMod.ColNr:=1;  {TEMPORARY !!!!!!!}
      Xrel:=abs(Ymax[DataMod.ColNr]);
      Yrel:=abs(Ymin[DataMod.ColNr]);
      Limit[1]:=Yrel+(Xrel-Yrel)/7;
      Limit[2]:=Yrel+2*(Xrel-Yrel)/7;
      Limit[3]:=Yrel+3*(Xrel-Yrel)/7;
      Limit[4]:=Yrel+4*(Xrel-Yrel)/7;
      Limit[5]:=Yrel+5*(Xrel-Yrel)/7;
      Limit[6]:=Yrel+6*(Xrel-Yrel)/7;
      SelectClassesForm.Classes_Grid.Cells[1,1]:=
                        format('%4.2f',[Limit[1]]);
      SelectClassesForm.Classes_Grid.Cells[1,2]:=
                        format('%4.2f',[Limit[2]]);
      SelectClassesForm.Classes_Grid.Cells[1,3]:=
                        format('%4.2f',[Limit[3]]);
      SelectClassesForm.Classes_Grid.Cells[1,4]:=
                        format('%4.2f',[Limit[4]]);
      SelectClassesForm.Classes_Grid.Cells[1,5]:=
                        format('%4.2f',[Limit[5]]);
      SelectClassesForm.Classes_Grid.Cells[1,6]:=
                        format('%4.2f',[Limit[6]]);
    end;
  end;
end; {ColorMapButtonClick}
{------------------------}


procedure TMainForm.Output_TabSheetExit(Sender: TObject);
{-------------------------------------------------------}
begin
  inherited;
  MappingForm.Hide;

end; {TMainForm.Output_TabSheetExit}
{----------------------------------}


{******************************************************************************
 End of Output tabsheet, start of Graphics Tabsheet
*******************************************************************************}



procedure TMainForm.Graphics_TabSheetShow(Sender: TObject);
{---------------------------------------------------------}
begin
  inherited;
  InputSave_Button.Caption:='Save general input';
  StatusText('Enter data or use "Open input" to see examples in any' +
             ' folder or to edit existing files. Thereafter use' +
             ' "Save general input".');
  BackToInputButton.Enabled := GoToInput_Button.Enabled;
  Statustext ('Graphics presentations of output data can be seen and saved.'+
              ' Use "Open output" to open a new output file and make graphs.');
  if GroupOpened then
  begin
    GraphOpened := true;
    GraphShowSymbols_Button.Enabled := true;
    Graphics_Image.Visible := true;
    SaveGraph_Button.Enabled:=true;
    ColorMapButton.Visible := true;
    SeeGraph_Button.Enabled := true;
    GraphSalt_Image.Visible := false;
    GroupOpened:=false;
    ShowGraphics;
  end else
  begin
    BackToInputButton.Visible := false;
    ColorMapButton.Visible := false;
    GraphShowSymbols_Button.Visible := false;
    Graphics_Image.Visible := false;
    SaveGraph_Button.Visible := false;
    Select_Button.Visible:=false;
    GraphSalt_Image.Visible := true;
  end;
end; {TMainForm.Graphics_TabSheetShow}
{------------------------------------}



procedure TMainForm.ShowGraphics;
{-------------------------------}
var Count, ii, jj, kk, Score : integer;
    DumReal : real; NameStr  : string;
    ScalarY, DecimalY        : integer;
    MaximY, MinimY           : longint;
    HlpInt, Middle, Serial   : integer;
    NrOfNode                 : array of integer;
    SelectedNrOfPoly         : integer;
begin
  inherited;
  GraphSave.Enabled := true;
    GraphShowSymbols_Button.Enabled := true;
    Graphics_Image.Visible := true;
    SaveGraph_Button.Enabled:=true;
    ColorMapButton.Visible := true;
    SeeGraph_Button.Enabled := true;
    BackToInputButton.Visible:=true;
    SaveGraph_Button.Visible:=true;
    GraphShowSymbols_button.Visible:=true;
    if DataMod.NrOfIntPoly>20 then Select_Button.Visible:=true;
    GraphSalt_Image.Visible := false;
  if (DataMod.GroupMark='EaU') and not PosValues[7] then
  begin
    Showmessage ('Only zero data present. Graph is not made');
    SeeGraph_Button.Enabled := true;
    SaveGroup_Button.Enabled := true;
    Graphics_Image.Visible := false;
    exit;
  end;
  if (DataMod.GroupMark='Zs') and not PosValues[5] then
  begin
    Showmessage ('Only zero data present. Graph is not made');
    SeeGraph_Button.Enabled := true;
    SaveGroup_Button.Enabled := true;
    Graphics_Image.Visible := false;
    exit;
  end;
  NumberWanted:=DataMod.NrOfIntPoly;
(*
  if DataMod.PolyData then if DataMod.NrOfIntPoly>20 then with DataMod do
  begin
    if NrOfPolySelected=0 then exit;
    NumberWanted:=NrOfPolySelected;
    NrOfData:=NumberWanted;
  end;
*)
// if NrOfPolySelected>0 then NumberWanted:=NrOfPolySelected;
 if DataMod.NrOfPolySelected>0 then NumberWanted:=DataMod.NrOfPolySelected;

  MaxMin;
  Scaling;
  Relative;

  with Graphics_Image.Canvas do with DataMod do
  begin

    Brush.Color := clWhite;
    FillRect(Graphics_Image.Canvas.ClipRect);
    Font.Style := [fsBold];
    Font.Color := clTeal;      {for the titles}
    Textout (120,5,GrTitle2);
    Textout (120,20,GrTitle3);
    Brush.Color := $00f5fffa;
    Font.Color := clMaroon;     {for the text}
    Pen.Color := clBlue;        {for the lines}

    MaximY:=0;
    MinimY:=1000000;
    ScalarY := 10;
    DecimalY := 1;

//Maxima and minima

    if (GroupMark<>'Dw') and (GroupMark<>'Zs') and
       (GroupMark<>'EaU') and (GroupMark<>'AvC') then
    begin
       Count:=0;
       for ii:=1 to NrOfitems do if PosValues[ii] then
       begin
         Count:=Count+1;
         if MaximY<MaxY[ii] then
         begin
           MaximY:=MaxY[ii];
           ScalarY:=ScaleY[ii];
           DecimalY:=DecimY[ii];
         end;
         if MinimY>MinY[ii] then
            MinimY:=MinY[ii];
       end;
       if Count=0 then
       begin
         Showmessage ('Only zero data present. Graph is not made');
         Graphics_Image.Visible := false;
         exit;
       end;
    end;

    if GroupMark='Zs' then
    begin
      MaximY:=MaxY[5];
      MinimY:=MinY[5];
      ScalarY:=ScaleY[5];
      DecimalY:=DecimY[5];
    end; {if GroupMark='Zs' then}

    if GroupMark='AvC' then
    begin
      MaximY:=MaxY[3];
      MinimY:=MinY[3];
      ScalarY:=ScaleY[3];
      DecimalY:=DecimY[3];
    end; {if GroupMark='AvC' then}

    if GroupMark='Dw' then
    begin
      MaximY:=MaxY[1];
      MinimY:=MinY[1];
      ScalarY:=ScaleY[1];
      DecimalY:=DecimY[1];
    end; {if GroupMark='Dw' then}

    if (GroupMark='FfA') or (GroupMark='A') then
    begin
      MaximY:=120;
      MinimY:=0;
      ScalarY:=6;
    end;

    if GroupMark='EaU' then
    begin
      MaximY:=MaxY[7];
      MinimY:=MinY[7];
      ScalarY:=ScaleY[7];
      DecimalY:=DecimY[7];
    end; {if GroupMark='EaU' then}

// Y and X axes

    HlpInt:=0;
    if (GroupMark='FfA') or (GroupMark='A') then HlpInt:=1;
    for ii:=HlpInt to ScalarY do                         { vertical axis }
    begin
      Moveto (posX1,round(posY1+(ii/ScalarY)*LY));
      Lineto (posX1-4, round(posY1+(ii/ScalarY)*LY));
      DumReal := ii/ScalarY*(MaximY-MinimY);
      NameStr := format('%' + IntToStr(2 + DecimalY) + '.' +
                 IntToStr(DecimalY) + 'f', [MaximY - DumReal]);
          {bijv. '%3.1f' voor 1 decimaal, 3 cijfers, float number}
      Textout ((posX1-TextWidth(NameStr)-6),
        (round(posY1+(ii/ScalarY)*LY)-round(1/2*TextHeight(NameStr))),
                                                             NameStr);
      if (GroupMark='Dw') and (ii=ScalarY) then
         Textout ((posX1-TextWidth(NameStr)-6),
         (round(posY1+(ii/ScalarY)*LY)-round(1/2*TextHeight(NameStr))),
                                                            NameStr);
    end; {for ii:=0 to ScalarY do}

    Count:=-1;                                           {horizontal axis}
    if not PolyData then
    begin
      TextOut(PosX1-5,PosY2+10,'0');
      TextOut(625,PosY2+25,'Year');
    end else
      TextOut(625,PosY2+25,'Polygon');
    Middle:=(RelXdata[1]-RelXdata[0]) div 2;
    if not PolyData then
    begin
      for jj:=0 to NrOfYears do for ii:=1 to NrOfSeasons do
      begin
        Count:=Count+1;
        if ii=NrOfSeasons then
        begin
          TextOut (RelXdata[Count]-5,PosY2+10,IntToStr(jj+1));
          Moveto (RelXdata[Count], PosY2);
          Lineto (RelXdata[Count], PosY2+6);
        end;
      end;
    end else
    begin
      setlength (NrOfNode,NumberWanted+1);
      if NumberWanted<DataMod.NrOfIntPoly then
         for jj:=0 to NumberWanted-1 do
             NrOfNode[jj]:=PolySelected[jj]
      else
      begin
        setlength (DataMod.NodeNr,NumberWanted+1);
        for jj:=0 to NumberWanted-1 do
            NrOfNode[jj]:=DataMod.NodalNr[jj];
      end;
      if NumberWanted<=20 then
      for jj:=0 to NumberWanted-1 do
      begin
        TextOut (RelXdata[jj]-5+Middle,PosY2+10,IntToStr(NrOfNode[jj]));
        Moveto (RelXdata[jj]+Middle,PosY2);
        Lineto (RelXdata[jj]+Middle,PosY2+4);
      end;
      if NumberWanted>20 then
      for jj:=0 to NumberWanted-1 do
      if jj mod 10 = 0 then if jj>0 then
      begin
        TextOut (RelXdata[jj-1]-5+Middle,PosY2+10,IntToStr(NrOfNode[jj-1]));
        Moveto (RelXdata[jj-1]+Middle,PosY2);
        Lineto (RelXdata[jj-1]+Middle,PosY2+4);
      end;
    end; {if not PolyData then else}

//Graph texts and plots

    if (GroupMark='CrA') or (GroupMark='Cxf') or (GroupMark='Cti') then
    begin
      Score:=0;                                 {plotting of legends and lines}
      if GroupMark='CrA' then
      TextOut (PosX1+10,PosY1-15,'Soil salinity, EC in dS/m');
      if GroupMark='Cxf' then
      TextOut (PosX1+10,PosY1-15,'Subsoil salinities, EC in dS/m');
      if GroupMark='Cti' then
      TextOut (PosX1+10,PosY1-15,'Other salinities, EC in dS/m');
      Font.Style := [];
      if GroupMark='CrA' then
      TextOut (290,40,'Only applicable values are shown depending'+
                      ' on the value of rotation key Kr')
      else if GroupMark='Cxf' then
      TextOut (290,40,'Only applicable values are shown depending'+
                      ' on the value of drainage key Kd')
      else
      TextOut (290,35,'Only applicable values are shown depending'+
                      ' on the operation of drains/wells');

      Font.Style:= [fsBold];
      Pen.Width := 2;
      for ii:=1 to NrOfitems do if PosValues[ii] then
      begin
        Count:=0;
        Score:=Score+1;
        if ii=1 then
        begin
          Pen.Color := clBlue;
          Font.Color := clBlue;
          if GroupMark='CrA' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'CrA')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'CrA*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'CrA*100');
          end;
          if GroupMark='Cxf' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cxf')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cxf*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cxf*100');
          end;
          if GroupMark='Cti' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cti')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cti*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cti*100');
          end;
        end; {if ii=1 then}
        if ii=2 then
        begin
          Pen.Color := clGreen;
          Font.Color:= clGreen;
          if GroupMark='CrA' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'CrB')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'CrB*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'CrB*100');
          end;
          if GroupMark='Cxf' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cxa')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cxa*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cxa*100');
          end;
          if GroupMark='Cti' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cqi')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cqi*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cqi*100');
          end;
        end; {if ii=2 then}
        if ii=3 then
        begin
          Pen.Color := clRed;
          Font.Color:= clRed;
          if GroupMark='CrA' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'CrU')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'CrU*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'CrU*100');
          end;
          if GroupMark='Cxf' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cxb')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cxb*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cxb*100');
          end;
          if GroupMark='Cti' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Ci')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Ci*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Ci*100');
          end;
        end; {if ii=3 then}
        if ii=4 then
        begin
          Pen.Color := clLime;
          Font.Color:= clLime;
          if GroupMark='CrA' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cr4')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cr4*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cr4*100');
          end;
          if GroupMark='Cxf' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cqf')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cqf*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cqf*100');
          end;
          if GroupMark='Cti' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cd')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cd*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cd*100');
          end;
        end; {if ii=4 then}
        if ii=5 then
        begin
          Pen.Color := clSilver;
          Font.Color:= clSilver;
          if GroupMark='CrA' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'C0*')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'C0*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'C0*100');
          end;
          if GroupMark='Cti' then
          begin
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cw')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cw*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Cw*100');
          end;
        end; {if ii=5 then}
        if ii=6 then
        begin
          Pen.Color := clFuchsia;
          Font.Color:= clFuchsia;
          if FactorY[ii]=1 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'C1*')
          else
          if FactorY[ii]=10 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'C1*10')
          else
          if FactorY[ii]=100 then
              TextOut (PosX1+15+60*(Score-1),PosY1,'C1*100');
        end; {if ii=6 then}
        if ii=7 then
        begin
          Pen.Color := $008AD5FD;
          Font.Color:= $008AD5FD;
          if FactorY[ii]=1 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'C2*')
          else
          if FactorY[ii]=10 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'C2*10')
          else
          if FactorY[ii]=100 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'C2*100');
        end; {if ii=7 then}
        if ii=8 then
        begin
          Pen.Color := clMaroon;
          Font.Color:= clMaroon;
          if FactorY[ii]=1 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'C3*')
          else
          if FactorY[ii]=10 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'C3*10')
          else
          if FactorY[ii]=100 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'C3*100');
        end; {if ii=8 then}

        if (GroupMark='CrA') or (GroupMark='Cxf') then
        begin
          if not PolyData then
          begin
            for jj:=0 to NrOfYears do
               for kk:=1 to NrOfSeasons do
               begin
                 Count:=Count+1;
                 if (Count<NrOfData) then
                 begin
                   Moveto (RelXdata[Count-1],RelYdata[ii,Count-1]);
                   Lineto (RelXdata[Count],RelYdata[ii,Count]);
                 end;
               end;
          end else
          begin
            for jj:=0 to NumberWanted-1 do
            if jj<NumberWanted-1 then
            begin
              if RelYdata[ii,jj]<370 then
              begin
                Moveto (RelXdata[jj],RelYdata[ii,jj]);
                Lineto (RelXdata[jj+1],RelYdata[ii,jj]);
              end;
            end else
            begin
              Moveto (RelXdata[jj],RelYdata[ii,jj]);
              Lineto (RelXdata[jj]+2*Middle,RelYdata[ii,jj]);
            end;
          end; {if not PolyData then else}
        end; {if (GroupMark='CrA') or (GroupMark='Cxf') then}

        if GroupMark='Cti' then
        begin
          Serial:=ii;
          FillGraphics (Count,Middle,Serial);
        end; { if GroupMark='Cti' then }
      end; {for ii:=1 to NrOfitems do }
      Pen.Width := 1;
      Pen.Color := clBlue;
      Font.Color := clMaroon;     {for the text}
    end; {if (GroupMark='CrA') or (GroupMark='Cxf') or (GroupMark='Cti') then}

    if (GroupMark='Zs') then
    begin
      Pen.Color := clNavy;
      Font.Color:= clNavy;
      Count:=0;
      TextOut (PosX1+10,PosY1-15,'Salt storage Zs in m.dS/m');
      if FactorY[6]=1 then
         TextOut (PosX1+15,PosY1,'Zs')
      else
      if FactorY[6]=10 then
         TextOut (PosX1+15,PosY1,'Zs*10')
      else
      if FactorY[6]=100 then
         TextOut (PosX1+15,PosY1,'Zs*100');
      Serial:=5;
      FillGraphics (Count,Middle,Serial);
      Font.Color := clMaroon;     {for the text}
    end;{if GroupMark='Zs' then}

    if (GroupMark='Gti') then
    begin
      Score:=0;                                 {plotting of legends and lines}
      TextOut (PosX1+10,PosY1-15,'Groundwater flow, m/season');
      Font.Style := [];
      TextOut (290,40,'Only applicable values are shown');
      Font.Style:= [fsBold];
      Pen.Width := 2;
      for ii:=1 to NrOfitems do if PosValues[ii] then
      begin
        Count:=0;
        Score:=Score+1;
        if ii=1 then
        begin
          Pen.Color := clBlue;
          Font.Color := clBlue;
          if FactorY[ii]=1 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gti')
          else
          if FactorY[ii]=10 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gti*10')
          else
          if FactorY[ii]=100 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gti*100');
          if FactorY[ii]=1000 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gti*1000');
        end; {if ii=1 then}
        if ii=2 then
        begin
          Pen.Color := clGreen;
          Font.Color:= clGreen;
          if FactorY[ii]=1 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gto')
          else
          if FactorY[ii]=10 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gto*10')
          else
          if FactorY[ii]=100 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gto*100');
          if FactorY[ii]=1000 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gto*1000');
        end; {if ii=2 then}
        if ii=3 then
        begin
          Pen.Color := clRed;
          Font.Color:= clRed;
          if FactorY[ii]=1 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gtv')
          else
          if FactorY[ii]=10 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gtv*10')
          else
          if FactorY[ii]=100 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gtv*100');
          if FactorY[ii]=1000 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gtv*1000');
        end; {if ii=3 then}
        if ii=4 then
        begin
          Pen.Color := clLime;
          Font.Color:= clLime;
             if FactorY[ii]=1 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Gqi')
             else
             if FactorY[ii]=10 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Gqi*10')
             else
             if FactorY[ii]=100 then
                TextOut (PosX1+15+60*(Score-1),PosY1,'Gqi*100');
          if FactorY[ii]=1000 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gqi*1000');
        end; {if ii=4 then}
        if ii=5 then
        begin
          Pen.Color := clMaroon;
          Font.Color:= clMaroon;
          if FactorY[ii]=1 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gqo')
          else
          if FactorY[ii]=10 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gqo*10')
          else
          if FactorY[ii]=100 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gqo*100');
          if FactorY[ii]=1000 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gqo*1000');
        end; {if ii=5 then}
        if ii=6 then
        begin
          Pen.Color := clFuchsia;
          Font.Color:= clFuchsia;
          if FactorY[ii]=1 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gaq')
          else
          if FactorY[ii]=10 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gaq*10')
          else
          if FactorY[ii]=100 then
              TextOut (PosX1+15+60*(Score-1),PosY1,'Gaq*100');
          if FactorY[ii]=1000 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gaq*1000');
        end; {if ii=6 then}
        if ii=7 then
        begin
          Pen.Color := clBlack;
          Font.Color:= clBlack;
          if FactorY[ii]=1 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gnt')
          else
          if FactorY[ii]=10 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gnt*10')
          else
          if FactorY[ii]=100 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gnt*100');
          if FactorY[ii]=1000 then
             TextOut (PosX1+15+60*(Score-1),PosY1,'Gnt*1000');
        end; {if ii=7 then}
        Serial:=ii;
        FillGraphics (Count,Middle,Serial);
      end; {for ii:=1 to NrOfitems do}
      Pen.Width := 1;
      Pen.Color := clBlue;
      Font.Color := clMaroon;     {for the text}
    end; {if GroupMark='Gti' then}

    if (GroupMark='Gd') or (GroupMark='A') then
    begin
      if (GroupMark='Gd') then
         TextOut (PosX1+10,PosY1-15,'Drain/well discharge (m/season)');
      if (GroupMark='A') then
         TextOut (PosX1+10,PosY1-15,'Area fractions (%)');
      Font.Style := [];
      TextOut (293,45,'Only applicable values are shown depending'+
                      ' on the parameter values employed');
      Font.Style:= [fsBold];
      Score:=0;
      for ii:=1 to NrOfitems do if PosValues[ii] then
      begin
        Count:=0;
        Score:=Score+1;
        if ii=1 then
        begin
          Pen.Color := clBlue;
          Font.Color := clBlue;
          if GroupMark='Gd' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,' Gd')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
            TextOut (PosX1+15+60*(Score-1),PosY1,'Gd*'+NameStr);
            end;
          end else
            TextOut (PosX1+15+60*(Score-1),PosY1,'A');
        end;
        if ii=2 then
        begin
          Pen.Color := clRed;
          Font.Color:= clRed;
          if GroupMark='Gd' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'Ga')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'Ga*'+NameStr);
            end;
            end else
              TextOut (PosX1+15+60*(Score-1),PosY1,'B');
        end;
        if ii=3 then
        begin
          Pen.Color := clGreen;
          Font.Color:= clGreen;
          if GroupMark='Gd' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'Gb')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'Gb*'+NameStr);
            end;
          end else
              TextOut (PosX1+15+60*(Score-1),PosY1,'U');
        end;
        if ii=4 then
        begin
          Pen.Color := clPurple;
          Font.Color:= clPurple;
          if GroupMark='Gd' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'Gw')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'Gw*'+NameStr);
            end;
          end else
            TextOut (PosX1+15+60*(Score-1),PosY1,'Uc');
        end;
        Serial:=ii;
        FillGraphics (Count,Middle,Serial);
      end; {for ii:=1 to NrOfitems do}
      Pen.Color := clBlue;
      Font.Color := clMaroon;     {for the text}
    end;{ if (GroupMark='Gd') or (GroupMark='A') then }

    if (GroupMark='Dw') then
    begin
      Pen.Color := clNavy;
      Font.Color:= clNavy;
      if FactorY[1]=1 then
         TextOut (PosX1+10,PosY1-20,'Dw')
      else
      begin
        NameStr:=IntToStr(FactorY[1]);
        TextOut (PosX1+10,PosY1-20,'Dw*'+NameStr);
      end;
      Count:=0;
      if not PolyData then
      begin
        for jj:=0 to NrOfYears do
          for kk:=1 to NrOfSeasons do
          begin
            Count:=Count+1;
            if kk=1 then Brush.Color := clOlive;
            if kk=2 then Brush.Color := clSilver;
            if kk=3 then Brush.Color := clYellow;
            if kk=4 then Brush.Color := clRed;
            if (Count<DataMod.NrOfData) then
            begin
              HlpInt:=PosY2-round(LY*(0-MinY[1])/(MaxY[1]-MinY[1]));
              if abs(HlpInt-RelYdata[1,Count])<3 then
                 RelYdata[1,Count]:=RelYdata[1,Count]-3;
              Fillrect (Rect(RelXdata[Count-1],RelYdata[1,Count],
                        RelXdata[Count],HlpInt));
            end;
          end;
      end else
      begin
        for jj:=1 to NumberWanted do
        begin
          if jj mod 2 = 0 then Brush.Color := clOlive
          else Brush.Color := clSilver;
          HlpInt:=PosY2-round(LY*(0-MinY[1])/(MaxY[1]-MinY[1]));
          if abs(HlpInt-RelYdata[1,jj-1])<3 then
             RelYdata[1,jj-1]:=RelYdata[1,jj-1]+3;
          if jj<NumberWanted then
             Fillrect (Rect(RelXdata[jj-1],HlpInt,
                       RelXdata[jj],RelYdata[1,jj-1]))
          else
             Fillrect (Rect(RelXdata[jj-1],HlpInt,
                         RelXdata[jj-1]+2*Middle,RelYdata[1,jj-1]));
        end; {for jj:=1 to NumberWanted do}
      end; {if not PolyData then else then}
      Brush.Color := $00f5fffa;
      Font.Color := clMaroon;     {for the text}
      Pen.Color := clBlue;
    end;{if GroupMark='Dw' then }

    if (GroupMark='LrA') or (GroupMark='RrA') then
    begin
      Score:=0;                                   {plotting of lines}
      if GroupMark='LrA' then
      TextOut (PosX1+10,PosY1-15,'Pecolation in m/season');
      if GroupMark='RrA' then
      TextOut (PosX1+10,PosY1-15,'Capillary rise in m/season');
      Font.Style := [];
      TextOut (300,45,'Only applicable values are shown depending'+
                      ' on the parameter values given');
      Font.Style:= [fsBold];
      for ii:=1 to NrOfitems do if PosValues[ii] then
      begin
        Count:=0;
        Score:=Score+1;
        if ii=1 then
        begin
          Pen.Color := clBlue;
          Font.Color := clBlue;
          if GroupMark='LrA' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'LrA')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'LrA*'+NameStr);
            end;
          end;
          if GroupMark='RrA' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'RrA')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'RrA*'+NameStr);
            end;
          end;
        end;
        if ii=2 then
        begin
          Pen.Color := clGreen;
          Font.Color:= clGreen;
          if GroupMark='LrA' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'LrB')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'LrB*'+NameStr);
            end;
          end;
          if GroupMark='RrA' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'RrB')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'RrB*'+NameStr);
            end;
          end;
        end;
        if ii=3 then
        begin
          Pen.Color := clRed;
          Font.Color:= clRed;
          if GroupMark='LrA' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'LrU')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'LrU*'+NameStr);
            end;
          end;
          if GroupMark='RrA' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'RrU')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'RrU*'+NameStr);
            end;
          end;
        end;
        if ii=4 then
        begin
          Pen.Color := clLime;
          Font.Color:= clLime;
          if GroupMark='LrA' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'LrAve')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'LrAve*'+NameStr);
            end;
          end;
          if GroupMark='RrA' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'RrAve')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'RrAve*'+NameStr);
            end;
          end;
        end;
        Serial:=ii;
        FillGraphics (Count,Middle,Serial);
      end; {for ii:=1 to NrOfitems do}
      Pen.Color := clBlue;
      Font.Color := clMaroon;     {for the text}
    end; {if (GroupMark='LrA') or (GroupMark='RrA') then}

    if (GroupMark='It') or (GroupMark='FfA') then
    begin
      Score:=0;                                   {plotting of lines}
      if GroupMark='It' then
         TextOut (PosX1+10,PosY1-15,'Irrigation data in m/season')
      else
         TextOut (PosX1+10,PosY1-15,'Efficiency/sufficiency in %');
      Font.Style := [];
      TextOut (300,45,'Only applicable values are shown depending'+
                      ' on the parameter values given');
      Font.Style:= [fsBold];
      for ii:=1 to NrOfitems do if PosValues[ii] then
      begin
        Count:=0;
        Score:=Score+1;
        if ii=1 then
        begin
          Pen.Color := clGreen;
          Font.Color := clGreen;
          if GroupMark='It' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'It')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'It*'+NameStr);
            end;
          end else
              TextOut (PosX1+15+60*(Score-1),PosY1,'FfA')
        end;
        if ii=2 then
        begin
          Pen.Color := clFuchsia;
          Font.Color:= clFuchsia;
          if GroupMark='It' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'Is')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'Is*'+NameStr);
            end;
          end else
              TextOut (PosX1+15+60*(Score-1),PosY1,'FfB')
        end;
        if ii=3 then
        begin
          Pen.Color := clRed;
          Font.Color:= clRed;
          if GroupMark='It' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'IaA')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'IaA*'+NameStr);
            end;
          end else
              TextOut (PosX1+15+60*(Score-1),PosY1,'FfT')
        end;
        if ii=4 then
        begin
          Pen.Color := clBlue;
          Font.Color:= clBlue;
          if GroupMark='It' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'IaB')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'IaB*'+NameStr);
            end;
          end else
              TextOut (PosX1+15+60*(Score-1),PosY1,'JsA')
        end;
        if ii=5 then
        begin
          Pen.Color := clMaroon;
          Font.Color:= clMaroon;
          if FactorY[ii]=1 then
          if GroupMark='It' then
          begin
            if FactorY[ii]=1 then
               TextOut (PosX1+15+60*(Score-1),PosY1,'Io')
            else
            begin
              NameStr:=IntToStr(FactorY[ii]);
              TextOut (PosX1+15+60*(Score-1),PosY1,'Io*'+NameStr);
            end;
          end else
              TextOut (PosX1+15+60*(Score-1),PosY1,'JsB')
        end;
        Serial:=ii;
        FillGraphics (Count,Middle,Serial);
      end; {for ii:=1 to NrOfitems do}
      Pen.Color := clBlue;
      Font.Color := clMaroon;     {for the text}
    end; {if (GroupMark='It') or (GroupMark='FfA') then}

    if GroupMark='EaU' then
    begin
      if PolyData then
      begin
        Pen.Color := clSilver;
        for jj:=0 to NrOfIntPoly-1 do
        begin
          Moveto (RelXdata[jj],PosY2);
          Lineto (RelXdata[jj],PosY1);
        end;
      end;
      Pen.Color := clNavy;
      Font.Color:= clNavy;
      Count:=0;
      TextOut (PosX1+10,PosY1-15,'Actual evaporation from unirrigated land,'+
                                 ' m/season');
      if FactorY[7]=1 then
         TextOut (PosX1+15,PosY1,'EaU')
      else
      if FactorY[7]=10 then
         TextOut (PosX1+15,PosY1,'EaU*10')
      else
      if FactorY[7]=100 then
         TextOut (PosX1+15,PosY1,'EaU*100');
      if not PolyData then
      begin
        for jj:=0 to NrOfYears do
          for kk:=1 to NrOfSeasons do
          begin
            Count:=Count+1;
            if Count<NrOfData then
            begin
              Moveto (RelXdata[Count-1],RelYdata[7,Count-1]);
              Lineto (RelXdata[Count-1],RelYdata[7,Count]);
              Moveto (RelXdata[Count-1],RelYdata[7,Count]);
              Lineto (RelXdata[Count],RelYdata[7,Count]);
            end;
          end;
      end else
      begin
        for jj:=0 to NumberWanted-1 do
        if jj<NumberWanted-1 then
        begin
          Moveto (RelXdata[jj],RelYdata[7,jj]);
          Lineto (RelXdata[jj+1],RelYdata[7,jj]);
        end else
        begin
          Moveto (RelXdata[jj],RelYdata[7,jj]);
          Lineto (RelXdata[jj]+2*Middle,RelYdata[7,jj]);
        end;
      end; {if not PolyData then else then}
      Font.Color := clMaroon;     {for the text}
    end;{if GroupMark='EaU' then}

    if GroupMark='AvC' then
    begin
      if PolyData then
      begin
        Pen.Color := clSilver;
        for jj:=0 to NumberWanted-1 do
        begin
          Moveto (RelXdata[jj],PosY2);
          Lineto (RelXdata[jj],PosY1);
        end;
      end;
      Pen.Color := clNavy;
      Font.Color:= clNavy;
      Count:=0;
      TextOut (PosX1+10,PosY1-15,'Average soil salinity, AvC, '+
                                 ' dS/m');
      if FactorY[7]=1 then
         TextOut (PosX1+15,PosY1,'AvC')
      else
      if FactorY[7]=10 then
         TextOut (PosX1+15,PosY1,'AvC*10')
      else
      if FactorY[7]=100 then
         TextOut (PosX1+15,PosY1,'AvC*100');
      if not PolyData then
      begin
        for jj:=0 to NrOfYears do
          for kk:=1 to NrOfSeasons do
          begin
            Count:=Count+1;
            if kk=1 then Brush.Color := clOlive;
            if kk=2 then Brush.Color := clSilver;
            if kk=3 then Brush.Color := clYellow;
            if kk=4 then Brush.Color := clRed;
            if Count<NrOfData then
            begin
              Fillrect (Rect(RelXdata[Count-1],RelYdata[3,Count],
                        RelXdata[Count],PosY2));
//              Moveto (RelXdata[Count-1],RelYdata[3,Count-1]);
//              Lineto (RelXdata[Count-1],RelYdata[3,Count]);
//              Moveto (RelXdata[Count-1],RelYdata[3,Count]);
//              Lineto (RelXdata[Count],RelYdata[3,Count]);
            end;
          end;
      end else
      begin
        for jj:=0 to NumberWanted-1 do
        begin
          if jj mod 2 = 0 then Brush.Color := clOlive
          else Brush.Color := clSilver;
        if jj<NumberWanted-1 then
        begin
          Fillrect (Rect(RelXdata[jj],RelYdata[3,jj],
                    RelXdata[jj+1],PosY2));
//          Moveto (RelXdata[jj],RelYdata[3,jj]);
//          Lineto (RelXdata[jj+1],RelYdata[3,jj]);
        end else
        begin
          Fillrect (Rect(RelXdata[jj],RelYdata[3,jj],
                    RelXdata[jj]+2*Middle,PosY2));
//          Moveto (RelXdata[jj],RelYdata[3,jj]);
//          Lineto (RelXdata[jj]+2*Middle,RelYdata[3,jj]);
        end;
        end;
      end; {if not PolyData then else then}
      Brush.Color := $00f5fffa;
      Font.Color := clMaroon;     {for the text}
      Pen.Color := clBlue;
    end;{if GroupMark='AvC' then}

    moveto (PosX1,PosY2+4);                              {Axis lines}
    lineto (PosX1,PosY1);
    moveto (PosX1,PosY2);
    lineto (PosX2,PosY2);
    if PolyData then                                   {Grid lines}
    begin
      Pen.Color := clSilver;
      SelectedNrOfPoly:=NrOfIntPoly;
      if NrOfIntPoly>20 then SelectedNrOfPoly:=NrOfPolySelected;
      for jj:=0 to SelectedNrOfPoly-1 do
      begin
        Moveto (RelXdata[jj],PosY2);
        Lineto (RelXdata[jj],PosY1+20);
      end;
    end;
    Font.Color := clBlack;     {for the text}
    TextOut (70,PosY2+60,'SahysMod: ' + GrTitle1+' '+GrTitle4);
    Font.Color := clMaroon;     {for the text}

  end; {With Graphics_Image.Canvas do with DataMod do}
  for ii:=Start to HlpNr do for jj:=0 to DataMod.NrOfData-1 do
      DataMod.Variable[ii,jj]:=DataMod.Variable[ii,jj]/FactorY[ii];
end; {TMainForm.ShowGraphics}
{---------------------------}



procedure TMainForm.FillGraphics (var Sum, Mid, Nr : integer);
{-----------------------------------------------------------}
Var jj, kk, HlpInt : integer;
begin
  with Graphics_Image.Canvas do with DataMod do
  begin
          if not PolyData then
          begin
            for jj:=0 to NrOfYears do
               for kk:=1 to NrOfSeasons do
               begin
                 HlpInt:=2*(Nr-1);
                 Sum:=Sum+1;
                 if (Sum<NrOfData) then
                 begin
                 Moveto(RelXdata[Sum-1]+HlpInt,RelYData[Nr,Sum-1]-HlpInt);
                 Lineto (RelXdata[Sum-1]+HlpInt,RelYdata[Nr,Sum]-HlpInt);
                 Moveto(RelXdata[Sum-1]+HlpInt,RelYdata[Nr,Sum]-HlpInt);
                 Lineto (RelXdata[Sum]+HlpInt,RelYdata[Nr,Sum]-HlpInt);
                 end;
               end;
          end else
          begin
            for jj:=0 to NumberWanted-1 do
            begin
              HlpInt:=2*(Nr-1);
              if jj<NumberWanted-1 then
              begin
                Moveto (RelXdata[jj],RelYdata[Nr,jj]-HlpInt);
                Lineto (RelXdata[jj+1],RelYdata[Nr,jj]-HlpInt);
              end else
              begin
                Moveto (RelXdata[jj],RelYdata[Nr,jj]-HlpInt);
                Lineto (RelXdata[jj]+2*Mid,RelYdata[Nr,jj]-HlpInt);
              end;
            end;
          end; {if not PolyData then else then}
  end; {with DataMod do}
end; {FillGraphics}
{-----------------}


procedure TMainForm.HideColPanels;
begin
  SelectColumnForm.SoilSal_Panel.Visible:=false;
  SelectColumnForm.SubSal_Panel.Visible:=false;
  SelectColumnForm.OtherSal_Panel.Visible:=false;
  SelectColumnForm.Grwt_Panel.Visible:=false;
  SelectColumnForm.Disch_Panel.Visible:=false;
  SelectColumnForm.Perco_Panel.Visible:=false;
  SelectColumnForm.Capil_Panel.Visible:=false;
  SelectColumnForm.Irr_Panel.Visible:=false;
  SelectColumnForm.Eff_Panel.Visible:=false;
  SelectColumnForm.Area_Panel.Visible:=false;
end;


procedure TMainForm.Select_ButtonClick(Sender: TObject);
begin
  inherited;
  SelectPolyForm.Show;
end;


procedure TMainForm.GraphOpen_Execute(Sender: TObject);
{-----------------------------------------------------}
var GraphName : string;
begin
  inherited;
      Graphics_Image.Visible := true;
      GraphShowSymbols_Button.Enabled := true;
      ColorMapButton.Enabled := true;
      GraphOpened := true;
      if MainForm.GraphOpen_Dialog.Execute then  with DataMod do
      begin
        GraphName := MainForm.GraphOpen_Dialog.Files.Strings[0];
        if FileExists (GraphName) then
          Graphics_Image.Picture.LoadFromFile(GraphName)
        else
        begin
          Showmessage ('File does not exist, please select another one,');
          exit;
        end;
      end
      else
      begin
        Showmessage('No image file was selected');
        exit;
      end;
      GraphSalt_Image.Visible:=false;
      Graphics_Tabsheet.Show;
end; {TMainForm.GraphOpen_Execute}
{--------------------------------}



procedure TMainForm.GraphSave_Execute(Sender: TObject);
{----------------------------------------------------}
var Result : boolean;
    GraphName : string;
begin
  inherited;
      if GraphSave_Dialog.Execute then with DataMod do
      begin GraphName := GraphSave_Dialog.Files.Strings[0];
        if FileExists(GraphName) then
             Result := Question('The graph file already exists, overwrite?')
        else Result := true;
        if Result then
        begin
          Graphics_Image.Picture.SaveToFile(GraphName);
          Showmessage ('The graph was saved in  ' + GraphName);
        end;
      end
      else Showmessage ('The graph was not saved');
end; {TMainForm.GraphSave_Execute}
{-------------------------------}


{******************************************************************************
 End of Graphics tabsheet, start of CloseForm,
*******************************************************************************}


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
{-----------------------------------------------------------------------}
begin
   Inherited;
    Action := caNone;
    if DirectoryExists (InitDir) then chdir (InitDir);
    DeleteGroupFiles;                              {GroupFiles are "Name"files}
    if DirectoryExists (DataDir) then chdir (DataDir);
    DeleteGroupFiles;
    RestrictInputArrays ('Polygonal');
    RestrictInputArrays ('Seasonal');
    CloseForm.Show;
end; {TMainForm.FormClose}
{------------------------}



procedure TMainForm.FormShow(Sender: TObject);
{--------------------------------------------}
begin Inherited;
      if CloseForm.Visible then
            Application.Terminate;
end; {TMainForm.FormShow}
{-----------------------}


{******************************************************************************
 End of CloseForm, start of GENERAL AND MENU ITEMS
 ******************************************************************************}


procedure TMainForm.SetInitialDir (SetDir : string);
{--------------------------------------------------}
begin
  InputOpen_Dialog.InitialDir:=SetDir;
  InputSave_Dialog.InitialDir:=SetDir;
  OutputOpen_Dialog.InitialDir:=SetDir;
  GraphOpen_Dialog.InitialDir:=SetDir;
  GraphSave_Dialog.InitialDir:=SetDir;
  GroupOpen_Dialog.InitialDir:=SetDir;
  GroupSave_Dialog.InitialDir:=SetDir;
end; {TMainForm.SetInitialDir}
{----------------------------}



procedure TMainForm.RestrictInputArrays (const DataSheet : string);
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
      Poly_StringGrid.ColCount:=1;
      Poly_StringGrid.RowCount:=1;
    end;
    if not (DataSheet='Seasonal') then
    begin
      for i:=1 to 4 do for j:=1 to 4 do setlength(AuxValue[i,j],1);
      Season_StringGrid.ColCount:=1;
      Season_StringGrid.RowCount:=1;
    end;
  end; {with DataMod do}
end; {TMainForm.RestrictInputArrays}
{----------------------------------}



procedure TMainForm.ReduceOutputArrays;
{-------------------------------------}
var i:byte;
begin
  for i:=1 to 7 do setlength(DataMod.Mainstr[i],1);
  for i:=1 to 7 do setlength(DataMod.Variable[i],1);
end; {TMainForm.ReduceOutputArrays}
{---------------------------------}


end.
