unit UTransForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, UBaseForm, ShellApi, StdActns, ActnList, Menus, StdCtrls,
  ExtCtrls, Grids, ComCtrls, Clipbrd, Math;

type
  TTransForm = class(TForm)
    CoordStringGrid: TStringGrid;
    TrLabel1: TLabel;
    TrLabel2: TLabel;
    NumberLabel: TLabel;
    EndButton: TButton;
    Memo1: TMemo;
    AngleButton: TButton;
    AngleEdit: TEdit;
    AngleLabel: TLabel;
    RotateButton: TButton;
    ShiftButton: TButton;
    MoveButton: TButton;
    ShiftPanel: TPanel;
    ShiftXLabel: TLabel;
    ShiftXEdit: TEdit;
    ShiftYLabel: TLabel;
    ShiftYEdit: TEdit;
    procedure Initialize;
    procedure CoordStringGridSetEditText(Sender: TObject; ACol,
                                   ARow: Integer; const Value: String);
    procedure HandlePasteCells(Sender: TObject; ACol,
                                    ARow: Integer; const Value: String);
    procedure AngleButtonClick(Sender: TObject);
    procedure EndButtonClick(Sender: TObject);
    procedure AngleEditExit(Sender: TObject);
    procedure RotateButtonClick(Sender: TObject);
    procedure ShiftButtonClick(Sender: TObject);
    procedure ShiftXEditExit(Sender: TObject);
    procedure ShiftYEditExit(Sender: TObject);
    procedure MoveButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Changed : boolean;
  end;

var
  TransForm: TTransForm;
  Angle, DeltaX, DeltaY : real;

implementation

uses UMainForm, UDataMod, UExtraUtils, UNetworkForm;

{$R *.dfm}


procedure TTransForm.Initialize;
var k:integer;
begin
  CoordStringGrid.ColCount:=3;
  CoordStringGrid.Width:=3*60+25;
  CoordStringGrid.ColCount:=3;
  CoordStringGrid.EditorMode:=true;
  CoordStringGrid.Cells[0,0]:=' -';
  CoordStringGrid.Cells[1,0]:='cm map';
  CoordStringGrid.Cells[2,0]:='cm map';
  CoordStringGrid.RowCount:=DataMod.TotNrOfPoly+1;
  for k:=1 to DataMod.TotNrOfPoly do
  begin
    CoordStringGrid.Cells[0,k] := IntToStr(DataMod.NodeNr[k-1]);
    CoordStringGrid.Cells[1,k] := FloatToStr (DataMod.Xcoord[k-1]);
    CoordStringGrid.Cells[2,k] := FloatToStr(DataMod.Ycoord[k-1]);
  end;
  Changed := false;
end;

procedure TTransForm.CoordStringGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var MultiPaste:boolean;
begin
  MultiPaste := (POS(FORMAT('%s',[#9]), Value)> 0 );
  MultiPaste := MultiPaste or (POS(FORMAT('%s',[#13]), Value)> 0 );
  if MultiPaste then
  begin
    Try
      HandlePasteCells(Sender, ACol, ARow, Value) ;
      Except on E: Exception do
      begin
        Showmessage ('There are no data to be pasted or the data'+
                     ' are incompatible');
      end;
    end;
  end;
end;  {CoordStringGridSetEditText}


procedure TTransForm.HandlePasteCells(Sender: TObject; ACol,
                        ARow: Integer; const Value: String);
{----------------------------------------------------------}
// only accepts numbers to be pasted into the grid
  var
   i, m, j, k, Kr, StartCol: integer;
   c: char ;
//   fs : TFormatSettings;

begin
  // MessageDlg(Value, mtInformation, [mbOK], 0);
  m := Length(Value);
  (Sender as TStringGrid).Cells[ACol,ARow] := '' ;
  StartCol := ACol ;
  i := 1;
  Kr := 2;
//  DecimalSeparator:=fs.DecimalSeparator;
  while i <= m do begin
  // loop through the characters of the Value string
    c := Value[i];
    j := Integer(c);
    if j = 9 then
    begin // tab: Move to next column
      ACol := ACol + 1 ;
      if i < m then // empty the cell if not at end
        (Sender as TStringGrid).Cells[ACol,ARow] := '' ;
    end
    else if j = 13 then
    begin // CR - is followed by LF
         // Move to next row, jump back to startcolumn
      CoordStringGrid.RowCount:=Kr;
      Kr:=Kr+1;
      ARow := ARow + 1 ;
      ACol := startcol ;
      i := i + 1 ; // skip the LF
      if i < m then // empty the cell it if not at end
        (Sender as TStringGrid).Cells[ACol,ARow] := '' ;
    end
    else // add the character to the string in the cell if a number
    if c in [DecimalSeparator,'-',#48,#49,#50,#51,#52,#53,#54,#55,#56,#57] then
        (Sender as TStringGrid).Cells[ACol,ARow] :=
          ConCat((Sender as TStringGrid).Cells[ACol,ARow], c);
    i := i + 1 ;
  end;
  CoordStringGrid.FixedCols:=1;
  CoordStringGrid.FixedRows:=1;
  DataMod.NrOfData:=CoordStringGrid.RowCount-1;
  for k:=1 to DataMod.TotNrOfPoly do
  begin
    DataMod.Xcoord[k-1]:=MainForm.StringToFloat(CoordStringGrid.Cells[1,k]);
    DataMod.Ycoord[k-1]:=MainForm.StringToFloat(CoordStringGrid.Cells[2,k]);
//    MainForm.Poly_StringGrid.Cells[1,k]:=CoordStringGrid.Cells[1,k];
//    MainForm.Poly_StringGrid.Cells[2,k]:=CoordStringGrid.Cells[2,k];
  end;
end; {TTransForm.HandlePasteCells}


procedure TTransForm.AngleButtonClick(Sender: TObject);
begin
  AngleLabel.Visible:=true;
  AngleEdit.Visible:=true;
  RotateButton.Visible:=true;
end;


procedure TTransForm.EndButtonClick(Sender: TObject);
begin
  AngleLabel.Visible:=false;
  AngleEdit.Visible:=false;
  RotateButton.Visible:=false;
  ShiftPanel.Visible:=false;
  MoveButton.Visible:=false;
  ShiftYEdit.Visible:=true;
  MainForm.Identity:='Finished';
  MainForm.Pasted:=true;
  if Changed then
  begin
     Showmessage ('For viewing the new network map, the Group Data need'+
                  ' to be saved first');
     Changed:=false;
  end;
  MainForm.ShowOverallTable;
  TransForm.Hide;
end;



procedure TTransForm.AngleEditExit(Sender: TObject);
begin
  Try Angle:=MainForm.stringtofloat(AngleEdit.Text);
      Except on E: exception do
      begin
        Showmessage ('There is a problem with the angle. Please try again');
        exit;
      end;
  end;
  while Angle>360 do Angle:=Angle-360;
  while Angle<0 do Angle:=360+Angle;
  Angle:=2*pi*Angle/360;
  if Angle<>0 then Changed := true;
end;



procedure TTransForm.RotateButtonClick(Sender: TObject);

var k                : integer;
    Z1, Z2           : string;
    X1, Y1, X2, Y2,
    R, alfa1, alfa2,
    Add, Add1        : real;
    XX1              : array of real;

begin

  Add:=0;
  Add1:=0;
  for k:=1 to DataMod.TotNrOfPoly do
  begin
    setlength (XX1,k+1);
    XX1[k] := MainForm.StringToFloat(MainForm.PolyGroupEdit[2,k].Text);
    if XX1[k]=0 then Add:=1;
    if XX1[k]<0 then Add1:=-XX1[k];
    if Add<Add1 then Add:=Add1;
  end;

// DEZE WERKT MAAR GEEFT SCHUINE HOEKEN
  for k:=1 to DataMod.TotNrOfPoly do
  begin
    X1 := MainForm.StringToFloat(CoordStringGrid.Cells[1,k])+Add;
    Y1 := MainForm.StringToFloat(CoordStringGrid.Cells[2,k]);
    R := sqrt(X1*X1+Y1*Y1);
    Alfa1:=(arctan(Y1/X1));
    Alfa2 := Alfa1-Angle;
    X2 := R*cos(alfa2)-Add;
    Y2 := R*sin(alfa2);
    Z1 := format('%8.4f',[X2]);
    Z2 := format('%8.4f',[Y2]);
    CoordStringGrid.Cells[1,k] := Z1;
    CoordStringGrid.Cells[2,k] := Z2;
    DataMod.Xcoord[k-1]:=strtofloat(Z1);
    DataMod.Ycoord[k-1]:=strtofloat(Z2);
  end;
  AngleLabel.Visible:=false;
  AngleEdit.Visible:=false;
  RotateButton.Visible:=false;
//  Networkform.NetworkPicture;
end;


procedure TTransForm.ShiftButtonClick(Sender: TObject);
begin
  ShiftPanel.Visible:=true;
  MoveButton.Visible:=true;
end;


procedure TTransForm.ShiftXEditExit(Sender: TObject);
begin
  Try DeltaX:=MainForm.stringtofloat(ShiftXEdit.Text);
      Except on E: exception do
      begin
        Showmessage ('There is a problem with the X shift value. Please try again');
        exit;
      end;
  end;
  if DeltaX<>0 then Changed := true;
end;


procedure TTransForm.ShiftYEditExit(Sender: TObject);
begin
  Try DeltaY:=MainForm.stringtofloat(ShiftYEdit.Text);
      Except on E: exception do
      begin
        Showmessage ('There is a problem with the Y shift value. Please try again');
        exit;
      end;
  end;
  if DeltaY<>0 then Changed := true;
end;


procedure TTransForm.MoveButtonClick(Sender: TObject);
var X1, Y1, X2, Y2 : real; Z1, Z2 : string; K : integer;
begin
  for k:=1 to DataMod.TotNrOfPoly do
  begin
    X1 := MainForm.StringToFloat(CoordStringGrid.Cells[1,k]);
    Y1 := MainForm.StringToFloat(CoordStringGrid.Cells[2,k]);
    X2 := X1+DeltaX;
    Y2 := Y1+DeltaY;
    Z1 := format('%8.4f',[X2]);
    Z2 := format('%8.4f',[Y2]);
    CoordStringGrid.Cells[1,k] := Z1;
    CoordStringGrid.Cells[2,k] := Z2;
    DataMod.Xcoord[k-1]:=strtofloat(Z1);
    DataMod.Ycoord[k-1]:=strtofloat(Z2);
    ShiftXLabel.Visible:=false;
    ShiftXEdit.Visible:=false;
    ShiftYLabel.Visible:=false;
    ShiftYEdit.Visible:=false;
    MoveButton.Visible:=false;
  end;

end;

end.
