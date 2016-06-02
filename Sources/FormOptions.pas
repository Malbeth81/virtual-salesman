(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormOptions;

interface

uses
  SysUtils, Windows, Messages, StdCtrls, Controls,  Classes, Forms, ComCtrls, ExtCtrls,
  Dialogs, Graphics, StrUtils2, LanguagePack, UnitMessages, UnitUsers, UnitPrint;

type
  TfrmOptions = class(TForm)
    FontDialog: TFontDialog;
    btnOk: TButton;
    btnCancel: TButton;
    pgcOptions: TPageControl;
    tbsGeneral: TTabSheet;
    tbsPrinting: TTabSheet;
    tbsSecurity: TTabSheet;
    tbsSaving: TTabSheet;
    lblLanguage: TLabel;
    cmbLanguages: TComboBox;
    chkAutoUpdate: TCheckBox;
    lblMargins: TLabel;
    lblMarginTop: TLabel;
    edtMarginTop: TEdit;
    lblMarginbottom: TLabel;
    edtMarginBottom: TEdit;
    lblMarginLeft: TLabel;
    edtMarginLeft: TEdit;
    lblMarginRight: TLabel;
    edtMarginRight: TEdit;
    lblPrintFont: TLabel;
    lblFont: TLabel;
    btnFont: TButton;
    chkAutoSave: TCheckBox;
    edtAutoSave: TEdit;
    udwAutoSave: TUpDown;
    chkAskAutoSave: TCheckBox;
    chkMsgAutoSave: TCheckBox;
    chkLogin: TCheckBox;
    btnAddUser: TButton;
    btnEditUser: TButton;
    btnDeleteUser: TButton;
    lstUsers: TListBox;
    lblUser: TLabel;
    lblAutoSave1: TLabel;
    lblAutoSave2: TLabel;
    lblSeparator: TLabel;
    cmbSeparator: TComboBox;
    lblDelimiter: TLabel;
    cmbDelimiter: TComboBox;
    lblExport: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkAutoSaveClick(Sender: TObject);
    procedure lstUsersClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnAddUserClick(Sender: TObject);
    procedure btnEditUserClick(Sender: TObject);
    procedure btnDeleteUserClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  public
    function Show : Boolean; reintroduce;
    procedure ListLanguagePacks;
    procedure DisplayUsers;
  private
    LanguageFiles : TStrings;
  end;

var
  frmOptions: TfrmOptions;

implementation

uses FormUser, FormMain;

{$R *.dfm}

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  LanguageFiles := TStringList.Create;
end;

procedure TfrmOptions.FormDestroy(Sender: TObject);
begin
  LanguageFiles.Free;
end;

procedure TfrmOptions.FormShow(Sender: TObject);
begin
  with frmMain do
  begin
    ListLanguagePacks;
    DisplayUsers;
    cmbLanguages.ItemIndex := LanguageFiles.IndexOf(LanguageFile);
    lblFont.Font.Assign(PrintFont);
    lblFont.Caption := PrintFont.Name + ', ' + IntToStr(PrintFont.Size) + 'pts';
    edtMarginLeft.Text := IntToStr(PrintMargins.Left);
    edtMarginRight.Text := IntToStr(PrintMargins.Right);
    edtMarginTop.Text := IntToStr(PrintMargins.Top);
    edtMarginBottom.Text := IntToStr(PrintMargins.Bottom);
    chkAutoUpdate.Checked := AutoUpdate;
    chkAutoSave.Checked := AutoSave;
    chkAskAutoSave.Checked := AskAutoSave;
    chkMsgAutoSave.Checked := MsgAutoSave;
    udwAutoSave.Position := AutoSaveTime;
    edtAutoSave.Enabled := chkAutoSave.Checked;
    udwAutoSave.Enabled := chkAutoSave.Checked;
    cmbDelimiter.ItemIndex := cmbDelimiter.Items.IndexOf(ExportDelimiter);
    cmbSeparator.ItemIndex := cmbSeparator.Items.IndexOf(ExportSeparator);
    chkLogin.Checked := Users.AskLogin;
    pgcOptions.ActivePageIndex := 0;
  end;
end;

procedure TfrmOptions.chkAutoSaveClick(Sender: TObject);
begin
  lblAutoSave1.Enabled := chkAutoSave.Checked;
  lblAutoSave2.Enabled := chkAutoSave.Checked;
  edtAutoSave.Enabled := chkAutoSave.Checked;
  udwAutoSave.Enabled := chkAutoSave.Checked;
end;

procedure TfrmOptions.btnFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(lblFont.Font);
  if FontDialog.Execute then
  begin
    lblFont.Font.Assign(FontDialog.Font);
    lblFont.Caption := FontDialog.Font.Name + ', ' + IntToStr(FontDialog.Font.Size) + ' pts';
  end;
end;
               
procedure TfrmOptions.lstUsersClick(Sender: TObject);
begin
  if lstUsers.ItemIndex >= 0 then
    btnDeleteUser.Enabled := not (lstUsers.Items[lstUsers.ItemIndex] = 'admin');
end;

procedure TfrmOptions.btnAddUserClick(Sender: TObject);
begin     
  if rAddUser in frmMain.User.Rights then
    frmUser.Show(mAdd)
  else
    ShowError(22); { No rights }
end;
    
procedure TfrmOptions.btnEditUserClick(Sender: TObject);
begin
  if rEditUser in frmMain.User.Rights then
    frmUser.Show(mEdit)
  else
    ShowError(22); { No rights }
end;

procedure TfrmOptions.btnDeleteUserClick(Sender: TObject);
begin
  if rDeleteUser in frmMain.User.Rights then
  begin
    if (lstUsers.ItemIndex >= 0) and (lstUsers.ItemIndex < frmMain.Users.Size) then
      if AskQuestion(2) = idYes then { Deletion confirmation }
        if frmMain.Users.Remove(lstUsers.ItemIndex+1) then
          DisplayUsers;
  end
  else
    ShowError(22); { No rights }
end;

procedure TfrmOptions.btnOkClick(Sender: TObject);
begin
  if chkLogin.Checked and (frmMain.Users.First = nil) then
  begin
    ShowError(21); { Must add a user }
    pgcOptions.ActivePageIndex := 3;
  end
  else
    with frmMain do
    begin
      LanguageFile := LanguageFiles[cmbLanguages.ItemIndex];
      TranslateTo(LanguageFile);
      PrintFont.Assign(lblFont.Font);
      PrintMargins.Left := StrToInt(edtMarginLeft.Text);
      PrintMargins.Right := StrToInt(edtMarginRight.Text);
      PrintMargins.Top := StrToInt(edtMarginTop.Text);
      PrintMargins.Bottom := StrToInt(edtMarginBottom.Text);
      AutoUpdate := chkAutoUpdate.Checked;
      AutoSave := chkAutoSave.Checked;
      AskAutoSave := chkAskAutoSave.Checked;
      MsgAutoSave := chkMsgAutoSave.Checked;
      AutoSaveTime := udwAutoSave.Position;     
      ExportDelimiter := cmbDelimiter.Text[1];
      ExportSeparator := cmbSeparator.Text[1];
      Users.AskLogin := chkLogin.Checked;
      Users.SaveToFile(MakeFileName(RootDir, 'users.dat'));
      SaveOptions;
      Self.ModalResult := mrOk;
    end;
end;

function TfrmOptions.Show : Boolean;
begin
  Result := (ShowModal = mrOk);
end;

procedure TfrmOptions.ListLanguagePacks;
var
  FileInfo : TSearchRec;
  LangPack : TLangPack;
begin
  cmbLanguages.Items.Clear;
  LanguageFiles.Clear;
  LangPack := TLangPack.Create;
  if FindFirst(frmMain.RootDir+'*.lang', faAnyFile, FileInfo) = 0 then
  begin
    repeat
    begin
      if (FileInfo.Attr and faDirectory) = 0 then
        if LangPack.LoadHeaderFromFile(frmMain.RootDir+FileInfo.Name) then
        begin
          cmbLanguages.Items.Add(LangPack.Name);
          LanguageFiles.Add(FileInfo.Name);
        end;
    end;
    until FindNext(FileInfo) <> 0;
    SysUtils.FindClose(FileInfo);
  end;
  LangPack.Free;
end;

procedure TfrmOptions.DisplayUsers;
var
  CurUser : PUser;
  SelIndex : Integer;
begin
  SelIndex := lstUsers.ItemIndex;
  lstUsers.items.Clear;
  CurUser := frmMain.Users.First;
  while CurUser <> nil do
  begin
    lstUsers.AddItem(CurUser.Name, nil);
    CurUser := CurUser.Next;
  end;            
  lstUsers.ItemIndex := SelIndex;
  lstUsers.OnClick(Self);
end;

end.
