object DeliveryForm: TDeliveryForm
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = '配送员界面'
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
      Caption = '外卖员账户管理'
      OnShow = TabAccountShow
      object pnlDeliveryInfo: TPanel
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
        object lblDeliveryInfoTitle: TLabel
          Left = 15
          Top = 15
          Width = 216
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = '外卖员账户信息'
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
          Width = 73
          Height = 37
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = '姓名'
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
          Caption = '联系信息'
        end
        object lblStatus: TLabel
          Left = 15
          Top = 210
          Width = 73
          Height = 37
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = '状态'
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
        object edtStatus: TEdit
          Left = 180
          Top = 203
          Width = 450
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Enabled = False
          TabOrder = 2
        end
        object btnUpdateDeliveryInfo: TButton
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
          OnClick = btnUpdateDeliveryInfoClick
        end
        object btnToggleStatus: TButton
          Left = 435
          Top = 270
          Width = 225
          Height = 51
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = #20999#25442#29366#24577
          TabOrder = 4
          OnClick = btnToggleStatusClick
        end
      end
    end
    object TabOrder: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = '订单管理'
      ImageIndex = 1
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
          Caption = '订单管理'
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
          Width = 1470
          Height = 650
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          DataSource = dsOrders
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -27
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnCellClick = gridOrdersCellClick
        end
        object btnAcceptOrder: TButton
          Left = 15
          Top = 750
          Width = 300
          Height = 60
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = '接单'
          TabOrder = 1
          OnClick = btnAcceptOrderClick
          Enabled = False
        end
        object btnConfirmDelivery: TButton
          Left = 330
          Top = 750
          Width = 300
          Height = 60
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = '确认送达'
          TabOrder = 2
          OnClick = btnConfirmDeliveryClick
          Enabled = False
        end
      end
    end
    object TabRevenue: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = '收益统计'
      ImageIndex = 2
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
        object lblRevenueTitle: TLabel
          Left = 15
          Top = 15
          Width = 144
          Height = 45
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = '收益统计'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -33
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object gboxDateRange: TGroupBox
          Left = 15
          Top = 75
          Width = 1200
          Height = 135
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = '日期范围'
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
            Caption = '开始日期'
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
            Caption = '结束日期'
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
            Date = 45155.000000000000000000
            Time = 0.659722222222222200
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
            Date = 45155.000000000000000000
            Time = 0.659722222222222200
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
            Caption = '生成统计'
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
            Caption = '总收益'
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
            Caption = '0.00 元'
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
            Caption = '总订单数'
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
            Caption = '0 单'
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
  object dsDeliveryInfo: TDataSource
    Left = 480
    Top = 15
  end
  object qryDeliveryInfo: TFDQuery
    Left = 585
    Top = 15
  end
  object qryUpdateDeliveryInfo: TFDQuery
    Left = 690
    Top = 15
  end
  object dsOrders: TDataSource
    Left = 480
    Top = 75
  end
  object qryOrders: TFDQuery
    Left = 585
    Top = 75
  end
  object qryAcceptOrder: TFDQuery
    Left = 480
    Top = 135
  end
  object qryConfirmDelivery: TFDQuery
    Left = 585
    Top = 135
  end
  object qryRevenue: TFDQuery
    Left = 240
    Top = 256
  end
  object qryToggleStatus: TFDQuery
    Left = 440
    Top = 256
  end
end
