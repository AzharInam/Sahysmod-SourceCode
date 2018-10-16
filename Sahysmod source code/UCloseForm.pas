unit UCloseForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBaseForm, StdCtrls, ComCtrls;

type
  TCloseForm = class(TBaseForm)
    Finish_Memo: TMemo;
    Finish_Button: TButton;
    procedure FormShow(Sender: TObject);
    procedure Finish_ButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CloseForm: TCloseForm;

implementation

{$R *.dfm}


procedure TCloseForm.FormShow(Sender: TObject);
begin
  inherited;
  StatusText('Click on Finish button to end program.');
end;


procedure TCloseForm.Finish_ButtonClick(Sender: TObject);
begin
  inherited;
  Application.Terminate;
end;


procedure TCloseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Application.Terminate;
 { Application.ProcessMessages;}
end;


end.
