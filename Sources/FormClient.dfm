object frmClient: TfrmClient
  Left = 385
  Top = 51
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Client information'
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
  object pgcClient: TPageControl
    Left = 0
    Top = 0
    Width = 449
    Height = 193
    ActivePage = tbsInfo
    TabOrder = 2
    OnChange = pgcClientChange
    object tbsInfo: TTabSheet
      Caption = 'Information'
      object lblNumber2: TLabel
        Left = 179
        Top = 12
        Width = 159
        Height = 13
        Caption = '(Cannot be modified once saved).'
      end
      object lblNumber1: TLabel
        Left = 27
        Top = 12
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Number:'
      end
      object lblName: TLabel
        Left = 36
        Top = 44
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = 'Name:'
      end
      object lblAddress: TLabel
        Left = 26
        Top = 76
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = 'Address:'
      end
      object lblTelephone: TLabel
        Left = 13
        Top = 108
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = 'Telephone:'
      end
      object lblOther: TLabel
        Left = 38
        Top = 140
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = 'Other:'
      end
      object lblEmail: TLabel
        Left = 196
        Top = 108
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = 'E-mail:'
      end
      object edtOther: TEdit
        Left = 72
        Top = 136
        Width = 361
        Height = 21
        AutoSelect = False
        TabOrder = 0
      end
      object edtTelephone: TEdit
        Left = 72
        Top = 104
        Width = 100
        Height = 21
        AutoSelect = False
        TabOrder = 1
      end
      object edtEmail: TEdit
        Left = 232
        Top = 104
        Width = 201
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
      object edtName: TEdit
        Left = 72
        Top = 40
        Width = 361
        Height = 21
        AutoSelect = False
        TabOrder = 4
      end
      object edtNumber: TEdit
        Left = 72
        Top = 8
        Width = 78
        Height = 21
        AutoSelect = False
        TabOrder = 5
      end
      object btnNumber: TButton
        Left = 155
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
        TabOrder = 6
        OnClick = btnNumberClick
      end
    end
    object tbsTransactions: TTabSheet
      Caption = 'Transactions'
      ImageIndex = 1
      object tabTransType: TTabControl
        Left = 0
        Top = 4
        Width = 244
        Height = 22
        TabOrder = 1
        Tabs.Strings = (
          'Quotes'
          'Orders'
          'Invoices')
        TabIndex = 0
        TabWidth = 80
        OnChange = tabTransTypeChange
      end
      object stgTransactions: TStringGrid
        Left = 0
        Top = 24
        Width = 441
        Height = 141
        ColCount = 7
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
        TabOrder = 0
        ColWidths = (
          44
          103
          158
          64
          64
          64
          176)
      end
      object btnOpenTransaction: TButton
        Left = 360
        Top = 0
        Width = 81
        Height = 21
        Caption = 'Open'
        TabOrder = 2
        OnClick = btnOpenTransactionClick
      end
    end
    object tbsProducts: TTabSheet
      Caption = 'Products purchased'
      ImageIndex = 2
      object stgProducts: TStringGrid
        Left = 0
        Top = 0
        Width = 441
        Height = 165
        Align = alClient
        ColCount = 6
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
        TabOrder = 0
        ColWidths = (
          59
          189
          62
          59
          159
          89)
      end
    end
  end
end
