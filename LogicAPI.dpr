program LogicAPI;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  MyThread in 'MyThread.pas',
  Settings in 'Settings.pas' {FormSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormSettings, FormSettings);
  Application.Run;
end.
