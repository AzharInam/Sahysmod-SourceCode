object SymbolsForm: TSymbolsForm
  Left = 664
  Top = 72
  Width = 614
  Height = 433
  Caption = 'SahysMod input/output symbols'
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
  object SymbolsCloseButton: TButton
    Left = 504
    Top = 371
    Width = 65
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = SymbolsCloseButtonClick
  end
  object OutputSymbolsMemo: TMemo
    Left = 26
    Top = 16
    Width = 551
    Height = 345
    Lines.Strings = (
      ''
      '              LIST OF SYMBOLS OF OUTPUT DATA'
      '               (equation numbers refer to the SahysMod manual)'
      ''
      
        'A'#9'Seasonal fraction of the area under irrigated group A crop(s) ' +
        '(-), equal to the input value A1, A2, '
      
        '                A3 or A4, depending on the season, or determined' +
        ' by eqn. 106 when the key for farmers'#39' '
      '                responses Kf=1'
      
        'Ac'#9'Fraction of the area permanently under irrigated group A crop' +
        '(s) throughout the seasons (-)'
      
        'B'#9'Seasonal fraction of the area under irrigated group B crop(s) ' +
        '(-), equal to the input value B1, B2, '
      
        '                B3 or B4, depending on the season, or determined' +
        ' by eqn. 107 when the key for farmers'#39' '
      '                responses Kf=1'
      
        'Bc'#9'Fraction of the area permanently under irrigated  group B cro' +
        'p(s) (-)'
      ''
      
        'AvC         Average salinity of the soil moisture in the rootzon' +
        'e (EC in dS/m) over the entire polygon.'
      ''
      
        'Cd'#9'Seasonal average salt concentration of the drainage water, eq' +
        'n 75 (EC in dS/m)'
      
        'Ci             Salt concentration of the surface irrigation wate' +
        'r including the use of drain or well water for'
      '                irrigation (EC in dS/m)'
      
        'Cqf'#9'Salt concentration of the soil moisture in the aquifer, when' +
        ' saturated, at the end of the season '
      '                (EC in dS/m), eqn. 74'
      
        'CrA'#9'Salt concentration of the soil moisture in the root zone, wh' +
        'en saturated, of the permanently '
      
        '                irrigated land under group A crop(s) at the end ' +
        'of the present season (EC in dS/m), only used '
      
        '                when the rotation key Kr=0 or Kr=2 and equal to ' +
        'Cr0Af in eqn. 80a or Cr2Af in eqn. 93a '
      '                respectively '
      
        'CrB'#9'Salt concentration of the soil moisture in the root zone, wh' +
        'en saturated, of the permanently '
      
        '                irrigated land under group B crop(s) at the end ' +
        'of the present season (EC in dS/m), only used '
      
        '                when the rotation key Kr=0 or Kr=3 and equal to ' +
        'Cr0Bf in eqn. 80b or Cr3Bf in eqn. 100a '
      '                respectively'
      
        'CrU'#9'Salt concentration of the soil moisture in the root zone, wh' +
        'en saturated, of the permanently '
      
        '                non-irrigated (U) land at the end of the present' +
        ' season (EC in dS/m), only used when the '
      
        '                rotation key Kr=0 or Kr=1 and equal to Cr0Uf in ' +
        'eqn. 80c or Cr1Uf in eqn. 86a respectively'
      
        'C0*          Salt concentration of soil moisture in the root zon' +
        'e, when saturated, of the land outside the'
      
        '                the permanently areas A, B and U, at the end of ' +
        'the present season (EC in dS/m), only used'
      '                when the rotation key is Kr=0 or Kr=10'
      
        'C1*'#9'Salt concentration of soil moisture in the root zone, when s' +
        'aturated, of the land outside the'
      
        '                permanently non-irrigated (U) area at the end of' +
        ' the present season (EC in dS/m), only used'
      
        '                when the rotation key  Kr=1 or K3=5 and equal to' +
        ' Cr1*f in eqn. 86b'
      
        'C2*'#9'Salt concentration of the soil moisture in the root zone, wh' +
        'en saturated, of the land outside the '
      
        '                permanently irrigated land under group A crop(s)' +
        ' at the end of the present season (EC in dS/m), '
      
        '                only used when the rotation key Kr=2 or Kr=6 and' +
        ' equal to Cr2*f in eqn. 93b'
      
        'C3*'#9'Salt concentration of the soil moisture in the root zone, wh' +
        'en saturated, of the land outside the '
      
        '                permanently irrigated land under group B crop(s)' +
        ' at the end of the present season (dS/m), only '
      
        '                used when the rotation key Kr=3 or Kr=7 and equa' +
        'l to Cr3*f in eqn. 100b'
      
        'Cr4'#9'Salt concentration of the soil moisture in the root zone, wh' +
        'en saturated in the fully rotated land at '
      
        '                the end of the season (EC in dS/m), only used wh' +
        'en the rotation key Kr=4 and equal to Cr4f in '
      '                eqn. 62'
      
        'Cti            Salt concentration of incoming groundwater throug' +
        'h the transition zone into a polygon'
      '                eqn.4.27a (EC in dS/m)'
      
        'Cxa'#9'Salt concentration of the soil moisture in the transition zo' +
        'ne aquifer above drain level, when '
      
        '                saturated, at the end of the season (EC in dS/m)' +
        ', only used when the drainage key Kd=1 and '
      '                equal to Cxaf in eqn. 72a'
      
        'Cxb'#9'Salt concentration of the soil moisture in the transition zo' +
        'ne below drain level, when saturated, at '
      
        '                the end of the season (EC in dS/m), only used wh' +
        'en the drainage key Kd=1 and equal to Cxbf in '
      '                eqn. 72b'
      
        'Cqf'#9'Seasonal average salt concentration of the soil moisture in ' +
        'the aquifer, when saturated,'
      
        '                at the end of the season (EC in dS/m), only used' +
        ' when the drainage key Kd=0, eqn. 70'
      
        'Cxf'#9'Seasonal average salt concentration of the soil moisture in ' +
        'the transition zone, when saturated, at'
      
        '                the end of the season (EC in dS/m), only used wh' +
        'en the drainage key Kd=0, eqn. 70 '
      
        'Cw'#9'Seasonal average salt concentration of the pumped well water ' +
        '(EC in dS/m), eqn. 76'
      ''
      
        'Dw'#9'Seasonal average depth of the water table below the soil surf' +
        'ace (m), eqn. 41, 42'
      
        'EaU'#9'Actual evapo-transpiration in the non-irrigated land (m3/sea' +
        'son per m2 non-irrigated area), eqn. 27'
      'FfA'#9'Field irrigation efficiency of group A crop(s) (-), eqn. 46a'
      'FfB'#9'Field irrigation efficiency of group B crop(s) (-), eqn. 46b'
      'Fft'#9'Total field irrigation efficiency (-), eqn. 47'
      
        'Gd'#9'Total amount of subsurface drainage water (m3/season per m2 t' +
        'otal area), only used when the '
      '                drainage key Kd=1, eqn. 36a and 38'
      
        'Ga'#9'Subsurface drainage water originating from ground water flow ' +
        'above drain level (m3/season per '
      
        '                m2 total area), only used when the drainage key ' +
        'Kd=1, eqn. 36c'
      
        'Gb'#9'Subsurface drainage water originating from ground water flow ' +
        'below drain level (m3/season per '
      
        '                m2 total area), only used when the drainage key ' +
        'Kd=1, eqn. 36b'
      'Gqi'#9'Horizontally incoming ground water flow through the aquifer'
      '               (m3/season per m2 total area)'
      'Gqo'#9'Horizontally outgoing ground water flow through the aquifer'
      '               (m3/season per m2 total area)'
      
        'Gti'#9'Horizontally incoming ground water flow through the transiti' +
        'on zone in'
      '               (m3/season per m2 total area)'
      
        'Gto'#9'Horizontally outgoing ground water flow through the transiti' +
        'on zone'
      '               (m3/season per m2 total area)'
      
        'Gtv'#9'Vertical ground water flow from rootzone into the transition' +
        ' zone '
      '               (m3/season per m2 total area) '
      '               Gtv = LrT + leakage from canals'
      'Gw          Discharge from wells (m3/season per m2 total area)'
      'Gaq    =   Gqi - Gqo - Gw'
      'Gnt     =   Gaq + Gti - Gto'
      ''
      
        'IaA'#9'Amount of field irrigation (m3/season per m2 irrigated land ' +
        'under group A crop(s)), equal to the'
      
        '                input value IaA1, IaA2, IaA3 or IaA4, depending ' +
        'on the season, or determined by eqn. 110a and '
      '                113a when the key for farmers'#39' responses Kf=1'
      
        'IaB'#9'Amount of field irrigation (m3/season per m2 irrigated land ' +
        'under group B crop(s)), equal to the '
      
        '                input value IaB1, IaB2, IaB3 or IaB4, depending ' +
        'on the season, or determined by eqn. 110b and '
      '                113b when the key for farmers'#39' responses Kf=1'
      
        'Io'#9'Water leaving the area through the irrigation canal system (b' +
        'ypass, m3/season per m2 total area), '
      
        '                equal to the input value Io1, Io2, Io3 or Io4, d' +
        'epending on the season, or determined by eqn. 109 '
      '                and 112 when the key for farmers'#39' responses Kf=1'
      
        'Is'#9'Net amount of irrigation water supplied by the canal system i' +
        'ncluding the percolation losses from '
      
        '                the canals, but excluding the use of drain and w' +
        'ell water and the bypass (m3/season per m2 total '
      '                area): Is=Ii(eqn. 18)-Io'
      
        'It'#9'Total amount of irrigation water applied, including the perco' +
        'lation losses from the canals and the '
      
        '                use of drainage and/or well water, but excluding' +
        ' the bypass (m3/season per m2 total area), '
      '                eqn. 48'
      'JsA'#9'Irrigation sufficiency of group A crop(s) (-), eqn. 49a'
      'JsB'#9'Irrigation sufficiency of group B crop(s) (-), eqn. 49b'
      ''
      
        'Kr'#9'Key for rotational type of agricultural land use (-).   Kr = ' +
        '0, 1, 2, 3 or 4. This value may be the same '
      
        '                as the one given with the input or it may be cha' +
        'nged by the program. Possible landuse types are: '
      
        '                irrigated land under group A crops, irrigated la' +
        'nd under crops group B crops, and non-irrigated land '
      '                (U);'
      'Kr=0'#9'no rotation'
      'Kr=4'#9'full rotation'
      
        'Kr=1'#9'part or all of the non-irrigated land remains permanently u' +
        'nchanged, the remaining land is under '
      '                full rotation'
      
        'Kr=2'#9'part or all of the irrigated land under group A crop(s) rem' +
        'ains permanently unchanged, the '
      '                remaining land is under full rotation'
      
        'Kr=3'#9'part or all of the irrigated land under group B crop(s) rem' +
        'ains permanently unchanged, the '
      '                remaining land is under full rotation'
      
        'Kr=5         part or all of the lirrigated land under group A an' +
        'd B crops(s) remains permannently unchamged,'
      '                the remaining land is under full rotation'
      
        'Kr=6         part or all of the unirrigated (U) land and the irr' +
        'igated land under group A crops(s) remains '
      
        '                permanently unchamged, the remaining land is und' +
        'er full rotation'
      
        'Kr=7         part or all of the unirrigated (U) land  and the ir' +
        'rigated land under group B crops(s) remains '
      
        '                permanently unchamged, the remaining land is und' +
        'er full rotation'
      
        'Kr=10       part or all of the unirrigated (U) land  and the irr' +
        'igated land under both group A and group B '
      
        '                crops(s) remains permanently unchamged, the rema' +
        'ining land is under full rotation'
      ''
      
        'LrA'#9'Percolation from the root zone (m3/season per m2 irrigated a' +
        'rea under group A crops), eqn. 19a'
      
        'LrB'#9'Percolation from the root zone (m3/season per m2 irrigated a' +
        'rea under group B crops), eqn. 19b'
      
        'LrT'#9'Total percolation from the root zone (m3/season per m2 total' +
        ' area), eqn. 19'
      
        'LrU'#9'Percolation from the root zone in the non-irrigated area (m3' +
        '/season per m2 non-irrigated area), '
      '                eqn. 19c'
      ''
      'Qv      Recharge from rootzone (m3/season per m2 total area)'
      ''
      
        'RrA'#9'Capillary rise into the root zone (m3/season per m2 irrigate' +
        'd area under group A crop(s), eqn. 27a'
      
        'RrB'#9'Capillary rise into the root zone (m3/season per m2 irrigate' +
        'd area under group B crop(s), eqn. 27b'
      
        'RrT'#9'Total capillary rise into the root zone (m3/season per m2 to' +
        'tal area), eqn. 21'
      
        'RrU'#9'Capillary rise into the root zone of the non-irrigated land ' +
        '(m3/season per m2 non-irrigated area), '
      '                eqn. 27c'
      
        'U'#9'Seasonal fraction of the non-irrigated area (-), equal to the ' +
        'input value U1, U2, U3 or U4, depending '
      
        '                on the season, or determined by eqn. 108 when th' +
        'e key for farmers'#39' responses Kf=1'
      
        'Uc'#9'Fraction of the permanently non-irrigated area throughout the' +
        ' seasons (-)'
      ''
      
        'Zs            Amount of salt stored above the soil surface (m.dS' +
        '/m)')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object InputSymbolsMemo: TMemo
    Left = 32
    Top = 20
    Width = 553
    Height = 341
    Lines.Strings = (
      ''
      '                                 LIST OF SYMBOLS OF INPUT DATA'
      ''
      
        'In some of the following symbols of input variables the sign # i' +
        's used to indicate the '
      'season number: # = 1, 2, 3, or 4'
      ''
      
        'A#'#9'Fraction of total area occupied by irrigated group A crops in' +
        ' season # (-),  0<A#<1'
      
        'B#'#9'Fraction of total area occupied by irrigated group B crops in' +
        ' season # (-),  0<B# <1'
      'Cic'#9'Salt concentration of the incoming canal water (EC in dS/m)'
      
        'CA0'#9'Initial salt concentration of the soil moisture, at field sa' +
        'turation, in the root '
      
        '                zone of the irrigated land under group A crop(s)' +
        ' (EC in dS/m)'
      
        'CB0'#9'Initial salt concentration of the soil moisture, at field sa' +
        'turation, in the root '
      
        '                zone of the irrigated land under group B crop(s)' +
        ' (EC in dS/m)'
      'Ch'#9'Salt concentration of the incoming ground water (EC in dS/m)'
      
        'Cinf          Salt concentartion of the incoming groundwater Qin' +
        'f (EC in dS/m)'
      'Cp'#9'Salt concentration of the rain water (EC in dS/m)'
      
        'Cq0'#9'Initial salt concentration of the ground water in the aquife' +
        'r (EC in dS/m)'
      
        'Cx0'#9'Initial salt concentration of the soil moisture in the trans' +
        'ition zone (EC in dS/m)'
      
        'Cxa0'#9'Initial salt concentration of the ground water in the upper' +
        ' part of the transition '
      '                zone, i.e. above drain level (EC in dS/m)'
      
        'Cxb0'#9'Initial salt concentration of the ground water in the lower' +
        ' part of the transition '
      '                zone, i.e. below drain level (EC in dS/m)'
      
        'CU0'#9'Initial salt concentration of the soil moisture, when at fie' +
        'ld saturation, in the'
      '                root zone of the non-irrigated land (EC in dS/m)'
      
        'Dc'#9'Critical depth of the water table for capillary rise (m), Dcr' +
        ' > Dr'
      'Dd'#9'Depth of subsurface drains (m), Dd > Dr'
      'Dq'#9'Thickness of the aquifer (m)'
      'Dr'#9'Thickness of the root zone (m), Dr >0.1 > Dcr'
      
        'Dx'#9'Thickness of the transition zone between root zone and aquife' +
        'r (m)'
      'Dw0'#9'Initial depth of the water table (m)'
      
        'EpA#'#9'Potential evapo-transpiration of irrigated group A crop(s) ' +
        'in season #'
      
        '                (m3/season per m2 irrigated area under group A c' +
        'rops)'
      
        'EpB#'#9'Potential evapo-transpiration of irrigated group B crop(s) ' +
        'in season #'
      
        '                (m3/season per m2 irrigated area under group B c' +
        'rops)'
      
        'EpU#'#9'Potential evapo-transpiration of non-irrigated area in seas' +
        'on #'
      '                (m3/season per m2 non-irrigated area)'
      'Fla'#9'Leaching efficiency of the aquifer (-),  Fla > 0'
      'Flr'#9'Leaching efficiency of the root zone (-),  Flr > 0'
      'Flt'#9'Leaching efficiency of the transition zone (-),  Flt > 0'
      
        'Frd'#9'Reduction factor of the drainage function for water table co' +
        'ntrol or for partial'
      '                drainage of the area (-)'
      
        'FsA#'#9'Storage efficiency of irrigation and rain water in irrigate' +
        'd land under group A'
      
        '                crop(s): fraction of irrigation and rainwater st' +
        'ored in the root zone of A crop(s),'
      
        '                average of all irrigations and rain storms (-), ' +
        ' 0 < FsA < 1'
      
        'FsB#'#9'Storage efficiency of irrigation and rain water in irrigate' +
        'd land under group B'
      
        '                crop(s): fraction of irrigation and rain water s' +
        'tored in the root zone of B crop(s),'
      
        '                average for all irrigations and rain storms (-),' +
        '  0 < FsB < 1'
      
        'FsU#'#9'Efficiency of rain water in non-irrigated land: fraction of' +
        ' rainwater stored in'
      
        '                the root zone of non-irrigated lands as an avera' +
        'ge for all rain storms (-),'
      '                0 < FsU < 1'
      
        'Fw#'#9'Fraction of pumped well water used for irrigation (-),  0 < ' +
        'Fw < 1'
      'Gu#'#9'Subsurface drainage water used for irrigation in season #'
      '                (m3/season per m2 total area),  Gu# < Gd'
      'Gw#'#9'Ground water pumped from wells in the aquifer in season #'
      '                (m3/season per m2 total area)'
      
        'IaA#'#9'Irrigation water applied to the irrigated fields under grou' +
        'p A crop(s) in season #'
      
        '                (m3/season per m2 area under group A crops). Res' +
        'use of drain and '
      '                well water not to be included.'
      
        'IaB#'#9'Irrigation water applied to the irrigated fields under grou' +
        'p B crop(s) in season #'
      
        '                (m3/season per m2 area under group B crops). Reu' +
        'se of drain  and'
      '                well water not to to be included.'
      
        'Io#'#9'Water leaving the area through the irrigation canal system i' +
        'n season #'
      '                (bypass, m3/season per m2 total area)'
      'Kaq         Hydraulic conductivity of the aquifer (m/day)'
      'Ktop        Hydraulic conductivity of the top layer (m/day)'
      'Kd'#9'Key for the presence of a subsurface drainage system:'
      '                yes -> Kd = 1, no -> Kd = 0'
      
        'Kf'#9'Key for farmers'#39' responses to water  logging, salinization or' +
        ' irrigation scarcity:'
      '                yes -> Kf = 1, no -> Kf = 0'
      
        'Kr'#9'Key for rotational type of agricultural land use (-). Kr = 0,' +
        ' 1, 2, 3 or 4.'
      
        '                Possible landuse types are: irrigated land under' +
        ' group A crops, irrigated land under'
      '                group B crops, and non-irrigated land (U);'
      '                Kr=0'#9'no rotation'
      '                Kr=4'#9'full rotation'
      
        '                Kr=1'#9'part or all of the non-irrigated land remai' +
        'ns permanently unchanged,'
      
        '                                the remaining land is under full' +
        ' rotation'
      
        '                Kr=2'#9'part or all of the irrigated land under gro' +
        'up A crop(s) remains permanently'
      
        '                                unchanged, the remaining land is' +
        ' under full rotation'
      
        '                Kr=3'#9'part or all of the irrigated land under gro' +
        'up B crop(s) remains permanently'
      
        '                                unchanged, the remaining land is' +
        ' under full rotation'
      'Ky'#9'Key for yearly changes of input data (-)'
      'Lc#'#9'Percolation from the irrigation canal system in season #'
      '                (m3/season per m2 total area)'
      'Ns'#9'Number of seasons per year, Ns = 1, 2, 3, or 4'
      'Ny'#9'Number of years for model running (-), 1 < Ny < 99'
      
        'Peq'#9'Effective porosity (drainable or refillable pore space) of t' +
        'he aquifer (m/m),'
      '                0 < Peq < Ptq'
      
        'Per'#9'Effective porosity (drainable or refillable pore space) of t' +
        'he root zone (m/m),'
      '                0 < Per < Ptr'
      
        'Pex'#9'Effective porosity (drainable or refillable pore space) of t' +
        'he transition zone (m/m),'
      '                0 < Pex < Ptx'
      'Pp#'#9'Rainfall in season # (m3/season per m2 total area)'
      'Ptq'#9'Total pore space of the aquifer (m/m), Peq < Ptq < 1'
      'Ptr'#9'Total pore space of the root zone (m/m), Per < Ptr < 1'
      'Ptx'#9'Total pore space of transition zone (m/m), Pex < Ptx < 1'
      
        'QH1'#9'Ratio of drain discharge and height of the water table above' +
        ' drain level '
      '                (m/day per m)'
      
        'QH2'#9'Ratio of drain discharge and squared height of the water tab' +
        'le above drain level '
      '                (m/day per m2)'
      'RcA#'#9'Whether group A crops in season # is paddy (1) or not (0)'
      'RcA#'#9'Whether group B crops in season # is paddy (1) or not (0)'
      
        'Qinf          Inflow of groundwater into the aquifer from cracks' +
        ' through the impermeable'
      '                layer, or geological fault lines (m/year)'
      
        'Qout        Outflow of groundwater from the aquifer into cracks ' +
        'through the impermeable'
      '                layer, or geological fault lines (m/year)'
      
        'SiU#'#9'Surface inflow from surroundings into the non-irrigated are' +
        'a in season #'
      '                (m3/season per m2 non-irrigated area)'
      
        'SoA#'#9'Outgoing surface runoff or surface drain water from irrigat' +
        'ed land under group '
      
        '                A crop(s) in season # (m3/season per m2 irrigate' +
        'd area under group A crops)'
      
        'SoB#'#9'Outgoing surface runoff or surface drain water from irrigat' +
        'ed land under group '
      
        '                B crop(s) in season # (m3/season per m2 irrigate' +
        'd area under group B crops)'
      
        'SoU#'#9'Outgoing surface runoff water from the non-irrigated area i' +
        'n season # '
      '                (m3/season per m2 non-irrigated area)'
      'Ts#'#9'Duration of the season # (months)'
      '')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object KrMemo: TMemo
    Left = 32
    Top = 24
    Width = 537
    Height = 345
    Lines.Strings = (
      ''
      
        'To accommodate the rotational land use, Saltmod distinguishes 3 ' +
        'types of land use per season:'
      ''
      'A: irrigated land under group A crops'
      'B: irrigated land under group B crops'
      'U: non-irrigated land (U)'
      ''
      
        'The distinction between group A and B crops is made to introduce' +
        ' the possibility of having lightly and '
      'heavily '
      
        'irrigated crops. Examples of the second kind are submerged rice ' +
        'and sugarcane. The latter crop may cover '
      
        'more than one season. The distinction also gives the possibility' +
        ' to introduce permanent instead of arable '
      
        'crops like orchards. The non-irrigated land may consist of rainf' +
        'ed crops and temporary or permanently fallow '
      'land.'
      ''
      
        'Each land use type is determined by an area fraction A, B, and U' +
        ' respectively. The sum of the fractions '
      'equals unity:  A + B + U = 1 '#9#9#9#9#9#9
      #9
      
        'In Sahysmod, the water and salt balances are calculated separate' +
        'ly for the different reservoirs and, in '
      
        'addition, for different types of cropping rotation, indicated by' +
        ' the rotation key Kr that can reach '
      'the values 0, 1, 2, 3, 4, 5, 6, 7 and 10.'
      '(before August 1914 SahysMod contained only 5 Kr options).'
      ''
      
        'Kr = 0 indicates that there is no annual cropping rotation and a' +
        'll land use types are fixed to the same areas'
      'each season. '
      ''
      
        'Kr = 1 indicates that part or all of the non-irrigated (U) land ' +
        'is permanently used unchanged throughout the'
      
        'seasons (e.g. permanently uncultivated land, non-irrigated grazi' +
        'ng land, non-irrigated (agro-forestry,'
      'abandoned land), whilee the remainder is rotated.'
      ''
      
        'Kr = 2 indicates that part or all of the land under group A crop' +
        '(s) is permanently used unchanged throughout'
      
        'the seasons (e.g. the land under irrigated sugarcane) while the ' +
        'remainder is under crop rotation.'
      ''
      
        'Kr = 3 indicates that part or all of the land under group B crop' +
        '(s) is permanently used unchanged throughout'
      
        'the seasons (e.g. double irrigated rice crops) while the remaind' +
        'er is rotated.'
      ''
      
        'Kr = 4 indicates that there is full annual cropping rotation and' +
        ' that the land use types are continually moved'
      'over the area.'
      ''
      
        'Kr = 5 indicates that the A and B areas are partly fixed in all ' +
        'seasons (no rotation) while the'
      'remainder is rotated over the seasons.'
      ''
      
        'Kr = 6 indicates that the A and U areas are partly fixed in all ' +
        'seasons (no rotation) while the'
      'remainder is rotated over the seasons.'
      ''
      
        'Kr = 7 indicates that the B and U areas are partly fixed in all ' +
        'seasons (no rotation) while in the'
      'remainder there is crop rotation over the seasons.'
      ''
      
        'Kr=10 indicates that the A, B and U land are partly fixed in all' +
        ' seasons (no rotation) while in the '
      'remainder there is crop rotation over the seasons.'
      ''
      
        'It is immaterial whether one assigns a permanent land use type e' +
        'ither to the A or B group of crop(s). Also,'
      
        'a group of crops may consist of only one type of crop. It would ' +
        'be a good practice to reserve one group'
      
        'for the intensively irrigated crops and the other for the more l' +
        'ightly irrigated crops.')
    ScrollBars = ssVertical
    TabOrder = 3
  end
end
