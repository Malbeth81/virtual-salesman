(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormSelect;

interface

uses
  SysUtils, Windows, Messages, Controls, StdCtrls, ExtCtrls, ComCtrls, Classes, Forms,
  Registry, Grids, Dialogs, WinUtils, UnitMessages, UnitCompany, UnitEmployee,
  UnitClient, UnitSupplier;

type
  TMode = (mEmployees, mClients, mSuppliers);
  TfrmSelect = class(TForm)
    stgSelect: TStringGrid;
    pnlBottom: TPanel;
    btnCancel: TButton;
    btnOk: TButton;
    btnNew: TButton;
    btnFind: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure stgSelectDblClick(Sender: TObject);
    procedure pnlBottomResize(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure DisplayEmployees;
    procedure DisplayClients;
    procedure DisplaySuppliers;
    procedure LoadAppearance;
    procedure SaveAppearance;   
  public
    Number,
    Name,
    Address,
    Telephone,
    Email,
    Other : string;    
    function Show(Mode : TMode) : Boolean;
  private
    Mode : TMode;
  end;

var
  frmSelect: TfrmSelect;

implementation

uses FormClient, FormEmployee, FormSupplier, FormFind, FormMain;

{$R *.dfm}

procedure TfrmSelect.FormCreate(Sender: TObject);
begin
  LoadAppearance;  
  stgSelect.Rows[0].Text := 'Number'+#13#10+'Name'+#13#10+'Address'+#13#10+'Telephone'+#13#10+'E-mail'+#13#10+'Other';
 end;
      
procedure TfrmSelect.FormShow(Sender: TObject);
begin
  case Mode of
    mEmployees: begin
      frmSelect.Caption := frmMain.Texts.Values['Title0'];
      DisplayEmployees;
    end;
    mClients : begin
      frmSelect.Caption := frmMain.Texts.Values['Title1'];
      DisplayClients;
    end;
    mSuppliers : begin                       
      frmSelect.Caption := frmMain.Texts.Values['Title2'];
      DisplaySuppliers;
    end;
  end;
  if Number <> '' then
    StringGridSelect(stgSelect, 0, Number);
end;

procedure TfrmSelect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveAppearance;
end;
    
procedure TfrmSelect.stgSelectDblClick(Sender: TObject);
begin
  btnOk.Click;
end;

procedure TfrmSelect.pnlBottomResize(Sender: TObject);
begin
  btnOk.Left := pnlBottom.Width-141;
  btnCancel.Left := pnlBottom.Width-69;
end;

procedure TfrmSelect.btnFindClick(Sender: TObject);
begin
  frmFind.Show(stgSelect);
end;

procedure TfrmSelect.btnNewClick(Sender: TObject);
begin
  case Mode of
    mEmployees: frmEmployee.Show(FormEmployee.mAdd);
    mClients: frmClient.Show(FormClient.mAdd);
    mSuppliers: frmSupplier.Show(FormSupplier.mAdd);
  end;
end;

procedure TfrmSelect.btnOkClick(Sender: TObject);
begin
  Number := stgSelect.Cells[0, stgSelect.Row];
  Name := stgSelect.Cells[1, stgSelect.Row];
  Address := stgSelect.Cells[2, stgSelect.Row];
  Telephone := stgSelect.Cells[3, stgSelect.Row];
  Email := stgSelect.Cells[4, stgSelect.Row];
  Other := stgSelect.Cells[5, stgSelect.Row];
  Self.ModalResult := mrOk;end;

function TfrmSelect.Show(Mode : TMode) : Boolean;
begin
  Self.Mode := Mode;
  Result := (ShowModal = mrOk);
end;

procedure TfrmSelect.DisplayEmployees;
var
  Index : Word;
  Employee : PEmployee;
begin
  if frmMain.Company.Employees.Size > 0 then
  begin
    stgSelect.RowCount := frmMain.Company.Employees.Size+1;
    Employee := frmMain.Company.Employees.First;
    Index := 0;
    while (Employee <> nil) and (Index < stgSelect.RowCount-1) do
    begin
      Index := Index+1;
      stgSelect.Cells[0, Index] := Employee.Number;
      stgSelect.Cells[1, Index] := Employee.Name;
      stgSelect.Cells[2, Index] := Employee.Address;
      stgSelect.Cells[3, Index] := Employee.Telephone;
      stgSelect.Cells[4, Index] := Employee.Email;
      stgSelect.Cells[5, Index] := Employee.Other;
      Employee := Employee.Next;
    end;
  end
  else
  begin
    stgSelect.RowCount := 2;
    stgSelect.Rows[1].Clear;
  end;
end;

procedure TfrmSelect.DisplayClients;
var
  Index : Word;
  Client : PClient;
begin
  if frmMain.Company.Clients.Size > 0 then
  begin
    stgSelect.RowCount := frmMain.Company.Clients.Size+1;
    Client := frmMain.Company.Clients.First;
    Index := 0;
    while (Client <> nil) and (Index < stgSelect.RowCount-1) do
    begin
      Index := Index+1;
      stgSelect.Cells[0, Index] := Client.Number;
      stgSelect.Cells[1, Index] := Client.Name;
      stgSelect.Cells[2, Index] := Client.Address;
      stgSelect.Cells[3, Index] := Client.Telephone;
      stgSelect.Cells[4, Index] := Client.Email;
      stgSelect.Cells[5, Index] := Client.Other;
      Client := Client.Next;
    end;
  end
  else
  begin
    stgSelect.RowCount := 2;
    stgSelect.Rows[1].Clear;
  end;
end;

procedure TfrmSelect.DisplaySuppliers;
var
  Index : Word;
  Supplier : PSupplier;
begin
  if frmMain.Company.Suppliers.Size > 0 then
  begin
    stgSelect.RowCount := frmMain.Company.Suppliers.Size+1;
    Supplier := frmMain.Company.Suppliers.First;
    Index := 0;
    while (Supplier <> nil) and (Index < stgSelect.RowCount-1) do
    begin
      Index := Index+1;
      stgSelect.Cells[0, Index] := Supplier.Number;
      stgSelect.Cells[1, Index] := Supplier.Name;
      stgSelect.Cells[2, Index] := Supplier.Address;
      stgSelect.Cells[3, Index] := Supplier.Telephone;
      stgSelect.Cells[4, Index] := Supplier.Email;
      stgSelect.Cells[5, Index] := Supplier.Other;
      Supplier := Supplier.Next;
    end;
  end
  else
  begin
    stgSelect.RowCount := 2;
    stgSelect.Rows[1].Clear;
  end;
end;

procedure TfrmSelect.LoadAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin                   
      frmSelect.Width := Reg.ReadInteger('FormSelectWidth');
      frmSelect.Height := Reg.ReadInteger('FormSelectHeight');
      stgSelect.ColWidths[0] := Reg.ReadInteger('FormSelectCol01');
      stgSelect.ColWidths[1] := Reg.ReadInteger('FormSelectCol02');
      stgSelect.ColWidths[2] := Reg.ReadInteger('FormSelectCol03');
      stgSelect.ColWidths[3] := Reg.ReadInteger('FormSelectCol04');
      stgSelect.ColWidths[4] := Reg.ReadInteger('FormSelectCol05');
      stgSelect.ColWidths[5] := Reg.ReadInteger('FormSelectCol06');
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

procedure TfrmSelect.SaveAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin
      Reg.WriteInteger('FormSelectWidth', frmSelect.Width);
      Reg.WriteInteger('FormSelectHeight', frmSelect.Height);
      Reg.WriteInteger('FormSelectCol01', stgSelect.ColWidths[0]);
      Reg.WriteInteger('FormSelectCol02', stgSelect.ColWidths[1]);
      Reg.WriteInteger('FormSelectCol03', stgSelect.ColWidths[2]);
      Reg.WriteInteger('FormSelectCol04', stgSelect.ColWidths[3]);
      Reg.WriteInteger('FormSelectCol05', stgSelect.ColWidths[4]);
      Reg.WriteInteger('FormSelectCol06', stgSelect.ColWidths[5]);
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

end.
