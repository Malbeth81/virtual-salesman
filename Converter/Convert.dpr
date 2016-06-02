program Convert;

uses
  Forms,
  FormConvert in 'FormConvert.pas' {frmDBTool},
  UnitConvertSupplier in 'UnitConvertSupplier.pas',
  UnitConvertClient in 'UnitConvertClient.pas',
  UnitConvertCompany in 'UnitConvertCompany.pas',
  UnitConvertEmployee in 'UnitConvertEmployee.pas',
  UnitConvertInventory in 'UnitConvertInventory.pas',
  UnitConvertOperation in 'UnitConvertOperation.pas',
  UnitConvertProduct in 'UnitConvertProduct.pas',
  UnitConvertGroup in 'UnitConvertGroup.pas',
  UnitConvertSelection in 'UnitConvertSelection.pas';

{$R *.res} 
{$R WinXP.res}

begin
  Application.Initialize;
  Application.Title := 'VV3 - Conversion de données';
  Application.CreateForm(TfrmDBTool, frmDBTool);
  Application.Run;
end.
