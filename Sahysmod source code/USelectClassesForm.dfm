object SelectClassesForm: TSelectClassesForm
  Left = 872
  Top = 201
  Width = 458
  Height = 424
  Caption = 'Select class limits'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Classes_Panel: TPanel
    Left = 16
    Top = 8
    Width = 273
    Height = 369
    BevelOuter = bvNone
    TabOrder = 0
    object Classes_Grid: TStringGrid
      Left = 8
      Top = 152
      Width = 320
      Height = 185
      ColCount = 4
      RowCount = 7
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
    end
    object Classes_ComboBox: TComboBox
      Left = 8
      Top = 124
      Width = 153
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'Accept automatic limits'
      OnChange = Classes_ComboBoxChange
      Items.Strings = (
        'Accept automatic limits'
        'Make user preferred limits')
    end
    object Classes_Memo: TMemo
      Left = 8
      Top = 0
      Width = 201
      Height = 110
      Color = clGradientInactiveCaption
      Lines.Strings = (
        ' Automatic limits of classes are shown.'
        '      The sequence is from low to high.'
        ' They can be replaced by user preferred '
        ' limits with the help of combo box below.'
        '      If so decided, enter the desired limits'
        ' in the 3rd column of the table and the '
        ' desired color codes in the 4th.'
        '      Click "Ready" when done.'
        '')
      TabOrder = 2
    end
    object Classes_Button: TButton
      Left = 64
      Top = 336
      Width = 75
      Height = 25
      Caption = 'Ready'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Classes_ButtonClick
    end
    object NrOfClasses_ComboBox: TComboBox
      Left = 168
      Top = 124
      Width = 97
      Height = 21
      ItemHeight = 13
      ItemIndex = 3
      TabOrder = 4
      Text = 'Use 6 classes'
      OnChange = NrOfClasses_ComboBoxChange
      Items.Strings = (
        'Use 3 classes'
        'Use 4 classes'
        'Use 5 classes'
        'Use 6 classes')
    end
    object CancelCButton: TButton
      Left = 8
      Top = 336
      Width = 49
      Height = 25
      Caption = 'Cancel'
      TabOrder = 5
      OnClick = CancelCButtonClick
    end
  end
  object Color_Panel: TPanel
    Left = 304
    Top = 24
    Width = 129
    Height = 313
    TabOrder = 1
    object Color_Label1: TLabel
      Left = 32
      Top = 72
      Width = 42
      Height = 13
      Caption = '      1      '
      Color = 4630337
      ParentColor = False
    end
    object Color_Label2: TLabel
      Left = 32
      Top = 96
      Width = 42
      Height = 13
      Caption = '      2      '
      Color = 9165467
      ParentColor = False
    end
    object Color_Label3: TLabel
      Left = 32
      Top = 120
      Width = 42
      Height = 13
      Caption = '      3      '
      Color = 7011583
      ParentColor = False
    end
    object Color_Label4: TLabel
      Left = 32
      Top = 144
      Width = 42
      Height = 13
      Caption = '      4      '
      Color = 42495
      ParentColor = False
    end
    object Color_Label5: TLabel
      Left = 32
      Top = 168
      Width = 42
      Height = 13
      Caption = '      5      '
      Color = clRed
      ParentColor = False
    end
    object Color_Label8: TLabel
      Left = 32
      Top = 240
      Width = 42
      Height = 13
      Caption = '      8      '
      Color = 16643481
      ParentColor = False
    end
    object Color_Label7: TLabel
      Left = 32
      Top = 216
      Width = 42
      Height = 13
      Caption = '      7      '
      Color = 15772008
      ParentColor = False
    end
    object Color_Label6: TLabel
      Left = 32
      Top = 192
      Width = 42
      Height = 13
      Caption = '      6      '
      Color = clFuchsia
      ParentColor = False
    end
    object Color_Label9: TLabel
      Left = 32
      Top = 264
      Width = 42
      Height = 13
      Caption = '      9      '
      Color = clSilver
      ParentColor = False
    end
    object Color_Label10: TLabel
      Left = 32
      Top = 288
      Width = 42
      Height = 13
      Caption = '      10    '
      Color = 2970272
      ParentColor = False
    end
    object Color_Memo: TMemo
      Left = 0
      Top = 8
      Width = 121
      Height = 49
      Color = clMoneyGreen
      Lines.Strings = (
        'The desired color codes'
        'may be entered in the'
        'last column of the table')
      TabOrder = 0
    end
  end
end
