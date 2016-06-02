(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormSelection;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes, Forms,
  Dialogs, Registry, ComCtrls, Grids, StrUtils2, WinUtils, UnitMessages,
  UnitCompany, UnitInventory, UnitGroup, UnitProduct, UnitSelection;

type          
  TMode = (mAdd, mEdit);
  TfrmSelection = class(TForm)
    stgGroups: TStringGrid;
    stgProducts: TStringGrid;
    pnlBottom: TPanel;
    edtComments: TEdit;
    pnlTop: TPanel;
    lblInventory: TLabel;
    cmbInventories: TComboBox;
    splSelection: TSplitter;
    lblComment: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    lblQuantity: TLabel;
    edtQuantity: TEdit;
    udwQuantity: TUpDown;
    chkTextOnly: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmbInventoriesChange(Sender: TObject);
    procedure stgGroupsClick(Sender: TObject);
    procedure pnlBottomResize(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure DisplayInventories;
    procedure DisplayGroups;
    procedure DisplayProducts;
    procedure LoadAppearance;
    procedure SaveAppearance;   
  public
    function Show(Mode : TMode) : Boolean; reintroduce;
  private
    Mode : TMode;
    Inventory : TInventory;
    Group : PGroup;
  end;

var
  frmSelection: TfrmSelection;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmSelection.FormCreate(Sender: TObject);
begin
  Inventory := TInventory.Create;
  LoadAppearance;
  stgGroups.Rows[0].Text := 'Code'+#13#10+'Group';
  stgProducts.Rows[0].Text := 'Code'+#13#10+'Name'+#13#10+'Price'+#13#10+'Qty'+#13#10+'Tax';
end;

procedure TfrmSelection.FormShow(Sender: TObject);
var
  Selection : PSelection;
begin
  btnOk.Enabled := False;
  DisplayInventories;
  cmbInventories.OnChange(Self);
  if Mode = mAdd then
  begin
    udwQuantity.Position := 1;
    edtComments.Text := '';
  end
  else
  begin
    Selection := frmMain.Transaction.Selections.Get(frmMain.stgSelections.Row);
    if Selection <> nil then
    begin
      cmbInventories.ItemIndex := cmbInventories.Items.IndexOf(Selection.Inventory);
      udwQuantity.Position := Selection.Quantity;
      edtComments.Text := Selection.Comments;
      cmbInventories.OnChange(frmSelection);
      StringGridSelect(stgGroups, 0, Selection.Group);
      StringGridSelect(stgProducts, 0, Selection.Code);
    end;
  end;
end;

procedure TfrmSelection.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveAppearance;
end;

procedure TfrmSelection.cmbInventoriesChange(Sender: TObject);
begin
  if cmbInventories.Text <> '' then
    case Inventory.LoadFromFile(frmMain.Company.FilesDir+cmbInventories.Text+InvExt) of
      10 : ShowError(1, cmbInventories.Text+InvExt);
      12,13 : ShowError(2, cmbInventories.Text+InvExt);
      14,15 : ShowError(3, cmbInventories.Text+InvExt);
    else
      DisplayGroups;
      stgGroups.OnClick(Self);
      btnOk.Enabled := True;
    end;
end;

procedure TfrmSelection.stgGroupsClick(Sender: TObject);
begin
  Group := Inventory.Groups.Get(stgGroups.Row);
  DisplayProducts;
end;

procedure TfrmSelection.pnlBottomResize(Sender: TObject);
begin
  btnOk.Left := pnlBottom.Width-141;
  btnCancel.Left := pnlBottom.Width-69;
  edtComments.Width := pnlBottom.Width-328;
end;

procedure TfrmSelection.btnOkClick(Sender: TObject);
var
  Product : PProduct;
begin
  if Group <> nil then
  begin
    Product := Group.Products.Get(stgProducts.Row);
    if Product <> nil then
      if (udwQuantity.Position = 0) or (udwQuantity.Position > Product.Quantity) then
      begin
        ShowError(17); { Quantity must not be 0 }
        edtQuantity.SetFocus;
      end
      else
        case Mode of
          mAdd:
            if not frmMain.Transaction.Selections.Add(Inventory.Name, Group.Code, Product.Code, Product.Name, Product.Web, Product.Price, udwQuantity.Position, Product.Taxed, edtComments.Text, chkTextOnly.Checked) then
              ShowError(10) { Code already used }
            else with frmMain do
            begin
              Transaction.Calculate(Company.FederalTaxValue, Company.StateTaxValue, Transaction.Fees, Transaction.Deposit);
              DisplaySelections;
              StringGridSelect(stgSelections, 0, Product.Code);
              ModifiedTransaction := True;
              Self.ModalResult := mrOk;
            end;
          mEdit:
            if not frmMain.Transaction.Selections.Modify(frmMain.stgSelections.Row, Inventory.Name, Group.Code, Product.Code, Product.Name, Product.Web, Product.Price, udwQuantity.Position, Product.Taxed, edtComments.Text, chkTextOnly.Checked) then
              ShowError(10) { Code already used }
            else with frmMain do
            begin
              Transaction.Calculate(Company.FederalTaxValue, Company.StateTaxValue, Transaction.Fees, Transaction.Deposit);
              DisplaySelections;
              ModifiedTransaction := True;
              Self.ModalResult := mrOk;
            end;
        end;
  end;
end;

function TfrmSelection.Show(Mode : TMode) : Boolean;
begin
  Self.Mode := Mode;
  Result := (ShowModal = mrOk);
end;

procedure TfrmSelection.DisplayInventories;
var
  FileInfo : TSearchRec;
  Inventory : TInventory;
  i : Integer;
begin
  i := cmbInventories.ItemIndex;
  cmbInventories.Items.Clear;
  Inventory := TInventory.Create;
  if FindFirst(frmMain.Company.FilesDir+'*'+InvExt, faAnyFile, FileInfo) = 0 then
  begin
    repeat
      if (FileInfo.Attr and faDirectory) = 0 then
        case Inventory.LoadHeaderFromFile(MakeFileName(frmMain.Company.FilesDir, FileInfo.Name)) of
          10 : ShowError(1, FileInfo.Name);
          12,13 : ShowError(2, FileInfo.Name);
          14,15 : ShowError(3, FileInfo.Name);
        else
          cmbInventories.Items.Append(Inventory.Name);
        end;
    until FindNext(FileInfo) <> 0;
    SysUtils.FindClose(FileInfo);
  end;
  Inventory.Free;
  cmbInventories.ItemIndex := i;
end;

procedure TfrmSelection.DisplayGroups;
var
  Index : Integer;
  CurGroup : PGroup;
begin    
  if Inventory.Groups.Size > 0 then
  begin
    stgGroups.RowCount := Inventory.Groups.Size+1;
    CurGroup := Inventory.Groups.First;
    Index := 0;
    while (CurGroup <> nil) and (Index < stgGroups.RowCount-1) do
    begin
      Index := Index+1;
      stgGroups.Cells[0, Index] := CurGroup.Code;
      stgGroups.Cells[1, Index] := CurGroup.Name;
      CurGroup := CurGroup.Next;
    end;
  end
  else
  begin
    stgGroups.RowCount := 2;
    stgGroups.Rows[1].Clear;
  end;
end;

procedure TfrmSelection.DisplayProducts;
var
  Index : Integer;
  Product : PProduct;
begin
  if (Group <> nil) and (Group.Products.Size > 0) then
  begin
    stgProducts.RowCount := Group.Products.Size+1;
    Product := Group.Products.First;
    Index := 0;
    while (Product <> nil) and (Index < stgProducts.RowCount-1) do
    begin
      Index := Index+1;
      stgProducts.Cells[0, Index] := Product.Code;
      stgProducts.Cells[1, Index] := Product.Name;
      stgProducts.Cells[2, Index] := FormatFloat('0.00 ' + frmMain.Company.CurrencySign, Product.Price);
      stgProducts.Cells[3, Index] := IntToStr(Product.Quantity);
      if Product.Taxed then
        stgProducts.Cells[4, Index] := 'T'
      else
        stgProducts.Cells[4, Index] := '';
      stgProducts.Cells[5, Index] := Product.Web;
      Product := Product.Next;
    end;
  end
  else
  begin
    stgProducts.RowCount := 2;
    stgProducts.Rows[1].Clear;
  end;
end;

procedure TfrmSelection.LoadAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin                                
      frmSelection.Width := Reg.ReadInteger('FormSelectionWidth');
      frmSelection.Height := Reg.ReadInteger('FormSelectionHeight');
      stgGroups.ColWidths[0] := Reg.ReadInteger('FormSelectionCol01');
      stgGroups.ColWidths[1] := Reg.ReadInteger('FormSelectionCol02');
      stgGroups.Width := Reg.ReadInteger('FormSelectionCol03');
      stgProducts.ColWidths[0] := Reg.ReadInteger('FormSelectionCol11');
      stgProducts.ColWidths[1] := Reg.ReadInteger('FormSelectionCol12');
      stgProducts.ColWidths[2] := Reg.ReadInteger('FormSelectionCol13');
      stgProducts.ColWidths[3] := Reg.ReadInteger('FormSelectionCol14');
      stgProducts.ColWidths[4] := Reg.ReadInteger('FormSelectionCol15');
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

procedure TfrmSelection.SaveAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin                             
      Reg.WriteInteger('FormSelectionWidth', frmSelection.Width);
      Reg.WriteInteger('FormSelectionHeight', frmSelection.Height);
      Reg.WriteInteger('FormSelectionCol01', stgGroups.ColWidths[0]);
      Reg.WriteInteger('FormSelectionCol02', stgGroups.ColWidths[1]);   
      Reg.WriteInteger('FormSelectionCol03', stgGroups.Width);
      Reg.WriteInteger('FormSelectionCol11', stgProducts.ColWidths[0]);
      Reg.WriteInteger('FormSelectionCol12', stgProducts.ColWidths[1]);
      Reg.WriteInteger('FormSelectionCol13', stgProducts.ColWidths[2]);
      Reg.WriteInteger('FormSelectionCol14', stgProducts.ColWidths[3]);
      Reg.WriteInteger('FormSelectionCol15', stgProducts.ColWidths[4]);
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

end.
