(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormSupplier;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes, Forms,
  WinUtils, UnitMessages, UnitSupplier;

type
  TMode = (mAdd, mEdit);
  TfrmSupplier = class(TForm)
    edtNumber: TEdit;
    btnNumber: TButton;
    lblNumber2: TLabel;
    edtName: TEdit;
    edtAddress: TEdit;
    edtTelephone: TEdit;
    edtEmail: TEdit;
    edtOther: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    lblNumber1: TLabel;
    lblName: TLabel;
    lblAddress: TLabel;
    lblTelephone: TLabel;
    lblOther: TLabel;
    lblEmail: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNumberClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);  
  public
    function Show(Mode : TMode) : Boolean; reintroduce;
  private
    Mode : TMode;
  end;

var
  frmSupplier: TfrmSupplier;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmSupplier.FormShow(Sender: TObject);
var
  Supplier : PSupplier;
begin
  if Mode = mAdd then
  begin           
    lblNumber1.Enabled := True;
    edtNumber.Enabled := True;
    btnNumber.Enabled := True;
    btnNumber.Click;
  end
  else
  begin
    Supplier := frmMain.Company.Suppliers.Get(frmMain.stgSuppliers.Row);
    if Supplier <> nil then
    begin
      lblNumber1.Enabled := False;
      edtNumber.Enabled := False;
      btnNumber.Enabled := False;
      edtNumber.Text := Supplier.Number;
      edtName.Text := Supplier.Name;
      edtAddress.Text := Supplier.Address;
      edtTelephone.Text := Supplier.Telephone;
      edtEmail.Text := Supplier.Email;
      edtOther.Text := Supplier.Other;
    end;
  end;
  edtName.SetFocus;
end;

procedure TfrmSupplier.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edtNumber.Text := '';
  edtName.Text := '';
  edtAddress.Text := '';
  edtTelephone.Text := '';
  edtEmail.Text := '';
  edtOther.Text := '';  
end;
     
procedure TfrmSupplier.btnNumberClick(Sender: TObject);
begin
  edtNumber.Text := '';
  if frmMain.Company.Suppliers.Size < 99 then
    edtNumber.Text := edtNumber.Text + '0';
  if frmMain.Company.Suppliers.Size < 9 then
    edtNumber.Text := edtNumber.Text + '0';
  edtNumber.Text := edtNumber.Text + IntToStr(frmMain.Company.Suppliers.Size+1);
end;

procedure TfrmSupplier.btnOkClick(Sender: TObject);
begin
  if edtNumber.Text = '' then
  begin
    ShowError(8); { Must enter a number }
    edtNumber.SetFocus;
  end
  else with frmMain do
    case Mode of
      mAdd:
        if not Company.Suppliers.Add(edtNumber.Text, edtName.Text, edtAddress.Text, edtTelephone.Text, edtEmail.Text, edtOther.Text) then
          ShowError(11) { Number already used }
        else
        begin
          DisplaySuppliers;
          StringGridSelect(stgSuppliers, 0, edtNumber.Text);
          ModifiedCompany := True;
          Self.ModalResult := mrOk;
        end;
      mEdit:
        if not Company.Suppliers.Modify(edtNumber.Text, edtName.Text, edtAddress.Text, edtTelephone.Text, edtEmail.Text, edtOther.Text) then
          ShowError(11) { Number already used }
        else
        begin
          DisplaySuppliers;
          ModifiedCompany := True;
          Self.ModalResult := mrOk;
        end;
    end;
end;

function TfrmSupplier.Show(Mode : TMode) : Boolean;
begin
  Self.Mode := Mode;
  Result := (ShowModal = mrOk);
end;

end.
