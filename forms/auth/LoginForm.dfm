object LoginForm: TLoginForm
  Left = 0
  Top = 0
  Margins.Left = 4
  Margins.Top = 4
  Margins.Right = 4
  Margins.Bottom = 4
  Caption = #30331#24405'/'#27880#20876
  ClientHeight = 600
  ClientWidth = 650
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 144
  TextHeight = 25
  object pcLoginRegister: TPageControl
    Left = 0
    Top = 0
    Width = 650
    Height = 600
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = tsLogin
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Style = tsFlatButtons
    TabOrder = 0
    StyleElements = [seFont, seClient]
    object tsLogin: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #30331#24405
      object pnlLogin: TPanel
        Left = 0
        Top = 0
        Width = 642
        Height = 554
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object lblLoginRole: TLabel
          Left = 80
          Top = 120
          Width = 80
          Height = 28
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #35282#33394#31867#22411
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblLoginUsername: TLabel
          Left = 80
          Top = 200
          Width = 60
          Height = 28
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #29992#25143#21517
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblLoginPassword: TLabel
          Left = 80
          Top = 280
          Width = 40
          Height = 28
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #23494#30721
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblAppTitle: TLabel
          Left = 200
          Top = 40
          Width = 232
          Height = 37
          Alignment = taCenter
          Caption = #39184#21697#37197#36865#31995#32479#30331#24405
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cmbLoginRole: TComboBox
          Left = 200
          Top = 116
          Width = 350
          Height = 36
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object edtLoginUsername: TEdit
          Left = 200
          Top = 196
          Width = 350
          Height = 36
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelKind = bkFlat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object edtLoginPassword: TEdit
          Left = 200
          Top = 276
          Width = 350
          Height = 36
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelKind = bkFlat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          PasswordChar = '*'
          TabOrder = 2
        end
        object btnLogin: TButton
          Left = 200
          Top = 360
          Width = 350
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #30331#24405
          Default = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -22
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnLoginClick
        end
        object pnlLoginButton: TPanel
          Left = 200
          Top = 360
          Width = 350
          Height = 60
          BevelOuter = bvNone
          Color = clBlue
          ParentBackground = False
          TabOrder = 4
          Visible = False
          OnClick = btnLoginClick
          object lblLoginBtn: TLabel
            Left = 0
            Top = 0
            Width = 48
            Height = 30
            Align = alClient
            Alignment = taCenter
            Caption = #30331#24405
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -22
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            OnClick = btnLoginClick
          end
        end
      end
    end
    object tsRegister: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = #27880#20876
      ImageIndex = 1
      object pnlRegister: TPanel
        Left = 0
        Top = 0
        Width = 642
        Height = 554
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object lblRegRole: TLabel
          Left = 80
          Top = 80
          Width = 80
          Height = 28
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #35282#33394#31168#22411
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblRegUsername: TLabel
          Left = 80
          Top = 150
          Width = 60
          Height = 28
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #29992#25143#21517
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblRegPassword: TLabel
          Left = 80
          Top = 220
          Width = 40
          Height = 28
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #23494#30721
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblName: TLabel
          Left = 80
          Top = 290
          Width = 40
          Height = 28
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #22995#21517
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblContactInfo: TLabel
          Left = 80
          Top = 360
          Width = 80
          Height = 28
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #32852#31995#26041#24335
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblPasswordHint: TLabel
          Left = 200
          Top = 255
          Width = 80
          Height = 20
          Caption = #35831#36755#20837#23494#30721
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -15
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblUsernameHint: TLabel
          Left = 200
          Top = 185
          Width = 96
          Height = 20
          Caption = #35831#36755#20837#29992#25143#21517
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -15
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblContactInfoHint: TLabel
          Left = 200
          Top = 395
          Width = 112
          Height = 20
          Caption = #35831#36755#20837#32852#31995#26041#24335
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -15
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblRegisterTitle: TLabel
          Left = 200
          Top = 25
          Width = 116
          Height = 37
          Alignment = taCenter
          Caption = #29992#25143#27880#20876
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -27
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cmbRegRole: TComboBox
          Left = 200
          Top = 76
          Width = 350
          Height = 36
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object edtRegUsername: TEdit
          Left = 200
          Top = 146
          Width = 350
          Height = 36
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelKind = bkFlat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnChange = edtRegUsernameChange
        end
        object edtRegPassword: TEdit
          Left = 200
          Top = 216
          Width = 350
          Height = 36
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelKind = bkFlat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          PasswordChar = '*'
          TabOrder = 2
          OnChange = edtRegPasswordChange
        end
        object edtName: TEdit
          Left = 200
          Top = 286
          Width = 350
          Height = 36
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelKind = bkFlat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object edtContactInfo: TEdit
          Left = 200
          Top = 356
          Width = 350
          Height = 36
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelKind = bkFlat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnChange = edtContactInfoChange
        end
        object btnRegister: TButton
          Left = 200
          Top = 430
          Width = 350
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = #27880#20876
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -22
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          OnClick = btnRegisterClick
        end
        object pnlRegisterButton: TPanel
          Left = 200
          Top = 430
          Width = 350
          Height = 60
          BevelOuter = bvNone
          Color = clBlue
          ParentBackground = False
          TabOrder = 6
          Visible = False
          OnClick = btnRegisterClick
          object lblRegisterBtn: TLabel
            Left = 0
            Top = 0
            Width = 48
            Height = 30
            Align = alClient
            Alignment = taCenter
            Caption = #27880#20876
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -22
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            OnClick = btnRegisterClick
          end
        end
      end
    end
  end
end
