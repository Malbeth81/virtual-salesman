(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst, UnitMessages, UnitUsers;

type                  
  TMode = (mAdd, mEdit);
  TfrmUser = class(TForm)
    chlRights: TCheckListBox;
    lblRights: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    chkHidePassword: TCheckBox;
    lblUsername: TLabel;
    lblPassword: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure DisplayRights(Rights : TRights);
    function GetRights : TRights;
    procedure chkHidePasswordClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);   
  public
    function Show(Mode : TMode) : Boolean; reintroduce;
  private
    Mode : TMode;
  end;

var
  frmUser: TfrmUser;

implementation

uses FormMain, FormOptions;

{$R *.dfm}

procedure TfrmUser.FormCreate(Sender: TObject);
begin
  chlRights.Header[0] := True;
  chlRights.Header[4] := True;
  chlRights.Header[8] := True;
  chlRights.Header[12] := True;
  chlRights.Header[16] := True;
  chlRights.Header[20] := True;
  chlRights.Header[24] := True;
  chlRights.Header[28] := True; 
  chlRights.Header[32] := True;
end;

procedure TfrmUser.FormShow(Sender: TObject);
var
  User : PUser;
begin
  if Mode = mAdd then
  begin
    lblUsername.Enabled := True;
    edtUsername.Enabled := True;
    chlRights.Enabled := True;
    edtPassword.Text := '';
    edtUsername.Text := '';
    DisplayRights([]);
    edtUsername.SetFocus;
  end
  else
  begin
    User := frmMain.Users.Get(frmOptions.lstUsers.ItemIndex+1);
    if User <> nil then
    begin
      lblUsername.Enabled := False;
      edtUsername.Enabled := False;        
      chlRights.Enabled := not (User.Name = 'admin');
      edtUsername.Text := User.Name;
      edtPassword.Text := User.Password;
      DisplayRights(User.Rights);
    end
  end;
end;
        
procedure TfrmUser.chkHidePasswordClick(Sender: TObject);
begin
  if chkHidePassword.Checked then
    edtPassword.PasswordChar := '*'
  else
    edtPassword.PasswordChar := #0;
end;

procedure TfrmUser.btnOkClick(Sender: TObject);
begin
  if edtUsername.Text = '' then
  begin
    ShowError(6); { Must enter a name }
    edtUsername.SetFocus;
  end
  else with frmMain, frmOptions do
    case Mode of
      mAdd:
        if not Users.Add(edtUsername.Text, edtPassword.Text, GetRights) then
          ShowError(9) { Name already used }
        else
        begin
          DisplayUsers;
          lstUsers.ItemIndex := lstUsers.Items.IndexOf(edtUsername.Text);
          Self.ModalResult := mrOk;
        end;
      mEdit:
        if not Users.Modify(edtUsername.Text, edtPassword.Text, GetRights) then
          ShowError(9) { Name already used }
        else      
        begin
          DisplayUsers;
          Self.ModalResult := mrOk;
        end;
    end;
end;

function TfrmUser.Show(Mode : TMode) : Boolean;
begin
  Self.Mode := Mode;
  Result := (ShowModal = mrOk);
end;

procedure TfrmUser.DisplayRights(Rights : TRights);
begin
  chlRights.Checked[1] := (rAddInventory in Rights);
  chlRights.Checked[2] := (rOpenInventory in Rights);
  chlRights.Checked[3] := (rDeleteInventory in Rights);
  chlRights.Checked[5] := (rAddEmployee in Rights);
  chlRights.Checked[6] := (rEditEmployee in Rights);
  chlRights.Checked[7] := (rDeleteEmployee in Rights);
  chlRights.Checked[9] := (rAddClient in Rights);
  chlRights.Checked[10] := (rEditClient in Rights);
  chlRights.Checked[11] := (rDeleteClient in Rights);
  chlRights.Checked[13] := (rAddSupplier in Rights);
  chlRights.Checked[14] := (rEditSupplier in Rights);
  chlRights.Checked[15] := (rDeleteSupplier in Rights);
  chlRights.Checked[17] := (rAddTransaction in Rights);
  chlRights.Checked[18] := (rOpenTransaction in Rights);
  chlRights.Checked[19] := (rDeleteTransaction in Rights);
  chlRights.Checked[21] := (rAddGroup in Rights);
  chlRights.Checked[22] := (rEditGroup in Rights);
  chlRights.Checked[23] := (rDeleteGroup in Rights);
  chlRights.Checked[25] := (rAddProduct in Rights);
  chlRights.Checked[26] := (rEditProduct in Rights);
  chlRights.Checked[27] := (rDeleteProduct in Rights);
  chlRights.Checked[29] := (rAddUser in Rights);
  chlRights.Checked[30] := (rEditUser in Rights);
  chlRights.Checked[31] := (rDeleteUser in Rights);
  chlRights.Checked[33] := (rEditCompany in Rights);
end;

function TfrmUser.GetRights : TRights;
begin
  Result := [];
  if chlRights.Checked[1] then
    Include(Result, rAddInventory);
  if chlRights.Checked[2] then
    Include(Result, rOpenInventory);
  if chlRights.Checked[3] then
    Include(Result, rDeleteInventory);
  if chlRights.Checked[5] then
    Include(Result, rAddEmployee);
  if chlRights.Checked[6] then
    Include(Result, rEditEmployee);
  if chlRights.Checked[7] then
    Include(Result, rDeleteEmployee);
  if chlRights.Checked[9] then
    Include(Result, rAddClient);
  if chlRights.Checked[10] then
    Include(Result, rEditClient);
  if chlRights.Checked[11] then
    Include(Result, rDeleteClient);
  if chlRights.Checked[13] then
    Include(Result, rAddSupplier);
  if chlRights.Checked[14] then
    Include(Result, rEditSupplier);
  if chlRights.Checked[15] then
    Include(Result, rDeleteSupplier);
  if chlRights.Checked[17] then
    Include(Result, rAddTransaction);
  if chlRights.Checked[18] then
    Include(Result, rOpenTransaction);
  if chlRights.Checked[19] then
    Include(Result, rDeleteTransaction);
  if chlRights.Checked[21] then
    Include(Result, rAddGroup);
  if chlRights.Checked[22] then
    Include(Result, rEditGroup);
  if chlRights.Checked[23] then
    Include(Result, rDeleteGroup);
  if chlRights.Checked[25] then
    Include(Result, rAddProduct);
  if chlRights.Checked[26] then
    Include(Result, rEditProduct);
  if chlRights.Checked[27] then
    Include(Result, rDeleteProduct);
  if chlRights.Checked[29] then
    Include(Result, rAddUser);
  if chlRights.Checked[30] then
    Include(Result, rEditUser);
  if chlRights.Checked[31] then
    Include(Result, rDeleteUser);
  if chlRights.Checked[33] then
    Include(Result, rEditCompany);
end;

end.
