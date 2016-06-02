(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormFind;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes, Forms,
  Grids, WinUtils, UnitMessages;

type
  TfrmFind = class(TForm)  
    edtFind: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    lblFind: TLabel;
    procedure btnOkClick(Sender: TObject);
  public
    function Show(Grid : TStringGrid) : Boolean; reintroduce;
    procedure FindNext;
  private
    Grid : TStringGrid;
  end;

var
  frmFind: TfrmFind;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmFind.FindNext;  
var
  Found : Boolean;
begin
  Found := False;
  if edtFind.Text <> '' then
  begin
    while not Found do
    begin
      Found := StringGridFind(Grid, Grid.Row+1, edtFind.Text);
      if not Found then
        if AskQuestion(7) = idYes then
        begin
          Grid.Row := 1;
          Found := StringGridFind(Grid, Grid.Row, edtFind.Text);
        end
        else
          Found := True;
    end;
  end;
end;

procedure TfrmFind.btnOkClick(Sender: TObject);
begin
  if edtFind.Text = '' then
  begin
    ShowError(5); { Must enter text }
    edtFind.SetFocus;
  end
  else
  begin
    FindNext;
    Self.ModalResult := mrOk;
  end;
end;

function TfrmFind.Show(Grid : TStringGrid) : Boolean;
begin
  Self.Grid := Grid;
  Result := (ShowModal = mrOk);
end;

end.
