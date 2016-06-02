(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormProduct;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes, Forms,
  Buttons, ComCtrls, Grids, Registry, WinUtils, StrUtils2, UnitMessages,
  UnitCompany, UnitGroup, UnitProduct, UnitSupplier;

type
  TMode = (mAdd, mEdit);
  TfrmProduct = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    pgcProduct: TPageControl;
    tbsSuppliers: TTabSheet;
    tbsProduct: TTabSheet;
    edtPercent: TEdit;
    edtCost: TEdit;
    edtQuantity: TEdit;
    edtWeb: TEdit;
    chkTaxed: TCheckBox;
    btnPrice: TButton;
    lblPercent: TLabel;
    edtPrice: TEdit;
    edtName: TEdit;
    lblCode2: TLabel;
    btnCode: TButton;
    edtCode: TEdit;
    stgSuppliers: TStringGrid;
    btnAdd: TButton;
    btnRemove: TButton;
    lblCode1: TLabel;
    lblName: TLabel;
    lblCost: TLabel;
    lblQuantity: TLabel;
    lblURL: TLabel;
    lblPlus: TLabel;
    lblPrice: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction); 
    procedure btnCodeClick(Sender: TObject);
    procedure btnPriceClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure DisplaySuppliers;
    procedure LoadAppearance;
    procedure SaveAppearance;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pgcProductChange(Sender: TObject);
  public
    function Show(Mode : TMode) : Boolean; reintroduce;
  private
    Mode : TMode;
    Suppliers : TStringList;
  end;

var
  frmProduct: TfrmProduct;

implementation

uses FormSelect, FormMain;

{$R *.dfm}

procedure TfrmProduct.FormCreate(Sender: TObject);
begin
  Suppliers := TStringList.Create;
  LoadAppearance;
  stgSuppliers.Rows[0].Text := 'Number'+#13#10+'Name'+#13#10+'Address'+#13#10+'Telephone'+#13#10+'E-mail'+#13#10+'Other';
end;
      
procedure TfrmProduct.FormDestroy(Sender: TObject);
begin
  Suppliers.Free;
end;

procedure TfrmProduct.FormShow(Sender: TObject);
var
  Product : PProduct;
  i : Integer;
begin
  if Mode = mAdd then
  begin
    lblCode1.Enabled := True;
    edtCode.Enabled := True;
    btnCode.Enabled := True;
    edtCost.Text := FormatFloat('0.00', 0);
    edtPercent.Text := FormatFloat('0.00', 0);
    edtPrice.Text := FormatFloat('0.00', 0);
    edtQuantity.Text := '0';
    btnCode.Click;
  end
  else
  begin
    Product := frmMain.Group.Products.Get(frmMain.stgProducts.Row);
    if Product <> nil then
    begin
      lblCode1.Enabled := False;
      edtCode.Enabled := False;
      btnCode.Enabled := False;
      edtCode.Text := Product.Code;
      edtName.Text := Product.Name;
      edtCost.Text := FormatFloat('0.00', Product.Cost);
      edtPrice.Text := FormatFloat('0.00', Product.Price);
      edtQuantity.Text := IntToStr(Product.Quantity);
      chkTaxed.Checked := Product.Taxed;
      edtWeb.Text := Product.Web;
      Suppliers.Text := Product.Suppliers;
      for i := Suppliers.Count-1 downto 0 do
        if frmMain.Company.Suppliers.Get(Suppliers[i]) = nil then
          Suppliers.Delete(i);
    end;
  end;
  pgcProduct.ActivePageIndex := 0;
  edtName.SetFocus;
end;

procedure TfrmProduct.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edtCode.Text := '';
  edtName.Text := '';
  edtCost.Text := '';
  if edtPercent.Text = '' then
    edtPercent.Text := '';
  edtPrice.Text := '';
  edtQuantity.Text := '';
  chkTaxed.Checked := True;
  edtWeb.Text := '';  
  Suppliers.Clear;      
  SaveAppearance;
end;
         
procedure TfrmProduct.pgcProductChange(Sender: TObject);
begin
  case pgcProduct.ActivePageIndex of
    1: DisplaySuppliers;
  end;
end;

procedure TfrmProduct.btnCodeClick(Sender: TObject);
begin
  edtCode.Text := frmMain.Group.Code;
  if frmMain.Group.Products.Size < 99 then
    edtCode.Text := edtCode.Text + '0';
  if frmMain.Group.Products.Size < 9 then
    edtCode.Text := edtCode.Text + '0';
  edtCode.Text := edtCode.Text + IntToStr(frmMain.Group.Products.Size+1);
end;
   
procedure TfrmProduct.btnPriceClick(Sender: TObject);
var
  Cost,
  Percent : Single;
begin
  Cost := StrToFloat(edtCost.Text);
  Percent := StrToFloat(edtPercent.Text)/100;
  edtPrice.Text := FormatFloat('0.00', Cost + (Cost*Percent));
end;

procedure TfrmProduct.btnAddClick(Sender: TObject);
begin
  if frmSelect.Show(mSuppliers) then
  begin
    Suppliers.Add(frmSelect.Number);
    if stgSuppliers.Cells[0, stgSuppliers.RowCount-1] <> '' then
      stgSuppliers.RowCount := stgSuppliers.RowCount+1;
    stgSuppliers.Cells[0, stgSuppliers.RowCount-1] := frmSelect.Number;
    stgSuppliers.Cells[1, stgSuppliers.RowCount-1] := frmSelect.Name;
    stgSuppliers.Cells[2, stgSuppliers.RowCount-1] := frmSelect.Address;
    stgSuppliers.Cells[3, stgSuppliers.RowCount-1] := frmSelect.Telephone;
    stgSuppliers.Cells[4, stgSuppliers.RowCount-1] := frmSelect.Email;
    stgSuppliers.Cells[5, stgSuppliers.RowCount-1] := frmSelect.Other;
  end;
end;

procedure TfrmProduct.btnRemoveClick(Sender: TObject);
var
  i : Integer;
begin
  if stgSuppliers.Cells[0, stgSuppliers.RowCount-1] <> '' then
  begin
    Suppliers.Delete(stgSuppliers.RowCount-2);
    for i := stgSuppliers.Row to stgSuppliers.RowCount-1 do
      stgSuppliers.Rows[i] := stgSuppliers.Rows[i+1];
    if stgSuppliers.RowCount > 2 then
      stgSuppliers.RowCount := stgSuppliers.RowCount-1;
  end;
end;

procedure TfrmProduct.btnOkClick(Sender: TObject);
begin        
  if edtCost.Text = '' then
    edtCost.Text := FormatFloat('0.00', 0);
  if edtPrice.Text = '' then
    edtPrice.Text := FormatFloat('0.00', 0);
  if edtQuantity.Text = '' then
    edtQuantity.Text := FormatFloat('0.00', 0);

  if edtCode.Text = '' then
  begin
    ShowError(7); { Missing Code }                  
    pgcProduct.ActivePageIndex := 0;
    edtCode.SetFocus;
    Exit;
  end;
  if StrToFloat(edtCost.Text) > StrToFloat(edtPrice.Text) then
  begin
    ShowError(19); { Price cannot be lower than cost }
    pgcProduct.ActivePageIndex := 0;
    edtPrice.SetFocus;
  end
  else with frmMain do
    case Mode of
      mAdd:
        if not Group.Products.Add(edtCode.Text, edtName.Text, edtWeb.Text, StrToFloat(edtCost.Text), StrToFloat(edtPrice.Text), StrToInt(edtQuantity.Text), chkTaxed.Checked, Suppliers.Text) then
          ShowError(10) { Code already used }
        else
        begin
          DisplayProducts;
          StringGridSelect(stgProducts, 0, edtCode.Text);
          ModifiedInventory := True;
          Self.ModalResult := mrOk;
        end;
      mEdit:
        if not Group.Products.Modify(edtCode.Text, edtName.Text, edtWeb.Text, StrToFloat(edtCost.Text), StrToFloat(edtPrice.Text), StrToInt(edtQuantity.Text), chkTaxed.Checked, Suppliers.Text) then
          ShowError(10) { Code already used }
        else
        begin
          DisplayProducts;
          ModifiedInventory := True;
          Self.ModalResult := mrOk;
        end;
    end;
end;

function TfrmProduct.Show(Mode : TMode) : Boolean;
begin
  Self.Mode := Mode;
  Result := (ShowModal = mrOk);
end;

procedure TfrmProduct.DisplaySuppliers;
var
  i : Word;
  Supplier : PSupplier;
  Product : PProduct;
begin
  Product := frmMain.Group.Products.Get(frmMain.stgProducts.Row);
  if (Product <> nil) and (Suppliers.Count > 0) then
  begin
    stgSuppliers.RowCount := Suppliers.Count+1;
    for i := 0 to Suppliers.Count-1 do
    begin
      Supplier := frmMain.Company.Suppliers.Get(Suppliers[i]);
      if Supplier <> nil then
      begin
        stgSuppliers.Cells[0, i+1] := Supplier.Number;
        stgSuppliers.Cells[1, i+1] := Supplier.Name;
        stgSuppliers.Cells[2, i+1] := Supplier.Address;
        stgSuppliers.Cells[3, i+1] := Supplier.Telephone;
        stgSuppliers.Cells[4, i+1] := Supplier.Email;
        stgSuppliers.Cells[5, i+1] := Supplier.Other;
      end;
    end;
  end
  else
  begin
    stgSuppliers.RowCount := 2;
    stgSuppliers.Rows[1].Clear;
  end;
end;

procedure TfrmProduct.LoadAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin
      stgSuppliers.ColWidths[0] := Reg.ReadInteger('FormProductCol01');
      stgSuppliers.ColWidths[1] := Reg.ReadInteger('FormProductCol02');
      stgSuppliers.ColWidths[2] := Reg.ReadInteger('FormProductCol03');
      stgSuppliers.ColWidths[3] := Reg.ReadInteger('FormProductCol04');
      stgSuppliers.ColWidths[4] := Reg.ReadInteger('FormProductCol05');
      stgSuppliers.ColWidths[5] := Reg.ReadInteger('FormProductCol06');
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

procedure TfrmProduct.SaveAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin
      Reg.WriteInteger('FormProductCol01', stgSuppliers.ColWidths[0]);
      Reg.WriteInteger('FormProductCol02', stgSuppliers.ColWidths[1]);
      Reg.WriteInteger('FormProductCol03', stgSuppliers.ColWidths[2]);
      Reg.WriteInteger('FormProductCol04', stgSuppliers.ColWidths[3]);
      Reg.WriteInteger('FormProductCol05', stgSuppliers.ColWidths[4]);
      Reg.WriteInteger('FormProductCol06', stgSuppliers.ColWidths[5]);
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

end.
