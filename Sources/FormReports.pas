(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormReports;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DateUtils, ExtCtrls, StdCtrls, Grids, StrUtils2, UnitMessages, UnitCompany,
  UnitReport, UnitPrint;

type
  TfrmReports = class(TForm)
    btnClose: TButton;
    stgReport: TStringGrid;
    btnGenerate: TButton;
    btnPrint: TButton;
    cmbReport: TComboBox;
    cmbPeriod: TComboBox;
    edtFrom: TEdit;
    edtTo: TEdit;
    lblReport: TLabel;
    lblPeriod: TLabel;
    lblFromDate: TLabel;
    lblToDate: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmbPeriodChange(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  public
    function Show : Boolean; reintroduce;
  end;

var
  frmReports: TfrmReports;

implementation

uses FormPrint, FormMain;

{$R *.dfm}

procedure TfrmReports.FormShow(Sender: TObject);
begin
  frmMain.Report.Clear;
  cmbPeriod.ItemIndex := 0;
  cmbPeriod.OnChange(Self);
  btnPrint.Enabled := False;
end;

procedure TfrmReports.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  stgReport.RowCount := 1;
  stgreport.Rows[0].Clear;
end;
    
procedure TfrmReports.cmbPeriodChange(Sender: TObject);
begin
  case cmbPeriod.ItemIndex of
    0 : begin
      edtFrom.Text := FormatDateTime('ddddd', Date);
      edtTo.Text := FormatDateTime('ddddd', Date);
    end;
    1 : begin
      edtFrom.Text := FormatDateTime('ddddd', StartOfTheWeek(Date));
      edtTo.Text := FormatDateTime('ddddd', Date);
    end;
    2 : begin
      edtFrom.Text := FormatDateTime('ddddd', StartOfTheMonth(Date));
      edtTo.Text := FormatDateTime('ddddd', Date);
    end;
    3 : begin
      edtFrom.Text := FormatDateTime('ddddd', StartOfTheYear(Date));
      edtTo.Text := FormatDateTime('ddddd', Date);
    end;
  end;
end;

procedure TfrmReports.btnGenerateClick(Sender: TObject);
var
  ReportType : TReportType;
  i : Integer;
begin
  with frmMain do
  begin
    if cmbReport.ItemIndex = 1 then
      ReportType := tCommands
    else
      ReportType := tSales;
    Report.Generate(ReportType, StrToDate(edtFrom.Text), StrToDate(edtTo.Text), Company.TransDir);
    stgReport.RowCount := 1;
    stgReport.Cells[0, stgReport.RowCount-1] := Texts.Values['Sect00'];
    stgReport.RowCount := stgReport.RowCount+1;
    if Report.ReportType = tSales then
      stgReport.Cells[0, stgReport.RowCount-1] := Texts.Values['Stat00']
    else
      stgReport.Cells[0, stgReport.RowCount-1] := Texts.Values['Stat01'];
    stgReport.Cells[1, stgReport.RowCount-1] := IntToStr(Report.Count);
    stgReport.RowCount := stgReport.RowCount+1;
    stgReport.Cells[0, stgReport.RowCount-1] := Texts.Values['Stat02'];
    stgReport.Cells[1, stgReport.RowCount-1] := FormatFloat('0.00 ' + Company.CurrencySign, Report.SubTotals);
    stgReport.RowCount := stgReport.RowCount+1;
    stgReport.Cells[0, stgReport.RowCount-1] := Company.FederalTaxName+':';
    stgReport.Cells[1, stgReport.RowCount-1] := FormatFloat('0.00 ' + Company.CurrencySign, Report.FederalTaxes);
    stgReport.RowCount := stgReport.RowCount+1;
    stgReport.Cells[0, stgReport.RowCount-1] := Company.StateTaxName+':';
    stgReport.Cells[1, stgReport.RowCount-1] := FormatFloat('0.00 ' + Company.CurrencySign, Report.StateTaxes);
    stgReport.RowCount := stgReport.RowCount+1;
    stgReport.Cells[0, stgReport.RowCount-1] := Texts.Values['Stat03'];
    stgReport.Cells[1, stgReport.RowCount-1] := FormatFloat('0.00 ' + Company.CurrencySign, Report.Fees);
    stgReport.RowCount := stgReport.RowCount+1;
    stgReport.Cells[0, stgReport.RowCount-1] := Texts.Values['Stat04'];
    stgReport.Cells[1, stgReport.RowCount-1] := FormatFloat('0.00 ' + Company.CurrencySign, Report.Totals);
    stgReport.RowCount := stgReport.RowCount+1;
    stgReport.Cells[0, stgReport.RowCount-1] := Texts.Values['Stat05'];
    stgReport.Cells[1, stgReport.RowCount-1] := FormatFloat('0.00 ' + Company.CurrencySign, Report.Deposits);
    stgReport.RowCount := stgReport.RowCount+1;
    stgReport.Cells[0, stgReport.RowCount-1] := Texts.Values['Sect01'];
    for i := 0 to Report.Clients.Count-1 do
    begin
      stgReport.RowCount := stgReport.RowCount +1;
      stgReport.Cells[0, stgReport.RowCount-1] := Report.Clients.Names[i];
      stgReport.Cells[1, stgReport.RowCount-1] := Report.Clients.Values[Report.Clients.Names[i]];
    end;
    stgReport.RowCount := stgReport.RowCount+1;
    stgReport.Cells[0, stgReport.RowCount-1] := Texts.Values['Sect02'];
    for i := 0 to Report.Products.Count-1 do
    begin
      stgReport.RowCount := stgReport.RowCount +1;
      stgReport.Cells[0, stgReport.RowCount-1] := Report.Products.Names[i];
      stgReport.Cells[1, stgReport.RowCount-1] := Report.Products.Values[Report.Products.Names[i]];
    end;
    btnPrint.Enabled := True;
  end;
end;

procedure TfrmReports.btnPrintClick(Sender: TObject);
begin
  frmPrint.Show(mReport);
end;

function TfrmReports.Show : Boolean;
begin
  Result := (ShowModal = mrOk);
end;

end.
