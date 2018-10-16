unit UMappingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMappingForm = class(TForm)
    Mapping_Memo: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MappingForm: TMappingForm;

implementation

{$R *.dfm}

end.
