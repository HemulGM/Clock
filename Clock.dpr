program Clock;

uses
  Vcl.Forms,
  Clock.Main in 'Clock.Main.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
