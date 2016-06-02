(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2005 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormStats;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes, Forms,
  Grids, StrUtils2, WinUtils, UnitMessages, UnitCompany, UnitInventory,
  UnitGroup, UnitEmployee, UnitClient, UnitSupplier;

type
  TfrmStats = class(TForm)
    stgStats: TStringGrid;
    btnOk: TButton;
    procedure FormShow(Sender: TObject);
    procedure stgStatsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    function TotalProducts : Integer;      
  public
    function Show : Boolean; reintroduce;
  end;

var
  frmStats: TfrmStats;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmStats.FormShow(Sender: TObject);
begin
  with frmMain do
  begin
    stgStats.RowCount := 1;
    stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Sect10'];
    stgStats.Cells[1, stgStats.RowCount-1] := '';
    stgStats.RowCount := stgStats.RowCount+1;
    stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Stat10'];
    stgStats.Cells[1, stgStats.RowCount-1] := FormatFloat('0.00', FolderSize(Company.FilesDir)/1024) + ' Ko';
    stgStats.RowCount := stgStats.RowCount+1;
    stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Stat11'];
    stgStats.Cells[1, stgStats.RowCount-1] := IntToStr(CountFiles(Company.FilesDir+'*'+InvExt));
    stgStats.RowCount := stgStats.RowCount+1;
    stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Stat12'];
    stgStats.Cells[1, stgStats.RowCount-1] := IntToStr(Company.Employees.Size);
    stgStats.RowCount := stgStats.RowCount+1;
    stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Stat13'];
    stgStats.Cells[1, stgStats.RowCount-1] := IntToStr(Company.Clients.Size);
    stgStats.RowCount := stgStats.RowCount+1;
    stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Stat14'];
    stgStats.Cells[1, stgStats.RowCount-1] := IntToStr(Company.Suppliers.Size);
    stgStats.RowCount := stgStats.RowCount+1;
    stgStats.Cells[0, stgStats.RowCount-1] := '';
    stgStats.Cells[1, stgStats.RowCount-1] := '';
    stgStats.RowCount := stgStats.RowCount+1;
    stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Sect11'];
    stgStats.Cells[1, stgStats.RowCount-1] := '';
    stgStats.RowCount := stgStats.RowCount+1;
    if Inventory = nil then
    begin
      stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Stat15'];
      stgStats.Cells[1, stgStats.RowCount-1] := '';
    end
    else
    begin
      stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Stat16'];
      stgStats.Cells[1, stgStats.RowCount-1] := IntToStr(Inventory.Groups.Size);
      stgStats.RowCount := stgStats.RowCount+1;
      stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Stat17'];
      stgStats.Cells[1, stgStats.RowCount-1] := IntToStr(TotalProducts);
      stgStats.RowCount := stgStats.RowCount+1;
      stgStats.Cells[0, stgStats.RowCount-1] := Texts.Values['Stat18'];
      if Inventory.Groups.Size > 0 then
        stgStats.Cells[1, stgStats.RowCount-1] := FormatFloat('0.00', TotalProducts/Inventory.Groups.Size)
      else
        stgStats.Cells[1, stgStats.RowCount-1] := '0';
    end;
  end;
  btnOk.SetFocus;
end;

procedure TfrmStats.stgStatsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if stgStats.ColWidths[ARow] >= stgStats.ClientWidth then
    stgStats.ColWidths[ARow] := stgStats.ClientWidth;
end;

function TfrmStats.Show : Boolean;
begin
  Result := (ShowModal = mrOk);
end;

function TfrmStats.TotalProducts : Integer;
var
  CurGroup : PGroup;
begin
  Result := 0;
  CurGroup := frmMain.Inventory.Groups.First;
  while CurGroup <> nil do
  begin
    Result := Result + CurGroup.Products.Size;
    CurGroup := CurGroup.Next;
  end;
end;

end.
