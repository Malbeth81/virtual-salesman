object frmReports: TfrmReports
  Left = 382
  Top = 54
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Reports'
  ClientHeight = 305
  ClientWidth = 289
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
  object lblReport: TLabel
    Left = 0
    Top = 0
    Width = 27
    Height = 13
    Caption = 'Type:'
  end
  object lblPeriod: TLabel
    Left = 0
    Top = 44
    Width = 33
    Height = 13
    Caption = 'Period:'
  end
  object lblFromDate: TLabel
    Left = 136
    Top = 44
    Width = 50
    Height = 13
    Caption = 'From date:'
  end
  object lblToDate: TLabel
    Left = 216
    Top = 44
    Width = 40
    Height = 13
    Caption = 'To date:'
  end
  object btnClose: TButton
    Left = 208
    Top = 88
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 3
  end
  object stgReport: TStringGrid
    Left = 0
    Top = 120
    Width = 289
    Height = 185
    ColCount = 2
    Ctl3D = True
    DefaultColWidth = 120
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goTabs, goRowSelect, goThumbTracking]
    ParentCtl3D = False
    TabOrder = 2
    ColWidths = (
      181
      81)
  end
  object btnGenerate: TButton
    Left = 0
    Top = 88
    Width = 81
    Height = 25
    Caption = 'Generate'
    TabOrder = 0
    OnClick = btnGenerateClick
  end
  object btnPrint: TButton
    Left = 88
    Top = 88
    Width = 81
    Height = 25
    Caption = 'Print...'
    Enabled = False
    TabOrder = 1
    OnClick = btnPrintClick
  end
  object cmbReport: TComboBox
    Left = 0
    Top = 16
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 4
    Text = 'Sales summary'
    Items.Strings = (
      'Sales summary'
      'Orders summary')
  end
  object cmbPeriod: TComboBox
    Left = 0
    Top = 60
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = cmbPeriodChange
    Items.Strings = (
      'Today'
      'This week'
      'This month'
      'This year')
  end
  object edtFrom: TEdit
    Left = 136
    Top = 60
    Width = 73
    Height = 21
    AutoSelect = False
    TabOrder = 6
  end
  object edtTo: TEdit
    Left = 216
    Top = 60
    Width = 73
    Height = 21
    AutoSelect = False
    TabOrder = 7
  end
end
