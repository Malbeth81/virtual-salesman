object frmOpen: TfrmOpen
  Left = 383
  Top = 55
  Width = 380
  Height = 203
  BorderIcons = [biSystemMenu]
  Caption = 'Open a company'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 380
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object stgOpen: TStringGrid
    Left = 0
    Top = 0
    Width = 372
    Height = 139
    Align = alClient
    ColCount = 3
    Ctl3D = True
    DefaultColWidth = 120
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goTabs, goRowSelect, goThumbTracking]
    ParentCtl3D = False
    TabOrder = 0
    OnDblClick = stgOpenDblClick
    OnDrawCell = stgOpenDrawCell
    ColWidths = (
      172
      77
      108)
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 139
    Width = 372
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = pnlBottomResize
    object btnOk: TButton
      Left = 231
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Ok'
      Default = True
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btnCancel: TButton
      Left = 303
      Top = 6
      Width = 65
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
