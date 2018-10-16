object MappingForm: TMappingForm
  Left = 205
  Top = 60
  Width = 517
  Height = 388
  Caption = 'Mapping help'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Mapping_Memo: TMemo
    Left = 8
    Top = 8
    Width = 489
    Height = 337
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      ''
      '  SahysMod shows a network map. It can also produce graphs of'
      '  output data.'
      
        '  However, it does not produce maps with countourlines (isolines' +
        ') .'
      ''
      
        '  Simple and free map-making software for the purpose is QuikGri' +
        'd.'
      '  Spreadsheet programs like Ms Excel also have contouring '
      '  facilities.'
      ''
      '  USE OF QUIKGRID TO MAKE A MAP OF SAHYSMOD OUTPUT DATA'
      ''
      '1. In SahysMod open the ouput file'
      '2. Use "Select data for graphs" '
      '3. Check "Polygonal characteristics"'
      
        '4. Use "Save group", give a group name (say Coordinates.prn) for' +
        ' the'
      '     X,Y coordinates, and save'
      '5. Use again "Select data for graphs" '
      '6. Select the data group you wish to make a map of (say depth of'
      '     watertable) and click "Go"'
      
        '7. Select "Polygonal data per season" , click "Go" and define ye' +
        'ar'
      '     and season'
      
        '8. Use again "Save group", give a group name (say ZData.prn), an' +
        'd save'
      '9. Open MsExcel'
      '10. Under tab "Data" use "Import data from text file"'
      '11. Open Coord.prn, use space delimited and paste it'
      
        '12. Open ZData.prn, use space delimited and paste it to the righ' +
        't of'
      '      Coordinates.prn'
      '13. Copy the column with X coordinates and paste it below the'
      '      imported data'
      '14. Do the same for Y coordinates and paste right next to the'
      '      X coordinate column'
      
        '15. Select the column from ZData you wish to map, copy it and pa' +
        'ste it'
      '      next to the Y coordinate column'
      '16. Select the last 3 columns'
      '17. Open Ms NotePad'
      '18. Paste the 3 columns'
      '19. Save the notepad file (say MapData.txt)'
      '20. Open QuikGrid'
      '21. Under "File" select:"Scattered data points" and then select:'
      '      "input in metric units"'
      '22. In QuikGrid, open the file MapData.txt'
      '23. Use the "Edit" and "View" tabs to configure the map to'
      '      your wishes'
      '      (e.g. under "View" use "with hidden color grid" and under'
      '       "Edit" use "color intervals and labels", "Title", and'
      
        '       "edit number of gridlines" making them equal to the numbe' +
        'r'
      '       used in SahysMod)'
      '24. After satisfaction, use "Window" and "Copy to clipboard"'
      '25. Open MsPaint'
      '26. Use "Edit" and "Paste"'
      '27. Edit the map to your wishes and add more titles if desired'
      '26. Save the map as *.bmp, *.jpg, *.png or any other optional'
      '      format, say for example EndMap.tif'
      '27. Ready'
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
