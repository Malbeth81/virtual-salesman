(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c) 2003 Marc-Andre Lamothe ***************************)
(* All rights reserved *********************************************)

unit UnitConvertGroup;

interface        
uses UnitCryptedFile, UnitConvertProduct ;

type    
  PGroup = ^TGroup ;
  TGroup = record
    Code : String ;
    Name : String ;
    Products : TProductList ;

    Prev, Next : PGroup ;
  end ;

  TGroupList = class(TObject)
  private
    lFirst,
    lLast,
    lCurrent : PGroup ;
    lSize : Word ;
  public
    constructor Create ;
    destructor Destroy ; override ;

    procedure Clear ;
    procedure WriteInFile(CFile : TCryptedFile) ;
    procedure ReadInFile(CFile : TCryptedFile) ;
  end ;

implementation
               
  constructor TGroupList.Create ;
  begin
    lFirst := nil ;
    lLast := nil ;
    lCurrent := nil ;
    lSize := 0 ;
  end ;

  destructor TGroupList.Destroy ;
  begin
    Clear ;
    inherited Destroy ;
  end ;

  procedure TGroupList.Clear  ;
  var
    Ptr : PGroup ;
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

  procedure TGroupList.WriteInFile(CFile : TCryptedFile) ;
  var
    Ptr : PGroup ;
  begin
    CFile.WriteInteger(lSize) ;
    Ptr := lFirst ;
    while Ptr <> nil do
    begin
      CFile.WriteString(Ptr.Code) ;
      CFile.WriteString(Ptr.Name) ;
      Ptr.Products.WriteInFile(CFile) ;
      Ptr := Ptr.Next ;
    end ;
  end ;

  procedure TGroupList.ReadInFile(CFile : TCryptedFile) ;
  var
    Index : Integer ;
    Group : PGroup ;
  begin
    if lFirst <> nil then
      Clear ;     
    lSize := CFile.ReadInteger ;
    for Index := 0 to lSize-1 do
    begin
      New(Group) ;
      Group.Products := TProductList.Create ;
      Group.Code := CFile.ReadString ;
      Group.Name := CFile.ReadString ;
      Group.Products.ReadInFile(CFile) ;
      if lLast <> nil then
      begin                   
        Group.Prev := lLast ;
        Group.Next := nil ;
        lLast.Next := Group ;
      end
      else
      begin   
        Group.Prev := nil ;
        Group.Next := nil ;
        lFirst := Group ;
      end ;
      lLast := Group ;
    end ;
  end ;

end.
