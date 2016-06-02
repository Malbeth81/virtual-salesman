unit UnitImport;

interface

uses StrUtils, SysUtils;

type
  TFieldValues = array of string;

  PRow = ^TRow;
  TRow = record
    Field : TFieldValues;
    Prev, Next : PRow;
  end;

  TImport = class(TObject)
  private
    FDelimiter,
    FSeparator : Char;
    FFirstRow : PRow;
    FLastRow : PRow;
    FRowCount : Word;

    procedure StringToArray(const Str : string; var A : TFieldValues);
  public
    constructor Create(FileName : string; Delimiter, Separator : Char);
    property FirstRow : PRow read FFirstRow;
    property LastRow : PRow read FLastRow;
    property RowCount : Word read FRowCount;
  end;

implementation

constructor TImport.Create(FileName : string; Delimiter, Separator : Char);
var
  hFile : TextFile;
  Str : string;
  Row : PRow;
begin
  if FileExists(FileName) then
  begin
    FDelimiter := Delimiter;
    FSeparator := Separator;
    try
      AssignFile(hFile, FileName);
      Reset(hFile);
      while not EOF(hFile) do
      begin
        ReadLn(hFile, Str);
        New(Row);
        StringToArray(Str, Row.Field);
        Row.Prev := FLastRow;
        Row.Next := nil;
        if FLastRow <> nil then
          FLastRow.Next := Row
        else
          FFirstRow := Row;
        FLastRow := Row;
        Inc(FRowCount);
      end;
      CloseFile(hFile);
    except
      CloseFile(hFile);
    end;
  end;
end;

char*[] StringToArray(const Str : string; var A : TFieldValues);
var
  i, j, k : Integer;
begin
  i := 1;
  j := 0;
  while i < Length(Str) do
  begin
    if Str[i] = FDelimiter then
    begin
      SetLength(A, j+1);
      k := PosEx(FDelimiter+FSeparator, Str, i+1);
      if k = 0 then
        k := Length(Str);
      A[j] := Copy(Str, i+1, k-i-1);
      i := k;
    end
    else
    begin     
      SetLength(A, j+1);
      k := PosEx(FSeparator, Str, i);
      if k = 0 then
        k := Length(Str)+1;
      A[j] := Copy(Str, i, k-i);
      i := k;
    end;
    Inc(i);
    Inc(j);
  end;
end;

end.
