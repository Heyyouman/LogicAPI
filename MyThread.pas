unit MyThread;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, MMSystem;

type
  Thread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Upd_ammount_old;
    procedure Update;
    procedure UpdateAmmount;
  end;

implementation

uses Main;

procedure Thread.Upd_ammount_old;
begin
  Main.ammountSum_old:= Main.ammountSum;
end;

procedure Thread.UpdateAmmount;
begin
  Form1.UpdateAmmount;
end;


procedure Thread.Update;
begin
  Form1.GetInfo;
  Form1.SetGrid;
end;

procedure Thread.Execute;
begin
  Synchronize(Update);
  Synchronize(Upd_ammount_old);
  repeat
    Sleep(30000);
    Synchronize(Update);
    if Main.ammountSum > Main.ammountSum_old then begin
      PlaySound('assets/synth.wav',0,SND_ASYNC);
      Synchronize(Update);
      Synchronize(Upd_ammount_old);
    end;
  until False;
end;

end.
