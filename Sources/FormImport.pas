unit FormImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Math, UnitImport, UnitMessages;

type
  TMode = (mProducts, mEmployees, mClients, mSuppliers);
  TfrmImport = class(TForm)
    stgImport: TStringGrid;
    lblSelect: TLabel;
    cmbValue1: TComboBox;
    lblNumber: TLabel;
    cmbValue2: TComboBox;
    lblName: TLabel;
    cmbValue3: TComboBox;
    lblAddress: TLabel;
    cmbValue4: TComboBox;
    lblTelephone: TLabel;
    cmbValue5: TComboBox;
    lblEmail: TLabel;
    cmbValue6: TComboBox;
    lblOther: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    lblCode: TLabel;
    lblCost: TLabel;
    lblPrice: TLabel;
    lblURL: TLabel;
    lblQuantity: TLabel;
    lblFilename: TLabel;
    edtFilename: TEdit;
    btnBrowse: TButton;
    lblSeparator: TLabel;
    cmbSeparator: TComboBox;
    lblDelimiter: TLabel;
    cmbDelimiter: TComboBox;
    btnImport: TButton;
    dlgImport: TOpenDialog;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
  public
    function Show(Mode : TMode) : Boolean; reintroduce;
    procedure DisplayData;
    function GetValues(Row : PRow) : string;
  private
    Mode : TMode;
    Import : TImport;
  end;

var
  frmImport: TfrmImport;

implementation

uses FormMain;

{$R *.dfm}
    
procedure TfrmImport.FormShow(Sender: TObject);
begin
  lblNumber.Visible := not (Mode = mProducts);
  lblCode.Visible := (Mode = mProducts);
  lblAddress.Visible := not (Mode = mProducts);
  lblCost.Visible := (Mode = mProducts);      
  lblTelephone.Visible := not (Mode = mProducts);
  lblPrice.Visible := (Mode = mProducts);      
  lblEmail.Visible := not (Mode = mProducts);
  lblQuantity.Visible := (Mode = mProducts);      
  lblOther.Visible := not (Mode = mProducts);
  lblURL.Visible := (Mode = mProducts);
  btnOk.Enabled := False;
end;

procedure TfrmImport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Import.Free;
  Import := nil;
  edtFileName.Text := ''; 
  stgImport.ColCount := 1;
  stgImport.RowCount := 2;
  stgImport.Rows[1].Clear;
end;

procedure TfrmImport.btnBrowseClick(Sender: TObject);
begin
  if dlgImport.Execute then
    edtFilename.Text := dlgImport.Filename;
end;

procedure TfrmImport.btnImportClick(Sender: TObject);
begin
  if edtFilename.Text <> '' then
  begin
    Import := TImport.Create(edtFileName.Text, cmbDelimiter.Text[1], cmbSeparator.Text[1]);
    DisplayData;
    btnOk.Enabled := (Import.RowCount > 0);
  end;
end;

procedure TfrmImport.btnOkClick(Sender: TObject);
var
  Row : PRow;
  Values : TStringList;
begin
  Values := TStringList.Create;
  if cmbValue1.ItemIndex < 1 then
  begin
    ShowError(23);
    cmbValue1.SetFocus;
  end
  else if Mode = mProducts then with frmMain do
  begin
    if Group <> nil then
    begin
      Row := Import.FirstRow;
      while Row <> nil do
      begin
        Values.Text := GetValues(Row);
        Group.Products.Add(Values[0], Values[1], Values[5], StrToFloat(Values[2]), StrToFloat(Values[3]), StrToInt(Values[4]), True, '');
        Row := Row.Next;
      end;
      DisplayProducts;
      Self.ModalResult := mrOk;
    end;
  end
  else with frmMain do
  begin
    if Company <> nil then
    begin
      Row := Import.FirstRow;
      while Row <> nil do
      begin
        Values.Text := GetValues(Row);
        case Mode of
          mEmployees: Company.Employees.Add(Values[0], Values[1], Values[2], Values[3], Values[4], Values[5]);
          mClients: Company.Clients.Add(Values[0], Values[1], Values[2], Values[3], Values[4], Values[5]);
          mSuppliers: Company.Suppliers.Add(Values[0], Values[1], Values[2], Values[3], Values[4], Values[5]);
        end;
        Row := Row.Next;
      end;
      case Mode of
        mEmployees: DisplayEmployees;
        mClients: DisplayClients;
        mSuppliers: DisplaySuppliers;
      end;
      Self.ModalResult := mrOk;
    end;
  end;
  Values.Free;
end;

function TfrmImport.Show(Mode : TMode) : Boolean;
begin
  Self.Mode := Mode;
  Result := (ShowModal = mrOk);
end;

procedure TfrmImport.DisplayData;
var
  Row : PRow;
  i, j : Integer;
begin
  stgImport.ColCount := 1;
  stgImport.RowCount := 2;
  stgImport.Rows[1].Clear;
  cmbValue1.Items.Clear;
  cmbValue2.Items.Clear;
  cmbValue3.Items.Clear;
  cmbValue4.Items.Clear;
  cmbValue5.Items.Clear;
  cmbValue6.Items.Clear;
  if Import.RowCount > 0 then
  begin
    i := 0;
    stgImport.RowCount := Import.RowCount+1;
    Row := Import.FirstRow;
    while Row <> nil do
    begin
      if Length(Row.Field) > stgImport.ColCount then
        stgImport.ColCount := Length(Row.Field);
      for j := 0 to Length(Row.Field)-1 do
        stgImport.Cells[j, i+1] := Row.Field[j];
      Row := Row.Next;
      Inc(i);
    end;
    for i := 0 to stgImport.ColCount-1 do
      stgImport.Cells[i, 0] := IntToStr(i+1);
    cmbValue1.Items.Text := '0'+#13#10+stgImport.Rows[0].Text;
    cmbValue2.Items.Text := cmbValue1.Items.Text;
    cmbValue3.Items.Text := cmbValue1.Items.Text;
    cmbValue4.Items.Text := cmbValue1.Items.Text;
    cmbValue5.Items.Text := cmbValue1.Items.Text;
    cmbValue6.Items.Text := cmbValue1.Items.Text;   
    cmbValue1.ItemIndex := 0;
    cmbValue2.ItemIndex := 0;
    cmbValue3.ItemIndex := 0;
    cmbValue4.ItemIndex := 0;
    cmbValue5.ItemIndex := 0;
    cmbValue6.ItemIndex := 0;
  end;
end;

function TfrmImport.GetValues(Row : PRow) : string;
begin
  Result := '';
  if cmbValue1.ItemIndex > 0 then
    Result := Result+Row.Field[cmbValue1.ItemIndex-1];
  Result := Result+#13#10;
  if cmbValue2.ItemIndex > 0 then
    Result := Result+Row.Field[cmbValue2.ItemIndex-1];
  Result := Result+#13#10;
  if cmbValue3.ItemIndex > 0 then
    Result := Result+Row.Field[cmbValue3.ItemIndex-1]
  else if Mode = mProducts then
    Result := Result+'0';
  Result := Result+#13#10;
  if cmbValue4.ItemIndex > 0 then
    Result := Result+Row.Field[cmbValue4.ItemIndex-1]
  else if Mode = mProducts then
    Result := Result+'0';
  Result := Result+#13#10;
  if cmbValue5.ItemIndex > 0 then
    Result := Result+Row.Field[cmbValue5.ItemIndex-1]
  else if Mode = mProducts then
    Result := Result+'0';
  Result := Result+#13#10;
  if cmbValue6.ItemIndex > 0 then
    Result := Result+Row.Field[cmbValue6.ItemIndex-1];
  Result := Result+#13#10;
end;

end.
