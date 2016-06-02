(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, UnitUsers, UnitMessages;

type
  TfrmLogin = class(TForm)
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    lblUsername: TLabel;
    lblPassword: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  public
    function Show : Boolean; reintroduce;
  end;

var
  frmLogin: TfrmLogin;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  edtUsername.Text := '';
  edtUsername.SetFocus;
  edtPassword.Text := '';
end;

procedure TfrmLogin.btnOkClick(Sender: TObject);
var
  User : PUser;
begin
  User := frmMain.Users.Get(edtUsername.Text);
  if (User = nil) or (User.Password <> edtPassword.Text) then
    ShowError(14) { Invalid login }
  else
  begin
    frmMain.User := User;
    Self.ModalResult := mrOk;
  end;
end;

function TfrmLogin.Show : Boolean;
begin
  Result := (ShowModal = mrOk);
end;

end.
