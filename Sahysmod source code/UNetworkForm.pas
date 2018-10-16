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
    Nodes_Button: TButton;
    SectionButton: TButton;

    procedure FormShow(Sender: TObject);
    procedure SaveNetw_ButtonClick(Sender: TObject);
    procedure MapSaveExecute(Sender: TObject);
    procedure Nodes_ButtonClick(Sender: TObject);
    procedure SectionButtonClick(Sender: TObject);

  private
    { Private declarations }

  MiniY, MiniX, MaxiY, MaxiX : integer;
  Yscale, Xscale             : integer;
  Kilo, YesOk                : boolean;
  DumReal                    : real;

  procedure MaxiMini;

  public
    { Public declarations }
  Limit       : array[1..6] of real;
  ColorCode   : array[1..6] of integer;
  Decim       : integer;
  Yrel, Xrel  : real;

  procedure NetworkPicture;

  end;

var
  NetworkForm: TNetworkForm;

implementation

uses UMainForm, UDataMod, UExtraUtils, USelectColumnForm, USelectClassesForm,
  USelectPolyForm;

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
  DataMod.ReadInputData;
  CheckNetworkData (Checked);
  if not Checked then
  begin
    showmessage ('Due to network errors the map may look distorted.'+
                 ' Depending on the degree of distortion, the program may'+
                 ' not function well.');
//    exit;
  end;
  if DataMod.ColorMap then
  begin
    NetWorkForm.Height:=620;
    NetworkImage.Height:=530;
  end else
  begin
    NetWorkForm.Height:=580;
    NetworkImage.Height:=480;
  end;

  YesOK:=true;
  SectionButton.Visible:=true;
  if DataMod.NrOfIntPoly<=20 then SectionButton.Visible:=false;
  NetworkPicture;
  
end; {NetworkForm.FormShow}



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
//    Ymaxi:=Ymaxi+0.05*(Ymaxi-Ymini);
//    Xmaxi:=Xmaxi+0.05*(Xmaxi-Xmini);
//    Ymini:=Ymini-0.05*(Ymaxi-Ymini);
//    Xmini:=Xmini-0.05*(Xmaxi-Xmini);

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
    LegendX, LegendY, NameStr: string;
    HlpStr, AuxStr           : string;
    NoMap                    : boolean;
    PlotRelY, PlotRelX       : array[1..6] of real;
    RelPlotX, RelPlotY       : array[1..6] of integer;
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
    Pen.Color := clWhite;
    Brush.Color := clWhite;
    FillRect(NetworkImage.Canvas.ClipRect);      {to clear the canvas}
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
    NameStr:=OpenFileName;
    if YesOK then
    begin
      if NameStr<>'' then
      begin
        NameStr:=extractfilename(NameStr);
        TextOut (80,PosY2+50,'      SahysMod: ' + NameStr);
      end else
        TextOut (80,PosY2+50,'      SahysMod: new network');
    end else
    begin
      if NameStr<>'' then
      begin
        NameStr:=extractfilename(NameStr);
        TextOut (45,PosY2+70,'      SahysMod: ' + NameStr);
      end else
        TextOut (45,PosY2+70,'      SahysMod: new network');
    end;

    Font.Size:=10;
    if TotNrOfPoly>50 then
    begin
       Font.Style:=[];
       Font.Size:=8;
    end;
    if TotNrOfPoly>100 then
    begin
       Font.Style:=[];
       Font.Size:=4;
    end;

    if not ColorMap and not MainForm.Internal_RadioButton.Checked then
    for jj:=0 to TotNrOfPoly-1 do                   {plotting of nodal numbers}
    begin
      XRel := LX*(DataMod.Xcoord[jj]-MiniX)/(MaxiX-MiniX);
      RelX := PosX1+round(XRel);
      YRel := LY*(DataMod.Ycoord[jj]-MiniY)/(MaxiY-MiniY);
      RelY := PosY2-round(YRel);
      NameStr := IntToStr (NodeNr[jj]);
      if jj>NrOfIntPoly-1 then Font.Color:=clFuchsia;
      TextOut (RelX-6,RelY-6,NameStr);
      if YesOK then
      begin
        Font.Color := clMaroon;
        TextOut (70,PosY2+65,'* internal node');
        Font.Color:=clFuchsia;
        TextOut (190,PosY2+65,'* external node');
      end;
      Font.Color := clMaroon;     {for the text}
    end;

    if ColorMap or MainForm.Internal_RadioButton.Checked then
    begin
(*
      if TotNrOfPoly>=150 then
         showmessage ('Owing to the large number of polygons the node'+
                      ' numbers will not be shown.');
      if TotNrOfPoly<150 then
         YesOK:=Question('Do you wish the nodal numbers to be shown in'+
                       ' the color map? ');
*)
//      if (TotNrOfPoly<150) and YesOK then
      if YesOK then for jj:=0 to TotNrOfPoly-1 do   {plotting of nodal numbers}
      begin
        XRel := LX*(DataMod.Xcoord[jj]-MiniX)/(MaxiX-MiniX);
        RelX := PosX1+round(XRel);
        YRel := LY*(DataMod.Ycoord[jj]-MiniY)/(MaxiY-MiniY);
        RelY := PosY2-round(YRel);
        NameStr := IntToStr (NodeNr[jj]);
        if jj>NrOfIntPoly-1 then Font.Color:=clFuchsia;
        TextOut (RelX-6,RelY-6,NameStr);
        Font.Color := clMaroon;
        TextOut (70,PosY2+65,'* internal node');
        Font.Color:=clFuchsia;
        TextOut (190,PosY2+65,'* external node');
        Font.Color := clMaroon;     {for the text}
      end;
      end else
      begin
      for jj:=0 to TotNrOfPoly-1 do                   {plotting of nodal numbers}
      begin
        XRel := LX*(DataMod.Xcoord[jj]-MiniX)/(MaxiX-MiniX);
        RelX := PosX1+round(XRel);
        YRel := LY*(DataMod.Ycoord[jj]-MiniY)/(MaxiY-MiniY);
        RelY := PosY2-round(YRel);
        NameStr := IntToStr (NodeNr[jj]);
        if jj>NrOfIntPoly-1 then Font.Color:=clFuchsia;
        TextOut (RelX-6,RelY-6,NameStr);
      end;
    end;

    if not ColorMap then
    begin
      Font.Color := clMaroon;
      TextOut (70,PosY2+65,'* internal node');
      Font.Color:=clFuchsia;
      TextOut (190,PosY2+65,'* external node');
      Font.Color := clMaroon;     {for the text}
    end;

    setlength (RelXdata,6);
    Font.Size:=10;
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

   if MainForm.Internal_RadioButton.Checked then
   begin
     ColNr:=1;
     DataMod.NrOfitems:=1;
     setlength (Variable[1],DataMod.NrOfIntPoly+1);
     for jj:=0 to DataMod.NrOfIntPoly-1 do
     DataMod.Variable[1,jj]:=TopLevel[jj];
     PosValues[1]:=true;
     DataMod.NrOfData:=DataMod.NrOfIntPoly;
     if SelectClassesForm.Classes_ComboBox.ItemIndex=0 then
     begin
       MaxMin;
       Xrel:=abs(Ymax[1]);
       Yrel:=abs(Ymin[1]);
       Limit[1]:=Yrel+(Xrel-Yrel)/7;
       Limit[2]:=Yrel+2*(Xrel-Yrel)/7;
       Limit[3]:=Yrel+3*(Xrel-Yrel)/7;
       Limit[4]:=Yrel+4*(Xrel-Yrel)/7;
       Limit[5]:=Yrel+5*(Xrel-Yrel)/7;
       Limit[6]:=Yrel+6*(Xrel-Yrel)/7;
     end;
   end;

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
      end;
      if Num>2 then for ii:=1 to Num do     {plot polygons}
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
      end; {if Num>2 then}

        if ColorMap then   {plotting colors}
        begin
          for ii:=1 to Num do
          begin
            PlotRelY[1] := LY*(PointY[ii]-MiniY)/(MaxiY-MiniY);
            RelPlotY[2] := PosY2-round(PlotRelY[ii]);
            PlotRelX[1] := LX*(PointX[ii]-MiniX)/(MaxiX-MiniX);
            RelPlotX[2] := PosX1+round(PlotRelX[ii]);
          end; {for ii:=1 to Num do}

              if MainForm.DepthWT_RadioButton.Checked then ColNr:=1;
              if MainForm.AvSal_RadioButton.Checked then ColNr:=3;
              if MainForm.SaltSto_RadioButton.Checked then ColNr:=5;
              if MainForm.Evapo_RadioButton.Checked then ColNr:=7;
              DumReal:=DataMod.Variable[ColNr,i-1];
              if MainForm.Internal_RadioButton.Checked then
                 DumReal:=DataMod.TopLevel[i-1];

              if DumReal<0 then
              begin
                Brush.Color:=clWhite;
                goto 1;
              end;

              if SelectClassesForm.NrOfClasses_ComboBox.ItemIndex=2 then
                   ColorCode[6]:=ColorCode[5];
              if SelectClassesForm.NrOfClasses_ComboBox.ItemIndex=1 then
              begin
                   ColorCode[6]:=ColorCode[4];
                   ColorCode[5]:=ColorCode[4];
              end;
              if SelectClassesForm.NrOfClasses_ComboBox.ItemIndex=0 then
              begin
                   ColorCode[6]:=ColorCode[3];
                   ColorCode[5]:=ColorCode[3];
                   ColorCode[4]:=ColorCode[3];
              end;

              if (SelectClassesForm.Classes_ComboBox.ItemIndex=0) then
              begin
                if (DumReal>Limit[6]) then Brush.Color:=clYellow;
                if (DumReal<=Limit[6]) and (DumReal>Limit[5]) then
                    Brush.Color:=$004080FF;
                if (DumReal<=Limit[5]) and (DumReal>Limit[4]) then
                    Brush.Color:=$00BFD6F7;
                if (DumReal<=Limit[4]) and (DumReal>Limit[3]) then
                    Brush.Color:=$0035AC13;
                if (DumReal<=Limit[3]) and (DumReal>Limit[2]) then
                    Brush.Color:=$0080ff80;
                if (DumReal<=Limit[2]) and (DumReal>Limit[1]) then
                    Brush.Color:=clAqua;
                if (DumReal<=Limit[1]) and (DumReal>0) then
                    Brush.Color:=$00E4925A;
                if (DumReal<=0) then Brush.Color:=clWhite;
             end;

{ItemIndex 3 wordt niet gebruikt !!!!!!}

              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) then
                if (DumReal>Limit[5]) then
                begin
                  if ColorCode[6]=1 then Brush.Color:=$0046A741
                  else if ColorCode[6]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[6]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[6]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[6]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[6]=5 then Brush.Color:=clRed
                  else if ColorCode[6]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[6]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[6]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[6]=9 then Brush.Color:=clSilver
                  else if ColorCode[6]=10 then Brush.Color:=$002D52A0
                end;

              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) then
                if (DumReal<=Limit[5]) and (DumReal>Limit[4]) then
                begin
                  if ColorCode[5]=1 then Brush.Color:=$0046A741
                  else if ColorCode[5]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[5]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[5]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[5]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[5]=5 then Brush.Color:=clRed
                  else if ColorCode[5]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[5]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[5]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[5]=9 then Brush.Color:=clSilver
                  else if ColorCode[5]=10 then Brush.Color:=$002D52A0
                end;

              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) then
                if (DumReal<=Limit[4]) and (DumReal>Limit[3]) then
                begin
                  if ColorCode[4]=1 then Brush.Color:=$0046A741
                  else if ColorCode[4]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[4]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[4]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[4]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[4]=5 then Brush.Color:=clRed
                  else if ColorCode[4]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[4]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[4]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[4]=9 then Brush.Color:=clSilver
                  else if ColorCode[4]=10 then Brush.Color:=$002D52A0
                end;

              if (DumReal<=Limit[3]) and (DumReal>Limit[2]) then
              begin
                if SelectClassesForm.Classes_ComboBox.ItemIndex=1 then
                begin
                  if ColorCode[3]=1 then Brush.Color:=$0046A741
                  else if ColorCode[3]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[3]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[3]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[3]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[3]=5 then Brush.Color:=clRed
                  else if ColorCode[3]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[3]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[3]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[3]=9 then Brush.Color:=clSilver
                  else if ColorCode[3]=10 then Brush.Color:=$002D52A0
                end else Brush.Color:=$0080ff80;
              end;

              if (DumReal<=Limit[2]) and (DumReal>Limit[1]) then
              begin
                if SelectClassesForm.Classes_ComboBox.ItemIndex=1 then
                begin
                  if ColorCode[2]=1 then Brush.Color:=$0046A741
                  else if ColorCode[2]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[2]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[2]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[2]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[2]=5 then Brush.Color:=clRed
                  else if ColorCode[2]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[2]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[2]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[2]=9 then Brush.Color:=clSilver
                  else if ColorCode[2]=10 then Brush.Color:=$002D52A0
                end else Brush.Color:=clAqua;
              end;

              if (DumReal<=Limit[1]) then
              begin
                if SelectClassesForm.Classes_ComboBox.ItemIndex=1 then
                begin
                  if ColorCode[1]=1 then Brush.Color:=$0046A741
                  else if ColorCode[1]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[1]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[1]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[1]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[1]=5 then Brush.Color:=clRed
                  else if ColorCode[1]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[1]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[1]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[1]=9 then Brush.Color:=clSilver
                  else if ColorCode[1]=10 then Brush.Color:=$002D52A0
                end else Brush.Color:=$00E4925A;
              end;
1:            Fillrect (Rect(RelPlotX[1],RelPlotY[1],
                        RelPlotX[3],RelPlotY[3]));

            Pen.Color := clMaroon;        {for the lines}
            if Num>2 then for ii:=1 to Num do     {plot polygons}
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
            end; {if Num>2 then}

            Font.Color := clMaroon;     {for the text}
            Font.Size:=10;
//            Brush.Color:=clscrollbar;
            if NrOfIntPoly>100 then
            begin
              Font.Style:=[];
              Font.Size:=8;
            end;
            if NrOfIntPoly>200 then
            begin
              Font.Style:=[];
              Font.Size:=4;
            end;

           if YesOK then
           begin
              XRel := LX*(DataMod.Xcoord[i-1]-MiniX)/(MaxiX-MiniX);
              RelX := PosX1+round(XRel);
              YRel := LY*(DataMod.Ycoord[i-1]-MiniY)/(MaxiY-MiniY);
              RelY := PosY2-round(YRel);
              NameStr := IntToStr (NodeNr[i-1]);
              TextOut (RelX-5,RelY-9,NameStr);
            end;

        end; {if ColorMap then}
  end; {for i:=1 to NrOfIntPoly do}

         if ColorMap then
         begin
            Brush.Color:=clwhite;
            if MainForm.SoilSal_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=1 then
               begin
                 AuxStr:='CrA';
                 if not DataPresent[1] then NoMap:=true;
               end;
               if ColNr=2 then
               begin
                 AuxStr:='CrB';
                 if not DataPresent[2] then NoMap:=true;
               end;
               if ColNr=3 then
               begin
                 AuxStr:='CrU';
                 if not DataPresent[3] then NoMap:=true;
               end;
               if ColNr=4 then
               begin
                 AuxStr:='Cr4';
                 if not DataPresent[4] then NoMap:=true;
               end;
               if ColNr=5 then
               begin
                 AuxStr:='C1*';
                 if not DataPresent[5] then NoMap:=true;
               end;
               if ColNr=6 then
               begin
                 AuxStr:='C2*';
                 if not DataPresent[6] then NoMap:=true;
               end;
               if ColNr=7 then
               begin
                 AuxStr:='C3*';
                 if not DataPresent[7] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= 'Classification of soil salinity '+AuxStr+
                            ' in dS/m for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.SoilSal_RadioButton.Checked then}

            if MainForm.AvSal_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NameStr:= 'Classification of weighted average salinity'+
                         ' in dS/m m for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;

            if MainForm.DepthWT_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NameStr:= 'Classification of watertable depth'+
                         ' in m for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;

            if MainForm.SubSal_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=1 then
               begin
                 AuxStr:='Cxf';
                 if not DataPresent[1] then NoMap:=true;
               end;
               if ColNr=2 then
               begin
                 AuxStr:='Cxa';
                 if not DataPresent[2] then NoMap:=true;
               end;
               if ColNr=3 then
               begin
                 AuxStr:='Cxb';
                 if not DataPresent[3] then NoMap:=true;
               end;
               if ColNr=4 then
               begin
                 AuxStr:='Cqb';
                 if not DataPresent[4] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= 'Classification of subsoil salinity '+AuxStr+
                            ' in dS/m for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end; {if MainForm.SubSal_RadioButton.Checked then}

            if MainForm.OtherSal_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=1 then
               begin
                 AuxStr:='Cti (trans. zone)';
                 if not DataPresent[1] then NoMap:=true;
               end;
               if ColNr=2 then
               begin
                 AuxStr:='Cqi (aquifer)';
                 if not DataPresent[2] then NoMap:=true;
               end;
               if ColNr=3 then
               begin
                 AuxStr:='Ci (irrigation)';
                 if not DataPresent[3] then NoMap:=true;
               end;
               if ColNr=4 then
               begin
                 AuxStr:='Cd (drainage) ';
                 if not DataPresent[4] then NoMap:=true;
               end;
               if ColNr=5 then
               begin
                 AuxStr:='Cw (wells)';
                 if not DataPresent[5] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= 'Classification of salinity '+AuxStr+
                            ' in dS/m for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.OtherSal_RadioButton.Checked then}

            if MainForm.SaltSto_RadioButton.Checked then
            begin
               NameStr:= 'Classification of salt at soil surface'+
                        ' in dS/m for year '+NameStr+' season '+HlpStr;
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=5 then
               begin
                 AuxStr:= 'Zs';
                 if not DataPresent[5] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= 'Classification of salt storage '+AuxStr+
                            ' in m.dS/m for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.SaltSto_RadioButton.Checked then}

            if MainForm.Groundwater_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=1 then
               begin
                 AuxStr:='Gti';
                 if not DataPresent[1] then NoMap:=true;
               end;
               if ColNr=2 then
               begin
                 AuxStr:='Gto';
                 if not DataPresent[2] then NoMap:=true;
               end;
               if ColNr=3 then
               begin
                 AuxStr:='Gtv';
                 if not DataPresent[3] then NoMap:=true;
               end;
               if ColNr=4 then
               begin
                 AuxStr:='Gqi';
                 if not DataPresent[4] then NoMap:=true;
               end;
               if ColNr=5 then
               begin
                 AuxStr:='Gqo';
                 if not DataPresent[5] then NoMap:=true;
               end;
               if ColNr=6 then
               begin
                 AuxStr:='Gaq';
                 if not DataPresent[6] then NoMap:=true;
               end;
               if ColNr=7 then
               begin
                 AuxStr:='Gnt';
                 if not DataPresent[5] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= ' Groundwater flow classes '+AuxStr+
                            ' in m/season for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.Groundwater_RadioButton.Checked then}


            if MainForm.Discharge_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=1 then
               begin
                 AuxStr:='Gd (drainage)';
                 if not DataPresent[1] then NoMap:=true;
               end;
               if ColNr=2 then
               begin
                 AuxStr:='Ga';
                 if not DataPresent[2] then NoMap:=true;
               end;
               if ColNr=3 then
               begin
                 AuxStr:='Gb';
                 if not DataPresent[3] then NoMap:=true;
               end;
               if ColNr=4 then
               begin
                 AuxStr:='Gw (wells)';
                 if not DataPresent[4] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= ' Drain and well discharge classes '+AuxStr+
                            ' in m/season for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.Discharge_RadioButton.Checked then}

            if MainForm.Percol_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=1 then
               begin
                 AuxStr:='LrA';
                 if not DataPresent[1] then NoMap:=true;
               end;
               if ColNr=2 then
               begin
                 AuxStr:='LrB';
                 if not DataPresent[2] then NoMap:=true;
               end;
               if ColNr=3 then
               begin
                 AuxStr:='LrU';
                 if not DataPresent[3] then NoMap:=true;
               end;
               if ColNr=4 then
               begin
                 AuxStr:='Lr';
                 if not DataPresent[4] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= ' Percolation classes for '+AuxStr+
                            ' in m/season for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.Percol_RadioButton.Checked then}

            if MainForm.Capil_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=1 then
               begin
                 AuxStr:='RrA';
                 if not DataPresent[1] then NoMap:=true;
               end;
               if ColNr=2 then
               begin
                 AuxStr:='RrB';
                 if not DataPresent[2] then NoMap:=true;
               end;
               if ColNr=3 then
               begin
                 AuxStr:='RrU';
                 if not DataPresent[3] then NoMap:=true;
               end;
               if ColNr=4 then
               begin
                 AuxStr:='Rr';
                 if not DataPresent[4] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= ' Capillary rise classes for '+AuxStr+
                            ' in m/season for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.Capil_RadioButton.Checked then}

            if MainForm.CanalIrr_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=1 then
               begin
                 AuxStr:='It';
                 if not DataPresent[1] then NoMap:=true;
               end;
               if ColNr=2 then
               begin
                 AuxStr:='Is';
                 if not DataPresent[2] then NoMap:=true;
               end;
               if ColNr=3 then
               begin
                 AuxStr:='IaA';
                 if not DataPresent[3] then NoMap:=true;
               end;
               if ColNr=4 then
               begin
                 AuxStr:='IaB';
                 if not DataPresent[4] then NoMap:=true;
               end;
               if ColNr=5 then
               begin
                 AuxStr:='Io';
                 if not DataPresent[5] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= ' Irrigation classes for '+AuxStr+
                            ' in m/season for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.CanalIrr_RadioButton.Checked then}

            if MainForm.IrrEff_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=1 then
               begin
                 AuxStr:='Ffa';
                 if not DataPresent[1] then NoMap:=true;
               end;
               if ColNr=2 then
               begin
                 AuxStr:='FfB';
                 if not DataPresent[2] then NoMap:=true;
               end;
               if ColNr=3 then
               begin
                 AuxStr:='Fft';
                 if not DataPresent[3] then NoMap:=true;
               end;
               if ColNr=4 then
               begin
                 AuxStr:='JsA';
                 if not DataPresent[4] then NoMap:=true;
               end;
               if ColNr=5 then
               begin
                 AuxStr:='JsB';
                 if not DataPresent[5] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= ' Irrigation efficiency classes for '+AuxStr+
                            ' for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.IrrEff_RadioButton.Checked then}

            if MainForm.Evapo_RadioButton.Checked then
            begin
               NameStr:= 'Classification of net evaporation'+
                        ' in in m/season for year '+NameStr+' season '+HlpStr;
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               AuxStr:= 'EaU';
               if not DataPresent[7] then NoMap:=true;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= 'Classification of net evaporation '+AuxStr+
                            ' in m/season for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.Evapo_RadioButton.Checked then}

            if MainForm.CropArea_RadioButton.Checked then
            begin
               NameStr:=inttostr(YearWanted);
               HlpStr:=inttostr(SeasonWanted);
               NoMap:=false;
               if ColNr=1 then
               begin
                 AuxStr:='A land';
                 if not DataPresent[1] then NoMap:=true;
               end;
               if ColNr=2 then
               begin
                 AuxStr:='B land';
                 if not DataPresent[2] then NoMap:=true;
               end;
               if ColNr=3 then
               begin
                 AuxStr:='U land';
                 if not DataPresent[3] then NoMap:=true;
               end;
               if ColNr=4 then
               begin
                 AuxStr:='Uc land';
                 if not DataPresent[4] then NoMap:=true;
               end;
               if NoMap then
                  NameStr:= ' In group '+AuxStr+' no data are present.'+
                            ' Hence no map colors shown.              '
               else
                  NameStr:= ' Crop area fractions of '+AuxStr+
                            ' for year '+NameStr+' season '+HlpStr+
                            '                    ';
               TextOut (70,PosY2+90,NameStr);
            end;  {if MainForm.CropArea_RadioButton.Checked then}

            if MainForm.Internal_RadioButton.Checked then
            begin
              NameStr:= ' Topographic surface level classes in m.'+
                        '                                        ';
              TextOut (70,PosY2+90,NameStr);
            end;

                if MainForm.DepthWT_RadioButton.Checked then ColNr:=1;
                if MainForm.AvSal_RadioButton.Checked then ColNr:=3;

                if SelectClassesForm.Classes_ComboBox.ItemIndex=1 then
                begin
                  if ColorCode[1]=1 then Brush.Color:=$0046A741
                  else if ColorCode[1]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[1]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[1]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[1]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[1]=5 then Brush.Color:=clRed
                  else if ColorCode[1]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[1]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[1]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[1]=9 then Brush.Color:=clSilver
                  else if ColorCode[1]=10 then Brush.Color:=$002D52A0
                end else Brush.Color:=$00E4925A;

              if Ymax[DataMod.ColNr]<1.001 then
                 NameStr:=' < ' + format('%4.2f',[Limit[1]]) + '  '
              else
              if Ymax[DataMod.ColNr]>10 then
                 NameStr:=' < ' + format('%4.0f',[Limit[1]]) + '  '
              else
                 NameStr:=' < ' + format('%5.1f',[Limit[1]]) + '  ';
              TextOut (90,PosY2+110,NameStr);

                if SelectClassesForm.Classes_ComboBox.ItemIndex=1 then
                begin
                  if ColorCode[2]=1 then Brush.Color:=$0046A741
                  else if ColorCode[2]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[2]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[2]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[2]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[2]=5 then Brush.Color:=clRed
                  else if ColorCode[2]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[2]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[2]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[2]=9 then Brush.Color:=clSilver
                  else if ColorCode[2]=10 then Brush.Color:=$002D52A0
                end else Brush.Color:=clAqua;

              if Ymax[DataMod.ColNr]<1.001 then
              begin
                 HlpStr:=format('%4.2f',[Limit[1]]);
                 NameStr:=HlpStr + ' -' + format('%4.2f',[Limit[2]])+'  '
              end else
              if Ymax[DataMod.ColNr]>10 then
              begin
                 HlpStr:=format('%4.0f',[Limit[1]]);
                 NameStr:=HlpStr + ' -' + format('%4.0f',[Limit[2]])+'  '
              end else
              begin
                 HlpStr:=format('%4.1f',[Limit[1]]);
                 NameStr:=HlpStr + ' -' + format('%4.1f',[Limit[2]])+'  ';
              end;
              TextOut (180,PosY2+110,NameStr);

                if SelectClassesForm.Classes_ComboBox.ItemIndex=1 then
                begin
                  if ColorCode[3]=1 then Brush.Color:=$0046A741
                  else if ColorCode[3]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[3]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[3]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[3]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[3]=5 then Brush.Color:=clRed
                  else if ColorCode[3]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[3]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[3]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[3]=9 then Brush.Color:=clSilver
                  else if ColorCode[3]=10 then Brush.Color:=$002D52A0
                end else Brush.Color:=$0080ff80;

              if Ymax[DataMod.ColNr]<1.001 then
              begin
                 HlpStr:=format('%4.2f',[Limit[2]]);
                 NameStr:=HlpStr + ' -' + format('%4.2f',[Limit[3]])+'  '
              end else
              if Ymax[DataMod.ColNr]>10 then
              begin
                 HlpStr:=format('%4.0f',[Limit[2]]);
                 NameStr:=HlpStr + ' -' + format('%4.0f',[Limit[3]])+'  '
              end else
              begin
                 HlpStr:=format('%4.1f',[Limit[2]]);
                 NameStr:=HlpStr + ' -' + format('%4.1f',[Limit[3]])+'  ';
              end;
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) and
                 (SelectClassesForm.NrOfClasses_ComboBox.ItemIndex=0) then
              begin
                if Ymax[DataMod.ColNr]<1.001 then
                   NameStr:=' > ' + format('%4.2f',[Limit[2]]) + '  '
                else
                if Ymax[DataMod.ColNr]>10 then
                   NameStr:=' > ' + format('%4.0f',[Limit[2]]) + '  '
                else
                   NameStr:=' > ' + format('%5.1f',[Limit[2]]) + '  ';
              end;
              TextOut (270,PosY2+110,NameStr);

                if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) and
                   (SelectClassesForm.NrOfClasses_ComboBox.ItemIndex>0) then
                begin
                  if ColorCode[4]=1 then Brush.Color:=$0046A741
                  else if ColorCode[4]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[4]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[4]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[4]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[4]=5 then Brush.Color:=clRed
                  else if ColorCode[4]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[4]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[4]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[4]=9 then Brush.Color:=clSilver
                  else if ColorCode[4]=10 then Brush.Color:=$002D52A0
                end else Brush.Color:=$0035AC13;

              if Ymax[DataMod.ColNr]<1.001 then
              begin
                 HlpStr:=format('%4.2f',[Limit[3]]);
                 NameStr:=HlpStr + ' -' + format('%4.2f',[Limit[4]])+'  '
              end else
              if Ymax[DataMod.ColNr]>10 then
              begin
                 HlpStr:=format('%4.0f',[Limit[3]]);
                 NameStr:=HlpStr + ' -' + format('%4.0f',[Limit[4]])+'  '
              end else
              begin
                 HlpStr:=format('%5.1f',[Limit[3]]);
                 NameStr:=HlpStr + ' -' + format('%5.1f',[Limit[4]])+'  ';
              end;
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) and
                 (SelectClassesForm.NrOfClasses_ComboBox.ItemIndex=1) then
              begin
                if Ymax[DataMod.ColNr]<1.001 then
                   NameStr:=' > ' + format('%4.2f',[Limit[3]]) + '  '
                else
                if Ymax[DataMod.ColNr]>10 then
                   NameStr:=' > ' + format('%4.0f',[Limit[3]]) + '  '
                else
                   NameStr:=' > ' + format('%5.1f',[Limit[3]]) + '  ';
              end;

              if (SelectClassesForm.Classes_ComboBox.ItemIndex=0) then
                 TextOut (360,PosY2+110,NameStr);
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) then
                 TextOut (360,PosY2+110,NameStr);

                if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) and
                   (SelectClassesForm.NrOfClasses_ComboBox.ItemIndex>1) then
                begin
                  if ColorCode[5]=1 then Brush.Color:=$0046A741
                  else if ColorCode[5]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[5]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[5]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[5]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[5]=5 then Brush.Color:=clRed
                  else if ColorCode[5]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[5]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[5]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[5]=9 then Brush.Color:=clSilver
                  else if ColorCode[5]=10 then Brush.Color:=$002D52A0
                end else Brush.Color:=$00BFD6F7;

              if Ymax[DataMod.ColNr]<1.001 then
              begin
                 HlpStr:=format('%4.2f',[Limit[4]]);
                 NameStr:=HlpStr + ' -' + format('%4.2f',[Limit[5]])+'  '
              end else
              if Ymax[DataMod.ColNr]>10 then
              begin
                 HlpStr:=format('%4.0f',[Limit[4]]);
                 NameStr:=HlpStr + ' -' + format('%4.0f',[Limit[5]])+'  '
              end else
              begin
                 HlpStr:=format('%5.1f',[Limit[4]]);
                 NameStr:=HlpStr + ' -' + format('%5.1f',[Limit[5]])+'  ';;
              end;
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) and
                 (SelectClassesForm.NrOfClasses_ComboBox.ItemIndex=2) then
              begin
                if Ymax[DataMod.ColNr]<1.001 then
                   NameStr:=' > ' + format('%4.2f',[Limit[4]]) + '  '
                else
                if Ymax[DataMod.ColNr]>10 then
                   NameStr:=' > ' + format('%4.0f',[Limit[4]]) + '  '
                else
                   NameStr:=' > ' + format('%5.1f',[Limit[4]]) + '  ';
              end;

              if (SelectClassesForm.Classes_ComboBox.ItemIndex=0) then
                 TextOut (450,PosY2+110,NameStr);
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) then
                 TextOut (450,PosY2+110,NameStr);

                if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) then
                begin
                  if ColorCode[6]=1 then Brush.Color:=$0046A741
                  else if ColorCode[6]=2 then Brush.Color:=$008BDA9B
                  else if ColorCode[6]=3 then Brush.Color:=$006AFCFF
                  else if ColorCode[6]=4 then Brush.Color:=$0000A5FF
//                  else if ColorCode[6]=4 then Brush.Color:=$00C6E8FF
                  else if ColorCode[6]=5 then Brush.Color:=clRed
                  else if ColorCode[6]=6 then Brush.Color:=clFuchsia
                  else if ColorCode[6]=7 then Brush.Color:=$00F0A968
                  else if ColorCode[6]=8 then Brush.Color:=$00FDF599
                  else if ColorCode[6]=9 then Brush.Color:=clSilver
                  else if ColorCode[6]=10 then Brush.Color:=$002D52A0
                end else Brush.Color:=$004080FF;

              if (SelectClassesForm.Classes_ComboBox.ItemIndex=0) then
              begin
              if Ymax[DataMod.ColNr]<1.001 then
              begin
                 HlpStr:=format('%4.2f',[Limit[5]]);
                 NameStr:=HlpStr + ' -' + format('%4.2f',[Limit[6]])+'  ';
              end else
              if Ymax[DataMod.ColNr]>10 then
              begin
                 HlpStr:=format('%4.0f',[Limit[5]]);
                 NameStr:=HlpStr + ' -' + format('%4.0f',[Limit[6]])+'  ';
              end else
              begin
                 HlpStr:=format('%5.1f',[Limit[5]]);
                 NameStr:=HlpStr + ' -' + format('%5.1f',[Limit[6]])+'  ';
              end;
              end;
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) then
              begin
                if Ymax[DataMod.ColNr]<1.001 then
                   NameStr:=' > ' + format('%4.2f',[Limit[5]]) + '  '
                else
                if Ymax[DataMod.ColNr]>10 then
                   NameStr:=' > ' + format('%4.0f',[Limit[5]]) + '  '
                else
                   NameStr:=' > ' + format('%5.1f',[Limit[5]]) + '  ';
              end;
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=0) then
                 TextOut (540,PosY2+110,NameStr);
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) then
                 TextOut (540,PosY2+110,NameStr);

              Brush.Color:=clYellow;
              if Ymax[DataMod.ColNr]<1.001 then
                 NameStr:=format('%4.2f',[Limit[6]])+'  '
              else
              if Ymax[DataMod.ColNr]>10 then
                 NameStr:=format('%4.0f',[Limit[6]])+'  '
              else
                 NameStr:=format('%5.1f',[Limit[6]])+'  ';
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=0) then
                 TextOut (630,PosY2+110,' > ' + NameStr);

              Brush.Color:=clwhite;
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=0) then
                  NameStr:= ' White color: no data of this kind present';
              if (SelectClassesForm.Classes_ComboBox.ItemIndex=1) then
                  NameStr:= ' White color: no data present'+
                            ' in the classes defined.';
              TextOut (70,PosY2+130,NameStr);

        end; {if ColorMap then}

        if MainForm.Internal_RadioButton.Checked then ColorMap:=false;

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


procedure TNetworkForm.Nodes_ButtonClick(Sender: TObject);
begin
  inherited;
  if Nodes_Button.Caption= 'Remove node numbers' then
  begin
    YesOK:=false;
    Nodes_Button.Caption := 'Show node numbers';
  end else
  begin
    YesOK:=true;
    Nodes_Button.Caption := 'Remove node numbers';
  end;
  NetWorkPicture;
end;


procedure TNetworkForm.SectionButtonClick(Sender: TObject);
begin
  inherited;
  SelectPolyForm.Show;
end;

end.

