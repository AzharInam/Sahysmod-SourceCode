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
    procedure FormShow(Sender: TObject);
    procedure ExampleButtonClick(Sender: TObject);
    procedure Rows_Cols_OK_ButtonClick(Sender: TObject);
    procedure NrOfNodesOKButtonClick(Sender: TObject);
    procedure YcoordOKButtonClick(Sender: TObject);
    procedure XcoordOKButtonClick(Sender: TObject);
    procedure FirstXOKButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BackButtonClick(Sender: TObject);

  private
    { Private declarations }
    NrOfRows, NrOfCols         : integer;
    CoordY, CoordX, FirstX     : array of real;
    Xcord, Ycord               : array of real;
    NrOfNodesPerRow            : array of integer;
    IndexNr, NodeNr, NextNr    : array of IntArray;
    NrOfIntNodes, NrOfExtNodes,
    TmpTotal, TmpAdded,
    Count, Sum                 : integer;
    Done                       : boolean;

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
var k {, Total} : integer;
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
(*
  Total:=0;
  for k:=1 to NrOfRows do Total:=Total+NrOfNodesPerRow[k];
  if Total<>TmpTotal+TmpAdded then
  begin
    Result:=
      DataMod.Question ('The total number of all nodes '+IntToStr(Total)+
      ' of all rows does not equal the total number '+IntToStr(TmpTotal)+
      ' plus the added number '+IntToStr(TmpAdded)+ ' specified in the'+
      ' general input tabsheet.  Although the program will make adjustments'+
      ' atomatically, would you like to change the number of nodes per row?');
    if Result then
    begin
      Rows_Cols_OK_ButtonClick (Sender);
      exit;
    end;
  end;
*)

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
     BooleanArray = array of boolean;

var
    AddX, Counter1,
    Counter2        : IntegerArray;
    TmpX            : RealArray;
    i, ii, j,
    Total, Ref1     : integer;
{    Minim           : real; }
    Check, Result   : boolean;
    Xcoord          : DoubleRealArray;
    Corner, Counted : boolean;

begin

//Allotting X-coordinates to the points in the grid system
  setlength (TmpX,5);
  setlength (Xcoord,NrOfRows+1);
  for i:=1 to NrOfRows do setlength (Xcoord[i],NrOfCols+1);
  for i:=1 to NrOfRows do
  begin
    Count:=0;
    for ii:=1 to NrOfCols do
    begin
      Count:=Count+1;
      Xcoord[i,ii]:=CoordX[Count];
    end;
  end;

//Adjusting first X-coordinate
//  for i:=2 to NrOfRows do
//      if FirstX[i]>FirstX[i-1]+1 then
//         FirstX[i]:=FirstX[i-1]+1;

//The following has no influence on AddX
//Shifting the network back when the minimum FirstX>1
//  Minim:=NrOfCols;
//  for i:=1 to NrOfRows do
//      if FirstX[i]<Minim then Minim:=FirstX[i];
//  Ref1:=round(Minim);
//  for i:=1 to NrOfRows do
//      FirstX[i]:=FirstX[i]-Ref1+1;

//Removing irrelevant nodes, AddX is the shift of the first node when there
//is no space to put an external node before it
  setlength (AddX,NrOfRows+1);
  for i:=0 to NrOfRows do AddX[i]:=0;
  for i:=1 to NrOfRows do for ii:=1 to NrOfCols do
  begin
    Corner:=false;
    Counted:=false;
    if (i=1) and (ii=1) then
    begin
      Corner:=true;
      AddX[1]:=1;
    end;
    if (i=NrOfRows) and (ii=1) then
    begin
      Corner:=true;
      AddX[NrOfRows]:=1;
    end;
    if (i=1) and (ii=NrOfCols) then Corner:=true;
    if (i=NrOfRows) and (ii=NrOfCols) then Corner:=true;
    for j:=1 to 4 do TmpX[j]:=0;
    if ii<NrOfCols then Tmpx[1]:=Xcoord[i,ii+1];
    if ii>1 then Tmpx[2]:=Xcoord[i,ii-1];
    if i<NrOfRows then Tmpx[3]:=Xcoord[i+1,ii];
    if i>1 then Tmpx[4]:=Xcoord[i-1,ii];
    Count:=0;
    if (ii<NrOfCols) and (Tmpx[1]>=FirstX[i]) then Count:=Count+1;
    if (ii>1) and (TmpX[2]>=FirstX[i]) then Count:=Count+1;
    if (i<NrOfRows) and (Tmpx[3]>=FirstX[i]) then Count:=Count+1;
    if (i>1) and (Tmpx[4]>=FirstX[i]) then Count:=Count+1;
    if Count<3 then if (i>1) and (i<NrOfRows) and (ii>1) and (ii<NrOfCols) then
    begin
      AddX[i]:=AddX[i]+1;
      Counted:=true;
    end;
    if (Count<2) and not Corner and not Counted then
       AddX[i]:=AddX[i]+1;
  end;
//Adjusting the number of nodes per row
  for i:=1 to NrOfRows do
  begin
    Ref1:=NrOfNodesPerRow[i]+AddX[i];
    if Ref1>NrOfCols-1 then
       if Ref1>NrOfcols then
          NrOfNodesPerRow[i]:=NrOfNodesPerRow[i]-AddX[i]
       else
          AddX[i]:=NrOfCols-NrOfNodesPerRow[i];
  end;

//Adjusting AddX to avoid a double jump
  for i:=2 to NrOfRows do
  begin
    if AddX[i]>AddX[i-1]+1 then
       AddX[i]:=AddX[i-1]+1;
    if AddX[i]<AddX[i-1]-1 then
       AddX[i]:=AddX[i-1]-1;
   end;
(*
   if AddX[2]<AddX[1]+1 then AddX[1]:=AddX[1]+1;

   if AddX[NrOfRows]+NrOfNodesPerRow[NrOfRows]<AddX[NrOfRows-1]+
                                              NrOfNodesPerRow[NrOfRows-1]-1 then
      AddX[NrOfRows]:=AddX[NrOfRows-1]+1;
*)

  for i:=2 to NrOfRows do
      if NrOfNodesPerRow[i]+AddX[i]<NrOfNodesPerRow[i-1]+AddX[i-1]-1 then
         NrOfNodesPerRow[i]:=NrOfNodesPerRow[i-1]+AddX[i-1]-1-AddX[i];

  setlength (IndexNr,NrOfRows+1);
  setlength (NodeNr,NrOfRows+1);
  setlength (NextNr,(NrOfRows+1)*(NrOfCols+1));
  for i:=1 to NrOfRows do setlength (IndexNr[i],2*NrOfCols);
  for i:=1 to NrOfRows do for ii:=1 to NrOfCols do IndexNr[i,ii]:=0;
  for i:=1 to NrOfRows do setlength (NodeNr[i],2*NrOfCols);
  for i:=1 to NrOfRows do for ii:=1 to NrOfCols+AddX[i] do NodeNr[i,ii]:=0;
  for i:=1 to NrOfRows*NrOfCols do setlength (NextNr[i],2*NrOfCols);
//IndexNr = Ki/e index of NodeNr
//NodeNr = Alternative Node Nr in grid point [i,ii] in a numbering system
//whereby the internal nodes are given the lower numbers
  setlength (Xcord,NrOfCols*NrOfRows+1);
  setlength (Ycord,NrOfRows*NrOfCols+1);
// Xcord and Ycord are the coordinates written in the result files

//Determining NrOfNodesPerRow
  setlength (Counter1,NrOfRows+1);
  setlength (Counter2,NrOfRows+1);
  for i:=1 to NrOfRows do Counter1[i]:=NrOfNodesPerRow[i];
  for i:=1 to NrOfRows do Counter2[i]:=NrOfCols;

  for i:=2 to NrOfRows-1 do Counter1[i]:=Counter1[i]-AddX[i]-2;
  Counter1[1]:=Counter1[2];
  Counter1[NrOfRows]:=Counter1[NrOfRows-1];
  for i:=2 to NrOfRows-1 do Counter1[i]:=Counter1[i]+2;

  for i:=2 to NrOfRows-1 do Counter2[i]:=Counter2[i]-AddX[i]-2;
  Counter2[1]:=Counter2[2];
  Counter2[NrOfRows]:=Counter2[NrOfRows-1];
  for i:=2 to NrOfRows-1 do Counter2[i]:=Counter2[i]+2;

  for i:=1 to NrOfRows do
      if Counter2[i]<NrOfNodesPerRow[i] then
      begin
        if (NrOfNodesPerRow[i]>NrOfCols-2) and (Counter2[i]<NrOfCols-2) then
            AddX[i]:=AddX[i]+1;
        NrOfNodesPerRow[i]:=Counter2[i];
      end;

  for i:=1 to NrOfRows do
      if NrOfNodesPerRow[i]<Counter1[i] then
         NrOfNodesPerRow[i]:=Counter1[i];

//Avoiding a double jump in NrOfNodesPerRow
  for ii:=1 to NrOfCols do
  begin
    if NrOfNodesPerRow[1]>NrOfNodesPerRow[2]-2 then
    begin
      NrOfNodesPerRow[1]:=NrOfNodesPerRow[1]-1;
      AddX[1]:=AddX[2]+1;
    end;
    if AddX[2]+NrOfNodesPerRow[2]>AddX[1]+NrOfNodesPerRow[1]+2 then
       NrOfNodesPerRow[2]:=NrOfNodesPerRow[2]-1;
    for i:=3 to NrOfRows-1 do
        if AddX[i]+NrOfNodesPerRow[i]>AddX[i-1]+NrOfNodesPerRow[i-1]+1 then
           NrOfNodesPerRow[i]:=NrOfNodesPerRow[i]-1;
    if NrOfNodesPerRow[NrOfRows]>NrOfNodesPerRow[NrOfRows-1]-2 then
    begin
      NrOfNodesPerRow[NrOfRows]:=NrOfNodesPerRow[NrOfRows]-1;
      AddX[NrOfRows]:=AddX[NrOfRows-1]+1;
    end;
  end;

//Determining number of internal nodes
  Count:=0;
  for i:=1 to NrOfRows do
  begin
    for ii:=1 to NrOfNodesPerRow[i] do
      if (i>1) and (ii>1) and (i<NrOfRows) and
         (ii<NrOfNodesPerRow[i]) then
         begin
           Count:=Count+1;                          {number of internal nodes}
           NodeNr[i,ii]:=Count;
         end;
  end;

//Determining whether nodes are internal (IndexNr=1) or external (IndexNr=2)
//The DataMod Int_Ext_Index is used for writing the index to the data file
//Assigning nodal numbers (NodeNr) to the gridpoints
  Total:=0;
  Ref1:=0;
  Sum:=0;
  setlength(TmpX,1);
  TmpX[0]:=0;
  setlength (DataMod.Int_Ext_Index,NrOfRows*NrOfCols+1);
  for i:=0 to NrOfRows*NrOfCols do
      DataMod.Int_Ext_Index[i]:=0;                        {dummy Ki/e index}
  for i:=1 to NrOfRows do
  begin
    if i>1 then Ref1:=Ref1+NrOfNodesPerRow[i-1];
    for ii:=1 to NrOfNodesPerRow[i] do
    begin
      Sum:=Sum+1;
      Total:=Total+NrOfCols;
      setlength(TmpX,Total+4);
      TmpX[Ref1+ii]:=CoordX[ii+AddX[i]];                   {Temp X-coord}
      if (ii=1) or (ii=NrOfNodesPerRow[i]) then
      begin
        DataMod.Int_Ext_Index[Ref1+ii-1]:=2;              {Ki/e index extern}
        IndexNr[i,ii]:=2;
        NodeNr[i,ii]:=Sum+Count;
      end;
      if (i=1) or (i=NrOfRows) then
      begin
        DataMod.Int_Ext_Index[Ref1+ii-1]:=2;              {Ki/e index extern}
        IndexNr[i,ii]:=2;
        NodeNr[i,ii]:=Sum+Count;
      end;
      if NrOfNodesPerRow[i]<3 then
      begin
        DataMod.Int_Ext_Index[Ref1+ii-1]:=2;              {Ki/e index extern}
        IndexNr[i,ii]:=2;
        NodeNr[i,ii]:=Sum+Count;
      end;
      if (i>1) and (ii>1) and (i<NrOfRows) and
         (ii<NrOfNodesPerRow[i]) then
         begin
           DataMod.Int_Ext_Index[Ref1+ii-1]:=1;          {Ki/e index intern}
           IndexNr[i,ii]:=1;
           Sum:=Sum-1;
         end;
    end;
  end;
  NrOfIntNodes:=Count;
  DataMod.NrOfIntPoly:=Count;
  NrOfExtNodes:=Sum;
  DataMod.NrOfExtPoly:=NrOfExtNodes;

//Shifting the network forward again when the minimum FirstX>1
//  Ref1:=round(Minim);
//  for i:=1 to NrOfRows do
//      AddX[i]:=AddX[i]+Ref1-1;
//  for i:=1 to NrOfRows do for ii:=1 to NrOfCols-Ref1+1 do
//      Xcoord[i,ii]:=Xcoord[i,ii+Ref1-1];

//shifting the position of the node numbers according the first X coord
  for i:=1 to NrOfRows do for ii:=1 to NrOfCols do
      NextNr[i,ii]:=NodeNr[i,ii];                          {Dummy variable}
  for i:=1 to NrOfRows do for ii:=1 to NrOfCols do
      NodeNr[i,ii+AddX[i]]:=NextNr[i,ii];

  for i:=1 to NrOfRows do
      if AddX[i]+NrOfNodesPerRow[i]>NrOfCols then
      begin
        Showmessage ('The value of the first column (first X) in a row plus'+
                     ' the number of nodes in that row given before is'+
                     ' exceeding the given number of available columns ('
                     + IntToStr(NrOfCols) + '). Please adjust.');
        XcoordOKButtonClick(Sender);
        exit;
      end;

//Determining X and Y coordinates in the grid points
  Count:=0;
  for i:=1 to NrOfRows do for ii:=1 to NrOfCols do
  begin
    Xcord[NodeNr[i,ii]]:=CoordX[ii];
    Ycord[NodeNr[i,ii]]:=CoordY[i];
  end;

//Determining neighbor node numbers (NextNr) of internal poygons
  Count:=0;
  for i:=1 to NrOfRows do for ii:=1 to NrOfCols do
  begin
    if IndexNr[i,ii]=1 then
    begin
      Count:=Count+1;
      //NextNr = NeighborNr in changed identification system whereby the
      //internal nodes have the lower identification numbers
      NextNr[Count,1]:=NodeNr[i-1,ii+AddX[i]];
      NextNr[Count,2]:=NodeNr[i,ii+1+AddX[i]];
      NextNr[Count,3]:=NodeNr[i+1,ii+AddX[i]];
      NextNr[Count,4]:=NodeNr[i,ii-1+AddX[i]];
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
                 ' input tabsheet after saving the data.');
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
  for k:=1 to NrOfIntNodes do write (GroupFile,Xcord[k]:8:2);
  writeln (GroupFile);
  for k:=1 to NrOfExtNodes do write (GroupFile,Xcord[k+NrOfIntNodes]:8:2);
  writeln (GroupFile);
  for k:=1 to NrOfIntNodes do write (GroupFile,Ycord[k]:8:2);
  writeln (GroupFile);
  for k:=1 to NrOfExtNodes do write (GroupFile,Ycord[k+NrOfIntNodes]:8:2);
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


end.

