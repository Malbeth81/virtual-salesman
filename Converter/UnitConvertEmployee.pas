(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c) 2003 Marc-Andre Lamothe ***************************)
(* All rights reserved *********************************************)

unit UnitConvertEmployee;

interface
uses SysUtils, UnitCryptedFile ;

type             
  PEmployee = ^TEmployee ;
  TEmployee = record
		Number,
		Name,
		Adress,
    SSN,
		Phone,
		Email,
		Other : String ;

    Prev, Next : PEmployee ;
  end ;

  TEmployeeList = class(TObject)
  private
    lFirst,
    lLast,
    lCurrent : PEmployee ;
    lSize : Word ;
  public
    constructor Create ;
    destructor Destroy ; override ;
                                      
    procedure Clear ;
    procedure WriteInFile(CFile : TCryptedFile) ;
    function LoadFromFile(FileName : String) : Word ;
  end ;

implementation
                        
  constructor TEmployeeList.Create ;
  begin
    lFirst := nil ;
    lLast := nil ;
    lCurrent := nil ;
    lSize := 0 ;
  end ;

  destructor TEmployeeList.Destroy ;
  begin
    Clear ;
    inherited Destroy ;
  end ;
                    
  procedure TEmployeeList.Clear  ;
  var
    Ptr : PEmployee ;
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

  procedure TEmployeeList.WriteInFile(CFile : TCryptedFile) ;
  var
    Ptr : PEmployee ;
  begin
    { Writes data }
    CFile.WriteInteger(lSize) ;
    Ptr := lFirst ;
    while Ptr <> nil do
    begin
      CFile.WriteString(Ptr.Number) ;
      CFile.WriteString(Ptr.Name) ;
      CFile.WriteString(Ptr.Adress) ;
      CFile.WriteString(Ptr.SSN) ;
      CFile.WriteString(Ptr.Phone) ;
      CFile.WriteString(Ptr.Email) ;
      CFile.WriteString(Ptr.Other) ;
      Ptr := Ptr.Next ;
    end ;
  end ;

  function TEmployeeList.LoadFromFile(FileName : String) : Word ;
  var
    CFile : TCryptedFile ;
    Index : Integer ;     
    Employee : PEmployee ;
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
        New(Employee) ;
        Employee.Number := CFile.ReadString ;
        Employee.Name := CFile.ReadString ;
        Employee.Adress := CFile.ReadString ;
        Employee.SSN := '' ;
        Employee.Phone := CFile.ReadString ;
        Employee.Email := CFile.ReadString ;
        Employee.Other := CFile.ReadString ;
        if lLast <> nil then
        begin
          Employee.Prev := lLast ;
          Employee.Next := nil ;
          lLast.Next := Employee ;
        end
        else
        begin
          Employee.Prev := nil ;
          Employee.Next := nil ;
          lFirst := Employee ;
        end ;
        lLast := Employee ;
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
