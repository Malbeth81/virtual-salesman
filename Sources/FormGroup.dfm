object frmGroup: TfrmGroup
  Left = 384
  Top = 56
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Group information'
  ClientHeight = 97
  ClientWidth = 385
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
  object lblCode2: TLabel
    Left = 144
    Top = 12
    Width = 159
    Height = 13
    Caption = '(Cannot be modified once saved).'
  end
  object lblCode1: TLabel
    Left = 24
    Top = 12
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = 'Code:'
  end
  object lblName: TLabel
    Left = 21
    Top = 44
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'Name:'
  end
  object btnCancel: TButton
    Left = 320
    Top = 72
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object btnOk: TButton
    Left = 248
    Top = 72
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 2
    OnClick = btnOkClick
  end
  object edtCode: TEdit
    Left = 56
    Top = 8
    Width = 81
    Height = 21
    AutoSelect = False
    TabOrder = 0
  end
  object edtName: TEdit
    Left = 56
    Top = 40
    Width = 321
    Height = 21
    AutoSelect = False
    TabOrder = 1
  end
end
