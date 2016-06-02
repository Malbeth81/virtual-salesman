object frmDBTool: TfrmDBTool
  Left = 224
  Top = 110
  AutoScroll = False
  Caption = 'Conversion de donn'#233'es'
  ClientHeight = 184
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnConvert: TButton
    Left = 140
    Top = 152
    Width = 81
    Height = 25
    Caption = 'Convertir'
    TabOrder = 4
    OnClick = btnConvertClick
  end
  object edtFileName: TLabeledEdit
    Left = 8
    Top = 120
    Width = 321
    Height = 21
    EditLabel.Width = 202
    EditLabel.Height = 13
    EditLabel.Caption = 'Chemin du fichier de la compagnie (*.vv3) :'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 228
    Top = 152
    Width = 81
    Height = 25
    Caption = 'Quitter'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object btnFileName: TButton
    Left = 332
    Top = 120
    Width = 21
    Height = 21
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnFileNameClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 345
    Height = 89
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 329
      Height = 41
      AutoSize = False
      Caption = 
        #192' cause de plusieurs changements dans les structures de donn'#233'es ' +
        'du Vendeur Virtuel, cette version ne peut lire les fichiers prov' +
        'enant de versions ant'#233'rieures '#224' 3.1.0.'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 329
      Height = 29
      AutoSize = False
      Caption = 
        'Avant de convertir des fichiers assurez vous d'#39'avoir une sauvega' +
        'rde compl'#232'tes des fichiers dans un autre dossier ou sur une disq' +
        'uette !!!'
      WordWrap = True
    end
  end
  object btnBackup: TButton
    Left = 52
    Top = 152
    Width = 81
    Height = 25
    Caption = 'Sauvegarder'
    Default = True
    TabOrder = 3
    OnClick = btnBackupClick
  end
  object OpenDialog: TOpenDialog
    FileName = '*.vv3'
    Filter = 'Fichier compagnie du Vendeur Virtuel 3 (*.vv3)|*.vv3'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoReadOnlyReturn, ofNoDereferenceLinks, ofEnableSizing, ofDontAddToRecent]
    OptionsEx = [ofExNoPlacesBar]
    Left = 8
    Top = 152
  end
end
