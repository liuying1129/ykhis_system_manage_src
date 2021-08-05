object frmPower: TfrmPower
  Left = 161
  Top = 82
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26435#38480#35774#32622
  ClientHeight = 556
  ClientWidth = 782
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 782
    Height = 556
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #35282#33394#35774#32622
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 774
        Height = 41
        Align = alTop
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label4: TLabel
          Left = 8
          Top = 12
          Width = 52
          Height = 13
          Caption = #36873#25321#31995#32479
        end
        object ComboBox1: TComboBox
          Left = 64
          Top = 9
          Width = 121
          Height = 21
          DropDownCount = 20
          ItemHeight = 0
          TabOrder = 0
          OnChange = ComboBox1Change
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 41
        Width = 264
        Height = 487
        Align = alLeft
        Caption = #35282#33394#21015#34920
        TabOrder = 1
        object DBGrid_js1: TDBGrid
          Left = 2
          Top = 15
          Width = 260
          Height = 470
          Align = alClient
          DataSource = DataSource_js
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -13
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
        end
      end
      object CheckListBox1: TCheckListBox
        Left = 264
        Top = 41
        Width = 510
        Height = 487
        OnClickCheck = CheckListBox1ClickCheck
        Align = alClient
        Columns = 2
        ItemHeight = 13
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20154#21592#26435#38480#20998#37197
      ImageIndex = 1
      object GroupBox6: TGroupBox
        Left = 0
        Top = 0
        Width = 264
        Height = 528
        Align = alLeft
        TabOrder = 0
        object DBGrid_zy: TDBGrid
          Left = 2
          Top = 95
          Width = 260
          Height = 431
          Align = alClient
          DataSource = DataSource_zy
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -13
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
        end
        object Panel2: TPanel
          Left = 2
          Top = 15
          Width = 260
          Height = 80
          Align = alTop
          TabOrder = 1
          object LabeledEdit1: TLabeledEdit
            Left = 37
            Top = 25
            Width = 185
            Height = 21
            EditLabel.Width = 183
            EditLabel.Height = 13
            EditLabel.Caption = #20154#21592#25628#32034'.'#22635#20889#24037#21495#25110#22995#21517','#22238#36710
            TabOrder = 0
            OnKeyDown = LabeledEdit1KeyDown
          end
          object Edit1: TEdit
            Left = 37
            Top = 51
            Width = 185
            Height = 21
            Color = clMenu
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = #23435#20307
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
      object CheckListBox2: TCheckListBox
        Left = 264
        Top = 0
        Width = 510
        Height = 528
        OnClickCheck = CheckListBox2ClickCheck
        Align = alClient
        Columns = 2
        ItemHeight = 13
        TabOrder = 1
      end
    end
  end
  object DataSource_js: TDataSource
    DataSet = ADOQuery_js
    Left = 424
  end
  object DataSource_zy: TDataSource
    DataSet = ADOQuery_zy
    Left = 592
  end
  object ADOQuery_js: TMyQuery
    AfterScroll = ADOQuery_jsAfterScroll
    Left = 388
  end
  object ADOQuery_zy: TMyQuery
    AfterScroll = ADOQuery_zyAfterScroll
    Left = 556
  end
end
