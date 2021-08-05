object frmMain: TfrmMain
  Left = 276
  Top = 150
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'HIS'#21518#21488#31649#29702
  ClientHeight = 341
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 224
    Top = 144
    Width = 150
    Height = 80
    Caption = #33647#21697#31649#29702
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 400
    Top = 40
    Width = 150
    Height = 80
    Caption = #27169#26495#30446#24405#31649#29702
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 400
    Top = 144
    Width = 150
    Height = 80
    Caption = #27169#26495#20869#23481#35774#32622
    OnClick = SpeedButton3Click
  end
  object SpeedButton4: TSpeedButton
    Left = 32
    Top = 40
    Width = 150
    Height = 80
    Caption = #36890#29992#20195#30721#35774#32622
    OnClick = Button1Click
  end
  object SpeedButton5: TSpeedButton
    Left = 224
    Top = 40
    Width = 150
    Height = 80
    Caption = #20154#21592#31649#29702
    OnClick = BitBtn2Click
  end
  object SpeedButton6: TSpeedButton
    Left = 32
    Top = 144
    Width = 150
    Height = 80
    Caption = #26435#38480#35774#32622
    OnClick = BitBtn1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 322
    Width = 584
    Height = 19
    Panels = <
      item
        Width = 75
      end
      item
        Text = #25805#20316#20154#21592#24037#21495':'
        Width = 80
      end
      item
        Width = 50
      end
      item
        Text = #25805#20316#20154#21592#22995#21517':'
        Width = 80
      end
      item
        Width = 50
      end
      item
        Text = #25480#26435#20351#29992#21333#20301':'
        Width = 80
      end
      item
        Width = 150
      end
      item
        Text = #26381#21153#22120':'
        Width = 45
      end
      item
        Width = 50
      end
      item
        Text = #25968#25454#24211':'
        Width = 45
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Left = 8
    Top = 8
    object N1: TMenuItem
      Caption = #25991#20214
      object N6: TMenuItem
        Caption = #37325#26032#30331#24405
        OnClick = N6Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object N8: TMenuItem
        Caption = #20462#25913#23494#30721
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object N5: TMenuItem
        Caption = #36864#20986#31995#32479
        OnClick = N5Click
      end
    end
    object N10: TMenuItem
      Caption = #31995#32479#35774#32622
      object N11: TMenuItem
        Caption = #36873#39033
        OnClick = N11Click
      end
    end
    object N2: TMenuItem
      Caption = #24110#21161
      object N4: TMenuItem
        Caption = #20851#20110'...'
      end
    end
  end
  object TimerIdleTracker: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = TimerIdleTrackerTimer
    Left = 40
    Top = 8
  end
end
