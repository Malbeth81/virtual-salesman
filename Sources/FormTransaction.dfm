object frmTransaction: TfrmTransaction
  Left = 321
  Top = 77
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Transaction properties'
  ClientHeight = 217
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 328
    Top = 192
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnOk: TButton
    Left = 256
    Top = 192
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object pgcTransaction: TPageControl
    Left = 0
    Top = 0
    Width = 393
    Height = 185
    ActivePage = tbsPayment
    TabOrder = 0
    object tbsGeneral: TTabSheet
      Caption = 'General'
      object lblSalesman: TLabel
        Left = 11
        Top = 11
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'Salesman:'
      end
      object lblTransType: TLabel
        Left = 33
        Top = 43
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Type:'
      end
      object lblDate: TLabel
        Left = 34
        Top = 83
        Width = 26
        Height = 13
        Alignment = taRightJustify
        Caption = 'Date:'
      end
      object lblQuotationNumber: TLabel
        Left = 8
        Top = 112
        Width = 87
        Height = 13
        Caption = 'Quotation number:'
      end
      object lblOrderNumber: TLabel
        Left = 144
        Top = 112
        Width = 67
        Height = 13
        Caption = 'Order number:'
      end
      object lblInvoiceNumber: TLabel
        Left = 280
        Top = 112
        Width = 76
        Height = 13
        Caption = 'Invoice number:'
      end
      object cmbFormType: TComboBox
        Left = 64
        Top = 40
        Width = 105
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cmbFormTypeChange
        Items.Strings = (
          'Quotation'
          'Order'
          'Invoice')
      end
      object edtDate: TEdit
        Left = 64
        Top = 80
        Width = 81
        Height = 21
        TabOrder = 1
      end
      object btnDate: TButton
        Left = 152
        Top = 81
        Width = 19
        Height = 19
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'System'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = btnDateClick
      end
      object pnlDescType: TPanel
        Left = 176
        Top = 40
        Width = 201
        Height = 65
        BevelOuter = bvLowered
        ParentColor = True
        TabOrder = 3
        object lblDescType: TLabel
          Left = 3
          Top = 3
          Width = 195
          Height = 59
          AutoSize = False
          Transparent = True
          WordWrap = True
        end
      end
      object edtQuotationNumber: TEdit
        Left = 8
        Top = 128
        Width = 97
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
      object edtOrderNumber: TEdit
        Left = 144
        Top = 128
        Width = 97
        Height = 21
        ReadOnly = True
        TabOrder = 5
      end
      object edtInvoiceNumber: TEdit
        Left = 280
        Top = 128
        Width = 97
        Height = 21
        ReadOnly = True
        TabOrder = 6
      end
      object edtSalesmanName: TEdit
        Left = 128
        Top = 8
        Width = 161
        Height = 21
        ReadOnly = True
        TabOrder = 7
      end
      object btnSalesman: TButton
        Left = 296
        Top = 8
        Width = 81
        Height = 21
        Caption = 'Select'
        TabOrder = 8
        OnClick = btnSalesmanClick
      end
      object edtSalesmanNumber: TEdit
        Left = 64
        Top = 8
        Width = 57
        Height = 21
        ReadOnly = True
        TabOrder = 9
      end
    end
    object tbsClient: TTabSheet
      Caption = 'Client'
      ImageIndex = 1
      object lblClient: TLabel
        Left = 24
        Top = 8
        Width = 70
        Height = 13
        Caption = 'Select a client:'
      end
      object lblClientNumber: TLabel
        Left = 27
        Top = 36
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Number:'
      end
      object lblClientName: TLabel
        Left = 36
        Top = 68
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = 'Name:'
      end
      object lblClientAddress: TLabel
        Left = 26
        Top = 100
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = 'Address:'
      end
      object lblClientTelephone: TLabel
        Left = 13
        Top = 132
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = 'Telephone:'
      end
      object lblClientEmail: TLabel
        Left = 196
        Top = 132
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = 'E-mail:'
      end
      object edtClientNumber: TEdit
        Left = 72
        Top = 32
        Width = 81
        Height = 21
        AutoSelect = False
        ReadOnly = True
        TabOrder = 0
      end
      object edtClientName: TEdit
        Left = 72
        Top = 64
        Width = 305
        Height = 21
        AutoSelect = False
        ReadOnly = True
        TabOrder = 1
      end
      object edtClientAddress: TEdit
        Left = 72
        Top = 96
        Width = 305
        Height = 21
        AutoSelect = False
        ReadOnly = True
        TabOrder = 2
      end
      object edtClientTelephone: TEdit
        Left = 72
        Top = 128
        Width = 97
        Height = 21
        AutoSelect = False
        ReadOnly = True
        TabOrder = 3
      end
      object edtClientEmail: TEdit
        Left = 232
        Top = 128
        Width = 145
        Height = 21
        AutoSelect = False
        ReadOnly = True
        TabOrder = 4
      end
      object btnSelectClient: TButton
        Left = 160
        Top = 32
        Width = 81
        Height = 21
        Caption = 'Select'
        TabOrder = 5
        OnClick = btnSelectClientClick
      end
    end
    object tbsRecipient: TTabSheet
      Caption = 'Recipient'
      ImageIndex = 4
      object lblRecipientNumber: TLabel
        Left = 27
        Top = 36
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Number:'
        Enabled = False
      end
      object lblRecipientName: TLabel
        Left = 36
        Top = 68
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = 'Name:'
        Enabled = False
      end
      object lblRecipientAddress: TLabel
        Left = 26
        Top = 100
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = 'Address:'
        Enabled = False
      end
      object lblRecipientTelephone: TLabel
        Left = 13
        Top = 132
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = 'Telephone:'
        Enabled = False
      end
      object lblRecipientEmail: TLabel
        Left = 196
        Top = 132
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = 'E-mail:'
        Enabled = False
      end
      object chkRecipient: TCheckBox
        Left = 6
        Top = 7
        Width = 163
        Height = 17
        Caption = 'Specify a recipient:'
        TabOrder = 0
        OnClick = chkRecipientClick
      end
      object edtRecipientNumber: TEdit
        Left = 72
        Top = 32
        Width = 81
        Height = 21
        AutoSelect = False
        Enabled = False
        TabOrder = 1
      end
      object edtRecipientName: TEdit
        Left = 72
        Top = 64
        Width = 305
        Height = 21
        AutoSelect = False
        Enabled = False
        TabOrder = 2
      end
      object edtRecipientAddress: TEdit
        Left = 72
        Top = 96
        Width = 305
        Height = 21
        AutoSelect = False
        Enabled = False
        TabOrder = 3
      end
      object edtRecipientTelephone: TEdit
        Left = 72
        Top = 128
        Width = 97
        Height = 21
        AutoSelect = False
        Enabled = False
        TabOrder = 4
      end
      object edtRecipientEmail: TEdit
        Left = 232
        Top = 128
        Width = 145
        Height = 21
        AutoSelect = False
        Enabled = False
        TabOrder = 5
      end
      object btnSelectRecipient: TButton
        Left = 160
        Top = 32
        Width = 81
        Height = 21
        Caption = 'Select'
        Enabled = False
        TabOrder = 6
        OnClick = btnSelectRecipientClick
      end
    end
    object tbsPayment: TTabSheet
      Caption = 'Payment'
      ImageIndex = 2
      object lblPlus: TLabel
        Left = 98
        Top = 28
        Width = 6
        Height = 13
        Caption = '+'
      end
      object lblMulti: TLabel
        Left = 202
        Top = 28
        Width = 5
        Height = 13
        Caption = 'x'
      end
      object lblPercent: TLabel
        Left = 254
        Top = 28
        Width = 8
        Height = 13
        Caption = '%'
      end
      object lblEquation: TLabel
        Left = 161
        Top = 75
        Width = 104
        Height = 13
        Alignment = taRightJustify
        Caption = 'Total + Fees - Deposit'
      end
      object lblPaymentType: TLabel
        Left = 9
        Top = 111
        Width = 82
        Height = 13
        Caption = 'Payment method:'
      end
      object lblTotal: TLabel
        Left = 9
        Top = 7
        Width = 27
        Height = 13
        Caption = 'Total:'
      end
      object lblFees: TLabel
        Left = 113
        Top = 7
        Width = 26
        Height = 13
        Caption = 'Fees:'
      end
      object lblDeposit: TLabel
        Left = 297
        Top = 7
        Width = 39
        Height = 13
        Caption = 'Deposit:'
      end
      object lblBalance: TLabel
        Left = 297
        Top = 55
        Width = 42
        Height = 13
        Caption = 'Balance:'
      end
      object lblCreditNumber: TLabel
        Left = 121
        Top = 111
        Width = 92
        Height = 13
        Caption = 'Credit card number:'
        Enabled = False
      end
      object lblCreditExpiration: TLabel
        Left = 281
        Top = 111
        Width = 73
        Height = 13
        Caption = 'Expiration date:'
        Enabled = False
      end
      object edtTotal: TEdit
        Left = 8
        Top = 24
        Width = 81
        Height = 21
        AutoSelect = False
        ReadOnly = True
        TabOrder = 0
        OnChange = btnDepositClick
      end
      object edtFees: TEdit
        Left = 112
        Top = 24
        Width = 81
        Height = 21
        AutoSelect = False
        TabOrder = 1
        OnChange = btnDepositClick
      end
      object edtDepositValue: TEdit
        Left = 216
        Top = 24
        Width = 33
        Height = 21
        AutoSelect = False
        ReadOnly = True
        TabOrder = 2
        OnChange = btnDepositClick
      end
      object btnDeposit: TButton
        Left = 272
        Top = 25
        Width = 19
        Height = 19
        Caption = '='
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = btnDepositClick
      end
      object edtDeposit: TEdit
        Left = 296
        Top = 24
        Width = 81
        Height = 21
        AutoSelect = False
        TabOrder = 4
        OnChange = btnTotalClick
      end
      object edtBalance: TEdit
        Left = 296
        Top = 72
        Width = 81
        Height = 21
        AutoSelect = False
        ReadOnly = True
        TabOrder = 5
      end
      object btnTotal: TButton
        Left = 272
        Top = 73
        Width = 19
        Height = 19
        Caption = '='
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = btnTotalClick
      end
      object cmbPaymentType: TComboBox
        Left = 8
        Top = 128
        Width = 105
        Height = 21
        Style = csDropDownList
        Enabled = False
        ItemHeight = 13
        TabOrder = 7
        OnChange = cmbPaymentTypeChange
        Items.Strings = (
          'Cash'
          'Debit'
          'Credit')
      end
      object edtCreditNumber: TEdit
        Left = 120
        Top = 128
        Width = 153
        Height = 21
        AutoSelect = False
        Enabled = False
        TabOrder = 8
      end
      object edtCreditExpiration: TEdit
        Left = 280
        Top = 128
        Width = 97
        Height = 21
        AutoSelect = False
        Enabled = False
        TabOrder = 9
      end
    end
    object tbsComments: TTabSheet
      Caption = 'Comments'
      ImageIndex = 3
      object memComments: TMemo
        Left = 0
        Top = 0
        Width = 385
        Height = 157
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
      end
    end
  end
end
