unit FormConvert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, UnitWinUtils, UnitStrUtils,
  UnitConvertCompany, UnitConvertInventory, UnitConvertOperation ;

type
  TfrmDBTool = class(TForm)
    btnConvert: TButton;
    edtFileName: TLabeledEdit;
    btnCancel: TButton;
    btnFileName: TButton;
    OpenDialog: TOpenDialog;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnBackup: TButton;
    procedure btnConvertClick(Sender: TObject);
    procedure btnFileNameClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDBTool: TfrmDBTool;

implementation

{$R *.dfm}
           
procedure TfrmDBTool.btnFileNameClick(Sender: TObject);
begin
  OpenDialog.InitialDir := ExtractFileDir(Application.ExeName) ;
  if OpenDialog.Execute then
    edtFileName.Text := OpenDialog.FileName ;
end;
   
procedure TfrmDBTool.btnBackupClick(Sender: TObject) ;
var
  BrowseDialog : TBrowseDialog ;
  FileInfo : TSearchRec ;
  FromDir,
  ToDir : String ;
  Cancel,
  Succeed : Boolean ;
  Flags : Integer ;
begin
  if not FileExists(edtFileName.Text) then
  begin
    ShowMessage('Ce nom de fichier n''est pas valide, le fichier n''existe pas!') ;
    Exit ;
  end ;

  BrowseDialog := TBrowseDialog.Create ;
  BrowseDialog.Caption := 'Veuillez choisir le dossier ou le lecteur où vous désirez éffectué la sauvegarde :' ;
  if BrowseDialog.Execute(frmDBTool.Handle) then
  begin
    FromDir := ExtractFileDir(edtFileName.Text) ;
    ToDir := MakeFileName(BrowseDialog.Folder, ExtractFileName(FromDir)) ;
    Cancel := False ;
    Succeed := True ;
    Flags := 0 ;

    if not CreateDir(ToDir) then
      if Application.MessageBox('Une copie de cette compagnie est déja présente dans le dossier sélectionné.' + #13#10 + 'Voullez-vous enregistrer par dessus?', 'Sauvegarde', mb_YesNo + mb_IconWarning) = id_No then
        Exit ;

    if FindFirst(MakeFileName(FromDir, '*.*'), faAnyFile, FileInfo) = 0 then
    begin
      repeat
        if (FileInfo.Attr and faDirectory) = 0 then
          if not CopyFileEx(PChar(MakeFileName(FromDir, FileInfo.Name)), PChar(MakeFileName(ToDir, FileInfo.Name)), nil, nil, PBool(Cancel), Flags) then
            Succeed := False ;
      until FindNext(FileInfo) <> 0 ;
      SysUtils.FindClose(FileInfo) ;
    end ;

    CreateDir(MakeFileName(ToDir, 'Soumissions')) ;
    if FindFirst(MakeFileName(FromDir, 'Soumissions\*.*'), faAnyFile, FileInfo) = 0 then
    begin
      repeat
        if (FileInfo.Attr and faDirectory) = 0 then
          if not CopyFileEx(PChar(MakeFileName(FromDir, 'Soumissions\' + FileInfo.Name)), PChar(MakeFileName(ToDir, 'Soumissions\' + FileInfo.Name)), nil, nil, PBool(Cancel), Flags) then
            Succeed := False ;
      until FindNext(FileInfo) <> 0 ;
      SysUtils.FindClose(FileInfo) ;
    end ;
                   
    CreateDir(MakeFileName(ToDir, 'Commandes')) ;
    if FindFirst(MakeFileName(FromDir, 'Commandes\*.*'), faAnyFile, FileInfo) = 0 then
    begin
      repeat
        if (FileInfo.Attr and faDirectory) = 0 then
          if not CopyFileEx(PChar(MakeFileName(FromDir, 'Commandes\' + FileInfo.Name)), PChar(MakeFileName(ToDir, 'Commandes\' + FileInfo.Name)), nil, nil, PBool(Cancel), Flags) then
            Succeed := False ;
      until FindNext(FileInfo) <> 0 ;
      SysUtils.FindClose(FileInfo) ;
    end ;
                     
    CreateDir(MakeFileName(ToDir, 'Factures')) ;
    if FindFirst(MakeFileName(FromDir, 'Factures\*.*'), faAnyFile, FileInfo) = 0 then
    begin
      repeat
        if (FileInfo.Attr and faDirectory) = 0 then
          if not CopyFileEx(PChar(MakeFileName(FromDir, 'Factures\' + FileInfo.Name)), PChar(MakeFileName(ToDir, 'Factures\' + FileInfo.Name)), nil, nil, PBool(Cancel), Flags) then
            Succeed := False ;
      until FindNext(FileInfo) <> 0 ;
      SysUtils.FindClose(FileInfo) ;
    end ;
    
    if Succeed then
      ShowMessage('Sauvegarde réusie avec succès!')
    else
      ShowMessage('Une erreur est survenue lors de la sauvegarde!')
  end ;
end;

procedure TfrmDBTool.btnConvertClick(Sender: TObject);
var
  FileInfo : TSearchRec ;
  CurrentDir : String ;
  Company : TCompany ;
  Inventory : TInventory ;
  Operation : TOperation ;
begin        
  if not FileExists(edtFileName.Text) then
  begin
    ShowMessage('Ce nom de fichier n''est pas valide, le fichier n''existe pas!') ;
    Exit ;
  end ;
    
  Company := TCompany.Create ;
  if Company.LoadFromFile(edtFileName.Text) = 00 then
  begin
    CurrentDir := ExtractFileDir(edtFileName.Text) ;
    Company.Employees.LoadFromFile(MakeFileName(CurrentDir, 'Employees.v3d')) ;
    Company.Clients.LoadFromFile(MakeFileName(CurrentDir, 'Clients.v3d')) ;
    Company.Suppliers.LoadFromFile(MakeFileName(CurrentDir, 'Fournisseurs.v3d')) ;
    if Company.SaveToFile(edtFileName.Text) = 00 then
    begin
      DeleteFile(MakeFileName(CurrentDir, 'Employees.v3d')) ;
      DeleteFile(MakeFileName(CurrentDir, 'Clients.v3d')) ;
      DeleteFile(MakeFileName(CurrentDir, 'Fournisseurs.v3d')) ;
    end ;
    Company.Free ;

    if FindFirst(MakeFileName(CurrentDir, '*.v3i'), faAnyFile, FileInfo) = 0 then
    begin
      Inventory := TInventory.Create ;
      repeat
        if (FileInfo.Attr and faDirectory) = 0 then
          if Inventory.LoadFromFile(MakeFileName(CurrentDir, FileInfo.Name)) = 00 then
            Inventory.SaveToFile(MakeFileName(CurrentDir, FileInfo.Name)) ;
      until FindNext(FileInfo) <> 0 ;
      SysUtils.FindClose(FileInfo) ;
      Inventory.Free ;
    end ;

    if FindFirst(MakeFileName(CurrentDir, 'Soumissions\*.v3o'), faAnyFile, FileInfo) = 0 then
    begin
      Operation := TOperation.Create ;
      repeat
        if (FileInfo.Attr and faDirectory) = 0 then
          if Operation.LoadFromFile(MakeFileName(CurrentDir, 'Soumissions\' + FileInfo.Name)) = 00 then
            Operation.SaveToFile(MakeFileName(CurrentDir, 'Soumissions\' + FileInfo.Name)) ;
      until FindNext(FileInfo) <> 0 ;
      SysUtils.FindClose(FileInfo) ;
      Operation.Free ;
    end ;

    if FindFirst(MakeFileName(CurrentDir, 'Commandes\*.v3o'), faAnyFile, FileInfo) = 0 then
    begin
      Operation := TOperation.Create ;
      repeat
        if (FileInfo.Attr and faDirectory) = 0 then
          if Operation.LoadFromFile(MakeFileName(CurrentDir, 'Commandes\' + FileInfo.Name)) = 00 then
            Operation.SaveToFile(MakeFileName(CurrentDir, 'Commandes\' + FileInfo.Name)) ;
      until FindNext(FileInfo) <> 0 ;
      SysUtils.FindClose(FileInfo) ;  
      Operation.Free ;
    end ;
           
    if FindFirst(MakeFileName(CurrentDir, 'Factures\*.v3o'), faAnyFile, FileInfo) = 0 then
    begin
      Operation := TOperation.Create ;
      repeat
        if (FileInfo.Attr and faDirectory) = 0 then
          if Operation.LoadFromFile(MakeFileName(CurrentDir, 'Factures\' + FileInfo.Name)) = 00 then
            Operation.SaveToFile(MakeFileName(CurrentDir, 'Factures\' + FileInfo.Name)) ;
      until FindNext(FileInfo) <> 0 ;
      SysUtils.FindClose(FileInfo) ;
      Operation.Free ;
    end ;
    ShowMessage('Conversion réusie avec succès!') ;
  end
  else
    ShowMessage('Une erreur est survenue lors de la convertion des fichiers!') ;
end;

procedure TfrmDBTool.btnCancelClick(Sender: TObject);
begin
  frmDBTool.Close ;
end;

end.
