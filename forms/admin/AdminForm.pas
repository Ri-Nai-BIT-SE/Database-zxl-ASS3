unit AdminForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, 
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.Stan.Param, 
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Vcl.Grids, Vcl.DBGrids, 
  FireDAC.Comp.DataSet, Vcl.DBCtrls, Vcl.Mask, Vcl.Buttons;

type
  TAdminForm = class(TForm)
    DBConnect: TFDConnection;
    PageControl: TPageControl;
    TabMerchant: TTabSheet;
    TabDelivery: TTabSheet;
    TabOrder: TTabSheet;
    TabStats: TTabSheet;
    pnlMerchant: TPanel;
    lblMerchantTitle: TLabel;
    gridMerchant: TDBGrid;
    navMerchant: TDBNavigator;
    dsMerchant: TDataSource;
    qryMerchant: TFDQuery;
    pnlMerchantFilter: TPanel;
    lblMerchantStatus: TLabel;
    cmbMerchantStatus: TComboBox;
    btnFilterMerchant: TButton;
    btnResetMerchant: TButton;
    pnlDelivery: TPanel;
    lblDeliveryTitle: TLabel;
    gridDelivery: TDBGrid;
    navDelivery: TDBNavigator;
    dsDelivery: TDataSource;
    qryDelivery: TFDQuery;
    pnlDeliveryFilter: TPanel;
    lblDeliveryStatus: TLabel;
    cmbDeliveryStatus: TComboBox;
    btnFilterDelivery: TButton;
    btnResetDelivery: TButton;
    pnlOrder: TPanel;
    lblOrderTitle: TLabel;
    gridOrder: TDBGrid;
    navOrder: TDBNavigator;
    dsOrder: TDataSource;
    qryOrder: TFDQuery;
    pnlOrderFilter: TPanel;
    lblOrderStatus: TLabel;
    cmbOrderStatus: TComboBox;
    btnFilterOrder: TButton;
    btnResetOrder: TButton;
    pnlStats: TPanel;
    lblStatsTitle: TLabel;
    gboxDateRange: TGroupBox;
    lblStartDate: TLabel;
    lblEndDate: TLabel;
    dtpStartDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    btnGenerateStats: TButton;
    pnlRevenueStats: TPanel;
    lblTotalRevenue: TLabel;
    lblRevenueValue: TLabel;
    pnlOrderStats: TPanel;
    lblTotalOrders: TLabel;
    lblOrdersValue: TLabel;
    tmpQuery: TFDQuery;
    
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabMerchantShow(Sender: TObject);
    procedure TabDeliveryShow(Sender: TObject);
    procedure TabOrderShow(Sender: TObject);
    procedure TabStatsShow(Sender: TObject);
    procedure btnFilterMerchantClick(Sender: TObject);
    procedure btnResetMerchantClick(Sender: TObject);
    procedure btnFilterDeliveryClick(Sender: TObject);
    procedure btnResetDeliveryClick(Sender: TObject);
    procedure btnFilterOrderClick(Sender: TObject);
    procedure btnResetOrderClick(Sender: TObject);
    procedure btnGenerateStatsClick(Sender: TObject);
    procedure qryMerchantAfterPost(DataSet: TDataSet);
    procedure qryDeliveryAfterPost(DataSet: TDataSet);
  private
    procedure ConnectToDatabase;
  public
    class procedure ShowAdminForm;
  end;

var
  gAdminForm: TAdminForm;

implementation

{$R *.dfm}

uses
  DataModuleUnit;

class procedure TAdminForm.ShowAdminForm;
begin
  // 确保只创建一个实例
  if not Assigned(gAdminForm) then
    Application.CreateForm(TAdminForm, gAdminForm);
    
  // 显示窗体
  gAdminForm.Show;
end;

procedure TAdminForm.ConnectToDatabase;
begin
  // 确保数据模块已连接
  if not Assigned(DM) then
    Exit;
    
  // 使用管理员角色连接
  if not DM.Connect(rtAdmin) then
    Exit;
    
  // 设置当前窗体的数据库连接
  DBConnect.ConnectionString := DM.FDConnection1.ConnectionString;
  DBConnect.Connected := True;
  
  // 设置所有查询的连接
  tmpQuery.Connection := DBConnect;
  qryMerchant.Connection := DBConnect;
  qryDelivery.Connection := DBConnect;
  qryOrder.Connection := DBConnect;
end;

procedure TAdminForm.FormCreate(Sender: TObject);
begin
  Caption := '管理员界面';
  
  // 初始化ComboBox
  with cmbMerchantStatus.Items do begin
    Add('');
    Add('pending_approval');
    Add('active');
    Add('inactive');
    Add('rejected');
    Add('suspended');
  end;
  
  with cmbDeliveryStatus.Items do begin
    Add('');
    Add('pending_approval');
    Add('active_available');
    Add('active_delivering');
    Add('inactive');
    Add('rejected');
  end;
  
  with cmbOrderStatus.Items do begin
    Add('');
    Add('pending');
    Add('processing');
    Add('delivering');
    Add('delivered');
    Add('cancelled');
  end;
  
  // 设置默认日期范围
  dtpStartDate.Date := Date - 30;
  dtpEndDate.Date := Date;
end;

procedure TAdminForm.FormShow(Sender: TObject);
begin
  // 连接数据库并加载初始数据
  ConnectToDatabase;
  
  // 显示初始页签的数据
  case PageControl.ActivePageIndex of
    0: TabMerchantShow(Sender);
    1: TabDeliveryShow(Sender);
    2: TabOrderShow(Sender);
    3: TabStatsShow(Sender);
  else
    TabMerchantShow(Sender);
  end;
end;

procedure TAdminForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // 断开数据库连接
  if DBConnect.Connected then
    DBConnect.Connected := False;
    
  Action := caFree;
  gAdminForm := nil; // 清除全局引用
end;

procedure TAdminForm.TabMerchantShow(Sender: TObject);
var
  SQL: string;
begin
  SQL := 'SELECT merchant_id, username, name, contact_info, business_address, status FROM merchant';
  
  if cmbMerchantStatus.Text <> '' then
    SQL := SQL + ' WHERE status = ' + QuotedStr(cmbMerchantStatus.Text);
    
  SQL := SQL + ' ORDER BY merchant_id';
  
  qryMerchant.Close;
  qryMerchant.SQL.Text := SQL;
  qryMerchant.Open;
end;

procedure TAdminForm.TabDeliveryShow(Sender: TObject);
var
  SQL: string;
begin
  SQL := 'SELECT delivery_man_id, username, name, contact_info, status FROM delivery_man';
  
  if cmbDeliveryStatus.Text <> '' then
    SQL := SQL + ' WHERE status = ' + QuotedStr(cmbDeliveryStatus.Text);
    
  SQL := SQL + ' ORDER BY delivery_man_id';
  
  qryDelivery.Close;
  qryDelivery.SQL.Text := SQL;
  qryDelivery.Open;
end;

procedure TAdminForm.TabOrderShow(Sender: TObject);
var
  SQL: string;
begin
  SQL := 'SELECT o.order_id, c.name as customer_name, m.name as merchant_name, ' +
         'COALESCE(d.name, ''未分配'') as delivery_name, o.total_amount, o.status, ' +
         'o.created_at, o.updated_at ' +
         'FROM order_info o ' +
         'JOIN customer c ON o.customer_id = c.customer_id ' +
         'JOIN merchant m ON o.merchant_id = m.merchant_id ' +
         'LEFT JOIN delivery_man d ON o.delivery_man_id = d.delivery_man_id';
  
  if cmbOrderStatus.Text <> '' then
    SQL := SQL + ' WHERE o.status = ' + QuotedStr(cmbOrderStatus.Text);
    
  SQL := SQL + ' ORDER BY o.order_id';
  
  qryOrder.Close;
  qryOrder.SQL.Text := SQL;
  qryOrder.Open;
end;

procedure TAdminForm.TabStatsShow(Sender: TObject);
begin
  btnGenerateStatsClick(nil);
end;

procedure TAdminForm.btnFilterMerchantClick(Sender: TObject);
begin
  TabMerchantShow(Sender);
end;

procedure TAdminForm.btnResetMerchantClick(Sender: TObject);
begin
  cmbMerchantStatus.ItemIndex := 0;
  TabMerchantShow(Sender);
end;

procedure TAdminForm.btnFilterDeliveryClick(Sender: TObject);
begin
  TabDeliveryShow(Sender);
end;

procedure TAdminForm.btnResetDeliveryClick(Sender: TObject);
begin
  cmbDeliveryStatus.ItemIndex := 0;
  TabDeliveryShow(Sender);
end;

procedure TAdminForm.btnFilterOrderClick(Sender: TObject);
begin
  TabOrderShow(Sender);
end;

procedure TAdminForm.btnResetOrderClick(Sender: TObject);
begin
  cmbOrderStatus.ItemIndex := 0;
  TabOrderShow(Sender);
end;

procedure TAdminForm.qryMerchantAfterPost(DataSet: TDataSet);
begin
  TabMerchantShow(nil);
end;

procedure TAdminForm.qryDeliveryAfterPost(DataSet: TDataSet);
begin
  TabDeliveryShow(nil);
end;

procedure TAdminForm.btnGenerateStatsClick(Sender: TObject);
var
  TotalRevenue: Double;
  TotalOrders: Integer;
  SQL: string;
  StartDate, EndDate: TDateTime;
begin
  StartDate := dtpStartDate.Date;
  EndDate := dtpEndDate.Date;
  
  // 计算总收入
  SQL := 'SELECT COALESCE(SUM(total_amount), 0) as total_revenue ' +
         'FROM order_info ' +
         'WHERE status = ''delivered'' ' +
         'AND created_at >= :start_date ' +
         'AND created_at <= :end_date';
  
  tmpQuery.Close;
  tmpQuery.SQL.Text := SQL;
  tmpQuery.ParamByName('start_date').AsDate := StartDate;
  tmpQuery.ParamByName('end_date').AsDate := EndDate + 1;  // 加1天以包含结束日期当天
  tmpQuery.Open;
  
  TotalRevenue := tmpQuery.FieldByName('total_revenue').AsFloat;
  lblRevenueValue.Caption := FormatFloat('#,##0.00', TotalRevenue) + ' 元';
  
  // 计算订单总数
  SQL := 'SELECT COUNT(*) as total_orders ' +
         'FROM order_info ' +
         'WHERE created_at >= :start_date ' +
         'AND created_at <= :end_date';
  
  tmpQuery.Close;
  tmpQuery.SQL.Text := SQL;
  tmpQuery.ParamByName('start_date').AsDate := StartDate;
  tmpQuery.ParamByName('end_date').AsDate := EndDate + 1;  // 加1天以包含结束日期当天
  tmpQuery.Open;
  
  TotalOrders := tmpQuery.FieldByName('total_orders').AsInteger;
  lblOrdersValue.Caption := IntToStr(TotalOrders) + ' 单';
end;

end. 
