program Clock;

uses
  Vcl.Forms,
  Clock.Main in 'Clock.Main.pas' {Form1},
  VCLDrawing in 'VCLDrawing.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
