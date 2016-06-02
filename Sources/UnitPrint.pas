(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit UnitPrint;

interface

uses Windows, SysUtils, Classes, Graphics, StrUtils2, PrintPreview,
     UnitMessages, UnitCompany, UnitInventory, UnitEmployee, UnitClient, UnitSupplier,
     UnitTransaction, UnitGroup, UnitProduct, UnitSelection, UnitReport;

type
  TAlignment = (aLeft, aRight, aCenter);

var
  Margins : TRect;
  PrtStr : TStringList;

procedure SetPrintMargins(Rect : TRect);
function PrintCompany(PrintPreview : TPrintPreview; Company : TCompany) : Boolean;
function PrintEmployees(PrintPreview : TPrintPreview; Company : TCompany) : Boolean;
function PrintClients(PrintPreview : TPrintPreview; Company : TCompany) : Boolean;
function PrintSuppliers(PrintPreview : TPrintPreview; Company : TCompany) : Boolean;
function PrintInventory(PrintPreview : TPrintPreview; Company : TCompany; Inventory : TInventory) : Boolean;
function PrintGroup(PrintPreview : TPrintPreview; Company : TCompany; Inventory : TInventory; Group : Word) : Boolean;
function PrintTransaction(PrintPreview : TPrintPreview; Company : TCompany; Transaction : TTransaction) : Boolean;
function PrintReport(PrintPreview : TPrintPreview; Company : TCompany; Report : TReport) : Boolean;

implementation
                             
procedure SetPrintMargins(Rect : TRect);
begin
  Margins := Rect;
end;

procedure TruncateText(Canvas : TCanvas; var Text : String; ToWidth : Integer);
var
  i, TmpInt : Integer;
begin
  if ToWidth > 0 then
  begin
    TmpInt := Canvas.TextWidth(Text[1]);
    for i := 2 to Length(Text)-1 do
    begin
      TmpInt := TmpInt+Canvas.TextWidth(Text[i]);
      if TmpInt >= ToWidth then
        Break;
    end;
    Text := Copy(Text, 0, i-2);
    Text := Text + '...';
  end;
end;

procedure PrintText(PrintPreview : TPrintPreview; Text : String; Alignment : TAlignment; YPos : Integer; Indent, MaxWidth : Real);
var
  X : Integer;
  PageWidth : Integer;
begin
  with PrintPreview do
  begin
    PageWidth := PrinterPageBounds.Right-PrinterPageBounds.Left-Margins.Left-Margins.Right;
    if Indent < 1 then                    { Calculate text indentation }
      X := Round(PageWidth*Indent)
    else
      X := Round(Indent);
    if MaxWidth < 1 then   { Calculate text maximum width, including indent }
      MaxWidth := PageWidth*MaxWidth;
    if (MaxWidth <= 0) or (Round(MaxWidth) > PageWidth) then  { Makes sure the specified width is valid }
      MaxWidth := PageWidth;
    if X+Canvas.TextWidth(Text) > Round(MaxWidth) then  { Truncate the text if necessary }
      TruncateText(Canvas, Text, Round(MaxWidth)-X);
    case Alignment of                              { Prints the text }
      aLeft : begin
        SetTextAlign(Canvas.Handle, TA_LEFT or TA_TOP);
        Canvas.TextOut(PrinterPageBounds.Left+Margins.Left+X, YPos, Text);
      end;
      aRight : begin
        SetTextAlign(Canvas.Handle, TA_RIGHT or TA_TOP);
        Canvas.TextOut(PrinterPageBounds.Right-Margins.Right-X, YPos, Text);
      end;
      aCenter : begin
        SetTextAlign(Canvas.Handle, TA_CENTER or TA_TOP);
        Canvas.TextOut(PrinterPageBounds.Left+Round(PageWidth/2)+X, YPos, Text);
      end;
    end;
  end;
end;
        
procedure PrintLine(PrintPreview : TPrintPreview; Text : String; Alignment : TAlignment; var YPos : Integer; Indent, MaxWidth : Real);
begin
  PrintText(PrintPreview, Text, Alignment, YPos, Indent, MaxWidth);
  Inc(YPos, PrintPreview.Canvas.TextHeight('W'));
end;

procedure DrawImageRect(PrintPreview : TPrintPreview; Rect : TRect; FileName : String);
var
  Bitmap : TBitmap;
begin
  if FileExists(FileName) then
  begin
    Bitmap := TBitmap.Create;
    Bitmap.LoadFromFile(FileName);
    PrintPreview.PaintGraphicEx(Rect, Bitmap, True, False, True);
    Bitmap.Free;
  end;
end;

procedure DrawLine(PrintPreview : TPrintPreview; var YPos : Integer);
var
  OldPen : TPenRecall;
begin
  with PrintPreview do
  begin
    OldPen := TPenRecall.Create(Canvas.Pen);
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Width := Canvas.TextHeight('W') div 10;
    Canvas.Pen.Color := $00000000;
    Canvas.MoveTo(PrinterPageBounds.Left+Margins.Left, YPos+Canvas.Pen.Width*2);
    Canvas.LineTo(PrinterPageBounds.Right-Margins.Right, YPos+Canvas.Pen.Width*2);
    Inc(YPos, Canvas.Pen.Width*5);
    OldPen.Free;  
  end;
end;

procedure PrintHead(PrintPreview : TPrintPreview; Caption, Infos : String; var YPos : Integer);
var
  sDate : String;
begin
  with PrintPreview do
  begin
    sDate := FormatDateTime('dddddd', Date);
    PrintLine(PrintPreview, PrtStr.Values['A00']+' - '+Caption, aLeft, YPos, 0, 0.85);
    DrawLine(PrintPreview, YPos);
    PrintText(PrintPreview, Infos, aLeft, YPos, 0, 0.75);
    PrintLine(PrintPreview, sDate, aRight, YPos, 0, 0.2);
  end;
end;

function PrintCompany(PrintPreview : TPrintPreview; Company : TCompany) : Boolean;
var
  XPos : Real;
  YPos,
  PageHeight,
  LineHeight : Integer;
  FileInfo : TSearchRec;
  Inventory : TInventory;
begin
  with PrintPreview do try
  begin
    BeginDoc;
    PageHeight := PrinterPageBounds.Bottom-PrinterPageBounds.Top-Margins.Top-Margins.Bottom;
    LineHeight := Canvas.TextHeight('W');

    YPos := PrinterPageBounds.Top+Margins.Top;
    PrintHead(PrintPreview, Company.Name, PrtStr.Values['A01'], YPos);
    Inc(YPos, LineHeight);

    XPos := 0.025;
    if FileExists(MakeFileName(Company.FilesDir, 'logo.bmp')) then
    begin
      DrawImageRect(PrintPreview, Rect(PrinterPageBounds.Left+Margins.Left, YPos, PrinterPageBounds.Left+Margins.Left+LineHeight*6, YPos+LineHeight*6), MakeFileName(Company.FilesDir, 'logo.bmp'));
      XPos := LineHeight*7;
    end;
    PrintLine(PrintPreview, Company.Name, aLeft, YPos, XPos, 0);
    PrintLine(PrintPreview, Company.InfoLine1, aLeft, YPos, XPos, 0);
    PrintLine(PrintPreview, Company.InfoLine2, aLeft, YPos, XPos, 0);
    PrintLine(PrintPreview, Company.InfoLine3, aLeft, YPos, XPos, 0);
    PrintLine(PrintPreview, Company.InfoLine4, aLeft, YPos, XPos, 0);
    PrintLine(PrintPreview, Company.InfoLine5, aLeft, YPos, XPos, 0);

    Inc(YPos, LineHeight);
    PrintLine(PrintPreview, PrtStr.Values['B00']+' '+Company.FederalTaxName, aLeft, YPos, 0, 0);
    PrintLine(PrintPreview, PrtStr.Values['B01']+' '+FormatFloat('#0.0#%', Company.FederalTaxValue), aLeft, YPos, 0, 0);
    PrintLine(PrintPreview, PrtStr.Values['B02']+' '+Company.FederalTaxNumber, aLeft, YPos, 0, 0);
    Inc(YPos, LineHeight);
    if Company.StateTaxValue > 0 then
    begin
      PrintLine(PrintPreview, PrtStr.Values['B03']+' '+Company.StateTaxName, aLeft, YPos, 0, 0);
      PrintLine(PrintPreview, PrtStr.Values['B04']+' '+FormatFloat('#0.0#%', Company.StateTaxValue), aLeft, YPos, 0, 0);
      PrintLine(PrintPreview, PrtStr.Values['B05']+' '+Company.StateTaxNumber, aLeft, YPos, 0, 0);
    end;

    Inc(YPos, LineHeight);
    PrintLine(PrintPreview, PrtStr.Values['B06'], aLeft, YPos, 0.00, 0);
    Inc(YPos, LineHeight);
    PrintLine(PrintPreview, Company.QuotationL1, aLeft, YPos, 0.025, 0.975);
    PrintLine(PrintPreview, Company.QuotationL2, aLeft, YPos, 0.025, 0.975);
    PrintLine(PrintPreview, Company.QuotationL3, aLeft, YPos, 0.025, 0.975);

    Inc(YPos, LineHeight);
    PrintLine(PrintPreview, PrtStr.Values['B07'], aLeft, YPos, 0.00, 0);
    Inc(YPos, LineHeight);
    PrintLine(PrintPreview, Company.OrderL1, aLeft, YPos, 0.025, 0.975);
    PrintLine(PrintPreview, Company.OrderL2, aLeft, YPos, 0.025, 0.975);
    PrintLine(PrintPreview, Company.OrderL3, aLeft, YPos, 0.025, 0.975);
    
    Inc(YPos, LineHeight);
    PrintLine(PrintPreview, PrtStr.Values['B08'], aLeft, YPos, 0.00, 0);
    Inc(YPos, LineHeight);
    PrintLine(PrintPreview, Company.QuotationL1, aLeft, YPos, 0.025, 0.975);
    PrintLine(PrintPreview, Company.QuotationL2, aLeft, YPos, 0.025, 0.975);
    PrintLine(PrintPreview, Company.QuotationL3, aLeft, YPos, 0.025, 0.975);

    Inventory := TInventory.Create;
    if FindFirst(Company.FilesDir+'*'+InvExt, faAnyFile, FileInfo) = 0 then
    begin
      Inc(YPos, LineHeight);
      PrintLine(PrintPreview, PrtStr.Values['B09'], aLeft, YPos, 0, 0);
      DrawLine(PrintPreview, YPos);         
      PrintText(PrintPreview, PrtStr.Values['C01'], aLeft, YPos, 0.025, 0.275);
      PrintText(PrintPreview, PrtStr.Values['C08'], aLeft, YPos, 0.3, 0.475);
      PrintLine(PrintPreview, PrtStr.Values['C09'], aLeft, YPos, 0.5, 0.975);
      Inc(YPos, LineHeight);
      repeat
      begin
        if ((FileInfo.Attr and faDirectory) = 0) and (Inventory.LoadHeaderFromFile(MakeFileName(Company.FilesDir, FileInfo.Name)) = 0) then
        begin
          if YPos+LineHeight > PageHeight-LineHeight then
          begin                
            PrintText(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0, 0);
            NewPage;
            YPos := PrinterPageBounds.Top+Margins.Top;
            PrintHead(PrintPreview, Company.Name, PrtStr.Values['A01'], YPos);
            Inc(YPos, LineHeight);
            PrintLine(PrintPreview, PrtStr.Values['B09'], aLeft, YPos, 0, 0);
            DrawLine(PrintPreview, YPos);    
            PrintText(PrintPreview, PrtStr.Values['C01'], aLeft, YPos, 0.025, 0.275);
            PrintText(PrintPreview, PrtStr.Values['C08'], aLeft, YPos, 0.3, 0.475);
            PrintLine(PrintPreview, PrtStr.Values['C09'], aLeft, YPos, 0.5, 0.975);
            Inc(YPos, LineHeight);
          end;
          PrintText(PrintPreview, Inventory.Name, aLeft, YPos, 0.025, 0.275);
          PrintText(PrintPreview, FormatDateTime('dddddd', Inventory.Date), aLeft, YPos, 0.3, 0.475);
          PrintLine(PrintPreview, Inventory.Description, aLeft, YPos, 0.5, 0.975);
        end;
      end;
      until FindNext(FileInfo) <> 0;
      FindClose(FileInfo);
    end;
    Inventory.Free;
    EndDoc;
    Result := True;
  end
  except
    PrintPreview.Abort;
    Result := False;
  end;
end;

function PrintEmployees(PrintPreview : TPrintPreview; Company : TCompany) : Boolean;
var
  YPos,
  PageHeight,
  LineHeight : Integer;
  i : Integer;
  CurEmployee : PEmployee;
begin
  with PrintPreview do try
  begin
    BeginDoc;
    PageHeight := PrinterPageBounds.Bottom-PrinterPageBounds.Top-Margins.Top-Margins.Bottom;
    LineHeight := Canvas.TextHeight('W');

    YPos := PrinterPageBounds.Top+Margins.Top;
    PrintHead(PrintPreview, Company.Name, PrtStr.Values['A02'], YPos);
    Inc(YPos, LineHeight);

    i := 0;
    CurEmployee := Company.Employees.First;
    while CurEmployee <> nil do
    begin
      if YPos+(LineHeight*5) > PageHeight-LineHeight then
      begin
        PrintText(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0, 0);
        NewPage;  
        YPos := PrinterPageBounds.Top+Margins.Top;
        PrintHead(PrintPreview, Company.Name, PrtStr.Values['A02'], YPos);
        Inc(YPos, LineHeight);
      end;

      if not Odd(i) then
      begin
        PrintLine(PrintPreview, CurEmployee.Number+' - '+CurEmployee.Name, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurEmployee.Address, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurEmployee.Telephone, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurEmployee.Email, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurEmployee.Other, aLeft, YPos, 0.025, 0.475);
      end
      else
      begin
        Dec(YPos, LineHeight*5);
        PrintLine(PrintPreview, CurEmployee.Number+' - '+CurEmployee.Name, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurEmployee.Address, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurEmployee.Telephone, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurEmployee.Email, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurEmployee.Other, aLeft, YPos, 0.5, 0.975);
        if (i > 0) and (i < Company.Employees.Size-1)  then
        begin
          Inc(YPos, LineHeight);
          DrawLine(PrintPreview, YPos);
          Inc(YPos, LineHeight);
        end;
      end;
      i := i +1;
      CurEmployee := CurEmployee.Next;
    end;
    EndDoc;
    Result := True;
  end
  except
    PrintPreview.Abort;
    Result := False;
  end;
end;

function PrintClients(PrintPreview : TPrintPreview; Company : TCompany) : Boolean;
var
  YPos,
  PageHeight,
  LineHeight : Integer;
  i : Integer;
  CurClient : PClient;
begin
with PrintPreview do try
  begin
    BeginDoc;
    PageHeight := PrinterPageBounds.Bottom-PrinterPageBounds.Top-Margins.Top-Margins.Bottom;
    LineHeight := Canvas.TextHeight('W');

    YPos := PrinterPageBounds.Top+Margins.Top;
    PrintHead(PrintPreview, Company.Name, PrtStr.Values['A03'], YPos);
    Inc(YPos, LineHeight);

    i := 0;
    CurClient := Company.Clients.First;
    while CurClient <> nil do
    begin
      if YPos+(LineHeight*5) > PageHeight-LineHeight then
      begin
        PrintText(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0, 0);
        NewPage;
        YPos := PrinterPageBounds.Top+Margins.Top;
        PrintHead(PrintPreview, Company.Name, PrtStr.Values['A03'], YPos);
        Inc(YPos, LineHeight);
      end;

      if not Odd(i) then
      begin
        PrintLine(PrintPreview, CurClient.Number+' - '+CurClient.Name, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurClient.Address, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurClient.Telephone, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurClient.Email, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurClient.Other, aLeft, YPos, 0.025, 0.475);
      end
      else
      begin
        Dec(YPos, LineHeight*5);
        PrintLine(PrintPreview, CurClient.Number+' - '+CurClient.Name, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurClient.Address, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurClient.Telephone, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurClient.Email, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurClient.Other, aLeft, YPos, 0.5, 0.975);
        if (i > 0) and (i < Company.Clients.Size-1)  then
        begin
          Inc(YPos, LineHeight);
          DrawLine(PrintPreview, YPos);
          Inc(YPos, LineHeight);
        end;
      end;
      i := i +1;
      CurClient := CurClient.Next;
    end;
    EndDoc;
    Result := True;
  end
  except
    PrintPreview.Abort;
    Result := False;
  end;
end;

function PrintSuppliers(PrintPreview : TPrintPreview; Company : TCompany) : Boolean;
var
  YPos,
  PageHeight,
  LineHeight : Integer;
  i : Integer;
  CurSupplier : PSupplier;
begin
  with PrintPreview do try
  begin
    BeginDoc;
    PageHeight := PrinterPageBounds.Bottom-PrinterPageBounds.Top-Margins.Top-Margins.Bottom;
    LineHeight := Canvas.TextHeight('W');

    YPos := PrinterPageBounds.Top+Margins.Top;
    PrintHead(PrintPreview, Company.Name, PrtStr.Values['A04'], YPos);
    Inc(YPos, LineHeight);

    i := 0;
    CurSupplier := Company.Suppliers.First;
    while CurSupplier <> nil do
    begin
      if YPos+(LineHeight*5) > PageHeight-LineHeight then
      begin
        PrintText(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0, 0);
        NewPage;  
        YPos := PrinterPageBounds.Top+Margins.Top;
        PrintHead(PrintPreview, Company.Name, PrtStr.Values['A04'], YPos);
        Inc(YPos, LineHeight);
      end;

      if not Odd(i) then
      begin
        PrintLine(PrintPreview, CurSupplier.Number+' - '+CurSupplier.Name, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurSupplier.Address, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurSupplier.Telephone, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurSupplier.Email, aLeft, YPos, 0.025, 0.475);
        PrintLine(PrintPreview, CurSupplier.Other, aLeft, YPos, 0.025, 0.475);
      end
      else
      begin
        Dec(YPos, LineHeight*5);
        PrintLine(PrintPreview, CurSupplier.Number+' - '+CurSupplier.Name, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurSupplier.Address, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurSupplier.Telephone, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurSupplier.Email, aLeft, YPos, 0.5, 0.975);
        PrintLine(PrintPreview, CurSupplier.Other, aLeft, YPos, 0.5, 0.975);
        if (i > 0) and (i < Company.Suppliers.Size-1)  then
        begin
          Inc(YPos, LineHeight);
          DrawLine(PrintPreview, YPos);
          Inc(YPos, LineHeight);
        end;
      end;
      i := i +1;
      CurSupplier := CurSupplier.Next;
    end;
    EndDoc;
    Result := True;
  end
  except
    PrintPreview.Abort;
    Result := False;
  end;
end;

function PrintInventory(PrintPreview : TPrintPreview; Company : TCompany; Inventory : TInventory) : Boolean;
var
  YPos,
  PageHeight,
  LineHeight : Integer;
  CurGroup : PGroup;
  CurProduct : PProduct;
begin
  with PrintPreview do try
  begin
    BeginDoc;
    PageHeight := PrinterPageBounds.Bottom-PrinterPageBounds.Top-Margins.Top-Margins.Bottom;
    LineHeight := Canvas.TextHeight('W');
                   
    YPos := PrinterPageBounds.Top+Margins.Top;
    PrintHead(PrintPreview, Company.Name, PrtStr.Values['A05']+' "'+Inventory.Name+'" ('+FormatDateTime('dddddd', Inventory.Date)+').', YPos);
    Inc(YPos, LineHeight);

    CurGroup := Inventory.Groups.First;
    while CurGroup <> nil do
    begin
      if YPos+(LineHeight*4) > PageHeight-LineHeight then
      begin
        PrintText(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0.0, 0);
        NewPage;
        YPos := PrinterPageBounds.Top+Margins.Top;
        PrintHead(PrintPreview, Company.Name, PrtStr.Values['A05']+' "'+Inventory.Name+'" ('+FormatDateTime('dddddd', Inventory.Date)+').', YPos);
        Inc(YPos, LineHeight);
      end;

      PrintLine(PrintPreview, CurGroup.Code+' - '+CurGroup.Name, aLeft, YPos, 0, 0);
      DrawLine(PrintPreview, YPos);
      PrintText(PrintPreview, PrtStr.Values['C00'], aLeft, YPos, 0.01, 0.11);
      PrintText(PrintPreview, PrtStr.Values['C01'], aLeft, YPos, 0.135, 0.565);
      PrintText(PrintPreview, PrtStr.Values['C02'], aRight, YPos, 0.285, 0.385);
      PrintText(PrintPreview, PrtStr.Values['C03'], aRight, YPos, 0.160, 0.260);
      PrintText(PrintPreview, PrtStr.Values['C06'], aRight, YPos, 0.085, 0.135);
      PrintLine(PrintPreview, PrtStr.Values['C07'], aRight, YPos, 0.01, 0.06); 
      Inc(YPos, LineHeight);

      CurProduct := CurGroup.Products.First;
      while CurProduct <> nil do
      begin
        if YPos+LineHeight > PageHeight-LineHeight then
        begin
          PrintText(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0, 0);
          NewPage;      
          YPos := PrinterPageBounds.Top+Margins.Top;
          PrintHead(PrintPreview, Company.Name, PrtStr.Values['A05']+' "'+Inventory.Name+'" ('+FormatDateTime('dddddd', Inventory.Date)+').', YPos);
          Inc(YPos, LineHeight);                                      
          PrintLine(PrintPreview, CurGroup.Code+' - '+CurGroup.Name, aLeft, YPos, 0, 0);
          DrawLine(PrintPreview, YPos);
          PrintText(PrintPreview, PrtStr.Values['C00'], aLeft, YPos, 0.01, 0.11);
          PrintText(PrintPreview, PrtStr.Values['C01'], aLeft, YPos, 0.135, 0.565);
          PrintText(PrintPreview, PrtStr.Values['C02'], aRight, YPos, 0.285, 0.385);
          PrintText(PrintPreview, PrtStr.Values['C03'], aRight, YPos, 0.160, 0.260);
          PrintText(PrintPreview, PrtStr.Values['C06'], aRight, YPos, 0.085, 0.135);
          PrintLine(PrintPreview, PrtStr.Values['C07'], aRight, YPos, 0.01, 0.06);
          Inc(YPos, LineHeight);
        end;
        PrintText(PrintPreview, CurProduct.Code, aLeft, YPos, 0.01, 0.11);
        PrintText(PrintPreview, CurProduct.Name, aLeft, YPos, 0.135, 0.565);
        PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, CurProduct.Cost), aRight, YPos, 0.285, 0.385);
        PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, CurProduct.Price), aRight, YPos, 0.160, 0.260);
        PrintText(PrintPreview, IntToStr(CurProduct.Quantity), aRight, YPos, 0.085, 0.135);
        if CurProduct.Taxed then
          PrintText(PrintPreview, 'T', aRight, YPos, 0.01, 0.06);
        CurProduct := CurProduct.Next;
        Inc(YPos, LineHeight);
      end;
      CurGroup := CurGroup.Next;
      Inc(YPos, LineHeight);
    end;
    EndDoc;
    Result := True;
  end
  except
    PrintPreview.Abort;
    Result := False;
  end;
end;

function PrintGroup(PrintPreview : TPrintPreview; Company : TCompany; Inventory : TInventory; Group : Word) : Boolean;
var
  YPos,
  PageHeight,
  LineHeight : Integer;
  CurGroup : PGroup;
  CurProduct : PProduct;
begin
  with PrintPreview do try
  begin
    BeginDoc;
    PageHeight := PrinterPageBounds.Bottom-PrinterPageBounds.Top-Margins.Top-Margins.Bottom;
    LineHeight := Canvas.TextHeight('W');

    YPos := PrinterPageBounds.Top+Margins.Top;
    PrintHead(PrintPreview, Company.Name, PrtStr.Values['A06']+' "'+Inventory.Name+'" ('+FormatDateTime('dddddd', Inventory.Date)+').', YPos);
    Inc(YPos, LineHeight);

    CurGroup := Inventory.Groups.Get(Group);
    PrintLine(PrintPreview, CurGroup.Code+' - '+CurGroup.Name, aLeft, YPos, 0, 0);
    DrawLine(PrintPreview, YPos);
    PrintText(PrintPreview, PrtStr.Values['C00'], aLeft, YPos, 0.01, 0.11);
    PrintText(PrintPreview, PrtStr.Values['C01'], aLeft, YPos, 0.135, 0.565);
    PrintText(PrintPreview, PrtStr.Values['C02'], aRight, YPos, 0.285, 0.385);
    PrintText(PrintPreview, PrtStr.Values['C03'], aRight, YPos, 0.160, 0.260);
    PrintText(PrintPreview, PrtStr.Values['C06'], aRight, YPos, 0.085, 0.135);
    PrintLine(PrintPreview, PrtStr.Values['C07'], aRight, YPos, 0.01, 0.06);
    Inc(YPos, LineHeight);
                                          
    CurProduct := CurGroup.Products.First;
    while CurProduct <> nil do
    begin
      if YPos+LineHeight > PageHeight-LineHeight then
      begin
        PrintText(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0, 0);
        NewPage;          
        YPos := PrinterPageBounds.Top+Margins.Top;
        PrintHead(PrintPreview, Company.Name, PrtStr.Values['A06']+' "'+Inventory.Name+'" ('+FormatDateTime('dddddd', Inventory.Date)+').', YPos);
        Inc(YPos, LineHeight);
        PrintLine(PrintPreview, CurGroup.Code+' - '+CurGroup.Name, aLeft, YPos, 0, 0);
        DrawLine(PrintPreview, YPos);
        PrintText(PrintPreview, PrtStr.Values['C00'], aLeft, YPos, 0.01, 0.11);
        PrintText(PrintPreview, PrtStr.Values['C01'], aLeft, YPos, 0.135, 0.565);
        PrintText(PrintPreview, PrtStr.Values['C02'], aRight, YPos, 0.285, 0.385);
        PrintText(PrintPreview, PrtStr.Values['C03'], aRight, YPos, 0.160, 0.260);
        PrintText(PrintPreview, PrtStr.Values['C06'], aRight, YPos, 0.085, 0.135);
        PrintLine(PrintPreview, PrtStr.Values['C07'], aRight, YPos, 0.01, 0.06);
        Inc(YPos, LineHeight);
      end;
      PrintText(PrintPreview, CurProduct.Code, aLeft, YPos, 0.01, 0.11);
      PrintText(PrintPreview, CurProduct.Name, aLeft, YPos, 0.135, 0.565);
      PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, CurProduct.Cost), aRight, YPos, 0.285, 0.385);
      PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, CurProduct.Price), aRight, YPos, 0.160, 0.260);
      PrintText(PrintPreview, IntToStr(CurProduct.Quantity), aRight, YPos, 0.085, 0.135);
      if CurProduct.Taxed then
        PrintText(PrintPreview, 'T', aRight, YPos, 0.01, 0.06);
      Inc(YPos, LineHeight);
      CurProduct := CurProduct.Next;
    end;  
    EndDoc;
    Result := True;
  end
  except
    PrintPreview.Abort;
    Result := False;
  end;
end;

procedure PrintTransHead(PrintPreview : TPrintPreview; Company : TCompany; Transaction : TTransaction; var YPos : Integer);
var
  LineHeight : Integer;
  XPos : Real;
begin
  with PrintPreview do
  begin
    LineHeight := Canvas.TextHeight('W');

    XPos := 0;
    if FileExists(MakeFileName(Company.FilesDir, 'logo.bmp')) then
    begin
      DrawImageRect(PrintPreview, Rect(PrinterPageBounds.Left+Margins.Left, YPos, PrinterPageBounds.Left+Margins.Left+LineHeight*6, YPos+LineHeight*6), MakeFileName(Company.FilesDir, 'logo.bmp'));
      XPos := LineHeight*7;
    end;
    PrintLine(PrintPreview, Company.Name, aLeft, YPos, XPos, 0.625);
    PrintLine(PrintPreview, Company.InfoLine1, aLeft, YPos, XPos, 0.625);
    PrintLine(PrintPreview, Company.InfoLine2, aLeft, YPos, XPos, 0.625);
    PrintLine(PrintPreview, Company.InfoLine3, aLeft, YPos, XPos, 0.625);
    PrintLine(PrintPreview, Company.InfoLine4, aLeft, YPos, XPos, 0.625);
    PrintLine(PrintPreview, Company.InfoLine5, aLeft, YPos, XPos, 0.625);

    Dec(YPos, LineHeight*6);
    case Transaction.FormType of
      fQuotation: PrintLine(PrintPreview, PrtStr.Values['D00']+' '+IntToStr(Transaction.QuotationNumber), aLeft, YPos, 0.65, 0.875);
      fOrder: PrintLine(PrintPreview, PrtStr.Values['D01']+' '+IntToStr(Transaction.OrderNumber), aLeft, YPos, 0.65, 0.875);
      fInvoice: PrintLine(PrintPreview, PrtStr.Values['D02']+' '+IntToStr(Transaction.InvoiceNumber), aLeft, YPos, 0.65, 0.875);
    end;
    PrintLine(PrintPreview, FormatDateTime('dddddd', Transaction.Date), aLeft, YPos, 0.65, 0);
    PrintLine(PrintPreview, PrtStr.Values['D03']+' '+Transaction.EmployeeNumber+' - '+Transaction.EmployeeName, aLeft, YPos, 0.65, 0);
    case Transaction.PaymentType of
      pCash: begin
        PrintLine(PrintPreview, PrtStr.Values['D04'], aLeft, YPos, 0.65, 0); 
        Inc(YPos, LineHeight);
      end;
      pDebit: begin
        PrintLine(PrintPreview, PrtStr.Values['D05'], aLeft, YPos, 0.65, 0);
        Inc(YPos, LineHeight);
      end;
      pCredit: begin
        PrintLine(PrintPreview, PrtStr.Values['D06'], aLeft, YPos, 0.65, 0);
        PrintText(PrintPreview, PrtStr.Values['D07']+' '+Transaction.CreditCardNumber, aLeft, YPos, 0.65, 0.85);
        PrintLine(PrintPreview, PrtStr.Values['D08']+' '+Transaction.CreditCardExp, aLeft, YPos, 0.875, 0);
      end;
    end;
    Inc(YPos, LineHeight*2);
    PrintLine(PrintPreview, PrtStr.Values['D09'], aLeft, YPos, 0.025, 0.475);
    PrintLine(PrintPreview, Transaction.ClientNumber+' - '+Transaction.ClientName, aLeft, YPos, 0.05, 0.475);
    PrintLine(PrintPreview, Transaction.ClientAddress, aLeft, YPos, 0.05, 0.475);
    PrintLine(PrintPreview, Transaction.ClientTelephone, aLeft, YPos, 0.05, 0.475);
    PrintLine(PrintPreview, Transaction.ClientEmail, aLeft, YPos, 0.05, 0.475);
    if Transaction.RecipientNumber <> '' then
    begin
      Dec(YPos, LineHeight*5);
      PrintLine(PrintPreview, PrtStr.Values['D10'], aLeft, YPos, 0.525, 0);
      PrintLine(PrintPreview, Transaction.RecipientNumber+' - '+Transaction.RecipientName, aLeft, YPos, 0.55, 0);
      PrintLine(PrintPreview, Transaction.RecipientAddress, aLeft, YPos, 0.55, 0);
      PrintLine(PrintPreview, Transaction.RecipientTelephone, aLeft, YPos, 0.55, 0);
      PrintLine(PrintPreview, Transaction.RecipientEmail, aLeft, YPos, 0.55, 0);
    end;
    Inc(YPos, LineHeight);
    DrawLine(PrintPreview, YPos);
    PrintText(PrintPreview, PrtStr.Values['C06'], aLeft, YPos, 0.01, 0.06);
    PrintText(PrintPreview, PrtStr.Values['C00'], aLeft, YPos, 0.075, 0.175);
    PrintText(PrintPreview, PrtStr.Values['C01'], aLeft, YPos, 0.2, 0.675);
    PrintText(PrintPreview, PrtStr.Values['C04'], aRight, YPos, 0.2, 0.3);
    PrintText(PrintPreview, PrtStr.Values['C05'], aRight, YPos, 0.075, 0.175);
    PrintLine(PrintPreview, PrtStr.Values['C07'], aRight, YPos, 0.01, 0.06);
    DrawLine(PrintPreview, YPos);
  end;
end;

procedure PrintTransFoot(PrintPreview : TPrintPreview; Company : TCompany;  Transaction : TTransaction);
var
  LineHeight : Integer;
  YPos : Integer;
begin
  with PrintPreview do
  begin
    LineHeight := Canvas.TextHeight('W');
    YPos := PrinterPageBounds.Bottom-Margins.Bottom-(LineHeight*8);
    { Sub-total }
    PrintText(PrintPreview, PrtStr.Values['D11'], aRight, YPos, 0.125, 0.225);
    PrintLine(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Transaction.SubTotal), aRight, YPos, 0.01, 0.1);
    DrawLine(PrintPreview, YPos);
    { Message }
    case Transaction.FormType of
      fQuotation: begin
        PrintLine(PrintPreview, Company.QuotationL1, aLeft, YPos, 0.01, 0.75);
        PrintLine(PrintPreview, Company.QuotationL2, aLeft, YPos, 0.01, 0.75);
        PrintLine(PrintPreview, Company.QuotationL3, aLeft, YPos, 0.01, 0.75);
        PrintLine(PrintPreview, Company.QuotationL4, aLeft, YPos, 0.01, 0.75);
      end;
      fOrder: begin
        PrintLine(PrintPreview, Company.OrderL1, aLeft, YPos, 0.01, 0.75);
        PrintLine(PrintPreview, Company.OrderL2, aLeft, YPos, 0.01, 0.75);
        PrintLine(PrintPreview, Company.OrderL3, aLeft, YPos, 0.01, 0.75);
        PrintLine(PrintPreview, Company.OrderL4, aLeft, YPos, 0.01, 0.75);
      end;
      fInvoice: begin
        PrintLine(PrintPreview, Company.InvoiceL1, aLeft, YPos, 0.01, 0.75);
        PrintLine(PrintPreview, Company.InvoiceL2, aLeft, YPos, 0.01, 0.75);
        PrintLine(PrintPreview, Company.InvoiceL3, aLeft, YPos, 0.01, 0.75);
        PrintLine(PrintPreview, Company.InvoiceL4, aLeft, YPos, 0.01, 0.75);
      end;
    end;
    Dec(YPos, LineHeight*4);
    { Federal tax }
    PrintText(PrintPreview, Company.FederalTaxName+':', aRight, YPos, 0.125, 0.225);
    PrintLine(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Transaction.FederalTaxes), aRight, YPos, 0.01, 0.1);
    { State tax }
    PrintText(PrintPreview, Company.StateTaxName+':', aRight, YPos, 0.125, 0.225);
    PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Transaction.StateTaxes), aRight, YPos, 0.01, 0.1);
    Inc(YPos, LineHeight);
    { Fees }
    PrintText(PrintPreview, PrtStr.Values['D12'], aRight, YPos, 0.125, 0.225);
    PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Transaction.Fees), aRight, YPos, 0.01, 0.1);
    Inc(YPos, LineHeight);
    { Total }
    PrintText(PrintPreview, PrtStr.Values['D13'], aRight, YPos, 0.125, 0.225);
    PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Transaction.Total+Transaction.Fees), aRight, YPos, 0.01, 0.1);
    Inc(YPos, LineHeight);
    DrawLine(PrintPreview, YPos);
    { Registration numbers }
    PrintText(PrintPreview, Company.FederalTaxName+': '+Company.FederalTaxNumber, aLeft, YPos, 0.01, 0.35);
    PrintText(PrintPreview, Company.StateTaxName+': '+Company.StateTaxNumber, aLeft, YPos, 0.375, 0.75);
    { Deposit and balance }
    if Transaction.FormType <> fQuotation then
    begin
      PrintText(PrintPreview, PrtStr.Values['D14'], aRight, YPos, 0.125, 0.225);
      PrintLine(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Transaction.Deposit), aRight, YPos, 0.01, 0.1);
      PrintText(PrintPreview, PrtStr.Values['D15'], aRight, YPos, 0.125, 0.225);
      PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Transaction.Balance), aRight, YPos, 0.01, 0.1);
    end;
  end;
end;

function PrintTransaction(PrintPreview : TPrintPreview; Company : TCompany; Transaction : TTransaction) : Boolean;
var
  YPos,
  PageHeight,
  LineHeight : Integer;
  i : Integer;
  CurSelection : PSelection;
  Comments : TStringList;
begin
  with PrintPreview do try
  begin
    BeginDoc;
    PageHeight := PrinterPageBounds.Bottom-PrinterPageBounds.Top-Margins.Top-Margins.Bottom;
    LineHeight := Canvas.TextHeight('W');
                    
    YPos := PrinterPageBounds.Top+Margins.Top;
    PrintTransHead(PrintPreview, Company, Transaction, YPos);
    Inc(YPos, LineHeight);

    CurSelection := Transaction.Selections.First;
    while CurSelection <> nil do
    begin
      if YPos+(LineHeight*11) > PageHeight-LineHeight then
      begin  { Need at least 11 line for foot + product w/desc }
        PrintLine(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0, 0);
        PrintTransFoot(PrintPreview, Company, Transaction);
        NewPage;      
        YPos := PrinterPageBounds.Top+Margins.Top;
        PrintTransHead(PrintPreview, Company, Transaction, YPos);
        Inc(YPos, LineHeight);
      end;
      PrintText(PrintPreview, IntToStr(CurSelection.Quantity), aLeft, YPos, 0.01, 0.06);
      PrintText(PrintPreview, CurSelection.Code, aLeft, YPos, 0.075, 0.175);
      PrintText(PrintPreview, CurSelection.Name, aLeft, YPos, 0.2, 0.675);
      if not CurSelection.Descriptive then
      begin
        PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, CurSelection.Price), aRight, YPos, 0.2, 0.3);
        PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, CurSelection.Quantity*CurSelection.Price), aRight, YPos, 0.075, 0.175);
        if CurSelection.Taxed then
          PrintText(PrintPreview, 'T ', aRight, YPos, 0.01, 0.06);
      end;
      Inc(YPos, LineHeight);
      if CurSelection.Comments <> '' then
        PrintLine(PrintPreview, CurSelection.Comments, aLeft, YPos, 0.2, 0.675);
      CurSelection := CurSelection.Next;
    end;
    Inc(YPos, LineHeight);
            
    Comments := TStringList.Create;
    Comments.SetText(PChar(Transaction.Comments));
    for i := 0 to Comments.Count-1 do
    begin
      if YPos+(LineHeight*10) > PageHeight-LineHeight then
      begin
        PrintLine(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0, 0);
        PrintTransFoot(PrintPreview, Company, Transaction);
        NewPage;            
        YPos := PrinterPageBounds.Top+Margins.Top;
        PrintTransHead(PrintPreview, Company, Transaction, YPos);
        Inc(YPos, LineHeight);
      end;
      PrintText(PrintPreview, Comments.Strings[i], aLeft, YPos, 0.01, 0);
    end;
    PrintTransFoot(PrintPreview, Company, Transaction);
    EndDoc;
    Result := True;
  end
  except
    PrintPreview.Abort;
    Result := False;
  end;
end;

function PrintReport(PrintPreview : TPrintPreview; Company : TCompany; Report : TReport) : Boolean;
var    
  YPos,        
  PageHeight,
  LineHeight : Integer;
  i : Integer;
begin
  with PrintPreview do try
  begin
    BeginDoc;                                 
    PageHeight := PrinterPageBounds.Bottom-PrinterPageBounds.Top-Margins.Top-Margins.Bottom;
    LineHeight := Canvas.TextHeight('W');

    YPos := PrinterPageBounds.Top+Margins.Top;
    if Report.ReportType = tSales then
      PrintHead(PrintPreview, Company.Name, PrtStr.Values['A07']+' '+PrtStr.Values['E00']+' '+FormatDateTime('dddddd', Report.PeriodStart)+' '+PrtStr.Values['E01']+' '+FormatDateTime('dddddd', Report.PeriodEnd)+'.', YPos)
    else
      PrintHead(PrintPreview, Company.Name, PrtStr.Values['A08']+' '+PrtStr.Values['E00']+' '+FormatDateTime('dddddd', Report.PeriodStart)+' '+PrtStr.Values['E01']+' '+FormatDateTime('dddddd', Report.PeriodEnd)+'.', YPos);
    Inc(YPos, LineHeight);

    if Report.ReportType = tSales then
      PrintText(PrintPreview, PrtStr.Values['E02'], aLeft, YPos, 0.01, 0.2)
    else
      PrintText(PrintPreview, PrtStr.Values['E03'], aLeft, YPos, 0.01, 0.2);
    PrintText(PrintPreview, IntToStr(Report.Count), aRight, YPos, 0.7, 0);

    Inc(YPos, LineHeight);
    PrintText(PrintPreview, PrtStr.Values['E04'], aLeft, YPos, 0.01, 0.2);
    PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Report.SubTotals), aRight, YPos, 0.7, 0);
    Inc(YPos, LineHeight);
    PrintText(PrintPreview, Company.FederalTaxName+':', aLeft, YPos, 0.01, 0.2);
    PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Report.FederalTaxes), aRight, YPos, 0.7, 0);
    Inc(YPos, LineHeight);
    PrintText(PrintPreview, Company.StateTaxName+':', aLeft, YPos, 0.01, 0.2);
    PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Report.StateTaxes), aRight, YPos, 0.7, 0);
    Inc(YPos, LineHeight);
    PrintText(PrintPreview, PrtStr.Values['E05'], aLeft, YPos, 0.01, 0.2);
    PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Report.Fees), aRight, YPos, 0.7, 0);
    Inc(YPos, LineHeight);
    PrintText(PrintPreview, PrtStr.Values['E06'], aLeft, YPos, 0.01, 0.2);
    PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Report.Totals), aRight, YPos, 0.7, 0);
    Inc(YPos, LineHeight);
    PrintText(PrintPreview, PrtStr.Values['E07'], aLeft, YPos, 0.01, 0.2);
    PrintText(PrintPreview, FormatFloat('# ### ##0.00 '+Company.CurrencySign, Report.Deposits), aRight, YPos, 0.7, 0);
    Inc(YPos, LineHeight);

    Inc(YPos, LineHeight);
    PrintLine(PrintPreview, PrtStr.Values['E08'], aLeft, YPos, 0, 0);
    DrawLine(PrintPreview, YPos);
    Inc(YPos, LineHeight);
    for i := 0 to Report.Clients.Count-1 do
    begin
      if YPos+LineHeight > PageHeight-LineHeight then
      begin             
        PrintText(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0, 0);
        NewPage;
        YPos := PrinterPageBounds.Top+Margins.Top;
        if Report.ReportType = tSales then
          PrintHead(PrintPreview, Company.Name, PrtStr.Values['A07']+' '+PrtStr.Values['E00']+' '+FormatDateTime('dddddd', Report.PeriodStart)+' '+PrtStr.Values['E01']+' '+FormatDateTime('dddddd', Report.PeriodEnd)+'.', YPos)
        else
          PrintHead(PrintPreview, Company.Name, PrtStr.Values['A08']+' '+PrtStr.Values['E00']+' '+FormatDateTime('dddddd', Report.PeriodStart)+' '+PrtStr.Values['E01']+' '+FormatDateTime('dddddd', Report.PeriodEnd)+'.', YPos);
        Inc(YPos, LineHeight);
        PrintLine(PrintPreview, PrtStr.Values['E08'], aLeft, YPos, 0, 0);
        DrawLine(PrintPreview, YPos);
        Inc(YPos, LineHeight);
      end;
      if not Odd(i) then
      begin
        PrintText(PrintPreview, Report.Clients.Names[i], aLeft, YPos, 0.01, 0.39);
        PrintLine(PrintPreview, Report.Clients.Values[Report.Clients.Names[i]], aRight, YPos, 0.51, 0);
      end
      else
      begin
        Dec(YPos, LineHeight);
        PrintText(PrintPreview, Report.Clients.Names[i], aLeft, YPos, 0.51, 0);
        PrintLine(PrintPreview, Report.Clients.Values[Report.Clients.Names[i]], aRight, YPos, 0.01, 0);
      end;
    end;
    Inc(YPos, LineHeight);

    PrintLine(PrintPreview, PrtStr.Values['E09'], aLeft, YPos, 0, 0);
    DrawLine(PrintPreview, YPos);
    Inc(YPos, LineHeight);
    for i := 0 to Report.Products.Count-1 do
    begin               
      if YPos+LineHeight > PageHeight-LineHeight then
      begin                 
        PrintText(PrintPreview, PrtStr.Values['A19'], aRight, YPos, 0, 0);
        NewPage;
        YPos := PrinterPageBounds.Top+Margins.Top;
        if Report.ReportType = tSales then
          PrintHead(PrintPreview, Company.Name, PrtStr.Values['A07']+' '+PrtStr.Values['E00']+' '+FormatDateTime('dddddd', Report.PeriodStart)+' '+PrtStr.Values['E01']+' '+FormatDateTime('dddddd', Report.PeriodEnd)+'.', YPos)
        else
          PrintHead(PrintPreview, Company.Name, PrtStr.Values['A08']+' '+PrtStr.Values['E00']+' '+FormatDateTime('dddddd', Report.PeriodStart)+' '+PrtStr.Values['E01']+' '+FormatDateTime('dddddd', Report.PeriodEnd)+'.', YPos);
        Inc(YPos, LineHeight);
        PrintText(PrintPreview, PrtStr.Values['E09'], aLeft, YPos, 0, 0);
        DrawLine(PrintPreview, YPos);
        Inc(YPos, LineHeight);
      end;
      if not Odd(i) then
      begin
        PrintText(PrintPreview, Report.Products.Names[i], aLeft, YPos, 0.01, 0.39);
        PrintLine(PrintPreview, Report.Products.Values[Report.Products.Names[i]], aRight, YPos, 0.51, 0);
      end
      else
      begin
        Dec(YPos, LineHeight);
        PrintText(PrintPreview, Report.Products.Names[i], aLeft, YPos, 0.51, 0);
        PrintLine(PrintPreview, Report.Products.Values[Report.Products.Names[i]], aRight, YPos, 0.01, 0);
      end;
    end;
    EndDoc;
    Result := True;
  end
  except
    PrintPreview.Abort;
    Result := False;
  end;
end;
    
initialization
  PrtStr := TStringList.Create;
  PrtStr.Add('A00=Virtual Salesman 3');
  PrtStr.Add('A01=Company information.');
  PrtStr.Add('A02=List of employees.');
  PrtStr.Add('A03=List of clients.');
  PrtStr.Add('A04=List of suppliers.');
  PrtStr.Add('A05=Inventory');
  PrtStr.Add('A06=Group from the inventory');
  PrtStr.Add('A07=Sale summary');
  PrtStr.Add('A08=Order summary');
  PrtStr.Add('A19=Continued on next page...');

  PrtStr.Add('B00=Federal tax name:');
  PrtStr.Add('B01=Federal tax rate:');
  PrtStr.Add('B02=Federal tax registration number:');
  PrtStr.Add('B03=State tax name:');
  PrtStr.Add('B04=State tax rate:');
  PrtStr.Add('B05=State tax registration number:');
  PrtStr.Add('B06=Message to display in a quotation:');
  PrtStr.Add('B07=Message to display in an order:');
  PrtStr.Add('B08=Message to display in an invoice:');
  PrtStr.Add('B09=Inventories');

  PrtStr.Add('C00=Number');
  PrtStr.Add('C01=Name');
  PrtStr.Add('C02=Cost');
  PrtStr.Add('C03=Price');
  PrtStr.Add('C04=Unit price');
  PrtStr.Add('C05=Total price');
  PrtStr.Add('C06=Qty');
  PrtStr.Add('C07=Tax');
  PrtStr.Add('C08=Last update'); 
  PrtStr.Add('C09=Description');

  PrtStr.Add('D00=QUOTATION');
  PrtStr.Add('D01=ORDER');
  PrtStr.Add('D02=INVOICE');
  PrtStr.Add('D03=Salesman:');
  PrtStr.Add('D04=Payment: Cash');
  PrtStr.Add('D05=Payment: Debit');
  PrtStr.Add('D06=Payment: Credit');
  PrtStr.Add('D07=No.:');
  PrtStr.Add('D08=Exp.:');
  PrtStr.Add('D09=Client:');
  PrtStr.Add('D10=Recipient:');
  PrtStr.Add('D11=Sub-total:');
  PrtStr.Add('D12=Fees:');
  PrtStr.Add('D13=Total:');
  PrtStr.Add('D14=Deposit:');
  PrtStr.Add('D15=Balance:');

  PrtStr.Add('E00=from');
  PrtStr.Add('E01=to');
  PrtStr.Add('E02=Number of invoices:');
  PrtStr.Add('E03=Number of orders:');
  PrtStr.Add('E04=Sub-Totals:');
  PrtStr.Add('E05=Fees:');
  PrtStr.Add('E06=Totals:');
  PrtStr.Add('E07=Deposits:');
  PrtStr.Add('E08=Clients:');  
  PrtStr.Add('E09=Products:');

finalization
  PrtStr.Free;

end.
