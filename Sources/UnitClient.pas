(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2005 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitClient;

interface
uses SysUtils, EncryptedFile;

type
  PClient = ^TClient;
  TClient = record
		Number,
		Name,
		Address,
		Telephone,
		Email,
		Other : string;

    Prev, Next : PClient;
  end;

  TAction = (aNone, aAdd, aModify, aRemove);
  PUndo = ^TUndo;
  TUndo = record
    Action : TAction;
    Data : TClient;

    Next : PUndo;
  end;

  TClientList = class(TObject)
  private
    lFirst,
    lLast : PClient;
    lSize : Word;    
    lUndo : PUndo;
    lRedo : PUndo;

    procedure NewUndo(Action : TAction; Data : PClient);
  public
    constructor Create;
    destructor Destroy; override;

    function Get(Number : String) : PClient; overload;
    function Get(Index : Word) : PClient; overload;
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

    property First : PClient read lFirst;
    property Last : PClient read lLast;
    property Size : Word read lSize;
  end;

implementation

procedure TClientList.NewUndo(Action : TAction; Data : PClient);
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

constructor TClientList.Create;
begin
  lFirst := nil;
  lLast := nil;
  lSize := 0;
  lUndo := nil;
  lRedo := nil;
end;

destructor TClientList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TClientList.Get(Number : string) : PClient;
begin
  Result := nil;
  if Number <> '' then
  begin
    Result := lFirst;
    while (Result <> nil) and (StrIComp(PChar(Result.Number), PChar(Number)) <> 0) do
      Result := Result.Next;
  end;
end;

function TClientList.Get(Index : Word) : PClient;
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

function TClientList.IndexOf(Number : string) : Word;
var
  CurClient : PClient;
begin
  Result := 0;
  if Number <> '' then
  begin
    CurClient := lFirst;
    while CurClient <> nil do
      if CurClient.Number = Number then
      begin
        Result := Result+1;
        Exit;
      end
      else
      begin
        CurClient := CurClient.Next;
        Result := Result+1;
    end;
  end;
end;

function TClientList.Add(Number, Name, Address, Telephone, Email, Other : String; Undo : Boolean = False) : Boolean;
var
  Ptr, Client : PClient;
begin
  Result := False;
  if (Number <> '') and (Get(Number) = nil) then
  begin
    New(Client);
    Client.Number := Number;
    Client.Name := Name;
    Client.Address := Address;
    Client.Telephone := Telephone;
    Client.Email := Email;
    Client.Other := Other;   
    if not Undo then
      NewUndo(aAdd, Client);
    Ptr := lFirst;
    while (Ptr <> nil) and (Ptr.Number < Number) do
      Ptr := Ptr.Next;
    if Ptr = lFirst then           { Add as first Client }
    begin
      Client.Prev := nil;
      Client.Next := lFirst;
      if lFirst <> nil then
        lFirst.Prev := Client;
      lFirst := Client;
      if lLast = nil then
        lLast := Client;
    end
    else if Ptr = nil then         { Add as last Client }
    begin
      Client.Prev := lLast;
      Client.Next := nil;
      if lLast <> nil then
        lLast.Next := Client;
      lLast := Client;
    end
    else                           { Add before Ptr }
    begin
      Client.Prev := Ptr.Prev;
      Client.Next := Ptr;
      Ptr.Prev.Next := Client;
      Ptr.Prev := Client;
    end;
    Inc(lSize);
    Result := True;
  end;
end;

function TClientList.Modify(Number, Name, Address, Telephone, Email, Other : String; Undo : Boolean = False) : Boolean;
var
  Ptr : PClient;
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

function TClientList.Remove(Index : Word; Undo : Boolean = False) : Boolean;
var
  Ptr : PClient;
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

procedure TClientList.Clear;
var
  Ptr : PClient;
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
      
function TClientList.LastAction : TAction;
begin
  Result := aNone;
  if lUndo <> nil then
    Result := lUndo.Action;
end;

function TClientList.LastUndone : TAction;
begin
  Result := aNone;
  if lRedo <> nil then
    Result := lRedo.Action;
end;

procedure TClientList.Undo(Count : Word = 1);
var
  Ptr : PClient;
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
      aAdd : begin
        Remove(IndexOf(lUndo.Data.Number), True);
      end;
      aModify : begin
        Modify(lUndo.Data.Number, lUndo.Data.Name, lUndo.Data.Address, lUndo.Data.Telephone, lUndo.Data.Email, lUndo.Data.Other, True);
      end;
      aRemove : begin
        Add(lUndo.Data.Number, lUndo.Data.Name, lUndo.Data.Address, lUndo.Data.Telephone, lUndo.Data.Email, lUndo.Data.Other, True);
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

procedure TClientList.Redo(Count : Word = 1);
var              
  Ptr : PClient;
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

procedure TClientList.WriteInFile(CFile : TEncryptedFile);
var
  Ptr : PClient;
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

procedure TClientList.ReadInFile(CFile : TEncryptedFile; Version : Integer);
var
  Index : Integer;
  Client : PClient;
begin
  { Reads data }
  if lFirst <> nil then
    Clear;
  lSize := CFile.ReadInteger;
  for Index := 0 to lSize-1 do
  begin
    New(Client);
    Client.Number := CFile.ReadString;
    Client.Name := CFile.ReadString;
    Client.Address := CFile.ReadString;
    Client.Telephone := CFile.ReadString;
    Client.Email := CFile.ReadString;
    Client.Other := CFile.ReadString;
    if Version < 105 then
    begin
      CFile.ReadString;
      CFile.ReadString;
      CFile.ReadString;
    end;
    if lLast <> nil then
    begin
      Client.Prev := lLast;
      Client.Next := nil;
      lLast.Next := Client;
    end
    else
    begin
      Client.Prev := nil;
      Client.Next := nil;
      lFirst := Client;
    end;
    lLast := Client;
  end;
end;

procedure TClientList.ExportToFile(FileName : string; Delimiter, Separator : Char);
var
  hFile : TextFile;
  Ptr : PClient;
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
