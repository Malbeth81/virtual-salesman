(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitCompany;

interface
uses SysUtils, EncryptedFile, UnitEmployee, UnitClient, UnitSupplier;

const
  CieExt = '.vs3';

{ Returned error codes of SaveToFile and LoadFromFile
  00 : No errors
  10 : Cannot open file
  12 : Wrong file type
  13 : Wrong file version
  14 : Write error
  15 : Read error }

type
  TCompany = class (TObject)
  private        
    cFileName : string;
    cFilesDir : string;
    cTransDir : string;
    cName,
    cInfoLine1,
    cInfoLine2,
    cInfoLine3,
    cInfoLine4,
    cInfoLine5 : string;
    cQuotationL1,
    cQuotationL2,
    cQuotationL3, 
    cQuotationL4,
    cOrderL1,
    cOrderL2,
    cOrderL3,
    cOrderL4,
    cInvoiceL1,
    cInvoiceL2,
    cInvoiceL3,
    cInvoiceL4 : string;    
    cFederalTaxName,
    cStateTaxName : string;
    cFederalTaxValue,
    cStateTaxValue : Single;
    cFederalTaxNumber,
    cStateTaxNumber : string;
    cDepositValue : Integer;    
    cCurrencySign : Char;
    cLockInvoices : Boolean;
    cQuotationNumber,
    cOrderNumber,
    cInvoiceNumber : Cardinal;
    cEmployees : TEmployeeList;
    cClients : TClientList;
    cSuppliers : TSupplierList; 
  published                
    property FileName : String read cFileName write cFileName;
    property FilesDir : String read cFilesDir write cFilesDir;
    property TransDir : String read cTransDir write cTransDir;
    property Name : String read cName write cName;
    property InfoLine1 : String read cInfoLine1 write cInfoLine1;
    property InfoLine2 : String read cInfoLine2 write cInfoLine2;
    property InfoLine3 : String read cInfoLine3 write cInfoLine3;
    property InfoLine4 : String read cInfoLine4 write cInfoLine4;
    property InfoLine5 : String read cInfoLine5 write cInfoLine5;
    property QuotationL1 : String read cQuotationL1 write cQuotationL1;
    property QuotationL2 : String read cQuotationL2 write cQuotationL2;
    property QuotationL3 : String read cQuotationL3 write cQuotationL3; 
    property QuotationL4 : String read cQuotationL4 write cQuotationL4;
    property OrderL1 : String read cOrderL1 write cOrderL1;
    property OrderL2 : String read cOrderL2 write cOrderL2;
    property OrderL3 : String read cOrderL3 write cOrderL3; 
    property OrderL4 : String read cOrderL4 write cOrderL4;
    property InvoiceL1 : String read cInvoiceL1 write cInvoiceL1;
    property InvoiceL2 : String read cInvoiceL2 write cInvoiceL2;
    property InvoiceL3 : String read cInvoiceL3 write cInvoiceL3; 
    property InvoiceL4 : String read cInvoiceL4 write cInvoiceL4;      
    property FederalTaxName : String read cFederalTaxName write cFederalTaxName;
    property StateTaxName : String read cStateTaxName write cStateTaxName;
    property FederalTaxValue : Single read cFederalTaxValue write cFederalTaxValue;
    property StateTaxValue : Single read cStateTaxValue write cStateTaxValue;
    property FederalTaxNumber : String read cFederalTaxNumber write cFederalTaxNumber;
    property StateTaxNumber : String read cStateTaxNumber write cStateTaxNumber;
    property DepositValue : Integer read cDepositValue write cDepositValue;
    property CurrencySign : Char read cCurrencySign write cCurrencySign;   
    property LockInvoices : Boolean read cLockInvoices write cLockInvoices;
    property QuotationNumber : Cardinal read cQuotationNumber write cQuotationNumber;
    property OrderNumber : Cardinal read cOrderNumber write cOrderNumber;
    property InvoiceNumber : Cardinal read cInvoiceNumber write cInvoiceNumber;
    property Employees : TEmployeeList read cEmployees;
    property Clients : TClientList read cClients;
    property Suppliers : TSupplierList read cSuppliers;
  public
    constructor Create(Name : String = '');  
    destructor Destroy; override;

    procedure Clear;
    procedure SetFileName(FileName : string);
    function SaveToFile(FileName : String) : Word;
    function LoadFromFile(FileName : String) : Word;
    function LoadHeaderFromFile(FileName : String) : Word;
  end;

implementation
           
const
  FileType = 'VV3Company';
  FileVersion = 105;
  Supported = 101;

  constructor TCompany.Create(Name : String = '');
  begin
    cEmployees := TEmployeeList.Create;
    cClients := TClientList.Create;
    cSuppliers := TSupplierList.Create;
    Clear();
    cName := Name;
  end;
               
  destructor TCompany.Destroy;
  begin
    cEmployees.Free;
    cClients.Free;
    cSuppliers.Free;
    inherited Destroy;
  end;

  procedure TCompany.Clear;
  begin             
    cFileName := '';
    cFilesDir := '';   
    cTransDir := '';
    cName := '';
    cInfoLine1 := '';
    cInfoLine2 := '';
    cInfoLine3 := '';
    cInfoLine4 := '';
    cInfoLine5 := '';
    cQuotationL1 := '';
    cQuotationL2 := '';
    cQuotationL3 := '';
    cQuotationL4 := '';
    cOrderL1 := '';
    cOrderL2 := '';
    cOrderL3 := '';
    cOrderL4 := '';
    cInvoiceL1 := '';
    cInvoiceL2 := '';
    cInvoiceL3 := '';
    cInvoiceL4 := '';
    cFederalTaxName := '';
    cStateTaxName := '';
    cFederalTaxValue := 0;
    cStateTaxValue := 0;
    cFederalTaxNumber := '';
    cStateTaxNumber := '';
    cDepositValue := 0;
    cCurrencySign := '$';  
    cLockInvoices := True;
    cQuotationNumber := 100;
    cOrderNumber := 100;
    cInvoiceNumber := 100;
    cEmployees.Clear;
    cClients.Clear;
    cSuppliers.Clear;
  end;

  procedure TCompany.SetFileName(FileName : string);
  begin
    cFileName := FileName;
    cFilesDir := ExtractFilePath(FileName)+'\';
    cTransDir := cFilesDir+'Transactions\';
  end;

  function TCompany.SaveToFile(FileName : String) : Word;
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
      CFile.WriteString(cName);
      CFile.WriteString(cInfoLine1);
      CFile.WriteString(cInfoLine2);
      CFile.WriteString(cInfoLine3);
      CFile.WriteString(cInfoLine4);
      CFile.WriteString(cInfoLine5);
      CFile.WriteString(cFederalTaxName);
      CFile.WriteString(cStateTaxName);
      CFile.WriteFloat(cFederalTaxValue);
      CFile.WriteFloat(cStateTaxValue);
      CFile.WriteString(cFederalTaxNumber);
      CFile.WriteString(cStateTaxNumber);
      CFile.WriteInteger(cDepositValue);
      CFile.WriteString(cCurrencySign);
      CFile.WriteBool(cLockInvoices);
      CFile.WriteString(cQuotationL1);
      CFile.WriteString(cQuotationL2);
      CFile.WriteString(cQuotationL3); 
      CFile.WriteString(cQuotationL4);
      CFile.WriteString(cOrderL1);
      CFile.WriteString(cOrderL2);
      CFile.WriteString(cOrderL3); 
      CFile.WriteString(cOrderL4);
      CFile.WriteString(cInvoiceL1);
      CFile.WriteString(cInvoiceL2);
      CFile.WriteString(cInvoiceL3); 
      CFile.WriteString(cInvoiceL4);
      CFile.WriteInteger(QuotationNumber);
      CFile.WriteInteger(OrderNumber);
      CFile.WriteInteger(InvoiceNumber);
      cEmployees.WriteInFile(CFile);
      cClients.WriteInFile(CFile);
      cSuppliers.WriteInFile(CFile);

      CFile.Free;
      Result := 00;
    except
      on Exception do begin
        CFile.Free;
        Result := 14;
      end;
    end;
  end;

  function TCompany.LoadFromFile(FileName : String) : Word;
  var
    CFile : TEncryptedFile;
    Version : Integer;
  begin
    SetFileName(FileName);
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
      if CFile.ReadString <> FileType then
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
      cName := CFile.ReadString;
      cInfoLine1 := CFile.ReadString;
      cInfoLine2 := CFile.ReadString;
      cInfoLine3 := CFile.ReadString;
      cInfoLine4 := CFile.ReadString;
      cInfoLine5 := CFile.ReadString;
      cFederalTaxName := CFile.ReadString;
      cStateTaxName := CFile.ReadString;
      cFederalTaxValue := CFile.ReadFloat;
      cStateTaxValue := CFile.ReadFloat;
      cFederalTaxNumber := CFile.ReadString;
      cStateTaxNumber := CFile.ReadString;
      cDepositValue := CFile.ReadInteger;
      if Version >= 103 then
        cCurrencySign := CFile.ReadString[1]; 
      if Version >= 104 then
        cLockInvoices := CFile.ReadBool;
      cQuotationL1 := CFile.ReadString;
      cQuotationL2 := CFile.ReadString;
      cQuotationL3 := CFile.ReadString;
      if Version >= 102 then
        cQuotationL4 := CFile.ReadString;
      cOrderL1 := CFile.ReadString;
      cOrderL2 := CFile.ReadString;
      cOrderL3 := CFile.ReadString;
      if Version >= 102 then
        cOrderL4 := CFile.ReadString;
      cInvoiceL1 := CFile.ReadString;
      cInvoiceL2 := CFile.ReadString;
      cInvoiceL3 := CFile.ReadString;
      if Version >= 102 then
        cInvoiceL4 := CFile.ReadString;
      cQuotationNumber := CFile.ReadInteger;
      cOrderNumber := CFile.ReadInteger;
      cInvoiceNumber := CFile.ReadInteger;
      cEmployees.ReadInFile(CFile, Version);
      cClients.ReadInFile(CFile, Version);
      cSuppliers.ReadInFile(CFile, Version);

      CFile.Free;
      Result := 00;
    except
      on Exception do begin
        CFile.Free;
        Result := 15;
      end;
    end;
  end;
    
  function TCompany.LoadHeaderFromFile(FileName : String) : Word;
  var
    CFile : TEncryptedFile;
    Version : Integer;
  begin
    cFileName := FileName;
    cFilesDir := ExtractFilePath(FileName);   
    cTransDir := cFilesDir+'Transactions\';
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
      if CFile.ReadString <> FileType then
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
      cName := CFile.ReadString;
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
