unit AuthDataModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB, 
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.VCLUI.Wait, Vcl.Dialogs,
  DataModuleUnit;

type
  TAuthDM = class(TDataModule)
    FDQueryLogin: TFDQuery;
    FDQueryRegister: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    // 初始化方法 - 设置查询组件的连接
    procedure Initialize;
    
    // 用户登录验证
    function ValidateLogin(const RoleType: TRoleType; const Username, Password: string): Boolean;
    
    // 用户注册方法
    function RegisterUser(const RoleType: TRoleType; const Username, Password, Name, ContactInfo: string;
                          const Address: string = ''; const BusinessAddress: string = ''): Boolean;
  end;

var
  AuthDM: TAuthDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

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
    
    // 设置查询组件的连接 - 这一步需要DM.FDConnection有效
    if Assigned(DM.FDConnection) then
    begin
      FDQueryLogin.Connection := DM.FDConnection;
      FDQueryRegister.Connection := DM.FDConnection;
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
begin
  Result := False;
  
  // 获取对应的角色表名
  RoleTable := DM.GetRoleTableName(RoleType);
  if RoleTable = '' then
    Exit;
    
  // 确保连接已初始化
  Initialize;
  
  // 执行登录验证查询
  SQL := Format('SELECT COUNT(*) FROM %s WHERE username = :username AND password_hash = :password', [RoleTable]);
  FDQueryLogin.SQL.Text := SQL;
  FDQueryLogin.Params.ParamByName('username').AsString := Username;
  FDQueryLogin.Params.ParamByName('password').AsString := Password; // 应当使用哈希处理
  
  try
    FDQueryLogin.Open();
    Result := (FDQueryLogin.Fields[0].AsInteger > 0);
  finally
    FDQueryLogin.Close;
  end;
end;

function TAuthDM.RegisterUser(const RoleType: TRoleType; const Username, Password, Name, ContactInfo: string;
                            const Address: string = ''; const BusinessAddress: string = ''): Boolean;
var
  RoleTable: string;
  SQL: string;
begin
  Result := False;
  
  // 获取对应的角色表名
  RoleTable := DM.GetRoleTableName(RoleType);
  if RoleTable = '' then
    Exit;
    
  // 确保连接已初始化
  Initialize;
  
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
  FDQueryRegister.Params.ParamByName('password').AsString := Password; // 应当使用哈希处理
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
end;

end. 
