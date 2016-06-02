object frmProduct: TfrmProduct
  Left = 378
  Top = 52
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Product information'
  ClientHeight = 225
  ClientWidth = 449
  Color = clBtnFace
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
  object btnCancel: TButton
    Left = 384
    Top = 200
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 312
    Top = 200
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 0
    OnClick = btnOkClick
  end
  object pgcProduct: TPageControl
    Left = 0
    Top = 0
    Width = 449
    Height = 193
    ActivePage = tbsProduct
    TabOrder = 2
    OnChange = pgcProductChange
    object tbsProduct: TTabSheet
      Caption = 'Information'
      ImageIndex = 1
      object lblPercent: TLabel
        Left = 237
        Top = 76
        Width = 8
        Height = 13
        Caption = '%'
      end
      object lblCode2: TLabel
        Left = 184
        Top = 12
        Width = 159
        Height = 13
        Caption = '(Cannot be modified once saved).'
      end
      object lblCode1: TLabel
        Left = 40
        Top = 12
        Width = 28
        Height = 13
        Alignment = taRightJustify
        Caption = 'Code:'
      end
      object lblName: TLabel
        Left = 37
        Top = 44
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = 'Name:'
      end
      object lblCost: TLabel
        Left = 44
        Top = 76
        Width = 24
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cost:'
      end
      object lblQuantity: TLabel
        Left = 26
        Top = 108
        Width = 42
        Height = 13
        Alignment = taRightJustify
        Caption = 'Quantity:'
      end
      object lblURL: TLabel
        Left = 43
        Top = 140
        Width = 25
        Height = 13
        Alignment = taRightJustify
        Caption = 'URL:'
      end
      object lblPlus: TLabel
        Left = 170
        Top = 76
        Width = 6
        Height = 13
        Alignment = taRightJustify
        Caption = '+'
      end
      object lblPrice: TLabel
        Left = 313
        Top = 76
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Price:'
      end
      object edtPercent: TEdit
        Left = 184
        Top = 72
        Width = 49
        Height = 21
        AutoSelect = False
        TabOrder = 0
      end
      object edtCost: TEdit
        Left = 72
        Top = 72
        Width = 89
        Height = 21
        AutoSelect = False
        TabOrder = 1
      end
      object edtQuantity: TEdit
        Left = 72
        Top = 104
        Width = 89
        Height = 21
        AutoSelect = False
        TabOrder = 2
      end
      object edtWeb: TEdit
        Left = 72
        Top = 136
        Width = 361
        Height = 21
        AutoSelect = False
        TabOrder = 3
      end
      object chkTaxed: TCheckBox
        Left = 184
        Top = 106
        Width = 249
        Height = 17
        Caption = 'Apply taxes when selling this product.'
        Checked = True
        Ctl3D = True
        ParentCtl3D = False
        State = cbChecked
        TabOrder = 4
      end
      object btnPrice: TButton
        Left = 256
        Top = 73
        Width = 19
        Height = 19
        Caption = '='
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'System'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnClick = btnPriceClick
      end
      object edtPrice: TEdit
        Left = 344
        Top = 72
        Width = 89
        Height = 21
        AutoSelect = False
        TabOrder = 6
      end
      object edtName: TEdit
        Left = 72
        Top = 40
        Width = 361
        Height = 21
        AutoSelect = False
        TabOrder = 7
      end
      object btnCode: TButton
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
        TabOrder = 8
        OnClick = btnCodeClick
      end
      object edtCode: TEdit
        Left = 72
        Top = 8
        Width = 81
        Height = 21
        AutoSelect = False
        TabOrder = 9
      end
    end
    object tbsSuppliers: TTabSheet
      Caption = 'Suppliers'
      object stgSuppliers: TStringGrid
        Left = 0
        Top = 0
        Width = 441
        Height = 141
        ColCount = 6
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect, goThumbTracking]
        TabOrder = 0
        ColWidths = (
          72
          147
          164
          110
          109
          169)
      end
      object btnAdd: TButton
        Left = 0
        Top = 144
        Width = 81
        Height = 21
        Caption = 'Add'
        TabOrder = 1
        OnClick = btnAddClick
      end
      object btnRemove: TButton
        Left = 88
        Top = 144
        Width = 81
        Height = 21
        Caption = 'Delete'
        TabOrder = 2
        OnClick = btnRemoveClick
      end
    end
  end
end
