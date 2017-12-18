unit Settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, inifiles;

type
  TFormSettings = class(TForm)
    EditUpdRange: TEdit;
    LabelUpdRange: TLabel;
    ButtonConfirm: TButton;
    ButtonOk: TButton;
    LabelSeconds: TLabel;
    procedure ButtonOkClick(Sender: TObject);
    procedure EditUpdRangeChange(Sender: TObject);
    procedure ButtonConfirmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSettings: TFormSettings;
  UpdateRangeSec: Integer;
  UpdateRangeMSec: Integer;
  ini: TIniFile;

implementation

{$R *.dfm}


procedure TFormSettings.ButtonConfirmClick(Sender: TObject);
begin
  ini.WriteInteger('Update','RangeMSec',UpdateRangeSec);
  ButtonConfirm.Enabled:= False;
end;

procedure TFormSettings.ButtonOkClick(Sender: TObject);
begin
  FormSettings.Close;
end;

procedure TFormSettings.EditUpdRangeChange(Sender: TObject);
begin
  if 1 > StrToInt(EditUpdRange.Text) then begin
    ShowMessagePos('Число '+ EditUpdRange.Text +' меньше или равно нулю!', Self.Left, Self.Top);
    EditUpdRange.Text:= IntToStr(0);
  end;
  if 1 < StrToInt(EditUpdRange.Text) then begin
    UpdateRangeSec:= StrToInt(EditUpdRange.Text)*1000;
  end;
  ButtonConfirm.Enabled:= True;
end;

procedure TFormSettings.FormShow(Sender: TObject);
begin
  ini:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'settings.ini');
  UpdateRangeMSec:= ini.ReadInteger('Update','Range',30000);
  UpdateRangeSec:= ini.ReadInteger('Update','Range',30);
  EditUpdRange.Text:= IntToStr(UpdateRangeSec);
  ButtonConfirm.Enabled:= False;
end;


end.
