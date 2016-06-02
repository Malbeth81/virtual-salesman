(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormMain;

interface

uses
  Windows, ShellAPI, Graphics, Classes, Forms, SysUtils, ExtCtrls,  Menus,
  ImgList, Controls, ToolWin, Grids, StdCtrls, Buttons, IniFiles, ComCtrls,
  Messages, Registry, Dialogs, ColorPicker, StrUtils2, WinUtils, Update,
  LanguagePack, UnitMessages, UnitPrint, UnitCompany, UnitEmployee, UnitClient,
  UnitSupplier, UnitGroup, UnitProduct, UnitInventory, UnitTransaction,
  UnitSelection, UnitReport, UnitUsers;

const
  sVersion = 'Version 3.3.3';
  iVersion = 333 ;
type
  TfrmMain = class(TForm)
    Menu: TMainMenu;
    Menu_File: TMenuItem;
    Menu_Edit: TMenuItem;
    Menu_View: TMenuItem;
    Menu_Help: TMenuItem;
    Menu_File_Open: TMenuItem;
    Menu_File_Save: TMenuItem;
    Menu_File_Print: TMenuItem;
    Menu_File_N1: TMenuItem;
    Menu_File_Export: TMenuItem;
    Menu_File_Import: TMenuItem;
    Menu_File_N3: TMenuItem;
    Menu_File_NewCompany: TMenuItem;
    Menu_File_Properties: TMenuItem;
    Menu_File_CloseFile: TMenuItem;
    Menu_File_N2: TMenuItem;
    Menu_File_Exit: TMenuItem;
    Menu_Edit_Undo: TMenuItem;
    Menu_Edit_Redo: TMenuItem;
    Menu_Edit_N1: TMenuItem;
    Menu_Edit_Add: TMenuItem;
    Menu_Edit_Edit: TMenuItem;
    Menu_Edit_Delete: TMenuItem;
    Menu_Edit_N2: TMenuItem;
    Menu_Edit_Find: TMenuItem;
    Menu_Edit_FindNext: TMenuItem;
    Menu_View_Company: TMenuItem;
    Menu_View_Statistics: TMenuItem;
    Menu_View_Reports: TMenuItem;
    Menu_View_N1: TMenuItem;
    Menu_View_Options: TMenuItem;
    Menu_View_Calculator: TMenuItem;
    Menu_View_Toolbar: TMenuItem;
    Menu_Help_Help: TMenuItem;
    Menu_Help_N1: TMenuItem;
    Menu_Help_ReportBug: TMenuItem;
    Menu_Help_Update: TMenuItem;
    Menu_Help_N2: TMenuItem;
    Menu_Help_About: TMenuItem;
    popToolBar: TPopupMenu;
    popToolBar_Buttons_Help: TMenuItem;
    popToolBar_Buttons_ShowAll: TMenuItem;
    popToolBar_Buttons_Update: TMenuItem;
    popToolBar_Buttons_N1: TMenuItem;
    popToolBar_Buttons: TMenuItem;
    popToolBar_Buttons_Open: TMenuItem;
    popToolBar_Buttons_Save: TMenuItem;
    popToolBar_Buttons_Print: TMenuItem;  
    popToolBar_Buttons_Import: TMenuItem;
    popToolBar_Buttons_Export: TMenuItem;
    popToolBar_Buttons_Properties: TMenuItem;
    popToolBar_Buttons_Close: TMenuItem;
    popToolBar_Buttons_Undo: TMenuItem;
    popToolBar_Buttons_Redo: TMenuItem;
    popToolBar_Buttons_Add: TMenuItem;
    popToolBar_Buttons_Edit: TMenuItem;
    popToolBar_Buttons_Delete: TMenuItem;
    popToolBar_Buttons_Find: TMenuItem;
    popToolBar_Buttons_Company: TMenuItem;
    popToolBar_Buttons_Statistics: TMenuItem;
    popToolBar_Buttons_Reports: TMenuItem;
    popToolBar_Buttons_Options: TMenuItem;
    popToolBar_Buttons_Calculator: TMenuItem;
    popToolBar_TextBelow: TMenuItem;
    popToolBar_TextRight: TMenuItem;
    popToolBar_NoText: TMenuItem;
    popToolBar_N1: TMenuItem;
    popToolBar_Hide: TMenuItem;
    popToolBar_N2: TMenuItem;
    imlIcons: TImageList;
    Timer: TTimer;
    pgcMain: TPageControl;
    tbsInventories: TTabSheet;
    stgInventories: TStringGrid;
    tbsEmployees: TTabSheet;
    stgEmployees: TStringGrid;
    tbsClients: TTabSheet;
    stgClients: TStringGrid;
    tbsSuppliers: TTabSheet;
    stgSuppliers: TStringGrid;
    tbsTransactions: TTabSheet;
    pnlTransactionTop: TPanel;
    tabTransType: TTabControl;
    cmbSalesman: TComboBox;
    lblSalesman: TLabel;
    stgTransactions: TStringGrid;
    pnlInventory: TPanel;
    pnlInventoryTop: TPanel;
    pnlInventoryGroups: TPanel;
    pnlInventoryProducts: TPanel;
    splInventory: TSplitter;
    btnInventoryDate: TButton;
    stgProducts: TStringGrid;
    pnlTransaction: TPanel;
    pnlTransactionBottom: TPanel;
    stgSelections: TStringGrid;
    lblSubTotal: TLabel;
    lblFederalTax: TLabel;
    lblStateTax: TLabel;
    lblTotal: TLabel;
    edtSubTotal: TEdit;
    edtFederalTax: TEdit;
    edtStateTax: TEdit;
    edtTotal: TEdit;
    edtInventoryDate: TEdit;
    edtInventoryDesc: TEdit;
    lblInventoryDate: TLabel;
    lblInventoryDesc: TLabel;
    ToolBar: TToolBar;
    tbnOpen: TToolButton;
    tbnSave: TToolButton;
    tbnPrint: TToolButton;
    tbnImport: TToolButton;
    tbnExport: TToolButton;
    ToolButton1: TToolButton;
    tbnProperties: TToolButton;
    tbnCloseFile: TToolButton;
    ToolButton2: TToolButton;
    tbnUndo: TToolButton;
    tbnRedo: TToolButton;
    ToolButton3: TToolButton;
    tbnAdd: TToolButton;
    tbnEdit: TToolButton;
    tbnDelete: TToolButton;
    ToolButton4: TToolButton;
    tbnFind: TToolButton;
    ToolButton5: TToolButton;
    tbnOptions: TToolButton;
    tbnCalculator: TToolButton;
    ToolButton6: TToolButton;
    tbnCompany: TToolButton;
    tbnStatistics: TToolButton;
    tbnReports: TToolButton;
    ToolButton7: TToolButton;
    tbnHelp: TToolButton;
    tbnUpdate: TToolButton;
    ToolButton8: TToolButton;
    pnlMainTop: TPanel;
    pnlInventorySelGroup: TColorPicker;
    pnlInventorySelProduct: TColorPicker;
    dlgExport: TSaveDialog;
    stgGroups: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure Menu_File_OpenClick(Sender: TObject);
    procedure Menu_File_SaveClick(Sender: TObject);
    procedure Menu_File_PrintClick(Sender: TObject);
    procedure Menu_File_ExportClick(Sender: TObject);
    procedure Menu_File_ImportClick(Sender: TObject);
    procedure Menu_File_NewCompanyClick(Sender: TObject);
    procedure Menu_File_CloseFileClick(Sender: TObject);
    procedure Menu_File_PropertiesClick(Sender: TObject);
    procedure Menu_File_ExitClick(Sender: TObject);
    procedure Menu_EditClick(Sender: TObject);
    procedure Menu_Edit_UndoClick(Sender: TObject);
    procedure Menu_Edit_RedoClick(Sender: TObject);
    procedure Menu_Edit_AddClick(Sender: TObject);
    procedure Menu_Edit_EditClick(Sender: TObject);
    procedure Menu_Edit_DeleteClick(Sender: TObject);
    procedure Menu_Edit_FindClick(Sender: TObject);
    procedure Menu_Edit_FindNextClick(Sender: TObject);
    procedure Menu_View_OptionsClick(Sender: TObject);
    procedure Menu_View_CalculatorClick(Sender: TObject);
    procedure Menu_View_CompanyClick(Sender: TObject);
    procedure Menu_View_StatisticsClick(Sender: TObject);
    procedure Menu_View_ReportsClick(Sender: TObject);
    procedure Menu_View_ToolbarClick(Sender: TObject);
    procedure Menu_Help_HelpClick(Sender: TObject);
    procedure Menu_Help_UpdateClick(Sender: TObject);
    procedure Menu_Help_ReportBugClick(Sender: TObject);
    procedure Menu_Help_AboutClick(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure stgInventoriesEnter(Sender: TObject);
    procedure stgEmployeesEnter(Sender: TObject);
    procedure stgClientsEnter(Sender: TObject);
    procedure stgSuppliersEnter(Sender: TObject);
    procedure stgTransactionsEnter(Sender: TObject);
    procedure stgGroupsEnter(Sender: TObject);
    procedure stgProductsEnter(Sender: TObject);
    procedure stgSelectionsEnter(Sender: TObject);
    procedure pnlInventorySelGroupClick(Sender: TObject);
    procedure pnlInventorySelProductClick(Sender: TObject);
    procedure stgGroupsClick(Sender: TObject);
    procedure edtInventoryDateChange(Sender: TObject);
    procedure btnInventoryDateClick(Sender: TObject);
    procedure edtInventoryDescChange(Sender: TObject);
    procedure tabTransTypeChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure pgcMainResize(Sender: TObject);
    procedure pnlTransactionTopResize(Sender: TObject);
    procedure pnlInventoryTopResize(Sender: TObject);
    procedure pnlTransactionBottomResize(Sender: TObject);
    procedure popToolBar_ButtonsClick(Sender: TObject);
    procedure popToolBar_Buttons_ShowAllClick(Sender: TObject);
    procedure popToolBar_TextBelowClick(Sender: TObject);
    procedure popToolBar_TextRightClick(Sender: TObject);
    procedure popToolBar_NoTextClick(Sender: TObject);
    procedure popToolBar_HideClick(Sender: TObject);
  public
    Texts : TStringList;
    Title : string;
    Updater : TUpdater;
    Users : TUserlist;
    User : PUser;
    Company : TCompany;
    Inventory : TInventory;
    Group : PGroup;
    Transaction : TTransaction;
    Report : TReport;

    RootDir, CurrentFile, CalcPath : string;
    CurrentList : Byte;
    SaveCount : Word;
    ModifiedCompany,
    ModifiedInventory,
    ModifiedTransaction : Boolean;

    LanguageFile : string;
    AutoUpdate : Boolean;
    PrintFont : TFont;
    PrintMargins : TRect;
    AutoSaveTime : Word;
    AutoSave,
    AskAutoSave,
    MsgAutoSave : Boolean;
    ExportDelimiter,
    ExportSeparator : Char;

    procedure UpdateCaption;
    function CompanyExists : Boolean;
    procedure ViewCompany;
    procedure NewCompany;
    procedure OpenCompany(Name : string);
    procedure ViewInventory;
    procedure OpenInventory(FileName : string);
    procedure CloseInventory;
    procedure ViewTransaction;    
    procedure NewTransaction;
    procedure OpenTransaction(FileName : string);
    procedure CloseTransaction;
    procedure DisplayCompany;
    procedure DisplayInventories;
    procedure DisplayEmployees;
    procedure DisplayClients;
    procedure DisplaySuppliers;
    procedure DisplayTransactions;
    procedure DisplayGroups;
    procedure DisplayProducts;
    procedure DisplaySelections;
    procedure UpdateFound(Param: Integer);
    procedure TranslateTo(FileName : string);
    procedure LoadSettings;
    procedure SaveSettings;
    procedure LoadAppearance;
    procedure SaveAppearance;
    procedure LoadOptions;
    procedure SaveOptions;
  end;

var
  frmMain : TfrmMain;

implementation

uses
  FormAbout, FormClient, FormCompany, FormEmployee, FormGroup,
  FormOpen, FormOptions, FormTransaction, FormLogin, FormProduct,
  FormReports, FormSave, FormSelection, FormStats, FormSupplier,
  FormSelect, FormPrint, FormUser, FormFind, FormImport;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Texts := TStringList.Create;
  Texts.Add('Labl0=Page');
  Texts.Add('Desc0=A quotation is a preview of the content and price of a client''s future order.');
  Texts.Add('Desc1=An order is a sale of products or services that cannot be delivered right away, the client gives a deposit and will pay the balance when he receives an invoice.');
  Texts.Add('Desc2=An invoice is a completed transaction with the client, the complete balance was paid and all the products and services where delivered to the client.');
  Texts.Add('Edit0=&Undo');
  Texts.Add('Edit1=&Redo');
  Texts.Add('Edit2=add');
  Texts.Add('Edit3=edit');
  Texts.Add('Edit4=delete');
  Texts.Add('Edit5=an employee');
  Texts.Add('Edit6=a client');
  Texts.Add('Edit7=a supplier');
  Texts.Add('Edit8=a group');
  Texts.Add('Edit9=a product');
  Texts.Add('Msg0=Please enter a folder name for the company:');
  Texts.Add('Msg1=Please enter a file name for the inventory:');
  Texts.Add('Pay0=Cash');
  Texts.Add('Pay1=Debit');
  Texts.Add('Pay2=Credit');
  Texts.Add('Sect00=- Statistics -');
  Texts.Add('Sect01=- Clients -');
  Texts.Add('Sect02=- Products -');
  Texts.Add('Sect10=- Company -');
  Texts.Add('Sect11=- Inventory -');
  Texts.Add('Stat00=Number of invoices:');
  Texts.Add('Stat01=Number of orders:');
  Texts.Add('Stat02=Sub-totals:');
  Texts.Add('Stat03=Fees:');
  Texts.Add('Stat04=Totals:');
  Texts.Add('Stat05=Deposits:');
  Texts.Add('Stat10=Total size of files:');
  Texts.Add('Stat11=Number of inventories:');
  Texts.Add('Stat12=Number of employees:');
  Texts.Add('Stat13=Number of clients:');
  Texts.Add('Stat14=Number of suppliers:');
  Texts.Add('Stat15=No inventory is currently opened.');
  Texts.Add('Stat16=Number of groups:');
  Texts.Add('Stat17=Total number of products:');
  Texts.Add('Stat18=Average number of products per group:');
  Texts.Add('Title0=Select an employee');
  Texts.Add('Title1=Select a client');
  Texts.Add('Title2=Select a supplier');  
  Texts.Add('Trans0=Quotation');
  Texts.Add('Trans1=Order');
  Texts.Add('Trans2=Invoice');
  Title := frmMain.Caption;
  RootDir := ExtractFileDir(Application.ExeName)+'\';
  Report := TReport.Create;
  Updater := TUpdater.Create;    
  Updater.OnUpdateFound := UpdateFound;
  Users := TUserList.Create;
  User := nil;     
  PrintFont := TFont.Create;
  stgInventories.Rows[0].Text := 'Name'+#13#10+'Date'+#13#10+'Description';
  stgEmployees.Rows[0].Text := 'Number'+#13#10+'Name'+#13#10+'Address'+#13#10+'Telephone'+#13#10+'E-mail'+#13#10+'Other';
  stgClients.Rows[0].Text := 'Number'+#13#10+'Name'+#13#10+'Address'+#13#10+'Telephone'+#13#10+'E-mail'+#13#10+'Other';
  stgSuppliers.Rows[0].Text := 'Number'+#13#10+'Name'+#13#10+'Address'+#13#10+'Telephone'+#13#10+'E-mail'+#13#10+'Other';
  stgTransactions.Rows[0].Text := 'Number'+#13#10+'Date'+#13#10+'Salesman'+#13#10+'Client'+#13#10+'Recipient'+#13#10+'Payment'+#13#10+'Deposit'+#13#10+'Balance'+#13#10+'Comment';
  stgGroups.Rows[0].Text := 'Code'+#13#10+'Group';
  stgProducts.Rows[0].Text := 'Code'+#13#10+'Name'+#13#10+'Cost'+#13#10+'Price'+#13#10+'Qty'+#13#10+'Tax'+#13#10+'URL';
  stgSelections.Rows[0].Text := 'Qty'+#13#10+'Code'+#13#10+'Name'+#13#10+'Unit price'+#13#10+'Total price'+#13#10+'Tax'+#13#10+'Comment';
  pgcMain.ActivePageIndex := 0;
  LoadSettings;
  LoadAppearance;
  LoadOptions;
end;
     
procedure TfrmMain.FormDestroy(Sender: TObject);
begin           
  SaveSettings;
  SaveAppearance;
  Texts.Free;
  Updater.Free;
  Users.Free;
  Company.Free;
  Inventory.Free;
  Transaction.Free;
  Report.Free;
  PrintFont.Free;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModifiedCompany or ModifiedInventory or ModifiedTransaction then
    case AskQuestion(1, '', True) of
      idYes : Menu_File_Save.Click;
      idCancel : CanClose := False;
    end;
end;
    
procedure TfrmMain.CMShowingChanged(var Message: TMessage);
begin                     
  if frmMain.Showing then
    TranslateTo(LanguageFile);
  inherited;
  if frmMain.Showing then
  begin
    if not Users.LoadFromFile(RootDir+'users.dat') then
    begin
      ShowError(4); { User file missing }
      Application.Terminate;
      Exit;
    end;
    if not Users.AskLogin then
    begin
      New(User);
      User.Name := '';
      User.Password := '';
      User.Rights := [rAddInventory, rDeleteInventory, rOpenInventory, rAddEmployee, rDeleteEmployee, rEditEmployee, rAddClient, rDeleteClient, rEditClient, rAddSupplier, rDeleteSupplier, rEditSupplier, rAddTransaction, rDeleteTransaction, rOpenTransaction, rAddGroup, rDeleteGroup, rEditGroup, rAddProduct, rDeleteProduct, rEditProduct, rAddUser, rDeleteUser, rEditUser, rEditCompany];
      User.Prev := nil;
      User.Next := nil;
    end
    else if not frmLogin.Show then
    begin
      Application.Terminate;
      Exit;
    end;
    if AutoUpdate then
      Updater.Update('VirtualSalesman', 'http://www.marcandre.info/versions.inf', 0);
    if FileExists(RootDir+CurrentFile) then
      OpenCompany(CurrentFile)
    else if CompanyExists then
    begin
      CurrentFile := '';
      Menu_File_Open.Click;
    end;
    if Company = nil then
      NewCompany;
    UpdateCaption;               
  end;
end;

procedure TfrmMain.Menu_File_OpenClick(Sender: TObject);
begin
  if ModifiedCompany or ModifiedInventory or ModifiedTransaction then
    case AskQuestion(1, '', True) of
      idYes : Menu_File_Save.Click;
      idCancel : Exit;
    end;
  frmOpen.Show;
end;

procedure TfrmMain.Menu_File_SaveClick(Sender: TObject);
var
  FileName : string;
begin
  if CurrentFile = '' then
    frmSave.Show(FormSave.mCompany, Texts.Values['Msg0']);
  if Company.FilesDir <> '' then
  begin
    if not DirectoryExists(Company.FilesDir) then
      CreateDir(Company.FilesDir);  
    if not DirectoryExists(Company.TransDir) then
      CreateDir(Company.TransDir);
    case Company.SaveToFile(Company.FileName) of
      10 : ShowError(01, CurrentFile);
      12,13 : ShowError(02, CurrentFile);
      14,15 : ShowError(03, CurrentFile);
    else
      ModifiedCompany := False;
      SaveCount := 0;
    end;
    if Inventory <> nil then
      case Inventory.SaveToFile(Company.FilesDir+Inventory.Name+InvExt) of
        10 : ShowError(1, Inventory.Name+InvExt);
        12,13 : ShowError(2, Inventory.Name+InvExt);
        14,15 : ShowError(3, Inventory.Name+InvExt);
      else
        ModifiedInventory := False;
        SaveCount := 0;
      end;
    if Transaction <> nil then
    begin
      if not Transaction.Verification then
      begin
        ShowMessage(2); { Missing Transaction data }
        Menu_File_Properties.Click;
      end;
      if Transaction.Verification then
      begin
        if frmTransaction.ChangedType and (Transaction.FormType = fInvoice) then
          if AskQuestion(5) = idYes then
            Transaction.SellProducts(Company.FilesDir)
          else
            Exit;
        case Transaction.FormType of
          fQuotation: FileName := Company.TransDir+'Q'+FormatFloat('000000', Transaction.QuotationNumber)+TransExt;
          fOrder: FileName := Company.TransDir+'O'+FormatFloat('000000', Transaction.OrderNumber)+TransExt;
          fInvoice: FileName := Company.TransDir+'I'+FormatFloat('000000', Transaction.InvoiceNumber)+TransExt;
        end;
        case Transaction.SaveToFile(FileName) of
          10 : ShowError(1, ExtractFileName(FileName));
          12,13 : ShowError(2, ExtractFileName(FileName));
          14,15 : ShowError(3, ExtractFileName(FileName));
        else
          if frmTransaction.ChangedType then
            case Transaction.FormType of
              fQuotation : Company.QuotationNumber := Company.QuotationNumber +1;
              fOrder : Company.OrderNumber := Company.OrderNumber +1;
              fInvoice : Company.InvoiceNumber := Company.InvoiceNumber +1;
            end;
          frmTransaction.ChangedType := False;
          ModifiedTransaction := False;
          SaveCount := 0;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.Menu_File_PrintClick(Sender: TObject);
begin
  frmPrint.SetPrintMargins(PrintMargins);
  frmPrint.SetPrintFont(PrintFont);
  case CurrentList of
    1: frmPrint.Show(FormPrint.mCompany);
    2: frmPrint.Show(FormPrint.mEmployees);
    3: frmPrint.Show(FormPrint.mClients);
    4: frmPrint.Show(FormPrint.mSuppliers);
    6, 7:
       if AskQuestion(8) = idYes then
         frmPrint.Show(FormPrint.mGroup)
       else
         frmPrint.Show(FormPrint.mInventory);
    8: if not Transaction.Verification then
       begin
         ShowMessage(2); { Missing Transaction data }
         Menu_File_Properties.Click;
       end
       else if (Transaction.FormType = fInvoice) and ModifiedTransaction then
       begin
         if AskQuestion(4) = idYes then
           Menu_File_Save.Click;
       end
       else
         frmPrint.Show(FormPrint.mTransaction);
  end;
end;
  
procedure TfrmMain.Menu_File_ImportClick(Sender: TObject);
begin
  case CurrentList of
    2: frmImport.Show(FormImport.mEmployees);  
    3: frmImport.Show(FormImport.mClients);
    4: frmImport.Show(FormImport.mSuppliers);
    6,7:if Inventory.Groups.Size = 0 then
          ShowError(13) { Must create a group first }
        else
          frmImport.Show(FormImport.mProducts);
  end;
end;

procedure TfrmMain.Menu_File_ExportClick(Sender: TObject);
begin
  if dlgExport.Execute then
    case CurrentList of
      2: Company.Employees.ExportToFile(dlgExport.FileName, ExportDelimiter, ExportSeparator);
      3: Company.Clients.ExportToFile(dlgExport.FileName, ExportDelimiter, ExportSeparator);
      4: Company.Suppliers.ExportToFile(dlgExport.FileName, ExportDelimiter, ExportSeparator);
      6,7: Group.Products.ExportToFile(dlgExport.FileName, ExportDelimiter, ExportSeparator);
    end;
end;

procedure TfrmMain.Menu_File_NewCompanyClick(Sender: TObject);
begin
  if ModifiedCompany or ModifiedInventory or ModifiedTransaction then
    case AskQuestion(1, '', True) of
      idYes : Menu_File_Save.Click;
      idCancel : Exit;
    end;
  NewCompany;
end;

procedure TfrmMain.Menu_File_PropertiesClick(Sender: TObject);
begin
  if Transaction <> nil then
  begin
  	frmTransaction.SetDisabled(Company.LockInvoices and (Transaction.FormType = fInvoice) and not frmTransaction.ChangedType);
    frmTransaction.Show;
  end;
end;

procedure TfrmMain.Menu_File_CloseFileClick(Sender: TObject);
begin
  if ModifiedInventory or ModifiedTransaction then
    case AskQuestion(1, '', True) of
      idYes : Menu_File_Save.Click;
      idCancel : Exit;
    end;
  if Inventory <> nil then
    CloseInventory;
  if Transaction <> nil then
    CloseTransaction;
end;

procedure TfrmMain.Menu_File_ExitClick(Sender: TObject);
begin
  Application.Terminate;
end;
 
procedure TfrmMain.Menu_EditClick(Sender: TObject);
begin
  Menu_Edit_Undo.Enabled := True;
  Menu_Edit_Redo.Enabled := True;                
  Menu_Edit_Undo.Caption := Texts.Values['Edit0'];
  Menu_Edit_Redo.Caption := Texts.Values['Edit1'];
  case CurrentList of
    1: begin
      Menu_Edit_Undo.Enabled := False;
      Menu_Edit_Redo.Enabled := False;
    end;
    2: begin
      case Company.Employees.LastAction of
        UnitEmployee.aAdd : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit5'];
        UnitEmployee.aModify : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit5'];
        UnitEmployee.aRemove : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit5'];
        else Menu_Edit_Undo.Enabled := False;
      end;
      case Company.Employees.LastUndone of
        UnitEmployee.aAdd : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit5'];
        UnitEmployee.aModify : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit5'];
        UnitEmployee.aRemove : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit5'];
        else Menu_Edit_Redo.Enabled := False;
      end;
    end;
    3: begin
      case Company.Clients.LastAction of
        UnitClient.aAdd : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit6'];
        UnitClient.aModify : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit6'];
        UnitClient.aRemove : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit6'];
        else Menu_Edit_Undo.Enabled := False;
      end;
      case Company.Clients.LastUndone of
        UnitClient.aAdd : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit6'];
        UnitClient.aModify : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit6'];
        UnitClient.aRemove : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit6'];
        else Menu_Edit_Redo.Enabled := False;
      end;
    end;
    4: begin
      case Company.Suppliers.LastAction of
        UnitSupplier.aAdd : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit7'];
        UnitSupplier.aModify : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit7'];
        UnitSupplier.aRemove : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit7'];
        else Menu_Edit_Undo.Enabled := False;
      end;
      case Company.Suppliers.LastUndone of
        UnitSupplier.aAdd : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit7'];
        UnitSupplier.aModify : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit7'];
        UnitSupplier.aRemove : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit7'];
        else Menu_Edit_Redo.Enabled := False;
      end;
    end;
    6: begin
      case Inventory.Groups.LastAction of
        UnitGroup.aAdd : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit8'];
        UnitGroup.aModify : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit8'];
        UnitGroup.aRemove : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit8'];
        else Menu_Edit_Undo.Enabled := False;
      end;
      case Inventory.Groups.LastUndone of
        UnitGroup.aAdd : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit8'];
        UnitGroup.aModify : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit8'];
        UnitGroup.aRemove : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit8'];
        else Menu_Edit_Redo.Enabled := False;
      end;
    end;
    7: begin
      if (Group <> nil) and (Group.Products.Size > 0) then
      begin
        case Group.Products.LastAction of
          UnitProduct.aAdd : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit9'];
          UnitProduct.aModify : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit9'];
          UnitProduct.aRemove : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit9'];
          else Menu_Edit_Undo.Enabled := False;
        end;
        case Group.Products.LastUndone of
          UnitProduct.aAdd : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit9'];
          UnitProduct.aModify : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit9'];
          UnitProduct.aRemove : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit9'];
          else Menu_Edit_Redo.Enabled := False;
        end;
      end;
    end;
    8: begin
      case Transaction.Selections.LastAction of
        UnitSelection.aAdd : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit9'];
        UnitSelection.aModify : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit9'];
        UnitSelection.aRemove : Menu_Edit_Undo.Caption := Menu_Edit_Undo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit9'];
        else Menu_Edit_Undo.Enabled := False;
      end;
      case Transaction.Selections.LastUndone of
        UnitSelection.aAdd : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit2']+' '+Texts.Values['Edit9'];
        UnitSelection.aModify : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit3']+' '+Texts.Values['Edit9'];
        UnitSelection.aRemove : Menu_Edit_Redo.Caption := Menu_Edit_Redo.Caption+' '+Texts.Values['Edit4']+' '+Texts.Values['Edit9'];
        else Menu_Edit_Redo.Enabled := False;
      end;
    end;
  end;                          
end;

procedure TfrmMain.Menu_Edit_UndoClick(Sender: TObject);
begin
  case CurrentList of
    2: begin
      Company.Employees.Undo;
      DisplayEmployees;
    end;
    3: begin
      Company.Clients.Undo;
      DisplayClients;
    end;       
    4: begin
      Company.Suppliers.Undo;
      DisplaySuppliers;
    end;
    6: begin
      Inventory.Groups.Undo;
      DisplayGroups;
      DisplayProducts;
      stgGroups.OnClick(Self);
    end;
    7: begin
      Group.Products.Undo;
      DisplayProducts;
    end;
    8: begin
      Transaction.Selections.Undo;
      DisplaySelections;
    end;
  end;
end;

procedure TfrmMain.Menu_Edit_RedoClick(Sender: TObject);
begin
  case CurrentList of
    2: begin
      Company.Employees.Redo;
      DisplayEmployees;
    end;
    3: begin
      Company.Clients.Redo;
      DisplayClients;
    end;       
    4: begin
      Company.Suppliers.Redo;
      DisplaySuppliers;
    end;
    6: begin
      Inventory.Groups.Redo;
      DisplayGroups;
      DisplayProducts;
      stgGroups.OnClick(Self);
    end;
    7: begin
      Group.Products.Redo;
      DisplayProducts;
    end;
    8: begin
      Transaction.Selections.Redo;
      DisplaySelections;
    end;
  end;
end;

procedure TfrmMain.Menu_Edit_AddClick(Sender: TObject);
begin
  case CurrentList of
    1: begin
      if rAddInventory in User.Rights then
        frmSave.Show(FormSave.mInventory, Texts.Values['Msg1'])
      else
        ShowError(22); { No rights }
    end;
    2: begin       
      if rAddEmployee in User.Rights then
        frmEmployee.Show(FormEmployee.mAdd)
      else
        ShowError(22); { No rights }
    end;
    3: begin          
      if rAddClient in User.Rights then
        frmClient.Show(FormClient.mAdd)
      else
        ShowError(22); { No rights }
    end;
    4: begin
      if rAddSupplier in User.Rights then
        frmSupplier.Show(FormSupplier.mAdd)
      else
        ShowError(22); { No rights }
    end;
    5: begin
      if rAddTransaction in User.Rights then
        NewTransaction
      else
        ShowError(22); { No rights }
    end;
    6: begin   
      if rAddGroup in User.Rights then
        frmGroup.Show(FormGroup.mAdd)
      else
        ShowError(22); { No rights }
    end;
    7: begin  
      if rAddProduct in User.Rights then
      begin
        if Inventory.Groups.Size = 0 then
          ShowError(13) { Must create a group first }
        else
          frmProduct.Show(FormProduct.mAdd);
      end
      else
        ShowError(22); { No rights }
    end;
    8: begin
    	if Company.LockInvoices and (Transaction.FormType = fInvoice) and not frmTransaction.ChangedType then
	    	ShowError(15)  { Cannot modify a saved invoice }
      else
        frmSelection.Show(FormSelection.mAdd);
    end;
  end;
end;

procedure TfrmMain.Menu_Edit_EditClick(Sender: TObject);
var
  FileName : String;
begin             
  if TStringGrid(Sender).Cells[0, TStringGrid(Sender).Row] = '' then
  begin
    Menu_Edit_Add.Click;
    Exit;
  end;
  case CurrentList of
    1: begin
      if rOpenInventory in User.Rights then
        OpenInventory(Company.FilesDir+stgInventories.Cells[0, stgInventories.Row]+InvExt)
      else
        ShowError(22); { No rights }
    end;
    2: begin
      if rEditEmployee in User.Rights then
          frmEmployee.Show(FormEmployee.mEdit)
      else
        ShowError(22); { No rights }
    end;
    3: begin
      if rEditClient in User.Rights then
        frmClient.Show(FormClient.mEdit)
      else
        ShowError(22); { No rights }
    end;
    4: begin      
      if rEditSupplier in User.Rights then
        frmSupplier.Show(FormSupplier.mEdit)
      else
        ShowError(22); { No rights }
    end;
    5: begin
      if rOpenTransaction in User.Rights then
      begin
          case tabTransType.TabIndex of
            0: FileName := Company.TransDir+'Q'+FormatFloat('000000', StrToInt(stgTransactions.Cells[0, stgTransactions.Row]))+TransExt;
            1: FileName := Company.TransDir+'O'+FormatFloat('000000', StrToInt(stgTransactions.Cells[0, stgTransactions.Row]))+TransExt;
            2: FileName := Company.TransDir+'I'+FormatFloat('000000', StrToInt(stgTransactions.Cells[0, stgTransactions.Row]))+TransExt;
          end;
          OpenTransaction(FileName);
      end
      else
        ShowError(22); { No rights }
    end;
    6: begin
      if rEditGroup in User.Rights then
        frmGroup.Show(FormGroup.mEdit)
      else
        ShowError(22); { No rights }
    end;
    7: begin
      if rEditProduct in User.Rights then
        frmProduct.Show(FormProduct.mEdit)
      else
        ShowError(22); { No rights }
    end;
    8: begin
    	if stgSelections.Cells[0, stgSelections.Row] = '' then
        Menu_Edit_Add.Click
      else
        frmSelection.Show(FormSelection.mEdit);
    end;
  end;
end;

procedure TfrmMain.Menu_Edit_DeleteClick(Sender: TObject);      
var
  FileName : String;
begin
  case CurrentList of
    1: begin       
      if rDeleteInventory in User.Rights then
      begin
        if AskQuestion(2) = idYes then { Deletion confirmation }
          if RecycleFile(Company.FilesDir+stgInventories.Cells[0, stgInventories.Row]+InvExt) then
            DisplayInventories;
      end
      else
        ShowError(22); { No rights }
    end;
    2: begin
      if rDeleteEmployee in User.Rights then
      begin
        if Company.Employees.Remove(stgEmployees.Row) then
        begin
          DisplayEmployees;
          ModifiedCompany := True;
        end;
      end
      else   
        ShowError(22); { No rights }
    end;
    3: begin    
      if rDeleteClient in User.Rights then
      begin
        if Company.Clients.Remove(stgClients.Row) then
        begin
          DisplayClients;
          ModifiedCompany := True;
        end;
      end
      else
        ShowError(22); { No rights }
    end;
    4: begin     
      if rDeleteSupplier in User.Rights then
      begin
        if Company.Suppliers.Remove(stgSuppliers.Row) then
        begin
          DisplaySuppliers;
          ModifiedCompany := True;
        end;
      end
      else
        ShowError(22); { No rights }
    end;
    5: begin
      if rDeleteTransaction in User.Rights then
      begin
        if Company.LockInvoices and (tabTransType.TabIndex = 2) then
          ShowError(15) { Cannot modify a saved invoice }
        else if AskQuestion(2) = idYes then { Deletion confirmation }
        begin
          case tabTransType.TabIndex of
            0: FileName := Company.TransDir+'Q'+FormatFloat('000000', StrToInt(stgTransactions.Cells[0, stgTransactions.Row]))+TransExt;
            1: FileName := Company.TransDir+'O'+FormatFloat('000000', StrToInt(stgTransactions.Cells[0, stgTransactions.Row]))+TransExt;
            2: FileName := Company.TransDir+'I'+FormatFloat('000000', StrToInt(stgTransactions.Cells[0, stgTransactions.Row]))+TransExt;
          end;
          if RecycleFile(FileName) then
            DisplayTransactions;
        end;
      end
      else
        ShowError(22); { No rights }
    end;
    6: begin      
      if rDeleteGroup in User.Rights then
      begin
        if Inventory.Groups.Remove(stgGroups.Row) then
        begin
          DisplayGroups;
          DisplayProducts;
          stgGroups.OnClick(Self);
          ModifiedInventory := True;
        end;
      end
      else
        ShowError(22); { No rights }
    end;
    7: begin       
      if rDeleteProduct in User.Rights then
      begin
        if (Group <> nil) and (Group.Products.Remove(stgProducts.Row)) then
        begin
          DisplayProducts;
          ModifiedInventory := True;
        end;
      end
      else
        ShowError(22); { No rights }
    end;
    8: begin
    	if Company.LockInvoices and (Transaction.FormType = fInvoice) and not frmTransaction.ChangedType then
    		ShowError(15) { Cannot modify a saved invoice }
      else if Transaction.Selections.Remove(stgSelections.Row) then
      begin
        Transaction.Calculate(Company.FederalTaxValue, Company.StateTaxValue, Transaction.Fees, Transaction.Deposit);
        DisplaySelections;
        ModifiedTransaction := True;
      end;
    end;
  end;
end;
    
procedure TfrmMain.Menu_Edit_FindClick(Sender: TObject);
begin
  case CurrentList of
    1: frmFind.Show(stgInventories);
    2: frmFind.Show(stgEmployees);
    3: frmFind.Show(stgClients);
    4: frmFind.Show(stgSuppliers);
    5: frmFind.Show(stgTransactions);
    6: frmFind.Show(stgGroups);
    7: frmFind.Show(stgProducts);
    8: frmFind.Show(stgSelections);
  end;
end;

procedure TfrmMain.Menu_Edit_FindNextClick(Sender: TObject);
begin
  frmFind.FindNext;
end;

procedure TfrmMain.Menu_View_CompanyClick(Sender: TObject);
begin
  if rEditCompany in User.Rights then
  begin
    if CurrentFile = '' then
      frmSave.Show(FormSave.mCompany, Texts.Values['Msg0']);
    if CurrentFile <> '' then
      frmCompany.Show;
  end
  else
    ShowError(22); { No rights }
end;

procedure TfrmMain.Menu_View_StatisticsClick(Sender: TObject);
begin
  frmStats.Show;
end;

procedure TfrmMain.Menu_View_ReportsClick(Sender: TObject);
begin
  frmReports.Show;
end;

procedure TfrmMain.Menu_View_OptionsClick(Sender: TObject);
begin
  frmOptions.Show;
end;

procedure TfrmMain.Menu_View_CalculatorClick(Sender: TObject);
begin
  if ShellExecute(Application.Handle, 'open', PChar(CalcPath), nil, nil, SW_SHOWNORMAL) = ERROR_FILE_NOT_FOUND then
    if ShellExecute(Application.Handle, 'open', 'calc.exe', nil, nil, SW_SHOWNORMAL) = ERROR_FILE_NOT_FOUND then
      ShowError(12); { Cannot find application }
end;

procedure TfrmMain.Menu_View_ToolbarClick(Sender: TObject);
begin
  ToolBar.Visible := Menu_View_Toolbar.Checked;
end;

procedure TfrmMain.Menu_Help_HelpClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar(MakeFileName(RootDir, 'Help.chm')), nil, nil, SW_SHOW);
end;

procedure TfrmMain.Menu_Help_ReportBugClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('mailto:marc@marcandre.info'), nil, nil, SW_SHOW);
end;

procedure TfrmMain.Menu_Help_UpdateClick(Sender: TObject);
begin
  Updater.Update('VirtualSalesman', 'http://www.marcandre.info/versions.inf', 1);
end;

procedure TfrmMain.Menu_Help_AboutClick(Sender: TObject);
begin
  frmAbout.Show(sVersion);
end;
              
procedure TfrmMain.popToolBar_ButtonsClick(Sender: TObject);
var
  i : Integer;
  Last : Integer;
begin
  with Sender as TMenuItem do
  begin
    ToolBar.Buttons[Tag].Visible := Checked;
    Last := -1;
    for i := 0 to ToolBar.ButtonCount-1 do
    begin
      if ToolBar.Buttons[i].Style = tbsSeparator then
        if Last in [0..ToolBar.ButtonCount-1] then
          ToolBar.Buttons[i].Visible := not (ToolBar.Buttons[Last].Style = tbsSeparator)
        else
          ToolBar.Buttons[i].Visible := False;
      if ToolBar.Buttons[i].Visible then
        Last := i;
    end;
    if ToolBar.Buttons[Last].Style = tbsSeparator then
      ToolBar.Buttons[Last].Visible := False;
  end;
end;

procedure TfrmMain.popToolBar_Buttons_ShowAllClick(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to ToolBar.ButtonCount-1 do
    ToolBar.Buttons[i].Visible := True;
  for i := 0 to popToolbar_Buttons.Count-3 do
    popToolbar_Buttons.Items[i].Checked := True;
end;

procedure TfrmMain.popToolBar_TextBelowClick(Sender: TObject);
begin
  ToolBar.List := False;
  ToolBar.ShowCaptions := True;
end;

procedure TfrmMain.popToolBar_TextRightClick(Sender: TObject);
begin
  ToolBar.List := True;
  ToolBar.ShowCaptions := True;
  ToolBar.ButtonHeight := 22;
end;

procedure TfrmMain.popToolBar_NoTextClick(Sender: TObject);
begin
  ToolBar.List := False;
  ToolBar.ShowCaptions := False;
  ToolBar.ButtonWidth := 23;
  ToolBar.ButtonHeight := 22;
end;

procedure TfrmMain.popToolBar_HideClick(Sender: TObject);
begin
  Menu_View_ToolBar.Click;
end;

procedure TfrmMain.pgcMainChange(Sender: TObject);
begin
  case pgcMain.ActivePageIndex of
    0: begin
      DisplayInventories;
      if tbsInventories.Enabled then
        stgInventories.SetFocus;
      Menu_File_Import.Enabled := False;
      Menu_File_Export.Enabled := False;
      tbnImport.Enabled := False;
      tbnExport.Enabled := False;
    end;
    1: begin
      DisplayEmployees;
      if tbsEmployees.Enabled then
        stgEmployees.SetFocus;
      Menu_File_Import.Enabled := True;
      Menu_File_Export.Enabled := True;
      tbnImport.Enabled := True;
      tbnExport.Enabled := True;
    end;
    2: begin
      DisplayClients;  
      if tbsClients.Enabled then
        stgClients.SetFocus;      
      Menu_File_Import.Enabled := True;
      Menu_File_Export.Enabled := True; 
      tbnImport.Enabled := True;
      tbnExport.Enabled := True;
    end;
    3: begin
      DisplaySuppliers;   
      if tbsSuppliers.Enabled then
        stgSuppliers.SetFocus;       
      Menu_File_Import.Enabled := True;
      Menu_File_Export.Enabled := True;
      tbnImport.Enabled := True;
      tbnExport.Enabled := True;
    end;
    4: begin              
      DisplayEmployees;
      DisplayTransactions;
      if tbsTransactions.Enabled then
        stgTransactions.SetFocus;    
      Menu_File_Import.Enabled := False;
      Menu_File_Export.Enabled := False; 
      tbnImport.Enabled := False;
      tbnExport.Enabled := False;
    end;
  end;
end;
           
procedure TfrmMain.pgcMainResize(Sender: TObject);
begin
  pgcMain.TabWidth := (pgcMain.Width-4) div 5;
end;

procedure TfrmMain.pnlTransactionTopResize(Sender: TObject);
begin                                                          
  cmbSalesman.Width := pnlTransactionTop.Width div 3;
  cmbSalesman.Left := pnlTransactionTop.Width-cmbSalesman.Width;
  lblSalesman.Left := cmbSalesman.Left-lblSalesman.Width-5;
end;

procedure TfrmMain.pnlInventoryTopResize(Sender: TObject);
begin
  edtInventoryDesc.Width := pnlInventoryTop.Width-edtInventoryDesc.Left-4;
end;

procedure TfrmMain.pnlTransactionBottomResize(Sender: TObject);
begin
  lblFederalTax.Left := Round(pnlTransactionBottom.Width*0.25);
  edtFederalTax.Left := 2+lblFederalTax.Left+lblFederalTax.Width;
  lblStateTax.Left := Round(pnlTransactionBottom.Width*0.5);
  edtStateTax.Left := 2+lblStateTax.Left+lblStateTax.Width;
  lblTotal.Left := Round(pnlTransactionBottom.Width*0.75);
  edtTotal.Left := 2+lblTotal.Left+lblTotal.Width;
end;

procedure TfrmMain.StringGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with Sender as TStringGrid do
  begin
    if ColWidths[ACol] > ClientWidth then
      ColWidths[ACol] := ClientWidth -16;
  end;
end;

procedure TfrmMain.stgInventoriesEnter(Sender: TObject);
begin
  CurrentList := 1;
end;

procedure TfrmMain.stgEmployeesEnter(Sender: TObject);
begin
  CurrentList := 2;
end;

procedure TfrmMain.stgClientsEnter(Sender: TObject);
begin
  CurrentList := 3;
end;

procedure TfrmMain.stgSuppliersEnter(Sender: TObject);
begin
  CurrentList := 4;
end;
                
procedure TfrmMain.stgTransactionsEnter(Sender: TObject);
begin
  CurrentList := 5;
end;

procedure TfrmMain.stgGroupsEnter(Sender: TObject);
begin
  CurrentList := 6;
  pnlInventorySelGroup.Color := clHighlight;
  pnlInventorySelProduct.Color := clBtnFace;
end;

procedure TfrmMain.stgProductsEnter(Sender: TObject);
begin
  CurrentList := 7;
  pnlInventorySelGroup.Color := clBtnFace;
  pnlInventorySelProduct.Color := clHighlight;
end;
     
procedure TfrmMain.stgSelectionsEnter(Sender: TObject);
begin
  CurrentList := 8;
end;

procedure TfrmMain.pnlInventorySelGroupClick(Sender: TObject);
begin
  if pnlInventory.Enabled then
    stgGroups.SetFocus;
end;

procedure TfrmMain.pnlInventorySelProductClick(Sender: TObject);
begin                    
  if pnlInventory.Enabled then
    stgProducts.SetFocus;
end;

procedure TfrmMain.stgGroupsClick(Sender: TObject);
begin
  Group := Inventory.Groups.Get(stgGroups.Row);
  DisplayProducts;
end;

procedure TfrmMain.edtInventoryDateChange(Sender: TObject);
begin
  if Inventory.Date <> StrToDate(edtInventoryDate.Text) then
  begin
    Inventory.Date := StrToDate(edtInventoryDate.Text);
    ModifiedInventory := True;
  end;
end;

procedure TfrmMain.btnInventoryDateClick(Sender: TObject);
begin
  edtInventoryDate.Text := FormatDateTime('ddddd', Now);
end;
  
procedure TfrmMain.edtInventoryDescChange(Sender: TObject);
begin
  if Inventory.Description <> edtInventoryDesc.Text then
  begin
    Inventory.Description := edtInventoryDesc.Text;
    ModifiedInventory := True;
  end;
end;
                                
procedure TfrmMain.tabTransTypeChange(Sender: TObject);
begin
  DisplayTransactions;
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
begin   
  if AutoSave and (SaveCount >= AutoSaveTime) then
  begin
    Timer.Enabled := False;
    SaveCount := 0;
    if AskAutoSave then
      if AskQuestion(1) = idNo then
        Exit;
    Menu_File_Save.Click;
    if MsgAutoSave then
      ShowMessage(1);
    Timer.Enabled := True;
  end
  else
    SaveCount := SaveCount+1;
end;

procedure TfrmMain.UpdateCaption;
begin
  if Company = nil then
    frmMain.Caption := Title
  else if Inventory <> nil then
    frmMain.Caption := Title+' : '+Company.Name+' - '+Inventory.Name
  else if Transaction <> nil then
    case Transaction.FormType of
      fQuotation: frmMain.Caption := Title+' : '+Company.Name+' - '+Texts.Values['Trans0']+' #'+IntToStr(Transaction.QuotationNumber);
      fOrder: frmMain.Caption := Title+' : '+Company.Name+' - '+Texts.Values['Trans1']+' #'+IntToStr(Transaction.OrderNumber);
      fInvoice: frmMain.Caption := Title+' : '+Company.Name+' - '+Texts.Values['Trans2']+' #'+IntToStr(Transaction.InvoiceNumber);
    end
  else
    frmMain.Caption := Title+' : '+Company.Name;
  Application.Title := frmMain.Caption;
end;
               
function TfrmMain.CompanyExists : Boolean;
var
  FileInfo : TSearchRec;
begin
  Result := False;
  if FindFirst(RootDir+'*.*', faAnyFile, FileInfo) = 0 then
  begin
    repeat
      if ((FileInfo.Attr and faDirectory) <> 0) and (FileInfo.Name <> '.') and (FileInfo.Name <> '..') then
        if FileExists(RootDir+FileInfo.Name+'\'+FileInfo.Name+CieExt) then
        begin
          Result := True;
          Break;
        end;
    until FindNext(FileInfo) <> 0;
    SysUtils.FindClose(FileInfo);
  end;
end;

procedure TfrmMain.ViewCompany;
begin
  pgcMain.Visible := True;
  pnlInventory.Visible := False;
  pnlTransaction.Visible := False;
  Menu_File_Properties.Enabled := False;
  Menu_File_CloseFile.Enabled := False;
  tbnProperties.Enabled := False;
  tbnCloseFile.Enabled := False;
  DisplayCompany;
  pgcMain.OnChange(Self);
  UpdateCaption;
end;

procedure TfrmMain.NewCompany;
begin
  if Inventory <> nil then
    CloseInventory;
  if Transaction <> nil then
    CloseTransaction;
  if Company = nil then
    Company := TCompany.Create('')
  else
    Company.Clear;
  if frmSave.Show(FormSave.mCompany, Texts.Values['Msg0']) then
    Menu_View_Company.Click;    
  ViewCompany;
end;

procedure TfrmMain.OpenCompany(Name : string);
begin
  if Inventory <> nil then
    CloseInventory;
  if Transaction <> nil then
    CloseTransaction;
  if Company = nil then
    Company := TCompany.Create('');
  case Company.LoadFromFile(RootDir+Name) of
    10 : ShowError(1, Name);
    12,13 : ShowError(2, Name);
    14,15 : ShowError(3, Name);
  else
    CurrentFile := Name;
    ViewCompany;
    ModifiedCompany := False;
  end;
end;

procedure TfrmMain.ViewInventory;
begin
  pgcMain.Visible := False;
  pnlInventory.Visible := True;
  Menu_File_CloseFile.Enabled := True;
  Menu_File_Import.Enabled := True;
  Menu_File_Export.Enabled := True; 
  tbnCloseFile.Enabled := True;
  tbnImport.Enabled := True;
  tbnExport.Enabled := True;
  edtInventoryDate.Text := FormatDateTime('ddddd', Inventory.Date);
  edtInventoryDesc.Text := Inventory.Description;
  DisplayGroups;
  DisplayProducts;
  if pnlInventory.Enabled then
    stgGroups.SetFocus;
  stgGroups.OnClick(Self);
  UpdateCaption;
end;

procedure TfrmMain.OpenInventory(FileName : string);
begin
  Inventory := TInventory.Create;
  case Inventory.LoadFromFile(FileName) of
    10 : begin
      ShowError(1, ExtractFileName(FileName));
      Inventory.Free;
      Inventory := nil;
    end;
    12,13 : begin
      ShowError(2, ExtractFileName(FileName));
      Inventory.Free;
      Inventory := nil;
    end;
    14,15 : begin
      ShowError(3, ExtractFileName(FileName));
      Inventory.Free;
      Inventory := nil;
    end;
  else
    ViewInventory;
    ModifiedInventory := False;
  end;
end ;

procedure TfrmMain.CloseInventory;
begin
  Inventory.Free;
  Inventory := nil;
  Group := nil;
  ModifiedInventory := False;
  ViewCompany;
end;
                   
procedure TfrmMain.ViewTransaction;
begin
  pgcMain.Visible := False;
  pnlTransaction.Visible := True;
  Menu_File_Properties.Enabled := True;
  Menu_File_CloseFile.Enabled := True;
  Menu_File_Import.Enabled := False;
  Menu_File_Export.Enabled := False;    
  tbnProperties.Enabled := True;
  tbnCloseFile.Enabled := True;
  tbnImport.Enabled := False;
  tbnExport.Enabled := False;
  DisplaySelections;
  if pnlTransaction.Enabled then
    stgSelections.SetFocus;    
  UpdateCaption;
end;

procedure TfrmMain.NewTransaction;
var
  CurEmployee : PEmployee;
begin
  Transaction := TTransaction.Create;
  if cmbSalesman.ItemIndex >= 0 then
  begin
    CurEmployee := Company.Employees.Get(cmbSalesman.ItemIndex+1);
    Transaction.EmployeeNumber := CurEmployee.Number;
    Transaction.EmployeeName := CurEmployee.Name;
  end;
  ViewTransaction;
end;

procedure TfrmMain.OpenTransaction(FileName : string);
begin
  Transaction := TTransaction.Create;
  case Transaction.LoadFromFile(FileName) of
    10 : begin
      ShowError(1, ExtractFileName(FileName));
      Transaction.Free;
      Transaction := nil;
    end;
    12,13 : begin
      ShowError(2, ExtractFileName(FileName));
      Transaction.Free;
      Transaction := nil;
    end;
    14,15 : begin
      ShowError(3, ExtractFileName(FileName));
      Transaction.Free;
      Transaction := nil;
    end;
  else
    ViewTransaction;
    ModifiedTransaction := False;
  end;
end;

procedure TfrmMain.CloseTransaction;
begin
  Transaction.Free;
  Transaction := nil;
  ModifiedTransaction := False;
  ViewCompany;
end;

procedure TfrmMain.DisplayCompany;
begin
  lblFederalTax.Caption := Company.FederalTaxName+':';
  lblStateTax.Caption := Company.StateTaxName+':';
end;

procedure TfrmMain.DisplayInventories;
var
  FileInfo : TSearchRec;
  Inventory : TInventory;
  Index : Word;
begin
  Index := 1;
  if Company.FilesDir <> '' then
  begin
    Inventory := TInventory.Create;
    if FindFirst(Company.FilesDir+'*'+InvExt, faAnyFile, FileInfo) = 0 then
    begin
      repeat
        if ((FileInfo.Attr and faDirectory) = 0) and (Inventory.LoadHeaderFromFile(Company.FilesDir+FileInfo.Name) = 0) then
        begin
          if Index > stgInventories.RowCount then
            stgInventories.RowCount := stgInventories.RowCount+1;
          stgInventories.Cells[0, Index] := Inventory.Name;
          stgInventories.Cells[1, Index] := FormatDateTime('dddddd', Inventory.Date);
          stgInventories.Cells[2, Index] := Inventory.Description;
          Index := Index+1;
        end;
      until FindNext(FileInfo) <> 0;
      SysUtils.FindClose(FileInfo);
    end;
    if Index > 1 then
      stgInventories.RowCount := Index
    else
    begin
      stgInventories.RowCount := 2;
      stgInventories.Rows[1].Clear;
    end;
    Inventory.Free;
  end;
end;

procedure TfrmMain.DisplayEmployees;
var
  Index : Integer;
  CurEmployee : PEmployee;
  Selected : Integer;
begin
  Selected := cmbSalesman.ItemIndex;
  cmbSalesman.Items.Clear;
  if Company.Employees.Size > 0 then
  begin
    stgEmployees.RowCount := Company.Employees.Size+1 ;
    CurEmployee := Company.Employees.First;
    Index := 0;
    while (CurEmployee <> nil) and (Index < stgEmployees.RowCount-1) do
    begin
      Index := Index+1;                             
      cmbSalesman.Items.Add(CurEmployee.Number+' - '+CurEmployee.Name);
      stgEmployees.Cells[0, Index] := CurEmployee.Number;
      stgEmployees.Cells[1, Index] := CurEmployee.Name;
      stgEmployees.Cells[2, Index] := CurEmployee.Address;
      stgEmployees.Cells[3, Index] := CurEmployee.Telephone;
      stgEmployees.Cells[4, Index] := CurEmployee.Email;
      stgEmployees.Cells[5, Index] := CurEmployee.Other;
      CurEmployee := CurEmployee.Next;
    end;
  end
  else
  begin
    stgEmployees.RowCount := 2;
    stgEmployees.Rows[1].Clear;
  end;  
  cmbSalesman.ItemIndex := Selected;
end;

procedure TfrmMain.DisplayClients;
var
  Index : Integer;
  CurClient : PClient;
begin
  if Company.Clients.Size > 0 then
  begin                               
    stgClients.RowCount := Company.Clients.Size+1;
    CurClient := Company.Clients.First;
    Index := 0;
    while (CurClient <> nil) and (Index < stgClients.RowCount-1) do
    begin
      Index := Index+1;
      stgClients.Cells[0, Index] := CurClient.Number;
      stgClients.Cells[1, Index] := CurClient.Name;
      stgClients.Cells[2, Index] := CurClient.Address;
      stgClients.Cells[3, Index] := CurClient.Telephone;
      stgClients.Cells[4, Index] := CurClient.Email;
      stgClients.Cells[5, Index] := CurClient.Other;
      CurClient := CurClient.Next;
    end;
  end
  else
  begin
    stgClients.RowCount := 2;
    stgClients.Rows[1].Clear;
  end;
end;

procedure TfrmMain.DisplaySuppliers;
var
  Index : Integer;
  CurSupplier : PSupplier;
begin
  if Company.Suppliers.Size > 0 then
  begin                                 
    stgSuppliers.RowCount := Company.Suppliers.Size+1;
    CurSupplier := Company.Suppliers.First;
    Index := 0;
    while (CurSupplier <> nil) and (Index < stgSuppliers.RowCount-1) do
    begin
      Index := Index+1;
      stgSuppliers.Cells[0, Index] := CurSupplier.Number;
      stgSuppliers.Cells[1, Index] := CurSupplier.Name;
      stgSuppliers.Cells[2, Index] := CurSupplier.Address;
      stgSuppliers.Cells[3, Index] := CurSupplier.Telephone;
      stgSuppliers.Cells[4, Index] := CurSupplier.Email;
      stgSuppliers.Cells[5, Index] := CurSupplier.Other;
      CurSupplier := CurSupplier.Next;
    end;
  end
  else
  begin
    stgSuppliers.RowCount := 2;
    stgSuppliers.Rows[1].Clear;
  end;
end;

procedure TfrmMain.DisplayTransactions;
var
  FileName : string;
  FileInfo : TSearchRec;
  Transaction : TTransaction;
  Index : Word;
begin
  if Company.TransDir <> '' then
  begin
    Index := 1;
    Transaction := TTransaction.Create;
    case tabTransType.TabIndex of
      0 : FileName := Company.TransDir+'Q*'+TransExt;
      1 : FileName := Company.TransDir+'O*'+TransExt;
      2 : FileName := Company.TransDir+'I*'+TransExt;
    end;
    if FindFirst(FileName, faAnyFile, FileInfo) = 0 then
    begin
      repeat
        if ((FileInfo.Attr and faDirectory) = 0) and (Transaction.LoadHeaderFromFile(Company.TransDir+FileInfo.Name) = 0) then
        begin
          if Index >= stgTransactions.RowCount then
            stgTransactions.RowCount := Index+1;
          case tabTransType.TabIndex of
            0: stgTransactions.Cells[0, Index] := IntToStr(Transaction.QuotationNumber);
            1: stgTransactions.Cells[0, Index] := IntToStr(Transaction.OrderNumber);
            2: stgTransactions.Cells[0, Index] := IntToStr(Transaction.InvoiceNumber);
          end;
          stgTransactions.Cells[1, Index] := FormatDateTime('dddddd', Transaction.Date);
          stgTransactions.Cells[2, Index] := Transaction.EmployeeNumber+' - '+Transaction.EmployeeName;
          stgTransactions.Cells[3, Index] := Transaction.ClientNumber+' - '+Transaction.ClientName;
          stgTransactions.Cells[4, Index] := Transaction.RecipientNumber+' - '+Transaction.RecipientName;
          case Transaction.PaymentType of
            pCash: stgTransactions.Cells[5, Index] := Texts.Values['Pay0'];
            pDebit: stgTransactions.Cells[5, Index] := Texts.Values['Pay1'];
            pCredit: stgTransactions.Cells[5, Index] := Texts.Values['Pay2'];
          end;
          stgTransactions.Cells[6, Index] := FormatFloat('0.00 '+Company.CurrencySign, Transaction.Deposit);
          stgTransactions.Cells[7, Index] := FormatFloat('0.00 '+Company.CurrencySign, Transaction.Total);
          stgTransactions.Cells[8, Index] := Transaction.Comments;
          Index := Index +1;
        end;
      until FindNext(FileInfo) <> 0;
      SysUtils.FindClose(FileInfo);
    end;
    if Index = 1 then
    begin
      stgTransactions.RowCount := 2;
      stgTransactions.Rows[1].Clear;
    end
    else
      stgTransactions.RowCount := Index;
    Transaction.Free;
  end;
end;

procedure TfrmMain.DisplayGroups;
var
  Index : Integer;
  CurGroup : PGroup;
begin
  if (Inventory <> nil) and (Inventory.Groups.Size > 0) then
  begin                                     
    stgGroups.RowCount := Inventory.Groups.Size+1;
    CurGroup := Inventory.Groups.First;
    Index := 0;
    while (CurGroup <> nil) and (Index < stgGroups.RowCount-1) do
    begin
      Index := Index+1;
      stgGroups.Cells[0, Index] := CurGroup.Code;
      stgGroups.Cells[1, Index] := CurGroup.Name;
      CurGroup := CurGroup.Next;
    end;
  end
  else
  begin
    stgGroups.RowCount := 2;
    stgGroups.Rows[1].Clear;
  end;
end;

procedure TfrmMain.DisplayProducts;
var
  Index : Integer;
  CurProduct : PProduct;
begin
  if Inventory <> nil then
  begin
    if (Group <> nil) and (Group.Products.Size > 0) then
    begin
      stgProducts.RowCount := Group.Products.Size+1;
      CurProduct := Group.Products.First;
      Index := 0;
      while (CurProduct <> nil) and (Index < stgProducts.RowCount-1) do
      begin
        Index := Index+1;
        stgProducts.Cells[0, Index] := CurProduct.Code;
        stgProducts.Cells[1, Index] := CurProduct.Name;
        stgProducts.Cells[2, Index] := FormatFloat('0.00 '+Company.CurrencySign, CurProduct.Cost);
        stgProducts.Cells[3, Index] := FormatFloat('0.00 '+Company.CurrencySign, CurProduct.Price);
        stgProducts.Cells[4, Index] := IntToStr(CurProduct.Quantity);
        if CurProduct.Taxed then
          stgProducts.Cells[5, Index] := 'T'
        else
          stgProducts.Cells[5, Index] := '';
        stgProducts.Cells[6, Index] := CurProduct.Web;
        CurProduct := CurProduct.Next;
      end;
    end
    else
    begin
      stgProducts.RowCount := 2;
      stgProducts.Rows[1].Clear;
    end;
  end
  else
  begin
    stgProducts.RowCount := 2;
    stgProducts.Rows[1].Clear;
  end;
end;
        
procedure TfrmMain.DisplaySelections;
var
  Index : Integer;
  CurSelection : PSelection;
begin
  if (Transaction <> nil) and (Transaction.Selections.Size > 0) then
  begin                   
    stgSelections.RowCount := Transaction.Selections.Size+1;
    CurSelection := Transaction.Selections.First;
    Index := 0;
    while (CurSelection <> nil) and (Index < stgSelections.RowCount-1) do
    begin
      Index := Index+1; 
      stgSelections.Cells[0, Index] := IntToStr(CurSelection.Quantity);
      stgSelections.Cells[1, Index] := CurSelection.Code;
      stgSelections.Cells[2, Index] := CurSelection.Name;
      if CurSelection.Descriptive then
      begin
        stgSelections.Cells[3, Index] := '';
        stgSelections.Cells[4, Index] := '';
        stgSelections.Cells[3, Index] := '';
      end
      else
      begin
        stgSelections.Cells[3, Index] := FormatFloat('0.00 '+Company.CurrencySign, CurSelection.Price);
        stgSelections.Cells[4, Index] := FormatFloat('0.00 '+Company.CurrencySign, CurSelection.Quantity*CurSelection.Price);
        if CurSelection.Taxed then
          stgSelections.Cells[5, Index] := 'T'
        else
          stgSelections.Cells[5, Index] := '';
      end;
      stgSelections.Cells[6, Index] := CurSelection.Comments;
      CurSelection := CurSelection.Next;
    end;
  end
  else
  begin
    stgSelections.RowCount := 2;
    stgSelections.Rows[1].Clear;
  end;

  edtSubTotal.Text := FormatFloat('0.00 '+Company.CurrencySign, Transaction.SubTotal);
  edtFederalTax.Text := FormatFloat('0.00 '+Company.CurrencySign, Transaction.FederalTaxes);
  edtStateTax.Text := FormatFloat('0.00 '+Company.CurrencySign, Transaction.StateTaxes);
  edtTotal.Text := FormatFloat('0.00 '+Company.CurrencySign, Transaction.Total);
end;
 
procedure TfrmMain.UpdateFound(Param : Integer);
begin
  if Updater.FileVersion > iVersion then
  begin
   if askQuestion(6) = idYes then
      ShellExecute(Application.Handle, 'open', PChar(Updater.FileURL), nil, nil, SW_SHOW);
  end
  else if Param = 1 then
    ShowMessage(3);
end;

procedure TfrmMain.TranslateTo(FileName : string);
var
  LangPack : TLangPack;
begin
  LangPack := TLangPack.Create;
  if LangPack.LoadFromFile(FileName) then
  begin
    LangPack.TranslateForm(frmAbout);
    LangPack.TranslateForm(frmClient);
    LangPack.TranslateForm(frmCompany);
    LangPack.TranslateForm(frmEmployee);
    LangPack.TranslateForm(frmFind);
    LangPack.TranslateForm(frmGroup);  
    LangPack.TranslateForm(frmImport);
    LangPack.TranslateForm(frmLogin);
    LangPack.TranslateForm(frmMain);
    LangPack.TranslateForm(frmOpen);
    LangPack.TranslateForm(frmOptions);
    LangPack.TranslateForm(frmPrint);
    LangPack.TranslateForm(frmProduct);
    LangPack.TranslateForm(frmReports);
    LangPack.TranslateForm(frmSave);
    LangPack.TranslateForm(frmSelect);
    LangPack.TranslateForm(frmSelection);
    LangPack.TranslateForm(frmStats);
    LangPack.TranslateForm(frmSupplier);
    LangPack.TranslateForm(frmTransaction);
    LangPack.TranslateForm(frmUser);
    LangPack.TranslateStrings('messages', MsgStr);
    LangPack.TranslateStrings('printing', PrtStr);
    LangPack.TranslateStrings('texts', Texts);
  end;
  UpdateCaption;
  LangPack.Free;
end;

procedure TfrmMain.LoadSettings;
var
  IniFile : TIniFile;
  Str : string;
begin
  IniFile := TIniFile.Create(MakeFileName(RootDir, 'VS3.ini'));
  CurrentFile := IniFile.ReadString('General', 'LastCompany', '');
  CalcPath := IniFile.ReadString('General', 'Calculator', RootDir+'Calc.exe');
  if not IniFile.ReadBool('General', 'Toolbar', True) then
    Menu_View_Toolbar.Click;
  Str := IniFile.ReadString('General', 'ToolbarCaptions', 'None');
  if Str = 'Below' then
    popToolBar_TextBelow.Click
  else if Str = 'Right' then
    popToolBar_TextRight.Click
  else
    popToolBar_NoText.Click;
  Str := IniFile.ReadString('General', 'ToolbarButtons', '11111111111111111111');
  if Str[1] = '0' then popToolBar_Buttons_Open.Click;
  if Str[2] = '0' then popToolBar_Buttons_Save.Click;
  if Str[3] = '0' then popToolBar_Buttons_Print.Click;
  if Str[4] = '0' then popToolBar_Buttons_Import.Click;
  if Str[5] = '0' then popToolBar_Buttons_Export.Click;
  if Str[6] = '0' then popToolBar_Buttons_Properties.Click;
  if Str[7] = '0' then popToolBar_Buttons_Close.Click;
  if Str[8] = '0' then popToolBar_Buttons_Undo.Click;
  if Str[9] = '0' then popToolBar_Buttons_Redo.Click;
  if Str[10] = '0' then popToolBar_Buttons_Add.Click;
  if Str[11] = '0' then popToolBar_Buttons_Edit.Click;
  if Str[12] = '0' then popToolBar_Buttons_Delete.Click;
  if Str[13] = '0' then popToolBar_Buttons_Find.Click;
  if Str[14] = '0' then popToolBar_Buttons_Company.Click;
  if Str[15] = '0' then popToolBar_Buttons_Statistics.Click;
  if Str[16] = '0' then popToolBar_Buttons_Reports.Click;
  if Str[17] = '0' then popToolBar_Buttons_Options.Click;
  if Str[18] = '0' then popToolBar_Buttons_Calculator.Click;
  if Str[19] = '0' then popToolBar_Buttons_Help.Click;
  if Str[20] = '0' then popToolBar_Buttons_Update.Click;
  IniFile.Free;
end;

procedure TfrmMain.SaveSettings;
var
  IniFile : TIniFile;
  Str : string;
begin
  IniFile := TIniFile.Create(MakeFileName(RootDir, 'VS3.ini'));
  IniFile.WriteString('General', 'LastCompany', CurrentFile);
  IniFile.WriteBool('General', 'Toolbar', ToolBar.Visible);
  if popToolBar_TextBelow.Checked then
    Str := 'Below'
  else if popToolBar_TextRight.Checked then
    Str := 'Right'
  else
    Str := 'None';
  IniFile.WriteString('General', 'ToolbarCaptions', Str);
  Str := '';
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Open.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Save.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Print.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Import.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Export.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Properties.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Close.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Undo.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Redo.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Add.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Edit.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Delete.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Find.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Company.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Statistics.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Reports.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Options.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Calculator.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Help.Checked));
  Str := Str+IntToStr(Integer(popToolBar_Buttons_Update.Checked));
  IniFile.WriteString('General', 'ToolbarButtons', Str);
  IniFile.UpdateFile;
  IniFile.Free;
end;

procedure TfrmMain.LoadAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin
      frmMain.Left := Reg.ReadInteger('FormMainLeft');
      frmMain.Top := Reg.ReadInteger('FormMainTop');
      frmMain.Width := Reg.ReadInteger('FormMainWidth');
      frmMain.Height := Reg.ReadInteger('FormMainHeight');
      stgInventories.ColWidths[0] := Reg.ReadInteger('FormMainCol01');
      stgInventories.ColWidths[1] := Reg.ReadInteger('FormMainCol02');
      stgInventories.ColWidths[2] := Reg.ReadInteger('FormMainCol03');
      stgEmployees.ColWidths[0] := Reg.ReadInteger('FormMainCol11');
      stgEmployees.ColWidths[1] := Reg.ReadInteger('FormMainCol12');
      stgEmployees.ColWidths[2] := Reg.ReadInteger('FormMainCol13');
      stgEmployees.ColWidths[3] := Reg.ReadInteger('FormMainCol14');
      stgEmployees.ColWidths[4] := Reg.ReadInteger('FormMainCol15');
      stgEmployees.ColWidths[5] := Reg.ReadInteger('FormMainCol16');
      stgClients.ColWidths[0] := Reg.ReadInteger('FormMainCol21');
      stgClients.ColWidths[1] := Reg.ReadInteger('FormMainCol22');
      stgClients.ColWidths[2] := Reg.ReadInteger('FormMainCol23');
      stgClients.ColWidths[3] := Reg.ReadInteger('FormMainCol24');
      stgClients.ColWidths[4] := Reg.ReadInteger('FormMainCol25');
      stgClients.ColWidths[5] := Reg.ReadInteger('FormMainCol26');
      stgSuppliers.ColWidths[0] := Reg.ReadInteger('FormMainCol31');
      stgSuppliers.ColWidths[1] := Reg.ReadInteger('FormMainCol32');
      stgSuppliers.ColWidths[2] := Reg.ReadInteger('FormMainCol33');
      stgSuppliers.ColWidths[3] := Reg.ReadInteger('FormMainCol34');
      stgSuppliers.ColWidths[4] := Reg.ReadInteger('FormMainCol35');
      stgSuppliers.ColWidths[5] := Reg.ReadInteger('FormMainCol36');
      stgTransactions.ColWidths[0] := Reg.ReadInteger('FormMainCol41');
      stgTransactions.ColWidths[1] := Reg.ReadInteger('FormMainCol42');
      stgTransactions.ColWidths[2] := Reg.ReadInteger('FormMainCol43');
      stgTransactions.ColWidths[3] := Reg.ReadInteger('FormMainCol44');
      stgTransactions.ColWidths[4] := Reg.ReadInteger('FormMainCol45');
      stgTransactions.ColWidths[5] := Reg.ReadInteger('FormMainCol46');
      stgTransactions.ColWidths[6] := Reg.ReadInteger('FormMainCol47');
      stgTransactions.ColWidths[7] := Reg.ReadInteger('FormMainCol48');
      stgTransactions.ColWidths[8] := Reg.ReadInteger('FormMainCol49');
      pnlInventoryGroups.Width := Reg.ReadInteger('FormMainCol51');
      stgGroups.ColWidths[0] := Reg.ReadInteger('FormMainCol52');
      stgGroups.ColWidths[1] := Reg.ReadInteger('FormMainCol53');
      stgProducts.ColWidths[0] := Reg.ReadInteger('FormMainCol61');
      stgProducts.ColWidths[1] := Reg.ReadInteger('FormMainCol62');
      stgProducts.ColWidths[2] := Reg.ReadInteger('FormMainCol63');
      stgProducts.ColWidths[3] := Reg.ReadInteger('FormMainCol64');
      stgProducts.ColWidths[4] := Reg.ReadInteger('FormMainCol65');
      stgProducts.ColWidths[5] := Reg.ReadInteger('FormMainCol66');
      stgProducts.ColWidths[6] := Reg.ReadInteger('FormMainCol67');
      stgSelections.ColWidths[0] := Reg.ReadInteger('FormMainCol71');
      stgSelections.ColWidths[1] := Reg.ReadInteger('FormMainCol72');
      stgSelections.ColWidths[2] := Reg.ReadInteger('FormMainCol73');
      stgSelections.ColWidths[3] := Reg.ReadInteger('FormMainCol74');
      stgSelections.ColWidths[4] := Reg.ReadInteger('FormMainCol75');
      stgSelections.ColWidths[5] := Reg.ReadInteger('FormMainCol76');
      stgSelections.ColWidths[6] := Reg.ReadInteger('FormMainCol77');
      Reg.CloseKey;
    end;   
    Reg.Free;
  except
    Reg.Free;
  end;
end;

procedure TfrmMain.SaveAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin
      Reg.WriteInteger('FormMainLeft', frmMain.Left);
      Reg.WriteInteger('FormMainTop', frmMain.Top);
      Reg.WriteInteger('FormMainWidth', frmMain.Width);
      Reg.WriteInteger('FormMainHeight', frmMain.Height);
      Reg.WriteInteger('FormMainCol01', stgInventories.ColWidths[0]);
      Reg.WriteInteger('FormMainCol02', stgInventories.ColWidths[1]);
      Reg.WriteInteger('FormMainCol03', stgInventories.ColWidths[2]);
      Reg.WriteInteger('FormMainCol11', stgEmployees.ColWidths[0]);
      Reg.WriteInteger('FormMainCol12', stgEmployees.ColWidths[1]);
      Reg.WriteInteger('FormMainCol13', stgEmployees.ColWidths[2]);
      Reg.WriteInteger('FormMainCol14', stgEmployees.ColWidths[3]);
      Reg.WriteInteger('FormMainCol15', stgEmployees.ColWidths[4]);
      Reg.WriteInteger('FormMainCol16', stgEmployees.ColWidths[5]);
      Reg.WriteInteger('FormMainCol21', stgClients.ColWidths[0]);
      Reg.WriteInteger('FormMainCol22', stgClients.ColWidths[1]);
      Reg.WriteInteger('FormMainCol23', stgClients.ColWidths[2]);
      Reg.WriteInteger('FormMainCol24', stgClients.ColWidths[3]);
      Reg.WriteInteger('FormMainCol25', stgClients.ColWidths[4]);
      Reg.WriteInteger('FormMainCol26', stgClients.ColWidths[5]);
      Reg.WriteInteger('FormMainCol31', stgSuppliers.ColWidths[0]);
      Reg.WriteInteger('FormMainCol32', stgSuppliers.ColWidths[1]);
      Reg.WriteInteger('FormMainCol33', stgSuppliers.ColWidths[2]);
      Reg.WriteInteger('FormMainCol34', stgSuppliers.ColWidths[3]);
      Reg.WriteInteger('FormMainCol35', stgSuppliers.ColWidths[4]);
      Reg.WriteInteger('FormMainCol36', stgSuppliers.ColWidths[5]);
      Reg.WriteInteger('FormMainCol41', stgTransactions.ColWidths[0]);
      Reg.WriteInteger('FormMainCol42', stgTransactions.ColWidths[1]);
      Reg.WriteInteger('FormMainCol43', stgTransactions.ColWidths[2]);
      Reg.WriteInteger('FormMainCol44', stgTransactions.ColWidths[3]);
      Reg.WriteInteger('FormMainCol45', stgTransactions.ColWidths[4]);
      Reg.WriteInteger('FormMainCol46', stgTransactions.ColWidths[5]);
      Reg.WriteInteger('FormMainCol47', stgTransactions.ColWidths[6]);
      Reg.WriteInteger('FormMainCol48', stgTransactions.ColWidths[7]);
      Reg.WriteInteger('FormMainCol49', stgTransactions.ColWidths[8]);
      Reg.WriteInteger('FormMainCol51', pnlInventoryGroups.Width);
      Reg.WriteInteger('FormMainCol52', stgGroups.ColWidths[0]);
      Reg.WriteInteger('FormMainCol53', stgGroups.ColWidths[1]);
      Reg.WriteInteger('FormMainCol61', stgProducts.ColWidths[0]);
      Reg.WriteInteger('FormMainCol62', stgProducts.ColWidths[1]);
      Reg.WriteInteger('FormMainCol63', stgProducts.ColWidths[2]);
      Reg.WriteInteger('FormMainCol64', stgProducts.ColWidths[3]);
      Reg.WriteInteger('FormMainCol65', stgProducts.ColWidths[4]);
      Reg.WriteInteger('FormMainCol66', stgProducts.ColWidths[5]);
      Reg.WriteInteger('FormMainCol67', stgProducts.ColWidths[6]);
      Reg.WriteInteger('FormMainCol71', stgSelections.ColWidths[0]);
      Reg.WriteInteger('FormMainCol72', stgSelections.ColWidths[1]);
      Reg.WriteInteger('FormMainCol73', stgSelections.ColWidths[2]);
      Reg.WriteInteger('FormMainCol74', stgSelections.ColWidths[3]);
      Reg.WriteInteger('FormMainCol75', stgSelections.ColWidths[4]);
      Reg.WriteInteger('FormMainCol76', stgSelections.ColWidths[5]);
      Reg.WriteInteger('FormMainCol77', stgSelections.ColWidths[6]);
      Reg.CloseKey;
    end;
    Reg.Free;
  except
    Reg.Free;
  end;
end;

procedure TfrmMain.LoadOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(MakeFileName(RootDir, 'VS3.ini'));

  LanguageFile := IniFile.ReadString('Options', 'LanguageFile', 'VS3EN.lang');
  AutoUpdate := IniFile.ReadBool('Options', 'AutoUpdate', True);
  PrintFont.Name := IniFile.ReadString('Options', 'PrintFontName', 'Arial');
  PrintFont.Size := IniFile.ReadInteger('Options', 'PrintFontSize', 10);
  if IniFile.ReadBool('Options', 'PrintFontBold', False) then
    PrintFont.Style := PrintFont.Style+[fsBold];
  if IniFile.ReadBool('Options', 'PrintFontItalic', False) then
    PrintFont.Style := PrintFont.Style+[fsItalic];  
  PrintMargins.Left := IniFile.ReadInteger('Options', 'PrintMarginLeft', 0);
  PrintMargins.Right := IniFile.ReadInteger('Options', 'PrintMarginRight', 0);
  PrintMargins.Top := IniFile.ReadInteger('Options', 'PrintMarginTop', 0);
  PrintMargins.Bottom := IniFile.ReadInteger('Options', 'PrintMarginBottom', 0);
  AutoSave := IniFile.ReadBool('Options', 'AutoSave', True);
  AutoSaveTime := IniFile.ReadInteger('Options', 'AutoSaveTime', 5);
  AskAutoSave := IniFile.ReadBool('Options', 'AutoSaveConfirm', True);
  MsgAutoSave := IniFile.ReadBool('Options', 'AutoSaveMessage', False);
  ExportDelimiter := IniFile.ReadString('Options', 'ExportDelimiter', '"')[1]; 
  ExportSeparator := IniFile.ReadString('Options', 'ExportSeparator', ';')[1];
  IniFile.Free;
end;

procedure TfrmMain.SaveOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(MakeFileName(RootDir, 'VS3.ini'));

  IniFile.WriteString('Options', 'LanguageFile', LanguageFile);  
  IniFile.WriteBool('Options', 'AutoUpdate', AutoUpdate);
  IniFile.WriteString('Options', 'PrintFontName', PrintFont.Name);
  IniFile.WriteInteger('Options', 'PrintFontSize', PrintFont.Size);
  IniFile.WriteBool('Options', 'PrintFontBold', (fsBold in PrintFont.Style));
  IniFile.WriteBool('Options', 'PrintFontItalic', (fsItalic in PrintFont.Style));
  IniFile.WriteInteger('Options', 'PrintMarginLeft', PrintMargins.Left);
  IniFile.WriteInteger('Options', 'PrintMarginRight', PrintMargins.Right);
  IniFile.WriteInteger('Options', 'PrintMarginTop', PrintMargins.Top);
  IniFile.WriteInteger('Options', 'PrintMarginBottom', PrintMargins.Bottom);
  IniFile.WriteBool('Options', 'AutoSave', AutoSave);
  IniFile.WriteInteger('Options', 'AutoSaveTime', AutoSaveTime);
  IniFile.WriteBool('Options', 'AutoSaveConfirm', AskAutoSave);
  IniFile.WriteBool('Options', 'AutoSaveMessage', MsgAutoSave);
  IniFile.WriteString('Options', 'ExportDelimiter', ExportDelimiter);
  IniFile.WriteString('Options', 'ExportSeparator', ExportSeparator);
  IniFile.UpdateFile;
  IniFile.Free;
end;

end.
