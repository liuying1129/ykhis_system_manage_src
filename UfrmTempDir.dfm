object frmTempDir: TfrmTempDir
  Left = 196
  Top = 124
  Width = 696
  Height = 480
  Caption = #27169#26495#30446#24405#31649#29702
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 241
    Top = 41
    Height = 400
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 41
    Width = 241
    Height = 400
    Align = alLeft
    Caption = #31867#21035#21015#34920
    TabOrder = 0
    object tvWareHouse: TTreeView
      Left = 2
      Top = 15
      Width = 237
      Height = 383
      Align = alClient
      HideSelection = False
      Indent = 19
      ReadOnly = True
      TabOrder = 0
      OnChange = tvWareHouseChange
      OnDeletion = tvWareHouseDeletion
    end
  end
  object Panel1: TPanel
    Left = 244
    Top = 41
    Width = 436
    Height = 400
    Align = alClient
    TabOrder = 1
    object labWhId: TLabel
      Left = 33
      Top = 29
      Width = 39
      Height = 13
      Caption = #25490#24207#21495
    end
    object labWhName: TLabel
      Left = 45
      Top = 58
      Width = 26
      Height = 13
      Caption = #21517#31216
    end
    object edtWhId: TEdit
      Left = 105
      Top = 25
      Width = 120
      Height = 21
      TabOrder = 0
    end
    object edtWhName: TEdit
      Left = 105
      Top = 54
      Width = 120
      Height = 21
      ImeMode = imOpen
      TabOrder = 1
      OnKeyDown = edtWhNameKeyDown
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 41
    Align = alTop
    TabOrder = 2
    object BitBtn1: TBitBtn
      Left = 5
      Top = 8
      Width = 100
      Height = 25
      Caption = #26032#22686#21516#32423#33410#28857'F1'
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 105
      Top = 8
      Width = 100
      Height = 25
      Caption = #26032#22686#19979#32423#33410#28857'F2'
      TabOrder = 1
      OnClick = BitBtn2Click
    end
    object BitBtn3: TBitBtn
      Left = 206
      Top = 8
      Width = 69
      Height = 25
      Caption = #20445#23384'F3'
      TabOrder = 2
      OnClick = BitBtn3Click
    end
    object BitBtn4: TBitBtn
      Left = 276
      Top = 8
      Width = 89
      Height = 25
      Caption = #21024#38500#33410#28857'F4'
      TabOrder = 3
      OnClick = BitBtn4Click
    end
    object BitBtn5: TBitBtn
      Left = 366
      Top = 8
      Width = 61
      Height = 25
      Caption = #21047#26032'F5'
      TabOrder = 4
      OnClick = BitBtn5Click
    end
    object BitBtn6: TBitBtn
      Left = 428
      Top = 8
      Width = 65
      Height = 25
      Caption = #36864#20986'Esc'
      TabOrder = 5
      OnClick = BitBtn6Click
    end
  end
  object DosMove1: TDosMove
    Active = True
    Left = 296
    Top = 160
  end
  object ActionList1: TActionList
    Left = 328
    Top = 160
    object ActAdd1: TAction
      Caption = 'ActAdd1'
      ShortCut = 112
      OnExecute = BitBtn1Click
    end
    object ActAdd2: TAction
      Caption = 'ActAdd2'
      ShortCut = 113
      OnExecute = BitBtn2Click
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
    object ActRefresh: TAction
      Caption = 'ActRefresh'
      ShortCut = 116
      OnExecute = BitBtn5Click
    end
    object ActExit: TAction
      Caption = 'ActExit'
      ShortCut = 27
      OnExecute = BitBtn6Click
    end
  end
end
