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
  FireDAC.Comp.DataSet, Vcl.DBCtrls, Vcl.Mask, Vcl.Buttons,
  System.Generics.Collections;

type
  TAdminForm = class(TForm)
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
    procedure AdjustGridColumnWidths(AGrid: TDBGrid; const AColumnWidths: TDictionary<string, Integer>);
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
  begin
    ShowMessage('数据库连接失败！请检查数据库服务是否运行以及连接配置是否正确。');
    Exit; // 连接失败，退出
  end;

  // 设置所有查询的连接为 DataModule 的连接
  tmpQuery.Connection := DM.FDConnection;
  qryMerchant.Connection := DM.FDConnection;
  qryDelivery.Connection := DM.FDConnection;
  qryOrder.Connection := DM.FDConnection;
end;

procedure TAdminForm.FormCreate(Sender: TObject);
begin
  ConnectToDatabase;
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
  // 需要手动调用 TabSheetShow
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
  // 不再需要断开窗体自己的连接
  Action := caFree;
  gAdminForm := nil; // 清除全局引用
end;

procedure TAdminForm.AdjustGridColumnWidths(AGrid: TDBGrid; const AColumnWidths: TDictionary<string, Integer>);
var
  I: Integer;
  Col: TColumn;
  FieldName: string;
  Width: Integer;
begin
  if not Assigned(AGrid) or not Assigned(AColumnWidths) or (AGrid.Columns.Count = 0) then
    Exit; // Exit if grid or dictionary is not assigned, or grid has no columns

  try
    // Iterate through the grid's columns
    for I := 0 to AGrid.Columns.Count - 1 do
    begin
      Col := AGrid.Columns[I];
      FieldName := Col.FieldName;

      // Check if this field name exists in the dictionary
      if AColumnWidths.TryGetValue(FieldName, Width) then
      begin
        Col.Width := Width; // Set the width from the dictionary
      end;
      // Optional: Set a default width for columns not in the dictionary
      // else begin
      //   Col.Width := 100; // Example default width
      // end;
    end;
  except
    on E: Exception do
      // Silently ignore errors during width adjustment
      // Consider logging the error: Log.d('Error adjusting column widths: ' + E.Message);
      ;
  end;
end;

procedure TAdminForm.TabMerchantShow(Sender: TObject);
var
  SQL: string;
  MerchantWidths: TDictionary<string, Integer>;
begin
  SQL := 'SELECT merchant_id, username, name, contact_info, business_address, status FROM merchant';

  if cmbMerchantStatus.Text <> '' then
    SQL := SQL + ' WHERE status = ' + QuotedStr(cmbMerchantStatus.Text);

  SQL := SQL + ' ORDER BY merchant_id';

  qryMerchant.Close;
  qryMerchant.SQL.Text := SQL;
  qryMerchant.Open;

  // Adjust column widths after opening the query
  if qryMerchant.Active then
  begin
    MerchantWidths := TDictionary<string, Integer>.Create;
    try
      // Define desired widths for merchant grid
      MerchantWidths.AddOrSetValue('merchant_id', 80);
      MerchantWidths.AddOrSetValue('username', 120);
      MerchantWidths.AddOrSetValue('name', 150);
      MerchantWidths.AddOrSetValue('contact_info', 180);
      MerchantWidths.AddOrSetValue('business_address', 220);
      MerchantWidths.AddOrSetValue('status', 80);

      AdjustGridColumnWidths(gridMerchant, MerchantWidths);
    finally
      MerchantWidths.Free;
    end;
  end;
end;

procedure TAdminForm.TabDeliveryShow(Sender: TObject);
var
  SQL: string;
  DeliveryWidths: TDictionary<string, Integer>;
begin
  SQL := 'SELECT delivery_man_id, username, name, contact_info, status FROM delivery_man';
  
  if cmbDeliveryStatus.Text <> '' then
    SQL := SQL + ' WHERE status = ' + QuotedStr(cmbDeliveryStatus.Text);
    
  SQL := SQL + ' ORDER BY delivery_man_id';
  
  qryDelivery.Close;
  qryDelivery.SQL.Text := SQL;
  qryDelivery.Open;

  // Adjust column widths after opening the query
  if qryDelivery.Active then
  begin
    DeliveryWidths := TDictionary<string, Integer>.Create;
    try
      // Define desired widths for delivery grid
      DeliveryWidths.AddOrSetValue('delivery_man_id', 80);
      DeliveryWidths.AddOrSetValue('username', 120);
      DeliveryWidths.AddOrSetValue('name', 150);
      DeliveryWidths.AddOrSetValue('contact_info', 180);
      DeliveryWidths.AddOrSetValue('status', 100);

      AdjustGridColumnWidths(gridDelivery, DeliveryWidths);
    finally
      DeliveryWidths.Free;
    end;
  end;
end;

procedure TAdminForm.TabOrderShow(Sender: TObject);
var
  SQL: string;
  OrderWidths: TDictionary<string, Integer>;
begin
  // Use v_order_details view
  SQL := 'SELECT order_id, customer_name, merchant_name, ' +
         'COALESCE(delivery_man_name, ''未分配'') as delivery_name, total_amount, order_status as status, ' + // Use aliases from the view/query
         'created_at, updated_at ' +
         'FROM v_order_details';

  if cmbOrderStatus.Text <> '' then
    // Filter by order_status from the view
    SQL := SQL + ' WHERE order_status = ' + QuotedStr(cmbOrderStatus.Text);

  SQL := SQL + ' ORDER BY order_id';

  qryOrder.Close;
  qryOrder.SQL.Text := SQL;
  qryOrder.Open;

  // Adjust column widths after opening the query
  if qryOrder.Active then
  begin
    OrderWidths := TDictionary<string, Integer>.Create;
    try
      // Define desired widths for order grid (use aliases/final names)
      OrderWidths.AddOrSetValue('order_id', 70);
      OrderWidths.AddOrSetValue('customer_name', 120);
      OrderWidths.AddOrSetValue('merchant_name', 150);
      OrderWidths.AddOrSetValue('delivery_name', 120); // Alias from COALESCE
      OrderWidths.AddOrSetValue('total_amount', 90);
      OrderWidths.AddOrSetValue('status', 100);        // Alias from order_status
      OrderWidths.AddOrSetValue('created_at', 140);
      OrderWidths.AddOrSetValue('updated_at', 140);

      AdjustGridColumnWidths(gridOrder, OrderWidths);
    finally
      OrderWidths.Free;
    end;
  end;
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

  // 计算总收入 - 使用 v_order_details 视图
  SQL := 'SELECT COALESCE(SUM(total_amount), 0) as total_revenue ' +
         'FROM v_order_details ' +
         'WHERE order_status = ''delivered'' ' + // 按视图中的 order_status 过滤
         'AND created_at >= :start_date ' +
         'AND created_at <= :end_date'; // 注意：结束日期处理保持不变

  tmpQuery.Close;
  tmpQuery.SQL.Text := SQL;
  tmpQuery.ParamByName('start_date').AsDate := StartDate;
  tmpQuery.ParamByName('end_date').AsDate := EndDate + 1;  // 加1天以包含结束日期当天
  tmpQuery.Open;

  TotalRevenue := tmpQuery.FieldByName('total_revenue').AsFloat;
  lblRevenueValue.Caption := FormatFloat('#,##0.00', TotalRevenue) + ' 元';

  // 计算订单总数 - 这个查询不需要 total_amount，保持不变
  SQL := 'SELECT COUNT(*) as total_orders ' +
         'FROM order_info ' + // 这里可以直接查 order_info 获取总数
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
