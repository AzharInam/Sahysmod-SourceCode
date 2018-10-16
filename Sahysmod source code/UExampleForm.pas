unit UExampleForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBaseForm, ExtCtrls, ComCtrls;

type
  TExampleForm = class(TBaseForm)
    ExampleImage: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExampleForm: TExampleForm;

implementation

{$R *.dfm}

end.
