object frmFind: TfrmFind
  Left = 385
  Top = 53
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Find'
  ClientHeight = 81
  ClientWidth = 265
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 14
  object lblFind: TLabel
    Left = 0
    Top = 8
    Width = 172
    Height = 14
    Caption = 'Enter the text you would like to find:'
  end
  object edtFind: TEdit
    Left = 0
    Top = 24
    Width = 265
    Height = 22
    AutoSelect = False
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 128
    Top = 56
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 200
    Top = 56
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
