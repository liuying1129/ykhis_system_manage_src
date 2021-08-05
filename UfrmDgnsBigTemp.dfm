object frmDgnsBigTemp: TfrmDgnsBigTemp
  Left = 402
  Top = 152
  Width = 847
  Height = 500
  Caption = #27169#26495#20869#23481#35774#32622
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 211
    Top = 34
    Height = 427
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 831
    Height = 34
    Align = alTop
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 178
      Top = 4
      Width = 88
      Height = 25
      Caption = #26032#22686'F2'
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn3: TBitBtn
      Left = 266
      Top = 4
      Width = 88
      Height = 25
      Caption = #20445#23384'F3'
      TabOrder = 3
      OnClick = BitBtn3Click
    end
    object BitBtn4: TBitBtn
      Left = 354
      Top = 4
      Width = 88
      Height = 25
      Caption = #21024#38500'F4'
      TabOrder = 1
      OnClick = BitBtn4Click
    end
    object BitBtn6: TBitBtn
      Left = 442
      Top = 4
      Width = 88
      Height = 25
      Caption = #36864#20986'(Esc)'
      TabOrder = 2
      OnClick = BitBtn6Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 34
    Width = 211
    Height = 427
    Align = alLeft
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 209
      Height = 425
      Align = alClient
      Caption = #31867#21035
      TabOrder = 0
      object tvWareHouse: TTreeView
        Left = 2
        Top = 15
        Width = 205
        Height = 408
        Align = alClient
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        OnChange = tvWareHouseChange
        OnDeletion = tvWareHouseDeletion
      end
    end
  end
  object Panel3: TPanel
    Left = 214
    Top = 34
    Width = 617
    Height = 427
    Align = alClient
    TabOrder = 2
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 615
      Height = 225
      Align = alTop
      TabOrder = 0
      object Label2: TLabel
        Left = 323
        Top = 20
        Width = 26
        Height = 13
        Caption = #29992#27861
      end
      object Label3: TLabel
        Left = 405
        Top = 20
        Width = 26
        Height = 13
        Caption = #39057#27425
      end
      object Label16: TLabel
        Left = 4
        Top = 3
        Width = 78
        Height = 13
        Caption = #33647#21697#21807#19968#32534#21495
      end
      object Label4: TLabel
        Left = 8
        Top = 64
        Width = 52
        Height = 13
        Caption = #30149#21382#20869#23481
      end
      object Label1: TLabel
        Left = 3
        Top = 19
        Width = 78
        Height = 13
        Caption = #27169#26495#20869#23481#31867#22411
      end
      object LabeledEdit2: TLabeledEdit
        Left = 103
        Top = 35
        Width = 85
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #21517#31216
        ImeMode = imOpen
        TabOrder = 1
        OnKeyDown = LabeledEdit2KeyDown
      end
      object LabeledEdit3: TLabeledEdit
        Left = 203
        Top = 35
        Width = 25
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #32452#21495
        TabOrder = 2
      end
      object LabeledEdit4: TLabeledEdit
        Left = 236
        Top = 35
        Width = 30
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #29992#37327
        TabOrder = 3
        OnChange = LabeledEdit4Change
      end
      object LabeledEdit5: TLabeledEdit
        Left = 479
        Top = 35
        Width = 30
        Height = 21
        EditLabel.Width = 46
        EditLabel.Height = 13
        EditLabel.Caption = #22825'/'#21058#25968
        TabOrder = 7
        OnChange = LabeledEdit4Change
      end
      object LabeledEdit6: TLabeledEdit
        Left = 529
        Top = 35
        Width = 30
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #25968#37327
        TabOrder = 8
      end
      object ComboBox2: TComboBox
        Left = 267
        Top = 35
        Width = 48
        Height = 21
        DropDownCount = 20
        ItemHeight = 13
        TabOrder = 4
        OnChange = LabeledEdit4Change
      end
      object ComboBox3: TComboBox
        Left = 322
        Top = 35
        Width = 75
        Height = 21
        DropDownCount = 20
        ItemHeight = 13
        TabOrder = 5
      end
      object ComboBox4: TComboBox
        Left = 404
        Top = 35
        Width = 58
        Height = 21
        DropDownCount = 20
        ItemHeight = 13
        TabOrder = 6
        OnChange = LabeledEdit4Change
      end
      object ComboBox5: TComboBox
        Left = 560
        Top = 35
        Width = 48
        Height = 21
        DropDownCount = 20
        ItemHeight = 13
        TabOrder = 9
        OnChange = LabeledEdit4Change
      end
      object Memo1: TMemo
        Left = 66
        Top = 63
        Width = 519
        Height = 155
        ImeMode = imOpen
        ScrollBars = ssBoth
        TabOrder = 10
      end
      object ComboBox1: TComboBox
        Left = 5
        Top = 35
        Width = 75
        Height = 21
        DropDownCount = 20
        ItemHeight = 13
        TabOrder = 0
        OnChange = ComboBox1Change
      end
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 226
      Width = 615
      Height = 200
      Align = alClient
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
    end
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    OnDataChange = DataSource1DataChange
    Left = 280
    Top = 281
  end
  object ActionList1: TActionList
    Left = 48
    Top = 72
    object ActAdd: TAction
      Caption = 'ActAdd'
      ShortCut = 113
      OnExecute = BitBtn1Click
    end
    object ActSave: TAction
      Caption = 'ActSave'
      ShortCut = 114
      OnExecute = BitBtn3Click
    end
    object ActDel: TAction
      Caption = 'ActDel'
      ShortCut = 115
      OnExecute = BitBtn4Click
    end
    object ActEsc: TAction
      Caption = 'ActEsc'
      ShortCut = 27
      OnExecute = BitBtn6Click
    end
    object ActSearch: TAction
      Caption = 'ActSearch'
      ShortCut = 116
    end
  end
  object ADOQuery1: TMyQuery
    AfterOpen = ADOQuery1AfterOpen
    AfterScroll = ADOQuery1AfterScroll
    Left = 240
    Top = 282
  end
  object DosMove1: TDosMove
    Active = True
    Left = 664
    Top = 8
  end
end
