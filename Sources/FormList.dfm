object frmList: TfrmList
  Left = 459
  Top = 84
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  BorderWidth = 8
  Caption = 'Select'
  ClientHeight = 185
  ClientWidth = 449
  Color = clBtnFace
  Constraints.MinHeight = 228
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object stgList: TStringGrid
    Left = 0
    Top = 0
    Width = 449
    Height = 154
    Align = alClient
    ColCount = 6
    DefaultColWidth = 100
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goTabs, goRowSelect, goThumbTracking]
    TabOrder = 0
    OnDblClick = stgListDblClick
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
    Top = 154
    Width = 449
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = pnlBottomResize
    object btnCancel: TButton
      Left = 384
      Top = 6
      Width = 65
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnOk: TButton
      Left = 312
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Ok'
      Default = True
      TabOrder = 1
      OnClick = btnOkClick
    end
    object btnNew: TButton
      Left = 0
      Top = 6
      Width = 81
      Height = 25
      Caption = 'Add new'
      TabOrder = 2
      OnClick = btnNewClick
    end
    object btnFind: TButton
      Left = 88
      Top = 6
      Width = 81
      Height = 25
      Caption = 'Find'
      TabOrder = 3
      OnClick = btnFindClick
    end
  end
end
