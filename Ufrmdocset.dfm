object frmdocset: Tfrmdocset
  Left = 202
  Top = 131
  Width = 544
  Height = 375
  Caption = #20154#21592#35774#32622
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 98
    Width = 528
    Height = 238
    Align = alClient
    Color = 16767438
    DataSource = DataSourcedoclist
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 528
    Height = 57
    Align = alTop
    Color = clSkyBlue
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 32
      Width = 125
      Height = 13
      Caption = #27880#65306#24102'[*]'#30340#24517#39035#36755#20837
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 365
      Top = 7
      Width = 26
      Height = 13
      Caption = #32844#31216
    end
    object LabeledEdit1: TLabeledEdit
      Left = 80
      Top = 4
      Width = 85
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 47
      EditLabel.Height = 13
      EditLabel.Caption = #24037#21495'[*]'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 0
    end
    object LabeledEdit2: TLabeledEdit
      Left = 247
      Top = 4
      Width = 85
      Height = 19
      Color = 16767438
      Ctl3D = False
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #21517#31216
      ImeMode = imOpen
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 1
    end
    object ComboBox2: TComboBox
      Left = 394
      Top = 3
      Width = 120
      Height = 21
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 528
    Height = 41
    Align = alTop
    Color = clSkyBlue
    TabOrder = 2
    object suiButton1: TSpeedButton
      Left = 5
      Top = 8
      Width = 58
      Height = 27
      Caption = #26032#22686
      Transparent = False
      OnClick = suiButton1Click
    end
    object suiButton2: TSpeedButton
      Left = 69
      Top = 8
      Width = 58
      Height = 27
      Caption = #20445#23384
      Transparent = False
      OnClick = suiButton2Click
    end
    object suiButton3: TSpeedButton
      Left = 133
      Top = 8
      Width = 58
      Height = 27
      Caption = #21024#38500
      Transparent = False
      OnClick = suiButton3Click
    end
    object Label2: TLabel
      Left = 339
      Top = 15
      Width = 52
      Height = 13
      Caption = #36873#25321#37096#38376
    end
    object BitBtn1: TBitBtn
      Left = 200
      Top = 8
      Width = 113
      Height = 27
      Caption = #23548#20986#37096#38376#20154#21592
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object ComboBox1: TComboBox
      Left = 394
      Top = 11
      Width = 120
      Height = 21
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 1
      OnChange = ComboBox1Change
    end
  end
  object DataSourcedoclist: TDataSource
    DataSet = ADOdoclist
    Left = 476
    Top = 248
  end
  object DosMove1: TDosMove
    Active = True
    Left = 368
    Top = 248
  end
  object ADOdoclist: TUniQuery
    AfterOpen = ADOdoclistAfterOpen
    AfterScroll = ADOdoclistAfterScroll
    Left = 440
    Top = 249
  end
end
