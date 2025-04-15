object MerchantForm: TMerchantForm
  Left = 0
  Top = 0
  Caption = '商家管理系统'
  ClientHeight = 800
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 1000
    Height = 800
    ActivePage = TabAccount
    Align = alClient
    TabOrder = 0
    TabWidth = 180
    object TabAccount: TTabSheet
      Caption = '商家账户管理'
      OnShow = TabAccountShow
      object pnlMerchantInfo: TPanel
        Left = 0
        Top = 0
        Width = 992
        Height = 762
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblMerchantInfoTitle: TLabel
          Left = 10
          Top = 10
          Width = 200
          Height = 30
          Caption = '商家账户管理'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object gridMerchantInfo: TDBGrid
          Left = 10
          Top = 50
          Width = 972
          Height = 702
          DataSource = dsMerchantInfo
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack, dgEditing]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -18
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
    end
    object TabProduct: TTabSheet
      Caption = '商品管理'
      ImageIndex = 1
      OnShow = TabProductShow
      object pnlProductManagement: TPanel
        Left = 0
        Top = 0
        Width = 992
        Height = 762
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblProductManagementTitle: TLabel
          Left = 10
          Top = 10
          Width = 200
          Height = 30
          Caption = '商品管理'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblProductName: TLabel
          Left = 10
          Top = 50
          Width = 80
          Height = 25
          Caption = '商品名称'
        end
        object lblProductPrice: TLabel
          Left = 320
          Top = 50
          Width = 80
          Height = 25
          Caption = '商品价格'
        end
        object lblProductStock: TLabel
          Left = 520
          Top = 50
          Width = 80
          Height = 25
          Caption = '商品库存'
        end
        object lblProductDescription: TLabel
          Left = 10
          Top = 90
          Width = 100
          Height = 25
          Caption = '商品描述'
        end
        object edtProductName: TEdit
          Left = 100
          Top = 45
          Width = 200
          Height = 30
          TabOrder = 0
        end
        object edtProductPrice: TEdit
          Left = 400
          Top = 45
          Width = 100
          Height = 30
          TabOrder = 1
        end
        object edtProductStock: TEdit
          Left = 600
          Top = 45
          Width = 100
          Height = 30
          TabOrder = 2
        end
        object mmoProductDescription: TMemo
          Left = 10
          Top = 120
          Width = 400
          Height = 100
          TabOrder = 3
        end
        object btnAddProduct: TButton
          Left = 420
          Top = 120
          Width = 120
          Height = 34
          Caption = '添加商品'
          TabOrder = 4
          OnClick = btnAddProductClick
        end
        object btnUpdateProduct: TButton
          Left = 560
          Top = 120
          Width = 120
          Height = 34
          Caption = '更新商品'
          TabOrder = 5
          OnClick = btnUpdateProductClick
        end
        object btnDeleteProduct: TButton
          Left = 700
          Top = 120
          Width = 120
          Height = 34
          Caption = '删除商品'
          TabOrder = 6
          OnClick = btnDeleteProductClick
        end
        object gridProducts: TDBGrid
          Left = 10
          Top = 240
          Width = 972
          Height = 510
          DataSource = dsProducts
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 7
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -18
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnCellClick = gridProductsCellClick
        end
      end
    end
    object TabOrder: TTabSheet
      Caption = '订单管理'
      ImageIndex = 2
      OnShow = TabOrderShow
      object pnlOrders: TPanel
        Left = 0
        Top = 0
        Width = 992
        Height = 762
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblOrdersTitle: TLabel
          Left = 10
          Top = 10
          Width = 120
          Height = 30
          Caption = '订单管理'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object gridOrders: TDBGrid
          Left = 10
          Top = 50
          Width = 972
          Height = 660
          DataSource = dsOrders
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack, dgEditing]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -18
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnCellClick = gridOrdersCellClick
        end
        object btnConfirmOrder: TButton
          Left = 10
          Top = 720
          Width = 120
          Height = 34
          Caption = '确认订单'
          TabOrder = 1
          OnClick = btnConfirmOrderClick
        end
        object btnConfirmDelivery: TButton
          Left = 140
          Top = 720
          Width = 150
          Height = 34
          Caption = '确认发货'
          TabOrder = 2
          OnClick = btnConfirmDeliveryClick
        end
      end
    end
    object TabRevenue: TTabSheet
      Caption = '营业额统计'
      ImageIndex = 3
      OnShow = TabRevenueShow
      object pnlRevenue: TPanel
        Left = 0
        Top = 0
        Width = 992
        Height = 762
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblRevenueTitle: TLabel
          Left = 10
          Top = 10
          Width = 180
          Height = 30
          Caption = '商家总营业额'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -22
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblRevenueValue: TLabel
          Left = 200
          Top = 10
          Width = 100
          Height = 40
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -29
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
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
end
