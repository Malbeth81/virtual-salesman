object frmSave: TfrmSave
  Left = 383
  Top = 57
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Saving'
  ClientHeight = 81
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblSave: TLabel
    Left = 0
    Top = 8
    Width = 3
    Height = 13
  end
  object edtSave: TEdit
    Left = 0
    Top = 24
    Width = 257
    Height = 21
    AutoSelect = False
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 120
    Top = 56
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 192
    Top = 56
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
