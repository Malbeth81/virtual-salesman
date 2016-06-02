object frmImport: TfrmImport
  Left = 224
  Top = 54
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Import'
  ClientHeight = 289
  ClientWidth = 425
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
  object lblURL: TLabel
    Left = 368
    Top = 212
    Width = 25
    Height = 13
    Caption = 'URL:'
    Visible = False
  end
  object lblQuantity: TLabel
    Left = 296
    Top = 212
    Width = 42
    Height = 13
    Caption = 'Quantity:'
    Visible = False
  end
  object lblPrice: TLabel
    Left = 224
    Top = 212
    Width = 27
    Height = 13
    Caption = 'Price:'
    Visible = False
  end
  object lblCost: TLabel
    Left = 152
    Top = 212
    Width = 24
    Height = 13
    Caption = 'Cost:'
    Visible = False
  end
  object lblCode: TLabel
    Left = 8
    Top = 212
    Width = 28
    Height = 13
    Caption = 'Code:'
    Visible = False
  end
  object lblSelect: TLabel
    Left = 0
    Top = 192
    Width = 392
    Height = 13
    Caption = 
      'Please select the collumn number for each of the following value' +
      's (select 0 if none):'
  end
  object lblNumber: TLabel
    Left = 8
    Top = 212
    Width = 40
    Height = 13
    Caption = 'Number:'
  end
  object lblName: TLabel
    Left = 80
    Top = 212
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object lblAddress: TLabel
    Left = 152
    Top = 212
    Width = 41
    Height = 13
    Caption = 'Address:'
  end
  object lblTelephone: TLabel
    Left = 224
    Top = 212
    Width = 54
    Height = 13
    Caption = 'Telephone:'
  end
  object lblEmail: TLabel
    Left = 296
    Top = 212
    Width = 31
    Height = 13
    Caption = 'E-mail:'
  end
  object lblOther: TLabel
    Left = 368
    Top = 212
    Width = 29
    Height = 13
    Caption = 'Other:'
  end
  object lblFilename: TLabel
    Left = 25
    Top = 8
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = 'File name:'
  end
  object lblSeparator: TLabel
    Left = 28
    Top = 36
    Width = 77
    Height = 13
    Alignment = taRightJustify
    Caption = 'Value separator:'
  end
  object lblDelimiter: TLabel
    Left = 202
    Top = 36
    Width = 71
    Height = 13
    Alignment = taRightJustify
    Caption = 'Value delimiter:'
  end
  object stgImport: TStringGrid
    Left = 0
    Top = 64
    Width = 425
    Height = 121
    ColCount = 1
    DefaultColWidth = 79
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
    TabOrder = 0
  end
  object cmbValue1: TComboBox
    Left = 8
    Top = 228
    Width = 57
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object cmbValue2: TComboBox
    Left = 80
    Top = 228
    Width = 57
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object cmbValue3: TComboBox
    Left = 152
    Top = 228
    Width = 57
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object cmbValue4: TComboBox
    Left = 224
    Top = 228
    Width = 57
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object cmbValue5: TComboBox
    Left = 296
    Top = 228
    Width = 57
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
  end
  object cmbValue6: TComboBox
    Left = 368
    Top = 228
    Width = 57
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
  end
  object btnOk: TButton
    Left = 288
    Top = 264
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    Enabled = False
    TabOrder = 7
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 360
    Top = 264
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object edtFilename: TEdit
    Left = 80
    Top = 4
    Width = 257
    Height = 21
    TabOrder = 9
  end
  object btnBrowse: TButton
    Left = 344
    Top = 2
    Width = 81
    Height = 25
    Caption = 'Browse'
    TabOrder = 10
    OnClick = btnBrowseClick
  end
  object cmbSeparator: TComboBox
    Left = 112
    Top = 32
    Width = 57
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    MaxLength = 1
    TabOrder = 11
    Text = ','
    Items.Strings = (
      ','
      ';'
      ':'
      'Tab'
      'Space')
  end
  object cmbDelimiter: TComboBox
    Left = 280
    Top = 32
    Width = 57
    Height = 21
    ItemHeight = 13
    ItemIndex = 1
    MaxLength = 1
    TabOrder = 12
    Text = '"'
    Items.Strings = (
      #39
      '"')
  end
  object btnImport: TButton
    Left = 344
    Top = 32
    Width = 81
    Height = 25
    Caption = 'Import'
    TabOrder = 13
    OnClick = btnImportClick
  end
  object dlgImport: TOpenDialog
    DefaultExt = 'csv'
    Filter = 'Comma separated values (*.csv)|*.csv'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 8
    Top = 120
  end
end
