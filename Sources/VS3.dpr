(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c) 2003-2005 Marc-Andre Lamothe **********************)
(* All rights reserved *********************************************)

program VS3;



uses
  Forms,
  FormMain in 'FormMain.pas' {frmMain},
  FormAbout in 'FormAbout.pas' {frmAbout},
  FormCompany in 'FormCompany.pas' {frmCompany},
  FormGroup in 'FormGroup.pas' {frmGroup},
  FormOpen in 'FormOpen.pas' {frmOpen},
  FormOptions in 'FormOptions.pas' {frmOptions},
  FormLogin in 'FormLogin.pas' {frmLogin},
  FormClient in 'FormClient.pas' {frmClient},
  FormProduct in 'FormProduct.pas' {frmProduct},
  FormReports in 'FormReports.pas' {frmReports},
  FormSave in 'FormSave.pas' {frmSave},
  FormStats in 'FormStats.pas' {frmStats},
  UnitCompany in 'UnitCompany.pas',
  UnitGroup in 'UnitGroup.pas',
  UnitInventory in 'UnitInventory.pas',
  UnitMessages in 'UnitMessages.pas',
  UnitTransaction in 'UnitTransaction.pas',
  UnitUsers in 'UnitUsers.pas',
  UnitSupplier in 'UnitSupplier.pas',
  UnitPrint in 'UnitPrint.pas',
  UnitProduct in 'UnitProduct.pas',
  UnitReport in 'UnitReport.pas',
  UnitSelection in 'UnitSelection.pas',
  UnitEmployee in 'UnitEmployee.pas',
  UnitClient in 'UnitClient.pas',
  FormEmployee in 'FormEmployee.pas' {frmEmployee},
  FormSupplier in 'FormSupplier.pas' {frmSupplier},
  FormTransaction in 'FormTransaction.pas' {frmTransaction},
  FormSelection in 'FormSelection.pas' {frmSelection},
  FormSelect in 'FormSelect.pas' {frmSelect},
  FormPrint in 'FormPrint.pas' {frmPrint},
  FormUser in 'FormUser.pas' {frmUser},
  FormFind in 'FormFind.pas' {frmFind},
  UnitImport in 'UnitImport.pas',
  FormImport in 'FormImport.pas' {frmImport};

{$E exe}

{$R *.res}
{$R Resources\WinXP.res}

begin
  Application.Initialize;
  Application.Title := 'Virtual Salesman 3';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmCompany, frmCompany);
  Application.CreateForm(TfrmGroup, frmGroup);
  Application.CreateForm(TfrmOpen, frmOpen);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmClient, frmClient);
  Application.CreateForm(TfrmProduct, frmProduct);
  Application.CreateForm(TfrmReports, frmReports);
  Application.CreateForm(TfrmSave, frmSave);
  Application.CreateForm(TfrmStats, frmStats);
  Application.CreateForm(TfrmEmployee, frmEmployee);
  Application.CreateForm(TfrmSupplier, frmSupplier);
  Application.CreateForm(TfrmTransaction, frmTransaction);
  Application.CreateForm(TfrmSelection, frmSelection);
  Application.CreateForm(TfrmSelect, frmSelect);
  Application.CreateForm(TfrmPrint, frmPrint);
  Application.CreateForm(TfrmUser, frmUser);
  Application.CreateForm(TfrmFind, frmFind);
  Application.CreateForm(TfrmImport, frmImport);
  Application.Run;
end.
