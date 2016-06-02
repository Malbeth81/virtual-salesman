object frmSelect: TfrmSelect
  Left = 382
  Top = 55
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Select'
  ClientHeight = 197
  ClientWidth = 465
  Color = clBtnFace
  Constraints.MinHeight = 224
  Constraints.MinWidth = 473
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object stgSelect: TStringGrid
    Left = 0
    Top = 0
    Width = 465
    Height = 162
    Align = alClient
    ColCount = 6
    DefaultColWidth = 100
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goTabs, goRowSelect, goThumbTracking]
    TabOrder = 0
    OnDblClick = stgSelectDblClick
    ColWidths = (
      60
      100
      150
      100
      100
      150)
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 162
    Width = 465
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = pnlBottomResize
    object btnCancel: TButton
      Left = 396
      Top = 6
      Width = 65
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOk: TButton
      Left = 324
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Ok'
      Default = True
      TabOrder = 1
      OnClick = btnOkClick
    end
    object btnNew: TButton
      Left = 4
      Top = 6
      Width = 81
      Height = 25
      Caption = 'Add new'
      TabOrder = 2
      OnClick = btnNewClick
    end
    object btnFind: TButton
      Left = 92
      Top = 6
      Width = 81
      Height = 25
      Caption = 'Find'
      TabOrder = 3
      OnClick = btnFindClick
    end
  end
end
