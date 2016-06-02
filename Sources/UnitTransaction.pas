(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitTransaction;

interface

uses SysUtils, StrUtils2, EncryptedFile, UnitSelection,
     UnitInventory, UnitGroup, UnitProduct;
                   
const
  TransExt = '.v3t';

{ Returned error codes of SaveToFile and LoadFromFile
  00 : No errors
  10 : Cannot open file
  12 : Wrong file type
  13 : Wrong file version
  14 : Write error
  15 : Read error }

type
  TFormType = (fNone, fQuotation, fOrder, fInvoice);
  TPaymentType = (pCash, pCredit, pDebit);
type
  TTransaction = class (TObject)
  private
    oSubTotal,
    oFederalTaxes,
    oStateTaxes,
    oFees,
    oTotal,
    oDeposit,
    oBalance : Single;
    oSelections : TSelectionList;    
  public
    FormType : TFormType;
    Date : TDateTime;
    QuotationNumber,
    OrderNumber,
    InvoiceNumber : Integer;
    EmployeeNumber,
    EmployeeName : string;
    ClientNumber,
    ClientName,
    ClientAddress,
    ClientTelephone,
    ClientEmail : string;
    RecipientNumber,
    RecipientName,
    RecipientAddress,
    RecipientTelephone,
    RecipientEmail : string;  
    PaymentType : TPaymentType;
    CreditCardNumber,
    CreditCardExp : string;
    Comments : string;

    constructor Create(FormType : TFormType = fNone; Date : TDateTime = 0);

    procedure Clear;
    procedure Calculate(FederalTaxValue, StateTaxValue, Fees, Deposit : Single);
    function Verification : Boolean;
    procedure SellProducts(CurDir : String);

    function SaveToFile(FileName : String) : Word;
    function LoadFromFile(FileName : String) : Word;
    function LoadHeaderFromFile(FileName : String) : Word;
  published
    property SubTotal : Single read oSubTotal;
    property FederalTaxes : Single read oFederalTaxes;
    property StateTaxes : Single read oStateTaxes;
    property Fees : Single read oFees;
    property Total : Single read oTotal;
    property Deposit : Single read oDeposit;
    property Balance : Single read oBalance;
    property Selections : TSelectionList read oSelections;
  end;

implementation

const
  FileType = 'VV3Transaction';   
  SuppFileType = 'VV3Operation';
  FileVersion = 101;
  Supported = 100;

  constructor TTransaction.Create(FormType : TFormType = fNone; Date : TDateTime = 0);
  begin
    oSelections := TSelectionList.Create;
    Clear;
    Self.FormType := FormType;
    Self.Date := Date;
  end;
                       
  procedure TTransaction.Clear;
  begin
    FormType := fNone;
    Date := 0;
    QuotationNumber := 0;
    OrderNumber := 0;
    InvoiceNumber := 0;
    EmployeeNumber := '';
		EmployeeName := '';
		ClientNumber := '';
		ClientName := '';
		ClientAddress := '';
		ClientTelephone := '';
		ClientEmail := '';
		RecipientNumber := '';
		RecipientName := '';
		RecipientAddress := '';
		RecipientTelephone := '';
		RecipientEmail := '';
    PaymentType := pCash;
    CreditCardNumber := '';
    CreditCardExp := '';
    oSubTotal := 0.0;
    oFederalTaxes := 0.0;
    oStateTaxes := 0.0;
    oFees := 0.0;
    oTotal := 0.0;
    oDeposit := 0.0;
    oBalance := 0.0;
    Comments := '';
    oSelections.Clear;
  end;

  procedure TTransaction.Calculate(FederalTaxValue, StateTaxValue, Fees, Deposit : Single);
  var
    TaxableTotal : Single;
    CurSelection : PSelection;
  begin
    oSubTotal := 0;
    TaxableTotal := 0;
    
    CurSelection := oSelections.First;
    while CurSelection <> nil do
    begin
      if not CurSelection.Descriptive then
      begin
        oSubTotal := oSubTotal + (CurSelection.Quantity * CurSelection.Price);
        if CurSelection.Taxed then
          TaxableTotal := TaxableTotal + (CurSelection.Quantity * CurSelection.Price);
      end;
      CurSelection := CurSelection.Next;
    end;
    oFederalTaxes := TaxableTotal*(FederalTaxValue/100);
    if StateTaxValue > 0 then
      oStateTaxes := (TaxableTotal+oFederalTaxes)*(StateTaxValue/100)
    else
      oStateTaxes := 0;
    oFees := Fees;
    oTotal := oSubTotal + oFederalTaxes + oStateTaxes;
    oDeposit := Deposit;
    oBalance := oTotal + oFees - oDeposit;
  end;
    
  function TTransaction.Verification : Boolean;
  begin
    Result := True;
    case FormType of
      fQuotation: if QuotationNumber < 1 then Result := False;
      fOrder: if OrderNumber < 1 then Result := False;
      fInvoice: if InvoiceNumber < 1 then Result := False;
      fNone: Result := False;
    end;
    if Date = 0 then
      Result := False;
    if (PaymentType = pCredit) and ((CreditCardNumber = '') or (CreditCardExp = '')) then
      Result := False;   
    if (EmployeeNumber = '') or (EmployeeName = '') then
      Result := False;
    if (ClientNumber = '') or (ClientName = '') then
      Result := False;
  end;
                            
  procedure TTransaction.SellProducts(CurDir : string);
  var
    CurInventory : TInventory;
    CurGroup : PGroup;
    CurProduct : PProduct;
    CurSelection : PSelection;
    CurFile : String;
  begin
    CurInventory := TInventory.Create;
    CurSelection := oSelections.First;
    while CurSelection <> nil do
    begin
      if CurInventory.Name <> CurSelection.Inventory then
      begin
        if CurFile <> '' then
          CurInventory.SaveToFile(CurFile);
        CurFile := CurDir+CurSelection.Inventory+InvExt;
        CurInventory.LoadFromFile(CurFile);
      end;
      if CurInventory.Name = CurSelection.Inventory then
      begin
        CurGroup := CurInventory.Groups.Get(CurSelection.Group);
        if CurGroup <> nil then
        begin
          CurProduct := CurGroup.Products.Get(CurSelection.Code);
          if CurProduct <> nil then
            CurProduct.Quantity := CurProduct.Quantity - CurSelection.Quantity;
        end;
      end;
      CurSelection := CurSelection.Next;
    end;
    CurInventory.SaveToFile(CurFile);
    CurInventory.Free;
  end;

  function TTransaction.SaveToFile(FileName : String) : Word;
  var
    CFile : TEncryptedFile;
  begin          
    CFile := TEncryptedFile.Create;
    try
      CFile.AssignFile(FileName);
      CFile.Rewrite;
    except   
      on Exception do begin
        CFile.Free;
        Result := 10;
        Exit;
      end;
    end;
    try
      { Writes file info }
      CFile.WriteString(FileType);
      CFile.WriteInteger(FileVersion);

      { Writes data }
      CFile.WriteInteger(Integer(FormType));
      CFile.WriteFloat(Date);
      CFile.WriteInteger(QuotationNumber);
      CFile.WriteInteger(OrderNumber);
      CFile.WriteInteger(InvoiceNumber);
      CFile.WriteString(EmployeeNumber);
      CFile.WriteString(EmployeeName);
      CFile.WriteString(ClientNumber);
      CFile.WriteString(ClientName);
		  CFile.WriteString(ClientAddress);
		  CFile.WriteString(ClientTelephone);
		  CFile.WriteString(ClientEmail);
		  CFile.WriteString(RecipientNumber);
		  CFile.WriteString(RecipientName);
		  CFile.WriteString(RecipientAddress);
		  CFile.WriteString(RecipientTelephone);
		  CFile.WriteString(RecipientEmail);
      CFile.WriteInteger(Integer(PaymentType));
      CFile.WriteString(CreditCardNumber);
      CFile.WriteString(CreditCardExp);
      CFile.WriteFloat(oSubTotal);
      CFile.WriteFloat(oFederalTaxes);
      CFile.WriteFloat(oStateTaxes);
      CFile.WriteFloat(oFees);
      CFile.WriteFloat(oTotal);
      CFile.WriteFloat(oDeposit);
      CFile.WriteFloat(oBalance);   
      CFile.WriteString(Comments);
      oSelections.WriteInFile(CFile);
      
      CFile.Free;
      Result := 00;
    except   
      on Exception do begin
        CFile.Free;
        Result := 14;
      end;
    end;
  end;

  function TTransaction.LoadFromFile(FileName : String) : Word;
  var
    CFile : TEncryptedFile;
    FType : string;
    Version : Integer;
  begin
    CFile := TEncryptedFile.Create;
    try
      CFile.AssignFile(FileName);
      CFile.Reset;
    except   
      on Exception do begin
        CFile.Free;
        Result := 10;
        Exit;
      end;
    end;
    try
      { Reads file info }
      FType := CFile.ReadString;
      if (FType <> FileType) and (FType <> SuppFileType) then
      begin
        Result := 12;
        Exit;
      end;          
      Version := CFile.ReadInteger;
      if not (Version in [Supported..FileVersion]) then
      begin
        Result := 13;
        Exit;
      end;

      { Reads data }
      FormType := TFormType(CFile.ReadInteger);
      Date := CFile.ReadFloat;
      QuotationNumber := CFile.ReadInteger;
      OrderNumber := CFile.ReadInteger;
      InvoiceNumber := CFile.ReadInteger;
      EmployeeNumber := CFile.ReadString;
      if Version >= 101 then
        EmployeeName := CFile.ReadString;
      ClientNumber := CFile.ReadString;
      if Version >= 101 then
      begin
        ClientName := CFile.ReadString;
	  	  ClientAddress := CFile.ReadString;
		    ClientTelephone := CFile.ReadString;
  		  ClientEmail := CFile.ReadString;
      end;
	    RecipientNumber := CFile.ReadString;
      if Version >= 101 then
      begin
  		  RecipientName := CFile.ReadString;
  		  RecipientAddress := CFile.ReadString;
  		  RecipientTelephone := CFile.ReadString;
  		  RecipientEmail := CFile.ReadString;
      end;
      PaymentType := TPaymentType(CFile.ReadInteger);
      CreditCardNumber := CFile.ReadString;
      CreditCardExp := CFile.ReadString;
      oSubTotal := CFile.ReadFloat;
      oFederalTaxes := CFile.ReadFloat;
      oStateTaxes := CFile.ReadFloat;
      oFees := CFile.ReadFloat;
      oTotal := CFile.ReadFloat;
      oDeposit := CFile.ReadFloat;
      oBalance := CFile.ReadFloat;   
      Comments := CFile.ReadString;

      oSelections.ReadInFile(CFile);
      CFile.Free;
      Result := 00;
    except   
      on Exception do begin
        CFile.Free;
        Result := 15;
      end;
    end;
  end;
    
  function TTransaction.LoadHeaderFromFile(FileName : String) : Word;
  var
    CFile : TEncryptedFile;
    FType : string;
    Version : Integer;
  begin      
    CFile := TEncryptedFile.Create;
    try
      CFile.AssignFile(FileName);
      CFile.Reset;
    except   
      on Exception do begin
        CFile.Free;
        Result := 10;
        Exit;
      end;
    end;
    try
      { Reads file info }
      FType := CFile.ReadString;
      if (FType <> FileType) and (FType <> SuppFileType) then
      begin
        Result := 12;
        Exit;
      end;
      Version := CFile.ReadInteger;
      if not (Version in [Supported..FileVersion]) then
      begin
        Result := 13;
        Exit;
      end;

      { Reads data }
      FormType := TFormType(CFile.ReadInteger);
      Date := CFile.ReadFloat;
      QuotationNumber := CFile.ReadInteger;
      OrderNumber := CFile.ReadInteger;
      InvoiceNumber := CFile.ReadInteger;
      EmployeeNumber := CFile.ReadString;
      if Version >= 101 then
        EmployeeName := CFile.ReadString;
      ClientNumber := CFile.ReadString;
      if Version >= 101 then
      begin
        ClientName := CFile.ReadString;
	  	  ClientAddress := CFile.ReadString;
		    ClientTelephone := CFile.ReadString;
  		  ClientEmail := CFile.ReadString;
      end;
	    RecipientNumber := CFile.ReadString;
      if Version >= 101then
      begin
  		  RecipientName := CFile.ReadString;
  		  RecipientAddress := CFile.ReadString;
  		  RecipientTelephone := CFile.ReadString;
  		  RecipientEmail := CFile.ReadString;
      end;
      PaymentType := TPaymentType(CFile.ReadInteger);
      CreditCardNumber := CFile.ReadString;
      CreditCardExp := CFile.ReadString;
      oSubTotal := CFile.ReadFloat;
      oFederalTaxes := CFile.ReadFloat;
      oStateTaxes := CFile.ReadFloat;
      oFees := CFile.ReadFloat;
      oTotal := CFile.ReadFloat;
      oDeposit := CFile.ReadFloat;
      oBalance := CFile.ReadFloat;
      Comments := CFile.ReadString;

      CFile.Free;
      Result := 00;
    except   
      on Exception do begin
        CFile.Free;
        Result := 15;
      end;
    end;
  end;

end.