program takeout;

uses
  Vcl.Forms,
  LoginForm in 'forms\auth\LoginForm.pas' {LoginForm},
  DataModuleUnit in 'data\DataModuleUnit.pas' {DM: TDataModule},
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
  try
    Application.CreateForm(TLoginForm, LoginF);
    Application.Run;
  finally
    // 释放数据模块实例
    if Assigned(DM) then
      DM.Free;
  end;
end.

