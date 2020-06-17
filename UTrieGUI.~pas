unit UTrieGUI;

interface

uses
  UTrieNode, UTrieTree, Classes, SysUtils, Windows, Messages, Variants,
  Graphics, Controls, Forms, ComCtrls,  StdCtrls, Menus, Dialogs;

type
  TTrieGUI = class(TTrieTree)
  private
    FModified:boolean;
    FFileName:string;
    FTree:TTreeView;
  protected
    procedure SetModified(value: boolean);
  public
    constructor Create(tv: TTreeView);

    function LoadFromFile(aFileName:string):boolean;
    procedure SaveToFile(aFileName:string);
    procedure Clear; override;
    function Add(const wrd:string):boolean; override;
    function Delete(wrd:string):boolean; override;
    property Modified:boolean read FModified write SetModified;
    property FileName:string read FFileName;

  end;

implementation

constructor TTrieGUI.Create(tv: TTreeView);
begin
  inherited Create;
  FFileName:='';
  FModified:=false;
  FTree:=tv;
  FTree.Items.Clear;
end;


procedure TTrieGUI.SetModified(value: boolean);
begin
  FModified:= value;
  if value then
    PrintAll(FTree.Items);
end;


function TTrieGUI.LoadFromFile(aFileName:string):boolean;
begin
  Result:= inherited LoadFromFile(aFileName);
  FFileName:=aFilename;
  FModified:= false;
  PrintAll(FTree.Items);
end;

procedure TTrieGUI.SaveToFile(aFileName:string);
begin
  inherited SaveToFile(aFileName);
  FFileName:=aFileName;
  FModified:=false;
end;

procedure TTrieGUI.Clear;
begin
  if not IsEmpty then
    begin
      inherited ClearHelp;
      Modified:=true;
    end;
end;

function TTrieGUI.Add(const wrd:string):boolean;
begin
  Result:= inherited AddHelp(wrd);
  if Result then
    Modified:= true;
end;

function TTrieGUI.Delete(wrd:string):boolean;
begin
  Result:= inherited DeleteHelp(wrd);
  if Result then
    Modified:= true;
end;

end.
