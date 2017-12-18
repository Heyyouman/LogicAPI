unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.JSON, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.Grids, MMSystem, MyThread, Settings, inifiles;

//const  WM_AFTER_SHOW = WM_USER + 301;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Output: TMemo;
    StringGrid1: TStringGrid;
    ButtonSettings: TButton;
    procedure FormShow(Sender: TObject);
    procedure GetInfo;
    procedure SetGrid;
    procedure UpdateAmmount;
    procedure ButtonSettingsClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
   // procedure WmAfterShow(var Msg: TMessage); message WM_AFTER_SHOW;
  public
    CheckUpdate: TThread;
  end;

 { Thread = class(TThread)
  private
    { Private declarations }
  {protected
    procedure Execute; override;
    procedure Upd;
    procedure UpdInfo;
    procedure ShowCaptions;
  end;}

var
  Form1: TForm1;
  date: string;
  year: string;
  mounth: string;
  users: array of string;
  ammount: array of string;
  lenght: Integer;
  ammountSum: Integer;
  ammountSum_old: Integer;
  UpdateRangeMSec: Integer;
  ini: TIniFile;

implementation

{$R *.dfm}


procedure TForm1.UpdateAmmount;
begin
  GetInfo;
  SetGrid;
end;

procedure TForm1.ButtonSettingsClick(Sender: TObject);
begin
  FormSettings.ShowModal;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Form1.Width:=355;
  Form1.Height:=548;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  //UpdateAmmount;
  ini:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'settings.ini');
  UpdateRangeMSec:= ini.ReadInteger('Update','RangeMSec',30000);
  CheckUpdate:= Thread.Create(False);
  CheckUpdate.FreeOnTerminate:= True;
  CheckUpdate.Priority:= tpNormal;
end;

procedure TForm1.GetInfo;
var
  i: integer;
  str: WideString;
 // JSONobj: TJSONObject;
  JSONValue: TJSONValue;
begin
  date:= FormatDateTime('mm.yyyy',Now);
  str:= IdHTTP1.Get('https://logicworld.ru/launcher/tableTopVote.php?mode=api&date='+ date);
  //Delete(str,1,62);    Fixed by Yaroslavik
  str:= '{"items": '+ str +'}';
  //Output.Text:= str;
  JSONValue:=TJSONObject.ParseJSONValue(str);
  JSONValue:=(JSONValue as TJSONObject).Get('items').JsonValue;
  ammount:= nil;
  users:= nil;
  if (JSONValue is TJSONArray) then
    for i:=0 to (JSONValue as TJSONArray).Count-1 do
      begin
        lenght:= Length(users);
        SetLength(users, lenght+1);
        lenght:= Length(ammount);
        SetLength(ammount, lenght+1);
        users[i]:= ((JSONValue as TJSONArray).Items[i] as TJSONObject).Get('user').JSONValue.Value ;
        ammount[i]:= ((JSONValue as TJSONArray).Items[i] as TJSONObject).Get('ammount').JSONValue.Value ;
      //Output.Lines.Add(users[i] +'   '+ ammount[i]);
     end;
  ammountSum:= 0;
  for i:= Low(ammount) to High(ammount) do
    ammountSum:= StrToInt(ammount[i]) + ammountSum;

end;


procedure TForm1.SetGrid;
var i: integer;
begin
  StringGrid1.ColCount:= 2;
  StringGrid1.RowCount:= Length(users)+3;
  StringGrid1.Cells[0,0]:= 'Никнейм';
  StringGrid1.Cells[1,0]:= 'Количество голосов';
  for i:= 1 to Length(users) do begin
    StringGrid1.Cells[0,i]:= users[i-1];
  end;
  for i:= 1 to Length(ammount) do begin
    StringGrid1.Cells[1,i]:= ammount[i-1];
  end;
  StringGrid1.Cells[0, Length(ammount)+2]:= 'Итого:';
  StringGrid1.Cells[1, Length(ammount)+2]:= IntToStr(ammountSum);
end;


end.
