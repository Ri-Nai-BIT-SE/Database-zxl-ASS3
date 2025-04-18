object DataModuleUnit: TDataModuleUnit
  Height = 250
  Width = 438
  PixelsPerInch = 120
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=username'
      'Database=database'
      'Password=password'
      'Port=5432'
      'Server=localhost'
      'DriverID=PG')
    LoginPrompt = False
    Left = 60
    Top = 30
  end
end
