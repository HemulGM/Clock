object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 300
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object TimerFPS: TTimer
    OnTimer = TimerFPSTimer
    Left = 176
    Top = 152
  end
  object TimerRepaint: TTimer
    Enabled = False
    Interval = 15
    OnTimer = TimerRepaintTimer
    Left = 104
    Top = 112
  end
end
