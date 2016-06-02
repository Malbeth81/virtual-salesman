object frmPrint: TfrmPrint
  Left = 258
  Top = 213
  AutoScroll = False
  Caption = 'Print a document'
  ClientHeight = 223
  ClientWidth = 537
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 545
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 537
    Height = 59
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object pnlTopCenter: TPanel
      Left = 0
      Top = 0
      Width = 537
      Height = 59
      BevelOuter = bvNone
      TabOrder = 0
      object lblPrinter: TLabel
        Left = 34
        Top = 8
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Printer:'
      end
      object lblPaper: TLabel
        Left = 37
        Top = 36
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = 'Paper:'
        FocusControl = cmbPaper
      end
      object lblZoom: TLabel
        Left = 394
        Top = 36
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Zoom:'
        FocusControl = cmbZoom
      end
      object lblOrientation: TLabel
        Left = 230
        Top = 36
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = 'Orientation:'
        FocusControl = cmbOrientation
      end
      object lblCopies: TLabel
        Left = 437
        Top = 6
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'Copies:'
      end
      object cmbPaper: TComboBox
        Left = 72
        Top = 32
        Width = 137
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cmbPaperChange
      end
      object cmbPrinter: TComboBox
        Left = 72
        Top = 4
        Width = 241
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnSelect = cmbPrinterSelect
      end
      object btnProperties: TButton
        Left = 320
        Top = 4
        Width = 89
        Height = 21
        Caption = 'Setup...'
        TabOrder = 2
        OnClick = btnPropertiesClick
      end
      object cmbZoom: TComboBox
        Left = 428
        Top = 32
        Width = 105
        Height = 21
        AutoComplete = False
        ItemHeight = 13
        TabOrder = 3
        Text = '100%'
        OnChange = cmbZoomChange
        OnSelect = cmbZoomSelect
        Items.Strings = (
          '50%'
          '100%'
          '150%'
          '200%'
          'Full width'
          'Full height'
          'Full page')
      end
      object cmbOrientation: TComboBox
        Left = 288
        Top = 32
        Width = 81
        Height = 21
        AutoComplete = False
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
        OnSelect = cmbOrientationSelect
        Items.Strings = (
          'Portrait'
          'Landscape')
      end
      object edtCopies: TEdit
        Left = 476
        Top = 4
        Width = 41
        Height = 21
        TabOrder = 5
        Text = '1'
      end
      object updCopies: TUpDown
        Left = 517
        Top = 4
        Width = 15
        Height = 21
        Associate = edtCopies
        Min = 1
        Position = 1
        TabOrder = 6
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 188
    Width = 537
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnPrint: TButton
      Left = 396
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Print'
      Default = True
      Enabled = False
      TabOrder = 0
      OnClick = btnPrintClick
    end
    object btnCancel: TButton
      Left = 468
      Top = 6
      Width = 65
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object cmbPage: TComboBox
      Left = 4
      Top = 6
      Width = 105
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 2
      Text = 'Page 1/1'
      OnChange = cmbPageChange
      Items.Strings = (
        'Page 1/1')
    end
  end
  object PrintPreview: TPrintPreview
    Left = 0
    Top = 59
    Width = 537
    Height = 129
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    TabOrder = 2
    Units = mmLoMetric
    PaperType = pLetter
    ZoomState = zsZoomOther
    ZoomSavePos = False
    OnBeginDoc = PrintPreviewBeginDoc
    OnEndDoc = PrintPreviewEndDoc
    OnBeforePrint = PrintPreviewBeforePrint
    OnAfterPrint = PrintPreviewAfterPrint
    OnZoomChange = PrintPreviewZoomChange
  end
  object PrinterSetupDialog: TPrinterSetupDialog
  end
end
