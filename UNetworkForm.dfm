inherited NetworkForm: TNetworkForm
  Left = 203
  Top = 10
  Width = 718
  Height = 569
  Caption = 'SahysMod: picture of nodal network and polygons'
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object NetworkImage: TImage [0]
    Left = 8
    Top = 16
    Width = 689
    Height = 465
  end
  inherited StatusBar1: TStatusBar
    Top = 515
    Width = 710
  end
  object SaveNetw_Button: TButton
    Left = 621
    Top = 491
    Width = 75
    Height = 20
    Caption = 'Save map'
    TabOrder = 1
    OnClick = SaveNetw_ButtonClick
  end
  object MapSave_Dialog: TSaveDialog
    DefaultExt = '.bmp'
    Filter = 'Image files (*.bmp)|*.bmp'
    Left = 8
    Top = 488
  end
end
