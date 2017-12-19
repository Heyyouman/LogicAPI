object FormSettings: TFormSettings
  Left = 397
  Top = 326
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 113
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelUpdRange: TLabel
    Left = 8
    Top = 24
    Width = 148
    Height = 13
    Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1084#1077#1078#1076#1091' '#1087#1088#1086#1074#1077#1088#1082#1072#1084#1080
  end
  object LabelSeconds: TLabel
    Left = 212
    Top = 24
    Width = 36
    Height = 13
    Caption = #1089#1077#1082#1091#1085#1076
  end
  object EditUpdRange: TEdit
    Left = 162
    Top = 21
    Width = 44
    Height = 21
    TabOrder = 0
    Text = '1'
    OnChange = EditUpdRangeChange
  end
  object ButtonConfirm: TButton
    Left = 24
    Top = 78
    Width = 75
    Height = 25
    Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100
    Enabled = False
    TabOrder = 1
    OnClick = ButtonConfirmClick
  end
  object ButtonOk: TButton
    Left = 212
    Top = 78
    Width = 75
    Height = 25
    Caption = #1054#1082
    TabOrder = 2
    OnClick = ButtonOkClick
  end
  object ButtonExit: TButton
    Left = 120
    Top = 78
    Width = 75
    Height = 25
    Caption = #1042#1099#1081#1090#1080
    TabOrder = 3
    OnClick = ButtonExitClick
  end
end
