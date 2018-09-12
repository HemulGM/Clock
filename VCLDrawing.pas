unit VCLDrawing;

interface

uses
  System.Classes;

type
  TThreadProc = class;
  TThProc = procedure(Thread:TThreadProc) of object;

  TThreadProc = class(TThread)
   private
    FProc:TThProc;
    FStop:Boolean;
    FStopped:Boolean;
    FWait:Boolean;
   protected
    procedure Execute; override;
   public
    procedure Stop;
    procedure Sync(AMethod: TThreadMethod);
    property Proc:TThProc read FProc write FProc;
    property Stopping:Boolean read FStop write FStop;
    property Stopped:Boolean read FStopped;
    property Wait:Boolean read FWait write FWait;
    property Terminated;
    constructor Create(CreateSuspended: Boolean); overload;
  end;

implementation


{ TThreadProc }

procedure TThreadProc.Stop;
begin
 FStop:=True;
end;

procedure TThreadProc.Sync(AMethod: TThreadMethod);
begin
 Synchronize(AMethod);
end;

constructor TThreadProc.Create(CreateSuspended: Boolean);
begin
 inherited Create(CreateSuspended);
 FStop:=False;
 FStopped:=True;
end;

procedure TThreadProc.Execute;
begin
 FStopped:=False;
 FStop:=False;
 if Assigned(FProc) then FProc(Self);
 FStopped:=True;
end;

end.
