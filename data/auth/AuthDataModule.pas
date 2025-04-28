unit AuthDataModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB, 
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.VCLUI.Wait, Vcl.Dialogs,
  DataModuleUnit, System.Hash;

type
  TAuthDM = class(TDataModule)
    FDQueryLogin: TFDQuery;
    FDQueryRegister: TFDQuery;
    FDQueryCheckExists: TFDQuery;
  private
    { Private declarations }
    // 生成随机盐值
    function GenerateSalt: string;
    // 计算密码哈希值（组合密码和盐值后哈希）
    function HashPassword(const Password, Salt: string): string;
  public
    { Public declarations }
    // 初始化方法 - 设置查询组件的连接
    procedure Initialize;
    
    // 用户登录验证
    function ValidateLogin(const RoleType: TRoleType; const Username, Password: string): Boolean;
    
    // 用户注册方法
    function RegisterUser(const RoleType: TRoleType; const Username, Password, Name, ContactInfo: string;
                          const Address: string = ''; const BusinessAddress: string = ''): Boolean;
    function CheckUsernameExists(const RoleType: TRoleType; const Username: string): Boolean;

    // 检查联系方式是否存在
    function CheckContactInfoExists(const RoleType: TRoleType; const ContactInfo: string): Boolean;
    
    // 获取用户ID
    function GetUserID(const RoleType: TRoleType; const Username: string): Integer;

  end;

var
  AuthDM: TAuthDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

// 生成随机盐值 - 32位十六进制字符串
function TAuthDM.GenerateSalt: string;
var
  GuidStr: TGUID;
begin
  CreateGUID(GuidStr);
  Result := GuidStr.ToString;
  // 移除大括号和连字符
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
end;

// 使用SHA256哈希算法计算密码哈希
function TAuthDM.HashPassword(const Password, Salt: string): string;
begin
  // 组合密码和盐值，然后使用SHA256算法哈希
  Result := THashSHA2.GetHashString(Password + Salt, THashSHA2.TSHA2Version.SHA256);
end;

procedure TAuthDM.Initialize;
begin
  // 确保主数据模块存在
  if not Assigned(DM) then
    Exit;
  
  try
    // 确保查询组件已创建
    if not Assigned(FDQueryLogin) then
      FDQueryLogin := TFDQuery.Create(Self);
      
    if not Assigned(FDQueryRegister) then
      FDQueryRegister := TFDQuery.Create(Self);
      
    if not Assigned(FDQueryCheckExists) then
      FDQueryCheckExists := TFDQuery.Create(Self);
    
    // 设置查询组件的连接 - 这一步需要DM.FDConnection有效
    if Assigned(DM.FDConnection) then
    begin
      FDQueryLogin.Connection := DM.FDConnection;
      FDQueryRegister.Connection := DM.FDConnection;
      FDQueryCheckExists.Connection := DM.FDConnection;
    end
    else
    begin
       ShowMessage('错误：主数据模块的数据库连接未初始化！');
       // 可能需要更健壮的错误处理
    end;
  except
    on E: Exception do
    begin
      ShowMessage('初始化认证模块失败: ' + E.Message);
    end;
  end;
end;

function TAuthDM.ValidateLogin(const RoleType: TRoleType; const Username, Password: string): Boolean;
var
  RoleTable: string;
  SQL: string;
  StoredHash, StoredSalt: string;
  ComputedHash: string;
  CurrentRole: TRoleType;
begin
  Result := False;
  
  // 获取对应的角色表名
  RoleTable := DM.GetRoleTableName(RoleType);
  if RoleTable = '' then
    Exit;
    
  // 保存当前角色
  CurrentRole := DM.CurrentRole;
  
  try
    // 确保以admin权限连接
    if DM.CurrentRole <> rtAdmin then
    begin
      // 断开当前连接
      if DM.FDConnection.Connected then
        DM.Disconnect;
        
      // 以admin权限重新连接
      if not DM.Connect(rtAdmin) then
      begin
        ShowMessage('无法以管理员权限连接数据库，登录验证失败');
        Exit;
      end;
    end;
    
    // 确保连接已初始化
    Initialize;
    
    // 首先获取用户的密码哈希和盐值
    SQL := Format('SELECT password_hash FROM %s WHERE username = :username', [RoleTable]);
    FDQueryLogin.SQL.Text := SQL;
    FDQueryLogin.Params.ParamByName('username').AsString := Username;
    
    try
      FDQueryLogin.Open();
      
      if FDQueryLogin.IsEmpty then
        Exit; // 用户不存在
        
      // 存储的密码哈希值格式为: HASH:SALT
      StoredHash := FDQueryLogin.FieldByName('password_hash').AsString;
      
      // 分离哈希值和盐值
      StoredSalt := Copy(StoredHash, Pos(':', StoredHash) + 1, Length(StoredHash));
      StoredHash := Copy(StoredHash, 1, Pos(':', StoredHash) - 1);
      
      // 使用相同的盐值计算输入密码的哈希值
      ComputedHash := HashPassword(Password, StoredSalt);
      
      // 比较计算的哈希值和存储的哈希值
      Result := (ComputedHash = StoredHash);
    finally
      FDQueryLogin.Close;
    end;
  finally
    // 如果之前不是admin角色，则恢复原来的连接
    if (CurrentRole <> rtAdmin) and (CurrentRole <> DM.CurrentRole) then
    begin
      // 断开admin连接
      DM.Disconnect;
      // 恢复原来的连接
      DM.Connect(CurrentRole);
    end;
  end;
end;

function TAuthDM.RegisterUser(const RoleType: TRoleType; const Username, Password, Name, ContactInfo: string;
                            const Address: string = ''; const BusinessAddress: string = ''): Boolean;
var
  RoleTable: string;
  SQL: string;
  Salt, PasswordHash, CombinedHash: string;
  CurrentRole: TRoleType;
begin
  Result := False;
  
  // 获取对应的角色表名
  RoleTable := DM.GetRoleTableName(RoleType);
  if RoleTable = '' then
    Exit;
    
  // 保存当前角色
  CurrentRole := DM.CurrentRole;
  
  try
    // 确保以admin权限连接
    if DM.CurrentRole <> rtAdmin then
    begin
      // 断开当前连接
      if DM.FDConnection.Connected then
        DM.Disconnect;
        
      // 以admin权限重新连接
      if not DM.Connect(rtAdmin) then
      begin
        ShowMessage('无法以管理员权限连接数据库，注册失败');
        Exit;
      end;
    end;
    
    // 确保连接已初始化
    Initialize;
    
    // 生成盐值并哈希密码
    Salt := GenerateSalt;
    PasswordHash := HashPassword(Password, Salt);
    
    // 组合哈希值和盐值 (格式: HASH:SALT)
    CombinedHash := PasswordHash + ':' + Salt;
    
    // 构建注册SQL语句（根据不同角色构建不同的SQL）
    case RoleType of
      rtCustomer:
        SQL := 'INSERT INTO customer (username, password_hash, name, contact_info, wallet_balance, address) ' +
               'VALUES (:username, :password, :name, :contact, 0.00, :address)';
      rtMerchant:
        SQL := 'INSERT INTO merchant (username, password_hash, name, contact_info, business_address, status) ' +
               'VALUES (:username, :password, :name, :contact, :business_address, ''pending_approval'')';
      rtDelivery:
        SQL := 'INSERT INTO delivery_man (username, password_hash, name, contact_info, status) ' +
               'VALUES (:username, :password, :name, :contact, ''pending_approval'')';
      rtAdmin:
        SQL := 'INSERT INTO admin (username, password_hash, name, contact_info) ' +
               'VALUES (:username, :password, :name, :contact)';
    else
      Exit;
    end;
    
    FDQueryRegister.SQL.Text := SQL;
    FDQueryRegister.Params.ParamByName('username').AsString := Username;
    FDQueryRegister.Params.ParamByName('password').AsString := CombinedHash; // 使用组合的哈希和盐值
    FDQueryRegister.Params.ParamByName('name').AsString := Name;
    FDQueryRegister.Params.ParamByName('contact').AsString := ContactInfo;
    
    // 根据角色设置额外参数
    if (RoleType = rtCustomer) and (FDQueryRegister.Params.FindParam('address') <> nil) then
      FDQueryRegister.Params.ParamByName('address').AsString := Address;
      
    if (RoleType = rtMerchant) and (FDQueryRegister.Params.FindParam('business_address') <> nil) then
      FDQueryRegister.Params.ParamByName('business_address').AsString := BusinessAddress;
    
    try
      FDQueryRegister.ExecSQL;
      Result := FDQueryRegister.RowsAffected > 0;
    except
      on E: Exception do
      begin
        ShowMessage('注册失败: ' + E.Message);
        Result := False;
      end;
    end;
  finally
    // 如果之前不是admin角色，则恢复原来的连接
    if (CurrentRole <> rtAdmin) and (CurrentRole <> DM.CurrentRole) then
    begin
      // 断开admin连接
      DM.Disconnect;
      // 恢复原来的连接
      DM.Connect(CurrentRole);
    end;
  end;
end;

function TAuthDM.CheckUsernameExists(const RoleType: TRoleType; const Username: string): Boolean;
var
  RoleTable: string;
  SQL: string;
  CurrentRole: TRoleType;
begin
  Result := False;

  // 获取对应的角色表名
  RoleTable := DM.GetRoleTableName(RoleType);
  if (RoleTable = '') or (Username = '') then
    Exit;

  // 保存当前角色
  CurrentRole := DM.CurrentRole;
  
  try
    // 确保以admin权限连接
    if DM.CurrentRole <> rtAdmin then
    begin
      // 断开当前连接
      if DM.FDConnection.Connected then
        DM.Disconnect;
        
      // 以admin权限重新连接
      if not DM.Connect(rtAdmin) then
      begin
        ShowMessage('无法以管理员权限连接数据库，检查用户名失败');
        Exit;
      end;
    end;

    // 确保连接已初始化
    Initialize;

    // 执行检查查询
    SQL := Format('SELECT COUNT(*) FROM %s WHERE username = :username', [RoleTable]);
    FDQueryCheckExists.SQL.Text := SQL;
    FDQueryCheckExists.Params.ParamByName('username').AsString := Username;

    try
      FDQueryCheckExists.Open();
      Result := (FDQueryCheckExists.Fields[0].AsInteger > 0);
    finally
      FDQueryCheckExists.Close;
    end;
  finally
    // 如果之前不是admin角色，则恢复原来的连接
    if (CurrentRole <> rtAdmin) and (CurrentRole <> DM.CurrentRole) then
    begin
      // 断开admin连接
      DM.Disconnect;
      // 恢复原来的连接
      DM.Connect(CurrentRole);
    end;
  end;
end;

function TAuthDM.CheckContactInfoExists(const RoleType: TRoleType; const ContactInfo: string): Boolean;
var
  RoleTable: string;
  SQL: string;
  CurrentRole: TRoleType;
begin
  Result := False;

  // 获取对应的角色表名
  RoleTable := DM.GetRoleTableName(RoleType);
  if (RoleTable = '') or (ContactInfo = '') then
    Exit;

  // 保存当前角色
  CurrentRole := DM.CurrentRole;
  
  try
    // 确保以admin权限连接
    if DM.CurrentRole <> rtAdmin then
    begin
      // 断开当前连接
      if DM.FDConnection.Connected then
        DM.Disconnect;
        
      // 以admin权限重新连接
      if not DM.Connect(rtAdmin) then
      begin
        ShowMessage('无法以管理员权限连接数据库，检查联系方式失败');
        Exit;
      end;
    end;

    // 确保连接已初始化
    Initialize;

    // 执行检查查询
    SQL := Format('SELECT COUNT(*) FROM %s WHERE contact_info = :contact_info', [RoleTable]);
    FDQueryCheckExists.SQL.Text := SQL;
    FDQueryCheckExists.Params.ParamByName('contact_info').AsString := ContactInfo;

    try
      FDQueryCheckExists.Open();
      Result := (FDQueryCheckExists.Fields[0].AsInteger > 0);
    finally
      FDQueryCheckExists.Close;
    end;
  finally
    // 如果之前不是admin角色，则恢复原来的连接
    if (CurrentRole <> rtAdmin) and (CurrentRole <> DM.CurrentRole) then
    begin
      // 断开admin连接
      DM.Disconnect;
      // 恢复原来的连接
      DM.Connect(CurrentRole);
    end;
  end;
end;

function TAuthDM.GetUserID(const RoleType: TRoleType; const Username: string): Integer;
var
  RoleTable: string;
  IDField: string;
  SQL: string;
  CurrentRole: TRoleType;
begin
  Result := -1; // 默认返回-1表示未找到
  
  // 获取对应的角色表名和ID字段名
  RoleTable := DM.GetRoleTableName(RoleType);
  if (RoleTable = '') or (Username = '') then
    Exit;
    
  // 设置每种角色的ID字段名
  case RoleType of
    rtCustomer: IDField := 'customer_id';
    rtMerchant: IDField := 'merchant_id';
    rtDelivery: IDField := 'delivery_man_id';
    rtAdmin: IDField := 'admin_id';
  else
    Exit;
  end;
  
  // 保存当前角色
  CurrentRole := DM.CurrentRole;
  
  try
    // 确保以admin权限连接
    if DM.CurrentRole <> rtAdmin then
    begin
      // 断开当前连接
      if DM.FDConnection.Connected then
        DM.Disconnect;
        
      // 以admin权限重新连接
      if not DM.Connect(rtAdmin) then
      begin
        ShowMessage('无法以管理员权限连接数据库，获取用户ID失败');
        Exit;
      end;
    end;
  
    // 确保连接已初始化
    Initialize;
    
    // 执行查询获取ID
    SQL := Format('SELECT %s FROM %s WHERE username = :username', [IDField, RoleTable]);
    FDQueryCheckExists.SQL.Text := SQL;
    FDQueryCheckExists.Params.ParamByName('username').AsString := Username;
    
    try
      FDQueryCheckExists.Open();
      if not FDQueryCheckExists.IsEmpty then
        Result := FDQueryCheckExists.Fields[0].AsInteger;
    finally
      FDQueryCheckExists.Close;
    end;
  finally
    // 如果之前不是admin角色，则恢复原来的连接
    if (CurrentRole <> rtAdmin) and (CurrentRole <> DM.CurrentRole) then
    begin
      // 断开admin连接
      DM.Disconnect;
      // 恢复原来的连接
      DM.Connect(CurrentRole);
    end;
  end;
end;

end. 
