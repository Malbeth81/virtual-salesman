object frmCompany: TfrmCompany
  Left = 385
  Top = 51
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Company information'
  ClientHeight = 321
  ClientWidth = 377
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
  object pgcCompany: TPageControl
    Left = 0
    Top = 0
    Width = 377
    Height = 289
    ActivePage = tbsGeneral
    HotTrack = True
    TabOrder = 0
    object tbsGeneral: TTabSheet
      Caption = 'General'
      object lblCompanyInfo: TLabel
        Left = 8
        Top = 152
        Width = 210
        Height = 13
        Caption = 'Information about the company (5 lines only):'
      end
      object lblLogo: TLabel
        Left = 24
        Top = 40
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Logo:'
      end
      object lblName: TLabel
        Left = 20
        Top = 12
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = 'Name:'
      end
      object memCompanyInfo: TMemo
        Left = 8
        Top = 168
        Width = 353
        Height = 81
        Ctl3D = True
        ParentCtl3D = False
        ScrollBars = ssVertical
        TabOrder = 3
        WordWrap = False
      end
      object edtCompanyName: TEdit
        Left = 56
        Top = 8
        Width = 305
        Height = 21
        AutoSelect = False
        TabOrder = 0
      end
      object pnlLogo: TPanel
        Left = 56
        Top = 40
        Width = 105
        Height = 105
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Color = clWhite
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 1
        object imgLogo: TImage
          Left = 2
          Top = 2
          Width = 101
          Height = 101
          Align = alClient
          Center = True
          Proportional = True
          Stretch = True
        end
      end
      object btnLoadLogo: TButton
        Left = 168
        Top = 40
        Width = 75
        Height = 25
        Caption = 'Change'
        TabOrder = 2
        OnClick = btnLoadLogoClick
      end
      object btnDeleteLogo: TButton
        Left = 168
        Top = 72
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 4
        OnClick = btnDeleteLogoClick
      end
    end
    object tbsConfiguration: TTabSheet
      Caption = 'Configuration'
      ImageIndex = 1
      object grpTaxes: TGroupBox
        Left = 8
        Top = 8
        Width = 353
        Height = 101
        Caption = ' Taxes '
        TabOrder = 0
        object lblTaxName: TLabel
          Left = 88
          Top = 16
          Width = 28
          Height = 13
          Caption = 'Name'
        end
        object lblTaxRate: TLabel
          Left = 152
          Top = 16
          Width = 23
          Height = 13
          Caption = 'Rate'
        end
        object lblTaxNumber: TLabel
          Left = 208
          Top = 16
          Width = 94
          Height = 13
          Caption = 'Registration number'
        end
        object lblFederal1: TLabel
          Left = 46
          Top = 36
          Width = 38
          Height = 13
          Alignment = taRightJustify
          Caption = 'Federal:'
        end
        object lblState1: TLabel
          Left = 56
          Top = 72
          Width = 28
          Height = 13
          Alignment = taRightJustify
          Caption = 'State:'
          Enabled = False
        end
        object lblFederal2: TLabel
          Left = 189
          Top = 36
          Width = 8
          Height = 13
          Caption = '%'
        end
        object lblState2: TLabel
          Left = 189
          Top = 72
          Width = 8
          Height = 13
          Caption = '%'
          Enabled = False
        end
        object chkStateTax: TCheckBox
          Left = 7
          Top = 71
          Width = 15
          Height = 15
          TabOrder = 3
          OnClick = chkStateTaxClick
        end
        object edtFederalTaxValue: TEdit
          Left = 152
          Top = 32
          Width = 33
          Height = 21
          AutoSelect = False
          TabOrder = 1
        end
        object edtStateTaxValue: TEdit
          Left = 152
          Top = 68
          Width = 33
          Height = 21
          AutoSelect = False
          TabOrder = 5
        end
        object edtFederalTaxName: TEdit
          Left = 88
          Top = 32
          Width = 49
          Height = 21
          AutoSelect = False
          TabOrder = 0
        end
        object edtFederalTaxNumber: TEdit
          Left = 208
          Top = 32
          Width = 137
          Height = 21
          AutoSelect = False
          TabOrder = 2
        end
        object edtStateTaxNumber: TEdit
          Left = 208
          Top = 68
          Width = 137
          Height = 21
          AutoSelect = False
          TabOrder = 6
        end
        object edtStateTaxName: TEdit
          Left = 88
          Top = 68
          Width = 49
          Height = 21
          AutoSelect = False
          TabOrder = 4
        end
      end
      object grpDeposit: TGroupBox
        Left = 8
        Top = 160
        Width = 353
        Height = 45
        Caption = ' Orders '
        TabOrder = 1
        object lblDeposit2: TLabel
          Left = 269
          Top = 20
          Width = 64
          Height = 13
          Caption = '% of the total.'
        end
        object lblDeposit1: TLabel
          Left = 42
          Top = 20
          Width = 186
          Height = 13
          Alignment = taRightJustify
          Caption = 'In an order, the deposit must be at least'
        end
        object edtDeposit: TEdit
          Left = 232
          Top = 16
          Width = 33
          Height = 21
          AutoSelect = False
          TabOrder = 0
        end
      end
      object grpCurrency: TGroupBox
        Left = 8
        Top = 112
        Width = 353
        Height = 45
        Caption = ' Currency '
        TabOrder = 2
        object lblCurrency: TLabel
          Left = 63
          Top = 20
          Width = 165
          Height = 13
          Alignment = taRightJustify
          Caption = 'Use the following monetary symbol:'
        end
        object edtCurrencySign: TEdit
          Left = 232
          Top = 16
          Width = 33
          Height = 21
          AutoSelect = False
          TabOrder = 0
        end
      end
      object grpInvoices: TGroupBox
        Left = 8
        Top = 208
        Width = 353
        Height = 45
        Caption = ' Invoices '
        TabOrder = 3
        object chkUnlockInvoices: TCheckBox
          Left = 8
          Top = 20
          Width = 337
          Height = 17
          Caption = 'Allow the content of a saved invoice to be modified.'
          TabOrder = 0
        end
      end
    end
    object tbsMessages: TTabSheet
      Caption = 'Messages'
      ImageIndex = 2
      object lblQuotation: TLabel
        Left = 8
        Top = 8
        Width = 284
        Height = 13
        Caption = 'Text to display in the bottom of every quotation (4 lines only):'
      end
      object lblOrder: TLabel
        Left = 8
        Top = 92
        Width = 264
        Height = 13
        Caption = 'Text to display in the bottom of every order (4 lines only):'
      end
      object lblInvoice: TLabel
        Left = 8
        Top = 176
        Width = 277
        Height = 13
        Caption = 'Text to display in the bottom of every invoice (4 lines only) :'
      end
      object memQuotationMessage: TMemo
        Left = 8
        Top = 24
        Width = 353
        Height = 57
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
      end
      object memOrderMessage: TMemo
        Left = 8
        Top = 108
        Width = 353
        Height = 57
        ScrollBars = ssVertical
        TabOrder = 1
        WordWrap = False
      end
      object memInvoiceMessage: TMemo
        Left = 8
        Top = 192
        Width = 353
        Height = 57
        ScrollBars = ssVertical
        TabOrder = 2
        WordWrap = False
      end
    end
  end
  object btnOk: TButton
    Left = 240
    Top = 296
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 312
    Top = 296
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    FilterIndex = 0
    Options = [ofReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Top = 292
  end
end
