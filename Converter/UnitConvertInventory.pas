(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c) 2003 Marc-Andre Lamothe ***************************)
(* All rights reserved *********************************************)

unit UnitConvertInventory;

interface
  uses SysUtils, UnitCryptedFile, UnitConvertGroup ;
     
const
  FileType = 'VV3Inventory' ;
  FileVersion = 100 ;
            
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
  public
    constructor Create ;
    destructor Destroy ; override ;

    function SaveToFile(FileName : String) : Word ;
    function LoadFromFile(FileName : String) : Word ;
  end ;

implementation

  constructor TInventory.Create ;
  begin
    iGroups := TGroupList.Create ;
  end ;

  destructor TInventory.Destroy ;
  begin
    iGroups.Free ;
    inherited Destroy ;
  end ;

  function TInventory.SaveToFile(FileName : String) : Word ;
  var
    CFile : TCryptedFile ;
  begin
    CFile := TCryptedFile.Create ;
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
    CFile : TCryptedFile ;
  begin
    CFile := TCryptedFile.Create ;
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
    
end.
