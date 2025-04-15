unit MerchantForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMerchantForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  gMerchantForm: TMerchantForm;

implementation

{$R *.dfm}

procedure TMerchantForm.FormCreate(Sender: TObject);
begin
  Caption := '商家界面';
  // Add merchant-specific initialization code here
end;

end. 
