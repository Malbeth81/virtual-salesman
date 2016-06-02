(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c) 2003 Marc-Andre Lamothe ***************************)
(* All rights reserved *********************************************)

unit UnitConvertSupplier;

interface
uses SysUtils, UnitCryptedFile ;

type             
  PSupplier = ^TSupplier ;
  TSupplier = record
		Number,
		Name,
		Adress,
		Phone,
		Email,
		Other : String ;

    Prev, Next : PSupplier ;
  end ;

  TSupplierList = class(TObject)
  private
    lFirst,
    lLast,
    lCurrent : PSupplier ;
    lSize : Word ;
  public
    constructor Create ;
    destructor Destroy ; override ;
                                
    procedure Clear ;
    procedure WriteInFile(CFile : TCryptedFile) ;
    function LoadFromFile(FileName : String) : Word ;
  end ;

implementation
                        
  constructor TSupplierList.Create ;
  begin
    lFirst := nil ;
    lLast := nil ;
    lCurrent := nil ;
    lSize := 0 ;
  end ;

  destructor TSupplierList.Destroy ;
  begin
    Clear ;
    inherited Destroy ;
  end ;
                               
  procedure TSupplierList.Clear  ;
  var
    Ptr : PSupplier ;
  begin
    while lFirst <> nil do
    begin
      Ptr := lFirst ;
      lFirst := Ptr.Next ;
      Dispose(Ptr) ;
    end ;
    lLast := nil ;
    lCurrent := nil ;
    lSize := 0 ;
  end ;

  procedure TSupplierList.WriteInFile(CFile : TCryptedFile) ;
  var
    Ptr : PSupplier ;
  begin
    { Writes data }
    CFile.WriteInteger(lSize) ;
    Ptr := lFirst ;
    while Ptr <> nil do
    begin
      CFile.WriteString(Ptr.Number) ;
      CFile.WriteString(Ptr.Name) ;
      CFile.WriteString(Ptr.Adress) ;
      CFile.WriteString(Ptr.Phone) ;
      CFile.WriteString(Ptr.Email) ;
      CFile.WriteString(Ptr.Other) ;
      Ptr := Ptr.Next ;
    end ;
  end ;

  function TSupplierList.LoadFromFile(FileName : String) : Word ;
  var
    CFile : TCryptedFile ;
    Index : Integer ;     
    Supplier : PSupplier ;
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
      if lFirst <> nil then
        Clear ;
      lSize := CFile.ReadInteger ;
      for Index := 0 to lSize-1 do
      begin
        New(Supplier) ;
        Supplier.Number := CFile.ReadString ;
        Supplier.Name := CFile.ReadString ;
        Supplier.Adress := CFile.ReadString ;
        Supplier.Phone := CFile.ReadString ;
        Supplier.Email := CFile.ReadString ;
        Supplier.Other := CFile.ReadString ;
        if lLast <> nil then
        begin
          Supplier.Prev := lLast ;
          Supplier.Next := nil ;
          lLast.Next := Supplier ;
        end
        else
        begin
          Supplier.Prev := nil ;
          Supplier.Next := nil ;
          lFirst := Supplier ;
        end ;
        lLast := Supplier ;
      end ;

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
