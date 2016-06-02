object frmPassword: TfrmPassword
  Left = 252
  Top = 112
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Mot de passe'
  ClientHeight = 104
  ClientWidth = 200
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object edtPassword: TLabeledEdit
    Left = 88
    Top = 36
    Width = 105
    Height = 22
    AutoSelect = False
    BevelKind = bkFlat
    BorderStyle = bsNone
    EditLabel.Width = 71
    EditLabel.Height = 14
    EditLabel.Caption = 'Mot de passe :'
    LabelPosition = lpLeft
    LabelSpacing = 5
    PasswordChar = '*'
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 56
    Top = 72
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 128
    Top = 72
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object edtUsername: TLabeledEdit
    Left = 88
    Top = 8
    Width = 105
    Height = 22
    AutoSelect = False
    BevelKind = bkFlat
    BorderStyle = bsNone
    EditLabel.Width = 68
    EditLabel.Height = 14
    EditLabel.Caption = 'Nom d'#39'usag'#233' :'
    LabelPosition = lpLeft
    LabelSpacing = 5
    PasswordChar = '*'
    TabOrder = 3
    OnChange = edtUsernameChange
  end
end
