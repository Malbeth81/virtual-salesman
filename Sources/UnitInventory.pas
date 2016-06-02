(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitInventory;

interface
  uses SysUtils, EncryptedFile, UnitGroup ;

const
  InvExt = '.v3i';

{ Returned error codes of SaveToFile and LoadFromFile
  00 : No errors
  10 : Cannot open file
  12 : Wrong file type
  13 : Wrong file version
  14 : Write error
  15 : Read error }

type
  TInventory = class (TObject)
  private
    iName : String ;
    iDate : TDateTime ;
    iDescription : String ;
    iGroups : TGroupList ;
  published
    property Name : String read iName ;
    property Date : TDateTime read iDate write iDate ;
    property Description : String read iDescription write iDescription ;
    property Groups : TGroupList read iGroups ;
  public
    constructor Create(Name : String = '' ; Date : TDateTime = 0 ; Description : String = '') ;
    destructor Destroy ; override ;

    procedure Clear ;
    function SaveToFile(FileName : String) : Word ;
    function LoadFromFile(FileName : String) : Word ;
    function LoadHeaderFromFile(FileName : String) : Word ;
  end ;

implementation
        
const
  FileType = 'VV3Inventory';
  FileVersion = 100;
  Supported = 100;

  constructor TInventory.Create(Name : String = '' ; Date : TDateTime = 0 ; Description : String = '') ;
  begin           
    iName := Name ;
    iDate := Date ;
    iDescription := Description ;
    iGroups := TGroupList.Create ;
  end ;

  destructor TInventory.Destroy ;
  begin
    iGroups.Free ;
    inherited Destroy ;
  end ;
          
  procedure TInventory.Clear ;
  begin
    iName := '' ;
    iDate := 0 ;
    iDescription := '' ;
    iGroups.Clear ;
  end ;

  function TInventory.SaveToFile(FileName : String) : Word ;
  var
    CFile : TEncryptedFile ;
  begin
    CFile := TEncryptedFile.Create ;
    try
      CFile.AssignFile(FileName) ;
      CFile.Rewrite ;
    except   
      on Exception do begin
        CFile.Free ;
        Result := 10 ;
        Exit ;
      end ;
    end ;
    try
      { Writes file info }
      CFile.WriteString(FileType) ;
      CFile.WriteInteger(FileVersion) ;

      { Writes data }
      CFile.WriteString(iName) ;
      CFile.WriteFloat(iDate) ;
      CFile.WriteString(iDescription) ;
      iGroups.WriteInFile(CFile) ;
      CFile.Free ;
      Result := 00 ;
    except   
      on Exception do begin
        CFile.Free ;
        Result := 14 ;
      end ;
    end ;
  end ;

  function TInventory.LoadFromFile(FileName : String) : Word ;
  var
    CFile : TEncryptedFile ; 
    Version : Integer;
  begin
    CFile := TEncryptedFile.Create ;
    try
      CFile.AssignFile(FileName) ;
      CFile.Reset ;
    except   
      on Exception do begin
        CFile.Free ;
        Result := 10 ;
        Exit ;
      end ;
    end ;
    try
      { Reads file info }
      if CFile.ReadString <> FileType then
      begin
        Result := 12 ;
        Exit ;
      end ;
      Version := CFile.ReadInteger;
      if not (Version in [Supported..FileVersion]) then
      begin
        Result := 13;
        Exit;
      end;

      { Reads data }
      iName := CFile.ReadString() ;
      iDate := CFile.ReadFloat() ;
      iDescription := CFile.ReadString() ;
      iGroups.ReadInFile(CFile) ;

      CFile.Free ;
      Result := 00 ;
    except   
      on Exception do begin
        CFile.Free ;
        Result := 15 ;
      end ;
    end ;
  end ;
    
  function TInventory.LoadHeaderFromFile(FileName : String) : Word ;
  var
    CFile : TEncryptedFile ; 
    Version : Integer;
  begin         
    CFile := TEncryptedFile.Create ;
    try
      CFile.AssignFile(FileName) ;
      CFile.Reset ;
    except   
      on Exception do begin
        CFile.Free ;
        Result := 10 ;
        Exit ;
      end ;
    end ;
    try
      { Reads file info }
      if CFile.ReadString <> FileType then
      begin
        Result := 12 ;
        Exit ;
      end ;          
      Version := CFile.ReadInteger;
      if not (Version in [Supported..FileVersion]) then
      begin
        Result := 13;
        Exit;
      end;

      { Reads data }
      iName := CFile.ReadString() ;
      iDate := CFile.ReadFloat() ;
      iDescription := CFile.ReadString() ;
      CFile.Free ;
      Result := 00 ;
    except   
      on Exception do begin
        CFile.Free ;
        Result := 15 ;
      end ;
    end ;
  end ;

end.
