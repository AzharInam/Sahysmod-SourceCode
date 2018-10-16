unit USelectColumnForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids;

type
  TSelectColumnForm = class(TForm)
    SoilSal_Panel: TPanel;
    SoilSal_RadioGroup: TRadioGroup;
    CrA_RadioButton: TRadioButton;
    CrB_RadioButton: TRadioButton;
    CrU_RadioButton: TRadioButton;
    Cr4_RadioButton: TRadioButton;
    C1_RadioButton: TRadioButton;
    C2_RadioButton: TRadioButton;
    C3_RadioButton: TRadioButton;
    SelectCol_Button: TButton;
    SubSal_Panel: TPanel;
    SubSal_RadioGroup: TRadioGroup;
    Cxf_RadioButton: TRadioButton;
    Cxa_RadioButton: TRadioButton;
    Cxb_RadioButton: TRadioButton;
    Cqf_RadioButton: TRadioButton;
    OtherSal_Panel: TPanel;
    OtherSal_RadioGroup: TRadioGroup;
    Cti_RadioButton: TRadioButton;
    Cqi_RadioButton: TRadioButton;
    Ci_RadioButton: TRadioButton;
    Cd_RadioButton: TRadioButton;
    Cw_RadioButton: TRadioButton;
    Grwt_Panel: TPanel;
    Grwt_RadioGroup: TRadioGroup;
    GTi_RadioButton: TRadioButton;
    Gto_RadioButton: TRadioButton;
    Gtv_RadioButton: TRadioButton;
    Gqi_RadioButton: TRadioButton;
    Gqo_RadioButton: TRadioButton;
    Gaq_RadioButton: TRadioButton;
    Gnt_RadioButton: TRadioButton;
    SelectCol_Memo: TMemo;
    Disch_Panel: TPanel;
    Disch_RadioGroup: TRadioGroup;
    Gd_RadioButton: TRadioButton;
    Ga_RadioButton: TRadioButton;
    Gb_RadioButton: TRadioButton;
    Gw_RadioButton: TRadioButton;
    Perco_Panel: TPanel;
    Perco_RadioGroup: TRadioGroup;
    LrA_RadioButton: TRadioButton;
    LrB_RadioButton: TRadioButton;
    LrU_RadioButton: TRadioButton;
    Lr_RadioButton: TRadioButton;
    Capil_Panel: TPanel;
    Capil_RadioGroup: TRadioGroup;
    RrA_RadioButton: TRadioButton;
    RrB_RadioButton: TRadioButton;
    RrU_RadioButton: TRadioButton;
    Rr_RadioButton: TRadioButton;
    Irr_Panel: TPanel;
    Irr_RadioGroup: TRadioGroup;
    It_RadioButton: TRadioButton;
    Is_RadioButton: TRadioButton;
    IaA_RadioButton: TRadioButton;
    IaB_RadioButton: TRadioButton;
    Io_RadioButton: TRadioButton;
    Eff_Panel: TPanel;
    Eff_RadioGroup: TRadioGroup;
    FfA_RadioButton: TRadioButton;
    FfB_RadioButton: TRadioButton;
    Fft_RadioButton: TRadioButton;
    JsA_RadioButton: TRadioButton;
    JsB_RadioButton: TRadioButton;
    Area_Panel: TPanel;
    RadioGroup1: TRadioGroup;
    AreaA_RadioButton: TRadioButton;
    AreaB_RadioButton: TRadioButton;
    AreaU_RadioButton: TRadioButton;
    AreaUc_RadioButton: TRadioButton;
    C0_RadioButton: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure SelectCol_ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ColSelected : boolean;
  end;

var
  SelectColumnForm: TSelectColumnForm;

implementation

uses UMainForm, UDataMod, UExtraUtils;

{$R *.dfm}

procedure TSelectColumnForm.FormShow(Sender: TObject);
begin
  ColSelected:=false;
end;

procedure TSelectColumnForm.SelectCol_ButtonClick(Sender: TObject);
begin
  if MainForm.SoilSal_RadioButton.Checked then
  begin
  if CrA_RadioButton.Checked then DataMod.ColNr:=1;
  if CrB_RadioButton.Checked then DataMod.ColNr:=2;
  if CrU_RadioButton.Checked then DataMod.ColNr:=3;
  if Cr4_RadioButton.Checked then DataMod.ColNr:=4;
  if C0_RadioButton.Checked then DataMod.ColNr:=5;
  if C1_RadioButton.Checked then DataMod.ColNr:=6;
  if C2_RadioButton.Checked then DataMod.ColNr:=7;
  if C3_RadioButton.Checked then DataMod.ColNr:=8;
  end;

  if MainForm.SubSal_RadioButton.Checked then
  begin
  if Cxf_RadioButton.Checked then DataMod.ColNr:=1;
  if Cxa_RadioButton.Checked then DataMod.ColNr:=2;
  if Cxb_RadioButton.Checked then DataMod.ColNr:=3;
  if Cqf_RadioButton.Checked then DataMod.ColNr:=4;
  end;

  if MainForm.OtherSal_RadioButton.Checked then
  begin
  if Cti_RadioButton.Checked then DataMod.ColNr:=1;
  if Cqi_RadioButton.Checked then DataMod.ColNr:=2;
  if Ci_RadioButton.Checked then DataMod.ColNr:=3;
  if Cd_RadioButton.Checked then DataMod.ColNr:=4;
  if Cw_RadioButton.Checked then DataMod.ColNr:=5;
  end;

  if MainForm.Groundwater_RadioButton.Checked then
  begin
  if Gti_RadioButton.Checked then DataMod.ColNr:=1;
  if Gto_RadioButton.Checked then DataMod.ColNr:=2;
  if Gtv_RadioButton.Checked then DataMod.ColNr:=3;
  if Gqi_RadioButton.Checked then DataMod.ColNr:=4;
  if Gqo_RadioButton.Checked then DataMod.ColNr:=5;
  if Gaq_RadioButton.Checked then DataMod.ColNr:=6;
  if Gnt_RadioButton.Checked then DataMod.ColNr:=7;
  end;

  if MainForm.Discharge_RadioButton.Checked then
  begin
  if Gd_RadioButton.Checked then DataMod.ColNr:=1;
  if Ga_RadioButton.Checked then DataMod.ColNr:=2;
  if Gb_RadioButton.Checked then DataMod.ColNr:=3;
  if Gw_RadioButton.Checked then DataMod.ColNr:=4;
  end;

  if MainForm.Percol_RadioButton.Checked then
  begin
  if LrA_RadioButton.Checked then DataMod.ColNr:=1;
  if LrB_RadioButton.Checked then DataMod.ColNr:=2;
  if LrU_RadioButton.Checked then DataMod.ColNr:=3;
  if Lr_RadioButton.Checked then DataMod.ColNr:=4;
  end;

  if MainForm.Capil_RadioButton.Checked then
  begin
  if RrA_RadioButton.Checked then DataMod.ColNr:=1;
  if RrB_RadioButton.Checked then DataMod.ColNr:=2;
  if RrU_RadioButton.Checked then DataMod.ColNr:=3;
  if Rr_RadioButton.Checked then DataMod.ColNr:=4;
  end;

  if MainForm.CanalIrr_RadioButton.Checked then
  begin
  if It_RadioButton.Checked then DataMod.ColNr:=1;
  if Is_RadioButton.Checked then DataMod.ColNr:=2;
  if IaA_RadioButton.Checked then DataMod.ColNr:=3;
  if IaB_RadioButton.Checked then DataMod.ColNr:=4;
  if Io_RadioButton.Checked then DataMod.ColNr:=5;
  end;

  if MainForm.IrrEff_RadioButton.Checked then
  begin
  if FfA_RadioButton.Checked then DataMod.ColNr:=1;
  if FfB_RadioButton.Checked then DataMod.ColNr:=2;
  if Fft_RadioButton.Checked then DataMod.ColNr:=3;
  if JsA_RadioButton.Checked then DataMod.ColNr:=4;
  if JsB_RadioButton.Checked then DataMod.ColNr:=5;
  end;

  if MainForm.CropArea_RadioButton.Checked then
  begin
  if AreaA_RadioButton.Checked then DataMod.ColNr:=1;
  if AreaB_RadioButton.Checked then DataMod.ColNr:=2;
  if AreaU_RadioButton.Checked then DataMod.ColNr:=3;
  if AreaUc_RadioButton.Checked then DataMod.ColNr:=4;
  end;

  ColSelected:=true;
  SelectColumnForm.Visible:=false;
  SelectColumnForm.SubSal_Panel.Visible:=false;
  MainForm.ColorMapButtonClick(Sender);

end;


end.
