inherited ColumnsForm: TColumnsForm
  Left = 574
  Top = 43
  Width = 421
  Height = 349
  Caption = 'SahysMod input: fill entire column'
  OldCreateOrder = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  inherited StatusBar1: TStatusBar
    Top = 295
    Width = 413
  end
  object ColumnsStringGrid: TStringGrid
    Left = 24
    Top = 120
    Width = 308
    Height = 46
    DefaultColWidth = 60
    DefaultRowHeight = 20
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 24
    Top = 24
    Width = 305
    Height = 73
    Lines.Strings = (
      'Enter the value with which the column should be '
      'filled in the corresponding position.'
      'Leave the position blank if the column is to remain '
      'unchanged.')
    TabOrder = 2
  end
  object Button1: TButton
    Left = 344
    Top = 268
    Width = 60
    Height = 20
    Caption = 'OK'
    TabOrder = 3
    OnClick = Button1Click
  end
end
