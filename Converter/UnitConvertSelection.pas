(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c) 2003 Marc-Andre Lamothe ***************************)
(* All rights reserved *********************************************)

unit UnitConvertSelection;

interface
  uses UnitCryptedFile ;
      
type         
  PSelection = ^TSelection ;
  TSelection = record
    Inventory : String ;
    Group : String ;
		Number,
		Name,
		Web : String ;
		Price : Single ;
		Quantity : SmallInt ;
		Taxed : Boolean ;
    Comments : String ;
    Descriptive : Boolean ;

    Prev, Next : PSelection ;
  end ;

  TSelectionList = class(TObject)
  private
    lFirst,
    lLast,
    lCurrent : PSelection ;
    lSize : Word ;
  public
    constructor Create ;
    destructor Destroy ; override ;

    procedure Clear ;
    procedure WriteInFile(CFile : TCryptedFile) ;
    procedure ReadInFile(CFile : TCryptedFile) ;
  end ;

implementation
                 
  constructor TSelectionList.Create ;
  begin
    lFirst := nil ;
    lLast := nil ;
    lCurrent := nil ;
    lSize := 0 ;
  end ;

  destructor TSelectionList.Destroy ;
  begin
    Clear ;
    inherited Destroy ;
  end ;

  procedure TSelectionList.Clear  ;
  var
    Ptr : PSelection ;
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

  procedure TSelectionList.WriteInFile(CFile : TCryptedFile) ;
  var
    Ptr : PSelection ;
  begin
    CFile.WriteInteger(lSize) ;
    Ptr := lFirst ;
    while Ptr <> nil do
    begin
      CFile.WriteString(Ptr.Inventory) ;
      CFile.WriteString(Ptr.Group) ;
      CFile.WriteString(Ptr.Number) ;
      CFile.WriteString(Ptr.Name) ;
      CFile.WriteString(Ptr.Web) ;
      CFile.WriteFloat(Ptr.Price) ;
      CFile.WriteInteger(Ptr.Quantity) ;
      CFile.WriteBool(Ptr.Taxed) ;
      CFile.WriteString(Ptr.Comments) ;
      CFile.WriteBool(Ptr.Descriptive) ;
      Ptr := Ptr.Next ;
    end ;
  end ;

  procedure TSelectionList.ReadInFile(CFile : TCryptedFile) ;
  var
    Index : Word ;
    Selection : PSelection ;
  begin
    if lFirst <> nil then
      Clear ;
    lSize := CFile.ReadInteger ;
    for Index := 0 to lSize-1 do
    begin
      New(Selection) ;
      Selection.Inventory := CFile.ReadString ;
      Selection.Group := CFile.ReadString ;
      Selection.Number := CFile.ReadString ;
      Selection.Name := CFile.ReadString ;
      Selection.Web := CFile.ReadString ;
      Selection.Price := CFile.ReadFloat ;
      Selection.Quantity := CFile.ReadInteger ;
      Selection.Taxed := CFile.ReadBool ;
      Selection.Comments := CFile.ReadString ;
      Selection.Descriptive := CFile.ReadBool ;
      if lLast <> nil then
      begin                   
        Selection.Prev := lLast ;
        Selection.Next := nil ;
        lLast.Next := Selection ;
      end
      else
      begin   
        Selection.Prev := nil ;
        Selection.Next := nil ;
        lFirst := Selection ;
      end ;
      lLast := Selection ;
    end ;
  end ;

end.
