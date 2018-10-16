unit UNodalHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TNodalHelpForm = class(TForm)
    NodalHelp_Memo: TMemo;
    SeeNetwork_Button: TButton;
    procedure SeeNetwork_ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NodalHelpForm: TNodalHelpForm;

implementation

  uses UExampleForm;

{$R *.dfm}

procedure TNodalHelpForm.SeeNetwork_ButtonClick(Sender: TObject);
begin
  ExampleForm.Show;
end;


end.
