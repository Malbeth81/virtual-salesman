(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormClient;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes, Forms,
  Grids, ComCtrls, Registry, WinUtils, UnitMessages, UnitCompany, UnitClient,
  UnitTransaction, UnitSelection;

type
  TMode = (mAdd, mEdit);
  TfrmClient = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    pgcClient: TPageControl;
    tbsInfo: TTabSheet;
    tbsTransactions: TTabSheet;
    tbsProducts: TTabSheet;
    edtOther: TEdit;
    edtTelephone: TEdit;
    edtEmail: TEdit;
    edtAddress: TEdit;
    edtName: TEdit;
    edtNumber: TEdit;
    btnNumber: TButton;
    lblNumber2: TLabel;
    stgTransactions: TStringGrid;
    stgProducts: TStringGrid;
    tabTransType: TTabControl;
    btnOpenTransaction: TButton;
    lblNumber1: TLabel;
    lblName: TLabel;
    lblAddress: TLabel;
    lblTelephone: TLabel;
    lblOther: TLabel;
    lblEmail: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tabTransTypeChange(Sender: TObject);
    procedure pgcClientChange(Sender: TObject);
    procedure btnOpenTransactionClick(Sender: TObject);
    procedure btnNumberClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  public
    function Show(Mode : TMode) : Boolean; reintroduce;
    procedure DisplayTransactions;
    procedure DisplayProducts;
    procedure LoadAppearance;
    procedure SaveAppearance;
  private
    Mode : TMode;
    Transactions : TStrings;
  end;

var
  frmClient: TfrmClient;

implementation

uses FormMain;

{$R *.dfm}
             
procedure TfrmClient.FormCreate(Sender: TObject);
begin
  Transactions := TStringList.Create;
  LoadAppearance;
  stgTransactions.Rows[0].Text := 'Number'+#13#10+'Date'+#13#10+'Salesman'+#13#10+'Payment'+#13#10+'Deposit'+#13#10+'Balance'+#13#10+'Comment';
  stgProducts.Rows[0].Text := 'Code'+#13#10+'Name'+#13#10+'Price paid'+#13#10+'Qty'+#13#10+'Inventory'+#13#10+'Group';
end;
    
procedure TfrmClient.FormDestroy(Sender: TObject);
begin
  Transactions.Free;
end;

procedure TfrmClient.FormShow(Sender: TObject);
var
  Client : PClient;
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
    Client := frmMain.Company.Clients.Get(frmMain.stgClients.Row);
    if Client <> nil then
    begin
      lblNumber1.Enabled := False;
      edtNumber.Enabled := False;
      btnNumber.Enabled := False;
      edtNumber.Text := Client.Number;
      edtName.Text := Client.Name;
      edtAddress.Text := Client.Address;
      edtTelephone.Text := Client.Telephone;
      edtEmail.Text := Client.Email;
      edtOther.Text := Client.Other;
    end;
  end;
  pgcClient.ActivePageIndex := 0;
  edtName.SetFocus;
end;

procedure TfrmClient.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edtNumber.Text := '';
  edtName.Text := '';
  edtAddress.Text := '';
  edtTelephone.Text := '';
  edtEmail.Text := '';
  edtOther.Text := ''; 
  SaveAppearance;
end;
          
procedure TfrmClient.pgcClientChange(Sender: TObject);
begin
  case pgcClient.ActivePageIndex of
    1: DisplayTransactions;
    2: DisplayProducts;
  end;
end;

procedure TfrmClient.btnNumberClick(Sender: TObject);
begin
  edtNumber.Text := '';
  if frmMain.Company.Clients.Size < 99 then
    edtNumber.Text := edtNumber.Text + '0';
  if frmMain.Company.Clients.Size < 9 then
    edtNumber.Text := edtNumber.Text + '0';
  edtNumber.Text := edtNumber.Text + IntToStr(frmMain.Company.Clients.Size+1);
end;
                 
procedure TfrmClient.tabTransTypeChange(Sender: TObject);
begin
  DisplayTransactions;
end;
                 
procedure TfrmClient.btnOpenTransactionClick(Sender: TObject);
begin
  Self.Close;
  frmMain.OpenTransaction(Transactions[stgTransactions.Row-1]);
end;

procedure TfrmClient.btnOkClick(Sender: TObject);
begin
  if edtNumber.Text = '' then
  begin
    ShowError(8); { Must enter a number }
    edtNumber.SetFocus;
  end
  else with frmMain do
    case Mode of
      mAdd:
        if not Company.Clients.Add(edtNumber.Text, edtName.Text, edtAddress.Text, edtTelephone.Text, edtEmail.Text, edtOther.Text) then
          ShowError(11) { Number already used }
        else
        begin
          DisplayClients;
          StringGridSelect(stgClients, 0, edtNumber.Text);
          ModifiedCompany := True;
          Self.ModalResult := mrOk;
        end;
      mEdit:
        if not Company.Clients.Modify(edtNumber.Text, edtName.Text, edtAddress.Text, edtTelephone.Text, edtEmail.Text, edtOther.Text) then
          ShowError(11) { Number already used }
        else
        begin
          DisplayClients;
          ModifiedCompany := True;
          Self.ModalResult := mrOk;
        end;
    end;
end;

function TfrmClient.Show(Mode : TMode) : Boolean;
begin
  Self.Mode := Mode;
  Result := (ShowModal = mrOk);
end;

procedure TfrmClient.DisplayTransactions;
var
  Client : PClient;
  FileName : string;
  FileInfo : TSearchRec;
  Transaction : TTransaction;
  Index : Word;
begin
  Cursor := crHourglass;
  Transaction := TTransaction.Create;
  Transactions.Clear;
  Client := frmMain.Company.Clients.Get(frmMain.stgClients.Row);
  if (Client <> nil) and (frmMain.Company.TransDir <> '') then
  try
    Index := 1;
    case tabTransType.TabIndex of
      0 : FileName := frmMain.Company.TransDir+'Q*'+TransExt;
      1 : FileName := frmMain.Company.TransDir+'O*'+TransExt;
      2 : FileName := frmMain.Company.TransDir+'I*'+TransExt;
    end;
    if FindFirst(FileName, faAnyFile, FileInfo) = 0 then
    begin
      repeat
        if ((FileInfo.Attr and faDirectory) = 0) and (Transaction.LoadFromFile(frmMain.Company.TransDir+FileInfo.Name) = 0) then
          if Transaction.ClientNumber = Client.Number then
          begin
            Transactions.Add(frmMain.Company.TransDir+FileInfo.Name);
            if Index >= stgTransactions.RowCount then
              stgTransactions.RowCount := Index+1;
            case tabTransType.TabIndex of
              0: stgTransactions.Cells[0, Index] := IntToStr(Transaction.QuotationNumber);
              1: stgTransactions.Cells[0, Index] := IntToStr(Transaction.OrderNumber);
              2: stgTransactions.Cells[0, Index] := IntToStr(Transaction.InvoiceNumber);
            end;
            stgTransactions.Cells[1, Index] := FormatDateTime('dddddd', Transaction.Date);
            stgTransactions.Cells[2, Index] := Transaction.EmployeeNumber + ' - ' + Transaction.EmployeeName;
            case Transaction.PaymentType of
              pCash: stgTransactions.Cells[3, Index] := frmMain.Texts.Values['Pay0'];
              pCredit: stgTransactions.Cells[3, Index] := frmMain.Texts.Values['Pay1'];
              pDebit: stgTransactions.Cells[3, Index] := frmMain.Texts.Values['Pay2'];
            end;
            stgTransactions.Cells[4, Index] := FormatFloat('0.00 ' + frmMain.Company.CurrencySign, Transaction.Deposit);
            stgTransactions.Cells[5, Index] := FormatFloat('0.00 ' + frmMain.Company.CurrencySign, Transaction.Total);
            stgTransactions.Cells[6, Index] := Transaction.Comments;
            Index := Index +1;
          end;
      until FindNext(FileInfo) <> 0;
      SysUtils.FindClose(FileInfo);
    end;
    if Index < 2 then
    begin
      stgTransactions.RowCount := 2;
      stgTransactions.Rows[1].Clear;
    end;
  finally
    Transaction.Free;
    Cursor := crDefault;
  end;
end;
                                 
procedure TfrmClient.DisplayProducts;
var
  Client : PClient;
  FileInfo : TSearchRec;
  Transaction : TTransaction;
  CurSelection : PSelection;
  i : Integer;
begin
  Cursor := crHourglass;
  Transaction := TTransaction.Create;
  Client := frmMain.Company.Clients.Get(frmMain.stgClients.Row);
  if (Client <> nil) and (frmMain.Company.FilesDir <> '') then
  try
    stgProducts.RowCount := 2;
    stgProducts.Rows[1].Clear;
    if FindFirst(frmMain.Company.TransDir+'I*'+TransExt, faAnyFile, FileInfo) = 0 then
    begin
      repeat
        if ((FileInfo.Attr and faDirectory) = 0) and (Transaction.LoadFromFile(frmMain.Company.TransDir+FileInfo.Name) = 0) then
          if Transaction.ClientNumber = Client.Number then
          begin
            CurSelection := Transaction.Selections.First;
            while CurSelection <> nil do
            begin
              i := stgProducts.Cols[0].IndexOf(CurSelection.Code);
              if (i >= 0) and (stgProducts.Cells[1, i] = CurSelection.Name) then
                stgProducts.Cells[3, i] := IntToStr(StrToInt(stgProducts.Cells[3, i])+1)
              else
              begin
                if stgProducts.Cells[0, stgProducts.RowCount-1] <> '' then
                  stgProducts.RowCount := stgProducts.RowCount+1;
                stgProducts.Cells[0, stgProducts.RowCount-1] := CurSelection.Code;
                stgProducts.Cells[1, stgProducts.RowCount-1] := CurSelection.Name;
                stgProducts.Cells[2, stgProducts.RowCount-1] := FormatFloat('0.00 ' + frmMain.Company.CurrencySign, CurSelection.Price);
                stgProducts.Cells[3, stgProducts.RowCount-1] := '1';
                stgProducts.Cells[4, stgProducts.RowCount-1] := CurSelection.Inventory;
                stgProducts.Cells[5, stgProducts.RowCount-1] := CurSelection.Group;
              end;
              CurSelection := CurSelection.Next;
            end;
          end;
      until FindNext(FileInfo) <> 0;
      SysUtils.FindClose(FileInfo);
    end;
  finally
    Transaction.Free;
    Cursor := crDefault;
  end;
end;
                     
procedure TfrmClient.LoadAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin
      stgTransactions.ColWidths[0] := Reg.ReadInteger('FormClientCol01');
      stgTransactions.ColWidths[1] := Reg.ReadInteger('FormClientCol02');
      stgTransactions.ColWidths[2] := Reg.ReadInteger('FormClientCol03');
      stgTransactions.ColWidths[3] := Reg.ReadInteger('FormClientCol04');
      stgTransactions.ColWidths[4] := Reg.ReadInteger('FormClientCol05');
      stgTransactions.ColWidths[5] := Reg.ReadInteger('FormClientCol06');
      stgTransactions.ColWidths[6] := Reg.ReadInteger('FormClientCol07');
      stgProducts.ColWidths[0] := Reg.ReadInteger('FormClientCol11');
      stgProducts.ColWidths[1] := Reg.ReadInteger('FormClientCol12');
      stgProducts.ColWidths[2] := Reg.ReadInteger('FormClientCol13');
      stgProducts.ColWidths[3] := Reg.ReadInteger('FormClientCol14');
      stgProducts.ColWidths[4] := Reg.ReadInteger('FormClientCol15');
      stgProducts.ColWidths[5] := Reg.ReadInteger('FormClientCol16');
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

procedure TfrmClient.SaveAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin
      Reg.WriteInteger('FormClientCol01', stgTransactions.ColWidths[0]);  
      Reg.WriteInteger('FormClientCol02', stgTransactions.ColWidths[1]);
      Reg.WriteInteger('FormClientCol03', stgTransactions.ColWidths[2]);
      Reg.WriteInteger('FormClientCol04', stgTransactions.ColWidths[3]);
      Reg.WriteInteger('FormClientCol05', stgTransactions.ColWidths[4]);
      Reg.WriteInteger('FormClientCol06', stgTransactions.ColWidths[5]);
      Reg.WriteInteger('FormClientCol07', stgTransactions.ColWidths[6]);
      Reg.WriteInteger('FormClientCol11', stgProducts.ColWidths[0]);   
      Reg.WriteInteger('FormClientCol12', stgProducts.ColWidths[1]);
      Reg.WriteInteger('FormClientCol13', stgProducts.ColWidths[2]);
      Reg.WriteInteger('FormClientCol14', stgProducts.ColWidths[3]);
      Reg.WriteInteger('FormClientCol15', stgProducts.ColWidths[4]);
      Reg.WriteInteger('FormClientCol16', stgProducts.ColWidths[5]);
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

end.
