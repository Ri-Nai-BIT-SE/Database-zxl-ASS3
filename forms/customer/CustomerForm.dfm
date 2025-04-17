object CustomerForm: TCustomerForm
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = #28040#36153#32773#30028#38754
  ClientHeight = 900
  ClientWidth = 1515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -27
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  Visible = True
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
      Caption = #24080#25143#31649#29702
      OnShow = TabAccountShow
      object pnlAccountInfo: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblAccountTitle: TLabel
          Left = 15
          Top = 15
          Width = 252
          Height = 45
          Caption = #28040#36153#32773#20010#20154#20449#24687
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
          Caption = #29992#25143#21517#31216
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblContact: TLabel
          Left = 15
          Top = 150
          Width = 112
          Height = 37
          Caption = #32852#31995#20449#24687
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblAddress: TLabel
          Left = 15
          Top = 210
          Width = 112
          Height = 37
          Caption = #25910#36135#22320#22336
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblBalance: TLabel
          Left = 15
          Top = 270
          Width = 196
          Height = 37
          Caption = #38065#21253#24403#21069#20313#39069#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblBalanceValue: TLabel
          Left = 240
          Top = 270
          Width = 91
          Height = 37
          Caption = '0.00 '#20803
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edtName: TEdit
          Left = 180
          Top = 83
          Width = 450
          Height = 45
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object edtContactInfo: TEdit
          Left = 180
          Top = 143
          Width = 450
          Height = 45
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object edtAddress: TEdit
          Left = 180
          Top = 203
          Width = 750
          Height = 45
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object btnUpdateInfo: TButton
          Left = 180
          Top = 330
          Width = 225
          Height = 51
          Caption = #26356#26032#20449#24687
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btnUpdateInfoClick
        end
        object gboxRecharge: TGroupBox
          Left = 15
          Top = 400
          Width = 750
          Height = 200
          Caption = #38065#21253#20805#20540
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          object lblRechargeAmount: TLabel
            Left = 20
            Top = 60
            Width = 112
            Height = 37
            Caption = #20805#20540#37329#39069
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object edtRechargeAmount: TEdit
            Left = 150
            Top = 57
            Width = 300
            Height = 45
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object btnRecharge: TButton
            Left = 470
            Top = 57
            Width = 200
            Height = 51
            Caption = #20805#20540
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = btnRechargeClick
          end
        end
      end
    end
    object TabMerchant: TTabSheet
      Caption = #21830#23478#21830#21697
      ImageIndex = 1
      OnShow = TabMerchantShow
      object pnlMerchants: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblMerchantTitle: TLabel
          Left = 15
          Top = 15
          Width = 216
          Height = 45
          Caption = #21830#23478#21830#21697#21015#34920
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Splitter1: TSplitter
          Left = 0
          Top = 420
          Width = 1507
          Height = 5
          Cursor = crVSplit
          Align = alTop
          ExplicitTop = 350
          ExplicitWidth = 400
        end
        object pnlMerchantList: TPanel
          Left = 0
          Top = 70
          Width = 1507
          Height = 350
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object gridMerchants: TDBGrid
            Left = 15
            Top = 15
            Width = 1479
            Height = 320
            DataSource = dsMerchants
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -27
            TitleFont.Name = 'Segoe UI'
            TitleFont.Style = []
            OnCellClick = gridMerchantsCellClick
          end
        end
        object pnlProducts: TPanel
          Left = 0
          Top = 420
          Width = 1507
          Height = 428
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object lblSelectedMerchant: TLabel
            Left = 15
            Top = 10
            Width = 140
            Height = 37
            Caption = #24403#21069#21830#23478#65306
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblMerchantName: TLabel
            Left = 150
            Top = 10
            Width = 11
            Height = 37
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblProducts: TLabel
            Left = 15
            Top = 60
            Width = 216
            Height = 45
            Caption = #21830#23478#21830#21697#21015#34920
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -33
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblQuantity: TLabel
            Left = 1050
            Top = 380
            Width = 84
            Height = 37
            Caption = #25968#37327#65306
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object gridProducts: TDBGrid
            Left = 15
            Top = 110
            Width = 1479
            Height = 260
            DataSource = dsProducts
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -27
            TitleFont.Name = 'Segoe UI'
            TitleFont.Style = []
            OnCellClick = gridProductsCellClick
          end
          object btnAddToCart: TButton
            Left = 15
            Top = 380
            Width = 200
            Height = 51
            Caption = #21152#20837#36141#29289#36710
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = btnAddToCartClick
          end
          object btnViewCart: TButton
            Left = 230
            Top = 380
            Width = 200
            Height = 51
            Caption = #26597#30475#36141#29289#36710
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = btnViewCartClick
          end
          object btnPlaceOrder: TButton
            Left = 445
            Top = 380
            Width = 200
            Height = 51
            Caption = #19979#21333
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = btnPlaceOrderClick
          end
          object edtQuantity: TEdit
            Left = 1130
            Top = 380
            Width = 120
            Height = 45
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            Text = '1'
          end
        end
      end
    end
    object TabOrder: TTabSheet
      Caption = #35746#21333#31649#29702
      ImageIndex = 2
      OnShow = TabOrderShow
      object pnlOrders: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblOrdersTitle: TLabel
          Left = 15
          Top = 15
          Width = 144
          Height = 45
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
          Width = 1480
          Height = 700
          DataSource = dsOrders
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -27
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnCellClick = gridOrdersCellClick
        end
        object btnOrderAgain: TButton
          Left = 15
          Top = 785
          Width = 225
          Height = 51
          Caption = #20877#27425#19979#21333
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnOrderAgainClick
        end
        object btnOrderDetails: TButton
          Left = 255
          Top = 785
          Width = 225
          Height = 51
          Caption = #35746#21333#35814#24773
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnOrderDetailsClick
        end
      end
    end
    object TabCart: TTabSheet
      Caption = #36141#29289#36710
      ImageIndex = 3
      OnShow = TabCartShow
      object pnlCart: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblCartTitle: TLabel
          Left = 15
          Top = 15
          Width = 108
          Height = 45
          Caption = #36141#29289#36710
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblTotalAmount: TLabel
          Left = 15
          Top = 790
          Width = 84
          Height = 37
          Caption = #24635#35745#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblTotalAmountValue: TLabel
          Left = 90
          Top = 790
          Width = 91
          Height = 37
          Caption = '0.00 '#20803
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblCartQuantity: TLabel
          Left = 1050
          Top = 720
          Width = 84
          Height = 37
          Caption = #25968#37327#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object gridCart: TStringGrid
          Left = 15
          Top = 75
          Width = 1480
          Height = 630
          DefaultRowHeight = 50
          FixedCols = 0
          RowCount = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
          ParentFont = False
          TabOrder = 0
          OnSelectCell = gridCartSelectCell
          ColWidths = (
            120
            600
            180
            180
            400)
        end
        object pnlCartButtons: TPanel
          Left = 15
          Top = 720
          Width = 1000
          Height = 60
          BevelOuter = bvNone
          TabOrder = 1
          object btnRemoveFromCart: TButton
            Left = 0
            Top = 0
            Width = 200
            Height = 51
            Caption = #31227#38500#36873#20013#21830#21697
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = btnRemoveFromCartClick
          end
          object btnUpdateQuantity: TButton
            Left = 215
            Top = 0
            Width = 200
            Height = 51
            Caption = #26356#26032#25968#37327
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = btnUpdateQuantityClick
          end
          object btnClearCart: TButton
            Left = 430
            Top = 0
            Width = 200
            Height = 51
            Caption = #28165#31354#36141#29289#36710
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = btnClearCartClick
          end
          object btnCartPlaceOrder: TButton
            Left = 645
            Top = 0
            Width = 200
            Height = 51
            Caption = #19979#21333
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = btnCartPlaceOrderClick
          end
        end
        object edtCartQuantity: TEdit
          Left = 1130
          Top = 720
          Width = 120
          Height = 45
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
      end
    end
  end
  object qryCustomerInfo: TFDQuery
    SQL.Strings = (
      
        'SELECT customer_id, username, name, contact_info, wallet_balance' +
        ', address'
      'FROM customer'
      'WHERE customer_id = :customer_id')
    Left = 600
    Top = 30
    ParamData = <
      item
        Name = 'CUSTOMER_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryUpdateCustomerInfo: TFDQuery
    Left = 720
    Top = 30
  end
  object qryMerchants: TFDQuery
    SQL.Strings = (
      
        'SELECT merchant_id AS '#21830#23478#32534#21495', name AS '#21830#23478#21517#31216', business_address AS '#21830#23478 +
        #22320#22336
      'FROM merchant'
      'WHERE status = '#39'active'#39
      'ORDER BY merchant_id')
    Left = 600
    Top = 90
  end
  object dsMerchants: TDataSource
    DataSet = qryMerchants
    Left = 720
    Top = 90
  end
  object qryProducts: TFDQuery
    SQL.Strings = (
      'SELECT'
      '  product_id AS '#21830#21697#32534#21495','
      '  product_name AS '#21830#21697#21517#31216','
      '  price AS '#20215#26684','
      '  stock AS '#24211#23384','
      '  description AS '#25551#36848','
      '  is_available'
      'FROM v_all_merchant_products'
      'WHERE merchant_id = :merchant_id'
      'AND is_available = true'
      'AND stock > 0')
    Left = 600
    Top = 150
    ParamData = <
      item
        Name = 'MERCHANT_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dsProducts: TDataSource
    DataSet = qryProducts
    Left = 720
    Top = 150
  end
  object qryOrders: TFDQuery
    SQL.Strings = (
      'SELECT'
      '  order_id AS '#35746#21333#32534#21495','
      '  merchant_id AS '#21830#23478#32534#21495','
      '  status AS '#35746#21333#29366#24577','
      '  created_at AS '#19979#21333#26102#38388','
      '  updated_at AS '#26356#26032#26102#38388
      'FROM order_info'
      'WHERE customer_id = :customer_id'
      'ORDER BY created_at DESC')
    Left = 600
    Top = 210
    ParamData = <
      item
        Name = 'CUSTOMER_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dsOrders: TDataSource
    DataSet = qryOrders
    Left = 720
    Top = 210
  end
  object qryOrderDetails: TFDQuery
    Left = 600
    Top = 270
  end
  object qryPlaceOrder: TFDQuery
    Left = 720
    Top = 270
  end
  object qryAddOrderItem: TFDQuery
    Left = 600
    Top = 330
  end
  object qryRecharge: TFDQuery
    Left = 720
    Top = 330
  end
end
