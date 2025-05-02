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
  System.Generics.Collections, System.JSON, OrderStatus;

type
  TAdminForm = class(TForm)
    PageControl: TPageControl;
    TabMerchant: TTabSheet;
    TabDelivery: TTabSheet;
    TabOrder: TTabSheet;
    TabStats: TTabSheet;
    TabCustomer: TTabSheet;
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
    pnlCustomer: TPanel;
    lblCustomerTitle: TLabel;
    gridCustomer: TDBGrid;
    navCustomer: TDBNavigator;
    pnlCustomerFilter: TPanel;
    lblWalletBalance: TLabel;
    edtWalletBalance: TEdit;
    btnFilterCustomer: TButton;
    btnResetCustomer: TButton;
    dsCustomer: TDataSource;
    qryCustomer: TFDQuery;
    // 订单详情相关组件
    qryOrderDetails: TFDQuery;
    qryOrderHistory: TFDQuery;
    btnOrderDetails: TButton;
    
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabMerchantShow(Sender: TObject);
    procedure TabDeliveryShow(Sender: TObject);
    procedure TabOrderShow(Sender: TObject);
    procedure TabStatsShow(Sender: TObject);
    procedure TabCustomerShow(Sender: TObject);
    procedure btnFilterMerchantClick(Sender: TObject);
    procedure btnResetMerchantClick(Sender: TObject);
    procedure btnFilterDeliveryClick(Sender: TObject);
    procedure btnResetDeliveryClick(Sender: TObject);
    procedure btnFilterOrderClick(Sender: TObject);
    procedure btnResetOrderClick(Sender: TObject);
    procedure btnFilterCustomerClick(Sender: TObject);
    procedure btnResetCustomerClick(Sender: TObject);
    procedure btnGenerateStatsClick(Sender: TObject);
    procedure qryMerchantAfterPost(DataSet: TDataSet);
    procedure qryDeliveryAfterPost(DataSet: TDataSet);
    procedure qryOrderAfterPost(DataSet: TDataSet);
    procedure qryCustomerAfterPost(DataSet: TDataSet);
    procedure GetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure qryMerchantAfterOpen(DataSet: TDataSet);
    procedure qryDeliveryAfterOpen(DataSet: TDataSet);
    procedure qryOrderAfterOpen(DataSet: TDataSet);
    procedure qryCustomerAfterOpen(DataSet: TDataSet);
    procedure btnOrderDetailsClick(Sender: TObject);
    procedure btnCloseDetailsClick(Sender: TObject);
    procedure gridOrderCellClick(Column: TColumn);
  private
    // 订单详情相关字段和方法
    selectedOrderID: Integer;
    dlgOrderDetails: TForm;
    pnlOrderInfo: TPanel;
    lblOrderID: TLabel;
    lblOrderStatus: TLabel;
    lblOrderTime: TLabel;
    lblCustomerInfo: TLabel;
    lblMerchantInfo: TLabel;
    lblDeliveryManInfo: TLabel;
    gridOrderItems: TStringGrid;
    memoOrderHistory: TMemo;
    btnCloseDetails: TButton;
    procedure ConnectToDatabase;
    procedure AdjustGridColumnWidths(AGrid: TDBGrid; const AColumnWidths: TDictionary<string, Integer>);
    procedure InitializeOrderDetailsDialog;
    procedure ShowEnhancedOrderDetails(OrderID: Integer);
    procedure LoadOrderStatusHistory(OrderID: Integer);
  public
    class procedure ShowAdminForm;
    function GetStatusDescription(const Status: string; const MerchantID: Integer = 0; const DeliveryManID: Integer = 0): string;
    procedure UpdateOrderStatusDisplay(ALabel: TLabel; const Status: string);
    procedure FormatOrderTimeline(const JsonStr: string; var FormattedText: string);
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
  qryCustomer.Connection := DM.FDConnection;
  qryOrder.Connection := DM.FDConnection;

  // 为订单详情相关的查询组件设置连接
  if Assigned(qryOrderDetails) then
    qryOrderDetails.Connection := DM.FDConnection;
  
  if Assigned(qryOrderHistory) then
    qryOrderHistory.Connection := DM.FDConnection;
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
  dtpStartDate.Date := Date - 30;  // 默认显示过去30天
  dtpEndDate.Date := Date;         // 默认结束日期为今天

  // 初始化订单详情相关变量
  selectedOrderID := -1;
  
  // 确保查询组件已创建
  if not Assigned(qryOrderDetails) then
    qryOrderDetails := TFDQuery.Create(Self);
  
  if not Assigned(qryOrderHistory) then
    qryOrderHistory := TFDQuery.Create(Self);
    
  // 确保设置连接
  if Assigned(qryOrderDetails) then
    qryOrderDetails.Connection := DM.FDConnection;
  
  if Assigned(qryOrderHistory) then
    qryOrderHistory.Connection := DM.FDConnection;
end;

procedure TAdminForm.FormShow(Sender: TObject);
begin
  // 需要手动调用 TabSheetShow
  case PageControl.ActivePageIndex of
    0: TabMerchantShow(Sender);
    1: TabDeliveryShow(Sender);
    2: TabCustomerShow(Sender);
    3: TabOrderShow(Sender);
    4: TabStatsShow(Sender);
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
begin
  // 查询所有订单
  qryOrder.Close;
  qryOrder.SQL.Text := 
    'SELECT ' +
    '  o.order_id, ' +
    '  o.customer_id, ' +
    '  o.merchant_id, ' +
    '  o.delivery_man_id, ' +
    '  o.status, ' +
    '  o.created_at, ' +
    '  o.updated_at ' +
    'FROM order_info o ';
  
  // 添加筛选条件
  if cmbOrderStatus.Text <> '' then
  begin
    qryOrder.SQL.Add('WHERE o.status = :status');
    qryOrder.ParamByName('status').AsString := cmbOrderStatus.Text;
  end;
  
  qryOrder.SQL.Add('ORDER BY o.created_at DESC');
  qryOrder.Open;
  
  // 设置列标题
  if qryOrder.Active and (qryOrder.FieldCount > 0) then
  begin
    qryOrder.FieldByName('order_id').DisplayLabel := '订单编号';
    qryOrder.FieldByName('customer_id').DisplayLabel := '顾客编号';
    qryOrder.FieldByName('merchant_id').DisplayLabel := '商家编号';
    qryOrder.FieldByName('delivery_man_id').DisplayLabel := '配送员编号';
    qryOrder.FieldByName('status').DisplayLabel := '状态';
    qryOrder.FieldByName('created_at').DisplayLabel := '创建时间';
    qryOrder.FieldByName('updated_at').DisplayLabel := '更新时间';
  end;
  
  // 调整列宽...
  
  // 设置网格单元格点击事件
  gridOrder.OnCellClick := gridOrderCellClick;
  
  // 添加订单详情按钮
  if not Assigned(btnOrderDetails) then
  begin
    btnOrderDetails := TButton.Create(Self);
    with btnOrderDetails do
    begin
      Parent := pnlOrderFilter;
      Caption := '订单详情';
      Left := btnResetOrder.Left + btnResetOrder.Width + 20;
      Top := btnResetOrder.Top;
      Width := 120;
      Height := btnResetOrder.Height;
      OnClick := btnOrderDetailsClick;
      Enabled := False; // 初始状态下禁用按钮
    end;
  end;
end;

procedure TAdminForm.TabStatsShow(Sender: TObject);
begin
  // 自动生成统计，使用当前设置的日期范围
  btnGenerateStatsClick(nil);
end;

procedure TAdminForm.TabCustomerShow(Sender: TObject);
var
  SQL: string;
  CustomerWidths: TDictionary<string, Integer>;
begin
  SQL := 'SELECT customer_id, username, name, contact_info, wallet_balance, address FROM customer';

  if edtWalletBalance.Text <> '' then
    SQL := SQL + ' WHERE wallet_balance >= ' + edtWalletBalance.Text;

  SQL := SQL + ' ORDER BY customer_id';

  qryCustomer.Close;
  qryCustomer.SQL.Text := SQL;
  qryCustomer.Open;

  // Adjust column widths after opening the query
  if qryCustomer.Active then
  begin
    CustomerWidths := TDictionary<string, Integer>.Create;
    try
      // Define desired widths for customer grid
      CustomerWidths.AddOrSetValue('customer_id', 80);
      CustomerWidths.AddOrSetValue('username', 120);
      CustomerWidths.AddOrSetValue('name', 150);
      CustomerWidths.AddOrSetValue('contact_info', 180);
      CustomerWidths.AddOrSetValue('wallet_balance', 100);
      CustomerWidths.AddOrSetValue('address', 200);

      AdjustGridColumnWidths(gridCustomer, CustomerWidths);
    finally
      CustomerWidths.Free;
    end;
  end;
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

procedure TAdminForm.btnFilterCustomerClick(Sender: TObject);
begin
  TabCustomerShow(Sender);
end;

procedure TAdminForm.btnResetCustomerClick(Sender: TObject);
begin
  edtWalletBalance.Text := '';
  TabCustomerShow(Sender);
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

  // 计算平台总收入 - 使用func_calculate_all_earnings函数（平台收益率为10%）
  SQL := 'SELECT func_calculate_all_earnings(''platform'', NULL, :start_date, :end_date, 0.1) as total_revenue';

  tmpQuery.Close;
  tmpQuery.SQL.Text := SQL;
  tmpQuery.ParamByName('start_date').AsDate := StartDate;
  tmpQuery.ParamByName('end_date').AsDate := EndDate;
  tmpQuery.Open;

  TotalRevenue := tmpQuery.FieldByName('total_revenue').AsFloat;
  lblRevenueValue.Caption := FormatFloat('#,##0.00', TotalRevenue) + ' 元';

  // 计算订单总数 - 使用同样的视图进行一致的筛选
  SQL := 'SELECT COUNT(*) as total_orders ' +
         'FROM v_order_details ' + // 改为使用视图以保持筛选条件一致
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

procedure TAdminForm.qryMerchantAfterPost(DataSet: TDataSet);
begin
  TabMerchantShow(nil);
end;

procedure TAdminForm.qryMerchantAfterOpen(DataSet: TDataSet);
begin
  // 处理TEXT类型字段显示问题，设置OnGetText事件处理器
  if qryMerchant.FindField('business_address') <> nil then
    qryMerchant.FieldByName('business_address').OnGetText := GetText;
end;

procedure TAdminForm.qryDeliveryAfterPost(DataSet: TDataSet);
begin
  TabDeliveryShow(nil);
end;

procedure TAdminForm.qryDeliveryAfterOpen(DataSet: TDataSet);
begin
  // 处理TEXT类型字段显示问题，设置OnGetText事件处理器 
  // 目前没有TEXT类型字段，如果以后添加就在这里处理
end;

procedure TAdminForm.qryOrderAfterPost(DataSet: TDataSet);
begin
  TabOrderShow(nil);
end;

procedure TAdminForm.qryOrderAfterOpen(DataSet: TDataSet);
begin
  // 处理TEXT类型字段显示问题，设置OnGetText事件处理器
  // 如果有TEXT类型字段，就在这里处理
end;

procedure TAdminForm.qryCustomerAfterPost(DataSet: TDataSet);
begin
  TabCustomerShow(nil);
end;

procedure TAdminForm.qryCustomerAfterOpen(DataSet: TDataSet);
begin
  // 处理TEXT类型字段显示问题，设置OnGetText事件处理器
  if qryCustomer.FindField('address') <> nil then
    qryCustomer.FieldByName('address').OnGetText := GetText;
end;

procedure TAdminForm.GetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

function TAdminForm.GetStatusDescription(const Status: string; const MerchantID: Integer = 0; const DeliveryManID: Integer = 0): string;
begin
  // 调用共享单元中的方法
  Result := TOrderStatusHelper.GetStatusDescription(Status, MerchantID, DeliveryManID);
end;

procedure TAdminForm.UpdateOrderStatusDisplay(ALabel: TLabel; const Status: string);
var
  TempFont: TFont;
begin
  // 先复制字体对象
  TempFont := TFont.Create;
  try
    TempFont.Assign(ALabel.Font);
    // 使用共享单元中的方法设置状态样式
    TOrderStatusHelper.ApplyStatusStyle(Status, TempFont);
    // 将修改后的字体属性应用回标签字体
    ALabel.Font.Assign(TempFont);
  finally
    TempFont.Free;
  end;
end;

procedure TAdminForm.FormatOrderTimeline(const JsonStr: string; var FormattedText: string);
begin
  TOrderStatusHelper.FormatOrderTimeline(JsonStr, FormattedText);
end;

procedure TAdminForm.gridOrderCellClick(Column: TColumn);
begin
  if not Assigned(gridOrder.DataSource.DataSet) then
    Exit;
    
  selectedOrderID := gridOrder.DataSource.DataSet.FieldByName('order_id').AsInteger;
  // 启用订单详情按钮
  btnOrderDetails.Enabled := True;
end;

procedure TAdminForm.InitializeOrderDetailsDialog;
begin
  if not Assigned(dlgOrderDetails) then
  begin
    dlgOrderDetails := TForm.Create(Self);
    with dlgOrderDetails do
    begin
      Caption := '订单详情';
      Width := 700;
      Height := 600;
      Position := poScreenCenter;
      BorderStyle := bsDialog;
      
      pnlOrderInfo := TPanel.Create(dlgOrderDetails);
      with pnlOrderInfo do
      begin
        Parent := dlgOrderDetails;
        Align := alTop;
        Height := 180;
        BevelOuter := bvNone;
        
        lblOrderID := TLabel.Create(pnlOrderInfo);
        with lblOrderID do
        begin
          Parent := pnlOrderInfo;
          Left := 10;
          Top := 10;
          Font.Style := [fsBold];
        end;
        
        lblOrderStatus := TLabel.Create(pnlOrderInfo);
        with lblOrderStatus do
        begin
          Parent := pnlOrderInfo;
          Left := 10;
          Top := 35;
        end;
        
        lblOrderTime := TLabel.Create(pnlOrderInfo);
        with lblOrderTime do
        begin
          Parent := pnlOrderInfo;
          Left := 10;
          Top := 60;
        end;
        
        lblCustomerInfo := TLabel.Create(pnlOrderInfo);
        with lblCustomerInfo do
        begin
          Parent := pnlOrderInfo;
          Left := 10;
          Top := 85;
        end;
        
        lblMerchantInfo := TLabel.Create(pnlOrderInfo);
        with lblMerchantInfo do
        begin
          Parent := pnlOrderInfo;
          Left := 10;
          Top := 110;
        end;
        
        lblDeliveryManInfo := TLabel.Create(pnlOrderInfo);
        with lblDeliveryManInfo do
        begin
          Parent := pnlOrderInfo;
          Left := 10;
          Top := 135;
        end;
      end;
      
      gridOrderItems := TStringGrid.Create(dlgOrderDetails);
      with gridOrderItems do
      begin
        Parent := dlgOrderDetails;
        Align := alTop;
        Height := 150;
        Top := 180;
        FixedRows := 1;
        ColCount := 5;
        RowCount := 2;
        Options := Options + [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect];
        
        // 设置表头
        Cells[0, 0] := '商品编号';
        Cells[1, 0] := '商品名称';
        Cells[2, 0] := '单价';
        Cells[3, 0] := '数量';
        Cells[4, 0] := '小计';
      end;
      
      memoOrderHistory := TMemo.Create(dlgOrderDetails);
      with memoOrderHistory do
      begin
        Parent := dlgOrderDetails;
        Align := alClient;
        ReadOnly := True;
        ScrollBars := ssVertical;
      end;
      
      btnCloseDetails := TButton.Create(dlgOrderDetails);
      with btnCloseDetails do
      begin
        Parent := dlgOrderDetails;
        Align := alBottom;
        Caption := '关闭';
        Height := 30;
        OnClick := btnCloseDetailsClick;
      end;
    end;
  end;
end;

procedure TAdminForm.ShowEnhancedOrderDetails(OrderID: Integer);
var
  TotalAmount: Double;
  CurrentStatus: string;
  MerchantID, DeliveryManID: Integer;
begin
  InitializeOrderDetailsDialog;
  
  // 确保查询组件已创建并连接到数据库
  if not Assigned(qryOrderDetails) or not Assigned(qryOrderDetails.Connection) then
  begin
    if not Assigned(qryOrderDetails) then
      qryOrderDetails := TFDQuery.Create(Self);
    qryOrderDetails.Connection := DM.FDConnection;
  end;
  
  if not Assigned(qryOrderHistory) or not Assigned(qryOrderHistory.Connection) then
  begin
    if not Assigned(qryOrderHistory) then
      qryOrderHistory := TFDQuery.Create(Self);
    qryOrderHistory.Connection := DM.FDConnection;
  end;
  
  // 查询订单基本信息
  with qryOrderDetails do
  begin
    Close;
    SQL.Text := 
      'SELECT o.order_id, o.status, o.created_at, o.updated_at, ' +
      'c.name AS customer_name, c.contact_info AS customer_contact, c.address AS customer_address, ' +
      'm.name AS merchant_name, m.contact_info AS merchant_contact, m.business_address AS merchant_address, ' +
      'd.name AS delivery_man_name, d.contact_info AS delivery_man_contact, ' +
      'o.merchant_id, o.customer_id, o.delivery_man_id ' +
      'FROM order_info o ' +
      'JOIN customer c ON o.customer_id = c.customer_id ' +
      'JOIN merchant m ON o.merchant_id = m.merchant_id ' +
      'LEFT JOIN delivery_man d ON o.delivery_man_id = d.delivery_man_id ' +
      'WHERE o.order_id = :order_id';
    ParamByName('order_id').AsInteger := OrderID;
    Open;
    
    if RecordCount = 0 then
    begin
      ShowMessage('未找到订单信息');
      Exit;
    end;
    
    // 更新订单基本信息显示
    CurrentStatus := FieldByName('status').AsString;
    MerchantID := FieldByName('merchant_id').AsInteger;
    DeliveryManID := 0;
    if not FieldByName('delivery_man_id').IsNull then
      DeliveryManID := FieldByName('delivery_man_id').AsInteger;
    
    lblOrderID.Caption := Format('订单编号: #%d', [OrderID]);
    lblOrderStatus.Caption := Format('状态: %s', [GetStatusDescription(CurrentStatus, MerchantID, DeliveryManID)]);
    UpdateOrderStatusDisplay(lblOrderStatus, CurrentStatus);
    lblOrderTime.Caption := Format('创建时间: %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss', FieldByName('created_at').AsDateTime)]);
    lblCustomerInfo.Caption := Format('顾客: %s (%s) - 地址: %s', 
      [FieldByName('customer_name').AsString, 
      FieldByName('customer_contact').AsString,
      FieldByName('customer_address').AsString]);
    
    lblMerchantInfo.Caption := Format('商家: %s (%s) - 地址: %s', 
      [FieldByName('merchant_name').AsString, 
      FieldByName('merchant_contact').AsString,
      FieldByName('merchant_address').AsString]);
    
    if not FieldByName('delivery_man_id').IsNull then
      lblDeliveryManInfo.Caption := Format('配送员: %s (%s)', 
        [FieldByName('delivery_man_name').AsString, 
        FieldByName('delivery_man_contact').AsString])
    else
      lblDeliveryManInfo.Caption := '配送员: 暂未分配';
  end;
  
  // 查询订单商品明细
  with qryOrderDetails do
  begin
    Close;
    SQL.Text := 
      'SELECT oi.product_id, p.name AS product_name, ' +
      'oi.quantity, oi.price_at_order ' +
      'FROM order_item oi ' +
      'JOIN product p ON oi.product_id = p.product_id ' +
      'WHERE oi.order_id = :order_id';
    ParamByName('order_id').AsInteger := OrderID;
    Open;
    
    // 更新商品明细表格
    gridOrderItems.RowCount := RecordCount + 1;
    TotalAmount := 0;
    
    First;
    var Row := 1;
    while not Eof do
    begin
      gridOrderItems.Cells[0, Row] := FieldByName('product_id').AsString;
      gridOrderItems.Cells[1, Row] := FieldByName('product_name').AsString;
      gridOrderItems.Cells[2, Row] := Format('%.2f', [FieldByName('price_at_order').AsFloat]);
      gridOrderItems.Cells[3, Row] := FieldByName('quantity').AsString;
      gridOrderItems.Cells[4, Row] := Format('%.2f', 
        [FieldByName('price_at_order').AsFloat * FieldByName('quantity').AsInteger]);
      
      TotalAmount := TotalAmount + (FieldByName('price_at_order').AsFloat * FieldByName('quantity').AsInteger);
      Inc(Row);
      Next;
    end;
  end;
  
  // 加载订单状态历史
  LoadOrderStatusHistory(OrderID);
  
  // 显示对话框
  dlgOrderDetails.ShowModal;
end;

procedure TAdminForm.LoadOrderStatusHistory(OrderID: Integer);
begin
  qryOrderHistory.Close;
  qryOrderHistory.SQL.Text := 
    'SELECT order_data, change_timestamp ' +
    'FROM order_log ' +
    'WHERE order_id = :order_id ' +
    'ORDER BY change_timestamp ASC';
  qryOrderHistory.ParamByName('order_id').AsInteger := OrderID;
  qryOrderHistory.Open;
  
  memoOrderHistory.Clear;
  memoOrderHistory.Lines.Add('订单状态变更历史:');
  memoOrderHistory.Lines.Add('');
  
  while not qryOrderHistory.Eof do
  begin
    var FormattedText: string;
    FormatOrderTimeline(qryOrderHistory.FieldByName('order_data').AsString, FormattedText);
    memoOrderHistory.Lines.Add(FormattedText);
    qryOrderHistory.Next;
  end;
end;

procedure TAdminForm.btnOrderDetailsClick(Sender: TObject);
begin
  if selectedOrderID <= 0 then
  begin
    ShowMessage('请先选择一个订单');
    Exit;
  end;
  
  ShowEnhancedOrderDetails(selectedOrderID);
end;

procedure TAdminForm.btnCloseDetailsClick(Sender: TObject);
begin
  dlgOrderDetails.Close;
end;

end. 
