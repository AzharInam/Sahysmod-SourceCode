object NodalHelpForm: TNodalHelpForm
  Left = 884
  Top = 122
  Width = 378
  Height = 433
  Caption = 'Polygonal network help'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object NodalHelp_Memo: TMemo
    Left = 8
    Top = 8
    Width = 353
    Height = 353
    Lines.Strings = (
      ''
      
        ' When entering data for a new project, it will be required to sp' +
        'ecify the '
      
        ' number of polygons to be added to the standard five to reach th' +
        'e total '
      
        ' number of  polygons desired. This includes internal polygons fo' +
        'r all '
      
        ' necessary model details, and external polygons giving the bound' +
        'ary '
      ' conditions.'
      ''
      
        ' Use the "Example of network" button below to obtain a first imp' +
        'ression  '
      
        ' of the layout  of a polygonal (nodal) network. It contains 21 n' +
        'odes, of '
      
        ' which 9 internal and 12 external. To create such a network one ' +
        'should '
      ' ad 16 polygons to the standard 5.'
      ''
      
        ' The other data on the General input tabsheet need also to be fi' +
        'lled in.'
      
        ' An impression of data requirements can be obtained using "Open ' +
        'input"'
      ' to inspect an existing input file.'
      ''
      
        ' After completion, use the "Save general input" button which wil' +
        'l save  '
      
        ' the data of the  General input tabsheet. Promptly one will be f' +
        'aced with '
      ' two options:'
      
        ' (1) to continue entering other polygonal data as the polygonal ' +
        '(nodal)'
      '     network has been prepared beforehand, or'
      
        ' (2) to proceed with guidance on the preparation of the network ' +
        'before'
      '     entering all other polgonal data.'
      ''
      
        ' The proceeds are furter supposed to be self-explanatory. For an' +
        ' '
      ' exercise, one may try to reconstruct the example.')
    TabOrder = 0
  end
  object SeeNetwork_Button: TButton
    Left = 233
    Top = 368
    Width = 129
    Height = 25
    Caption = 'Example of netwok'
    TabOrder = 1
    OnClick = SeeNetwork_ButtonClick
  end
end
