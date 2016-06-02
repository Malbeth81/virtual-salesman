(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitUsers;

interface   
  uses SysUtils, Windows, EncryptedFile, StrUtils;

type
  TRights = set of (rAddInventory, rDeleteInventory, rOpenInventory,
                    rAddEmployee, rDeleteEmployee, rEditEmployee,
                    rAddClient, rDeleteClient, rEditClient,
                    rAddSupplier, rDeleteSupplier, rEditSupplier,
                    rAddTransaction, rDeleteTransaction, rOpenTransaction,
                    rAddGroup, rDeleteGroup, rEditGroup,
                    rAddProduct, rDeleteProduct, rEditProduct,
                    rAddUser, rDeleteUser, rEditUser,
                    rEditCompany);
  PUser = ^TUser;
  TUser = record
   Name,
   Password : string;
   Rights : TRights;

   Prev, Next : PUser;
  end;

  TUserlist = class (TObject)
  private
    lAskLogin : Boolean;
    lFirst,
    lLast : PUser;
    lSize : Word;
  public
    constructor Create;
    destructor Destroy; override;

    function Get(Username : String) : PUser; overload;
    function Get(Index : Word) : PUser; overload;
    function IndexOf(Username : String) : Word;

    function Add(Username, Password : String; Rights : TRights) : Boolean;
    function Modify(Username, Password : String; Rights : TRights) : Boolean;
    function Remove(Index : Word) : Boolean;
    procedure Clear;

    function SaveToFile(Filename : string) : Boolean;
    function LoadFromFile(Filename : string) : Boolean;
                                             
    property AskLogin : Boolean read lAskLogin write lAskLogin;
    property First : PUser read lFirst;
    property Last : PUser read lLast;
    property Size : Word read lSize;
  end;

implementation

constructor TUserlist.Create;
begin        
  lAskLogin := False;
  lFirst := nil;
  lLast := nil;
  lSize := 0;
end;
           
destructor TUserlist.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TUserlist.Get(Username : String) : PUser;
begin
  Result := nil;
  if Username <> '' then
  begin
    Result := lFirst;
    while (Result <> nil) and (StrIComp(PChar(Result.Name), PChar(Username)) <> 0) do
      Result := Result.Next;
  end;
end;
                                            
function TUserlist.Get(Index : Word) : PUser;
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

function TUserlist.IndexOf(Username : string) : Word;
var
  CurUser : PUser;
begin
  Result := 0;
  if Username <> '' then
  begin
    CurUser := lFirst;
    while CurUser <> nil do
      if StrIComp(PChar(CurUser.Name), PChar(Username)) <> 0 then
      begin
        Result := Result+1;
        Exit;
      end
      else
      begin
        CurUser := CurUser.Next;
        Result := Result+1;
      end;
  end;
end;

function TUserlist.Add(Username, Password : String; Rights : TRights) : Boolean;
var
  Ptr, User : PUser;
begin
  Result := False;
  if (Username <> '') and (Get(Username) = nil) then
  begin
    New(User);
    User.Name := Username;
    User.Password := Password; 
    User.Rights := Rights;
    Ptr := lFirst;
    while (Ptr <> nil) and (Ptr.Name < Username) do
      Ptr := Ptr.Next;
    if Ptr = lFirst then           { Add as first User }
    begin
      User.Prev := nil;
      User.Next := lFirst;
      if lFirst <> nil then
        lFirst.Prev := User;
      lFirst := User;
      if lLast = nil then
        lLast := User;
    end
    else if Ptr = nil then         { Add as last User }
    begin
      User.Prev := lLast;
      User.Next := nil;
      if lLast <> nil then
        lLast.Next := User;
      lLast := User;
    end
    else                           { Add before Ptr }
    begin
      User.Prev := Ptr.Prev;
      User.Next := Ptr;
      Ptr.Prev.Next := User;
      Ptr.Prev := User;
    end;
    lSize := lSize +1;
    Result := True;
  end;
end;

function TUserList.Modify(Username, Password : String; Rights : TRights) : Boolean;
var
  Ptr : PUser;
begin
  Result := False;
  Ptr := Get(Username);
  if Ptr <> nil then
  begin
    Ptr.Password := Password;
    Ptr.Rights := Rights;
    Result := True;
  end;
end;

function TUserList.Remove(Index : Word) : Boolean;
var
  Ptr : PUser;
begin
  Result := False;
  Ptr := Get(Index);
  if Ptr <> nil then
  begin
    if Ptr.Prev = nil then
      lFirst := Ptr.Next
    else
      Ptr.Prev.Next := Ptr.Next;
    if Ptr.Next = nil then
      lLast := Ptr.Prev
    else
      Ptr.Next.Prev := Ptr.Prev;
    Dispose(Ptr);
    lSize := lSize -1;
    Result := True;
  end;
end;

procedure TUserList.Clear;
var
  Ptr : PUser;
begin
  while lFirst <> nil do
  begin
    Ptr := lFirst;
    lFirst := Ptr.Next;
    Dispose(Ptr);
  end;
  lLast := nil;
  lSize := 0;
end;

function TUserList.SaveToFile(Filename : string) : Boolean;
var
  CFile : TEncryptedFile;
  Ptr : PUser;
begin
  CFile := TEncryptedFile.Create;
  CFile.AssignFile(Filename);
  try
    CFile.Rewrite;
    CFile.WriteInteger(Integer(lAskLogin));
    CFile.WriteInteger(lSize);
    Ptr := lFirst;
    while Ptr <> nil do
    begin
      CFile.WriteString(Ptr.Name);
      CFile.WriteString(Ptr.Password);  
      CFile.WriteInteger(Integer(Ptr.Rights));
      Ptr := Ptr.Next;
    end;
    CFile.Free;
    Result := True;
  except
    CFile.Free;
    Result := False;
  end;
end;

function TUserList.LoadFromFile(Filename : string) : Boolean;
var
  CFile : TEncryptedFile;
  Index : Integer;
  User : PUser;
  Temp : Integer;
begin
  CFile := TEncryptedFile.Create;
  if not FileExists(Filename) then
  begin
    Result := False;
		Exit;
  end;
  CFile.AssignFile(Filename);
 	try
   	CFile.Reset;
    if lFirst <> nil then
      Clear;
    lAskLogin := Bool(CFile.ReadInteger);
    lSize := CFile.ReadInteger;
    for Index := 0 to lSize-1 do
    begin
      New(User);
      User.Name := CFile.ReadString;
      User.Password := CFile.ReadString;
      Temp := CFile.ReadInteger;
      User.Rights := TRights(Temp);
      if lLast <> nil then
      begin
        User.Prev := lLast;
        User.Next := nil;
        lLast.Next := User;
      end
      else
      begin
        User.Prev := nil;
        User.Next := nil;
        lFirst := User;
      end;
      lLast := User;
    end;
    CFile.Free;
   	Result := True;
  except
    CFile.Free;
   	Result := False;
  end;
end;
    
end.
