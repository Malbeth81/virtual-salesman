(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2004 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitMessages;

interface
  uses Forms, Windows, Classes, SysUtils, StrUtils2;

  procedure ShowError(Code : Integer; Param : String = '');
  procedure ShowMessage(Code : Integer; Param : String = '');
  function AskQuestion(Code : Integer; Param : String = ''; Cancel : Boolean = False) : Integer;
          
var
  MsgStr : TStringList;

implementation

procedure ShowError(Code : Integer; Param : String = '');
var
  Name : string;
begin
  if Code in [1..23] then
  begin
    if Code < 10 then
      Name := 'E0'+IntToStr(Code)
    else
      Name := 'E'+IntToStr(Code);
    Application.MessageBox(PChar(ReplaceAll2(MsgStr.Values[Name], ';', Param)), PChar(MsgStr.Values['E00']), mb_Ok);
  end;
end;

procedure ShowMessage(Code : Integer; Param : String = '');
var
  Name : string;
begin
  if Code in [1..5] then
  begin
    if Code < 10 then
      Name := 'M0'+IntToStr(Code)
    else
      Name := 'M'+IntToStr(Code);
    Application.MessageBox(PChar(ReplaceAll2(MsgStr.Values[Name], ';', Param)), PChar(MsgStr.Values['M0']), mb_Ok);
  end;
end;

function AskQuestion(Code : Integer; Param : String = ''; Cancel : Boolean = False) : Integer;
var
  Name : string;
begin
  Result := 0;
  if Code in [1..8] then   
  begin
    if Code < 10 then
      Name := 'Q0'+IntToStr(Code)
    else
      Name := 'Q'+IntToStr(Code);
    if Cancel then
      Result := Application.MessageBox(PChar(ReplaceAll2(MsgStr.Values[Name], ';', Param)), PChar(MsgStr.Values['Q0']), mb_YesNoCancel)
    else
      Result := Application.MessageBox(PChar(ReplaceAll2(MsgStr.Values[Name], ';', Param)), PChar(MsgStr.Values['Q0']), mb_YesNo);
  end;
end;

initialization
  MsgStr := TStringList.Create;
  MsgStr.Add('E00=Error');
  MsgStr.Add('E01=Unable to open the file ";"! It is not a Virtual Salesman file or it is currently used by another application.');
  MsgStr.Add('E02=Unable to open the file ";"! It may be an older and incompatible Virtual Salesman file format.');
  MsgStr.Add('E03=Unable to read or write data in the file ";"! The file could be damaged, please contact technical support.');
  MsgStr.Add('E04=The user file is missing or is currupted the program will now close! Please contact technical support.');
  MsgStr.Add('E05=Please enter the text you would like to search for or click on Cancel!');
  MsgStr.Add('E06=You must enter a name!');
  MsgStr.Add('E07=You must enter a code!');
  MsgStr.Add('E08=You must enter a number!');
  MsgStr.Add('E09=This name is already used! Each company, inventory or user name must be unique.');
  MsgStr.Add('E10=This code is already used! Each product or group code must be unique.');
  MsgStr.Add('E11=This number is already used! Each employee, client or supplier number must be unique.');
  MsgStr.Add('E12=Cannot find the requested application! It may not be installed on this computer.');
  MsgStr.Add('E13=You must add at least one group before you can add products.');
  MsgStr.Add('E14=The username and password you entered do not match!');
  MsgStr.Add('E15=You cannot modify the content of a saved invoice!');
  MsgStr.Add('E16=The value for the deposit must be at least ;% of the total!');
  MsgStr.Add('E17=The quantity of the product sold must be different then zero and lower or equal to the quantity in the inventory!');
  MsgStr.Add('E18=Unable to access the internet to look for updates! If this computer does not have access to the internet please uncheck the auto-update feature in the options.');
  MsgStr.Add('E19=The price of a product cannot be lower than it''s cost!');
  MsgStr.Add('E20=No salesman has been selected, you must select your name in the salesman list.');
  MsgStr.Add('E21=There are no users in the list! You must add at least one user if you turn on username and password identification.');
  MsgStr.Add('E22=The username you used to login does not have the required rights to accomplish this operation!');
  MsgStr.Add('E23=You must select the collumn that contains the code or number (this value is mandatory)!');  
  MsgStr.Add('M00=Message');
  MsgStr.Add('M01=The automatic save procedure completed successfully!');
  MsgStr.Add('M02=You must specify the properties of this transaction before you can continue.');
  MsgStr.Add('M03=You already have the latest version of the Virtual Salesman, no update is necessary.');
  MsgStr.Add('M04=The license data entered seams to be valid. The program is now registered.');
  MsgStr.Add('M05=The license data entered is invalid!');
  MsgStr.Add('Q00=Question');
  MsgStr.Add('Q01=Would you like to save all of the modification now?');
  MsgStr.Add('Q02=Are you sure that you want to delete this item?');
  MsgStr.Add('Q03=Are you sure that you want to delete this logo?');
  MsgStr.Add('Q04=This invoice must be saved before it can be printed! Would you like to save it now?');
  MsgStr.Add('Q05=After an invoice is saved it cannot be modified! Also, the quantity of the products sold will be substracted from the quantity in the inventory. Do you really want to save this invoice now?');
  MsgStr.Add('Q06=A new version of Virtual Salesman is available! Do you want to download it now?');
  MsgStr.Add('Q07=No result found from the current position in the list! Do you want to seach again from the beginning?');
  MsgStr.Add('Q08=Do you want to print the content of the selected group only? Click on No to print the entire inventory.');
finalization
  MsgStr.Free;

end.

