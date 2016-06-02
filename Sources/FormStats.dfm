object frmStats: TfrmStats
  Left = 381
  Top = 54
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Statistics'
  ClientHeight = 209
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object stgStats: TStringGrid
    Left = 0
    Top = 0
    Width = 281
    Height = 177
    ColCount = 2
    DefaultColWidth = 140
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
    TabOrder = 0
    OnDrawCell = stgStatsDrawCell
    ColWidths = (
      200
      57)
  end
  object btnOk: TButton
    Left = 216
    Top = 184
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
