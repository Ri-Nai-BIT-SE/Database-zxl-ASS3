unit LoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.UITypes,
  Vcl.ComCtrls, // Added for TPageControl, TTabSheet
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
    procedure btnLoginClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function GetSelectedRoleTableName(RoleComboBox: TComboBox): string; // Modified signature
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

procedure TLoginForm.btnRegisterClick(Sender: TObject);
var
  SelectedRoleTable: string;
  Username, Password, Name, ContactInfo: string; // Removed HashedPassword, added Name, ContactInfo
  SQLCheck, SQLInsert: string;
  UserExists: Boolean;
begin
  SelectedRoleTable := GetSelectedRoleTableName(cmbRegRole); // Use cmbRegRole
  Username := edtRegUsername.Text; // Use registration controls
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

  // Admin registration is implicitly prevented as 'admin' is not in cmbRegRole items

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

  if Name = '' then // Added validation
  begin
    MessageDlg('姓名不能为空。', mtWarning, [mbOK], 0);
    edtName.SetFocus;
    Exit;
  end;

  if ContactInfo = '' then // Added validation
  begin
    MessageDlg('联系方式不能为空。', mtWarning, [mbOK], 0);
    edtContactInfo.SetFocus;
    Exit;
  end;

  // 3. 数据库操作
  try
    // 连接数据库
    DM.Connect;

    // 检查用户名是否已存在
    SQLCheck := Format('SELECT COUNT(*) FROM %s WHERE username = :username', [SelectedRoleTable]);
    DM.FDQueryRegister.SQL.Text := SQLCheck;
    DM.FDQueryRegister.Params.ParamByName('username').AsString := Username;
    
    try
      DM.FDQueryRegister.Open();
      UserExists := (DM.FDQueryRegister.Fields[0].AsInteger > 0);
    finally
      DM.FDQueryRegister.Close; // 关闭检查查询
    end;

    if UserExists then
    begin
      MessageDlg('该用户名已被注册，请选择其他用户名。', mtError, [mbOK], 0);
      edtRegUsername.SetFocus;
      edtRegUsername.SelectAll;
      Exit;
    end;

    // 用户名不存在，执行插入操作
    // 注意：列名 password_hash, name, contact_info 需要与你数据库表结构一致
    // ** SECURITY WARNING: Storing plain text passwords is insecure! **
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

  except
    on E: Exception do
    begin
      MessageDlg('注册过程中发生数据库错误: ' + E.Message, mtError, [mbOK], 0);
      // 可以在此记录详细错误日志
    end;
  end;
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
  // cmbRegRole.ItemIndex := 0; // Optionally default selection

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
