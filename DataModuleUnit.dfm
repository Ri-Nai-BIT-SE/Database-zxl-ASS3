object DM: TDataModuleUnit
    OldCreateOrder = False
    Height = 200
    Width = 350
    object FDConnection1: TFDConnection
    Params.Strings = (
        'User_Name=takeout_admin'
        'Database=db_takeout'
        'Password=takeout_admin@123'
        'Port=26000'
        'Server=192.168.202.129'
        'DriverID=PG'
    )
    LoginPrompt = False
    Left = 48
    Top = 24
    end
    object FDQueryLogin: TFDQuery
    Connection = FDConnection1
    Left = 160
    Top = 24
    end
    object FDQueryRegister: TFDQuery
    Connection = FDConnection1
    Left = 256
    Top = 24
    end
end
