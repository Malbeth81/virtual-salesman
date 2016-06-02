(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2005 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitProduct;

interface
uses SysUtils, EncryptedFile;

type
  PProduct = ^TProduct;
  TProduct = record
    Code : string;
    Name : string;
    Web : string;
    Cost : Single;
    Price : Single;
    Quantity : SmallInt;
    Taxed : Boolean;
    Suppliers : string;

    Prev, Next : PProduct;
  end;
         
  TAction = (aNone, aAdd, aModify, aRemove);
  PUndo = ^TUndo;
  TUndo = record
    Action : TAction;
    Data : TProduct;

    Next : PUndo;
  end;

  TProductList = class(TObject)
  private
    lFirst,
    lLast : PProduct;
    lSize : Word;       
    lUndo : PUndo;
    lRedo : PUndo;

    procedure NewUndo(Action : TAction; Data : PProduct);
  public
    constructor Create;
    destructor Destroy; override;

    function Get(Code : String) : PProduct; overload;
    function Get(Index : Word) : PProduct; overload;
    function IndexOf(Code : String) : Word;
    function Add(Code, Name, Web : String; Cost, Price : Single; Quantity : SmallInt; Taxed : Boolean; Suppliers : string; Undo : Boolean = False) : Boolean;
    function Modify(Code, Name, Web : String; Cost, Price : Single; Quantity : SmallInt; Taxed : Boolean; Suppliers : string; Undo : Boolean = False) : Boolean;
    function Remove(Index : Word; Undo : Boolean = False) : Boolean;
    procedure Clear;

    function LastAction : TAction;
    function LastUndone : TAction;
    procedure Undo(Count : Word = 1);
    procedure Redo(Count : Word = 1);

    procedure WriteInFile(CFile : TEncryptedFile);
    procedure ReadInFile(CFile : TEncryptedFile);
    procedure ExportToFile(Filename : string; Delimiter, Separator : Char);
                                        
    property First : PProduct read lFirst;
    property Last : PProduct read lLast;
    property Size : Word read lSize;
  end;

implementation
               
procedure TProductList.NewUndo(Action : TAction; Data : PProduct);
var
  Undo : PUndo;
begin
  New(Undo);
  Undo.Action := Action;
  Undo.Data := Data^;
  Undo.Next := lUndo;
  lUndo := Undo;
  while lRedo <> nil do
  begin
    Undo := lRedo;
    lRedo := lRedo.Next;
    Dispose(Undo);
  end;
end;

constructor TProductList.Create;
begin
  lFirst := nil;
  lLast := nil;
  lSize := 0;    
  lUndo := nil;
  lRedo := nil;
end;

destructor TProductList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TProductList.Get(Code : String) : PProduct;
begin
  Result := nil;
  if Code <> '' then
  begin
    Result := lFirst;
    while (Result <> nil) and (StrIComp(PChar(Result.Code), PChar(Code)) <> 0) do
      Result := Result.Next;
  end;
end;

function TProductList.Get(Index : Word) : PProduct;
begin  
  Result := nil;
  if Index in [1..lSize] then
  begin
    Result := lFirst;
    while (Result <> nil) and (Index > 1) do
    begin
      Result := Result.Next;
      Index := Index -1;
    end;
  end;
end;

function TProductList.IndexOf(Code: string): Word;
var
  CurProduct: PProduct;
  i: Integer;
begin
  Result := 0;
  if Code <> '' then
  begin
    i := 0;
    CurProduct := lFirst;
    while CurProduct <> nil do
      if CurProduct.Code = Code then
      begin
        Result := i+1;
        Exit;
      end
      else
      begin
        i := i+1;
        CurProduct := CurProduct.Next;
      end;
  end;
end;

function TProductList.Add(Code, Name, Web : String; Cost, Price : Single; Quantity : SmallInt; Taxed : Boolean; Suppliers : string; Undo : Boolean = False) : Boolean;
var
  Ptr, Product : PProduct;
begin
  Result := False;
  if (Code <> '') and (Get(Code) = nil) then
  begin
    New(Product);
    Product.Code := Code;
    Product.Name := Name;
    Product.Web := Web;
    Product.Cost := Cost;
    Product.Price := Price;
    Product.Quantity := Quantity;
    Product.Taxed := Taxed;
    Product.Suppliers := Suppliers;
    if not Undo then
      NewUndo(aAdd, Product);
    Ptr := lFirst;
    while (Ptr <> nil) and (Ptr.Code < Code) do
      Ptr := Ptr.Next;
    if Ptr = lFirst then           { Add as first product }
    begin
      Product.Prev := nil;
      Product.Next := lFirst;
      if lFirst <> nil then
        lFirst.Prev := Product;
      lFirst := Product;
      if lLast = nil then
        lLast := Product;
    end
    else if Ptr = nil then         { Add as last product }
    begin
      Product.Prev := lLast;
      Product.Next := nil;
      if lLast <> nil then
        lLast.Next := Product;
      lLast := Product;
    end
    else                           { Add before Ptr }
    begin
      Product.Prev := Ptr.Prev;
      Product.Next := Ptr;
      Ptr.Prev.Next := Product;
      Ptr.Prev := Product;
    end;
    Inc(lSize);
    Result := True;
  end;
end;

function TProductList.Modify(Code, Name, Web : String; Cost, Price : Single; Quantity : SmallInt; Taxed : Boolean; Suppliers : string; Undo : Boolean = False) : Boolean;
var
  Ptr : PProduct;
begin
  Result := False;
  Ptr := Get(Code);
  if Ptr <> nil then
  begin            
    if not Undo then
      NewUndo(aModify, Ptr);
    Ptr.Name := Name;
    Ptr.Web := Web;
    Ptr.Cost := Cost;
    Ptr.Price := Price;
    Ptr.Quantity := Quantity;
    Ptr.Taxed := Taxed;    
    Ptr.Suppliers := Suppliers;
    Result := True;
  end;
end;

function TProductList.Remove(Index : Word; Undo : Boolean = False) : Boolean;
var
  Ptr : PProduct;
begin
  Result := False;
  Ptr := Get(Index);
  if Ptr <> nil then
  begin
    if not Undo then
      NewUndo(aRemove, Ptr);
    if Ptr.Prev = nil then lFirst := Ptr.Next else Ptr.Prev.Next := Ptr.Next;
    if Ptr.Next = nil then lLast := Ptr.Prev else Ptr.Next.Prev := Ptr.Prev;
    Dispose(Ptr);
    Dec(lSize);
    Result := True;
  end;
end;

procedure TProductList.Clear;
var
  Ptr : PProduct;
  Undo : PUndo;
begin
  while lFirst <> nil do
  begin
    Ptr := lFirst;
    lFirst := Ptr.Next;
    Dispose(Ptr);
  end;
  lLast := nil;
  lSize := 0;
  while lUndo <> nil do
  begin
    Undo := lUndo;
    lUndo := lUndo.Next;
    Dispose(Undo);
  end;
  while lRedo <> nil do
  begin
    Undo := lRedo;
    lRedo := lRedo.Next;
    Dispose(Undo);
  end;
end;
         
function TProductList.LastAction : TAction;
begin
  Result := aNone;
  if lUndo <> nil then
    Result := lUndo.Action;
end;

function TProductList.LastUndone : TAction;
begin
  Result := aNone;
  if lRedo <> nil then
    Result := lRedo.Action;
end;

procedure TProductList.Undo(Count : Word = 1);
var
  Ptr : PProduct;
  Redo : PUndo;
begin
  while (lUndo <> nil) and (Count > 0) do
  begin
    New(Redo);
    Redo.Action := lUndo.Action;
    Ptr := Get(lUndo.Data.Code);
    if Ptr <> nil then
      Redo.Data := Ptr^
    else
      Redo.Data := lUndo.Data;
    case lUndo.Action of
      aAdd : Remove(IndexOf(lUndo.Data.Code), True);
      aModify : Modify(lUndo.Data.Code, lUndo.Data.Name, lUndo.Data.Web, lUndo.Data.Cost, lUndo.Data.Price, lUndo.Data.Quantity, lUndo.Data.Taxed, lUndo.Data.Suppliers, True);
      aRemove : Add(lUndo.Data.Code, lUndo.Data.Name, lUndo.Data.Web, lUndo.Data.Cost, lUndo.Data.Price, lUndo.Data.Quantity, lUndo.Data.Taxed, lUndo.Data.Suppliers, True);
    end;
    Redo.Next := lRedo;
    lRedo := Redo;
    Redo := lUndo;
    lUndo := lUndo.Next;
    Dispose(Redo);
    Dec(Count);
  end;
end;

procedure TProductList.Redo(Count : Word = 1);
var              
  Ptr : PProduct;
  Undo : PUndo;
begin
  while (lRedo <> nil) and (Count > 0) do
  begin
    New(Undo);
    Undo.Action := lRedo.Action;  
    Ptr := Get(lRedo.Data.Code);
    if Ptr <> nil then
      Undo.Data := Ptr^
    else
      Undo.Data := lRedo.Data;
    case lRedo.Action of
      aAdd : Add(lRedo.Data.Code, lRedo.Data.Name, lRedo.Data.Web, lRedo.Data.Cost, lRedo.Data.Price, lRedo.Data.Quantity, lRedo.Data.Taxed, lRedo.Data.Suppliers, True);
      aModify : Modify(lRedo.Data.Code, lRedo.Data.Name, lRedo.Data.Web, lRedo.Data.Cost, lRedo.Data.Price, lRedo.Data.Quantity, lRedo.Data.Taxed, lRedo.Data.Suppliers, True);
      aRemove : Remove(IndexOf(lRedo.Data.Code), True);
    end;
    Undo.Next := lUndo;
    lUndo := Undo;        
    Undo := lRedo;
    lRedo := lRedo.Next;
    Dispose(Undo);
    Dec(Count);
  end;
end;

procedure TProductList.WriteInFile(CFile : TEncryptedFile);
var
  Ptr : PProduct;
begin
  { Writes data }
  CFile.WriteInteger(lSize);
  Ptr := lFirst;
  while Ptr <> nil do
  begin
    CFile.WriteString(Ptr.Code);
    CFile.WriteString(Ptr.Name);
    CFile.WriteString(Ptr.Web);
    CFile.WriteFloat(Ptr.Cost);
    CFile.WriteFloat(Ptr.Price);
    CFile.WriteInteger(Ptr.Quantity);
    CFile.WriteBool(Ptr.Taxed);
    CFile.WriteString(Ptr.Suppliers);
    Ptr := Ptr.Next;
  end;
end;

procedure TProductList.ReadInFile(CFile : TEncryptedFile);
var
  Index : Integer;
  Product : PProduct;
begin
  { Reads data }
  if lFirst <> nil then
    Clear;
  lSize := CFile.ReadInteger;
  for Index := 0 to lSize-1 do
  begin
    New(Product);
    Product.Code := CFile.ReadString;
    Product.Name := CFile.ReadString;
    Product.Web := CFile.ReadString;
    Product.Cost := CFile.ReadFloat;
    Product.Price := CFile.ReadFloat;
    Product.Quantity := CFile.ReadInteger;
    Product.Taxed := CFile.ReadBool;
    Product.Suppliers := CFile.ReadString;
    if lLast <> nil then
    begin
      Product.Prev := lLast;
      Product.Next := nil;
      lLast.Next := Product;
    end
    else
    begin
      Product.Prev := nil;
      Product.Next := nil;
      lFirst := Product;
    end;
    lLast := Product;
  end;
end;
    
procedure TProductList.ExportToFile(FileName : string; Delimiter, Separator : Char);
var
  hFile : TextFile;
  Ptr : PProduct;
begin
  AssignFile(hFile, FileName);
  Rewrite(hFile);
  { Writes data }
  Ptr := lFirst;
  while Ptr <> nil do
  begin
    Writeln(hFile, Delimiter+Ptr.Code+Delimiter+Separator+
                   Delimiter+Ptr.Name+Delimiter+Separator+
                   Delimiter+FormatFloat('0.00', Ptr.Cost)+Delimiter+Separator+
                   Delimiter+FormatFloat('0.00', Ptr.Price)+Delimiter+Separator+
                   Delimiter+IntToStr(Ptr.Quantity)+Delimiter+Separator+
                   Delimiter+Ptr.Web+Delimiter);
    Ptr := Ptr.Next;
  end;
  CloseFile(hFile);
end;

end.
