(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c) 2003 Marc-Andre Lamothe ***************************)
(* All rights reserved *********************************************)

unit UnitConvertCompany;

interface
uses SysUtils, UnitCryptedFile, UnitConvertEmployee, UnitConvertClient, UnitConvertSupplier ;

const
  FileType = 'VV3Company' ;
  FileVersion = 100 ;
            
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
    cName,
    cInfoLine1,
    cInfoLine2,
    cInfoLine3,
    cInfoLine4,
    cInfoLine5 : String ;
    cFedTaxName,
    cProvTaxName : String ;
    cFedTaxValue,
    cProvTaxValue : Single ;
    cFedTaxNumber,
    cProvTaxNumber : String ;
    cDepositValue : Integer ;
    cQuoteL1,
    cQuoteL2,
    cQuoteL3,
    cCommandL1,
    cCommandL2,
    cCommandL3,
    cInvoiceL1,
    cInvoiceL2,
    cInvoiceL3 : String ;
  public         
    Employees : TEmployeeList ;
    Clients : TClientList ;
    Suppliers : TSupplierList ;

    constructor Create ;
    destructor Destroy ; override ;

    function SaveToFile(FileName : String) : Word ;
    function LoadFromFile(FileName : String) : Word ;
  end ;

implementation
               
  constructor TCompany.Create ;
  begin
    Employees := TEmployeeList.Create ;
    Clients := TClientList.Create ;
    Suppliers := TSupplierList.Create ;
  end ;
               
  destructor TCompany.Destroy ;
  begin
    Employees.Free ;
    Clients.Free ;
    Suppliers.Free ;
    inherited Destroy ;
  end ;

  function TCompany.SaveToFile(FileName : String) : Word ;
  var
    CFile : TCryptedFile ;
  begin
    CFile := TCryptedFile.Create ;
    try
      CFile.AssignFile(FileName) ;
      CFile.Rewrite ;
    except     
      on Exception do begin
        CFile.Free ;
        Result := 10 ;
        Exit ;
      end ;
    end ;
    try          
      { Writes file info }
      CFile.WriteString(FileType) ;
      CFile.WriteInteger(FileVersion) ;

      { Writes data }
      CFile.WriteString(cName) ;
      CFile.WriteString(cInfoLine1) ;
      CFile.WriteString(cInfoLine2) ;
      CFile.WriteString(cInfoLine3) ;
      CFile.WriteString(cInfoLine4) ;
      CFile.WriteString(cInfoLine5) ;
      CFile.WriteString(cFedTaxName) ;
      CFile.WriteString(cProvTaxName) ;
      CFile.WriteFloat(cFedTaxValue) ;
      CFile.WriteFloat(cProvTaxValue) ;
      CFile.WriteString(cFedTaxNumber) ;
      CFile.WriteString(cProvTaxNumber) ;
      CFile.WriteInteger(cDepositValue) ;
      CFile.WriteString(cQuoteL1) ;
      CFile.WriteString(cQuoteL2) ;
      CFile.WriteString(cQuoteL3) ;
      CFile.WriteString(cCommandL1) ;
      CFile.WriteString(cCommandL2) ;
      CFile.WriteString(cCommandL3) ;
      CFile.WriteString(cInvoiceL1) ;
      CFile.WriteString(cInvoiceL2) ;
      CFile.WriteString(cInvoiceL3) ; 
      Employees.WriteInFile(CFile) ;
      Clients.WriteInFile(CFile) ;
      Suppliers.WriteInFile(CFile) ;
      CFile.Free ;
      Result := 00 ;
    except      
      on Exception do begin
        CFile.Free ;
        Result := 14 ;
      end ;
    end ;
  end ;

  function TCompany.LoadFromFile(FileName : String) : Word ;
  var
    CFile : TCryptedFile ;
  begin
    CFile := TCryptedFile.Create ;
    try
      CFile.AssignFile(FileName) ;
      CFile.Reset ;
    except  
      on Exception do begin
        CFile.Free ;
        Result := 10 ;
        Exit ;
      end ;
    end ;
    try
      { Reads data }
      cName := CFile.ReadString ;
      cInfoLine1 := CFile.ReadString ;
      cInfoLine2 := CFile.ReadString ;
      cInfoLine3 := CFile.ReadString ;
      cInfoLine4 := CFile.ReadString ;
      cInfoLine5 := CFile.ReadString ;
      cFedTaxName := CFile.ReadString ;
      cProvTaxName := CFile.ReadString ;
      cFedTaxValue := CFile.ReadFloat ;
      cProvTaxValue := CFile.ReadFloat ;
      cFedTaxNumber := CFile.ReadString ;
      cProvTaxNumber := CFile.ReadString ;
      cDepositValue := CFile.ReadInteger ;
      cQuoteL1 := CFile.ReadString ;
      cQuoteL2 := CFile.ReadString ;
      cQuoteL3 := CFile.ReadString ;
      cCommandL1 := CFile.ReadString ;
      cCommandL2 := CFile.ReadString ;
      cCommandL3 := CFile.ReadString ;
      cInvoiceL1 := CFile.ReadString ;
      cInvoiceL2 := CFile.ReadString ;
      cInvoiceL3 := CFile.ReadString ;
      CFile.Free ;
      Result := 00 ;
    except    
      on Exception do begin
        CFile.Free ;
        Result := 15 ;
      end ;
    end ;
  end ;

end.
