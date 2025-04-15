object DataModuleUnit: TDataModuleUnit
  Height = 250
  Width = 438
  PixelsPerInch = 120
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=takeout_admin'
      'Database=db_takeout'
      'Password=takeout_admin@123'
      'Port=26000'
      'Server=192.168.202.129'
      'DriverID=PG')
    LoginPrompt = False
    Left = 60
    Top = 30
  end
  object FDQueryLogin: TFDQuery
    Connection = FDConnection1
    Left = 200
    Top = 30
  end
  object FDQueryRegister: TFDQuery
    Connection = FDConnection1
    Left = 320
    Top = 30
  end
end
