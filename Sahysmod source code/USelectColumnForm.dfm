object SelectColumnForm: TSelectColumnForm
  Left = 874
  Top = 146
  Width = 216
  Height = 319
  Caption = 'Select column'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SoilSal_Panel: TPanel
    Left = 16
    Top = 40
    Width = 105
    Height = 233
    TabOrder = 0
    Visible = False
    object SoilSal_RadioGroup: TRadioGroup
      Left = 8
      Top = 8
      Width = 89
      Height = 217
      Caption = 'Select column'
      TabOrder = 0
    end
    object CrA_RadioButton: TRadioButton
      Left = 24
      Top = 32
      Width = 57
      Height = 17
      Caption = 'CrA'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object CrB_RadioButton: TRadioButton
      Left = 24
      Top = 56
      Width = 49
      Height = 17
      Caption = 'CrB'
      TabOrder = 2
    end
    object CrU_RadioButton: TRadioButton
      Left = 24
      Top = 80
      Width = 49
      Height = 17
      Caption = 'CrU'
      TabOrder = 3
    end
    object Cr4_RadioButton: TRadioButton
      Left = 24
      Top = 104
      Width = 49
      Height = 17
      Caption = 'Cr4'
      TabOrder = 4
    end
    object C1_RadioButton: TRadioButton
      Left = 24
      Top = 152
      Width = 57
      Height = 17
      Caption = 'C1*'
      TabOrder = 5
    end
    object C2_RadioButton: TRadioButton
      Left = 24
      Top = 176
      Width = 49
      Height = 17
      Caption = 'C2*'
      TabOrder = 6
    end
    object C3_RadioButton: TRadioButton
      Left = 24
      Top = 200
      Width = 57
      Height = 17
      Caption = 'C3*'
      TabOrder = 7
    end
    object C0_RadioButton: TRadioButton
      Left = 24
      Top = 128
      Width = 57
      Height = 17
      Caption = 'C0*'
      TabOrder = 8
    end
  end
  object SelectCol_Button: TButton
    Left = 124
    Top = 130
    Width = 41
    Height = 25
    Caption = 'Go'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = SelectCol_ButtonClick
  end
  object SubSal_Panel: TPanel
    Left = 16
    Top = 40
    Width = 105
    Height = 169
    TabOrder = 2
    object SubSal_RadioGroup: TRadioGroup
      Left = 8
      Top = 8
      Width = 89
      Height = 153
      Caption = 'Select column'
      TabOrder = 0
    end
    object Cxf_RadioButton: TRadioButton
      Left = 24
      Top = 32
      Width = 49
      Height = 17
      Caption = 'Cxf'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object Cxa_RadioButton: TRadioButton
      Left = 24
      Top = 64
      Width = 49
      Height = 17
      Caption = 'Cxa'
      TabOrder = 2
    end
    object Cxb_RadioButton: TRadioButton
      Left = 24
      Top = 96
      Width = 49
      Height = 17
      Caption = 'Cxb'
      TabOrder = 3
    end
    object Cqf_RadioButton: TRadioButton
      Left = 24
      Top = 128
      Width = 49
      Height = 17
      Caption = 'Cqf'
      TabOrder = 4
    end
  end
  object OtherSal_Panel: TPanel
    Left = 16
    Top = 40
    Width = 105
    Height = 161
    TabOrder = 3
    object OtherSal_RadioGroup: TRadioGroup
      Left = 8
      Top = 8
      Width = 89
      Height = 145
      Caption = 'Select column'
      TabOrder = 0
    end
    object Cti_RadioButton: TRadioButton
      Left = 24
      Top = 32
      Width = 49
      Height = 17
      Caption = 'Cti'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object Cqi_RadioButton: TRadioButton
      Left = 24
      Top = 56
      Width = 57
      Height = 17
      Caption = 'Cqi'
      TabOrder = 2
    end
    object Ci_RadioButton: TRadioButton
      Left = 24
      Top = 80
      Width = 49
      Height = 17
      Caption = 'Ci'
      TabOrder = 3
    end
    object Cd_RadioButton: TRadioButton
      Left = 24
      Top = 104
      Width = 49
      Height = 17
      Caption = 'Cd'
      TabOrder = 4
    end
    object Cw_RadioButton: TRadioButton
      Left = 24
      Top = 128
      Width = 49
      Height = 17
      Caption = 'Cw'
      TabOrder = 5
    end
  end
  object Grwt_Panel: TPanel
    Left = 24
    Top = 40
    Width = 105
    Height = 225
    TabOrder = 4
    object Grwt_RadioGroup: TRadioGroup
      Left = 8
      Top = 16
      Width = 89
      Height = 193
      Caption = 'Select column'
      TabOrder = 0
    end
    object GTi_RadioButton: TRadioButton
      Left = 32
      Top = 40
      Width = 57
      Height = 17
      Caption = 'Gti'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object Gto_RadioButton: TRadioButton
      Left = 32
      Top = 64
      Width = 49
      Height = 17
      Caption = 'Gto'
      TabOrder = 2
    end
    object Gtv_RadioButton: TRadioButton
      Left = 32
      Top = 88
      Width = 57
      Height = 17
      Caption = 'Gtv'
      TabOrder = 3
    end
    object Gqi_RadioButton: TRadioButton
      Left = 32
      Top = 112
      Width = 57
      Height = 17
      Caption = 'Gqi'
      TabOrder = 4
    end
    object Gqo_RadioButton: TRadioButton
      Left = 32
      Top = 136
      Width = 57
      Height = 17
      Caption = 'Gqo'
      TabOrder = 5
    end
    object Gaq_RadioButton: TRadioButton
      Left = 32
      Top = 160
      Width = 57
      Height = 17
      Caption = 'Gaq'
      TabOrder = 6
    end
    object Gnt_RadioButton: TRadioButton
      Left = 32
      Top = 184
      Width = 49
      Height = 17
      Caption = 'Gnt'
      TabOrder = 7
    end
  end
  object SelectCol_Memo: TMemo
    Left = 16
    Top = 8
    Width = 145
    Height = 33
    Lines.Strings = (
      'Select a column from those '
      'shown in the Output tabsheet')
    TabOrder = 5
  end
  object Disch_Panel: TPanel
    Left = 16
    Top = 70
    Width = 105
    Height = 145
    TabOrder = 6
    object Disch_RadioGroup: TRadioGroup
      Left = 8
      Top = 8
      Width = 84
      Height = 121
      Caption = 'Select column'
      TabOrder = 0
    end
    object Gd_RadioButton: TRadioButton
      Left = 32
      Top = 32
      Width = 49
      Height = 17
      Caption = 'Gd'
      TabOrder = 1
    end
    object Ga_RadioButton: TRadioButton
      Left = 32
      Top = 56
      Width = 49
      Height = 17
      Caption = 'Ga'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object Gb_RadioButton: TRadioButton
      Left = 32
      Top = 80
      Width = 49
      Height = 17
      Caption = 'Gb'
      TabOrder = 3
    end
    object Gw_RadioButton: TRadioButton
      Left = 32
      Top = 104
      Width = 49
      Height = 17
      Caption = 'Gw'
      TabOrder = 4
    end
  end
  object Perco_Panel: TPanel
    Left = 16
    Top = 72
    Width = 105
    Height = 137
    TabOrder = 7
    object Perco_RadioGroup: TRadioGroup
      Left = 8
      Top = 8
      Width = 89
      Height = 121
      Caption = 'Select column'
      TabOrder = 0
    end
    object LrA_RadioButton: TRadioButton
      Left = 24
      Top = 32
      Width = 57
      Height = 17
      Caption = 'LrA'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object LrB_RadioButton: TRadioButton
      Left = 24
      Top = 56
      Width = 57
      Height = 17
      Caption = 'LrB'
      TabOrder = 2
    end
    object LrU_RadioButton: TRadioButton
      Left = 24
      Top = 80
      Width = 57
      Height = 17
      Caption = 'LrU'
      TabOrder = 3
    end
    object Lr_RadioButton: TRadioButton
      Left = 24
      Top = 104
      Width = 57
      Height = 17
      Caption = 'Lr'
      TabOrder = 4
    end
  end
  object Capil_Panel: TPanel
    Left = 24
    Top = 72
    Width = 105
    Height = 137
    TabOrder = 8
    object Capil_RadioGroup: TRadioGroup
      Left = 8
      Top = 8
      Width = 89
      Height = 121
      Caption = 'Select column'
      TabOrder = 0
    end
    object RrA_RadioButton: TRadioButton
      Left = 24
      Top = 32
      Width = 57
      Height = 17
      Caption = 'RrA'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object RrB_RadioButton: TRadioButton
      Left = 24
      Top = 56
      Width = 57
      Height = 17
      Caption = 'RrB'
      TabOrder = 2
    end
    object RrU_RadioButton: TRadioButton
      Left = 24
      Top = 80
      Width = 49
      Height = 17
      Caption = 'RrU'
      TabOrder = 3
    end
    object Rr_RadioButton: TRadioButton
      Left = 24
      Top = 104
      Width = 41
      Height = 17
      Caption = 'Rr'
      TabOrder = 4
    end
  end
  object Irr_Panel: TPanel
    Left = 24
    Top = 72
    Width = 105
    Height = 153
    TabOrder = 9
    object Irr_RadioGroup: TRadioGroup
      Left = 8
      Top = 0
      Width = 89
      Height = 145
      Caption = 'Select column'
      TabOrder = 0
    end
    object It_RadioButton: TRadioButton
      Left = 24
      Top = 24
      Width = 49
      Height = 17
      Caption = 'It'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object Is_RadioButton: TRadioButton
      Left = 24
      Top = 48
      Width = 49
      Height = 17
      Caption = 'Is'
      TabOrder = 2
    end
    object IaA_RadioButton: TRadioButton
      Left = 24
      Top = 72
      Width = 49
      Height = 17
      Caption = 'IaA'
      TabOrder = 3
    end
    object IaB_RadioButton: TRadioButton
      Left = 24
      Top = 96
      Width = 49
      Height = 17
      Caption = 'IaB'
      TabOrder = 4
    end
    object Io_RadioButton: TRadioButton
      Left = 24
      Top = 120
      Width = 41
      Height = 17
      Caption = 'Io'
      TabOrder = 5
    end
  end
  object Eff_Panel: TPanel
    Left = 24
    Top = 64
    Width = 105
    Height = 161
    TabOrder = 10
    object Eff_RadioGroup: TRadioGroup
      Left = 8
      Top = 8
      Width = 89
      Height = 145
      Caption = 'Select column'
      TabOrder = 0
    end
    object FfA_RadioButton: TRadioButton
      Left = 24
      Top = 32
      Width = 57
      Height = 17
      Caption = 'FfA'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object FfB_RadioButton: TRadioButton
      Left = 24
      Top = 56
      Width = 41
      Height = 17
      Caption = 'FfB'
      TabOrder = 2
    end
    object Fft_RadioButton: TRadioButton
      Left = 24
      Top = 80
      Width = 49
      Height = 17
      Caption = 'Fft'
      TabOrder = 3
    end
    object JsA_RadioButton: TRadioButton
      Left = 24
      Top = 104
      Width = 49
      Height = 17
      Caption = 'JsA'
      TabOrder = 4
    end
    object JsB_RadioButton: TRadioButton
      Left = 24
      Top = 128
      Width = 57
      Height = 17
      Caption = 'JsB'
      TabOrder = 5
    end
  end
  object Area_Panel: TPanel
    Left = 24
    Top = 72
    Width = 105
    Height = 137
    TabOrder = 11
    object RadioGroup1: TRadioGroup
      Left = 16
      Top = 8
      Width = 89
      Height = 121
      Caption = 'Select column'
      TabOrder = 0
    end
    object AreaA_RadioButton: TRadioButton
      Left = 24
      Top = 32
      Width = 65
      Height = 17
      Caption = 'Area A'
      TabOrder = 1
    end
    object AreaB_RadioButton: TRadioButton
      Left = 24
      Top = 56
      Width = 65
      Height = 17
      Caption = 'Area B'
      TabOrder = 2
    end
    object AreaU_RadioButton: TRadioButton
      Left = 24
      Top = 80
      Width = 65
      Height = 17
      Caption = 'Area U'
      TabOrder = 3
    end
    object AreaUc_RadioButton: TRadioButton
      Left = 24
      Top = 104
      Width = 65
      Height = 17
      Caption = 'Area Uc'
      TabOrder = 4
    end
  end
end
