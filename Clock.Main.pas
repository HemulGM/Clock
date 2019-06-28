unit Clock.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Direct2D,
  D2D1, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    TimerFPS: TTimer;
    TimerRepaint: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerFPSTimer(Sender: TObject);
    procedure TimerRepaintTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  protected
    procedure CreateWnd; override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  private
    FCanvas: TDirect2DCanvas;
    FBuffer: TBitmap;
    FPSCounter: Integer;
    FFPS: Integer;
    FRect: TRect;
    FTime: TDateTime;
    FRotate, TempD: Word;
  public
    procedure DoDraw;
    property Canvas: TDirect2DCanvas read FCanvas;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.DateUtils;

{$R *.dfm}

procedure TfrmMain.CreateWnd;
begin
  inherited;
  FCanvas := TDirect2DCanvas.Create(Handle);
end;

procedure TfrmMain.WMPaint(var Message: TWMPaint);
var
  PaintStruct: TPaintStruct;
begin
  BeginPaint(Handle, PaintStruct);
  try
    FCanvas.BeginDraw;
    try
      Paint;
    finally
      FCanvas.EndDraw;
    end;
  finally
    EndPaint(Handle, PaintStruct);
  end;
end;

procedure TfrmMain.WMSize(var Message: TWMSize);
var
  D2Size: D2D_SIZE_U;
begin
  D2Size := D2D1SizeU(ClientWidth, ClientHeight);
  if Assigned(FCanvas) then
    ID2D1HwndRenderTarget(FCanvas.RenderTarget).Resize(D2Size);
  inherited;
end;

procedure TfrmMain.TimerFPSTimer(Sender: TObject);
begin
  FFPS := FPSCounter;
  FPSCounter := 0;
end;

procedure TfrmMain.TimerRepaintTimer(Sender: TObject);
begin
  DoDraw;
 //FRotate:=FRotate + 5;
 //if FRotate > 360 then FRotate:=1;
  TempD := TempD + 1;
  if TempD >= 30 then
    TempD := 1;
  {FTime := FTime + 1/24/60/60;
  FTime := FTime + 1/24/60;
  FTime := FTime + 1/24;
  FTime := FTime + 1;  }
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf24bit;
  FBuffer.Width := ClientWidth;
  FBuffer.Height := ClientHeight;
  FRect := ClientRect;
  FFPS := 0;
  FPSCounter := 0;
  FRotate := 0;
  TempD := 1;
  TimerRepaint.Enabled := True;
  FTime := Now;
end;

procedure TfrmMain.FormPaint(Sender: TObject);
begin
  DoDraw;
end;

function CreateRectFromPoint(Pt: TPoint; SX, SY: Integer): TRect;
begin
  Result.Left := Pt.X - SX div 2;
  Result.Top := Pt.Y - SY div 2;
  Result.Bottom := Pt.Y + SY div 2;
  Result.Right := Pt.X + SX div 2;
end;

procedure TfrmMain.DoDraw;
var
  Center, tmp: TPoint;
  i, R: Integer;
  Angle: Double;
  TmpRect: TRect;
  TmpStr: string;
  S, M, H, Ms: Word;
  Y, MM, D: Word;
  Stamp: Cardinal;
  LSize: TD2D1SizeF;
  Layer: ID2D1Layer;
  LParam: TD2D1LayerParameters;
begin
  with Canvas do
  begin
    FTime := Now;
    Stamp := GetTickCount;
    RenderTarget.BeginDraw;
   //RenderTarget.SetAntialiasMode(D2D1_ANTIALIAS_MODE_FORCE_DWORD);
    LSize.Width := ClientWidth;
    LSize.Height := ClientHeight;
    RenderTarget.SetTransform(TD2DMatrix3x2F.Identity());

    Brush.Color := clWhite;
    //Brush.Color := $00313131;
    Brush.Style := bsSolid;
    FillRect(ClientRect);
    Center := ClientRect.CenterPoint;
    Pen.Width := 2;
    Pen.Color := clGray;
    Brush.Style := bsClear;
    Ellipse(CreateRectFromPoint(Center, 230, 230));
    Ellipse(CreateRectFromPoint(Center, 200, 200));
    Brush.Color := clGray;

   //Дата
    DecodeDate(FTime, Y, MM, D);
    //360 / 60 = 6
    Font.Color := $004F4F4F;
    Font.Name := 'Segoe UI Script';
    Font.Style := [fsBold];
    Font.Size := 15;
    for i := 1 to 60 do
    begin
      Angle := 90 - i * 6;
      if i mod 5 = 0 then
      begin
        R := 77;
        tmp := Point(Round(Center.X + Cos(Angle / 180 * pi) * R), Round(Center.Y - Sin(Angle / 180 * pi) * R));
        TmpRect := CreateRectFromPoint(tmp, 30, 20);
        TmpStr := IntToStr(i div 5);
        TextRect(TmpRect, TmpStr, [tfCenter, tfVerticalCenter, tfSingleLine]);
        R := 90;
      end
      else
        R := 95;
      MoveTo(Round(Center.X + Cos(Angle / 180 * pi) * R), Round(Center.Y - Sin(Angle / 180 * pi) * R));
      R := 100;
      LineTo(Round(Center.X + Cos(Angle / 180 * pi) * R), Round(Center.Y - Sin(Angle / 180 * pi) * R));
    end;

    for i := 1 to 12 do
    begin
      Angle := 90 - i * 30;
      R := 110;
      MoveTo(Round(Center.X + Cos(Angle / 180 * pi) * R), Round(Center.Y - Sin(Angle / 180 * pi) * R));
      R := 120;
      LineTo(Round(Center.X + Cos(Angle / 180 * pi) * R), Round(Center.Y - Sin(Angle / 180 * pi) * R));

      RenderTarget.SetTransform(TD2DMatrix3x2F.Rotation(90 - Angle - 15, Center));
      Font.Color := clBlack;
      Font.Size := 10;
      TmpStr := FormatSettings.LongMonthNames[i];
      TmpRect := Rect(Center.X - 10 - 20, Center.Y - 155, Center.X - 10 + 20 + 20, Center.Y - 123 + 20);
      TextRect(TmpRect, TmpStr, [tfCenter, tfSingleLine, tfVerticalCenter]);
      RenderTarget.SetTransform(TD2DMatrix3x2F.Identity());
    end;

    Pen.Color := clMaroon;
    Pen.Width := 20;
    Angle := 90 - ((MM - 1) + D / 30) * 30;
    R := 107;
    H := Round(Center.X + Cos(Angle / 180 * pi) * R);
    S := Round(Center.Y - Sin(Angle / 180 * pi) * R);
    MoveTo(H, S);
    R := 120;
    H := Round(Center.X + Cos(Angle / 180 * pi) * R);
    S := Round(Center.Y - Sin(Angle / 180 * pi) * R);
    LineTo(H, S);
   //
    RenderTarget.SetTransform(TD2DMatrix3x2F.Rotation(90 - Angle, Center));
    Font.Color := clWhite;
    Font.Size := 10;
    TmpStr := IntToStr(D);
    TmpRect := Rect(Center.X - 10, Center.Y - 125, Center.X - 10 + 20, Center.Y - 123 + 20);
    TextRect(TmpRect, TmpStr, [tfCenter, tfSingleLine, tfVerticalCenter]);

    RenderTarget.SetTransform(TD2DMatrix3x2F.Identity());

    Font.Color := $00363636;
    Font.Size := 10;
    TmpStr := IntToStr(Y);
    TmpRect := Rect(Center.X - 30, Center.Y - 30, Center.X + 30, Center.Y - 10);
    TextRect(TmpRect, TmpStr, [tfCenter, tfSingleLine, tfVerticalCenter]);
   //

    RenderTarget.SetTransform(TD2DMatrix3x2F.Identity());
    DecodeTime(FTime, H, M, S, Ms);
    Brush.Style := bsSolid;
   //М.Секунды
    Pen.Width := 1;
    Pen.Color := clGray;
    Brush.Color := clWhite;
    tmp := Center;
    tmp.Y := tmp.Y + 40;
    Ellipse(CreateRectFromPoint(tmp, 40, 40));
    Angle := 90 - Ms * 0.36;
    MoveTo(tmp.X, tmp.Y);
    R := 20;
    Pen.Color := clGray;
    Brush.Color := clGray;
    LineTo(Round(tmp.X + Cos(Angle / 180 * pi) * R), Round(tmp.Y - Sin(Angle / 180 * pi) * R));
    Ellipse(CreateRectFromPoint(tmp, 6, 6));

   //Секунды
    Pen.Width := 1;
    Pen.Color := clMaroon;
    Brush.Color := clMaroon;
    Angle := 90 - (S + Ms / 1000) * 6;
    MoveTo(Center.X, Center.Y);
    R := 80;
    LineTo(Round(Center.X + Cos(Angle / 180 * pi) * R), Round(Center.Y - Sin(Angle / 180 * pi) * R));

    Angle := 90 - (S + Ms / 1000) * 6 + 180;
    MoveTo(Center.X, Center.Y);
    R := 15;
    LineTo(Round(Center.X + Cos(Angle / 180 * pi) * R), Round(Center.Y - Sin(Angle / 180 * pi) * R));

   //Минуты
    Pen.Width := 2;
    Pen.Color := $00363636;
    Brush.Color := $00363636;
    Angle := 90 - (M + S / 60) * 6;
    MoveTo(Center.X, Center.Y);
    R := 70;
    LineTo(Round(Center.X + Cos(Angle / 180 * pi) * R), Round(Center.Y - Sin(Angle / 180 * pi) * R));

   //Часы
    Pen.Width := 3;
    Pen.Color := $00363636;
    Brush.Color := $00363636;
    Angle := 90 - (H + M / 60) * 30;
    MoveTo(Center.X, Center.Y);
    R := 60;
    LineTo(Round(Center.X + Cos(Angle / 180 * pi) * R), Round(Center.Y - Sin(Angle / 180 * pi) * R));

    Pen.Color := clMaroon;
    Brush.Color := clMaroon;
    Ellipse(CreateRectFromPoint(Center, 10, 10));

    Brush.Style := bsClear;
   //Stamp:=GetTickCount-Stamp;
   //TextOut(10, 10, IntToStr(FFPS)+' '+INtToStr(Stamp));
    RenderTarget.EndDraw;
  end;
  FPSCounter := FPSCounter + 1;
end;

end.

