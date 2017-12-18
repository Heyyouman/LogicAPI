program LogicAPI;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  MyThread in 'MyThread.pas',
  Settings in 'Settings.pas' {FormSettings},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormSettings, FormSettings);
  Application.Run;
end.
