object AdminForm: TAdminForm
  Left = 0
  Top = 0
  Margins.Left = 7
  Margins.Top = 7
  Margins.Right = 7
  Margins.Bottom = 7
  Caption = #31649#29702#21592#30028#38754
  ClientHeight = 900
  ClientWidth = 1515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -27
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 144
  TextHeight = 37
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 1515
    Height = 900
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TabMerchant
    Align = alClient
    TabOrder = 0
    TabWidth = 270
    object TabMerchant: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #21830#23478#31649#29702
      OnShow = TabMerchantShow
      object pnlMerchant: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblMerchantTitle: TLabel
          Left = 29
          Top = 19
          Width = 216
          Height = 45
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #21830#23478#36134#25143#31649#29702
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object gridMerchant: TDBGrid
          Left = 29
          Top = 144
          Width = 1437
          Height = 576
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          DataSource = dsMerchant
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -27
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
        object navMerchant: TDBNavigator
          Left = 29
          Top = 732
          Width = 1432
          Height = 48
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          DataSource = dsMerchant
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
          TabOrder = 1
        end
        object pnlMerchantFilter: TPanel
          Left = 29
          Top = 60
          Width = 1437
          Height = 72
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelOuter = bvNone
          TabOrder = 2
          object lblMerchantStatus: TLabel
            Left = 19
            Top = 24
            Width = 140
            Height = 37
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #21830#23478#29366#24577#65306
          end
          object cmbMerchantStatus: TComboBox
            Left = 160
            Top = 20
            Width = 240
            Height = 45
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = csDropDownList
            TabOrder = 0
          end
          object btnFilterMerchant: TButton
            Left = 410
            Top = 24
            Width = 120
            Height = 40
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #31579#36873
            TabOrder = 1
            OnClick = btnFilterMerchantClick
          end
          object btnResetMerchant: TButton
            Left = 540
            Top = 24
            Width = 120
            Height = 40
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #37325#32622
            TabOrder = 2
            OnClick = btnResetMerchantClick
          end
        end
      end
    end
    object TabDelivery: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #22806#21334#21592#31649#29702
      ImageIndex = 1
      OnShow = TabDeliveryShow
      object pnlDelivery: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblDeliveryTitle: TLabel
          Left = 29
          Top = 19
          Width = 180
          Height = 45
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #22806#21334#21592#31649#29702
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object gridDelivery: TDBGrid
          Left = 29
          Top = 144
          Width = 1437
          Height = 576
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          DataSource = dsDelivery
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -27
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
        object navDelivery: TDBNavigator
          Left = 29
          Top = 732
          Width = 1432
          Height = 48
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          DataSource = dsDelivery
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
          TabOrder = 1
        end
        object pnlDeliveryFilter: TPanel
          Left = 29
          Top = 60
          Width = 1437
          Height = 72
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelOuter = bvNone
          TabOrder = 2
          object lblDeliveryStatus: TLabel
            Left = 19
            Top = 24
            Width = 168
            Height = 37
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #22806#21334#21592#29366#24577#65306
          end
          object cmbDeliveryStatus: TComboBox
            Left = 180
            Top = 20
            Width = 240
            Height = 45
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = csDropDownList
            TabOrder = 0
          end
          object btnFilterDelivery: TButton
            Left = 430
            Top = 24
            Width = 120
            Height = 40
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #31579#36873
            TabOrder = 1
            OnClick = btnFilterDeliveryClick
          end
          object btnResetDelivery: TButton
            Left = 560
            Top = 24
            Width = 120
            Height = 40
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #37325#32622
            TabOrder = 2
            OnClick = btnResetDeliveryClick
          end
        end
      end
    end
    object TabCustomer: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #28040#36153#32773#31649#29702
      ImageIndex = 2
      OnShow = TabCustomerShow
      object pnlCustomer: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblCustomerTitle: TLabel
          Left = 29
          Top = 19
          Width = 180
          Height = 45
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #28040#36153#32773#31649#29702
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object gridCustomer: TDBGrid
          Left = 29
          Top = 144
          Width = 1437
          Height = 576
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          DataSource = dsCustomer
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -27
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
        object navCustomer: TDBNavigator
          Left = 29
          Top = 732
          Width = 1432
          Height = 48
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          DataSource = dsCustomer
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
          TabOrder = 1
        end
        object pnlCustomerFilter: TPanel
          Left = 29
          Top = 60
          Width = 1437
          Height = 72
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelOuter = bvNone
          TabOrder = 2
          object lblWalletBalance: TLabel
            Left = 19
            Top = 24
            Width = 140
            Height = 37
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #38134#34892#20313#39069#65306
          end
          object edtWalletBalance: TEdit
            Left = 160
            Top = 20
            Width = 240
            Height = 45
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 0
          end
          object btnFilterCustomer: TButton
            Left = 410
            Top = 24
            Width = 120
            Height = 40
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #31579#36873
            TabOrder = 1
            OnClick = btnFilterCustomerClick
          end
          object btnResetCustomer: TButton
            Left = 540
            Top = 24
            Width = 120
            Height = 40
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #37325#32622
            TabOrder = 2
            OnClick = btnResetCustomerClick
          end
        end
      end
    end
    object TabOrder: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #35746#21333#31649#29702
      ImageIndex = 3
      OnShow = TabOrderShow
      object pnlOrder: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblOrderTitle: TLabel
          Left = 29
          Top = 19
          Width = 216
          Height = 45
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #35746#21333#20449#24687#31649#29702
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object gridOrder: TDBGrid
          Left = 29
          Top = 144
          Width = 1437
          Height = 576
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          DataSource = dsOrder
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -27
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
        object navOrder: TDBNavigator
          Left = 29
          Top = 732
          Width = 1432
          Height = 48
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          DataSource = dsOrder
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
          TabOrder = 1
        end
        object pnlOrderFilter: TPanel
          Left = 29
          Top = 60
          Width = 1437
          Height = 72
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelOuter = bvNone
          TabOrder = 2
          object lblOrderStatus: TLabel
            Left = 19
            Top = 24
            Width = 140
            Height = 37
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #35746#21333#29366#24577#65306
          end
          object cmbOrderStatus: TComboBox
            Left = 160
            Top = 20
            Width = 240
            Height = 45
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = csDropDownList
            TabOrder = 0
          end
          object btnFilterOrder: TButton
            Left = 410
            Top = 24
            Width = 120
            Height = 40
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #31579#36873
            TabOrder = 1
            OnClick = btnFilterOrderClick
          end
          object btnResetOrder: TButton
            Left = 540
            Top = 24
            Width = 120
            Height = 40
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #37325#32622
            TabOrder = 2
            OnClick = btnResetOrderClick
          end
        end
      end
    end
    object TabStats: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #32479#35745#25253#34920
      ImageIndex = 4
      OnShow = TabStatsShow
      object pnlStats: TPanel
        Left = 0
        Top = 0
        Width = 1507
        Height = 848
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblStatsTitle: TLabel
          Left = 29
          Top = 19
          Width = 216
          Height = 45
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #24179#21488#32479#35745#25253#34920
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object gboxDateRange: TGroupBox
          Left = 29
          Top = 60
          Width = 1437
          Height = 120
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #26102#38388#33539#22260
          TabOrder = 0
          object lblStartDate: TLabel
            Left = 19
            Top = 45
            Width = 112
            Height = 37
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #24320#22987#26085#26399
          end
          object lblEndDate: TLabel
            Left = 397
            Top = 45
            Width = 112
            Height = 37
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #32467#26463#26085#26399
          end
          object dtpStartDate: TDateTimePicker
            Left = 149
            Top = 40
            Width = 240
            Height = 45
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 45400.000000000000000000
            Time = 0.606510486111801600
            TabOrder = 0
          end
          object dtpEndDate: TDateTimePicker
            Left = 514
            Top = 40
            Width = 240
            Height = 45
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 45400.000000000000000000
            Time = 0.606510486111801600
            TabOrder = 1
          end
          object btnGenerateStats: TButton
            Left = 780
            Top = 40
            Width = 180
            Height = 45
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #29983#25104#25253#34920
            TabOrder = 2
            OnClick = btnGenerateStatsClick
          end
        end
        object pnlRevenueStats: TPanel
          Left = 29
          Top = 180
          Width = 557
          Height = 120
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelOuter = bvLowered
          TabOrder = 1
          object lblTotalRevenue: TLabel
            Left = 29
            Top = 19
            Width = 245
            Height = 45
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #24179#21488#24635#33829#19994#39069#65306
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -33
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblRevenueValue: TLabel
            Left = 29
            Top = 65
            Width = 87
            Height = 60
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '0.00'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -44
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object pnlOrderStats: TPanel
          Left = 605
          Top = 180
          Width = 557
          Height = 120
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelOuter = bvLowered
          TabOrder = 2
          object lblTotalOrders: TLabel
            Left = 29
            Top = 19
            Width = 210
            Height = 45
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #24635#35746#21333#25968#37327#65306
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -33
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblOrdersValue: TLabel
            Left = 29
            Top = 65
            Width = 25
            Height = 60
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -44
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
    end
  end
  object dsMerchant: TDataSource
    DataSet = qryMerchant
    Left = 920
    Top = 72
  end
  object qryMerchant: TFDQuery
    AfterOpen = qryMerchantAfterOpen
    AfterPost = qryMerchantAfterPost
    Left = 920
    Top = 136
  end
  object dsDelivery: TDataSource
    DataSet = qryDelivery
    Left = 840
    Top = 72
  end
  object qryDelivery: TFDQuery
    AfterOpen = qryDeliveryAfterOpen
    AfterPost = qryDeliveryAfterPost
    Left = 840
    Top = 136
  end
  object dsOrder: TDataSource
    DataSet = qryOrder
    Left = 760
    Top = 72
  end
  object qryOrder: TFDQuery
    AfterOpen = qryOrderAfterOpen
    AfterPost = qryOrderAfterPost
    Left = 760
    Top = 136
  end
  object tmpQuery: TFDQuery
    Left = 680
    Top = 136
  end
  object dsCustomer: TDataSource
    DataSet = qryCustomer
    Left = 680
    Top = 72
  end
  object qryCustomer: TFDQuery
    AfterOpen = qryCustomerAfterOpen
    AfterPost = qryCustomerAfterPost
    Left = 680
    Top = 200
  end
end
