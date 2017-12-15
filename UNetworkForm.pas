unit UNetworkForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBaseForm, ExtCtrls, ComCtrls, StdCtrls, StdActns, ActnList;

  const                         {tbv graphics}
  PosX1=70;
  PosX2=PosX1+600;
  PosY1=70;
  PosY2=PosY1+300;
  LX = PosX2-PosX1;
  LY = PosY2-PosY1;

type
  TNetworkForm = class(TBaseForm)
    NetworkImage: TImage;
    SaveNetw_Button: TButton;
    MapSave_Dialog: TSaveDialog;

    procedure FormShow(Sender: TObject);
    procedure SaveNetw_ButtonClick(Sender: TObject);
    procedure MapSaveExecute(Sender: TObject);

  private
    { Private declarations }

  MiniY, MiniX, MaxiY, MaxiX : integer;
  Yscale, Xscale : integer;
  Kilo : boolean;
  Decim : integer;

  procedure MaxiMini;

  public
    { Public declarations }
  procedure NetworkPicture;
  end;

var
  NetworkForm: TNetworkForm;

implementation

uses UMainForm, UDataMod, UExtraUtils;

{$R *.dfm}

procedure TNetworkForm.FormShow(Sender: TObject);
var Checked : boolean;
var ii:integer;
begin
  inherited;
  for ii:=1 to 6 do setlength(DataMod.NrOfSides,DataMod.NrOfIntPoly);
  setlength (DataMod.NodeNr,DataMod.TotNrOfPoly);
  if OutputOpened and not InputOpened then
  begin
    for ii:=0 to DataMod.TotNrOfPoly-1 do
        DataMod.NodeNr[ii]:=DataMod.NodalNr[ii];
    for ii:=0 to DataMod.NrOfIntPoly-1 do
        DataMod.NrOfSides[ii]:=DataMod.NrOfNeighbors[ii];
                 // NodeNr, NodalNr, NrOfSides, NrOfNeighbors te vereningen
  end;
  CheckNetworkData (Checked);
  if not Checked then
  begin
    showmessage ('Due to network errors the map may look distorted.'+
                 ' Depending on the degree of distortion, the program may'+
                 ' not function well.');
//    exit;
  end;
  NetworkPicture;
end;



procedure TNetworkForm.MaxiMini;
{------------------------------}

label 1;
var MarginX, MarginY : real;
    i : integer;

begin

1:Ymaxi := 0;
  Xmaxi := 0;
  Ymini := 10000000;
  Xmini := 10000000;

  with DataMod do
  begin

    for i:=0 to TotNrOfPoly-1 do
    begin
      if Ycoord[i]>Ymaxi then Ymaxi := Ycoord[i];
      if Ycoord[i]<Ymini then Ymini := Ycoord[i];
      if Xcoord[i]>Xmaxi then Xmaxi := Xcoord[i];
      if Xcoord[i]<Xmini then Xmini := Xcoord[i];
    end;
    Ymaxi:=Ymaxi+0.05*(Ymaxi-Ymini);
    Xmaxi:=Xmaxi+0.05*(Xmaxi-Xmini);
    Ymini:=Ymini-0.05*(Ymaxi-Ymini);
    Xmini:=Xmini-0.05*(Xmaxi-Xmini);

    Kilo := false;
    if Kilo=false then if ((Ymaxi>10000) or (Xmaxi>10000)) then
    begin
      Kilo:=true;
      for i:=1 to TotNrOfPoly do
      begin
        Xcoord[i]:=Xcoord[i]/1000;
        Ycoord[i]:=Ycoord[i]/1000;
      end;
      goto 1;
    end;

    MarginX := 0.1*Xmaxi;
    MarginY := 0.1*Ymaxi;

    if Ymaxi<10 then
    begin
      decim := 1;
      MiniY := round (Ymini-MarginX);
      MaxiY := round (Ymaxi+MarginY);
      Yscale := MaxiY-MiniY;
    end
    else if Ymaxi<100 then
    begin
      decim := 0;
      MiniY := round ((Ymini-MarginY));
      MaxiY := round ((Ymaxi+MarginY));
      Yscale := (MaxiY-MiniY) div 10;
    end
    else if Ymaxi<1000 then
    begin
      decim := 0;
      MiniY := 10*round ((Ymini-MarginY)/10);
      MaxiY := 10*round ((Ymaxi+MarginY)/10);
      Yscale := (MaxiY-MiniY) div 100;
    end
    else if Ymaxi<10000 then
    begin
      decim := 0;
      MiniY := 100*round ((Ymini-MarginY)/100);
      MaxiY := 100*round ((Ymaxi+MarginY)/100);
      Yscale := (MaxiY-MiniY) div 1000;
    end
    else if Ymaxi<100000 then
    begin
      decim := 0;
      MiniY := 1000*round ((Ymini-MarginY)/1000);
      MaxiY := 1000*round ((Ymaxi+MarginY)/1000);
      Yscale := (MaxiY-MiniY) div 10000;
    end
    else if Ymaxi<1000000 then
    begin
      decim := 0;
      MiniY := 10000*round ((Ymini-MarginY)/10000);
      MaxiY := 10000*round ((Ymaxi+MarginY)/10000);
      Yscale := (MaxiY-MiniY) div 100000;
    end;

    if Xmaxi<10 then
    begin
      decim := 1;
      MiniX := round (Xmini-MarginX);
      MaxiX := round (Xmaxi+MarginX);
      Xscale := MaxiX-MiniX;
    end
    else if Xmaxi<100 then
    begin
      decim := 0;
      MiniX := round(Xmini-MarginX);
      MaxiX := round(Xmaxi+MarginX);
      Xscale := (MaxiX-MiniX) div 10;
    end
    else if Xmaxi<1000 then
    begin
      decim := 0;
      MiniX := 10*round ((Xmini-MarginX)/10);
      MaxiX := 10*round ((Xmaxi+MarginX)/10);
      Xscale := (MaxiX-MiniX) div 100;
    end
    else if Xmaxi<10000 then
    begin
      decim := 0;
      MiniX := 100*round ((Xmini-MarginX)/100);
      MaxiX := 100*round ((Xmaxi+MarginX)/100);
      Xscale := (MaxiX-MiniX) div 1000;
    end
    else if Xmaxi<100000 then
    begin
      decim := 0;
      MiniX := 1000*round ((Xmini-MarginX)/1000);
      MaxiX := 1000*round ((Xmaxi+MarginX)/1000);
      Xscale := (MaxiX-MiniX) div 10000;
    end
    else if Xmaxi<1000000 then
    begin
      decim := 0;
      MiniX := 10000*round ((Xmini-MarginX)/10000);
      MaxiX := 10000*round ((Xmaxi+MarginX)/10000);
      Xscale := (MaxiX-MiniX) div 100000;
    end;

    if Yscale<3 then Yscale := 4;
    if Xscale<3 then Xscale := 4;

  end;  {with DataMod do}

end; {procedure TNetworkForm.MaxiMini;}
{-------------------------------------}



procedure TNetworkForm.NetworkPicture;
{------------------------------------}
label 1;
var i, ii, jj, Num           : integer;
    RelX, RelY               : integer;
    DumReal, Yrel, Xrel      : real;
    LegendX, LegendY, NameStr: string;
    PlotRelY, PlotRelX : array[1..6] of real;
    RelPlotX, RelPlotY : array[1..6] of integer;

begin

  MaxiMini;
  LegendX := 'X-coord. (cm)';
  LegendY := 'Y-coord. (cm)';
  if (Kilo) then
  begin
    LegendY := 'Y-coord.*1000';
    LegendX := 'X-coord.*1000';
  end;
  With NetworkImage.Canvas do with DataMod do
  begin
    Brush.Color := clWhite;
    FillRect(NetworkImage.Canvas.ClipRect);
    Font.Style := [fsBold];
    Font.Color := clTeal;      {for the titles}
    Brush.Color := $00f5fffa;
    Font.Color := clMaroon;     {for the text}
    Pen.Color := clBlue;        {for the lines}
    TextOut (365,PosY2+26,LegendX);
    TextOut (PosX1-4,40,LegendY);
    NameStr:=inttostr(DataMod.Scale);
    NameStr:='NODAL NETWORK, Scale=1:'+Namestr;
    TextOut (275,25,NameStr);

// Y and X axes
    for ii:=0 to Yscale do                         { vertical axis }
    begin
      Moveto (posX1,round(posY1+(ii/Yscale)*LY));
      Lineto (posX1-4, round(posY1+(ii/YScale)*LY));
      DumReal := ii/Yscale*(MaxiY-MiniY);
      NameStr := format('%' + IntToStr(2 + Decim) + '.' +
                 IntToStr(Decim) + 'f', [MaxiY - DumReal]);
          {bijv. '%3.1f' voor 1 decimaal, 3 cijfers, float number}
         Textout ((posX1-TextWidth(NameStr)-6),
         (round(posY1+(ii/Yscale)*LY)-round(1/2*TextHeight(NameStr))),
                                                            NameStr);
    end; {for ii:=0 to ScalarY do}

    if MaxiX=MiniX then MiniX := 0;
    if (MaxiX<>MiniX) then                            { horizontal scale }
    for ii:=0 to Xscale do
    begin
      Moveto (round(posX1+(ii/Xscale)*LX),posY2);
      Lineto (round(posX1+(ii/Xscale)*LX),PosY2+4);
      Str (MiniX+ii/Xscale*(MaxiX-MiniX):2:Decim, DumStr);
      TextOut (round(posX1-8+(ii/Xscale)*LX),PosY2+12,DumStr);
    end else
    begin
      Moveto (posX1,320);
      Lineto (posX1,324);
      Str (Xmaxi:2:2,DumStr);
      TextOut (round(posX1-8),356,DumStr);
    end;

    moveto (PosX1,PosY2+4);                              {Axis lines}
    lineto (PosX1,PosY1);
    moveto (PosX1,PosY2);
    lineto (PosX2,PosY2);

    Font.Color := clBlack;     {for the text}
    if OpenFileName<>'' then
    TextOut (70,PosY2+55,'SahysMod: ' + OpenFileName)
    else
    TextOut (70,PosY2+55,'SahysMod: new network');
    Font.Color := clMaroon;
    TextOut (70,PosY2+75,'* internal node');
    Font.Color:=clFuchsia;
    TextOut (200,PosY2+75,'* external node');
    Font.Color := clMaroon;     {for the text}

    for jj:=0 to TotNrOfPoly-1 do                   {plotting of nodal numbers}
    begin
      XRel := LX*(DataMod.Xcoord[jj]-MiniX)/(MaxiX-MiniX);
      RelX := PosX1+round(XRel);
      YRel := LY*(DataMod.Ycoord[jj]-MiniY)/(MaxiY-MiniY);
      RelY := PosY2-round(YRel);
      NameStr := IntToStr (NodeNr[jj]);
      if jj>NrOfIntPoly-1 then Font.Color:=clFuchsia;
      TextOut (RelX,RelY-6,NameStr);
    end;
    setlength (RelXdata,6);
                                                      {plotting of nodal areas}
  for ii:=1 to 7 do setlength (SideNr[ii],NrOfIntPoly);
  for ii:=0 to NrOfIntPoly-1 do for jj:=1 to NrOfSides[ii] do
      SideNr[jj,ii]:=Neighbor[jj,ii];
//Re-arranging nodal relations to match the coordinates: internal nodes have
//been arranged 0..NrOfIntNodes-1 and external nodes NrOfIntNodes..TotNrOfNodes
//but their identification numbers may be different and adjustment is required
  Num:=TotNrOfPoly;
  for i:=0 to TotNrOfPoly-1 do
      if NodeNr[i]>Num then Num:=NodeNr[i];
  setlength (SeqNr,Num+1);
  jj:=-1;
  for i:=0 to TotNrOfPoly-1 do
  begin
    jj:=jj+1;
    SeqNr[NodeNr[i]]:=jj;
  end;
(* tijdelijk,  kan weg?? *)
  for ii:=1 to 6 do setlength (SideNr[ii],2*DataMod.TotNrOfPoly);

  for i:=1 to NrOfIntPoly do
  begin
    Num:=i;
    GetCorners(Num);
    Num:=NrOfSides[i-1];
    if Num>2 then for ii:=1 to Num do
    begin
      PlotRelY[ii] := LY*(PointY[ii]-MiniY)/(MaxiY-MiniY);
      RelPlotY[ii] := PosY2-round(PlotRelY[ii]);
      PlotRelX[ii] := LX*(PointX[ii]-MiniX)/(MaxiX-MiniX);
      RelPlotX[ii] := PosX1+round(PlotRelX[ii]);
(*
      PlotRelY[ii] := LY*(PointY[ii]-YMini)/(YMaxi-YMini);
      RelPlotY[ii] := PosY2-round(PlotRelY[ii]);
      PlotRelX[ii] := LX*(PointX[ii]-XMini)/(XMaxi-XMini);
      RelPlotX[ii] := PosX1+round(PlotRelX[ii]);
*)
    end;
    if Num>2 then for ii:=1 to Num do
    begin
      if ii<Num then
      begin
        moveto(RelPlotX[ii],RelPlotY[ii]);
        lineto(RelPlotX[ii+1],RelPlotY[ii+1]);
      end;
      if ii=Num then
      begin
        moveto(RelPlotX[Num],RelPlotY[Num]);
        lineto(RelPlotX[1],RelPlotY[1]);
      end;
    end;
  end;

  end; {With NetworkImage.Canvas do with DataMod do}
end; {TNetworkForm.NetworkPicture}
{--------------------------------}


procedure TNetworkForm.SaveNetw_ButtonClick(Sender: TObject);
{-----------------------------------------------------------}
begin
  inherited;
  MapSaveExecute (Sender);
end; {TNetworkForm.SaveNetw_ButtonClick}
{--------------------------------------}


procedure TNetworkForm.MapSaveExecute(Sender: TObject);
var Result : boolean;
    MapName : string;
begin
  inherited;
      if MapSave_Dialog.Execute then with DataMod do
      begin MapName := MapSave_Dialog.Files.Strings[0];
        if FileExists(MapName) then
             Result := Question('The map file already exists, overwrite?')
        else Result := true;
        if Result then
        begin
          NetworkImage.Picture.SaveToFile(MapName);
          Showmessage ('The network map was saved in  ' + MapName);
        end;
      end
      else Showmessage ('The network map was not saved');

end;

end.

