unit DeliveryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TDeliveryForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  gDeliveryForm: TDeliveryForm;

implementation

{$R *.dfm}

procedure TDeliveryForm.FormCreate(Sender: TObject);
begin
  Caption := '配送员界面';
  // Add delivery-specific initialization code here
end;

end. 
