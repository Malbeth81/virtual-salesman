(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Registry, Printers, PrintPreview,
  UnitPrint, UnitMessages, UnitCompany, UnitInventory, UnitTransaction, UnitReport;

type
  TMode = (mCompany, mEmployees, mClients, mSuppliers, mInventory, mGroup, mTransaction, mReport);
  TfrmPrint = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    PrinterSetupDialog: TPrinterSetupDialog;
    PrintPreview: TPrintPreview;
    pnlTopCenter: TPanel;
    lblPrinter: TLabel;
    lblPaper: TLabel;
    cmbPaper: TComboBox;
    cmbPrinter: TComboBox;
    btnProperties: TButton;
    cmbZoom: TComboBox;
    lblZoom: TLabel;
    lblOrientation: TLabel;
    cmbOrientation: TComboBox;
    btnPrint: TButton;
    btnCancel: TButton;
    cmbPage: TComboBox;
    lblCopies: TLabel;
    edtCopies: TEdit;
    updCopies: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure cmbPrinterSelect(Sender: TObject);
    procedure btnPropertiesClick(Sender: TObject);
    procedure cmbPaperChange(Sender: TObject);
    procedure cmbZoomChange(Sender: TObject);
    procedure cmbPageChange(Sender: TObject);   
    procedure cmbOrientationSelect(Sender: TObject);
    procedure PrintPreviewZoomChange(Sender: TObject);
    procedure PrintPreviewBeginDoc(Sender: TObject);
    procedure PrintPreviewEndDoc(Sender: TObject);
    procedure PrintPreviewBeforePrint(Sender: TObject);
    procedure PrintPreviewAfterPrint(Sender: TObject);     
    procedure btnPrintClick(Sender: TObject);
    procedure cmbZoomSelect(Sender: TObject);
    procedure SetPrintMargins(Margins : TRect);
    procedure SetPrintFont(Font : TFont);
    procedure CreatePages;
    procedure LoadAppearance;
    procedure SaveAppearance;
  public
    function Show(Mode : TMode) : Boolean; reintroduce;
  private
    Mode : TMode;
  end;

var
  frmPrint: TfrmPrint;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmPrint.FormCreate(Sender: TObject);
begin
  PrintPreview.GetPrinterOptions;
  PrintPreview.FetchFormNames(cmbPaper.Items);
  LoadAppearance;
end;

procedure TfrmPrint.FormShow(Sender: TObject);
begin
  cmbPrinter.Items := Printer.Printers;
  cmbPrinter.ItemIndex := Printer.PrinterIndex;
  cmbPaper.ItemIndex := cmbPaper.Items.IndexOf(PrintPreview.FormName);
  cmbOrientation.ItemIndex := Integer(PrintPreview.Orientation);
  updCopies.Position := 1;
  CreatePages;
end;

procedure TfrmPrint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveAppearance;
end;

procedure TfrmPrint.FormResize(Sender: TObject);
begin
  pnlTopCenter.Left := (pnlTop.Width-pnlTopCenter.Width) div 2;
  btnPrint.Left := pnlBottom.Width-141;
  btnCancel.Left := pnlBottom.Width-69;
end;

procedure TfrmPrint.cmbPrinterSelect(Sender: TObject);
begin
  Printer.PrinterIndex := cmbPrinter.ItemIndex;
end;

procedure TfrmPrint.btnPropertiesClick(Sender: TObject);
begin
  PrintPreview.SetPrinterOptions;
  PrinterSetupDialog.Execute;
  PrintPreview.GetPrinterOptions;
  cmbPrinter.ItemIndex := Printer.PrinterIndex;
  cmbPaper.ItemIndex := cmbPaper.Items.IndexOf(PrintPreview.FormName);
  cmbOrientation.ItemIndex := Integer(PrintPreview.Orientation); 
  CreatePages;
end;

procedure TfrmPrint.cmbPaperChange(Sender: TObject);
begin            
  PrintPreview.FormName := cmbPaper.Items[cmbPaper.ItemIndex];
  CreatePages;
end;
   
procedure TfrmPrint.cmbOrientationSelect(Sender: TObject);
begin
  case cmbOrientation.ItemIndex of
    0: PrintPreview.Orientation := poPortrait;
    1: PrintPreview.Orientation := poLandscape;
  end;
  CreatePages;
end;

procedure TfrmPrint.cmbZoomSelect(Sender: TObject);
begin
  case cmbZoom.ItemIndex of
    0: PrintPreview.Zoom := 50;
    1: PrintPreview.Zoom := 100;
    2: PrintPreview.Zoom := 150;
    3: PrintPreview.Zoom := 200;
    4: PrintPreview.ZoomState := zsZoomToWidth;
    5: PrintPreview.ZoomState := zsZoomToHeight;
    6: PrintPreview.ZoomState := zsZoomToFit;
  end;
end;

procedure TfrmPrint.cmbZoomChange(Sender: TObject);
begin
  if cmbZoom.Text <> '' then
    if cmbZoom.ItemIndex < 0 then
      PrintPreview.Zoom := StrToInt(cmbZoom.Text);
end;

procedure TfrmPrint.cmbPageChange(Sender: TObject);
begin
  PrintPreview.CurrentPage := cmbPage.ItemIndex+1;
end;

procedure TfrmPrint.PrintPreviewZoomChange(Sender: TObject);
begin
  case PrintPreview.ZoomState of
    zsZoomToFit: cmbZoom.ItemIndex := 6;
    zsZoomToHeight: cmbZoom.ItemIndex := 5;
    zsZoomToWidth: cmbZoom.ItemIndex := 4;
  else
    case PrintPreview.Zoom of
      200: cmbZoom.ItemIndex := 3;
      150: cmbZoom.ItemIndex := 2;
      100: cmbZoom.ItemIndex := 1;
      50: cmbZoom.ItemIndex := 0;
    else
      cmbZoom.ItemIndex := -1;
      cmbZoom.Text := IntToStr(PrintPreview.Zoom);
    end;
  end;
end;

procedure TfrmPrint.PrintPreviewBeginDoc(Sender: TObject);
begin
  cmbPaper.Enabled := False;
  btnPrint.Enabled := False;        
end;

procedure TfrmPrint.PrintPreviewEndDoc(Sender: TObject);
begin
  cmbPaper.Enabled := True;
  btnPrint.Enabled := PrintPreview.PrinterInstalled and (PrintPreview.TotalPages > 0);
end;

procedure TfrmPrint.PrintPreviewBeforePrint(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  btnPrint.Enabled := False;
end;

procedure TfrmPrint.PrintPreviewAfterPrint(Sender: TObject);
begin
  Screen.Cursor := crDefault;
  btnPrint.Enabled := PrintPreview.PrinterInstalled and (PrintPreview.TotalPages > 0);
end;

procedure TfrmPrint.btnPrintClick(Sender: TObject);
begin
  if PrintPreview.State = psReady then
  begin
    Printer.Copies := StrToInt(edtCopies.Text);
    PrintPreview.SetPrinterOptions;
    PrintPreview.Print;
    Self.ModalResult := mrOk;
  end;
end;

function TfrmPrint.Show(Mode : TMode) : Boolean;
begin
  Self.Mode := Mode;
  Result := (ShowModal = mrOk);
end;

procedure TfrmPrint.SetPrintMargins(Margins : TRect);
begin
  Margins.Left := Margins.Left*10;
  Margins.Right := Margins.Right*10;
  Margins.Top := Margins.Top*10;
  Margins.Bottom := Margins.Bottom*10;
  UnitPrint.SetPrintMargins(Margins);
end;

procedure TfrmPrint.SetPrintFont(Font : TFont);
begin
  PrintPreview.Font := Font;
end;

procedure TfrmPrint.CreatePages;
var
  i : Word;
begin
  with frmMain do
    case Mode of
      mCompany: UnitPrint.PrintCompany(PrintPreview, Company);
      mEmployees: UnitPrint.PrintEmployees(PrintPreview, Company);
      mClients: UnitPrint.PrintClients(PrintPreview, Company);
      mSuppliers: UnitPrint.PrintSuppliers(PrintPreview, Company);
      mInventory: UnitPrint.PrintInventory(PrintPreview, Company, Inventory);
      mGroup: UnitPrint.PrintGroup(PrintPreview, Company, Inventory, frmMain.stgGroups.Row);
      mTransaction: UnitPrint.PrintTransaction(PrintPreview, Company, Transaction);
      mReport: UnitPrint.PrintReport(PrintPreview, Company, Report);
    end;
  if PrintPreview.TotalPages > 1 then
    for i := 1 to PrintPreview.TotalPages do
      with PrintPreview do
      begin
        BeginEdit(i);
        SetTextAlign(Canvas.Handle, TA_RIGHT or TA_TOP);
        Canvas.TextOut(PrinterPageBounds.Right, PrinterPageBounds.Top, frmMain.Texts.Values['Labl0']+' '+IntToStr(i)+'/'+IntToStr(TotalPages));
        EndEdit;
      end;
  cmbPage.Items.Clear;
  for i := 1 to PrintPreview.TotalPages do
    cmbPage.Items.Add(frmMain.Texts.Values['Labl0']+' '+IntToStr(i)+'/'+IntToStr(PrintPreview.TotalPages));
  cmbPage.ItemIndex := PrintPreview.CurrentPage-1;
  btnPrint.Enabled := PrintPreview.PrinterInstalled and (PrintPreview.TotalPages > 0);  
end;
     
procedure TfrmPrint.LoadAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin
      frmPrint.Height := Reg.ReadInteger('PrintPreviewHeight');
      frmPrint.Width := Reg.ReadInteger('PrintPreviewWidth');
      PrintPreview.ZoomState := TZoomState(Reg.ReadInteger('PrintPreviewZoom'));
      case PrintPreview.ZoomState of
        zsZoomToFit: cmbZoom.ItemIndex := 6;
        zsZoomToHeight: cmbZoom.ItemIndex := 5;
        zsZoomToWidth: cmbZoom.ItemIndex := 4;
      else
        PrintPreview.Zoom := Reg.ReadInteger('PrintPreviewZoomValue');
        case PrintPreview.Zoom of
          200: cmbZoom.ItemIndex := 3;
          150: cmbZoom.ItemIndex := 2;
          100: cmbZoom.ItemIndex := 1;
          50: cmbZoom.ItemIndex := 0;
        else
          cmbZoom.ItemIndex := -1;
          cmbZoom.Text := IntToStr(PrintPreview.Zoom);
        end;
      end;
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

procedure TfrmPrint.SaveAppearance;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Virtual Salesman', True) then
    begin                  
      Reg.WriteInteger('PrintPreviewHeight', frmPrint.Height);
      Reg.WriteInteger('PrintPreviewWidth', frmPrint.Width);      
      Reg.WriteInteger('PrintPreviewZoom', Integer(PrintPreview.ZoomState));
      Reg.WriteInteger('PrintPreviewZoomValue', PrintPreview.Zoom);
      Reg.CloseKey;
    end;
  except
    Reg.Free;
    Exit;
  end;
  Reg.Free;
end;

end.
