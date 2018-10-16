object SelectPolyForm: TSelectPolyForm
  Left = 624
  Top = 30
  Width = 295
  Height = 506
  Caption = 'Select polygons'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SelectPolyStringGrid: TStringGrid
    Left = 24
    Top = 120
    Width = 137
    Height = 113
    ColCount = 2
    DefaultRowHeight = 20
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs]
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object SelectPoly_Memo: TMemo
    Left = 24
    Top = 8
    Width = 249
    Height = 97
    Lines.Strings = (
      'Select maximum 20 polygons from the list in the '
      'first column by typing serial numbers  in the '
      'second column.'
      'The serial number ranges from 1 to N (the number '
      'of polygons you wish to select). N<21.'
      'The graph will show the polygons in the sequence '
      'given by the serial numbers.')
    TabOrder = 1
  end
  object Ready_Button: TButton
    Left = 201
    Top = 436
    Width = 75
    Height = 25
    Caption = 'Ready'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Ready_ButtonClick
  end
  object NetworkMap_Button: TButton
    Left = 192
    Top = 120
    Width = 83
    Height = 25
    Caption = 'Network map'
    TabOrder = 3
    OnClick = NetworkMap_ButtonClick
  end
  object ExampleButton: TButton
    Left = 192
    Top = 160
    Width = 83
    Height = 25
    Caption = 'See example'
    TabOrder = 4
    OnClick = ExampleButtonClick
  end
  object CancelButton: TButton
    Left = 200
    Top = 396
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = CancelButtonClick
  end
end
