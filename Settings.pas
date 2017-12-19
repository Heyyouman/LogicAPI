unit Settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, inifiles,
  MyThread;

type
  TFormSettings = class(TForm)
    EditUpdRange: TEdit;
    LabelUpdRange: TLabel;
    ButtonConfirm: TButton;
    ButtonOk: TButton;
    LabelSeconds: TLabel;
    ButtonExit: TButton;
    procedure ButtonOkClick(Sender: TObject);
    procedure EditUpdRangeChange(Sender: TObject);
    procedure ButtonConfirmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure ReloadUpdator;
    procedure FormResize(Sender: TObject);
  private
    SelfWidth: Integer;
    SelfHeight: Integer;
  public
  end;

var
  FormSettings: TFormSettings;
  UpdateRangeSec: Integer;
  UpdateRangeMSec: Integer;
  ini: TIniFile;

implementation

{$R *.dfm}

uses Main;

procedure TFormSettings.ReloadUpdator;
begin
  Main.Form1.CheckUpdate.Destroy;
  Main.Form1.CheckUpdate:= Thread.Create(False);
  Main.Form1.CheckUpdate.FreeOnTerminate:= True;
  Main.Form1.CheckUpdate.Priority:= tpNormal;
end;

procedure TFormSettings.ButtonConfirmClick(Sender: TObject);
begin
  ini.WriteInteger('Update','RangeMSec',UpdateRangeMSec);
  ini.WriteInteger('Update','RangeSec',UpdateRangeSec);
  ButtonConfirm.Enabled:= False;
end;

procedure TFormSettings.ButtonExitClick(Sender: TObject);
begin
  FormSettings.Close;
end;

procedure TFormSettings.ButtonOkClick(Sender: TObject);
begin
  ini.WriteInteger('Update','RangeMSec',UpdateRangeMSec);
  ini.WriteInteger('Update','RangeSec',UpdateRangeSec);
  ButtonConfirm.Enabled:= False;
  FormSettings.Close;
end;

procedure TFormSettings.EditUpdRangeChange(Sender: TObject);
begin
  if 1 > StrToInt(EditUpdRange.Text) then begin
    ShowMessagePos('Число '+ EditUpdRange.Text +' меньше или равно нулю!', Self.Left, Self.Top);
    EditUpdRange.Text:= IntToStr(0);
  end;
  if 1 < StrToInt(EditUpdRange.Text) then begin
    UpdateRangeSec:= StrToInt(EditUpdRange.Text);
    UpdateRangeMSec:= StrToInt(EditUpdRange.Text)*1000;
  end;
  ButtonConfirm.Enabled:= True;
end;

procedure TFormSettings.FormResize(Sender: TObject);
begin
  Self.Width:= SelfWidth;
  Self.Height:= SelfHeight;
end;

procedure TFormSettings.FormShow(Sender: TObject);
begin
  Self.Top:= Form1.Top + ( Form1.Width div 2 );
  Self.Left:= Form1.Left;
  SelfWidth:= Self.Width;
  SelfHeight:= Self.Height;
  ini:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'settings.ini');
  UpdateRangeMSec:= ini.ReadInteger('Update','RangeMSec',30000);
  UpdateRangeSec:=  ini.ReadInteger('Update','RangeSec',30);
  EditUpdRange.Text:= IntToStr(UpdateRangeSec);
  ButtonConfirm.Enabled:= False;
end;


end.
