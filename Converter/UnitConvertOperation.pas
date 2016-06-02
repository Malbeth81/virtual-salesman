(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c) 2003 Marc-Andre Lamothe ***************************)
(* All rights reserved *********************************************)

unit UnitConvertOperation;

interface

uses SysUtils, UnitCryptedFile, UnitConvertSelection ;
 
const
  FileType = 'VV3Operation' ;
  FileVersion = 100 ;
            
{ Returned error codes of SaveToFile and LoadFromFile
  00 : No errors
  10 : Cannot open file
  12 : Wrong file type
  13 : Wrong file version
  14 : Write error
  15 : Read error }

type
  TFormType = (fNone, fQuote, fCommand, fInvoice) ;
  TPaymentType = (pCash, pCredit, pDebit) ;
type
  TOperation = class (TObject)
  private
    oFormType : TFormType ;
    oDate : TDateTime ;
    oQuoteNumber,
    oCommandNumber,
    oInvoiceNumber : Integer ;
    oEmployee,
    oClient,
    oRecipient : String ;
    oPaymentType : TPaymentType ;
    oCreditCardNumber,
    oCreditCardExp : String ;
    oSubTotal,
    oFederalTaxes,
    oProvincialTaxes,
    oFees,
    oTotal,
    oDeposit,
    oBalance : Single ;
    oComments : String ;
    oSelections : TSelectionList ;
  public                
    constructor Create ;
    destructor Destroy ; override ;

    function SaveToFile(FileName : String) : Word ;
    function LoadFromFile(FileName : String) : Word ;
  end ;

implementation
                          
  constructor TOperation.Create ;
  begin
    oSelections := TSelectionList.Create ;
  end ;

  destructor TOperation.Destroy ;
  begin
    oSelections.Free ;
    inherited Destroy ;
  end ;

  function TOperation.SaveToFile(FileName : String) : Word ;
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
      CFile.WriteInteger(Integer(oFormType)) ;
      CFile.WriteFloat(oDate) ;
      CFile.WriteInteger(oQuoteNumber) ;
      CFile.WriteInteger(oCommandNumber) ;
      CFile.WriteInteger(oInvoiceNumber) ;
      CFile.WriteString(oEmployee) ;
      CFile.WriteString(oClient) ;
      CFile.WriteString(oRecipient) ;
      CFile.WriteInteger(Integer(oPaymentType)) ;
      CFile.WriteString(oCreditCardNumber) ;
      CFile.WriteString(oCreditCardExp) ;
      CFile.WriteFloat(oSubTotal) ;
      CFile.WriteFloat(oFederalTaxes) ;
      CFile.WriteFloat(oProvincialTaxes) ;
      CFile.WriteFloat(oFees) ;
      CFile.WriteFloat(oTotal) ;
      CFile.WriteFloat(oDeposit) ;
      CFile.WriteFloat(oBalance) ;   
      CFile.WriteString(oComments) ;
      oSelections.WriteInFile(CFile) ;
      
      CFile.Free ;
      Result := 00 ;
    except   
      on Exception do begin
        CFile.Free ;
        Result := 14 ;
      end ;
    end ;
  end ;

  function TOperation.LoadFromFile(FileName : String) : Word ;
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
      oFormType := TFormType(CFile.ReadInteger) ;
      oDate := CFile.ReadFloat ;
      oQuoteNumber := CFile.ReadInteger ;
      oCommandNumber := CFile.ReadInteger ;
      oInvoiceNumber := CFile.ReadInteger ;
      oEmployee := CFile.ReadString ;
      CFile.ReadString ;
      CFile.ReadString ;
      CFile.ReadString ;
      CFile.ReadString ;
      CFile.ReadString ;
      oClient := CFile.ReadString ;   
      CFile.ReadString ;
      CFile.ReadString ;
      CFile.ReadString ;
      CFile.ReadString ;
      CFile.ReadString ;
      oRecipient := CFile.ReadString ; 
      CFile.ReadString ;
      CFile.ReadString ;
      CFile.ReadString ;
      CFile.ReadString ;
      CFile.ReadString ;
      oPaymentType := TPaymentType(CFile.ReadInteger) ;
      oCreditCardNumber := CFile.ReadString ;
      oCreditCardExp := CFile.ReadString ;
      oSubTotal := CFile.ReadFloat ;
      oFederalTaxes := CFile.ReadFloat ;
      oProvincialTaxes := CFile.ReadFloat ;
      oFees := CFile.ReadFloat ;
      oTotal := CFile.ReadFloat ;
      oDeposit := CFile.ReadFloat ;
      oBalance := CFile.ReadFloat ;   
      oSelections.ReadInFile(CFile) ;
      oComments := CFile.ReadString ;

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