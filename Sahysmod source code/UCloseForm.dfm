inherited CloseForm: TCloseForm
  Width = 287
  Height = 251
  Caption = 'SahysMod exit'
  OldCreateOrder = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  inherited StatusBar1: TStatusBar
    Top = 193
    Width = 271
  end
  object Finish_Memo: TMemo
    Left = 32
    Top = 32
    Width = 201
    Height = 105
    Lines.Strings = (
      ''
      '  Thank you for using SahysMod'
      ''
      '  sitemaster@waterlog.info'
      '  www.waterlog.info'
      '  ')
    TabOrder = 1
  end
  object Finish_Button: TButton
    Left = 176
    Top = 160
    Width = 57
    Height = 25
    Caption = 'Finish'
    TabOrder = 2
    OnClick = Finish_ButtonClick
  end
end
