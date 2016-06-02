(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2005 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitEmployee;

interface
uses SysUtils, EncryptedFile;

type             
  PEmployee = ^TEmployee;
  TEmployee = record
		Number,
		Name,
		Address,
		Telephone,
		Email,
		Other : String;
    Prev, Next : PEmployee;
  end;
             
  TAction = (aNone, aAdd, aModify, aRemove);
  PUndo = ^TUndo;
  TUndo = record
    Action : TAction;
    Data : TEmployee;
    Next : PUndo;
  end;

  TEmployeeList = class(TObject)
  private
    lFirst,
    lLast : PEmployee;
    lSize : Word;   
    lUndo : PUndo;
    lRedo : PUndo;

    procedure NewUndo(Action : TAction; Data : PEmployee);
  public
    constructor Create;
    destructor Destroy; override;

    function Get(Number : String) : PEmployee; overload;
    function Get(Index : Word) : PEmployee; overload;
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
                                          
    property First : PEmployee read lFirst;
    property Last : PEmployee read lLast;
    property Size : Word read lSize;
  end;

implementation
             
procedure TEmployeeList.NewUndo(Action : TAction; Data : PEmployee);
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

constructor TEmployeeList.Create;
begin
  lFirst := nil;
  lLast := nil;
  lSize := 0;  
  lUndo := nil;
  lRedo := nil;
end;

destructor TEmployeeList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TEmployeeList.Get(Number : String) : PEmployee;
begin
  Result := nil;
  if Number <> '' then
  begin
    Result := lFirst;
    while (Result <> nil) and (StrIComp(PChar(Result.Number), PChar(Number)) <> 0) do
      Result := Result.Next;
  end;
end;

function TEmployeeList.Get(Index : Word) : PEmployee;
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

function TEmployeeList.IndexOf(Number : string) : Word;
var
  CurEmployee : PEmployee;
begin
  Result := 0;
  if Number <> '' then
  begin
    CurEmployee := lFirst;
    while CurEmployee <> nil do
      if CurEmployee.Number = Number then
      begin
        Result := Result+1;
        Exit;
      end
      else
      begin
        CurEmployee := CurEmployee.Next;
        Result := Result+1;
      end;
  end;
end;

function TEmployeeList.Add(Number, Name, Address, Telephone, Email, Other : String; Undo : Boolean = False) : Boolean;
var
  Ptr, Employee : PEmployee;
begin
  Result := False;
  if (Number <> '') and (Get(Number) = nil) then
  begin
    New(Employee);
    Employee.Number := Number;
    Employee.Name := Name;
    Employee.Address := Address;
    Employee.Telephone := Telephone;
    Employee.Email := Email;
    Employee.Other := Other;   
    if not Undo then
      NewUndo(aAdd, Employee);
    Ptr := lFirst;
    while (Ptr <> nil) and (Ptr.Number < Number) do
     Ptr := Ptr.Next;
    if Ptr = lFirst then           { Add as first Employee }
    begin
      Employee.Prev := nil;
      Employee.Next := lFirst;
      if lFirst <> nil then
        lFirst.Prev := Employee;
      lFirst := Employee;
      if lLast = nil then
        lLast := Employee;
    end
    else if Ptr = nil then         { Add as last Employee }
    begin
      Employee.Prev := lLast;
      Employee.Next := nil;
      if lLast <> nil then
        lLast.Next := Employee;
      lLast := Employee;
    end
    else                           { Add before Ptr }
    begin
      Employee.Prev := Ptr.Prev;
      Employee.Next := Ptr;
      Ptr.Prev.Next := Employee;
      Ptr.Prev := Employee;
    end;
    Inc(lSize);
    Result := True;
  end;
end;

function TEmployeeList.Modify(Number, Name, Address, Telephone, Email, Other : String; Undo : Boolean = False) : Boolean;
var
  Ptr : PEmployee;
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

function TEmployeeList.Remove(Index : Word; Undo : Boolean = False) : Boolean;
var
  Ptr : PEmployee;
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

procedure TEmployeeList.Clear;
var
  Ptr : PEmployee;
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
      
function TEmployeeList.LastAction : TAction;
begin
  Result := aNone;
  if lUndo <> nil then
    Result := lUndo.Action;
end;

function TEmployeeList.LastUndone : TAction;
begin
  Result := aNone;
  if lRedo <> nil then
    Result := lRedo.Action;
end;

procedure TEmployeeList.Undo(Count : Word = 1);
var
  Ptr : PEmployee;
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

procedure TEmployeeList.Redo(Count : Word = 1);
var               
  Ptr : PEmployee;
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

procedure TEmployeeList.WriteInFile(CFile : TEncryptedFile);
var
  Ptr : PEmployee;
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

procedure TEmployeeList.ReadInFile(CFile : TEncryptedFile; Version : Integer);
var
  Index : Integer;
  Employee : PEmployee;
begin
  { Reads data }
  if lFirst <> nil then
    Clear;
  lSize := CFile.ReadInteger;
  for Index := 0 to lSize-1 do
  begin
    New(Employee);
    Employee.Number := CFile.ReadString;
    Employee.Name := CFile.ReadString;
    Employee.Address := CFile.ReadString;
    if Version in [100..101] then
      CFile.ReadString;
    Employee.Telephone := CFile.ReadString;
    Employee.Email := CFile.ReadString;
    Employee.Other := CFile.ReadString;
    if lLast <> nil then
    begin
      Employee.Prev := lLast;
      Employee.Next := nil;
      lLast.Next := Employee;
    end
    else
    begin
      Employee.Prev := nil;
      Employee.Next := nil;
      lFirst := Employee;
    end;
    lLast := Employee;
  end;
end;

procedure TEmployeeList.ExportToFile(FileName : string; Delimiter, Separator : Char);
var
  hFile : TextFile;
  Ptr : PEmployee;
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
