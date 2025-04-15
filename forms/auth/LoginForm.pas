unit LoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.UITypes,
  Vcl.ComCtrls, // Added for TPageControl, TTabSheet
  Vcl.ExtCtrls, // Added for TPanel
  FireDAC.Stan.Param, // 添加用于 TFDParam.SetAsString
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
    lblUsernameHint: TLabel;       // 添加用户名提示标签
    lblContactInfoHint: TLabel;    // 添加联系方式提示标签
    procedure btnLoginClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtRegPasswordChange(Sender: TObject); // 添加密码输入改变事件
    procedure edtRegUsernameChange(Sender: TObject); // 添加用户名输入改变事件
    procedure edtContactInfoChange(Sender: TObject); // 添加联系方式输入改变事件
  private
    { Private declarations }
    function GetSelectedRoleTableName(RoleComboBox: TComboBox): string; // Modified signature
    function ValidatePassword(const Password: string; var ErrorMsg: string): Boolean; // 添加密码验证函数
    procedure UpdatePasswordHint(const Password: string); // 添加更新密码提示方法
    procedure UpdateUsernameHint(const Username: string); // 添加更新用户名提示方法
    procedure UpdateContactInfoHint(const ContactInfo: string); // 添加更新联系方式提示方法
    function CheckUsernameExists(const SelectedRoleTable, Username: string): Boolean; // 检查用户名是否存在
    function CheckContactInfoExists(const SelectedRoleTable, ContactInfo: string): Boolean; // 检查联系方式是否存在
  public
    { Public declarations }
    LoginSuccessful: Boolean;
    LoggedInUserRole: string;
  end;

implementation

uses System.StrUtils, DataModuleUnit;

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
  Username, Password: string; // Define Username and Password locally
begin
  LoginSuccessful := False;
  LoggedInUserRole := '';

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
    // 连接数据库
    DM.Connect;

    if DM.VerifyCredentials(SelectedRoleTable, Username, Password) then
    begin
      LoginSuccessful := True;
      LoggedInUserRole := cmbLoginRole.Items[cmbLoginRole.ItemIndex]; // Use cmbLoginRole

      // 根据角色创建主窗体
      if LoggedInUserRole = 'customer' then
        Application.CreateForm(TCustomerForm, gCustomerForm)
      else if LoggedInUserRole = 'merchant' then
        Application.CreateForm(TMerchantForm, gMerchantForm)
      else if LoggedInUserRole = 'delivery' then
        Application.CreateForm(TDeliveryForm, gDeliveryForm)
      else if LoggedInUserRole = 'admin' then
        Application.CreateForm(TAdminForm, gAdminForm)
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

// 检查用户名是否存在的函数
function TLoginForm.CheckUsernameExists(const SelectedRoleTable, Username: string): Boolean;
var
  SQLCheck: string;
begin
  Result := False;
  if (SelectedRoleTable = '') or (Username = '') then 
    Exit;
    
  // 连接数据库
  try
    DM.Connect;
    
    // 检查用户名是否已存在
    SQLCheck := Format('SELECT COUNT(*) FROM %s WHERE username = :username', [SelectedRoleTable]);
    DM.FDQueryRegister.SQL.Text := SQLCheck;
    DM.FDQueryRegister.Params.ParamByName('username').AsString := Username;
    
    try
      DM.FDQueryRegister.Open();
      Result := (DM.FDQueryRegister.Fields[0].AsInteger > 0);
    finally
      DM.FDQueryRegister.Close; // 关闭检查查询
    end;
  except
    // 出错时视为不存在
    Result := False;
  end;
end;

// 检查联系方式是否存在的函数
function TLoginForm.CheckContactInfoExists(const SelectedRoleTable, ContactInfo: string): Boolean;
var
  SQLCheck: string;
begin
  Result := False;
  if (SelectedRoleTable = '') or (ContactInfo = '') then
    Exit;
    
  // 连接数据库
  try
    DM.Connect;
    
    // 检查联系方式是否已存在
    SQLCheck := Format('SELECT COUNT(*) FROM %s WHERE contact_info = :contact_info', [SelectedRoleTable]);
    DM.FDQueryRegister.SQL.Text := SQLCheck;
    DM.FDQueryRegister.Params.ParamByName('contact_info').AsString := ContactInfo;
    
    try
      DM.FDQueryRegister.Open();
      Result := (DM.FDQueryRegister.Fields[0].AsInteger > 0);
    finally
      DM.FDQueryRegister.Close; // 关闭检查查询
    end;
  except
    // 出错时视为不存在
    Result := False;
  end;
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

procedure TLoginForm.btnRegisterClick(Sender: TObject);
var
  SelectedRoleTable: string;
  Username, Password, Name, ContactInfo: string;
  SQLInsert: string;
  PasswordErrMsg: string;
  UsernameExists, ContactInfoExists: Boolean;
begin
  SelectedRoleTable := GetSelectedRoleTableName(cmbRegRole);
  Username := edtRegUsername.Text;
  Password := edtRegPassword.Text;
  Name := edtName.Text;
  ContactInfo := edtContactInfo.Text;

  // 1. 输入验证
  if SelectedRoleTable = '' then
  begin
    MessageDlg('请选择要注册的角色。', mtWarning, [mbOK], 0);
    cmbRegRole.SetFocus;
    Exit;
  end;

  if Username = '' then
  begin
    MessageDlg('用户名不能为空。', mtWarning, [mbOK], 0);
    edtRegUsername.SetFocus;
    Exit;
  end;

  if Length(Username) < 3 then
  begin
    lblUsernameHint.Caption := '用户名至少需要3个字符';
    lblUsernameHint.Font.Color := clRed;
    edtRegUsername.SetFocus;
    Exit;
  end;

  if Password = '' then
  begin
    MessageDlg('密码不能为空。', mtWarning, [mbOK], 0);
    edtRegPassword.SetFocus;
    Exit;
  end;
  
  // 验证密码强度
  if not ValidatePassword(Password, PasswordErrMsg) then
  begin
    MessageDlg(PasswordErrMsg, mtWarning, [mbOK], 0);
    edtRegPassword.SetFocus;
    edtRegPassword.SelectAll;
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
  
  // 2. 数据库操作与判重
  try
    // 连接数据库
    DM.Connect;
    
    // 仅在点击注册时进行判重检查
    UsernameExists := CheckUsernameExists(SelectedRoleTable, Username);
    if UsernameExists then
    begin
      lblUsernameHint.Caption := '该用户名已被注册，请选择其他用户名';
      lblUsernameHint.Font.Color := clRed;
      edtRegUsername.SetFocus;
      edtRegUsername.SelectAll;
      Exit;
    end;
    
    ContactInfoExists := CheckContactInfoExists(SelectedRoleTable, ContactInfo);
    if ContactInfoExists then
    begin
      lblContactInfoHint.Caption := '该联系方式已被注册，请使用其他联系方式';
      lblContactInfoHint.Font.Color := clRed;
      edtContactInfo.SetFocus;
      edtContactInfo.SelectAll;
      Exit;
    end;

    // 用户名和联系方式不存在，执行插入操作
    SQLInsert := Format('INSERT INTO %s (username, password_hash, name, contact_info) VALUES (:username, :password_hash, :name, :contact_info)', [SelectedRoleTable]);
    DM.FDQueryRegister.SQL.Text := SQLInsert;
    DM.FDQueryRegister.Params.ParamByName('username').AsString := Username;
    DM.FDQueryRegister.Params.ParamByName('password_hash').AsString := Password; // 使用原始密码 (不安全! 应使用哈希)
    DM.FDQueryRegister.Params.ParamByName('name').AsString := Name;
    DM.FDQueryRegister.Params.ParamByName('contact_info').AsString := ContactInfo;

    DM.FDQueryRegister.ExecSQL; // 执行 INSERT 语句

    MessageDlg('注册成功！现在可以在登录页面使用新账户登录。', mtInformation, [mbOK], 0);

    // Clear registration form and switch to login tab
    edtRegUsername.Text := '';
    edtRegPassword.Text := '';
    edtName.Text := '';
    edtContactInfo.Text := '';
    cmbRegRole.ItemIndex := -1; // Clear selection
    pcLoginRegister.ActivePage := tsLogin; // Switch to login tab
    edtLoginUsername.SetFocus; // Set focus to login username
    edtLoginUsername.Text := Username;
    edtLoginPassword.Text := Password;
  except
    on E: Exception do
    begin
      MessageDlg('注册过程中发生数据库错误: ' + E.Message, mtError, [mbOK], 0);
      // 可以在此记录详细错误日志
    end;
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
