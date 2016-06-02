(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormGroup;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes, Forms,
  WinUtils, UnitMessages, UnitGroup;

type           
  TMode = (mAdd, mEdit);
  TfrmGroup = class(TForm)
    edtCode: TEdit;
    lblCode2: TLabel;
    edtName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    lblCode1: TLabel;
    lblName: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);  
  public
    function Show(Mode : TMode) : Boolean; reintroduce;
  private
    Mode : TMode;
  end;

var
  frmGroup: TfrmGroup;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmGroup.FormShow(Sender: TObject);
begin
  if Mode = mAdd then
  begin
    lblCode1.Enabled := True;
    edtCode.Enabled := True;
  end
  else if frmMain.Group <> nil then
  begin
    lblCode1.Enabled := False;
    edtCode.Enabled := False;
    edtCode.Text := frmMain.Group.Code;
    edtName.Text := frmMain.Group.Name;
  end;
  edtName.SetFocus;
end;

procedure TfrmGroup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edtCode.Text := '';
  edtName.Text := '';   
end;

procedure TfrmGroup.btnOkClick(Sender: TObject);
begin    
  if edtCode.Text = '' then
  begin
    ShowError(7); { Must enter code }
    edtCode.SetFocus;
  end
  else with frmMain do
    case Mode of
      mAdd:
        if not Inventory.Groups.Add(edtCode.Text, edtName.Text) then
          ShowError(10) { Code already used }
        else
        begin
          DisplayGroups;
          stgGroups.OnEnter(Self);
          StringGridSelect(stgGroups, 0, edtCode.Text);
          stgGroups.OnClick(Self);
          ModifiedInventory := True;
          Self.ModalResult := mrOk;
        end;
      mEdit:
        if not Inventory.Groups.Modify(edtCode.Text, edtName.Text) then
          ShowError(10) { Code already used }
        else
        begin
          DisplayGroups;
          stgGroups.OnEnter(Self);
          ModifiedInventory := True;
          Self.ModalResult := mrOk;
        end;
    end;
end;

function TfrmGroup.Show(Mode : TMode) : Boolean;
begin
  Self.Mode := Mode;
  Result := (ShowModal = mrOk);
end;

end.
