unit USelectPolyForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TSelectPolyForm = class(TForm)
    SelectPolyStringGrid: TStringGrid;
    SelectPoly_Memo: TMemo;
    Ready_Button: TButton;
    NetworkMap_Button: TButton;
    ExampleButton: TButton;
    CancelButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure Ready_ButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NetworkMap_ButtonClick(Sender: TObject);
    procedure ExampleButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectPolyForm: TSelectPolyForm;

implementation

uses UMainForm, UDataMod, UExtraUtils, UNetworkForm, USelectExampleForm;

{$R *.dfm}


procedure TSelectPolyForm.FormShow(Sender: TObject);
{--------------------------------------------------}
var i : integer;
begin
  SelectPolyStringGrid.EditorMode:=true;
  SelectPolyStringGrid.RowCount:=DataMod.NrOfIntPoly;
  SelectPolyStringGrid.Height:=20+20*(DataMod.NrOfIntPoly);
  if SelectPolyStringGrid.Height>312 then
     SelectPolyStringGrid.Height:=312;
  for i:=0 to DataMod.NrOfIntPoly-1 do
      SelectPolyStringGrid.Cells[0,i]:=IntToStr(DataMod.NodalNr[i]);
end; {TSelectPolyForm.FormShow}
{-----------------------------}



procedure TSelectPolyForm.Ready_ButtonClick(Sender: TObject);
{-----------------------------------------------------------}
label 1;
var i, j, k, HlpInt, NrSelected : integer;
    PolySelection : array of integer;
begin
  with DataMod do
  begin
    NrOfPolySelected:=0;
    setlength (Polyselection,DataMod.NrOfIntPoly);
    for i:=0 to DataMod.NrOfIntPoly-1 do Polyselection[i]:=-1;
    for i:=0 to DataMod.NrOfIntPoly-1 do
    begin
      if not (SelectPolyStringGrid.Cells[1,i]='') then
      begin
        Try
          begin
            HlpInt := StrToInt (SelectPolyStringGrid.Cells[1,i]);
            PolySelection[i]:=HlpInt;
          end;
          Except on E: exception do
          begin
            Showmessage ('The entry in row '+IntToStr(i+1)+
                         ' is not a valid integer.');
            Formshow (Sender);
          end;
        end;
      end;
    end;

    NrSelected:=0;
    for i:=0 to DataMod.NrOfIntPoly-1 do
      if PolySelection[i]>0 then NrSelected:=NrSelected+1;

    for i:=0 to NrSelected-1 do
      if (PolySelection[i]=0) or (PolySelection[i]>NrSelected) then
      begin
        showmessage ('The serial numbers should be greater than zero and less'+
                     ' than the total number selected.');
        Formshow (Sender);
        exit;
      end;

    for i:=0 to DataMod.NrOfIntPoly-2 do if Polyselection[i]>0 then
        for k:= i+1 to DataMod.NrOfIntPoly-1 do
            if Polyselection[i]=PolySelection[k] then
            begin
              showmessage ('There should be no duplicate serial numbers.');
              Formshow (Sender);
              exit;
            end;
    j:=0;
    k:=1;
1:  for i:=0 to DataMod.NrOfIntPoly-1 do
      if PolySelection[i]=k then
      begin
        k:=k+1;
        Setlength (PolySelected,j+1);
        NrOfPolySelected:=j+1;
        PolySelected[j]:=NodalNr[i];
        j:=j+1;
        goto 1;
      end;

    if NrSelected>2 then
    begin
      if NrSelected<>NrOfPolySelected then
        begin
          showmessage ('The serial numbers must be in the range of 1 to '+
                        IntToStr(NrSelected));
          Formshow (Sender);
          exit
        end;
    end else
    begin
       showmessage ('The number selected should be at least 3.'+
                    ' Graph is not shown');
       SelectPolyForm.Hide;
       MainForm.Output_Tabsheet.Show;
       exit;
    end;

  end; {with DataMod do}
  SelectPolyForm.Hide;
  DataMod.ReadSelectedPolyData(DataMod.GroupMark);
  MainForm.Graphics_Tabsheet.Show;
end; {TSelectPolyForm.Ready_ButtonClick}
{--------------------------------------}



procedure TSelectPolyForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  showmessage ('The selection of polygons is interrupted. Graph is not shown.');
  SelectPolyForm.Hide;
  MainForm.Output_Tabsheet.Show;
end;


procedure TSelectPolyForm.NetworkMap_ButtonClick(Sender: TObject);
begin
  NetworkForm.Show;
end;


procedure TSelectPolyForm.ExampleButtonClick(Sender: TObject);
begin
  if ExampleButton.Caption='See example' then
  begin
    SelectExampleForm.Show;
    ExampleButton.Caption:='Close example';
  end else
  begin
    SelectExampleForm.Hide;
    ExampleButton.Caption:='See example';
  end;
end;

procedure TSelectPolyForm.CancelButtonClick(Sender: TObject);
begin
    DataMod.NrOfPolySelected:=0;
    SelectPolyForm.Visible:=false;
    MainForm.Graphics_Tabsheet.Show;
end;

end.
