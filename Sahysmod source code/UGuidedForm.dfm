inherited GuidedForm: TGuidedForm
  Left = 589
  Top = 27
  Width = 535
  Height = 392
  Anchors = [akRight, akBottom]
  Caption = 'SahysMod: guided nodal network input'
  OldCreateOrder = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  inherited StatusBar1: TStatusBar
    Top = 338
    Width = 527
  end
  object ExampleButton: TButton
    Left = 432
    Top = 8
    Width = 81
    Height = 25
    Caption = 'Example'
    TabOrder = 1
    OnClick = ExampleButtonClick
  end
  object NrOfNodesPanel: TPanel
    Left = 40
    Top = 24
    Width = 337
    Height = 257
    TabOrder = 2
    Visible = False
    DesignSize = (
      337
      257)
    object NrOfNodesLabel: TLabel
      Left = 16
      Top = 96
      Width = 63
      Height = 64
      Caption = 'Minimum: number of internal nodes +1'
      WordWrap = True
    end
    object NrOfNodesMemo: TMemo
      Left = 8
      Top = 8
      Width = 281
      Height = 49
      Lines.Strings = (
        'Number of nodes per horizontal grid line (row)'
        'Begin with lowermost grid line Nr. 1')
      TabOrder = 0
    end
    object NrOfNodesOKButton: TButton
      Left = 288
      Top = 224
      Width = 41
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 1
      OnClick = NrOfNodesOKButtonClick
    end
    object NrOfNodesStringGrid: TStringGrid
      Left = 96
      Top = 64
      Width = 169
      Height = 185
      ColCount = 2
      DefaultColWidth = 80
      DefaultRowHeight = 20
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 2
      OnSetEditText = NrOfNodesStringGridSetEditText
    end
  end
  object YcoordPanel: TPanel
    Left = 64
    Top = 40
    Width = 361
    Height = 241
    TabOrder = 3
    Visible = False
    DesignSize = (
      361
      241)
    object YcoordMemo: TMemo
      Left = 16
      Top = 16
      Width = 329
      Height = 49
      Lines.Strings = (
        'Y coordinates of rows as measured in cm on the map. '
        'Start with smallest Y value corresponding to row 1.')
      TabOrder = 0
    end
    object YcoordStringGrid: TStringGrid
      Left = 56
      Top = 72
      Width = 225
      Height = 145
      ColCount = 2
      DefaultColWidth = 80
      DefaultRowHeight = 20
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 1
      OnSetEditText = YcoordStringGridSetEditText
    end
    object YcoordOKButton: TButton
      Left = 288
      Top = 168
      Width = 49
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 2
      OnClick = YcoordOKButtonClick
    end
  end
  object XcoordPanel: TPanel
    Left = 48
    Top = 32
    Width = 361
    Height = 265
    TabOrder = 4
    Visible = False
    object XcoordMemo: TMemo
      Left = 8
      Top = 16
      Width = 345
      Height = 49
      Lines.Strings = (
        'X coordinates of columns as measured in cm on the map. '
        'Start with smallest X value corresponding to column 1.')
      TabOrder = 0
    end
    object XcoordStringGrid: TStringGrid
      Left = 56
      Top = 72
      Width = 225
      Height = 145
      ColCount = 2
      DefaultColWidth = 80
      DefaultRowHeight = 20
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 1
      OnSetEditText = XcoordStringGridSetEditText
    end
    object XcoordOKButton: TButton
      Left = 288
      Top = 152
      Width = 49
      Height = 25
      Caption = 'OK'
      TabOrder = 2
      OnClick = XcoordOKButtonClick
    end
  end
  object FirstXPanel: TPanel
    Left = 56
    Top = 48
    Width = 273
    Height = 257
    TabOrder = 5
    Visible = False
    object FirstXMemo: TMemo
      Left = 0
      Top = 8
      Width = 241
      Height = 49
      Lines.Strings = (
        'X coordinate of first node in each row. '
        'See example')
      TabOrder = 0
    end
    object FirstXStringGrid: TStringGrid
      Left = 8
      Top = 72
      Width = 200
      Height = 145
      ColCount = 2
      DefaultColWidth = 80
      DefaultRowHeight = 20
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 1
      OnSetEditText = FirstXStringGridSetEditText
    end
    object FirstXOKButton: TButton
      Left = 208
      Top = 136
      Width = 49
      Height = 25
      Caption = 'OK'
      TabOrder = 2
      OnClick = FirstXOKButtonClick
    end
  end
  object Cols_Rows_Panel: TPanel
    Left = 56
    Top = 40
    Width = 353
    Height = 105
    TabOrder = 6
    object RowsMemo: TMemo
      Left = 8
      Top = 8
      Width = 281
      Height = 25
      Lines.Strings = (
        'Number of horizontal (nodal) grid lines: rows')
      TabOrder = 0
    end
    object ColsMemo: TMemo
      Left = 8
      Top = 40
      Width = 281
      Height = 25
      Lines.Strings = (
        'Number of vertical (nodal) grid lines: columns')
      TabOrder = 1
    end
    object NrOfRowsEdit: TEdit
      Left = 304
      Top = 8
      Width = 33
      Height = 24
      TabStop = False
      TabOrder = 2
    end
    object NrOfColsEdit: TEdit
      Left = 304
      Top = 40
      Width = 33
      Height = 24
      TabOrder = 3
    end
    object Rows_Cols_OK_Button: TButton
      Left = 304
      Top = 72
      Width = 33
      Height = 25
      Caption = 'OK'
      TabOrder = 4
      OnClick = Rows_Cols_OK_ButtonClick
    end
  end
  object BackButton: TButton
    Left = 440
    Top = 304
    Width = 75
    Height = 25
    Caption = 'Back'
    TabOrder = 7
    OnClick = BackButtonClick
  end
end
