unit UTrieNode;

interface

uses
  Classes, SysUtils, Windows, Messages, Variants, Graphics, Controls,
  Forms, ComCtrls,  StdCtrls, Menus, Dialogs, StrUtils;

const
  LowCh = 'a';
  HighCh = 'z';

type
  TIndex = LowCh..HighCh;

  TNode = class
  private
    FCount: integer;
    FNext: array[TIndex] of TNode;
  protected
    // Возвращает узел по индексу ch
    function GetNext(ch: TIndex): TNode;
    // Устанавливает узел value по индексу ch
    procedure SetNext(ch: TIndex; value: TNode);
  public
    // Конструктор узла
    constructor Create;
    // Деструктор узла
    destructor Destroy; override;

    // Проверка узла на пустоту
    function isEmpty:boolean;
    // Провекра символа на корректность
    function IsCorrectChar(ch: char): boolean;
    // Добавление слова
    function AddWord(var wrd: string; i: integer):boolean;
    // Поиск слова
    function FindWord(var wrd: string; i: integer): boolean;
    // Удаление слова
    function DelWord(var wrd: string; i: integer): boolean;
    // Вывод всех слов в мемо
    procedure PrintAll(wrd:string; items:TTreeNodes);

    procedure PrintAllString(wrd:string; strings:TStrings);

    // Свойство для поля FPoint
    property Count: integer read FCount write FCount;
    // Свойство для поля Fnext
    property Next[index: TIndex]: TNode read GetNext write SetNext;
  end;

implementation

// Возвращает узел по индексу ch
function TNode.GetNext(ch: TIndex): TNode;
begin
  result:= FNext[ch];
end;

// Устанавливает узел value по индексу ch
procedure TNode.SetNext(ch: TIndex; value: TNode);
begin
  if FNext[ch] <> value then
    begin
      FreeAndNil(FNext[ch]);
      FNext[ch]:= value;
    end;
end;

// Проверка узла на пустоту
function TNode.isEmpty:boolean;
var
  ch: TIndex;
begin
  ch:= LowCh;
  Result:= (FCount = 0) and (FNext[ch] = nil);
  if Result then
    repeat
      inc(ch);
      Result:= FNext[ch] = nil;
    until (ch = HighCh) or not Result;
end;

// Конструктор узла
constructor TNode.Create;
var
  ch: TIndex;
begin
  FCount:= 0;
  for ch:= LowCh to HighCh do
    FNext[ch]:= nil;
end;

// Деструктор узла
destructor TNode.Destroy;
var
  ch: TIndex;
begin
  for ch:= LowCh to HighCh do
    if FNext[ch] <> nil then
      FNext[ch].Destroy;
    inherited;
end;

// Провекра символа на корректность
function TNode.IsCorrectChar(ch: char): boolean;
begin
  result:= (ch >= LowCh) and (ch <= HighCh);
end;

// Добавление слова
function TNode.AddWord(var wrd: string; i: integer):boolean;
begin
  if i > length(wrd) then
    begin
      inc(FCount);
      result:= true;
    end
  else
    if not IsCorrectChar(wrd[i]) then
      result:= false
    else
      begin
        if FNext[wrd[i]] = nil then
          FNext[wrd[i]]:=TNode.Create;
        //Рекурсия
        result:= FNext[wrd[i]].AddWord(wrd, i+1);

        if not result and FNext[wrd[i]].isEmpty then
          FreeAndNil(FNext[wrd[i]]);
      end;
end;

// Поиск слова
function TNode.FindWord(var wrd: string; i: integer): boolean;
begin
  if i > length(wrd) then
    result:= FCount > 0
  else
    result:= IsCorrectChar(wrd[i]) and (FNext[wrd[i]] <> nil) and FNext[wrd[i]].FindWord(wrd, i+1);
end;

// Удаление слова
function TNode.DelWord(var wrd: string; i: integer): boolean;
begin
  if i > length(wrd) then
    begin
      if (FCount > 0) then
        begin
          result:= true;
          dec(FCount);
        end;
    end
  else
    if not IsCorrectChar(wrd[i]) or (FNext[wrd[i]] = nil) then
      result:= false
    else
      begin
        result:= FNext[wrd[i]].DelWord(wrd, i+1);
        if result and FNext[wrd[i]].IsEmpty then
          FreeAndNil(FNext[wrd[i]]);
      end;
end;

procedure AddNode(wrd: string; count:integer; nodes:TTreeNodes);
var
  i, j: integer;
  OK: boolean;
  node: TTreeNode;
begin
  node:= nil;
  for i:=1 to Length(wrd) do
    begin
      j:=0;
      OK:= false;
      if node = nil then
        while (j <= nodes.Count - 1) and (node = nil) do
          begin
            if (wrd[i] = nodes[j].text[1]) and (nodes[j].Level = 0) then
              begin
                node:= nodes[j];
                OK:= true;
              end
            else
              inc(j);
          end
      else
        while (j <= node.Count - 1) and not OK do
          begin
            if (node.Item[j].text[1] = wrd[i]) then
              begin
                OK:= true;
                node:= node.Item[j];
              end
            else
              inc(j);
          end;
      if (node = nil) or not OK then
        node:= nodes.AddChild(node, wrd[i]);
      if i = Length(wrd) then
        node.Text:= wrd[i] + '[' + IntToStr(count) + ']';
    end;
end;


//Рекурсивная функция принта всех слов от заданного звена
procedure TNode.PrintAll(wrd:string; items:TTreeNodes);
var
  ch:Tindex;
begin
  if FCount > 0 then
    AddNode(wrd, FCount, items);
  for ch:= lowCh to HighCh do
    if FNext[ch] <> nil then
      begin
        wrd:=wrd+ch;
        FNext[ch].PrintAll(wrd, items);
        SetLength(wrd,length(wrd)-1);
      end;
end;

procedure TNode.PrintAllString(wrd:string; strings:TStrings);
var
  ch:Tindex;
  i:integer;
begin
  for i:=1 to count do
    strings.add(wrd);
  for ch:= lowCh to HighCh do
    if FNext[ch] <> nil then
      begin
        wrd:=wrd+ch;
        FNext[ch].PrintAllString(wrd, strings);
        SetLength(wrd,length(wrd)-1);
      end;
end;


end.

