(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormTransaction;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, Dialogs, ComCtrls, Grids, StrUtils2, WinUtils,
  UnitMessages, UnitCompany, UnitEmployee, UnitClient, UnitTransaction;

type
  TfrmTransaction = class(TForm)
    pgcTransaction: TPageControl;
    tbsGeneral: TTabSheet;
    tbsClient: TTabSheet;
    tbsRecipient: TTabSheet;
    tbsPayment: TTabSheet;
    tbsComments: TTabSheet;
    memComments: TMemo;
    btnCancel: TButton;
    btnOk: TButton;
    lblSalesman: TLabel;
    lblTransType: TLabel;
    cmbFormType: TComboBox;
    edtDate: TEdit;
    btnDate: TButton;
    pnlDescType: TPanel;
    lblDescType: TLabel;
    edtQuotationNumber: TEdit;
    edtOrderNumber: TEdit;
    edtInvoiceNumber: TEdit;
    edtClientNumber: TEdit;
    edtClientName: TEdit;
    edtClientAddress: TEdit;
    edtClientTelephone: TEdit;
    edtClientEmail: TEdit;
    btnSelectClient: TButton;
    chkRecipient: TCheckBox;
    edtRecipientNumber: TEdit;
    edtRecipientName: TEdit;
    edtRecipientAddress: TEdit;
    edtRecipientTelephone: TEdit;
    edtRecipientEmail: TEdit;
    btnSelectRecipient: TButton;
    edtTotal: TEdit;
    lblPlus: TLabel;
    edtFees: TEdit;
    lblMulti: TLabel;
    lblPercent: TLabel;
    edtDepositValue: TEdit;
    btnDeposit: TButton;
    edtDeposit: TEdit;
    edtBalance: TEdit;
    lblEquation: TLabel;
    btnTotal: TButton;
    lblPaymentType: TLabel;
    cmbPaymentType: TComboBox;
    edtCreditNumber: TEdit;
    edtCreditExpiration: TEdit;
    lblClient: TLabel;
    lblDate: TLabel;
    lblQuotationNumber: TLabel;
    lblOrderNumber: TLabel;
    lblInvoiceNumber: TLabel;
    lblClientNumber: TLabel;
    lblClientName: TLabel;
    lblClientAddress: TLabel;
    lblClientTelephone: TLabel;
    lblClientEmail: TLabel;
    lblRecipientNumber: TLabel;
    lblRecipientName: TLabel;
    lblRecipientAddress: TLabel;
    lblRecipientTelephone: TLabel;
    lblRecipientEmail: TLabel;
    lblTotal: TLabel;
    lblFees: TLabel;
    lblDeposit: TLabel;
    lblBalance: TLabel;
    lblCreditNumber: TLabel;
    lblCreditExpiration: TLabel;
    edtSalesmanName: TEdit;
    btnSalesman: TButton;
    edtSalesmanNumber: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnSalesmanClick(Sender: TObject);
    procedure cmbFormTypeChange(Sender: TObject);
    procedure btnSelectClientClick(Sender: TObject);
    procedure btnSelectRecipientClick(Sender: TObject);
    procedure chkRecipientClick(Sender: TObject);
    procedure btnDateClick(Sender: TObject);
    procedure btnDepositClick(Sender: TObject);
    procedure btnTotalClick(Sender: TObject);
    procedure cmbPaymentTypeChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  public
    ChangedType : Boolean;
    function Show : Boolean; reintroduce;
    procedure SetDisabled(Value : Boolean);
  private
  	Disabled : Boolean;
  end;

var
  frmTransaction: TfrmTransaction;

implementation

uses FormClient, FormSelect, FormMain;

{$R *.dfm}

procedure TfrmTransaction.FormShow(Sender: TObject);
begin
  pgcTransaction.ActivePageIndex := 0;
  edtSalesmanNumber.Text := frmMain.Transaction.EmployeeNumber;
  edtSalesmanName.Text := frmMain.Transaction.EmployeeName;
  case frmMain.Transaction.FormType of
    fNone : cmbFormType.ItemIndex := -1;
    fQuotation : cmbFormType.ItemIndex := 0;
    fOrder : cmbFormType.ItemIndex := 1;
    fInvoice : cmbFormType.ItemIndex := 2;
  end;
  if not Disabled then
   cmbFormType.OnChange(Self);
  if frmMain.Transaction.Date = 0 then
    edtDate.Text := FormatDateTime('ddddd', Now)
  else
    edtDate.Text := FormatDateTime('ddddd', frmMain.Transaction.Date);
  edtQuotationNumber.Text := IntToStr(frmMain.Transaction.QuotationNumber);
  edtOrderNumber.Text := IntToStr(frmMain.Transaction.OrderNumber);
  edtInvoiceNumber.Text := IntToStr(frmMain.Transaction.InvoiceNumber);
  edtClientNumber.Text := frmMain.Transaction.ClientNumber;
  edtClientName.Text := frmMain.Transaction.ClientName;
  edtClientAddress.Text := frmMain.Transaction.ClientAddress;
  edtClientTelephone.Text := frmMain.Transaction.ClientTelephone;
  edtClientEmail.Text := frmMain.Transaction.ClientEmail;
  chkRecipient.Checked := (frmMain.Transaction.RecipientNumber <> '');
  if not Disabled then
    chkRecipient.OnClick(Self);
  edtRecipientNumber.Text := frmMain.Transaction.RecipientNumber;
  edtRecipientName.Text := frmMain.Transaction.RecipientName;
  edtRecipientAddress.Text := frmMain.Transaction.RecipientAddress;
  edtRecipientTelephone.Text := frmMain.Transaction.RecipientTelephone;
  edtRecipientEmail.Text := frmMain.Transaction.RecipientEmail;
  frmMain.Transaction.Calculate(frmMain.Company.FederalTaxValue, frmMain.Company.StateTaxValue, frmMain.Transaction.Fees, frmMain.Transaction.Deposit);
  edtTotal.Text := FormatFloat('0.00', frmMain.Transaction.Total);
  edtFees.Text := FormatFloat('0.00', frmMain.Transaction.Fees);
  edtDepositValue.Text := FormatFloat('0.00', frmMain.Company.DepositValue);
  edtDeposit.Text := FormatFloat('0.00', frmMain.Transaction.Deposit);
  edtBalance.Text := FormatFloat('0.00', frmMain.Transaction.Balance);
  case frmMain.Transaction.PaymentType of
    pCash : cmbPaymentType.ItemIndex := 0;
    pDebit : cmbPaymentType.ItemIndex := 1;
    pCredit : cmbPaymentType.ItemIndex := 2;
  end;
  if not Disabled then
    cmbPaymentType.OnChange(Self);
  edtCreditNumber.Text := frmMain.Transaction.CreditCardNumber;
  edtCreditExpiration.Text := frmMain.Transaction.CreditCardExp;
  memComments.Text := frmMain.Transaction.Comments;
end;

procedure TfrmTransaction.btnSalesmanClick(Sender: TObject);
begin
  if frmSelect.Show(mEmployees) then
  begin
    edtSalesmanNumber.Text := frmSelect.Number;
    edtSalesmanName.Text := frmSelect.Name;
  end;
end;

procedure TfrmTransaction.cmbFormTypeChange(Sender: TObject);
begin
  case cmbFormType.ItemIndex of
    -1: with frmMain do begin
      edtDeposit.ReadOnly := True;
      btnDeposit.Enabled := False;
      cmbPaymentType.ItemIndex := 0;
      cmbPaymentType.OnChange(cmbFormType);
      cmbPaymentType.Enabled := False;
    end;
    0: with frmMain do begin
      case Transaction.FormType of
        fOrder: begin
          cmbFormType.ItemIndex := 1;
          Exit;
        end;
        fInvoice: begin
          cmbFormType.ItemIndex := 2;
          Exit;
        end;
      end;
      lblDescType.Caption := Texts.Values['Desc0'];
      if Transaction.FormType <> fQuotation then
      begin
        edtQuotationNumber.Text := IntToStr(Company.QuotationNumber+1);
      	ChangedType := True;
      end
      else
        edtQuotationNumber.Text := IntToStr(Transaction.QuotationNumber);
      edtOrderNumber.Text := IntToStr(Transaction.OrderNumber);
      edtInvoiceNumber.Text := IntToStr(Transaction.InvoiceNumber);
      edtDeposit.Text := FormatFloat('0.00', 0);
      edtDeposit.ReadOnly := True;
      btnDeposit.Enabled := False;
      cmbPaymentType.ItemIndex := 0;
      cmbPaymentType.OnChange(cmbFormType);
      cmbPaymentType.Enabled := False;
    end;
    1: with frmMain do begin
      case Transaction.FormType of
        fInvoice: begin
          cmbFormType.ItemIndex := 2;
          Exit;
        end;
      end;
      lblDescType.Caption := Texts.Values['Desc1'];
      edtQuotationNumber.Text := IntToStr(Transaction.QuotationNumber);
      if Transaction.FormType <> fOrder then
      begin
        edtOrderNumber.Text := IntToStr(Company.OrderNumber+1);
       	ChangedType := True;
      end
      else
        edtOrderNumber.Text := IntToStr(Transaction.OrderNumber);
      edtInvoiceNumber.Text := IntToStr(Transaction.InvoiceNumber);
      edtDeposit.ReadOnly := False;
      btnDeposit.Enabled := True;
      cmbPaymentType.Enabled := True;
    end;
    2: with frmMain do begin           
      lblDescType.Caption := Texts.Values['Desc2'];
      edtQuotationNumber.Text := IntToStr(Transaction.QuotationNumber);
      edtOrderNumber.Text := IntToStr(Transaction.OrderNumber);
      if Transaction.FormType <> fInvoice then
      begin
        edtInvoiceNumber.Text := IntToStr(Company.InvoiceNumber+1);
       	ChangedType := True;
      end
      else
        edtInvoiceNumber.Text := IntToStr(Transaction.InvoiceNumber);
                         
      edtDeposit.ReadOnly := False;
      btnDeposit.Enabled := True;
      cmbPaymentType.Enabled := True;
    end;
  end;
end;
  
procedure TfrmTransaction.cmbPaymentTypeChange(Sender: TObject);
begin
  lblCreditNumber.Enabled := (cmbPaymentType.ItemIndex = 2);
  lblCreditExpiration.Enabled := (cmbPaymentType.ItemIndex = 2);
  edtCreditNumber.Enabled := (cmbPaymentType.ItemIndex = 2);
  edtCreditExpiration.Enabled := (cmbPaymentType.ItemIndex = 2);
end;

procedure TfrmTransaction.btnDateClick(Sender: TObject);
begin
  edtDate.Text := FormatDateTime('ddddd', Now);
end;

procedure TfrmTransaction.btnSelectClientClick(Sender: TObject);
begin
  if frmSelect.Show(mClients) then
  begin
    edtClientNumber.Text := frmSelect.Number;
    edtClientName.Text := frmSelect.Name;
    edtClientAddress.Text := frmSelect.Address;
    edtClientTelephone.Text := frmSelect.Telephone;
    edtClientEmail.Text := frmSelect.Email;
  end;
end;

procedure TfrmTransaction.chkRecipientClick(Sender: TObject);
begin
  if not Disabled then
  begin
    btnSelectRecipient.Enabled := chkRecipient.Checked;
    lblRecipientNumber.Enabled := chkRecipient.Checked;
    lblRecipientName.Enabled := chkRecipient.Checked;
    lblRecipientAddress.Enabled := chkRecipient.Checked;
    lblRecipientTelephone.Enabled := chkRecipient.Checked;
    lblRecipientEmail.Enabled := chkRecipient.Checked;
    edtRecipientNumber.Enabled := chkRecipient.Checked;
    edtRecipientName.Enabled := chkRecipient.Checked;
    edtRecipientAddress.Enabled := chkRecipient.Checked;
    edtRecipientTelephone.Enabled := chkRecipient.Checked;
    edtRecipientEmail.Enabled := chkRecipient.Checked;
  end;
end;

procedure TfrmTransaction.btnSelectRecipientClick(Sender: TObject);
begin
  if frmSelect.Show(mClients) then
  begin
    edtRecipientNumber.Text := frmSelect.Number;
    edtRecipientName.Text := frmSelect.Name;
    edtRecipientAddress.Text := frmSelect.Address;
    edtRecipientTelephone.Text := frmSelect.Telephone;
    edtRecipientEmail.Text := frmSelect.Email;
  end;
end;

procedure TfrmTransaction.btnDepositClick(Sender: TObject);
begin
  with frmMain do
  begin
    Transaction.Calculate(Company.FederalTaxValue, Company.StateTaxValue, StrToFloat(edtFees.Text), 0);
    if (cmbFormType.ItemIndex = 2) and (Transaction.OrderNumber = 0) then
      edtDeposit.Text := FormatFloat('0.00', Transaction.Total+Transaction.Fees)
    else
      edtDeposit.Text := FormatFloat('0.00', (Transaction.Total+Transaction.Fees)*(Company.DepositValue/100));
  end;
end;
   
procedure TfrmTransaction.btnTotalClick(Sender: TObject);
begin       
  with frmMain do
  begin
    Transaction.Calculate(Company.FederalTaxValue, Company.StateTaxValue, StrToFloat(edtFees.Text), StrToFloat(edtDeposit.Text));
    edtBalance.Text := FormatFloat('0.00', Transaction.Balance);
  end;
end;

procedure TfrmTransaction.btnOkClick(Sender: TObject);
begin
  if cmbPaymentType.ItemIndex < 0 then
    cmbPaymentType.ItemIndex := 0;
  if edtSalesmanNumber.Text = '' then
  begin
    ShowError(20);  { Must select a salesman }
    pgcTransaction.ActivePageIndex := 0;
    btnSalesman.SetFocus;
  end
  else with frmMain do
  begin
    Transaction.Calculate(Company.FederalTaxValue, Company.StateTaxValue, StrToFloat(edtFees.Text), StrToFloat(edtDeposit.Text));
    if (cmbFormType.ItemIndex > 0) and ((Transaction.Deposit-Transaction.Total*(Company.DepositValue/100)) < -0.01) then
    begin
      ShowError(16, IntToStr(Company.DepositValue));  { Deposit must be % of total }
      pgcTransaction.ActivePageIndex := 3;
    end
    else
    begin
      Transaction.EmployeeNumber := edtSalesmanNumber.Text;
      Transaction.EmployeeName := edtSalesmanName.Text;
      case cmbFormType.ItemIndex of
        -1: Transaction.FormType := fNone;
        0: Transaction.FormType := fQuotation;
        1: Transaction.FormType := fOrder;
        2: Transaction.FormType := fInvoice;
      end;
      Transaction.Date := StrToDate(edtDate.Text);
      Transaction.QuotationNumber := StrToInt(edtQuotationNumber.Text);
      Transaction.OrderNumber := StrToInt(edtOrderNumber.Text);
      Transaction.InvoiceNumber := StrToInt(edtInvoiceNumber.Text);
      Transaction.ClientNumber := edtClientNumber.Text;
      Transaction.ClientName := edtClientName.Text;
      Transaction.ClientAddress := edtClientAddress.Text;
      Transaction.ClientTelephone := edtClientTelephone.Text;
      Transaction.ClientEmail := edtClientEmail.Text;
      Transaction.RecipientNumber := edtRecipientNumber.Text;
      Transaction.RecipientName := edtRecipientName.Text;
      Transaction.RecipientAddress := edtRecipientAddress.Text;
      Transaction.RecipientTelephone := edtRecipientTelephone.Text;
      Transaction.RecipientEmail := edtRecipientEmail.Text;
      case cmbPaymentType.ItemIndex of
        0: Transaction.PaymentType := pCash;
        1: Transaction.PaymentType := pDebit;
        2: Transaction.PaymentType := pCredit;
      end;
      Transaction.CreditCardNumber := edtCreditNumber.Text;
      Transaction.CreditCardExp := edtCreditExpiration.Text;
      Transaction.Comments := memComments.Text;
      if Self.Enabled then
        ModifiedTransaction := True;
      Self.ModalResult := mrOk;
    end;
  end;
end;

function TfrmTransaction.Show : Boolean;
begin
  Result := (ShowModal = mrOk);
end;

procedure TfrmTransaction.SetDisabled(Value : Boolean);
begin
	Disabled := Value;
  lblSalesman.Enabled := not Value;
  edtSalesmanNumber.Enabled := not Value;
  edtSalesmanName.Enabled := not Value;
  btnSalesman.Enabled := not Value;
	cmbFormType.Enabled := not Value;
  edtDate.ReadOnly := Value;
  btnDate.Enabled := not Value;
  btnSelectClient.Enabled := not Value;
  chkRecipient.Enabled := not Value;
  btnSelectRecipient.Enabled := not Value;
  edtRecipientNumber.ReadOnly := Value;
  edtRecipientName.ReadOnly := Value;
  edtRecipientAddress.ReadOnly := Value;
  edtRecipientTelephone.ReadOnly := Value;
  edtRecipientEmail.ReadOnly := Value;
  edtFees.ReadOnly := Value;
  edtDeposit.ReadOnly := Value;
  btnDeposit.Enabled := not Value;
  lblPaymentType.Enabled := not Value;
  cmbPaymentType.Enabled := not Value;
  edtCreditNumber.ReadOnly := Value;
  edtCreditExpiration.ReadOnly := Value;
  memComments.Enabled := not Value;
  btnOk.Enabled := not Value;
end;

end.
