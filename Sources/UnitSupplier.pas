(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2005 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitSupplier;

interface
uses SysUtils, EncryptedFile;

type             
  PSupplier = ^TSupplier;
  TSupplier = record
		Number,
		Name,
		Address,
		Telephone,
		Email,
		Other : String;

    Prev, Next : PSupplier;
  end;
              
  TAction = (aNone, aAdd, aModify, aRemove);
  PUndo = ^TUndo;
  TUndo = record
    Action : TAction;
    Data : TSupplier;

    Next : PUndo;
  end;

  TSupplierList = class(TObject)
  private
    lFirst,
    lLast : PSupplier;
    lSize : Word;      
    lUndo : PUndo;
    lRedo : PUndo;

    procedure NewUndo(Action : TAction; Data : PSupplier);
  public
    constructor Create;
    destructor Destroy; override;

    function Get(Number : String) : PSupplier; overload;
    function Get(Index : Word) : PSupplier; overload;    
    function IndexOf(Number : String) : Word;
    function Add(Number, Name, Address, Telephone, Email, Other : String; Undo : Boolean = False) : Boolean;
    function Modify(Number, Name, Address, Telephone, Email, Other : String; Undo : Boolean = False) : Boolean;
    function Remove(Index : Word; Undo : Boolean = False) : Boolean;
    procedure Clear;   

    function LastAction : TAction;
    function LastUndone : TAction;
    procedure Undo(Count : Word = 1);
    procedure Redo(Count : Word = 1);

    procedure WriteInFile(CFile : TEncryptedFile);
    procedure ReadInFile(CFile : TEncryptedFile; Version : Integer);   
    procedure ExportToFile(Filename : string; Delimiter, Separator : Char);

    property First : PSupplier read lFirst;
    property Last : PSupplier read lLast;
    property Size : Word read lSize;
  end;

implementation
            
procedure TSupplierList.NewUndo(Action : TAction; Data : PSupplier);
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

constructor TSupplierList.Create;
begin
  lFirst := nil;
  lLast := nil;
  lSize := 0;   
  lUndo := nil;
  lRedo := nil;
end;

destructor TSupplierList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TSupplierList.Get(Number : String) : PSupplier;
begin
  Result := nil;
  if Number <> '' then
  begin
    Result := lFirst;
    while (Result <> nil) and (StrIComp(PChar(Result.Number), PChar(Number)) <> 0) do
      Result := Result.Next;
  end;
end;

function TSupplierList.Get(Index : Word) : PSupplier;
begin
  if Index in [1..lSize] then
  begin
    Result := lFirst;
    while (Result <> nil) and (Index > 1) do
    begin
      Result := Result.Next;
      Index := Index -1;
    end;
  end
  else
    Result := nil;
end;

function TSupplierList.IndexOf(Number : string) : Word;
var
  CurSupplier : PSupplier;
begin
  Result := 0;
  if Number <> '' then
  begin
    CurSupplier := lFirst;
    while CurSupplier <> nil do
      if CurSupplier.Number = Number then
      begin
        Result := Result+1;
        Exit;
      end
      else
      begin
        CurSupplier := CurSupplier.Next;
        Result := Result+1;
      end;
  end;
end;

function TSupplierList.Add(Number, Name, Address, Telephone, Email, Other : String; Undo : Boolean = False) : Boolean;
var
  Ptr, Supplier : PSupplier;
begin
  Result := False;
  if (Number <> '') and (Get(Number) = nil) then
  begin
    New(Supplier);
    Supplier.Number := Number;
    Supplier.Name := Name;
    Supplier.Address := Address;
    Supplier.Telephone := Telephone;
    Supplier.Email := Email;
    Supplier.Other := Other;     
    if not Undo then
      NewUndo(aAdd, Supplier);
    Ptr := lFirst;
    while (Ptr <> nil) and (Ptr.Number < Number) do
      Ptr := Ptr.Next;
    if Ptr = lFirst then           { Add as first Supplier }
    begin
      Supplier.Prev := nil;
      Supplier.Next := lFirst;
      if lFirst <> nil then
        lFirst.Prev := Supplier;
      lFirst := Supplier;
      if lLast = nil then
        lLast := Supplier;
    end
    else if Ptr = nil then         { Add as last Supplier }
    begin
      Supplier.Prev := lLast;
      Supplier.Next := nil;
      if lLast <> nil then
        lLast.Next := Supplier;
      lLast := Supplier;
    end
    else                           { Add before Ptr }
    begin
      Supplier.Prev := Ptr.Prev;
      Supplier.Next := Ptr;
      Ptr.Prev.Next := Supplier;
      Ptr.Prev := Supplier;
    end;
    Inc(lSize);
    Result := True;
  end;
end;

function TSupplierList.Modify(Number, Name, Address, Telephone, Email, Other : String; Undo : Boolean = False) : Boolean;
var
  Ptr : PSupplier;
begin
  Result := False;
  Ptr := Get(Number);
  if Ptr <> nil then
  begin                   
    if not Undo then
      NewUndo(aModify, Ptr);
    Ptr.Name := Name;
    Ptr.Address := Address;
    Ptr.Telephone := Telephone;
    Ptr.Email := Email;
    Ptr.Other := Other;
    Result := True;
  end;
end;

function TSupplierList.Remove(Index : Word; Undo : Boolean = False) : Boolean;
var
  Ptr : PSupplier;
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

procedure TSupplierList.Clear;
var
  Ptr : PSupplier;
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
        
function TSupplierList.LastAction : TAction;
begin
  Result := aNone;
  if lUndo <> nil then
    Result := lUndo.Action;
end;

function TSupplierList.LastUndone : TAction;
begin
  Result := aNone;
  if lRedo <> nil then
    Result := lRedo.Action;
end;

procedure TSupplierList.Undo(Count : Word = 1);
var
  Ptr : PSupplier;
  Redo : PUndo;
begin
  while (lUndo <> nil) and (Count > 0) do
  begin
    New(Redo);
    Redo.Action := lUndo.Action;
    Ptr := Get(lUndo.Data.Number);
    if Ptr <> nil then
      Redo.Data := Ptr^
    else
      Redo.Data := lUndo.Data;
    case lUndo.Action of
      aAdd : Remove(IndexOf(lUndo.Data.Number), True);
      aModify : Modify(lUndo.Data.Number, lUndo.Data.Name, lUndo.Data.Address, lUndo.Data.Telephone, lUndo.Data.Email, lUndo.Data.Other, True);
      aRemove : Add(lUndo.Data.Number, lUndo.Data.Name, lUndo.Data.Address, lUndo.Data.Telephone, lUndo.Data.Email, lUndo.Data.Other, True);
    end;
    Redo.Next := lRedo;
    lRedo := Redo;
    Redo := lUndo;
    lUndo := lUndo.Next;
    Dispose(Redo);
    Dec(Count);
  end;
end;

procedure TSupplierList.Redo(Count : Word = 1);
var              
  Ptr : PSupplier;
  Undo : PUndo;
begin
  while (lRedo <> nil) and (Count > 0) do
  begin
    New(Undo);
    Undo.Action := lRedo.Action;  
    Ptr := Get(lRedo.Data.Number);
    if Ptr <> nil then
      Undo.Data := Ptr^
    else
      Undo.Data := lRedo.Data;
    case lRedo.Action of
      aAdd : Add(lRedo.Data.Number, lRedo.Data.Name, lRedo.Data.Address, lRedo.Data.Telephone, lRedo.Data.Email, lRedo.Data.Other, True);
      aModify : Modify(lRedo.Data.Number, lRedo.Data.Name, lRedo.Data.Address, lRedo.Data.Telephone, lRedo.Data.Email, lRedo.Data.Other, True);
      aRemove : Remove(IndexOf(lRedo.Data.Number), True);
    end;
    Undo.Next := lUndo;
    lUndo := Undo;        
    Undo := lRedo;
    lRedo := lRedo.Next;
    Dispose(Undo);
    Dec(Count);
  end;
end;

procedure TSupplierList.WriteInFile(CFile : TEncryptedFile);
var
  Ptr : PSupplier;
begin
  { Writes data }
  CFile.WriteInteger(lSize);
  Ptr := lFirst;
  while Ptr <> nil do
  begin
    CFile.WriteString(Ptr.Number);
    CFile.WriteString(Ptr.Name);
    CFile.WriteString(Ptr.Address);
    CFile.WriteString(Ptr.Telephone);
    CFile.WriteString(Ptr.Email);
    CFile.WriteString(Ptr.Other);
    Ptr := Ptr.Next;
  end;
end;

procedure TsupplierList.ReadInFile(CFile : TEncryptedFile; Version : Integer);
var
  Index : Integer;
  Supplier : PSupplier;
begin
  { Reads data }
  if lFirst <> nil then
    Clear;
  lSize := CFile.ReadInteger;
  for Index := 0 to lSize-1 do
  begin
    New(Supplier);
    Supplier.Number := CFile.ReadString;
    Supplier.Name := CFile.ReadString;
    Supplier.Address := CFile.ReadString;
    Supplier.Telephone := CFile.ReadString;
    Supplier.Email := CFile.ReadString;
    Supplier.Other := CFile.ReadString;
    if lLast <> nil then
    begin
      Supplier.Prev := lLast;
      Supplier.Next := nil;
      lLast.Next := Supplier;
    end
    else
    begin
      Supplier.Prev := nil;
      Supplier.Next := nil;
      lFirst := Supplier;
    end;
    lLast := Supplier;
  end;
end;
    
procedure TSupplierList.ExportToFile(FileName : string; Delimiter, Separator : Char);
var
  hFile : TextFile;
  Ptr : PSupplier;
begin
  AssignFile(hFile, FileName);
  Rewrite(hFile);
  { Writes data }
  Ptr := lFirst;
  while Ptr <> nil do
  begin
    Writeln(hFile, Delimiter+Ptr.Number+Delimiter+Separator+
                   Delimiter+Ptr.Name+Delimiter+Separator+
                   Delimiter+Ptr.Address+Delimiter+Separator+
                   Delimiter+Ptr.Telephone+Delimiter+Separator+
                   Delimiter+Ptr.Email+Delimiter+Separator+
                   Delimiter+Ptr.Other+Delimiter);
    Ptr := Ptr.Next;
  end;
  CloseFile(hFile);
end;

end.
