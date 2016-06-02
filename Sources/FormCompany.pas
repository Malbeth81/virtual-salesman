(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormCompany;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes, Forms,
  ComCtrls, Dialogs, ExtDlgs, WinUtils, UnitMessages, UnitCompany;

type
  TfrmCompany = class(TForm)
    pgcCompany: TPageControl;
    tbsGeneral: TTabSheet;
    edtCompanyName: TEdit;
    lblLogo: TLabel;
    pnlLogo: TPanel;
    imgLogo: TImage;
    btnLoadLogo: TButton;
    lblCompanyInfo: TLabel;
    memCompanyInfo: TMemo;
    tbsMessages: TTabSheet;
    lblQuotation: TLabel;
    memQuotationMessage: TMemo;
    lblOrder: TLabel;
    memOrderMessage: TMemo;
    lblInvoice: TLabel;
    memInvoiceMessage: TMemo;
    tbsConfiguration: TTabSheet;
    grpTaxes: TGroupBox;
    lblTaxName: TLabel;
    lblTaxRate: TLabel;
    lblTaxNumber: TLabel;
    edtFederalTaxName: TEdit;
    edtFederalTaxValue: TEdit;
    edtFederalTaxNumber: TEdit;
    edtStateTaxName: TEdit;
    chkStateTax: TCheckBox;
    edtStateTaxValue: TEdit;
    edtStateTaxNumber: TEdit;
    grpDeposit: TGroupBox;
    edtDeposit: TEdit;
    lblDeposit2: TLabel;
    OpenPictureDialog: TOpenPictureDialog;
    btnOk: TButton;
    btnCancel: TButton;
    grpCurrency: TGroupBox;
    edtCurrencySign: TEdit;
    grpInvoices: TGroupBox;
    chkUnlockInvoices: TCheckBox;
    lblName: TLabel;
    lblDeposit1: TLabel;
    lblCurrency: TLabel;
    lblFederal1: TLabel;
    lblState1: TLabel;
    lblFederal2: TLabel;
    lblState2: TLabel;
    btnDeleteLogo: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoadLogoClick(Sender: TObject);
    procedure chkStateTaxClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnDeleteLogoClick(Sender: TObject); 
  public
    function Show : Boolean; reintroduce;
  end;

var
  frmCompany: TfrmCompany;

implementation

uses FormSave, FormMain;

{$R *.dfm}

procedure TfrmCompany.FormShow(Sender: TObject);
var
  i : Word;
begin
  with frmMain do
  begin
    edtCompanyName.Text := Company.Name;
    if FileExists(Company.FilesDir + '\logo.bmp') then
      imgLogo.Picture.LoadFromFile(Company.FilesDir + '\logo.bmp');
    memCompanyInfo.Lines.Clear;
    memCompanyInfo.Lines.Append(Company.InfoLine1);
    memCompanyInfo.Lines.Append(Company.InfoLine2);
    memCompanyInfo.Lines.Append(Company.InfoLine3);
    memCompanyInfo.Lines.Append(Company.InfoLine4);
    memCompanyInfo.Lines.Append(Company.InfoLine5);
    for i := memCompanyInfo.Lines.Count-1 downto 0 do
      if memCompanyInfo.Lines[i] = '' then
        memCompanyInfo.Lines.Delete(i);
    memQuotationMessage.Lines.Clear;
    memQuotationMessage.Lines.Append(Company.QuotationL1);
    memQuotationMessage.Lines.Append(Company.QuotationL2);
    memQuotationMessage.Lines.Append(Company.QuotationL3);
    memQuotationMessage.Lines.Append(Company.QuotationL4);
    for i := memQuotationMessage.Lines.Count-1 downto 0 do
      if memQuotationMessage.Lines[i] = '' then
        memQuotationMessage.Lines.Delete(i);
    memOrderMessage.Lines.Clear;
    memOrderMessage.Lines.Append(Company.OrderL1);
    memOrderMessage.Lines.Append(Company.OrderL2);
    memOrderMessage.Lines.Append(Company.OrderL3);
    memOrderMessage.Lines.Append(Company.OrderL4);
    for i := memOrderMessage.Lines.Count-1 downto 0 do
      if memOrderMessage.Lines[i] = '' then
        memOrderMessage.Lines.Delete(i);
    memInvoiceMessage.Lines.Clear;
    memInvoiceMessage.Lines.Append(Company.InvoiceL1);
    memInvoiceMessage.Lines.Append(Company.InvoiceL2);
    memInvoiceMessage.Lines.Append(Company.InvoiceL3);
    memInvoiceMessage.Lines.Append(Company.InvoiceL4);
    for i := memInvoiceMessage.Lines.Count-1 downto 0 do
      if memInvoiceMessage.Lines[i] = '' then
        memInvoiceMessage.Lines.Delete(i);
    edtFederalTaxName.Text := Company.FederalTaxName;
    edtFederalTaxValue.Text := FormatFloat('0.00', Company.FederalTaxValue);
    edtFederalTaxNumber.Text := Company.FederalTaxNumber;
    edtStateTaxName.Text := Company.StateTaxName;
    if Company.StateTaxValue > 0 then
    begin
      chkStateTax.Checked := True;
      edtStateTaxValue.Text := FormatFloat('0.00', Company.StateTaxValue);
    end
    else
    begin
      chkStateTax.Checked := False;
      edtStateTaxValue.Text := FormatFloat('0.00', 0);
    end;
    chkStateTax.OnClick(Self);
    edtStateTaxNumber.Text := Company.StateTaxNumber;
    edtDeposit.Text := IntToStr(Company.DepositValue);
    edtCurrencySign.Text := Company.CurrencySign;
    chkUnlockInvoices.Checked := not Company.LockInvoices;
    pgcCompany.ActivePageIndex := 0;
    edtCompanyName.SetFocus;
  end;
end;
         
procedure TfrmCompany.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edtCompanyName.Text := '';
  imgLogo.Picture := nil;
  memCompanyInfo.Lines.Clear;
  memQuotationMessage.Lines.Clear;
  memOrderMessage.Lines.Clear;
  memInvoiceMessage.Lines.Clear;
  edtFederalTaxName.Text := '';
  edtFederalTaxValue.Text := FormatFloat('0.00', 0);
  edtFederalTaxNumber.Text := '';
  edtStateTaxName.Text := '';
  edtStateTaxValue.Text := FormatFloat('0.00', 0);
  edtStateTaxNumber.Text := '';
  chkStateTax.Checked := False;
  chkStateTax.OnClick(frmCompany);
  edtDeposit.Text := '';
  edtCurrencySign.Text := '';
  chkUnlockInvoices.Checked := False;
end;
    
procedure TfrmCompany.btnLoadLogoClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
    imgLogo.Picture.LoadFromFile(OpenPictureDialog.FileName);
end;
   
procedure TfrmCompany.btnDeleteLogoClick(Sender: TObject);
begin
  if AskQuestion(3) = idYes then
    with frmMain do
    begin
      imgLogo.Picture := nil;
      if FileExists(Company.FilesDir + '\logo.bmp') then
        RecycleFile(Company.FilesDir + '\logo.bmp');
    end;
end;

procedure TfrmCompany.chkStateTaxClick(Sender: TObject);
begin
  lblState1.Enabled := chkStateTax.Checked;
  lblState2.Enabled := chkStateTax.Checked;
  edtStateTaxName.Enabled := chkStateTax.Checked;
  edtStateTaxValue.Enabled := chkStateTax.Checked;
  edtStateTaxNumber.Enabled := chkStateTax.Checked;
end;

procedure TfrmCompany.btnOkClick(Sender: TObject);
begin
  with frmMain do
  begin
    if not DirectoryExists(Company.FilesDir) then
      CreateDir(Company.FilesDir);
    Company.Name := edtCompanyName.Text;
    imgLogo.Picture.SaveToFile(Company.FilesDir + '\logo.bmp');
    Company.InfoLine1 := memCompanyInfo.Lines.Strings[0];
    Company.InfoLine2 := memCompanyInfo.Lines.Strings[1];
    Company.InfoLine3 := memCompanyInfo.Lines.Strings[2];
    Company.InfoLine4 := memCompanyInfo.Lines.Strings[3];
    Company.InfoLine5 := memCompanyInfo.Lines.Strings[4];
    Company.QuotationL1 := memQuotationMessage.Lines.Strings[0];
    Company.QuotationL2 := memQuotationMessage.Lines.Strings[1];
    Company.QuotationL3 := memQuotationMessage.Lines.Strings[2];
    Company.QuotationL4 := memQuotationMessage.Lines.Strings[3];
    Company.OrderL1 := memOrderMessage.Lines.Strings[0];
    Company.OrderL2 := memOrderMessage.Lines.Strings[1];
    Company.OrderL3 := memOrderMessage.Lines.Strings[2];
    Company.OrderL4 := memOrderMessage.Lines.Strings[3];
    Company.InvoiceL1 := memInvoiceMessage.Lines.Strings[0];
    Company.InvoiceL2 := memInvoiceMessage.Lines.Strings[1];
    Company.InvoiceL3 := memInvoiceMessage.Lines.Strings[2];
    Company.InvoiceL4 := memInvoiceMessage.Lines.Strings[3];
    Company.FederalTaxName := edtFederalTaxName.Text;
    Company.FederalTaxValue := StrToFloat(edtFederalTaxValue.Text);
    Company.FederalTaxNumber := edtFederalTaxNumber.Text;
    Company.StateTaxName := edtStateTaxName.Text;
    if not chkStateTax.Checked then
      Company.StateTaxValue := 0.00
    else
      Company.StateTaxValue := StrToFloat(edtStateTaxValue.Text);
    Company.StateTaxNumber := edtStateTaxNumber.Text;
    Company.DepositValue := StrToInt(edtDeposit.Text);
    Company.CurrencySign := edtCurrencySign.Text[1];
    Company.LockInvoices := not chkUnlockInvoices.Checked; 
    DisplayCompany;
    UpdateCaption;
    ModifiedCompany := True;
    Self.ModalResult := mrOk;
  end;
end;

function TfrmCompany.Show : Boolean;
begin
  Result := (ShowModal = mrOk);
end;

end.
