object SelectExampleForm: TSelectExampleForm
  Left = 922
  Top = 29
  Width = 364
  Height = 460
  Caption = 'Example of selection'
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
  object ExampleStringGrid: TStringGrid
    Left = 16
    Top = 64
    Width = 153
    Height = 345
    ColCount = 2
    RowCount = 30
    FixedRows = 0
    TabOrder = 0
  end
  object NodeMemo: TMemo
    Left = 16
    Top = 8
    Width = 57
    Height = 49
    Lines.Strings = (
      '   Node'
      ' numbers')
    TabOrder = 1
  end
  object SelectMemo: TMemo
    Left = 88
    Top = 8
    Width = 57
    Height = 49
    Lines.Strings = (
      'Sequential'
      ' selection'
      ' numbers')
    TabOrder = 2
  end
  object SelectionExplainMemo: TMemo
    Left = 184
    Top = 64
    Width = 161
    Height = 257
    Lines.Strings = (
      '  '
      '  Example of node selection.'
      '  - - - - - - - - - - - - - - - - - - - - - '
      ''
      ' The 9 selected nodes are'
      ' 4,  6,  8, 19, 17, 29, 26, 11,  9'
      ''
      ' with serial sequential numbers'
      ' 1,  2,  3,   4,   5,   6,   7,   8,  9'
      ' respectively.'
      ''
      ' On the X-axis of the graphs '
      ' the  selected nodes will be '
      ' shown in that sequence.'
      ''
      ' This method can be used'
      ' to select a suitable cross-'
      ' section in the nodal network.')
    TabOrder = 3
  end
  object CancelEButton: TButton
    Left = 224
    Top = 376
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = CancelEButtonClick
  end
end
