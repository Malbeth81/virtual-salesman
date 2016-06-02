object frmOptions: TfrmOptions
  Left = 387
  Top = 53
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Options'
  ClientHeight = 217
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 168
    Top = 192
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 240
    Top = 192
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object pgcOptions: TPageControl
    Left = 0
    Top = 0
    Width = 305
    Height = 185
    ActivePage = tbsGeneral
    TabOrder = 2
    object tbsGeneral: TTabSheet
      Caption = 'General'
      object lblLanguage: TLabel
        Left = 8
        Top = 4
        Width = 51
        Height = 13
        Caption = 'Language:'
      end
      object cmbLanguages: TComboBox
        Left = 8
        Top = 20
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object chkAutoUpdate: TCheckBox
        Left = 8
        Top = 56
        Width = 281
        Height = 17
        Caption = 'Look for new version automaticly on startup.'
        TabOrder = 1
      end
    end
    object tbsPrinting: TTabSheet
      Caption = 'Printing'
      ImageIndex = 3
      object lblMargins: TLabel
        Left = 8
        Top = 4
        Width = 107
        Height = 13
        Caption = 'Margins (in millimeters):'
      end
      object lblMarginTop: TLabel
        Left = 16
        Top = 24
        Width = 22
        Height = 13
        Caption = 'Top:'
      end
      object lblMarginbottom: TLabel
        Left = 88
        Top = 24
        Width = 36
        Height = 13
        Caption = 'Bottom:'
      end
      object lblMarginLeft: TLabel
        Left = 160
        Top = 24
        Width = 21
        Height = 13
        Caption = 'Left:'
      end
      object lblMarginRight: TLabel
        Left = 232
        Top = 24
        Width = 28
        Height = 13
        Caption = 'Right:'
      end
      object lblPrintFont: TLabel
        Left = 8
        Top = 68
        Width = 24
        Height = 13
        Caption = 'Font:'
      end
      object lblFont: TLabel
        Left = 16
        Top = 84
        Width = 265
        Height = 41
        AutoSize = False
        Caption = 'Arial, 8pts.'
      end
      object edtMarginTop: TEdit
        Left = 16
        Top = 40
        Width = 57
        Height = 21
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 0
      end
      object edtMarginBottom: TEdit
        Left = 88
        Top = 40
        Width = 57
        Height = 21
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 1
      end
      object edtMarginLeft: TEdit
        Left = 160
        Top = 40
        Width = 57
        Height = 21
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 2
      end
      object edtMarginRight: TEdit
        Left = 232
        Top = 40
        Width = 57
        Height = 21
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 3
      end
      object btnFont: TButton
        Left = 8
        Top = 128
        Width = 105
        Height = 25
        Caption = 'Change font'
        TabOrder = 4
        OnClick = btnFontClick
      end
    end
    object tbsSaving: TTabSheet
      Caption = 'Saving'
      ImageIndex = 3
      object lblAutoSave1: TLabel
        Left = 38
        Top = 36
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = 'Save every'
      end
      object lblAutoSave2: TLabel
        Left = 149
        Top = 36
        Width = 39
        Height = 13
        Caption = 'minutes.'
      end
      object lblSeparator: TLabel
        Left = 20
        Top = 132
        Width = 77
        Height = 13
        Alignment = taRightJustify
        Caption = 'Value separator:'
      end
      object lblDelimiter: TLabel
        Left = 170
        Top = 132
        Width = 71
        Height = 13
        Alignment = taRightJustify
        Caption = 'Value delimiter:'
      end
      object lblExport: TLabel
        Left = 8
        Top = 108
        Width = 232
        Height = 13
        Caption = 'Export data to csv files using the following format:'
      end
      object chkAutoSave: TCheckBox
        Left = 8
        Top = 8
        Width = 281
        Height = 17
        Caption = 'Enable automatic saving.'
        TabOrder = 0
        OnClick = chkAutoSaveClick
      end
      object edtAutoSave: TEdit
        Left = 96
        Top = 32
        Width = 33
        Height = 21
        AutoSelect = False
        BevelInner = bvNone
        BevelOuter = bvNone
        TabOrder = 1
        Text = '1'
      end
      object udwAutoSave: TUpDown
        Left = 129
        Top = 32
        Width = 15
        Height = 21
        Associate = edtAutoSave
        Min = 1
        Max = 60
        Position = 1
        TabOrder = 2
        Thousands = False
      end
      object chkAskAutoSave: TCheckBox
        Left = 8
        Top = 60
        Width = 281
        Height = 17
        Caption = 'Ask me before automatic saving.'
        TabOrder = 3
      end
      object chkMsgAutoSave: TCheckBox
        Left = 8
        Top = 84
        Width = 281
        Height = 17
        Caption = 'Notify me when automatic saving is complete.'
        TabOrder = 4
      end
      object cmbSeparator: TComboBox
        Left = 104
        Top = 128
        Width = 41
        Height = 21
        ItemHeight = 13
        MaxLength = 1
        TabOrder = 5
        Text = ';'
        Items.Strings = (
          ','
          ';'
          ':')
      end
      object cmbDelimiter: TComboBox
        Left = 248
        Top = 128
        Width = 41
        Height = 21
        ItemHeight = 13
        ItemIndex = 1
        MaxLength = 1
        TabOrder = 6
        Text = '"'
        Items.Strings = (
          #39
          '"')
      end
    end
    object tbsSecurity: TTabSheet
      Caption = 'Security'
      ImageIndex = 5
      object lblUser: TLabel
        Left = 96
        Top = 32
        Width = 30
        Height = 13
        Caption = 'Users:'
      end
      object chkLogin: TCheckBox
        Left = 8
        Top = 8
        Width = 281
        Height = 17
        Caption = 'Enable secure login with username and password.'
        TabOrder = 0
      end
      object btnAddUser: TButton
        Left = 8
        Top = 48
        Width = 81
        Height = 25
        Caption = 'Add'
        TabOrder = 1
        OnClick = btnAddUserClick
      end
      object btnEditUser: TButton
        Left = 8
        Top = 80
        Width = 81
        Height = 25
        Caption = 'Edit'
        TabOrder = 2
        OnClick = btnEditUserClick
      end
      object btnDeleteUser: TButton
        Left = 8
        Top = 112
        Width = 81
        Height = 25
        Caption = 'Delete'
        Enabled = False
        TabOrder = 3
        OnClick = btnDeleteUserClick
      end
      object lstUsers: TListBox
        Left = 96
        Top = 48
        Width = 193
        Height = 101
        AutoComplete = False
        Columns = 2
        ExtendedSelect = False
        ItemHeight = 13
        TabOrder = 4
        OnClick = lstUsersClick
        OnDblClick = btnEditUserClick
      end
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxFontSize = 36
    Options = [fdEffects, fdLimitSize]
    Top = 188
  end
end
