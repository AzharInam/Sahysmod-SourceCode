unit UColumnsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBaseForm, ComCtrls, StdCtrls, Grids;

type
  TColumnsForm = class(TBaseForm)
    ColumnsStringGrid: TStringGrid;
    Memo1: TMemo;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ColumnsForm: TColumnsForm;

implementation

uses UMainForm, UDataMod;

{$R *.dfm}

procedure TColumnsForm.FormShow(Sender: TObject);
var j : byte;
begin
  inherited;
  if MainForm.GroupsType='Polygonal' then
    begin
    ColumnsStringGrid.ColCount:=DataMod.NrOfitems;
    ColumnsStringGrid.Width:=10+60*(DataMod.NrOfItems);
    ColumnsStringGrid.FixedCols:=1;
    ColumnsStringGrid.RowCount:=2;
    ColumnsStringGrid.Cells[0,0]:=' Nodes';
    ColumnsStringGrid.Cells[1,0]:=' ';
    ColumnsStringGrid.Cells[0,1]:='  All';
    if MainForm.Identity='Conduct' then
    begin
      ColumnsStringGrid.FixedCols:=2;
      ColumnsStringGrid.Cells[0,0]:=' Nodes';
      ColumnsStringGrid.Cells[1,0]:=' Sides';
      ColumnsStringGrid.Cells[1,1]:='  All';
    end;
 end;
  if MainForm.GroupsType='Seasonal' then
  begin
    ColumnsStringGrid.ColCount:=DataMod.NrOfitems;
    ColumnsStringGrid.Width:=11+60*(DataMod.NrOfitems);
    ColumnsStringGrid.Height:=12+20*(DataMod.NrOfSeasons+1);
    ColumnsStringGrid.FixedCols:=2;
    ColumnsStringGrid.RowCount:=1+DataMod.NrOfSeasons;
    ColumnsStringGrid.Cells[0,0]:=' Nodes ';
    ColumnsStringGrid.Cells[1,0]:=' Season';
    ColumnsStringGrid.Cells[0,1]:='  All  ';
    for j:=1 to DataMod.NrOfSeasons do
    ColumnsStringGrid.Cells[1,j]:=IntToStr(j);
    if MainForm.Identity='Exthead' then
    begin
    end;
  end;
end;


procedure TColumnsForm.Button1Click(Sender: TObject);
var Count, NrOfPolygons, i, j, k : integer;
begin
  inherited;
  if MainForm.GroupsType='Polygonal' then
  begin
    NrOfPolygons:=DataMod.NrOfIntPoly;
    if MainForm.Identity='Extsal' then NrOfPolygons:=DataMod.NrOfExtPoly;
    if MainForm.Identity='Conduct' then
    begin
      Count:=0;
      for k:=0 to DataMod.NrOfIntPoly-1 do
          for j:=1 to DataMod.NrOfSides[k] do Count:=Count+1;
      if ColumnsStringGrid.Cells[2,1]<>'' then
         for k:=1 to Count do
             MainForm.Poly_StringGrid.Cells[2,k]:=ColumnsStringGrid.Cells[2,1];
      if ColumnsStringGrid.Cells[3,1]<>'' then
         for k:=1 to Count do
             MainForm.Poly_StringGrid.Cells[3,k]:=ColumnsStringGrid.Cells[3,1];
//         ColumnsStringGrid.Cells[3,1]:='';
    end else
    begin
      for j:=1 to DataMod.NrOfItems do
       if ColumnsStringGrid.Cells[j,1]<>'' then
          for k:=1 to NrOfPolygons do
          begin
            MainForm.Poly_StringGrid.Cells[j,k]:=ColumnsStringGrid.Cells[j,1];
//            ColumnsStringGrid.Cells[j,1]:='';
          end;
    end;
//    for j:=0 to Number do for k:=0 to 1 do ColumnsStringGrid.Cells[j,k]:='';
  end;
  if MainForm.GroupsType='Seasonal' then
  begin
    NrOfPolygons:=DataMod.NrOfIntPoly;
    if MainForm.Identity='Exthead' then NrOfPolygons:=DataMod.NrOfExtPoly;
    for i:=1 to DataMod.NrOfItems do
    begin
      for j:=1 to DataMod.NrOfSeasons do
      begin
        if ColumnsStringGrid.Cells[i+1,j]<>'' then
        begin
          Count:=j-DataMod.NrOfSeasons;
          for k:=1 to NrOfPolygons do
          begin
            Count:=Count+DataMod.NrOfSeasons;
            if ColumnsStringGrid.Cells[i+1,j]<>'' then
               MainForm.Season_StringGrid.Cells[i+1,Count]:=
                   ColumnsStringGrid.Cells[i+1,j];
//            ColumnsStringGrid.Cells[i+1,j]:='';
          end;
        end;
       end;
    end;
  end;
  ColumnsForm.Hide;
  for i:=1 to DataMod.NrOfItems do
        for j:=1 to DataMod.NrOfSeasons do
            ColumnsStringGrid.Cells[i,j]:='';
  MainForm.Show;
end;

procedure TColumnsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ColumnsForm.Hide;
end;

end.
