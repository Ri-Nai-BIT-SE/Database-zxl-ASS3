unit DataModuleUnit;

interface

uses
    System.SysUtils, System.Classes,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
    FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
    FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
    FireDAC.Comp.UI, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.Stan.Param,
    FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
    Vcl.Dialogs; // 添加Dialogs单元用于ShowMessage

type
    // 定义角色类型枚举
    TRoleType = (rtCustomer, rtMerchant, rtDelivery, rtAdmin);
    
    TDataModuleUnit = class(TDataModule)
    FDConnection: TFDConnection;
    DummyFDQueryForRTTI: TFDQuery; // <-- 添加虚拟字段以确保RTTI
    private
        { Private declarations }
        FCurrentRole: TRoleType;
        
        // 设置不同角色的连接参数
        procedure SetConnectionParams(const Role: TRoleType);
    public
        { Public declarations }
        // 获取当前连接的角色
        property CurrentRole: TRoleType read FCurrentRole;
        
        // 连接数据库的方法 - 使用枚举类型参数
        function Connect(const Role: TRoleType = rtAdmin): Boolean; overload;
        // 连接数据库的方法 - 使用字符串参数（便于从界面直接调用）
        function Connect(const RoleStr: string = 'admin'): Boolean; overload;
        // 通用的连接方法（不指定角色，使用当前设置）
        procedure ConnectDefault; // 重命名以避免歧义
        // 断开数据库连接
        procedure Disconnect;
        // 验证用户凭据
        function VerifyCredentials(const RoleTable, Username, Password: string): Boolean;
        // 获取角色表名
        function GetRoleTableName(const Role: TRoleType): string;
        function GetRoleTypeFromString(const RoleStr: string): TRoleType;
    end;

var
    DM: TDataModuleUnit; // 全局数据模块实例变量

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModuleUnit }

procedure TDataModuleUnit.SetConnectionParams(const Role: TRoleType);
var
    Username, Password: string;
begin
    // 设置数据库连接参数
    FDConnection.Connected := False;
    FDConnection.Params.Clear;
    
    // 所有角色连接都使用同一数据库
    FDConnection.Params.Add('Database=db_takeout');
    FDConnection.Params.Add('Server=192.168.202.129');
    FDConnection.Params.Add('Port=26000');
    FDConnection.Params.Add('DriverID=PG');
    
    // 根据角色设置用户名和密码
    case Role of
        rtCustomer:
        begin
            Username := 'customer';
            Password := 'customer@123';
        end;
        rtMerchant:
        begin
            Username := 'merchant';
            Password := 'merchant@123';
        end;
        rtDelivery:
        begin
            Username := 'delivery_man';
            Password := 'delivery_man@123';
        end;
        rtAdmin:
        begin
            Username := 'takeout_admin';
            Password := 'takeout_admin@123';
        end;
    end;
    
    FDConnection.Params.Add('User_Name=' + Username);
    FDConnection.Params.Add('Password=' + Password);
    
    // 保存当前角色
    FCurrentRole := Role;
end;

function TDataModuleUnit.Connect(const Role: TRoleType): Boolean;
begin
    Result := False;
    
    try
        // 设置连接参数
        SetConnectionParams(Role);
        
        // 尝试连接
        FDConnection.Connected := True;
        Result := FDConnection.Connected;
    except
        on E: Exception do
        begin
            ShowMessage('数据库连接失败: ' + E.Message);
            Result := False;
        end;
    end;
end;

function TDataModuleUnit.Connect(const RoleStr: string): Boolean;
var
    Role: TRoleType;
begin
    Role := GetRoleTypeFromString(RoleStr);
    Result := Connect(Role);
end;

procedure TDataModuleUnit.ConnectDefault;
begin
    // 使用当前设置连接数据库
    if not FDConnection.Connected then
    begin
        try
            FDConnection.Connected := True;
        except
            on E: Exception do
            begin
                ShowMessage('数据库连接失败: ' + E.Message);
                raise; // 重新抛出异常，让调用者知道失败了
            end;
        end;
    end;
end;

procedure TDataModuleUnit.Disconnect;
begin
    if FDConnection.Connected then
    begin
        try
            FDConnection.Connected := False;
        except
            on E: Exception do
            begin
                ShowMessage('断开数据库连接失败: ' + E.Message);
            end;
        end;
    end;
end;

function TDataModuleUnit.GetRoleTableName(const Role: TRoleType): string;
begin
    case Role of
        rtCustomer: Result := 'customer';
        rtMerchant: Result := 'merchant';
        rtDelivery: Result := 'delivery_man';
        rtAdmin: Result := 'admin';
    else
        Result := '';
    end;
end;

function TDataModuleUnit.GetRoleTypeFromString(const RoleStr: string): TRoleType;
begin
    if SameText(RoleStr, 'customer') then
        Result := rtCustomer
    else if SameText(RoleStr, 'merchant') then
        Result := rtMerchant
    else if SameText(RoleStr, 'delivery') then
        Result := rtDelivery
    else if SameText(RoleStr, 'admin') then
        Result := rtAdmin
    else
        Result := rtAdmin; // 默认为管理员角色
end;

function TDataModuleUnit.VerifyCredentials(const RoleTable, Username, Password: string): Boolean;
var
    SQL: string;
    Query: TFDQuery;
begin
    Result := False;
    if (RoleTable = '') or (Username = '') or (Password = '') then
        Exit;

    // 确保已连接
    if not FDConnection.Connected then
        ConnectDefault;

    Query := TFDQuery.Create(nil);
    try
        Query.Connection := FDConnection;
        SQL := Format('SELECT COUNT(*) FROM %s WHERE username = :username AND password_hash = :password', [RoleTable]);
        Query.SQL.Text := SQL;
        Query.Params.ParamByName('username').AsString := Username;
        Query.Params.ParamByName('password').AsString := Password; // 应当使用哈希处理

        try
            Query.Open();
            Result := (Query.Fields[0].AsInteger > 0);
        finally
            Query.Close;
        end;
    finally
        Query.Free;
    end;
end;

initialization
    // 注意：数据模块的创建和销毁通常在项目的主程序文件 (.dpr) 中完成，
    // 以确保正确的生命周期管理。这里仅声明变量。
    // 例如在 .dpr 文件中:
    // Application.Initialize;
    // DM := TDataModuleUnit.Create(nil); // 创建
    // Application.CreateForm(TLoginForm, LoginForm);
    // ...
    // Application.Run;
    // FreeAndNil(DM); // 销毁

end.
