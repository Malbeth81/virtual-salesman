(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c) 2003 Marc-Andre Lamothe ***************************)
(* All rights reserved *********************************************)

unit UnitConvertClient;

interface
uses SysUtils, UnitCryptedFile ;

type  
  PClient = ^TClient ;
  TClient = record
		Number,
		Name,
		Adress,
		Phone,
		Email,
		Other,
    Quotes,
    Commands,
    Invoices : String ;

    Prev, Next : PClient ;
  end ;

  TClientList = class(TObject)
  private
    lFirst,
    lLast,
    lCurrent : PClient ;
    lSize : Word ;
  published
    property Size : Word read lSize ;
  public
    constructor Create ;
    destructor Destroy ; override ;

    procedure Clear ;
    procedure WriteInFile(CFile : TCryptedFile) ;
    function LoadFromFile(FileName : String) : Word ;
  end ;

implementation

  constructor TClientList.Create ;
  begin
    lFirst := nil ;
    lLast := nil ;
    lCurrent := nil ;
    lSize := 0 ;
  end ;

  destructor TClientList.Destroy ;
  begin
    Clear ;
    inherited Destroy ;
  end ;

  procedure TClientList.Clear  ;
  var
    Ptr : PClient ;
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

  procedure TClientList.WriteInFile(CFile : TCryptedFile) ;
  var
    Ptr : PClient ;
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
      CFile.WriteString(Ptr.Quotes) ;
      CFile.WriteString(Ptr.Commands) ;
      CFile.WriteString(Ptr.Invoices) ;
      Ptr := Ptr.Next ;
    end ;
  end ;

  function TClientList.LoadFromFile(FileName : String) : Word ;
  var
    CFile : TCryptedFile ;
    Index : Integer ;
    Client : PClient ;
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
        New(Client) ;
        Client.Number := CFile.ReadString ;
        Client.Name := CFile.ReadString ;
        Client.Adress := CFile.ReadString ;
        Client.Phone := CFile.ReadString ;
        Client.Email := CFile.ReadString ;
        Client.Other := CFile.ReadString ;
        Client.Quotes := '' ;             
        Client.Commands := '' ;
        Client.Invoices := '' ;
        if lLast <> nil then
        begin
          Client.Prev := lLast ;
          Client.Next := nil ;
          lLast.Next := Client ;
        end
        else
        begin
          Client.Prev := nil ;
          Client.Next := nil ;
          lFirst := Client ;
        end ;
        lLast := Client ;
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
