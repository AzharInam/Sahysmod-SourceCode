unit USelectClassesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, UMainForm, UNetWorkForm;

type
  TSelectClassesForm = class(TForm)
    Classes_Panel: TPanel;
    Classes_Grid: TStringGrid;
    Classes_ComboBox: TComboBox;
    Classes_Memo: TMemo;
    Classes_Button: TButton;
    Color_Panel: TPanel;
    Color_Label1: TLabel;
    Color_Label2: TLabel;
    Color_Label3: TLabel;
    Color_Label4: TLabel;
    Color_Label5: TLabel;
    Color_Label8: TLabel;
    Color_Label7: TLabel;
    Color_Label6: TLabel;
    Color_Label9: TLabel;
    Color_Label10: TLabel;
    Color_Memo: TMemo;
    NrOfClasses_ComboBox: TComboBox;
    CancelCButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Classes_ButtonClick(Sender: TObject);
    procedure Classes_ComboBoxChange(Sender: TObject);
    procedure NrOfClasses_ComboBoxChange(Sender: TObject);
    procedure CancelCButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectClassesForm: TSelectClassesForm;

implementation

{$R *.dfm}

procedure TSelectClassesForm.FormCreate(Sender: TObject);
var i:integer;
begin
  Classes_Grid.Cells[0,0]:='Class Nr.';
  Classes_Grid.Cells[1,0]:='Automatic';
  Classes_Grid.Cells[2,0]:='Preference';
  Classes_Grid.Cells[3,0]:='Color code';
  NrOfClasses_ComboBox.ItemIndex:=3;
  Classes_Grid.RowCount:=7;
  for i:=1 to 6 do Classes_Grid.Cells[0,i]:=inttostr(i);
  Classes_Grid.Cells[2,6]:='   n.a.';
  Classes_Grid.Cells[2,5]:='   n.a.';
  Classes_Grid.Cells[2,4]:='   n.a.';
  Classes_Grid.Cells[2,3]:='   n.a.';
  Classes_Grid.Cells[2,2]:='   n.a.';
  Classes_Grid.Cells[2,1]:='   n.a.';
  Classes_Grid.Cells[3,6]:='   n.a.';
  Classes_Grid.Cells[3,5]:='   n.a.';
  Classes_Grid.Cells[3,4]:='   n.a.';
  Classes_Grid.Cells[3,3]:='   n.a.';
  Classes_Grid.Cells[3,2]:='   n.a.';
  Classes_Grid.Cells[3,1]:='   n.a.';
  Classes_ComboBox.ItemIndex:=0;
end;

procedure TSelectClassesForm.Classes_ButtonClick(Sender: TObject);
begin
  NetWorkForm.Nodes_Button.Caption:='Remove node numbers';
  if Classes_ComboBox.ItemIndex=1 then
  begin
    NetWorkForm.Limit[1]:=mainform.stringtofloat(Classes_Grid.Cells[2,1]);
    NetWorkForm.Limit[2]:=mainform.stringtofloat(Classes_Grid.Cells[2,2]);
    NetWorkForm.Limit[3]:=mainform.stringtofloat(Classes_Grid.Cells[2,3]);
    if NrOfClasses_ComboBox.ItemIndex>0 then
    NetWorkForm.Limit[4]:=mainform.stringtofloat(Classes_Grid.Cells[2,4]);
    if NrOfClasses_ComboBox.ItemIndex>1 then
    NetWorkForm.Limit[5]:=mainform.stringtofloat(Classes_Grid.Cells[2,5]);
    if NrOfClasses_ComboBox.ItemIndex>2 then
    NetWorkForm.Limit[6]:=mainform.stringtofloat(Classes_Grid.Cells[2,6]);
    if NrOfClasses_ComboBox.ItemIndex>2 then
       NetWorkForm.ColorCode[6]:=strtoint(Classes_Grid.Cells[3,6]);
    if NrOfClasses_ComboBox.ItemIndex>1 then
       NetWorkForm.ColorCode[5]:=strtoint(Classes_Grid.Cells[3,5]);
    if NrOfClasses_ComboBox.ItemIndex>0 then
       NetWorkForm.ColorCode[4]:=strtoint(Classes_Grid.Cells[3,4]);
    NetWorkForm.ColorCode[3]:=strtoint(Classes_Grid.Cells[3,3]);
    NetWorkForm.ColorCode[2]:=strtoint(Classes_Grid.Cells[3,2]);
    NetWorkForm.ColorCode[1]:=strtoint(Classes_Grid.Cells[3,1]);
  end else
  begin
    NetWorkForm.Limit[1]:=mainform.stringtofloat(Classes_Grid.Cells[1,1]);
    NetWorkForm.Limit[2]:=mainform.stringtofloat(Classes_Grid.Cells[1,2]);
    NetWorkForm.Limit[3]:=mainform.stringtofloat(Classes_Grid.Cells[1,3]);
    NetWorkForm.Limit[4]:=mainform.stringtofloat(Classes_Grid.Cells[1,4]);
    NetWorkForm.Limit[5]:=mainform.stringtofloat(Classes_Grid.Cells[1,5]);
    NetWorkForm.Limit[6]:=mainform.stringtofloat(Classes_Grid.Cells[1,6]);
  end;
  if NrOfClasses_ComboBox.ItemIndex=3 then
     Classes_Grid.RowCount:=7;
  if NrOfClasses_ComboBox.ItemIndex=2 then
     Classes_Grid.RowCount:=6;
  if NrOfClasses_ComboBox.ItemIndex=1 then
     Classes_Grid.RowCount:=5;
  if NrOfClasses_ComboBox.ItemIndex=0 then
     Classes_Grid.RowCount:=4;
  SelectClassesForm.Visible:=false;
  MainForm.ShowNetWorkMap (Sender);

end;

procedure TSelectClassesForm.Classes_ComboBoxChange(Sender: TObject);
begin
  if Classes_ComboBox.ItemIndex=0 then
  begin
    Classes_Grid.Cells[1,6]:=format('%4.2f',[NetWorkForm.Limit[6]]);
    Classes_Grid.Cells[1,5]:=format('%4.2f',[NetWorkForm.Limit[5]]);
    Classes_Grid.Cells[1,4]:=format('%4.2f',[NetWorkForm.Limit[4]]);
    Classes_Grid.Cells[1,3]:=format('%4.2f',[NetWorkForm.Limit[3]]);
    Classes_Grid.Cells[1,2]:=format('%4.2f',[NetWorkForm.Limit[2]]);
    Classes_Grid.Cells[1,1]:=format('%4.2f',[NetWorkForm.Limit[1]]);
    Classes_Grid.Cells[2,6]:='   n.a.';
    Classes_Grid.Cells[2,5]:='   n.a.';
    Classes_Grid.Cells[2,4]:='   n.a.';
    Classes_Grid.Cells[2,3]:='   n.a.';
    Classes_Grid.Cells[2,2]:='   n.a.';
    Classes_Grid.Cells[2,1]:='   n.a.';
    Classes_Grid.Cells[3,6]:='   n.a.';
    Classes_Grid.Cells[3,5]:='   n.a.';
    Classes_Grid.Cells[3,4]:='   n.a.';
    Classes_Grid.Cells[3,3]:='   n.a.';
    Classes_Grid.Cells[3,2]:='   n.a.';
    Classes_Grid.Cells[3,1]:='   n.a.';
    Classes_Grid.ColCount:=2;
    SelectClassesForm.Width:=347;
    Color_Panel.Visible:=false;
    NrOfClasses_ComboBox.Visible:=false;
    NrOfClasses_ComboBox.ItemIndex:=3;
    Classes_Grid.RowCount:=7;
  end else
  begin
    Classes_Grid.Cells[1,6]:='   n.a.';
    Classes_Grid.Cells[1,5]:='   n.a.';
    Classes_Grid.Cells[1,4]:='   n.a.';
    Classes_Grid.Cells[1,3]:='   n.a.';
    Classes_Grid.Cells[1,2]:='   n.a.';
    Classes_Grid.Cells[1,1]:='   n.a.';
    Classes_Grid.Cells[2,6]:=' ';
    Classes_Grid.Cells[2,5]:=' ';
    Classes_Grid.Cells[2,4]:=' ';
    Classes_Grid.Cells[2,3]:=' ';
    Classes_Grid.Cells[2,2]:=' ';
    Classes_Grid.Cells[2,1]:=' ';
    Classes_Grid.Cells[3,6]:=' ';
    Classes_Grid.Cells[3,5]:=' ';
    Classes_Grid.Cells[3,4]:=' ';
    Classes_Grid.Cells[3,3]:=' ';
    Classes_Grid.Cells[3,2]:=' ';
    Classes_Grid.Cells[3,1]:=' ';
    Classes_Grid.ColCount:=4;
    SelectClassesForm.Width:=466;
    Color_Panel.Visible:=true;
    NrOfClasses_ComboBox.Visible:=true;
    NrOfClasses_ComboBox.ItemIndex:=3;
    Classes_Grid.RowCount:=7;
  end;
end;

procedure TSelectClassesForm.NrOfClasses_ComboBoxChange(Sender: TObject);
begin
  if NrOfClasses_ComboBox.ItemIndex=3 then
     Classes_Grid.RowCount:=7;
  if NrOfClasses_ComboBox.ItemIndex=2 then
     Classes_Grid.RowCount:=6;
  if NrOfClasses_ComboBox.ItemIndex=1 then
     Classes_Grid.RowCount:=5;
  if NrOfClasses_ComboBox.ItemIndex=0 then
     Classes_Grid.RowCount:=4;
end;

procedure TSelectClassesForm.CancelCButtonClick(Sender: TObject);
begin
  MainForm.GroupOpened:=true;
  MainForm.Graphics_Tabsheet.Show;
  SelectClassesForm.Visible:=false;
end;

end.
