object frmCommCode: TfrmCommCode
  Left = 190
  Top = 176
  Width = 700
  Height = 500
  Caption = #36890#29992#20195#30721
  Color = clSkyBlue
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 225
    Top = 0
    Width = 459
    Height = 461
    Align = alClient
    Color = 16767438
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 225
    Height = 461
    Align = alLeft
    Color = clSkyBlue
    TabOrder = 1
    object Label1: TLabel
      Left = 15
      Top = 36
      Width = 52
      Height = 13
      Caption = #20195#30721#31867#22411
    end
    object Label2: TLabel
      Left = 3
      Top = 441
      Width = 216
      Height = 13
      Caption = #27880':'#35774#32622'"'#31995#32479#20195#30721'"'#38656#37325#21551#31243#24207#25165#29983#25928
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object SpeedButton1: TSpeedButton
      Left = 191
      Top = 32
      Width = 23
      Height = 22
      Hint = #22686#21152#20195#30721#31867#22411
      Glyph.Data = {
        26040000424D2604000000000000360000002800000012000000120000000100
        180000000000F003000025160000251600000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFE9BE6BE9BE6BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4B04DE4B04D
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4B04DE4B04DFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFE4B04DE4B04DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFE4B04DE4B04DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4B04DE4B04D
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
        E7BA65E4B04DE4B04DE4B04DE4B04DE4B04DE4B04DE4B04DE4B04DE4B04DE4B0
        4DE4B04DE4B04DE7B75CFFFFFFFFFFFF0000FFFFFFFFFFFFE5B354E4B04DE4B0
        4DE4B04DE4B04DE4B04DE4B04DE4B04DE4B04DE4B04DE4B04DE4B04DE4B04DE9
        BE6BFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFE4B04DE4B04DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4B04DE4B04D
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4B04DE4B04DFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFE4B04DE4B04DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFE4B04DE4B04DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7BA65E7BA65
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF0000}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object LabeledEdit2: TLabeledEdit
      Left = 69
      Top = 85
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #21517#31216
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 2
    end
    object BitBtn1: TBitBtn
      Left = 62
      Top = 379
      Width = 76
      Height = 25
      Caption = #26032#22686
      TabOrder = 15
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 138
      Top = 379
      Width = 75
      Height = 25
      Caption = #20445#23384
      TabOrder = 14
      OnClick = BitBtn2Click
    end
    object BitBtn3: TBitBtn
      Left = 62
      Top = 403
      Width = 76
      Height = 25
      Caption = #21024#38500
      TabOrder = 16
      OnClick = BitBtn3Click
    end
    object LabeledEdit1: TLabeledEdit
      Left = 69
      Top = 61
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #20195#30721
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 1
    end
    object LabeledEdit3: TLabeledEdit
      Left = 69
      Top = 109
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #22791#27880
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 3
    end
    object ComboBox1: TComboBox
      Left = 69
      Top = 32
      Width = 120
      Height = 21
      Style = csDropDownList
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboBox1Change
    end
    object BitBtn4: TBitBtn
      Left = 138
      Top = 403
      Width = 75
      Height = 25
      Caption = #23548#20986
      TabOrder = 17
      OnClick = BitBtn4Click
    end
    object LabeledEdit4: TLabeledEdit
      Left = 69
      Top = 133
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = #20445#30041#23383#27573'1'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 4
    end
    object LabeledEdit5: TLabeledEdit
      Left = 69
      Top = 157
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = #20445#30041#23383#27573'2'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 5
    end
    object LabeledEdit6: TLabeledEdit
      Left = 69
      Top = 181
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = #20445#30041#23383#27573'3'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 6
    end
    object LabeledEdit7: TLabeledEdit
      Left = 69
      Top = 205
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = #20445#30041#23383#27573'4'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 7
    end
    object LabeledEdit8: TLabeledEdit
      Left = 69
      Top = 229
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = #20445#30041#23383#27573'5'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 8
    end
    object LabeledEdit9: TLabeledEdit
      Left = 69
      Top = 253
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = #20445#30041#23383#27573'6'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 9
    end
    object LabeledEdit10: TLabeledEdit
      Left = 69
      Top = 277
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = #20445#30041#23383#27573'7'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 10
    end
    object LabeledEdit11: TLabeledEdit
      Left = 69
      Top = 301
      Width = 145
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = #20445#30041#23383#27573'8'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 11
    end
    object DateTimePicker1: TDateTimePicker
      Left = 192
      Top = 325
      Width = 22
      Height = 21
      Date = 40647.679042129630000000
      Time = 40647.679042129630000000
      TabOrder = 18
      OnChange = DateTimePicker1Change
    end
    object DateTimePicker2: TDateTimePicker
      Left = 192
      Top = 351
      Width = 22
      Height = 21
      Date = 40647.690831944440000000
      Time = 40647.690831944440000000
      TabOrder = 19
      OnChange = DateTimePicker2Change
    end
    object LabeledEdit12: TLabeledEdit
      Left = 69
      Top = 326
      Width = 123
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = #20445#30041#23383#27573'9'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 12
    end
    object LabeledEdit13: TLabeledEdit
      Left = 69
      Top = 352
      Width = 123
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 66
      EditLabel.Height = 13
      EditLabel.Caption = #20445#30041#23383#27573'10'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 13
    end
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 576
    Top = 56
  end
  object DosMove1: TDosMove
    Active = True
    Left = 336
    Top = 16
  end
  object ADOQuery1: TMyQuery
    AfterOpen = ADOQuery1AfterOpen
    AfterScroll = ADOQuery1AfterScroll
    Left = 544
    Top = 56
  end
end
