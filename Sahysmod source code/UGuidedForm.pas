unit UGuidedForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBaseForm, StdCtrls, ExtCtrls, ComCtrls, Grids;

const MaxNumber = 9;
type IntArray = array of integer;

type
  TGuidedForm = class(TBaseForm)
    ExampleButton: TButton;
    NrOfNodesPanel: TPanel;
    NrOfNodesMemo: TMemo;
    NrOfNodesOKButton: TButton;
    NrOfNodesStringGrid: TStringGrid;
    YcoordPanel: TPanel;
    YcoordMemo: TMemo;
    YcoordStringGrid: TStringGrid;
    YcoordOKButton: TButton;
    XcoordPanel: TPanel;
    XcoordMemo: TMemo;
    XcoordStringGrid: TStringGrid;
    XcoordOKButton: TButton;
    FirstXPanel: TPanel;
    FirstXMemo: TMemo;
    FirstXStringGrid: TStringGrid;
    FirstXOKButton: TButton;
    Cols_Rows_Panel: TPanel;
    RowsMemo: TMemo;
    ColsMemo: TMemo;
    NrOfRowsEdit: TEdit;
    NrOfColsEdit: TEdit;
    Rows_Cols_OK_Button: TButton;
    BackButton: TButton;
    NrOfNodesLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ExampleButtonClick(Sender: TObject);
    procedure Rows_Cols_OK_ButtonClick(Sender: TObject);
    procedure NrOfNodesOKButtonClick(Sender: TObject);
    procedure YcoordOKButtonClick(Sender: TObject);
    procedure XcoordOKButtonClick(Sender: TObject);
    procedure FirstXOKButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BackButtonClick(Sender: TObject);
    procedure HandlePasteMultiCell(Sender: TObject; ACol,
                     ARow: Integer; const Value: String);
    procedure YcoordStringGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure XcoordStringGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure NrOfNodesStringGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure FirstXStringGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);

  private
    { Private declarations }
    NrOfRows, NrOfCols           : integer;
    CoordY, CoordX, FirstX,
    StartX                       : array of real;
    Xnode, Ynode                 : array of real;
    NrOfNodesPerRow              : array of integer;
    NodeNr, NextNr               : array of IntArray;
    NrOfIntNodes, NrOfExtNodes,
    TmpTotal, TmpAdded, Count    : integer;
    Done                         : boolean;
    procedure AllNodes;
    procedure OverallGroupSave;
    procedure NetworkGroupSave;

  public
    { Public declarations }

  end;

var
  GuidedForm: TGuidedForm;
  Sender : TObject;

implementation

uses UMainForm, UDataMod, UExampleForm, UExtraUtils, UNetworkForm;

{$R *.dfm}


procedure TGuidedForm.FormShow(Sender: TObject);
begin
  inherited;
  MainForm.PolyShowMap_Button.Visible:=false;
  MainForm.NetworkCancel_Button.Visible:=false;
  Cols_Rows_Panel.Visible:=true;
  FirstXPanel.Visible:=false;
  NrOfNodesPanel.Visible:=false;
  XcoordPanel.Visible:=false;
  YcoordPanel.Visible:=false;
  Done:=false;
  TmpTotal:=DataMod.TotNrOfPoly;
  TmpAdded:=DataMod.NrOfNodesAdded;
end;



procedure TGuidedForm.ExampleButtonClick(Sender: TObject);
{--------------------------------------------------------}
begin
  inherited;
  ExampleForm.Show;
end; {TGuidedForm.ExampleButtonClick}



procedure TGuidedForm.Rows_Cols_OK_ButtonClick(Sender: TObject);
{--------------------------------------------------------------}
var k : integer;
begin
  inherited;
  NrOfRows:=StrToInt(NrOfRowsEdit.Text);
  NrOfCols:=StrToInt(NrOfColsEdit.Text);
  if (NrOfRows<3) or (NrOfCols<3) then
  begin
    Showmessage('The number of grid lines must be at least 3');
    exit;
  end;
  if (NrOfRows>59) or (NrOfCols>59) then
  begin
    Showmessage('The number of grid lines must be less than 59');
    exit;
  end;
  NrOfNodesStringGrid.RowCount:=1+NrOfRows;
  NrOfNodesPanel.Height:= 85+(1+NrOfRows)*20;
  NrOfNodesStringGrid.Width:=167;
  NrOfNodesStringGrid.Height:=12+(1+NrOfRows)*20;
  if NrOfRows>MaxNumber then
  begin
     NrOfNodesPanel.Height:= 85+(1+MaxNumber)*20;
     NrOfNodesStringGrid.Width:=185;
     NrOfNodesStringGrid.Height:=30+(1+MaxNumber)*20;
  end;
  NrOfNodesStringGrid.Cells[0,0]:='Row nr.';
  NrOfNodesStringGrid.Cells[1,0]:='Nr. of Nodes';
  for k:=1 to NrOfRows do
      NrOfNodesStringGrid.Cells[0,k]:=IntToStr(k);
  Cols_Rows_Panel.Visible:=false;
  NrOfNodesPanel.Visible:=true;
end; {TGuidedForm.Rows_Cols_OK_ButtonClick}
{-----------------------------------------}



procedure TGuidedForm.NrOfNodesOKButtonClick(Sender: TObject);
var k  : integer;
{    Result : boolean; }
begin
  inherited;
  setlength(NrOfNodesPerRow,NrOfRows+1);
  NrOfNodesPerRow[0]:=0;
  for k:=1 to NrOfRows do
      NrOfNodesPerRow[k]:= StrToInt(NrOfNodesStringGrid.Cells[1,k]);
  for k:=2 to NrOfRows-1 do if NrOfNodesPerRow[k]<3 then
      NrOfNodesPerRow[k]:=3;
  for k:=1 to NrOfRows do if NrOfNodesPerRow[k]>NrofCols then
  begin
    Showmessage (' The number of nodes per row cannot be greater than'+
                 ' the number of columns available ('+IntToStr(NrOfCols)+
                 '). Please adjust.');
    exit;
  end;

  YcoordStringGrid.RowCount:=1+NrOfRows;
  YcoordPanel.Height:= 85+(1+NrOfRows)*20;
  YcoordStringGrid.Width:=167;
  YcoordStringGrid.Height:=12+(1+NrOfRows)*20;
  if NrOfRows>MaxNumber then
  begin
     YcoordPanel.Height:= 85+(1+MaxNumber)*20;
     YcoordStringGrid.Width:=185;
     YcoordStringGrid.Height:=30+(1+MaxNumber)*20;
  end;
  YcoordStringGrid.Cells[0,0]:='Row nr.';
  YcoordStringGrid.Cells[1,0]:='Y-coordinate';
  for k:=1 to NrOfRows do
      YcoordStringGrid.Cells[0,k]:=IntToStr(k);
  NrOfNodesPanel.Visible:=false;
  YcoordPanel.Visible:=true;
end; {TGuidedForm.NrOfNodesOKButtonClick}
{---------------------------------------}



procedure TGuidedForm.YcoordOKButtonClick(Sender: TObject);
{---------------------------------------------------------}
var k: integer;
    RangeOK : boolean;
begin
  inherited;
  setlength (CoordY,NrOfRows+1);
  CoordY[0]:=0;
  for k:=1 to NrOfRows do
  Try
    CoordY[k]:=StrToFloat(YcoordStringGrid.Cells[1,k]);
    Except on E: exception do
    begin
      Showmessage ('The Y-coordinates must be real values');
      exit;
    end;
  end;
  RangeOK:=true;
  for k:=1 to NrOfRows-1 do
      if (CoordY[k]>=CoordY[k+1]) then RangeOK:=false;
  if not RangeOK then
  begin
    Showmessage('The values of the Y-coordinates must increase with'+
                ' increasing row number');
    exit;
  end;
  XcoordStringGrid.RowCount:=1+NrOfCols;
  XcoordPanel.Height:= 100+(1+NrOfCols)*20;
  XcoordStringGrid.Width:=167;
  XcoordStringGrid.Height:=12+(1+NrOfCols)*20;
  if NrOfCols>MaxNumber then
  begin
     XcoordPanel.Height:= 100+(1+MaxNumber)*20;
     XcoordStringGrid.Width:=185;
     XcoordStringGrid.Height:=30+(1+MaxNumber)*20;
  end;
  XcoordStringGrid.Cells[0,0]:='Column nr.';
  XcoordStringGrid.Cells[1,0]:='X-coordinate';
  for k:=1 to NrOfCols do
      XcoordStringGrid.Cells[0,k]:=IntToStr(k);
  YcoordPanel.Visible:=false;
  XcoordPanel.Visible:=true;
end; {TGuidedForm.YcoordOKButtonClick}
{------------------------------------}



procedure TGuidedForm.XcoordOKButtonClick(Sender: TObject);
{---------------------------------------------------------}
var k: integer;
    RangeOK : boolean;
begin
  inherited;
  setlength (CoordX,NrOfRows*NrOfCols);
  CoordX[0]:=0;
  for k:=1 to NrOfCols do
  Try
    CoordX[k]:=StrToFloat(XcoordStringGrid.Cells[1,k]);
    Except on E: exception do
    begin
      Showmessage ('The X-coordinates must be real values');
      exit;
    end;
  end;
  RangeOK:=true;
  for k:=1 to NrOfCols-1 do
      if (CoordX[k]>=CoordX[k+1]) then RangeOK:=false;
  if not RangeOK then
  begin
    Showmessage('The values of the X-coordinates must increase with'+
                ' increasing column number');
    exit;
  end;
  FirstXStringGrid.RowCount:=1+NrOfRows;
  FirstXPanel.Height:= 85+(1+NrOfRows)*20;
  FirstXStringGrid.Width:=167;
  FirstXStringGrid.Height:=12+(1+NrOfRows)*20;
  if NrOfRows>MaxNumber then
  begin
     FirstXPanel.Height:= 85+(1+MaxNumber)*20;
     FirstXStringGrid.Width:=185;
     FirstXStringGrid.Height:=30+(1+MaxNumber)*20;
  end;
  FirstXStringGrid.Cells[0,0]:='Row nr.';
  FirstXStringGrid.Cells[1,0]:='First X-coord';
  for k:=1 to NrOfRows do
      FirstXStringGrid.Cells[0,k]:=IntToStr(k);
  XcoordPanel.Visible:=false;
  FirstXPanel.Visible:=true;
end; {TGuidedForm.XcoordOKButtonClick}
{------------------------------------}



procedure TGuidedForm.FirstXOKButtonClick(Sender: TObject);
{---------------------------------------------------------}
var j, k: integer;
    RangeOK : boolean;
    FirstOK : array of boolean;
begin
  inherited;
  setlength (FirstX,NrOfRows+1);
  FirstX[0]:=0;
  for k:=1 to NrOfRows do
  Try
    FirstX[k]:=StrToFloat(FirstXStringGrid.Cells[1,k]);
    Except on E: exception do
    begin
      Showmessage ('The first X-coordinates must be real values');
      exit;
    end;
  end;
  RangeOK:=true;
  for k:=1 to NrOfRows do
  begin
      if (FirstX[k]<CoordX[1]) then RangeOK:=false;
      if (FirstX[k]>CoordX[NrOfCols]) then RangeOK:=false;
  end;
  if not RangeOK then
  begin
    Showmessage('The values of the first X-coordinates must be at least equal'+
                ' to the smallest X given for the columns and smaller than'+
                ' the largest X');
    exit;
  end;
  RangeOK:=true;
  setlength (FirstOK,NrOfRows+1);
  for k:=0 to NrOfRows do FirstOk[k]:=false;
  for k:=1 to NrOfCols do for j:=1 to NrOfRows do
      if FirstX[j]=CoordX[k] then FirstOK[j]:=true;
  for k:=1 to NrOfRows do if not FirstOK[k] then RangeOK:=false;
  if not RangeOK then
  begin
    Showmessage('The values of the first X-coordinates must be equal'+
                ' to one of the X-coordinates of the columns');
    exit;
  end;
  FirstXPanel.Visible:=false;
  AllNodes;
end; {TGuidedForm.FirstXOKButtonClick}
{------------------------------------}



procedure TGuidedForm.AllNodes;
{-----------------------------}
Type IntegerArray = array of integer;
     RealArray = array of real;
     DoubleRealArray = array of array of real;
     DoubleIntArray = array of array of integer;
     BooleanArray = array of boolean;

var
    VoidX           : IntegerArray;
                     {number of empty cells before the first node in a row}
    Index, NrNod    : IntegerArray; {needed later for changing sequence}
    AuxR            : real;
    i, ii, j,
    Ref1, Ref2,
    LastX, Total    : integer;
    Check, Result   : boolean;
    IND             : DoubleIntArray;    {internal/external index}

Label 1;

begin

  setlength (VoidX,NrOfRows+1);
  for i:=0 to NrOfRows do VoidX[i]:=0;
  for i:=1 to NrOfRows do
      for ii:=1 to NrOfCols do
          if CoordX[ii]<FirstX[i] then VoidX[i]:=VoidX[i]+1;

//Settting lengths of arrays
  setlength (NodeNr,2*NrOfRows+1,2*NrOfCols+1);
  Ref1:=NrOfRows;
  if NrOfCols>NrOfRows then Ref1:=NrOfCols;
  setlength(NextNr,Ref1*Ref1+1,5);
  for i:=1 to 2*NrOfRows do for ii:=1 to 2*NrOfCols do NodeNr[i,ii]:=0;
// XNode and Ynode are the coordinates written in the result files
  setlength (Xnode,2*Ref1*Ref1+1);
  setlength (Ynode,2*Ref1*Ref1+1);
  setlength (Index,2*Ref1*Ref1+1);
  setlength (NrNod,2*Ref1*Ref1+1);

//IND = index internal (1) and external (2) and irrelevant (0)
//begin with zero settings
  setlength (IND,Ref1+1,Ref1+1);
  for j:=1 to NrOfCols do
      for i:= 1 to NrOfRows do
          IND[i,j]:=0;

//Determing the start for defining internal nodes
  setlength (StartX,NrOfRows+1);
  StartX[1]:=FirstX[1];
  StartX[NrOfRows]:=FirstX[NrOfRows];
  for i:=2 to NrOfRows-1 do
  begin
    StartX[i]:=FirstX[i];
    if VoidX[i]<VoidX[i-1]-1 then StartX[i]:=CoordX[VoidX[i-1]];
//    if VoidX[i+1]>VoidX[i]+1 then StartX[i]:=CoordX[i-1];
  end;

//Making internal/external indices
//IND = index internal (1) and external (2) and irrelevant (0)
  for j:=2 to NrOfCols-1 do
      for i:=2 to NrOfRows-1 do
      begin
        LastX:=VoidX[i]+NrOfNodesPerRow[i];
        if (CoordX[j]>StartX[i]) and
           (CoordX[j]<CoordX[LastX]) then
              IND[i,j]:=1;
      end;

//Defining external nodes
//IND = index internal (1) and external (2) and irrelevant (0)
  for j:=1 to NrOfCols do
      for i:=1 to NrOfRows do
      begin
        if Ind[i,j]=1 then
        begin
          if Ind[i+1,j]=0 then Ind[i+1,j]:=2;
          if i>1 then
             if Ind[i-1,j]=0 then Ind[i-1,j]:=2;
          if Ind[i,j+1]=0 then Ind[i,j+1]:=2;
          if j>1 then
             if Ind[i,j-1]=0 then Ind[i,j-1]:=2;
        end;
      end;

//Determining number of internal nodes (Ref1)  and external (Ref2)
//and identification number of the nodes  (NodeNr)
  Count:=0;
  Ref1:=0;
  Ref2:=0;

  for j:=1 to NrOfCols do
      for i:=1 to NrOfRows do
      begin
        if Ind[i,j]=1 then
        begin
          Ref1:=Ref1+1;
          Count:=Count+1;
          NodeNr[i,j]:=Count;
          Xnode[NodeNr[i,j]]:=CoordX[j];
          Ynode[NodeNr[i,j]]:=CoordY[i];
          Index[NodeNr[i,j]]:=Ind[i,j];  {needed later for changing sequence}
          NrNod[NodeNr[i,j]]:=Count;
         end;
      end;

  for j:=1 to NrOfCols do
      for i:=1 to NrOfRows do
      begin
        if Ind[i,j]=2 then
        begin
          Ref2:=Ref2+1;
          Count:=Count+1;
          NodeNr[i,j]:=Count;
          Xnode[NodeNr[i,j]]:=CoordX[j];
          Ynode[NodeNr[i,j]]:=CoordY[i];
          Index[NodeNr[i,j]]:=Ind[i,j];
          NrNod[NodeNr[i,j]]:=Count;
        end;
      end;
  NrOfIntNodes:=Ref1;
  DataMod.NrOfIntPoly:=NrOfIntNodes;
  NrOfExtNodes:=Ref2;
  DataMod.NrOfExtPoly:=NrOfExtNodes;

//Determining neighbor node identifiction numbers (NextNr)
  for i:=1 to NrOfCols do for ii:=1 to NrOfRows do
  begin
    if IND[ii,i]=1 then
    begin
      if i>1 then NextNr[NodeNr[ii,i],1]:=NodeNr[ii,i-1];
      NextNr[NodeNr[ii,i],2]:=NodeNr[ii+1,i];
      NextNr[NodeNr[ii,i],3]:=NodeNr[ii,i+1];
      if ii>1 then NextNr[NodeNr[ii,i],4]:=NodeNr[ii-1,i];
    end;

  end;

//Ranking node numbers (NrNod) and moving its properties with it
//namely Index, Xnode, Ynode and NextNr
  Total:=NrOfIntNodes+NrOfExtNodes;
  for i:=1 to Total do
  begin
1:  for j:=i+1 to Total do
    begin
      if NrNod[j]<NrNod[j-1] then
      begin
        Ref1:=NrNod[j];
        NrNod[j]:=NrNod[j-1];
        NrNod[j-1]:=Ref1;
        if Index[j]=1 then
        begin
          Ref1:=Index[j];
          Index[j]:=Index[j-1];
          Index[j-1]:=Ref1;
          AuxR:=Xnode[j];
          Xnode[j]:=Xnode[j-1];
          Xnode[j-1]:=AuxR;
          AuxR:=Ynode[j];
          Ynode[j]:=Ynode[j-1];
          Ynode[j-1]:=AuxR;
          for ii:=1 to 4 do
          begin
            Ref1:=NextNr[j,ii];
            NextNr[j,ii]:=NextNr[j-1,ii];
            NextNr[j-1,ii]:=Ref1;
          end;
        end;
        goto 1;
      end;
    end;
  end;

//Finalizing
  Showmessage ('SahysMod has identified '+ IntToStr(NrOfIntNodes)+
               ' internal polygons and '+IntToStr(NrOfExtNodes)+
               ' external polygons.');
  if DataMod.NrOfIntPoly<1 then
     Showmessage ('SahysMod could not identify internal polygons.'+
     ' The polygonal network could not be made. Please try again.');
  DataMod.TotNrOfPoly:=DataMod.NrOfIntPoly+Datamod.NrOfExtPoly;
  setlength (DataMod.NrOfSides,DataMod.NrOfIntPoly+1);
  for i:=0 to DataMod.NrOfIntPoly-1 do DataMod.NrOfSides[i]:=4;
  if DataMod.Title1='' then
  begin
    DataMod.Title1:='NO TITLE WAS GIVEN. Network map was made under guided'+
                    ' input';
    MainForm.Title1_Edit.Text:=DataMod.Title1;
  end;
  if DataMod.Title2='' then
  begin
    DataMod.Title2:='Internal nodes are surrounded by polygonal boundary nodes';
    MainForm.Title2_Edit.Text:=DataMod.Title2;
  end;
  DataMod.NrOfNodesAdded:=0;
  DataMod.SaveGeneralGroup (Check);
  if not Check then exit;
  OverallGroupSave;
  NetworkGroupSave;
  DataMod.ReadGeneralGroup;
  DataMod.ReadOverallGroup;
  Datamod.ReadNetworkGroup('Starting');
  NetworkForm.Visible:=false;
  MainForm.ShowNetworkMap (Sender);
  NetworkForm.Visible:=true;

  Result:=DataMod.Question ('Would you like to review the network data?');
  if Result then
  begin
    DataMod.TotNrOfPoly:=TmpTotal;
    DataMod.NrOfNodesAdded:=TmpAdded;
    GuidedForm.FormShow(Sender);
    exit;
  end else
  begin
    Done:=true;
    GuidedForm.Hide;
    MainForm.Enabled:=true;
    Showmessage (' Please enter values of aquifer bottom level.'+
                 '  Thereafter complete the other data groups. '+
                 '  However, if the network map is not satisfactory'+
                 ' it may be better to use "Restart" in the general'+
                 ' input tabsheet after cancelling the data group.');
    DataMod.InitNrOfIntPoly:=DataMod.NrOfIntPoly;
    DataMod.InitNrOfExtPoly:=DataMod.NrOfExtPoly;
    MainForm.GuidedOK:=true;
    MainForm.GuideEnded:=false;
    MainForm.PolyShowMap_Button.Visible:=true;
    MainForm.NetworkCancel_Button.Visible:=false;
    MainForm.GuideStop:=false;
    InputOpened:=true;
    DataMod.MakeGroupFiles;
    GuidedForm.Hide;
    NetworkForm.Hide;
    MainForm.NrOfPoly_Edit.Text := IntToStr(DataMod.TotNrOfPoly);
    MainForm.NrAdded_Edit.Text := '0';
    MainForm.ShowOverallTable;
  end;
end; {TGuidedForm.AllNodes}
{-------------------------}


procedure TGuidedForm.OverallGroupSave;
{-------------------------------------}
var GroupFile : textfile;
    k : integer;
begin
  Assignfile(GroupFile,'Name01');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A reading error occurred. Data cannot be shown');
    exit;
  end;
  for k:=1 to NrOfIntNodes do write (GroupFile,k:5);
  writeln (GroupFile);
  for k:=1 to NrOfExtNodes do write (GroupFile,k+NrOfIntNodes:5);
  writeln (GroupFile);
  for k:=1 to NrOfIntNodes do write (GroupFile,Xnode[k]:8:2);
  writeln (GroupFile);
  for k:=1 to NrOfExtNodes do write (GroupFile,Xnode[k+NrOfIntNodes]:8:2);
  writeln (GroupFile);
  for k:=1 to NrOfIntNodes do write (GroupFile,Ynode[k]:8:2);
  writeln (GroupFile);
  for k:=1 to NrOfExtNodes do write (GroupFile,Ynode[k+NrOfIntNodes]:8:2);
  writeln (GroupFile);
  for k:=1 to NrOfIntNodes do write (GroupFile,'   0  ');
  writeln (GroupFile);
  for k:=1 to NrOfExtNodes do write (GroupFile,'   0 ');
  writeln (GroupFile);
  for k:=1 to NrOfIntNodes do write (GroupFile,' 1 ');
  writeln (GroupFile);
  for k:=1 to NrOfExtNodes do write (GroupFile,' 2 ');
  writeln (GroupFile);
  closefile(GroupFile);
end; {TGuidedForm.OverallGroupSave}
{---------------------------------}



procedure TGuidedForm.NetworkGroupSave;
var GroupFile : textfile;
    j,k : integer;
begin
  AssignFile(GroupFile,'Name03');
  {$I-} Rewrite(GroupFile); {$I+}
  if ioresult <> 0 then
  begin
    Showmessage('A temporary file could not be opened,'+
                ' SahysMod cannot proceed');
    exit;
  end;
  for k:=1 to NrOfIntNodes do
  begin
    write (GroupFile,k:3);
    for j:=1 to 4 do
        write (GroupFile,NextNr[k,j]:5,'     0  ','     0  ');
    writeln(groupFile);
  end;
  for k:=1 to NrOfIntNodes do
      write (GroupFile,'     0  ');
  writeln (GroupFile);
  for k:=1 to NrOfIntNodes do
      write (GroupFile,'     0  ');
  writeln (GroupFile);
  closefile(GroupFile);
end;{TGuidedForm.NetworkGroupSave}
{--------------------------------}



procedure TGuidedForm.BackButtonClick(Sender: TObject);
{-----------------------------------------------------}
begin
  inherited;
  if Cols_Rows_Panel.Visible=true then
  begin
    GuidedForm.Hide;
    MainForm.Enabled:=true;
    MainForm.PolyNetwork_Panel.Visible:=true;
    MainForm.PolyShowMap_Button.Visible:=false;
    MainForm.NetworkCancel_Button.Visible:=true;
    MainForm.PolygonalInput_Tabsheet.Show;
  end else
    if NrOfNodesPanel.Visible=true then
    begin
      NrOfNodesPanel.Visible:=false;
      Cols_Rows_Panel.Visible:=true;
{      Rows_Cols_OK_ButtonClick(Sender);}
    end else
    if YcoordPanel.Visible=true then
    begin
      YcoordPanel.Visible:=false;
      NrOfNodesPanel.Visible:=true;
{      NrOfNodesOKButtonClick(Sender);}
    end else
    if XcoordPanel.Visible=true then
    begin
      XcoordPanel.Visible:=false;
      YcoordPanel.Visible:=true;
{      YcoordOKButtonClick(Sender); }
    end else
    if FirstXPanel.Visible=true then
    begin
      FirstXPanel.Visible:=false;
      XcoordPanel.Visible:=true;
{      XcoordOKButtonClick(Sender); }
    end;
end; {TGuidedForm.BackButtonClick}
{--------------------------------}



procedure TGuidedForm.FormClose(Sender: TObject; var Action: TCloseAction);
{-------------------------------------------------------------------------}
begin
  inherited;
  GuidedForm.Hide;
  MainForm.Enabled:=true;
  if not Done then
  begin
    Showmessage ('Guided network data were not saved. Please try again.');
    MainForm.Restart_ButtonClick(Sender);
    MainForm.GeneralInput_TabSheet.Show;
  end else
  begin
  MainForm.Identity:='Overall';
  DataMod.InitNrOfIntPoly:=DataMod.NrOfIntPoly;
  DataMod.InitNrOfExtPoly:=DataMod.NrOfIntPoly;
  DataMod.ReadGeneralGroup;
  DataMod.ReadOverallGroup;
  Datamod.ReadNetworkGroup('Starting');
  DataMod.MakeGroupFiles;
  end;
end;


procedure TGuidedForm.HandlePasteMultiCell(Sender: TObject; ACol,
                    ARow: Integer; const Value: String);
{---------------------------------------------------------------}
// only accepts numbers to be pasted into the grid
  var
   i, m, j, {k,} startcol: integer;
   c: char ;

begin
  // MessageDlg(Value, mtInformation, [mbOK], 0);
  m := Length(Value);
  (Sender as TStringGrid).Cells[ACol,ARow] := '' ;
  startcol := ACol ;
  i := 1;
//  k := 1;
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
//      if YcoordB then YcoordStringGrid.RowCount:=k+1;
//      k:=k+1;
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
(*
  if YcoordStringGrid.Height>337 then
  begin
    YcoordStringGrid.Width:=24+60*DataMod.NrOfItems;
    YcoordStringGrid.Height:=337;
  end;
*)
end; {GuidedForm.HandlePasteMultiCell}


procedure TGuidedForm.YcoordStringGridSetEditText(Sender: TObject; ACol,
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
      end;
    end;
  end;
  InputOpened:=true;
end; {TGuidedForm.YcoordStringGridSetEditText}


procedure TGuidedForm.XcoordStringGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
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
      end;
    end;
  end;
  InputOpened:=true;
end;


procedure TGuidedForm.NrOfNodesStringGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
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
      end;
    end;
  end;
  InputOpened:=true;
end;


procedure TGuidedForm.FirstXStringGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
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
      end;
    end;
  end;
  InputOpened:=true;
end;


end.

