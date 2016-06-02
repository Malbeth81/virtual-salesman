object frmLogin: TfrmLogin
  Left = 382
  Top = 56
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Identification'
  ClientHeight = 129
  ClientWidth = 169
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblUsername: TLabel
    Left = 0
    Top = 0
    Width = 51
    Height = 13
    Caption = 'Username:'
  end
  object lblPassword: TLabel
    Left = 0
    Top = 48
    Width = 49
    Height = 13
    Caption = 'Password:'
  end
  object edtPassword: TEdit
    Left = 0
    Top = 64
    Width = 169
    Height = 21
    AutoSelect = False
    PasswordChar = '*'
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 0
    Top = 104
    Width = 81
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 88
    Top = 104
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object edtUsername: TEdit
    Left = 0
    Top = 16
    Width = 169
    Height = 21
    AutoSelect = False
    TabOrder = 3
  end
end
