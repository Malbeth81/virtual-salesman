(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2005 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitSelection;

interface
  uses EncryptedFile;
      
type         
  PSelection = ^TSelection;
  TSelection = record
    Inventory : String;
    Group : String;
		Code,
		Name,
		Web : String;
		Price : Single;
		Quantity : SmallInt;
		Taxed : Boolean;
    Comments : String;
    Descriptive : Boolean;

    Prev, Next : PSelection;
  end;
            
  TAction = (aNone, aAdd, aModify, aRemove);
  PUndo = ^TUndo;
  TUndo = record
    Action : TAction;
    Index : Word;
    Data : TSelection;

    Next : PUndo;
  end;

  TSelectionList = class(TObject)
  private
    lFirst,
    lLast : PSelection;
    lSize : Word;          
    lUndo : PUndo;
    lRedo : PUndo;

    procedure NewUndo(Action : TAction; Index : Word; Data : PSelection);
  public
    constructor Create;
    destructor Destroy; override;

    function Get(Index : Word) : PSelection;
    function IndexOf(Inventory, Group, Code : String) : Word;
    function Add(Inventory, Group, Code, Name, Web : String; Price : Single; Quantity : SmallInt; Taxed : Boolean; Comments : String; Descriptive : Boolean; Undo : Boolean = False) : Boolean;
    function Modify(Index : Word; Inventory, Group, Code, Name, Web : String; Price : Single; Quantity : SmallInt; Taxed : Boolean; Comments : String; Descriptive : Boolean; Undo : Boolean = False) : Boolean;
    function Remove(Index : Word; Undo : Boolean = False) : Boolean;
    procedure Clear;          

    function LastAction : TAction;
    function LastUndone : TAction;
    procedure Undo(Count : Word = 1);
    procedure Redo(Count : Word = 1);

    procedure WriteInFile(CFile : TEncryptedFile);
    procedure ReadInFile(CFile : TEncryptedFile);
                                    
    property First : PSelection read lFirst;
    property Last : PSelection read lLast;
    property Size : Word read lSize;
  end;

implementation
              
procedure TSelectionList.NewUndo(Action : TAction; Index : Word; Data : PSelection);
var
  Undo : PUndo;
begin
  New(Undo);
  Undo.Action := Action;  
  Undo.Index := Index;
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

constructor TSelectionList.Create;
begin
  lFirst := nil;
  lLast := nil;
  lSize := 0;   
  lUndo := nil;
  lRedo := nil;
end;

destructor TSelectionList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TSelectionList.Get(Index : Word) : PSelection;
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

function TSelectionList.IndexOf(Inventory, Group, Code : string) : Word;
var
  CurSelection : PSelection;
  i : Integer;
begin
  i := 1;
  Result := 0;
  if Code <> '' then
  begin
    CurSelection := lFirst;
    while CurSelection <> nil do
    begin
      if (CurSelection.Inventory = Inventory) and (CurSelection.Group = Group) and (CurSelection.Code = Code) then
      begin
        Result := i;
        Exit;
      end
      else
        CurSelection := CurSelection.Next;
      Inc(i);
    end;
  end;
end;

function TSelectionList.Add(Inventory, Group, Code, Name, Web : String; Price : Single; Quantity : SmallInt; Taxed : Boolean; Comments : String; Descriptive : Boolean; Undo : Boolean = False) : Boolean;
var
  Selection : PSelection;
begin
  Result := False;
  if (Inventory <> '') and (Group <> '') and (Code <> '') and (IndexOf(Inventory, Group, Code) = 0) then
  begin
    New(Selection);
    Selection.Inventory := Inventory;
    Selection.Group := Group;
    Selection.Code := Code;
    Selection.Name := Name;
    Selection.Web := Web;
    Selection.Price := Price;
    Selection.Quantity := Quantity;
    Selection.Taxed := Taxed;
    Selection.Comments := Comments;
    Selection.Descriptive := Descriptive;
    if not Undo then
      NewUndo(aAdd, lSize+1, Selection);
    Selection.Prev := lLast;
    Selection.Next := nil;
    if lLast <> nil then
      lLast.Next := Selection;
    lLast := Selection;
    if lFirst = nil then
      lFirst := Selection;
    Inc(lSize);
    Result := True;
  end;
end;

function TSelectionList.Modify(Index : Word; Inventory, Group, Code, Name, Web : String; Price : Single; Quantity : SmallInt; Taxed : Boolean; Comments : String; Descriptive : Boolean; Undo : Boolean = False) : Boolean;
var
  Ptr : PSelection;
begin
  Result := False;
  Ptr := Get(Index);
  if Ptr <> nil then
  begin                      
    if not Undo then
      NewUndo(aModify, Index, Ptr);
    Ptr.Inventory := Inventory;
    Ptr.Group := Group;
    Ptr.Code := Code;
    Ptr.Name := Name;
    Ptr.Web := Web;
    Ptr.Price := Price;
    Ptr.Quantity := Quantity;
    Ptr.Taxed := Taxed;
    Ptr.Comments := Comments;
    Ptr.Descriptive := Descriptive;
    Result := True;
  end;
end;

function TSelectionList.Remove(Index : Word; Undo : Boolean = False) : Boolean;
var
  Ptr : PSelection;
begin
  Result := False;
  Ptr := Get(Index);
  if Ptr <> nil then
  begin
    if not Undo then
      NewUndo(aRemove, Index, Ptr);
    if Ptr.Prev = nil then lFirst := Ptr.Next else Ptr.Prev.Next := Ptr.Next;
    if Ptr.Next = nil then lLast := Ptr.Prev else Ptr.Next.Prev := Ptr.Prev;
    Dispose(Ptr);
    Dec(lSize);
    Result := True;
  end;
end;

procedure TSelectionList.Clear;
var
  Ptr : PSelection;
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
          
function TSelectionList.LastAction : TAction;
begin
  Result := aNone;
  if lUndo <> nil then
    Result := lUndo.Action;
end;

function TSelectionList.LastUndone : TAction;
begin
  Result := aNone;
  if lRedo <> nil then
    Result := lRedo.Action;
end;

procedure TSelectionList.Undo(Count : Word = 1);
var
  Ptr : PSelection;
  Redo : PUndo;
begin
  while (lUndo <> nil) and (Count > 0) do
  begin
    New(Redo);
    Redo.Action := lUndo.Action;
    Ptr := Get(lUndo.Index);
    if Ptr <> nil then
      Redo.Data := Ptr^
    else
      Redo.Data := lUndo.Data;
    case lUndo.Action of
      aAdd : Remove(lUndo.Index, True);
      aModify : Modify(lUndo.Index, lUndo.Data.Inventory, lUndo.Data.Group, lUndo.Data.Code, lUndo.Data.Name, lUndo.Data.Web, lUndo.Data.Price, lUndo.Data.Quantity, lUndo.Data.Taxed, lUndo.Data.Comments, lUndo.Data.Descriptive, True);
      aRemove : Add(lUndo.Data.Inventory, lUndo.Data.Group, lUndo.Data.Code, lUndo.Data.Name, lUndo.Data.Web, lUndo.Data.Price, lUndo.Data.Quantity, lUndo.Data.Taxed, lUndo.Data.Comments, lUndo.Data.Descriptive, True);
    end;                  
    Redo.Index := IndexOf(lUndo.Data.Inventory, lUndo.Data.Group, lUndo.Data.Code);
    Redo.Next := lRedo;
    lRedo := Redo;
    Redo := lUndo;
    lUndo := lUndo.Next;
    Dispose(Redo);
    Dec(Count);
  end;
end;

procedure TSelectionList.Redo(Count : Word = 1);
var              
  Ptr : PSelection;
  Undo : PUndo;
begin
  while (lRedo <> nil) and (Count > 0) do
  begin
    New(Undo);
    Undo.Action := lRedo.Action;  
    Ptr := Get(lRedo.Index);
    if Ptr <> nil then
      Undo.Data := Ptr^
    else
      Undo.Data := lRedo.Data;
    case lRedo.Action of
      aAdd : Add(lRedo.Data.Inventory, lRedo.Data.Group, lRedo.Data.Code, lRedo.Data.Name, lRedo.Data.Web, lRedo.Data.Price, lRedo.Data.Quantity, lRedo.Data.Taxed, lRedo.Data.Comments, lRedo.Data.Descriptive, True);
      aModify : Modify(lRedo.Index, lRedo.Data.Inventory, lRedo.Data.Group, lRedo.Data.Code, lRedo.Data.Name, lRedo.Data.Web, lRedo.Data.Price, lRedo.Data.Quantity, lRedo.Data.Taxed, lRedo.Data.Comments, lRedo.Data.Descriptive, True);
      aRemove : Remove(lRedo.Index, True);
    end;
    Undo.Index := IndexOf(lRedo.Data.Inventory, lRedo.Data.Group, lRedo.Data.Code);
    Undo.Next := lUndo;
    lUndo := Undo;        
    Undo := lRedo;
    lRedo := lRedo.Next;
    Dispose(Undo);
    Dec(Count);
  end;
end;

procedure TSelectionList.WriteInFile(CFile : TEncryptedFile);
var
  Ptr : PSelection;
begin
  { Writes data }
  CFile.WriteInteger(lSize);
  Ptr := lFirst;
  while Ptr <> nil do
  begin
    CFile.WriteString(Ptr.Inventory);
    CFile.WriteString(Ptr.Group);
    CFile.WriteString(Ptr.Code);
    CFile.WriteString(Ptr.Name);
    CFile.WriteString(Ptr.Web);
    CFile.WriteFloat(Ptr.Price);
    CFile.WriteInteger(Ptr.Quantity);
    CFile.WriteBool(Ptr.Taxed);
    CFile.WriteString(Ptr.Comments);
    CFile.WriteBool(Ptr.Descriptive);
    Ptr := Ptr.Next;
  end;
end;

procedure TSelectionList.ReadInFile(CFile : TEncryptedFile);
var
  Index : Word;
  Selection : PSelection;
begin
  { Reads data }
  if lFirst <> nil then
    Clear;
  lSize := CFile.ReadInteger;
  for Index := 0 to lSize-1 do
  begin
    New(Selection);
    Selection.Inventory := CFile.ReadString;
    Selection.Group := CFile.ReadString;
    Selection.Code := CFile.ReadString;
    Selection.Name := CFile.ReadString;
    Selection.Web := CFile.ReadString;
    Selection.Price := CFile.ReadFloat;
    Selection.Quantity := CFile.ReadInteger;
    Selection.Taxed := CFile.ReadBool;
    Selection.Comments := CFile.ReadString;
    Selection.Descriptive := CFile.ReadBool;
    if lLast <> nil then
    begin
      Selection.Prev := lLast;
      Selection.Next := nil;
      lLast.Next := Selection;
    end
    else
    begin
      Selection.Prev := nil;
      Selection.Next := nil;
      lFirst := Selection;
    end;
    lLast := Selection;
  end;
end;

end.
