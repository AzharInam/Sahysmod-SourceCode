object TransForm: TTransForm
  Left = 745
  Top = 87
  Width = 419
  Height = 353
  Caption = 'Transform coordinates'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TrLabel1: TLabel
    Left = 82
    Top = 16
    Width = 50
    Height = 16
    Caption = 'X-coord.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object TrLabel2: TLabel
    Left = 142
    Top = 16
    Width = 51
    Height = 16
    Caption = 'Y-coord.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object NumberLabel: TLabel
    Left = 16
    Top = 16
    Width = 54
    Height = 16
    Caption = 'Node Nr.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object AngleLabel: TLabel
    Left = 312
    Top = 144
    Width = 71
    Height = 32
    Caption = ' Give angle   in degrees'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object CoordStringGrid: TStringGrid
    Left = 16
    Top = 32
    Width = 201
    Height = 273
    DefaultColWidth = 60
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
    OnSetEditText = CoordStringGridSetEditText
  end
  object EndButton: TButton
    Left = 240
    Top = 258
    Width = 67
    Height = 49
    Caption = 'OK proceed'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    WordWrap = True
    OnClick = EndButtonClick
  end
  object Memo1: TMemo
    Left = 240
    Top = 24
    Width = 153
    Height = 97
    Lines.Strings = (
      ' Two adjacent spreadsheet '
      ' columns (e.g. from MsExcel) '
      ' copied to the clipboard can'
      ' be pasted from there to'
      ' SahysMod right-clicking on'
      ' the first X-coord. cell and'
      ' giving "paste".')
    TabOrder = 2
  end
  object AngleButton: TButton
    Left = 240
    Top = 176
    Width = 65
    Height = 41
    Caption = ' Rotate network'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    WordWrap = True
    OnClick = AngleButtonClick
  end
  object AngleEdit: TEdit
    Left = 312
    Top = 176
    Width = 81
    Height = 21
    TabOrder = 4
    Text = '0'
    Visible = False
    OnExit = AngleEditExit
  end
  object RotateButton: TButton
    Left = 360
    Top = 200
    Width = 35
    Height = 25
    Caption = 'Go'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    Visible = False
    OnClick = RotateButtonClick
  end
  object ShiftButton: TButton
    Left = 240
    Top = 224
    Width = 67
    Height = 41
    Caption = 'Shift network'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Visible = False
    WordWrap = True
    OnClick = ShiftButtonClick
  end
  object MoveButton: TButton
    Left = 272
    Top = 292
    Width = 35
    Height = 25
    Caption = 'Go'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    Visible = False
    OnClick = MoveButtonClick
  end
  object ShiftPanel: TPanel
    Left = 320
    Top = 224
    Width = 82
    Height = 89
    TabOrder = 8
    Visible = False
    object ShiftXLabel: TLabel
      Left = 5
      Top = 7
      Width = 70
      Height = 26
      Caption = 'Give shift-term X-coordinates'
      WordWrap = True
    end
    object ShiftYLabel: TLabel
      Left = 5
      Top = 39
      Width = 70
      Height = 26
      Caption = 'Give shift-term  Y- coordinates'
      WordWrap = True
    end
    object ShiftXEdit: TEdit
      Left = 5
      Top = 24
      Width = 70
      Height = 21
      TabOrder = 0
      Text = '0'
      OnExit = ShiftXEditExit
    end
    object ShiftYEdit: TEdit
      Left = 5
      Top = 56
      Width = 70
      Height = 21
      TabOrder = 1
      Text = '0'
      OnExit = ShiftYEditExit
    end
  end
end
