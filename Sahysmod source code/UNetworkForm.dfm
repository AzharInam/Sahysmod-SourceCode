inherited NetworkForm: TNetworkForm
  Left = 677
  Top = 112
  Width = 757
  Height = 602
  Caption = 'SahysMod: picture of nodal network and polygons'
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object NetworkImage: TImage [0]
    Left = 32
    Top = 16
    Width = 689
    Height = 465
  end
  inherited StatusBar1: TStatusBar
    Top = 544
    Width = 741
  end
  object SaveNetw_Button: TButton
    Left = 645
    Top = 523
    Width = 75
    Height = 20
    Anchors = [akRight, akBottom]
    Caption = 'Save map'
    TabOrder = 1
    OnClick = SaveNetw_ButtonClick
  end
  object Nodes_Button: TButton
    Left = 488
    Top = 523
    Width = 147
    Height = 20
    Anchors = [akRight, akBottom]
    Caption = 'Remove node numbers'
    TabOrder = 2
    OnClick = Nodes_ButtonClick
  end
  object SectionButton: TButton
    Left = 352
    Top = 523
    Width = 123
    Height = 20
    Anchors = [akRight, akBottom]
    Caption = 'See a cross-section'
    TabOrder = 3
    OnClick = SectionButtonClick
  end
  object MapSave_Dialog: TSaveDialog
    DefaultExt = '.bmp'
    Filter = 'Image files (*.bmp)|*.bmp'
    Left = 8
    Top = 488
  end
end
