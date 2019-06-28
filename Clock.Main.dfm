object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1063#1072#1089#1099
  ClientHeight = 310
  ClientWidth = 310
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object TimerFPS: TTimer
    OnTimer = TimerFPSTimer
    Left = 176
    Top = 104
  end
  object TimerRepaint: TTimer
    Enabled = False
    Interval = 15
    OnTimer = TimerRepaintTimer
    Left = 72
    Top = 96
  end
end
