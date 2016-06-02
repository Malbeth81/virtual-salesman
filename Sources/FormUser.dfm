object frmUser: TfrmUser
  Left = 385
  Top = 56
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'User information'
  ClientHeight = 177
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblRights: TLabel
    Left = 0
    Top = 48
    Width = 33
    Height = 13
    Caption = 'Rights:'
  end
  object lblUsername: TLabel
    Left = 0
    Top = 0
    Width = 51
    Height = 13
    Caption = 'Username:'
  end
  object lblPassword: TLabel
    Left = 168
    Top = 0
    Width = 49
    Height = 13
    Caption = 'Password:'
  end
  object chlRights: TCheckListBox
    Left = 0
    Top = 64
    Width = 274
    Height = 81
    Columns = 3
    HeaderColor = clHotLight
    HeaderBackgroundColor = clBtnFace
    ItemHeight = 13
    Items.Strings = (
      'Inventories'
      'Add'
      'Open'
      'Delete'
      'Employees'
      'Add'
      'Edit'
      'Delete'
      'Clients'
      'Add'
      'Edit'
      'Delete'
      'Suppliers'
      'Add'
      'Edit'
      'Delete'
      'Transactions'
      'Add'
      'Open'
      'Delete'
      'Groups'
      'Add'
      'Edit'
      'Delete'
      'Products'
      'Add'
      'Edit'
      'Delete'
      'Users'
      'Add'
      'Edit'
      'Delete'
      'Company'
      'Edit')
    TabOrder = 3
  end
  object edtUsername: TEdit
    Left = 0
    Top = 16
    Width = 161
    Height = 21
    TabOrder = 0
  end
  object edtPassword: TEdit
    Left = 168
    Top = 16
    Width = 106
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 137
    Top = 152
    Width = 65
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 4
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 209
    Top = 152
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object chkHidePassword: TCheckBox
    Left = 168
    Top = 38
    Width = 97
    Height = 17
    Caption = 'Hide'
    Checked = True
    Ctl3D = True
    ParentCtl3D = False
    State = cbChecked
    TabOrder = 2
    OnClick = chkHidePasswordClick
  end
end
