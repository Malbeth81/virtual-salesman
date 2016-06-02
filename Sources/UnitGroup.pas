(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2005 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitGroup;

interface        
uses SysUtils, EncryptedFile, UnitProduct;

type    
  PGroup = ^TGroup;
  TGroup = record
    Code : String;
    Name : String;
    Products : TProductList;

    Prev, Next : PGroup;
  end;
              
  TAction = (aNone, aAdd, aModify, aRemove);
  PUndo = ^TUndo;
  TUndo = record
    Action : TAction;
    Data : TGroup;

    Next : PUndo;
  end;

  TGroupList = class(TObject)
  private
    lFirst,
    lLast : PGroup;
    lSize : Word;     
    lUndo : PUndo;
    lRedo : PUndo;

    procedure NewUndo(Action : TAction; Data : PGroup);
  public
    constructor Create;
    destructor Destroy; override;

    function Get(Code : String) : PGroup; overload;
    function Get(Index : Word) : PGroup; overload;
    function IndexOf(Code : String) : Word;
    function Add(Code, Name : String; Undo : Boolean = False) : Boolean;
    function Modify(Code, Name : String; Undo : Boolean = False) : Boolean;
    function Remove(Index : Word; Undo : Boolean = False) : Boolean;
    procedure Clear;                 

    function LastAction : TAction;
    function LastUndone : TAction;
    procedure Undo(Count : Word = 1);
    procedure Redo(Count : Word = 1);

    procedure WriteInFile(CFile : TEncryptedFile);
    procedure ReadInFile(CFile : TEncryptedFile);
                                           
    property First : PGroup read lFirst;
    property Last : PGroup read lLast;
    property Size : Word read lSize;
  end;

implementation
             
procedure TGroupList.NewUndo(Action : TAction; Data : PGroup);
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

constructor TGroupList.Create;
begin
  lFirst := nil;
  lLast := nil;
  lSize := 0;     
  lUndo := nil;
  lRedo := nil;
end;

destructor TGroupList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TGroupList.Get(Code : string) : PGroup;
begin
  Result := nil;
  if Code <> '' then
  begin
    Result := lFirst;
    while (Result <> nil) and (StrIComp(PChar(Result.Code), PChar(Code)) <> 0) do
      Result := Result.Next;
  end;
end;

function TGroupList.Get(Index : Word) : PGroup;
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

function TGroupList.IndexOf(Code: string): Word;
var
  CurGroup: PGroup; 
  i: Integer;
begin
  Result := 0;
  if Code <> '' then
  begin       
    i := 0;
    CurGroup := lFirst;
    while CurGroup <> nil do
      if CurGroup.Code = Code then
      begin
        Result := i+1;
        Exit;
      end
      else
      begin
        i := i+1;
        CurGroup := CurGroup.Next;
      end;
  end;
end;

function TGroupList.Add(Code, Name : String; Undo : Boolean = False) : Boolean;
var
  Ptr, Group : PGroup;
begin
  Result := False;
  if (Code <> '') and (Get(Code) = nil) then
  begin
    New(Group);                
    if not Undo then
      Group.Products := TProductList.Create;
    Group.Code := Code;
    Group.Name := Name;
    if not Undo then
      NewUndo(aAdd, Group);
    Ptr := lFirst;
    while (Ptr <> nil) and (Ptr.Code < Code) do
      Ptr := Ptr.Next;
    if Ptr = lFirst then           { Add as first Group }
    begin
      Group.Prev := nil;
      Group.Next := lFirst;
      if lFirst <> nil then
        lFirst.Prev := Group;
      lFirst := Group;
      if lLast = nil then
        lLast := Group;
    end
    else if Ptr = nil then         { Add as last Group }
    begin
      Group.Prev := lLast;
      Group.Next := nil;
      if lLast <> nil then
        lLast.Next := Group;
      lLast := Group;
    end
    else                           { Add before Ptr }
    begin
      Group.Prev := Ptr.Prev;
      Group.Next := Ptr;
      Ptr.Prev.Next := Group;
      Ptr.Prev := Group;
    end;
    lSize := lSize +1;
    Result := True;
  end;
end;

function TGroupList.Modify(Code, Name : String; Undo : Boolean = False) : Boolean;
var
  Ptr : PGroup;
begin
  Result := False;
  Ptr := Get(Code);
  if Ptr <> nil then
  begin               
    if not Undo then
      NewUndo(aModify, Ptr);
    Ptr.Name := Name;
    Result := True;
  end;
end;

function TGroupList.Remove(Index : Word; Undo : Boolean = False) : Boolean;
var
  Ptr : PGroup;
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
    lSize := lSize -1;
    Result := True;
  end;
end;

procedure TGroupList.Clear;
var
  Ptr : PGroup;    
  Undo : PUndo;
begin
  while lFirst <> nil do
  begin
    Ptr := lFirst;
    lFirst := Ptr.Next;
    Ptr.Products.Free;
    Dispose(Ptr);
  end;
  lLast := nil;
  lSize := 0;   
  while lUndo <> nil do
  begin
    Undo := lUndo;
    lUndo := lUndo.Next;
    if Undo.Action = aRemove then
      Undo.Data.Products.Free;
    Dispose(Undo);
  end;
  while lRedo <> nil do
  begin
    Undo := lRedo;
    lRedo := lRedo.Next;     
    if Undo.Action = aAdd then
      Undo.Data.Products.Free;
    Dispose(Undo);
  end;
end;
        
function TGroupList.LastAction : TAction;
begin
  Result := aNone;
  if lUndo <> nil then
    Result := lUndo.Action;
end;

function TGroupList.LastUndone : TAction;
begin
  Result := aNone;
  if lRedo <> nil then
    Result := lRedo.Action;
end;

procedure TGroupList.Undo(Count : Word = 1);
var
  Ptr : PGroup;
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
      aModify : begin
        Redo.Data.Products := nil;
        Modify(lUndo.Data.Code, lUndo.Data.Name, True);
      end;
      aRemove : begin
        Redo.Data.Products := nil;
        Add(lUndo.Data.Code, lUndo.Data.Name, True);
        Get(lUndo.Data.Code).Products := lUndo.Data.Products;
      end;
    end;
    Redo.Next := lRedo;
    lRedo := Redo;
    Redo := lUndo;
    lUndo := lUndo.Next;
    Dispose(Redo);
    Dec(Count);
  end;
end;

procedure TGroupList.Redo(Count : Word = 1);
var
  Ptr : PGroup;
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
      aAdd :  begin
        Undo.Data.Products := nil;
        Add(lRedo.Data.Code, lRedo.Data.Name, True); 
      end;
      aModify : begin
        Undo.Data.Products := nil;
        Modify(lRedo.Data.Code, lRedo.Data.Name, True);
      end;
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

procedure TGroupList.WriteInFile(CFile : TEncryptedFile);
var
  Ptr : PGroup;
begin
  { Writes data }
  CFile.WriteInteger(lSize);
  Ptr := lFirst;
  while Ptr <> nil do
  begin
    CFile.WriteString(Ptr.Code);
    CFile.WriteString(Ptr.Name);
    Ptr.Products.WriteInFile(CFile);
    Ptr := Ptr.Next;
  end;
end;

procedure TGroupList.ReadInFile(CFile : TEncryptedFile);
var
  Index : Integer;
  Group : PGroup;
begin
  { Reads data }
  if lFirst <> nil then
    Clear;
  lSize := CFile.ReadInteger;
  for Index := 0 to lSize-1 do
  begin
    New(Group);
    Group.Products := TProductList.Create;
    Group.Code := CFile.ReadString;
    Group.Name := CFile.ReadString;
    Group.Products.ReadInFile(CFile);
    if lLast <> nil then
    begin
      Group.Prev := lLast;
      Group.Next := nil;
      lLast.Next := Group;
    end
    else
    begin
      Group.Prev := nil;
      Group.Next := nil;
      lFirst := Group;
    end;
    lLast := Group;
  end;
end;

end.
