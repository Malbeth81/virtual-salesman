object frmEmployee: TfrmEmployee
  Left = 382
  Top = 52
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Employee information'
  ClientHeight = 193
  ClientWidth = 441
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
  object lblNumber2: TLabel
    Left = 184
    Top = 12
    Width = 159
    Height = 13
    Caption = '(Cannot be modified once saved).'
  end
  object lblNumber1: TLabel
    Left = 28
    Top = 12
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = 'Number:'
  end
  object lblName: TLabel
    Left = 37
    Top = 44
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'Name:'
  end
  object lblAddress: TLabel
    Left = 27
    Top = 76
    Width = 41
    Height = 13
    Alignment = taRightJustify
    Caption = 'Address:'
  end
  object lblTelephone: TLabel
    Left = 14
    Top = 108
    Width = 54
    Height = 13
    Alignment = taRightJustify
    Caption = 'Telephone:'
  end
  object lblOther: TLabel
    Left = 39
    Top = 140
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = 'Other:'
  end
  object lblEmail: TLabel
    Left = 197
    Top = 108
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'E-mail:'
  end
  object edtNumber: TEdit
    Left = 72
    Top = 8
    Width = 81
    Height = 21
    AutoSelect = False
    TabOrder = 0
  end
  object edtName: TEdit
    Left = 72
    Top = 40
    Width = 361
    Height = 21
    AutoSelect = False
    TabOrder = 2
  end
  object edtAddress: TEdit
    Left = 72
    Top = 72
    Width = 361
    Height = 21
    AutoSelect = False
    TabOrder = 3
  end
  object edtTelephone: TEdit
    Left = 72
    Top = 104
    Width = 97
    Height = 21
    AutoSelect = False
    TabOrder = 4
  end
  object edtEmail: TEdit
    Left = 232
    Top = 104
    Width = 201
    Height = 21
    AutoSelect = False
    TabOrder = 5
  end
  object edtOther: TEdit
    Left = 72
    Top = 136
    Width = 361
    Height = 21
    AutoSelect = False
    TabOrder = 6
  end
  object btnCancel: TButton
    Left = 376
    Top = 168
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object btnOk: TButton
    Left = 304
    Top = 168
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 7
    OnClick = btnOkClick
  end
  object btnNumber: TButton
    Left = 158
    Top = 9
    Width = 19
    Height = 19
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnNumberClick
  end
end
