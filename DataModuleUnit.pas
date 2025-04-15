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
    TDataModuleUnit = class(TDataModule)
    FDConnection1: TFDConnection;
    FDQueryLogin: TFDQuery;
    FDQueryRegister: TFDQuery;
    private
    { Private declarations }
    public
    { Public declarations }
    procedure Connect; // 添加一个连接方法（可选但有用）
    function VerifyCredentials(const RoleTable, Username, Password: string): Boolean;
    end;

var
    DM: TDataModuleUnit; // 全局数据模块实例变量

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModuleUnit }

procedure TDataModuleUnit.Connect;
begin
    // 尝试连接数据库，如果尚未连接
    if not FDConnection1.Connected then
    begin
    try
        FDConnection1.Connected := True;
    except
      on E: Exception do
      begin
        // 在实际应用中，这里应该记录错误或显示更友好的消息
        ShowMessage('数据库连接失败: ' + E.Message);
        raise; // 重新抛出异常，让调用者知道失败了
      end;
    end;
    end;
end;

function TDataModuleUnit.VerifyCredentials(const RoleTable, Username, Password: string): Boolean;
var
    SQL: string;
begin
    Result := False;
    if (RoleTable = '') or (Username = '') or (Password = '') then
        Exit;

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
