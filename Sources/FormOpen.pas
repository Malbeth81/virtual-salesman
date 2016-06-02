(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormOpen;

interface

  uses
    SysUtils, Windows, Messages, StdCtrls, Controls, ExtCtrls, Classes,
    Registry, Forms, Grids, StrUtils2, WinUtils, UnitMessages, UnitCompany;

type
  TfrmOpen = class(TForm)
    stgOpen: TStringGrid;
    pnlBottom: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure stgOpenDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure stgOpenDblClick(Sender: TObject);   
    procedure pnlBottomResize(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject); 
  public
    function Show : Boolean; reintroduce;
    procedure DisplayCompanies;
    procedure LoadAppearance;
    procedure SaveAppearance;
  private
    Companies : TStringList;
  end;

var
  frmOpen: TfrmOpen;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmOpen.FormCreate(Sender: TObject);
begin
  Companies := TStringList.Create;
  LoadAppearance;
  stgOpen.Rows[0].Text := 'Name'+#13#10+'Size'+#13#10+'Folder';
end;
     
procedure TfrmOpen.FormDestroy(Sender: TObject);
begin
  Companies.Free;
end;

procedure TfrmOpen.FormShow(Sender: TObject);
begin
  DisplayCompanies;
  stgOpen.SetFocus;
  btnOk.Enabled := (Companies.Count > 0);
end;

procedure TfrmOpen.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveAppearance;   
end;

procedure TfrmOpen.stgOpenDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if stgOpen.ColWidths[ACol] > stgOpen.ClientWidth then
    stgOpen.ColWidths[ACol] := stgOpen.ClientWidth -16;
end;

procedure TfrmOpen.stgOpenDblClick(Sender: TObject);
begin
  btnOk.Click;
end;

procedure TfrmOpen.pnlBottomResize(Sender: TObject);
begin
  btnOk.Left := pnlBottom.Width-141;
  btnCancel.Left := pnlBottom.Width-69;
end;

procedure TfrmOpen.btnOkClick(Sender: TObject);
begin
  if stgOpen.Row <= Companies.Count then
    with frmMain do
    begin
      if Inventory <> nil then
        CloseInventory;
      if Transaction <> nil then
        CloseTransaction;
      OpenCompany(Companies[stgOpen.Row-1]);
      Self.ModalResult := mrOk;
    end;
end;

function TfrmOpen.Show : Boolean;
begin
  Result := (ShowModal = mrOk);
end;

procedure TfrmOpen.DisplayCompanies;
var
  FileInfo : TSearchRec;
  Company : TCompany;
  FileName : String;
begin
  stgOpen.RowCount := 2;
  stgOpen.Rows[1].Clear;
  Companies.Clear;
  Company := TCompany.Create;
  if FindFirst(frmMain.RootDir+'*.*', faAnyFile, FileInfo) = 0 then
  begin
    repeat
    begin
      if ((FileInfo.Attr and faDirectory) <> 0) and (FileInfo.Name <> '.') and (FileInfo.Name <> '..') then
      begin
        FileName := frmMain.RootDir+FileInfo.Name+'\'+FileInfo.Name+CieExt;
        if FileExists(FileName) then
          case Company.LoadHeaderFromFile(FileName) of
            10 : ShowError(1, FileInfo.Name+CieExt);
            12,13 : ShowError(2, FileInfo.Name+CieExt);
            14,15 : ShowError(3, FileInfo.Name+CieExt);
          else
            stgOpen.Cells[0, stgOpen.RowCount-1] := Company.Name;
            stgOpen.Cells[1, stgOpen.RowCount-1] := FormatFloat('0.00', FolderSize(frmMain.RootDir+FileInfo.Name)/1024) + ' Ko';
            stgOpen.Cells[2, stgOpen.RowCount-1] := FileInfo.Name;
            stgOpen.RowCount := stgOpen.RowCount+1;
            Companies.Add(FileInfo.Name+'\'+FileInfo.Name+CieExt);
          end;
      end;
    end;
    until FindNext(FileInfo) <> 0;
    SysUtils.FindClose(FileInfo);
  end;
  Company.Free;
  if stgOpen.RowCount > 2 then
    stgOpen.RowCount := stgOpen.RowCount -1;
end;
    
procedure TfrmOpen.LoadAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin                                              
      frmOpen.Width := Reg.ReadInteger('FormOpenWidth');
      frmOpen.Height := Reg.ReadInteger('FormOpenHeight');
      stgOpen.ColWidths[0] := Reg.ReadInteger('FormOpenCol01');
      stgOpen.ColWidths[1] := Reg.ReadInteger('FormOpenCol02');
      stgOpen.ColWidths[2] := Reg.ReadInteger('FormOpenCol03');
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

procedure TfrmOpen.SaveAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin
      Reg.WriteInteger('FormOpenWidth', frmOpen.Width);
      Reg.WriteInteger('FormOpenHeight', frmOpen.Height);
      Reg.WriteInteger('FormOpenCol01', stgOpen.ColWidths[0]);
      Reg.WriteInteger('FormOpenCol02', stgOpen.ColWidths[1]);
      Reg.WriteInteger('FormOpenCol03', stgOpen.ColWidths[2]);
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

end.
