object AdminForm: TAdminForm
  Left = 0
  Top = 0
  Margins.Left = 6
  Margins.Top = 6
  Margins.Right = 6
  Margins.Bottom = 6
  Caption = 'AdminForm'
  ClientHeight = 933
  ClientWidth = 1246
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -25
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 200
  TextHeight = 35
  Visible = True
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=takeout_admin'
      'Database=db_takeout'
      'Password=admin@123'
      'Port=26000'
      'Server=192.168.202.129'
      'DriverID=PG')
    Left = 128
    Top = 104
  end
end
