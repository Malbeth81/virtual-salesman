object frmSelection: TfrmSelection
  Left = 382
  Top = 55
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Select a product'
  ClientHeight = 197
  ClientWidth = 513
  Color = clBtnFace
  Constraints.MinHeight = 224
  Constraints.MinWidth = 521
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object splSelection: TSplitter
    Left = 145
    Top = 33
    Width = 2
    Height = 129
    MinSize = 4
  end
  object stgGroups: TStringGrid
    Left = 0
    Top = 33
    Width = 145
    Height = 129
    Align = alLeft
    ColCount = 2
    DefaultColWidth = 60
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goTabs, goRowSelect, goThumbTracking]
    TabOrder = 0
    OnClick = stgGroupsClick
    ColWidths = (
      45
      94)
  end
  object stgProducts: TStringGrid
    Left = 147
    Top = 33
    Width = 366
    Height = 129
    Align = alClient
    DefaultColWidth = 60
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goTabs, goRowSelect, goThumbTracking]
    TabOrder = 1
    OnDblClick = btnOkClick
    ColWidths = (
      60
      157
      60
      50
      40)
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 162
    Width = 513
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    OnResize = pnlBottomResize
    object lblComment: TLabel
      Left = 126
      Top = 10
      Width = 47
      Height = 14
      Alignment = taRightJustify
      Caption = 'Comment:'
    end
    object lblQuantity: TLabel
      Left = 11
      Top = 10
      Width = 43
      Height = 14
      Alignment = taRightJustify
      Caption = 'Quantity:'
    end
    object edtComments: TEdit
      Left = 176
      Top = 6
      Width = 185
      Height = 22
      AutoSelect = False
      TabOrder = 0
    end
    object btnOk: TButton
      Left = 372
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Ok'
      Default = True
      Enabled = False
      TabOrder = 1
      OnClick = btnOkClick
    end
    object btnCancel: TButton
      Left = 444
      Top = 6
      Width = 65
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object edtQuantity: TEdit
      Left = 56
      Top = 6
      Width = 29
      Height = 22
      AutoSelect = False
      TabOrder = 3
      Text = '1'
    end
    object udwQuantity: TUpDown
      Left = 85
      Top = 6
      Width = 15
      Height = 22
      Associate = edtQuantity
      Min = -999
      Max = 999
      Position = 1
      TabOrder = 4
      Thousands = False
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 513
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object lblInventory: TLabel
      Left = 21
      Top = 8
      Width = 48
      Height = 14
      Alignment = taRightJustify
      Caption = 'Inventory:'
    end
    object cmbInventories: TComboBox
      Left = 72
      Top = 4
      Width = 201
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 0
      OnChange = cmbInventoriesChange
    end
    object chkTextOnly: TCheckBox
      Left = 280
      Top = 6
      Width = 233
      Height = 17
      Caption = 'Descriptive product (text only).'
      TabOrder = 1
    end
  end
end
