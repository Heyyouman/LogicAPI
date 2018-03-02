unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.JSON, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.Grids, MMSystem, MyThread, Settings, inifiles, Vcl.ComCtrls,
  Vcl.WinXPickers, Vcl.ToolWin, About;

//const  WM_AFTER_SHOW = WM_USER + 301;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Output: TMemo;
    MainGrid: TStringGrid;
    DatePicker1: TDatePicker;
    ToolBar: TToolBar;
    SettingsButton: TToolButton;
    AboutButton: TToolButton;
    UpadteButton: TToolButton;
    procedure FormShow(Sender: TObject);
    function GetInfo(date:string):string;
    procedure SetGrid;
    procedure UpdateAmmount;
    procedure FormResize(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
    procedure AboutButtonClick(Sender: TObject);
    procedure DatePicker1Change(Sender: TObject);
    procedure UpadteButtonClick(Sender: TObject);
  private
   // procedure WmAfterShow(var Msg: TMessage); message WM_AFTER_SHOW;
    SelfWidth: Integer;
    SelfHeight: Integer;
  public
    CheckUpdate: TThread;
  end;

var
  Form1: TForm1;
  CurrnetDate: string;
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

procedure TForm1.UpadteButtonClick(Sender: TObject);
begin
  GetInfo(CurrnetDate);
  SetGrid;
end;

procedure TForm1.UpdateAmmount;
begin
  GetInfo(CurrnetDate);
  SetGrid;
end;

procedure TForm1.SettingsButtonClick(Sender: TObject);
begin
   FormSettings.ShowModal;
end;

procedure TForm1.AboutButtonClick(Sender: TObject);
begin
  About.AboutBox.ShowModal;
end;

procedure TForm1.DatePicker1Change(Sender: TObject);
begin
  CurrnetDate:= FormatDateTime('mm.yyyy',DatePicker1.Date);
  GetInfo(CurrnetDate);
  SetGrid;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Form1.Width:=SelfWidth;
  Form1.Height:=SelfHeight;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  SelfWidth:= Self.Width;
  SelfHeight:= Self.Height;
  CurrnetDate:= FormatDateTime('mm.yyyy',Now);
  DatePicker1.Date:= StrToDate(FormatDateTime('dd.mm.yyyy',Now));
  //UpdateAmmount;
  ini:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'settings.ini');
  UpdateRangeMSec:= ini.ReadInteger('Update','RangeMSec',30000);
  CheckUpdate:= Thread.Create(False);
  CheckUpdate.FreeOnTerminate:= True;
  CheckUpdate.Priority:= tpNormal;
end;

function TForm1.GetInfo;
var
  i: integer;
  str: WideString;
 // JSONobj: TJSONObject;
  JSONValue: TJSONValue;
begin
  str:= IdHTTP1.Get('https://logicworld.ru/launcher/tableTopVote.php?mode=api&date='+ CurrnetDate);
  //Delete(str,1,62);    Fixed by Yaroslavik
  str:= '{"items": '+ str +'}';
  //Output.Text:= str;   Debug
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
      //Output.Lines.Add(users[i] +'   '+ ammount[i]);   Debug
     end;
  ammountSum:= 0;
  for i:= Low(ammount) to High(ammount) do
    ammountSum:= StrToInt(ammount[i]) + ammountSum;

end;


procedure TForm1.SetGrid;
var i: integer;
begin
  for i:= 1 to MainGrid.RowCount do begin    //  Очистка таблицы
    MainGrid.Cells[0,i]:= '';                //
    MainGrid.Cells[1,i]:= '';                //
  end;                                       //
  MainGrid.ColCount:= 2;
  MainGrid.RowCount:= Length(users)+3;
  MainGrid.Cells[0,0]:= 'Никнейм';
  MainGrid.Cells[1,0]:= 'Количество голосов';
  for i:= 1 to Length(users) do begin
    MainGrid.Cells[0,i]:= users[i-1];
  end;
  for i:= 1 to Length(ammount) do begin
    MainGrid.Cells[1,i]:= ammount[i-1];
  end;
  MainGrid.Cells[0, Length(ammount)+2]:= 'Итого:';
  MainGrid.Cells[1, Length(ammount)+2]:= IntToStr(ammountSum);
end;


end.
