unit USymbolsForm;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UExtraUtils;

type
  TSymbolsForm = class(TForm)
    OutputSymbolsMemo: TMemo;
    InputSymbolsMemo: TMemo;
    KrMemo: TMemo;
    SymbolsCloseButton: TButton;
    procedure SymbolsCloseButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SymbolsForm: TSymbolsForm;

implementation

{$R *.dfm}
procedure TSymbolsForm.SymbolsCloseButtonClick(Sender: TObject);
begin
  inherited;
  SymbolsForm.Hide;
end;


procedure TSymbolsForm.FormShow(Sender: TObject);
begin
  if Mode='Input' then
  begin
    InputSymbolsMemo.Visible:=true;
    OutputSymbolsMemo.Visible:=false;
    KrMemo.Visible:=false;
  end else
  if Mode='Output' then
  begin
    InputSymbolsMemo.Visible:=false;
    OutputSymbolsMemo.Visible:=true;
    KrMemo.Visible:=false;
  end else
  begin
    InputSymbolsMemo.Visible:=false;
    OutputSymbolsMemo.Visible:=false;
    KrMemo.Visible:=true;
  end;
end;

end.
