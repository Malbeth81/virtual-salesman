program Web;

uses
  Classes, SysUtils, HtmlParser, StrUtils2,
  UnitInventory in 'UnitInventory.pas',
  UnitGroup in 'UnitGroup.pas',
  UnitProduct in 'UnitProduct.pas';

{$APPTYPE CONSOLE}
{$E cgi}           
const
  ProgramName = 'Vendeur Virtuel 3 : Module web v1.3' ;

  procedure FileError(FileName : String) ;
  begin
    Write(Output, HtmlText('<HTML><HEAD><TITLE>Modèle introuvable</TITLE></HEAD>')) ;
    Write(Output, HtmlText('<BODY><H1>Modèle introuvable!</H1>')) ;
    Write(Output, HtmlText('<P>Le programme cgi n''a pus trouver le modèle demander : ' + FileName + '<BR>Contacter un technicien ou un administrateur pour plus d''information.</P>')) ;
    Write(Output, HtmlText('<HR><I>' + ProgramName + '</I></BODY></HTML>')) ;
  end ;

  procedure TagInventory(HTMLTag : THTMLTag ; var Inventory : TInventory) ;
  var
    Param : String ;
  begin
    if HTMLTag.ParamExists('Name') then
    begin
      Param := HTMLTag.GetParamValue('Name') ;
      if ExtractFileExt(Param) = '' then
        Param := ChangeFileExt(Param, '.v3i') ;
      Inventory.Free ;
      Inventory := TInventory.Create ;
      if Inventory.LoadFromFile(Param) <> 00 then
      begin
        Write(Output, HtmlText('<I>L''inventaire <B>' + Param + '</B> ne peut &ecirc;tre lus, le fichier est introuvable ou corumpu.</I>')) ;
        Inventory.Free ;
        Inventory := nil ;
      end ;
    end ;
    if HTMLTag.ParamExists('Value') then
    begin
      if Inventory <> nil then
      begin
        Param := HTMLTag.GetParamValue('Value') ;
        if SameText(Param, 'Date') then
          Write(Output, HtmlText(FormatDateTime('dddddd', Inventory.Date))) ;
        if SameText(Param, 'Description') then
          Write(Output, HtmlText(Inventory.Description)) ;
        if SameText(Param, 'GroupCount') then
          Write(Output, HtmlText(IntToStr(Inventory.Groups.Size))) ;
      end
      else   
        Write(Output, HtmlText('<I>Aucun inventaire n''est ouvert.</I>')) ;
    end ;
  end ;

  procedure TagEndInventory(HTMLTag : THTMLTag ; var Inventory : TInventory) ;
  begin
    Inventory.Free ;
    Inventory := nil ;
  end ;

  procedure TagGroup(HTMLTag : THTMLTag ; Inventory : TInventory) ;
  var
    Param : String ;
    CurGroup : PGroup ;
  begin
    if HTMLTag.ParamExists('Code') then
    begin
      if Inventory <> nil then
      begin
        CurGroup := Inventory.Groups.Get(HTMLTag.GetParamValue('Code')) ;
        if HTMLTag.ParamExists('Value') and (CurGroup <> nil) then
        begin
          Param := HTMLTag.GetParamValue('Value') ;
          if SameText(Param, 'Name') then
            Write(Output, HtmlText(CurGroup.Name)) ;
          if SameText(Param, 'ProductCount') then
            Write(Output, HtmlText(IntToStr(CurGroup.Products.Size))) ;
        end
        else
          Write(Output, HtmlText('<I>Le groupe <B>' + HTMLTag.GetParamValue('Code') + '</B> n''existe pas.</I>')) ;
      end
      else
        Write(Output, HtmlText('<I>Aucun inventaire n''est ouvert.</I>')) ;
    end ;
  end ;

  procedure TagProduct(HTMLTag : THTMLTag ; Inventory : TInventory) ;
  var
    Param : String ;
    CurGroup : PGroup ;
    CurProduct : PProduct ;
  begin
    if HTMLTag.ParamExists('Group') and HTMLTag.ParamExists('Number') then
    begin
      if Inventory <> nil then
      begin
        CurGroup := Inventory.Groups.Get(HTMLTag.GetParamValue('Group')) ;
        if CurGroup <> nil then
        begin
          CurProduct := CurGroup.Products.Get(HTMLTag.GetParamValue('Number')) ;
          if CurProduct <> nil then
          begin
            if HTMLTag.ParamExists('Value') then
            begin
              Param := HTMLTag.GetParamValue('Value') ;
              if SameText(Param, 'Name') then
                Write(Output, HtmlText(CurProduct.Name)) ;
              if SameText(Param, 'WebAdress') then
                Write(Output, HtmlText(CurProduct.Web)) ;
              if SameText(Param, 'Price') then
                Write(Output, HtmlText(FormatFloat('0.00', CurProduct.Price))) ;
              if SameText(Param, 'Quantity') then
                Write(Output, HtmlText(IntToStr(CurProduct.Quantity))) ;
              if SameText(Param, 'Taxed') and CurProduct.Taxed then
                Write(Output, HtmlText('T')) ;
            end ;
          end
          else
            Write(Output, HtmlText('<I>Le produit <B>' + HTMLTag.GetParamValue('Number') + '</B> n''existe pas.</I>')) ;
        end
        else
          Write(Output, HtmlText('<I>Le groupe <B>' + HTMLTag.GetParamValue('Code') + '</B> n''existe pas.</I>')) ;
      end
      else
        Write(Output, HtmlText('<I>Aucun inventaire n''est ouvert.</I>')) ;
    end ;
  end ;

  procedure TagTable(HTMLTag : THTMLTag ; Inventory : TInventory) ;  
  var
    HTMLParam : THTMLParam ;
    CurGroup : PGroup ;
    CurProduct : PProduct ;
    i : Integer ;
  begin
    { Write the html tag }
    Write(Output, HtmlText('<' + HTMLTag.Name)) ;
    if HTMLTag.Params <> nil then
      for i := 0 to HTMLTag.Params.Count-1 do
      begin
        HTMLParam := HTMLTag.Params[i] ;
        if (HTMLParam.Key <> 'Value') and (HTMLParam.Key <> 'Group') then
          Write(Output, HtmlText(' ' + HTMLParam.Key + '="' + HTMLParam.Value + '"')) ;
      end ;
    Writeln(Output, HtmlText('>')) ;

    { Generates the table }
    if HTMLTag.ParamExists('Value') then
    begin
      if Inventory <> nil then
      begin
        if HTMLTag.GetParamValue('Value') = 'Groups' then
        begin
          Writeln(Output, HtmlText('<tr><th colspan="2">' + Inventory.Name + '</th></td>')) ;
          Writeln(Output, HtmlText('<tr><th width="25%">Code</th><th>Nom</th></tr>')) ;
          CurGroup := Inventory.Groups.First ;
          while CurGroup <> nil do
          begin
            Writeln(Output, HtmlText('<tr><td>' + CurGroup.Code + '</td><td>' + CurGroup.Name + '</td></tr>')) ;
            CurGroup := CurGroup.Next ;
          end ;
        end
        else if HTMLTag.GetParamValue('Value') = 'Products' then
        begin
          CurGroup := Inventory.Groups.First ;
          while CurGroup <> nil do
          begin
            if not HTMLTag.ParamExists('Group') or SameText(HTMLTag.GetParamValue('Group'), CurGroup.Code) then
            begin
              Writeln(Output, HtmlText('<tr><th colspan="5">' + CurGroup.Name + '</th></tr>')) ;
              Writeln(Output, HtmlText('<tr><th width="15%">Numéro</th><th>Nom</th><th width="10%">Qté</th><th width="20%">Prix</th><th width="2%">Taxe</th></tr>')) ;

              CurProduct := CurGroup.Products.First ;
              while CurProduct <> nil do
              begin
                Write(Output, HtmlText('<tr><td>' + CurProduct.Code + '</td>')) ;
                if CurProduct.Web <> '' then
                  Write(Output, HtmlText('<td><a href="' + CurProduct.Web + '">' + CurProduct.Name + '</a></td>'))
                else
                  Write(Output, HtmlText('<td>' + CurProduct.Name + '</td>')) ;
                Write(Output, HtmlText('<td align="center">' + IntToStr(CurProduct.Quantity) + '</td><td align="right">')) ;
                Write(Output, HtmlText(FormatFloat('0.00 $', CurProduct.Price) + '</td><td align="center">')) ;
                case CurProduct.Taxed of
                  True : Write(Output, HtmlText('T')) ;
                  False : Write(Output, HtmlText(' ')) ;
                end ;
                Writeln(Output, HtmlText('</TD></TR>')) ;   
                CurProduct := CurProduct.Next ;
              end ;
            end ;
            CurGroup := CurGroup.Next ;
          end ;
        end ;
      end
      else
        Write(Output, HtmlText('<I>Aucun inventaire n''est ouvert</I>')) ;
    end ;
    Writeln(Output, HtmlText('</table>')) ;
  end ;
  
var
  Parameters,
  Param : String ;
  Length : Integer ;
  HTML : THTMLParser ;
  HTMLTag : THTMLTag ;
  HTMLParam : THTMLParam ;
  Index : Integer ;
  CurItem : TObject ;
  Inventory : TInventory ;
  i : Integer ;

begin
  Inventory := nil ;
  Write(Output, HtmlText('Content-type: text/html'+#13#10#13#10)) ;

  { Retreive the parameters }
  if ParamCount > 0 then
    Parameters := ParamStr(1)
  else if SameText(GetEnvironmentVariable('REQUEST_METHOD'), 'Post') then
  begin
    Length := StrToInt(GetEnvironmentVariable('CONTENT_LENGTH')) ;
    if Length > 0 then
    begin
      SetLength(Parameters, Length) ;
      for Index := 1 to Length do
        Read(Parameters[Index]) ;
    end ;
  end
  else
    Parameters := GetEnvironmentVariable('QUERY_STRING') ;

  { Process the parameters }
  Param := ParamValue(Parameters, 'File', '&') ;
  if ExtractFileExt(Param) = '' then
    Param := ChangeFileExt(Param, '.html') ;
  if not FileExists(Param) then
    FileError(Param) { The parameter is not a valid filename }
  else
  begin
    HTML := THTMLParser.Create ;
    HTML.Memory.LoadFromFile(Param) ;
    HTML.Execute ;
    for Index := 0 to HTML.Parsed.Count-1 do
    begin
      CurItem := HTML.Parsed[Index] ;
      if CurItem.ClassType = THTMLTag then
      begin
        HTMLTag := THTMLTag(CurItem) ;
        if HTMLTag.Name = 'Inventory' then
          TagInventory(HTMLTag, Inventory)
        else if HTMLTag.Name = '/Inventory' then
          TagEndInventory(HTMLTag, Inventory)
        else if HTMLTag.Name = 'Group' then
          TagGroup(HTMLTag, Inventory)
        else if HTMLTag.Name = 'Product' then
          TagProduct(HTMLTag, Inventory)
        else if HTMLTag.Name = 'Table' then
          TagTable(HTMLTag, Inventory)
        else
        begin
          Write(Output, HtmlText('<' + HTMLTag.Name)) ;
          if HTMLTag.Params <> nil then
            for i := 0 to HTMLTag.Params.Count-1 do
            begin
              HTMLParam := HTMLTag.Params[i] ;
              Write(Output, HtmlText(' ' + HTMLParam.Key + '="' + HTMLParam.Value + '"')) ;
            end ;
          Write(Output, HtmlText('>')) ;
        end ;
      end
      else if CurItem.ClassType = THTMLText then
        Write(Output, HtmlText(THTMLText(CurItem).Text))
      else if CurItem.ClassType = THTMLComment then
        Write(Output, HtmlText('<!--' + THTMLComment(CurItem).Comment + '-->'))
      else if CurItem.ClassType = THTMLServerScript then
        Write(Output, HtmlText('<%' + THTMLServerScript(CurItem).Script + '%>')) ;
    end ;
  end ;
end.
