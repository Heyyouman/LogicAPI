program LogicWorld_Votes;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  MyThread in 'MyThread.pas',
  Settings in 'Settings.pas' {FormSettings},
  Vcl.Themes,
  Vcl.Styles,
  ABOUT in 'ABOUT.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormSettings, FormSettings);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
