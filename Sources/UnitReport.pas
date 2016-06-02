(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2005 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitReport;

interface

uses
  SysUtils, Classes, Controls, StrUtils2, UnitTransaction, UnitSelection;

type
  TReportType = (tSales, tCommands);
type
  TReport = class (TObject)
  private
    rReportType : TReportType;
    rPeriodStart,
    rPeriodEnd : TDateTime;
    rCount : Integer;
    rSubTotals,
    rFederalTaxes,
    rStateTaxes,
    rFees,
    rTotals,
    rDeposits : Single;      
    rClients : TStrings;
    rProducts : TStrings;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Generate(ReportType : TReportType; PeriodStart, PeriodEnd : TDateTime; CurrentDir : String);
    procedure Clear;

    property ReportType : TReportType read rReportType;
    property PeriodStart : TDateTime read rPeriodStart;
    property PeriodEnd : TDateTime read rPeriodEnd; 
    property Count : Integer read rCount;
    property SubTotals : Single read rSubTotals;
    property FederalTaxes : Single read rFederalTaxes;
    property StateTaxes : Single read rStateTaxes;
    property Fees : Single read rFees;
    property Totals : Single read rTotals;
    property Deposits : Single read rDeposits;
    property Clients : TStrings read rClients;
    property Products : TStrings read rProducts;
  end;

implementation
                   
  constructor TReport.Create;
  begin
    rClients := TStringList.Create;
    rProducts := TStringList.Create;
    inherited Create;
  end;

  destructor TReport.Destroy; 
  begin
    rClients.Free;
    rProducts.Free;
    inherited Destroy;
  end;

  procedure TReport.Generate(ReportType : TReportType; PeriodStart, PeriodEnd : TDateTime; CurrentDir : String);
  var
    FileName : string;
    FileInfo : TSearchRec;
    Transaction : TTransaction;
    CurSelection : PSelection;
    Name : string;
  begin                         
    Clear;
    rReportType := ReportType;
    rPeriodStart := PeriodStart;
    rPeriodEnd := PeriodEnd;
    Transaction := TTransaction.Create;
    case ReportType of
      tSales : FileName := CurrentDir+'I*'+TransExt;
      tCommands : FileName := CurrentDir+'O*'+TransExt;
    end;
    if FindFirst(FileName, faAnyFile, FileInfo) = 0 then
    begin
      repeat
      begin
        if ((FileInfo.Attr and faDirectory) = 0) and (Transaction.LoadFromFile(CurrentDir+FileInfo.Name) = 0) then
          if (Transaction.Date >= PeriodStart) and (Transaction.Date <= PeriodEnd) then
          begin
            rCount := rCount + 1;
            rSubTotals := rSubTotals + Transaction.SubTotal;
            rFederalTaxes := rFederalTaxes + Transaction.FederalTaxes;
            rStateTaxes := rStateTaxes + Transaction.StateTaxes;
            rFees := rFees + Transaction.Fees;
            rTotals := rTotals + Transaction.Total + Transaction.Fees;
            rDeposits := rDeposits + Transaction.Deposit;
            Name := Transaction.ClientNumber+' - '+Transaction.ClientName;
            if rClients.Values[Name] = '' then
              rClients.Add(Name+'=1')
            else
              rClients.Values[Name] := IntToStr(StrToInt(rClients.Values[Name])+1);
            CurSelection := Transaction.Selections.First;
            while CurSelection <> nil do
            begin
              Name := CurSelection.Code+' - '+CurSelection.Name;
              if rProducts.Values[Name] = '' then
                rProducts.Add(Name+'=1')
              else
                rProducts.Values[Name] := IntToStr(StrToInt(Products.Values[Name])+1);
              CurSelection := CurSelection.Next;
            end;
          end;
      end;
      until FindNext(FileInfo) <> 0;
      SysUtils.FindClose(FileInfo);
    end;
  end;

  procedure TReport.Clear;
  begin
    rReportType := tSales;
    rPeriodStart := 0;
    rPeriodEnd := 0;
    rCount := 0;
    rSubTotals := 0;
    rFederalTaxes := 0;
    rStateTaxes := 0;
    rFees := 0;
    rTotals := 0;
    rDeposits := 0;  
    Clients.Clear;
    Products.Clear;
  end;

end.
