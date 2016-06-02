(* Vendeur Virtuel 3 ***********************************************)
(* Copyright (c)1998-2006 Marc-Andre Lamothe ***********************)
(* All rights reserved *********************************************)

unit FormAbout;

interface

uses
  Windows, Messages,  Graphics, Controls, Forms, ShellAPI, ExtCtrls, Classes,
  StdCtrls, UnitMessages;

type
  TfrmAbout = class(TForm)
    btnOk: TButton;
    imgLogo: TImage;
    lblVersion: TLabel;
    lblTitle: TLabel;
    lblWebsite: TLabel;
    lblCopyright: TLabel;
    Shape1: TShape;
    procedure lblWebsiteClick(Sender: TObject);
  public
    function Show(Version : String) : Boolean; reintroduce;
  end;

var
  frmAbout: TfrmAbout;

implementation

uses FormMain;

{$R *.dfm}

procedure TfrmAbout.lblWebsiteClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar(lblWebsite.Caption), nil, nil, SW_SHOW)
end;

function TfrmAbout.Show(Version : String) : Boolean;
begin
  lblVersion.Caption := Version;
  Result := (ShowModal = mrOk);
end;

end.
