unit UBaseForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TBaseForm = class(TForm)
    StatusBar1: TStatusBar;
  private
    { Private declarations }
  protected
    { Project declarations }
     procedure StatusText(const Notice: string);
  public
    { Public declarations }
  end;

var
  BaseForm: TBaseForm;

implementation



{$R *.dfm}

procedure TBaseForm.StatusText(const Notice: string);
begin
  StatusBar1.SimpleText := Notice;
  Repaint;
end; {TBaseForm.statustext}



end.
