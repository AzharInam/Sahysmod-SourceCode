unit USelectExampleForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls;

type
  TSelectExampleForm = class(TForm)
    ExampleStringGrid: TStringGrid;
    NodeMemo: TMemo;
    SelectMemo: TMemo;
    SelectionExplainMemo: TMemo;
    CancelEButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure CancelEButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectExampleForm: TSelectExampleForm;

implementation

uses USelectPolyForm;

{$R *.dfm}

procedure TSelectExampleForm.FormShow(Sender: TObject);
{-----------------------------------------------------}
var i : integer;
begin
  for i:=0 to 29 do
      ExampleStringGrid.Cells[0,i]:=IntToStr(i+1);
  ExampleStringGrid.Cells[1,3]:='1';
  ExampleStringGrid.Cells[1,5]:='2';
  ExampleStringGrid.Cells[1,7]:='3';
  ExampleStringGrid.Cells[1,18]:='4';
  ExampleStringGrid.Cells[1,16]:='5';
  ExampleStringGrid.Cells[1,28]:='6';
  ExampleStringGrid.Cells[1,25]:='7';
  ExampleStringGrid.Cells[1,10]:='8';
  ExampleStringGrid.Cells[1,8]:='9';
end; {TSelectExampleForm.FormShow}
{--------------------------------}


procedure TSelectExampleForm.CancelEButtonClick(Sender: TObject);
begin
  SelectPolyForm.ExampleButton.Caption:='See example';
  SelectExampleForm.Visible:=false;
end;

end.
