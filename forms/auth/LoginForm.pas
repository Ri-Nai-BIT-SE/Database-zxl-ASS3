unit LoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.UITypes,
  Vcl.ComCtrls, // Added for TPageControl, TTabSheet
  Vcl.ExtCtrls, // Added for TPanel
  FireDAC.Stan.Param, // 添加用于 TFDParam.SetAsString
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, 
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  DataModuleUnit, // 主数据模块
  AuthDataModule, // 添加引用认证数据模块
  CustomerForm,
  MerchantForm,
  DeliveryForm,
  AdminForm;

type
  TLoginForm = class(TForm)
    pcLoginRegister: TPageControl; // Added
    tsLogin: TTabSheet;            // Added
    lblLoginRole: TLabel;          // Added
    cmbLoginRole: TComboBox;       // Added
    lblLoginUsername: TLabel;      // Added
    edtLoginUsername: TEdit;       // Added
    lblLoginPassword: TLabel;      // Added
    edtLoginPassword: TEdit;       // Added
    btnLogin: TButton;             // Kept, moved to tsLogin
    tsRegister: TTabSheet;         // Added
    lblRegRole: TLabel;            // Added
    cmbRegRole: TComboBox;         // Added
    lblRegUsername: TLabel;        // Added
    edtRegUsername: TEdit;         // Added
    lblRegPassword: TLabel;        // Added
    edtRegPassword: TEdit;         // Added
    lblName: TLabel;               // Added
    edtName: TEdit;                // Added
    lblContactInfo: TLabel;        // Added
    edtContactInfo: TEdit;         // Added
    btnRegister: TButton;          // Kept, moved to tsRegister
    pnlLogin: TPanel;              // Added panel for login tab
    pnlRegister: TPanel;           // Added panel for register tab
    lblPasswordHint: TLabel;       // 添加密码提示标签
    lblUsernameHint: TLabel;        // 添加注册按钮标签
    lblNameHint: TLabel;           // 添加姓名提示标签
    lblContactInfoHint: TLabel;    // 添加联系方式提示标签
    lblAppTitle: TLabel;           // 添加登录页标题
    lblRegisterTitle: TLabel;      // 添加注册页标题
    pnlLoginButton: TPanel;        // 添加登录按钮面板
    lblLoginBtn: TLabel;           // 添加登录按钮标签
    pnlRegisterButton: TPanel;     // 添加注册按钮面板
    lblRegisterBtn: TLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtRegPasswordChange(Sender: TObject); // 添加密码输入改变事件
    procedure edtRegUsernameChange(Sender: TObject); // 添加用户名输入改变事件
    procedure edtContactInfoChange(Sender: TObject);
    procedure edtNameChange(Sender: TObject); // 添加姓名输入改变事件
  private
    { Private declarations }
    function GetSelectedRoleTableName(RoleComboBox: TComboBox): string; // Modified signature
    function ValidatePassword(const Password: string; var ErrorMsg: string): Boolean; // 添加密码验证函数
    procedure UpdatePasswordHint(const Password: string); // 添加更新密码提示方法
    procedure UpdateUsernameHint(const Username: string); // 添加更新用户名提示方法
    procedure UpdateContactInfoHint(const ContactInfo: string); // 添加更新联系方式提示方法
    procedure UpdateNameHint(const Name: string); // 添加更新姓名提示方法
    procedure CustomizeFormAppearance; // 自定义表单外观
  public
    { Public declarations }
    LoginSuccessful: Boolean;
    LoggedInUserRole: string;
    LoggedInUserID: Integer; // 添加用户ID
  end;

implementation

uses System.StrUtils;

{$R *.dfm}

// Helper function to get the database table name based on the selected role
function TLoginForm.GetSelectedRoleTableName(RoleComboBox: TComboBox): string; // Modified signature
begin
  Result := '';
  if RoleComboBox.ItemIndex < 0 then Exit;

  // case RoleComboBox.Items[RoleComboBox.ItemIndex] of
  if RoleComboBox.Items[RoleComboBox.ItemIndex] = 'customer' then
    Result := 'customer'
  else if RoleComboBox.Items[RoleComboBox.ItemIndex] = 'merchant' then
    Result := 'merchant'
  else if RoleComboBox.Items[RoleComboBox.ItemIndex] = 'delivery' then
    Result := 'delivery_man' // Match table name from sql.md
  else if RoleComboBox.Items[RoleComboBox.ItemIndex] = 'admin' then
    Result := 'admin';
end;


procedure TLoginForm.btnLoginClick(Sender: TObject);
var
  SelectedRoleTable: string;
  RoleType: TRoleType;
  Username, Password: string; // Define Username and Password locally
  MerchantID: Integer; // 添加商家ID变量
  DeliveryID: Integer; // 添加外卖员ID变量
  CustomerID: Integer; // 添加顾客ID变量
begin
  LoginSuccessful := False;
  LoggedInUserRole := '';
  LoggedInUserID := -1; // 初始化用户ID为-1

  SelectedRoleTable := GetSelectedRoleTableName(cmbLoginRole); // Use cmbLoginRole
  Username := edtLoginUsername.Text; // Use edtLoginUsername
  Password := edtLoginPassword.Text; // Use edtLoginPassword

  if SelectedRoleTable = '' then
  begin
    MessageDlg('请选择一个角色。', mtWarning, [mbOK], 0);
    cmbLoginRole.SetFocus; // Focus login role combo
    Exit;
  end;

  if Username = '' then // Add username check
  begin
    MessageDlg('用户名不能为空。', mtWarning, [mbOK], 0);
    edtLoginUsername.SetFocus;
    Exit;
  end;

  if Password = '' then // Add password check
  begin
    MessageDlg('密码不能为空。', mtWarning, [mbOK], 0);
    edtLoginPassword.SetFocus;
    Exit;
  end;

  // --- 数据库验证逻辑 ---
  try
    // 获取当前角色类型
    RoleType := DM.GetRoleTypeFromString(cmbLoginRole.Items[cmbLoginRole.ItemIndex]);
    
    // 确保数据库已连接
    if not DM.Connect(RoleType) then
    begin
      MessageDlg('无法连接到数据库，请检查网络连接。', mtError, [mbOK], 0);
      Exit;
    end;
    
    // 使用认证数据模块验证登录
    if AuthDM.ValidateLogin(RoleType, Username, Password) then
    begin
      LoginSuccessful := True;
      LoggedInUserRole := cmbLoginRole.Items[cmbLoginRole.ItemIndex]; // Use cmbLoginRole
      
      // 获取用户ID
      LoggedInUserID := AuthDM.GetUserID(RoleType, Username);

      // 根据角色创建主窗体
      if LoggedInUserRole = 'customer' then
      begin
        // 获取顾客ID
        CustomerID := LoggedInUserID;
        // 调用ShowCustomerForm方法并传递顾客ID
        TCustomerForm.ShowCustomerForm(CustomerID);
      end
      else if LoggedInUserRole = 'merchant' then
      begin
        // 获取商家ID
        MerchantID := LoggedInUserID;
        // 修改为传递商家ID
        TMerchantForm.ShowMerchantForm(MerchantID);
      end
      else if LoggedInUserRole = 'delivery' then
      begin
        // 获取外卖员ID
        DeliveryID := LoggedInUserID;
        // 修改为传递外卖员ID
        TDeliveryForm.ShowDeliveryForm(DeliveryID);
      end
      else if LoggedInUserRole = 'admin' then
        TAdminForm.ShowAdminForm
      else
      begin
        ShowMessage('未知的用户角色: ' + LoggedInUserRole);
        // 如果角色未知，阻止登录窗体关闭
        Exit; // 退出 btnLoginClick 过程
      end;

      ModalResult := mrOk; // Close the form with OK result ONLY if a form was created
    end
    else
    begin
      MessageDlg('无效的用户名或密码。', mtError, [mbOK], 0);
      LoginSuccessful := False;
      edtLoginPassword.SetFocus; // Focus login password
      edtLoginPassword.SelectAll;
      // Keep the form open for another attempt
    end;

  except
    on E: Exception do
    begin
      MessageDlg('登录时发生数据库错误: ' + E.Message, mtError, [mbOK], 0);
      LoginSuccessful := False;
      // Optionally log the error
    end;
  end;
  // --- 数据库验证逻辑结束 ---
end;

// 密码验证函数实现
function TLoginForm.ValidatePassword(const Password: string; var ErrorMsg: string): Boolean;
var
  HasUpperCase, HasLowerCase, HasDigit, HasSpecialChar: Boolean;
  i: Integer;
begin
  // 初始化标志
  HasUpperCase := False;
  HasLowerCase := False;
  HasDigit := False;
  HasSpecialChar := False;
  
  // 检查密码长度
  if Length(Password) < 6 then
  begin
    ErrorMsg := '密码长度至少需要6个字符';
    Result := False;
    Exit;
  end;
  
  // 检查密码复杂度
  for i := 1 to Length(Password) do
  begin
    if CharInSet(Password[i], ['A'..'Z']) then
      HasUpperCase := True
    else if CharInSet(Password[i], ['a'..'z']) then
      HasLowerCase := True
    else if CharInSet(Password[i], ['0'..'9']) then
      HasDigit := True
    else if CharInSet(Password[i], ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', '|', '\', ':', ';', '"', '''', '<', '>', ',', '.', '?', '/']) then
      HasSpecialChar := True;
  end;
  
  // 检查是否满足至少两个条件
  if (Integer(HasUpperCase) + Integer(HasLowerCase) + Integer(HasDigit) + Integer(HasSpecialChar) < 2) then
  begin
    ErrorMsg := '密码必须包含以下至少两种：大写字母、小写字母、数字、特殊字符';
    Result := False;
    Exit;
  end;
  
  Result := True;
end;

// 更新用户名提示的方法
procedure TLoginForm.UpdateUsernameHint(const Username: string);
begin
  if Username = '' then
  begin
    lblUsernameHint.Caption := '请输入用户名';
    lblUsernameHint.Font.Color := clGray;
    Exit;
  end;
  
  if Length(Username) < 3 then
  begin
    lblUsernameHint.Caption := '用户名至少需要3个字符';
    lblUsernameHint.Font.Color := clRed;
    Exit;
  end;
  
  // 移除实时判重，只显示格式验证结果
  lblUsernameHint.Caption := '用户名格式正确';
  lblUsernameHint.Font.Color := clGreen;
end;

// 更新联系方式提示的方法
procedure TLoginForm.UpdateContactInfoHint(const ContactInfo: string);
begin
  if ContactInfo = '' then
  begin
    lblContactInfoHint.Caption := '请输入联系方式';
    lblContactInfoHint.Font.Color := clGray;
    Exit;
  end;
  
  // 移除实时判重，只显示格式验证结果
  lblContactInfoHint.Caption := '联系方式格式正确';
  lblContactInfoHint.Font.Color := clGreen;
end;

procedure TLoginForm.UpdateNameHint(const Name: string);
begin
  if Name = '' then
  begin
    lblNameHint.Caption := '请输入您的不真实姓名';
    lblNameHint.Font.Color := clGray;
    Exit;
  end;

  lblNameHint.Caption := '姓名格式正确';
  lblNameHint.Font.Color := clGreen;
end;
// 用户名输入框改变事件处理程序
procedure TLoginForm.edtRegUsernameChange(Sender: TObject);
begin
  UpdateUsernameHint(edtRegUsername.Text);
end;

// 联系方式输入框改变事件处理程序
procedure TLoginForm.edtContactInfoChange(Sender: TObject);
begin
  UpdateContactInfoHint(edtContactInfo.Text);
end;

// 姓名输入框改变事件处理程序
procedure TLoginForm.edtNameChange(Sender: TObject);
begin
  UpdateNameHint(edtName.Text);
end;

procedure TLoginForm.btnRegisterClick(Sender: TObject);
var
  SelectedRoleTable: string;
  RoleType: TRoleType;
  Username, Password, Name, ContactInfo: string;
  ErrorMsg: string;
  Address, BusinessAddress: string;
begin
  SelectedRoleTable := GetSelectedRoleTableName(cmbRegRole);
  Username := edtRegUsername.Text;
  Password := edtRegPassword.Text;
  Name := edtName.Text;
  ContactInfo := edtContactInfo.Text;
  Address := ''; // 这里可以添加地址字段
  BusinessAddress := ''; // 这里可以添加商家地址字段
  
  // 基本输入验证
  if SelectedRoleTable = '' then
  begin
    MessageDlg('请选择一个角色。', mtWarning, [mbOK], 0);
    cmbRegRole.SetFocus;
    Exit;
  end;
  
  if Username = '' then
  begin
    MessageDlg('用户名不能为空。', mtWarning, [mbOK], 0);
    edtRegUsername.SetFocus;
    Exit;
  end;
  
  if Password = '' then
  begin
    MessageDlg('密码不能为空。', mtWarning, [mbOK], 0);
    edtRegPassword.SetFocus;
    Exit;
  end;
  
  if Name = '' then
  begin
    MessageDlg('姓名不能为空。', mtWarning, [mbOK], 0);
    edtName.SetFocus;
    Exit;
  end;
  
  if ContactInfo = '' then
  begin
    MessageDlg('联系方式不能为空。', mtWarning, [mbOK], 0);
    edtContactInfo.SetFocus;
    Exit;
  end;
  
  // 密码复杂度验证
  if not ValidatePassword(Password, ErrorMsg) then
  begin
    MessageDlg(ErrorMsg, mtWarning, [mbOK], 0);
    edtRegPassword.SetFocus;
    Exit;
  end;
  
  // 获取角色类型
  RoleType := DM.GetRoleTypeFromString(cmbRegRole.Items[cmbRegRole.ItemIndex]);
  
  // 确保 AuthDM 可用
  if not Assigned(AuthDM) then
  begin
      MessageDlg('认证模块未初始化，无法进行注册。', mtError, [mbOK], 0);
      Exit;
  end;

  // 使用 AuthDM 检查用户名是否已存在
  if AuthDM.CheckUsernameExists(RoleType, Username) then
  begin
      lblUsernameHint.Caption := '该用户名已被注册，请选择其他用户名';
      lblUsernameHint.Font.Color := clRed;
    edtRegUsername.SetFocus;
    Exit;
  end;
  
  // 使用 AuthDM 检查联系方式是否已存在
  if AuthDM.CheckContactInfoExists(RoleType, ContactInfo) then
  begin
      lblContactInfoHint.Caption := '该联系方式已被注册，请使用其他联系方式';
      lblContactInfoHint.Font.Color := clRed;
    edtContactInfo.SetFocus;
    Exit;
  end;
  
  // 使用认证数据模块进行注册
  if AuthDM.RegisterUser(RoleType, Username, Password, Name, ContactInfo, Address, BusinessAddress) then
  begin
    MessageDlg('注册成功！请登录使用您的账户。', mtInformation, [mbOK], 0);
    // 切换到登录页
    pcLoginRegister.ActivePage := tsLogin;
    // 预填充登录字段
    cmbLoginRole.ItemIndex := cmbRegRole.ItemIndex;
    edtLoginUsername.Text := Username;
    edtLoginPassword.Text := '';  // 出于安全考虑，不预填密码
    edtLoginPassword.SetFocus;
  end
  else
  begin
    MessageDlg('注册失败，请重试。', mtError, [mbOK], 0);
  end;
end;

// 更新密码提示的方法
procedure TLoginForm.UpdatePasswordHint(const Password: string);
var
  HasUpperCase, HasLowerCase, HasDigit, HasSpecialChar: Boolean;
  HintColor: TColor;
  i: Integer;
  PasswordStrength: Integer;
begin
  // 初始化标志
  HasUpperCase := False;
  HasLowerCase := False;
  HasDigit := False;
  HasSpecialChar := False;
  
  // 检查密码复杂度
  for i := 1 to Length(Password) do
  begin
    if CharInSet(Password[i], ['A'..'Z']) then
      HasUpperCase := True
    else if CharInSet(Password[i], ['a'..'z']) then
      HasLowerCase := True
    else if CharInSet(Password[i], ['0'..'9']) then
      HasDigit := True
    else if CharInSet(Password[i], ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', '|', '\', ':', ';', '"', '''', '<', '>', ',', '.', '?', '/']) then
      HasSpecialChar := True;
  end;
  
  // 计算密码强度
  PasswordStrength := Integer(HasUpperCase) + Integer(HasLowerCase) + Integer(HasDigit) + Integer(HasSpecialChar);
  
  // 根据密码强度设置提示颜色
  if (Length(Password) < 6) or (PasswordStrength < 2) then
    HintColor := clRed
  else if PasswordStrength = 2 then
    HintColor := clOlive
  else if PasswordStrength = 3 then
    HintColor := clGreen
  else
    HintColor := clGreen;
  
  // 更新密码提示
  lblPasswordHint.Font.Color := HintColor;
  
  if Length(Password) = 0 then
    lblPasswordHint.Caption := '请输入密码'
  else if Length(Password) < 6 then
    lblPasswordHint.Caption := '密码至少需要6个字符'
  else if PasswordStrength < 2 then
    lblPasswordHint.Caption := '密码强度太弱：需包含大小写字母、数字或特殊字符中的至少两种'
  else if PasswordStrength = 2 then
    lblPasswordHint.Caption := '密码强度一般'
  else if PasswordStrength = 3 then
    lblPasswordHint.Caption := '密码强度良好'
  else
    lblPasswordHint.Caption := '密码强度极佳';
end;

// 密码输入框改变事件处理程序
procedure TLoginForm.edtRegPasswordChange(Sender: TObject);
begin
  UpdatePasswordHint(edtRegPassword.Text);
end;

// 自定义表单外观
procedure TLoginForm.CustomizeFormAppearance;
begin
  // 美化登录按钮
  btnLogin.Font.Color := clWhite;
  
  // 美化注册按钮
  btnRegister.Font.Color := clWhite;
  
  // 设置输入框样式
  edtLoginUsername.BevelKind := bkFlat;
  edtLoginPassword.BevelKind := bkFlat;
  edtRegUsername.BevelKind := bkFlat;
  edtRegPassword.BevelKind := bkFlat;
  edtName.BevelKind := bkFlat;
  edtContactInfo.BevelKind := bkFlat;
end;

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  LoginSuccessful := False;
  LoggedInUserRole := '';
  edtLoginPassword.PasswordChar := '*';  // Set for login password
  edtRegPassword.PasswordChar := '*';    // Set for register password

  // Populate Login Role ComboBox
  cmbLoginRole.Items.Clear;
  cmbLoginRole.Items.Add('customer');
  cmbLoginRole.Items.Add('merchant');
  cmbLoginRole.Items.Add('delivery');
  cmbLoginRole.Items.Add('admin');
  cmbLoginRole.ItemIndex := 0; // Default to customer

  // Populate Register Role ComboBox (exclude admin)
  cmbRegRole.Items.Clear;
  cmbRegRole.Items.Add('customer');
  cmbRegRole.Items.Add('merchant');
  cmbRegRole.Items.Add('delivery');
  cmbRegRole.ItemIndex := 0; // Optionally default selection

  // 初始化提示标签
  lblPasswordHint.Caption := '请输入密码';
  lblPasswordHint.Font.Color := clGray;
  
  lblUsernameHint.Caption := '请输入用户名';
  lblUsernameHint.Font.Color := clGray;
  
  lblContactInfoHint.Caption := '请输入联系方式';
  lblContactInfoHint.Font.Color := clGray;

  // 自定义表单外观
  CustomizeFormAppearance;

  // Set initial active page (optional, DFM already sets it)
  pcLoginRegister.ActivePage := tsLogin;
end;

// Add FormShow implementation
procedure TLoginForm.FormShow(Sender: TObject);
begin
  // Set initial focus based on the active tab
  if pcLoginRegister.ActivePage = tsLogin then
  begin
    if cmbLoginRole.CanFocus then
      cmbLoginRole.SetFocus
    else if edtLoginUsername.CanFocus then
      edtLoginUsername.SetFocus;
  end
  else if pcLoginRegister.ActivePage = tsRegister then
  begin
     if cmbRegRole.CanFocus then
       cmbRegRole.SetFocus
     else if edtRegUsername.CanFocus then
       edtRegUsername.SetFocus;
  end;
end;


end.
