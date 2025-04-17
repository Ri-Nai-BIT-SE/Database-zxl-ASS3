object MerchantForm: TMerchantForm
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = #21830#23478#31649#29702#31995#32479
  ClientHeight = 900
  ClientWidth = 1515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -27
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 144
  TextHeight = 37
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 1515
    Height = 900
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ActivePage = TabAccount
    Align = alClient
    TabOrder = 0
    TabWidth = 270
    object TabAccount: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = #21830#23478#36134#25143#31649#29702
      OnShow = TabAccountShow
      object pnlMerchantInfo: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblMerchantInfoTitle: TLabel
          Left = 15
          Top = 15
          Width = 216
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #21830#23478#36134#25143#20449#24687
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblName: TLabel
          Left = 15
          Top = 90
          Width = 112
          Height = 37
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #21830#23478#21517#31216
        end
        object lblContact: TLabel
          Left = 15
          Top = 150
          Width = 112
          Height = 37
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #32852#31995#20449#24687
        end
        object lblAddress: TLabel
          Left = 15
          Top = 210
          Width = 112
          Height = 37
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #32463#33829#22320#22336
        end
        object edtName: TEdit
          Left = 180
          Top = 83
          Width = 450
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          TabOrder = 0
        end
        object edtContactInfo: TEdit
          Left = 180
          Top = 143
          Width = 450
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          TabOrder = 1
        end
        object edtBusinessAddress: TEdit
          Left = 180
          Top = 203
          Width = 750
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          TabOrder = 2
        end
        object btnUpdateMerchantInfo: TButton
          Left = 180
          Top = 270
          Width = 225
          Height = 51
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #26356#26032#20449#24687
          TabOrder = 3
          OnClick = btnUpdateMerchantInfoClick
        end
      end
    end
    object TabProduct: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = #21830#21697#31649#29702
      ImageIndex = 1
      OnShow = TabProductShow
      object pnlProductManagement: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 1511
        ExplicitHeight = 857
        object lblProductManagementTitle: TLabel
          Left = 15
          Top = 15
          Width = 144
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #21830#21697#31649#29702
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblProductName: TLabel
          Left = 15
          Top = 75
          Width = 112
          Height = 37
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #21830#21697#21517#31216
        end
        object lblProductPrice: TLabel
          Left = 480
          Top = 75
          Width = 112
          Height = 37
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #21830#21697#20215#26684
        end
        object lblProductStock: TLabel
          Left = 780
          Top = 75
          Width = 112
          Height = 37
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #21830#21697#24211#23384
        end
        object lblProductDescription: TLabel
          Left = 15
          Top = 135
          Width = 112
          Height = 37
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #21830#21697#25551#36848
        end
        object edtProductName: TEdit
          Left = 150
          Top = 68
          Width = 300
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          TabOrder = 0
        end
        object edtProductPrice: TEdit
          Left = 600
          Top = 68
          Width = 150
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          TabOrder = 1
        end
        object edtProductStock: TEdit
          Left = 900
          Top = 68
          Width = 150
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          TabOrder = 2
        end
        object mmoProductDescription: TMemo
          Left = 15
          Top = 180
          Width = 600
          Height = 150
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          TabOrder = 3
        end
        object btnAddProduct: TButton
          Left = 630
          Top = 180
          Width = 180
          Height = 51
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #28155#21152#21830#21697
          TabOrder = 4
          OnClick = btnAddProductClick
        end
        object btnUpdateProduct: TButton
          Left = 840
          Top = 180
          Width = 180
          Height = 51
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #26356#26032#21830#21697
          TabOrder = 5
          OnClick = btnUpdateProductClick
        end
        object btnDeleteProduct: TButton
          Left = 1050
          Top = 180
          Width = 180
          Height = 51
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #21024#38500#21830#21697
          TabOrder = 6
          OnClick = btnDeleteProductClick
        end
        object gridProducts: TDBGrid
          Left = 15
          Top = 360
          Width = 1458
          Height = 465
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          DataSource = dsProducts
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 7
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -27
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnCellClick = gridProductsCellClick
        end
      end
    end
    object TabOrder: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = #35746#21333#31649#29702
      ImageIndex = 2
      OnShow = TabOrderShow
      object pnlOrders: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblOrdersTitle: TLabel
          Left = 15
          Top = 15
          Width = 144
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #35746#21333#31649#29702
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object gridOrders: TDBGrid
          Left = 15
          Top = 75
          Width = 1458
          Height = 690
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          DataSource = dsOrders
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -27
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnCellClick = gridOrdersCellClick
        end
        object btnConfirmOrder: TButton
          Left = 15
          Top = 780
          Width = 180
          Height = 51
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #30830#35748#35746#21333
          TabOrder = 1
          OnClick = btnConfirmOrderClick
        end
        object btnConfirmDelivery: TButton
          Left = 210
          Top = 780
          Width = 225
          Height = 51
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #30830#35748#21457#36135
          TabOrder = 2
          OnClick = btnConfirmDeliveryClick
        end
      end
    end
    object TabRevenue: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = #33829#19994#39069#32479#35745
      ImageIndex = 3
      OnShow = TabRevenueShow
      object pnlRevenue: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 1511
        ExplicitHeight = 857
        object gboxDateRange: TGroupBox
          Left = 15
          Top = 75
          Width = 1200
          Height = 135
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #26085#26399#33539#22260
          TabOrder = 0
          object lblStartDate: TLabel
            Left = 15
            Top = 60
            Width = 112
            Height = 37
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Caption = #24320#22987#26085#26399
          end
          object lblEndDate: TLabel
            Left = 480
            Top = 60
            Width = 112
            Height = 37
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Caption = #32467#26463#26085#26399
          end
          object dtpStartDate: TDateTimePicker
            Left = 135
            Top = 52
            Width = 320
            Height = 45
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Date = 45000.000000000000000000
            Time = 45000.000000000000000000
            TabOrder = 0
          end
          object dtpEndDate: TDateTimePicker
            Left = 600
            Top = 52
            Width = 320
            Height = 45
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Date = 45000.000000000000000000
            Time = 45000.000000000000000000
            TabOrder = 1
          end
          object btnGenerateStats: TButton
            Left = 945
            Top = 52
            Width = 230
            Height = 45
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Caption = #29983#25104#32479#35745
            TabOrder = 2
            OnClick = btnGenerateStatsClick
          end
        end
        object pnlRevenueStats: TPanel
          Left = 15
          Top = 225
          Width = 480
          Height = 240
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 1
          object lblTotalRevenue: TLabel
            Left = 15
            Top = 15
            Width = 396
            Height = 60
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Alignment = taCenter
            Caption = #24635#25910#30410
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -43
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblRevenueValue: TLabel
            Left = 15
            Top = 120
            Width = 436
            Height = 75
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Alignment = taCenter
            AutoSize = False
            Caption = '0.00 '#20803
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -50
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object pnlOrderStats: TPanel
          Left = 510
          Top = 225
          Width = 480
          Height = 240
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          BevelKind = bkFlat
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 2
          object lblTotalOrders: TLabel
            Left = 15
            Top = 15
            Width = 396
            Height = 60
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Alignment = taCenter
            Caption = #24635#35746#21333#25968
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -43
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblOrdersValue: TLabel
            Left = 15
            Top = 120
            Width = 436
            Height = 75
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Alignment = taCenter
            AutoSize = False
            Caption = '0 '#21333
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -50
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
    end
  end
  object dsMerchantInfo: TDataSource
    DataSet = qryMerchantInfo
    Left = 800
    Top = 100
  end
  object qryMerchantInfo: TFDQuery
    Left = 800
    Top = 160
  end
  object dsOrders: TDataSource
    DataSet = qryOrders
    Left = 700
    Top = 100
  end
  object qryOrders: TFDQuery
    Left = 700
    Top = 160
  end
  object dsProducts: TDataSource
    DataSet = qryProducts
    Left = 800
    Top = 220
  end
  object qryProducts: TFDQuery
    Left = 700
    Top = 220
  end
  object qryAddProduct: TFDQuery
    Left = 600
    Top = 100
  end
  object qryUpdateProduct: TFDQuery
    Left = 600
    Top = 160
  end
  object qryDeleteProduct: TFDQuery
    Left = 600
    Top = 220
  end
  object qryConfirmOrder: TFDQuery
    Left = 500
    Top = 100
  end
  object qryConfirmDelivery: TFDQuery
    Left = 500
    Top = 160
  end
  object qryRevenue: TFDQuery
    Left = 500
    Top = 220
  end
  object qryUpdateMerchantInfo: TFDQuery
    Left = 800
    Top = 40
  end
end
