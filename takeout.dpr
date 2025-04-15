program takeout;

uses
  Vcl.Forms,
  LoginForm in 'LoginForm.pas' {LoginForm},
  DataModuleUnit in 'DataModuleUnit.pas' {DM: TDataModule};
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

