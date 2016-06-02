(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c) 2003 Marc-Andre Lamothe ***************************)
(* All rights reserved *********************************************)

unit UnitConvertProduct;

interface
uses UnitCryptedFile ;

type
  PProduct = ^TProduct ;
  TProduct = record
    Number : String ;
    Name : String ;
    Web : String ;
    CostPrice : Single ;
    RetailPrice : Single ;
    Quantity : SmallInt ;
    Taxed : Boolean ;
    Suppliers : String ;

    Prev, Next : PProduct ;
  end ;

  TProductList = class(TObject)
  private
    lFirst,
    lLast,
    lCurrent : PProduct ;
    lSize : Word ;
  public
    constructor Create ;
    destructor Destroy ; override ;

    procedure Clear ;
    procedure WriteInFile(CFile : TCryptedFile) ;
    procedure ReadInFile(CFile : TCryptedFile) ;
  end ;

implementation

  constructor TProductList.Create ;
  begin
    lFirst := nil ;
    lLast := nil ;
    lCurrent := nil ;
    lSize := 0 ;
  end ;

  destructor TProductList.Destroy ;
  begin
    Clear ;
    inherited Destroy ;
  end ;

  procedure TProductList.Clear  ;
  var
    Ptr : PProduct ;
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

  procedure TProductList.WriteInFile(CFile : TCryptedFile) ;
  var
    Ptr : PProduct ;
  begin
    CFile.WriteInteger(lSize) ;
    Ptr := lFirst ;
    while Ptr <> nil do
    begin
      CFile.WriteString(Ptr.Number) ;
      CFile.WriteString(Ptr.Name) ;
      CFile.WriteString(Ptr.Web) ;
      CFile.WriteFloat(Ptr.CostPrice) ;
      CFile.WriteFloat(Ptr.RetailPrice) ;
      CFile.WriteInteger(Ptr.Quantity) ;
      CFile.WriteBool(Ptr.Taxed) ; 
      CFile.WriteString(Ptr.Suppliers) ;
      Ptr := Ptr.Next ;
    end ;
  end ;

  procedure TProductList.ReadInFile(CFile : TCryptedFile) ;
  var
    Index : Integer ;
    Product : PProduct ;
  begin
    if lFirst <> nil then
      Clear ;     
    lSize := CFile.ReadInteger ;
    for Index := 0 to lSize-1 do
    begin
      New(Product) ;
      Product.Number := CFile.ReadString ;
      Product.Name := CFile.ReadString ;
      Product.Web := CFile.ReadString ;
      Product.CostPrice := CFile.ReadFloat ;
      Product.RetailPrice := CFile.ReadFloat ;
      Product.Quantity := CFile.ReadInteger ;
      Product.Taxed := CFile.ReadBool ;   
      Product.Suppliers := '' ;
      if lLast <> nil then
      begin                   
        Product.Prev := lLast ;
        Product.Next := nil ;
        lLast.Next := Product ;
      end
      else
      begin   
        Product.Prev := nil ;
        Product.Next := nil ;
        lFirst := Product ;
      end ;
      lLast := Product ;
    end ;
  end ;

end.
