(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormSave;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes, Forms,
  StrUtils2, WinUtils, UnitMessages, UnitCompany, UnitInventory;

type
  TMode = (mCompany, mInventory);
  TfrmSave = class(TForm)  
    edtSave: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    lblSave: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  public
    function Show(Mode : TMode; Caption : string) : Boolean; reintroduce;
  private
    Mode : TMode;
  end;

var
  frmSave: TfrmSave;

implementation

uses FormMain;

{$R *.dfm}
   
procedure TfrmSave.FormShow(Sender: TObject);
begin
  edtSave.SetFocus;
end;

procedure TfrmSave.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edtSave.Text := '';
end;

procedure TfrmSave.btnOkClick(Sender: TObject);
begin
  if edtSave.Text = '' then
  begin
    ShowError(6); { Must enter a name }
    edtSave.SetFocus;
  end
  else with frmMain do
    case Mode of
      mCompany:
        if DirectoryExists(RootDir+edtSave.Text) then
          ShowError(9) { Name already used }
        else
        begin
          Company.SetFileName(RootDir+edtSave.Text+'\'+edtSave.Text+CieExt);
          CurrentFile := edtSave.Text+'\'+edtSave.Text+CieExt;
          Self.ModalResult := mrOk;
        end;
      mInventory:
        if FileExists(Company.FilesDir+edtSave.Text+InvExt) then
          ShowError(9) { Name already used }
        else
        begin
          Inventory := TInventory.Create(edtSave.Text, Now, '');
          ViewInventory;
          Self.ModalResult := mrOk;
        end;
    end;
end;

function TfrmSave.Show(Mode : TMode; Caption  : string) : Boolean;
begin
  Self.Mode := Mode;
  lblSave.Caption := Caption;
  Result := (ShowModal = mrOk);
end;

end.
