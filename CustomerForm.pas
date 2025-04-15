unit CustomerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TCustomerForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  gCustomerForm: TCustomerForm;

implementation

{$R *.dfm}

procedure TCustomerForm.FormCreate(Sender: TObject);
begin
  Caption := '消费者界面';
  // Add customer-specific initialization code here
end;

end. 
