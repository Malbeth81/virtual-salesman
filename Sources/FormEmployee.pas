(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormEmployee;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes, Forms,
  WinUtils, UnitMessages, UnitEmployee;

type
  TMode = (mAdd, mEdit);
  TfrmEmployee = class(TForm)
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
  frmEmployee: TfrmEmployee;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmEmployee.FormShow(Sender: TObject);
var
  Employee : PEmployee;
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
    Employee := frmMain.Company.Employees.Get(frmMain.stgEmployees.Row);
    if Employee <> nil then
    begin
      lblNumber1.Enabled := False;
      edtNumber.Enabled := False;
      btnNumber.Enabled := False;
      edtNumber.Text := Employee.Number;
      edtName.Text := Employee.Name;
      edtAddress.Text := Employee.Address;
      edtTelephone.Text := Employee.Telephone;
      edtEmail.Text := Employee.Email;
      edtOther.Text := Employee.Other;
    end;
  end;
  edtName.SetFocus;
end;

procedure TfrmEmployee.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edtNumber.Text := '';
  edtName.Text := '';
  edtAddress.Text := '';
  edtTelephone.Text := '';
  edtEmail.Text := '';
  edtOther.Text := '';
end;
     
procedure TfrmEmployee.btnNumberClick(Sender: TObject);
begin
  edtNumber.Text := '';
  if frmMain.Company.Employees.Size < 99 then
    edtNumber.Text := edtNumber.Text + '0';
  if frmMain.Company.Employees.Size < 9 then
    edtNumber.Text := edtNumber.Text + '0';
  edtNumber.Text := edtNumber.Text + IntToStr(frmMain.Company.Employees.Size+1);
end;

procedure TfrmEmployee.btnOkClick(Sender: TObject);
begin
  if edtNumber.Text = '' then
  begin
    ShowError(8); { Must enter a number }
    edtNumber.SetFocus;
  end
  else with frmMain do
    case Mode of
      mAdd:
        if not Company.Employees.Add(edtNumber.Text, edtName.Text, edtAddress.Text, edtTelephone.Text, edtEmail.Text, edtOther.Text) then
          ShowError(11) { Number already used }
        else
        begin
          DisplayEmployees;
          StringGridSelect(stgEmployees, 0, edtNumber.Text);
          ModifiedCompany := True;
          Self.ModalResult := mrOk;
        end;
      mEdit:
        if not Company.Employees.Modify(edtNumber.Text, edtName.Text, edtAddress.Text, edtTelephone.Text, edtEmail.Text, edtOther.Text) then
          ShowError(11) { Number already used }
        else
        begin
          DisplayEmployees;
          ModifiedCompany := True;
          Self.ModalResult := mrOk;
        end;
    end;
end;

function TfrmEmployee.Show(Mode : TMode) : Boolean;
begin
  Self.Mode := Mode;
  Result := (ShowModal = mrOk);
end;

end.
