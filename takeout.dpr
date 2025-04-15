program takeout;

uses
  Vcl.Forms,
  // 添加FireDAC核心组件单元
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  // PostgreSQL驱动
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  
  LoginForm in 'forms\auth\LoginForm.pas' {LoginForm},
  DataModuleUnit in 'data\DataModuleUnit.pas' {DM: TDataModule},
  AuthDataModule in 'data\auth\AuthDataModule.pas' {AuthDM: TDataModule},
  CustomerForm in 'forms\customer\CustomerForm.pas' {CustomerForm},
  MerchantForm in 'forms\merchant\MerchantForm.pas' {MerchantForm},
  DeliveryForm in 'forms\delivery\DeliveryForm.pas' {DeliveryForm},
  AdminForm in 'forms\admin\AdminForm.pas' {AdminForm};

// 新的登录窗体

{$R *.res}
var
  LoginF: TLoginForm;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  
  // 创建数据模块实例
  DM := TDataModuleUnit.Create(nil);
  AuthDM := TAuthDM.Create(nil); // 在这里创建AuthDM
  try
    // 初始化认证数据模块
    if Assigned(AuthDM) then
      AuthDM.Initialize;
      
    Application.CreateForm(TLoginForm, LoginF);
    Application.Run;
  finally
    // 释放数据模块实例
    if Assigned(DM) then
      DM.Free;
  end;
end.

