unit MerchantForm;
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
  System.Generics.Collections, System.UITypes, System.JSON, OrderStatus;
type
  TMerchantForm = class(TForm)
    // 标签页控件
    PageControl: TPageControl;
    TabAccount: TTabSheet;
    TabProduct: TTabSheet;
    TabOrder: TTabSheet;
    TabRevenue: TTabSheet;
    // 商家信息数据源
    dsMerchantInfo: TDataSource;
    // 商家信息查询组件
    qryMerchantInfo: TFDQuery;
    // 商家信息更新查询组件
    qryUpdateMerchantInfo: TFDQuery;
    // 商品管理相关组件
    pnlProductManagement: TPanel;
    lblProductName: TLabel;
    edtProductName: TEdit;
    lblProductPrice: TLabel;
    edtProductPrice: TEdit;
    lblProductStock: TLabel;
    edtProductStock: TEdit;
    lblProductDescription: TLabel;
    mmoProductDescription: TMemo;
    btnAddProduct: TButton;
    btnUpdateProduct: TButton;
    btnDeleteProduct: TButton;
    // 订单处理相关组件
    gridOrders: TDBGrid;
    dsOrders: TDataSource;
    qryOrders: TFDQuery;
    btnConfirmOrder: TButton;
    btnConfirmDelivery: TButton;
    // 添加缺失的查询组件
    qryProducts: TFDQuery;
    qryAddProduct: TFDQuery;
    qryUpdateProduct: TFDQuery;
    qryDeleteProduct: TFDQuery;
    qryConfirmOrder: TFDQuery;
    qryConfirmDelivery: TFDQuery;
    qryRevenue: TFDQuery;
    // 添加商品数据源和网格
    dsProducts: TDataSource;
    gridProducts: TDBGrid;
    // 面板组件
    pnlMerchantInfo: TPanel;
    pnlOrders: TPanel;
    pnlRevenue: TPanel;
    // 标签组件
    lblMerchantInfoTitle: TLabel;
    lblProductManagementTitle: TLabel;
    lblOrdersTitle: TLabel;
    // -- TabAccount --
    lblName: TLabel;
    edtName: TEdit;
    lblContact: TLabel;
    edtContactInfo: TEdit;
    lblAddress: TLabel;
    edtBusinessAddress: TEdit;
    btnUpdateMerchantInfo: TButton;
    lblStatus: TLabel;
    edtStatus: TEdit;
    btnToggleStatus: TButton;
    // -- 新增日期筛选组件 --
    gboxDateRange: TGroupBox;
    lblStartDate: TLabel;
    lblEndDate: TLabel;
    dtpStartDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    btnGenerateStats: TButton;
    // -- 新增统计面板组件 --
    pnlRevenueStats: TPanel;
    lblRevenueValuePanel: TLabel;
    pnlOrderStats: TPanel;
    lblTotalOrders: TLabel;
    lblOrdersValue: TLabel;
    lblTotalRevenue: TLabel;
    lblRevenueValue: TLabel;
    qryToggleStatus: TFDQuery;
    // 订单详情相关组件
    qryOrderDetails: TFDQuery;
    qryOrderHistory: TFDQuery;
    btnOrderDetails: TButton;
    
    procedure FormCreate(Sender: TObject);
    procedure btnAddProductClick(Sender: TObject);
    procedure btnUpdateProductClick(Sender: TObject);
    procedure btnDeleteProductClick(Sender: TObject);
    procedure btnConfirmOrderClick(Sender: TObject);
    procedure btnConfirmDeliveryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridProductsCellClick(Column: TColumn);
    procedure gridOrdersCellClick(Column: TColumn);
    procedure TabAccountShow(Sender: TObject);
    procedure TabProductShow(Sender: TObject);
    procedure TabOrderShow(Sender: TObject);
    procedure TabRevenueShow(Sender: TObject);
    procedure btnUpdateMerchantInfoClick(Sender: TObject);
    procedure btnGenerateStatsClick(Sender: TObject);
    procedure btnToggleStatusClick(Sender: TObject);
    procedure btnOrderDetailsClick(Sender: TObject);
    procedure btnCloseDetailsClick(Sender: TObject);
  private
    FMerchantID: Integer; // 添加商家ID字段
    selectedProductID: Integer; // 添加选中的商品ID
    selectedOrderID: Integer; // 添加选中的订单ID
    dlgOrderDetails: TForm;
    pnlOrderInfo: TPanel;
    lblOrderID: TLabel;
    lblOrderStatus: TLabel;
    lblOrderTime: TLabel;
    lblCustomerInfo: TLabel;
    gridOrderItems: TStringGrid;
    memoOrderHistory: TMemo;
    btnCloseDetails: TButton;
    
    procedure ConnectToDatabase;
    procedure LoadMerchantInfo;
    procedure LoadProducts;
    procedure LoadOrders;
    procedure CalculateMerchantRevenue;
    procedure AdjustGridColumnWidths(AGrid: TDBGrid; const AColumnWidths: TDictionary<string, Integer>);
    procedure GetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure UpdateToggleStatusButton;
    function GetStatusDescription(const Status: string): string;
    procedure UpdateOrderStatusDisplay(ALabel: TLabel; const Status: string);
    procedure FormatOrderTimeline(const JsonStr: string; var FormattedText: string);
    procedure InitializeOrderDetailsDialog;
    procedure ShowEnhancedOrderDetails(OrderID: Integer);
    procedure LoadOrderStatusHistory(OrderID: Integer);
  public
    property CurrentMerchantID: Integer read FMerchantID write FMerchantID;
    class procedure ShowMerchantForm(MerchantID: Integer);
  end;
var
  gMerchantForm: TMerchantForm;
implementation

{$R *.dfm}

uses
  DataModuleUnit;

procedure TMerchantForm.GetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

procedure TMerchantForm.ConnectToDatabase;
begin
  // 确保数据模块已连接
  if not Assigned(DM) then
    Exit;
  // 设置查询组件的连接
  qryMerchantInfo.Connection := DM.FDConnection;
  qryUpdateMerchantInfo.Connection := DM.FDConnection;
  qryOrders.Connection := DM.FDConnection;
  
  // 为新增的查询组件设置连接
  qryProducts.Connection := DM.FDConnection;
  qryAddProduct.Connection := DM.FDConnection;
  qryUpdateProduct.Connection := DM.FDConnection;
  qryDeleteProduct.Connection := DM.FDConnection;
  qryConfirmOrder.Connection := DM.FDConnection;
  qryConfirmDelivery.Connection := DM.FDConnection;
  qryRevenue.Connection := DM.FDConnection;
  qryToggleStatus.Connection := DM.FDConnection;
  
  // 为订单详情相关的查询组件设置连接
  if Assigned(qryOrderDetails) then
    qryOrderDetails.Connection := DM.FDConnection;
  
  if Assigned(qryOrderHistory) then
    qryOrderHistory.Connection := DM.FDConnection;
end;

procedure TMerchantForm.LoadMerchantInfo;
begin
  qryMerchantInfo.Close;
  qryMerchantInfo.SQL.Text := 'SELECT name, contact_info, business_address, status FROM merchant WHERE merchant_id = :merchant_id';
  qryMerchantInfo.ParamByName('merchant_id').AsInteger := FMerchantID;
  qryMerchantInfo.Open;

  // 将数据显示到编辑框
  if qryMerchantInfo.RecordCount > 0 then
  begin
    edtName.Text := qryMerchantInfo.FieldByName('name').AsString;
    edtContactInfo.Text := qryMerchantInfo.FieldByName('contact_info').AsString;
    edtBusinessAddress.Text := qryMerchantInfo.FieldByName('business_address').AsString;
    edtStatus.Text := qryMerchantInfo.FieldByName('status').AsString;
    
    // 更新状态切换按钮
    UpdateToggleStatusButton;
  end
  else
  begin
    // 如果没有数据，清空编辑框
    edtName.Text := '';
    edtContactInfo.Text := '';
    edtBusinessAddress.Text := '';
    edtStatus.Text := '';
    ShowMessage('未能加载商家信息。');
  end;

  // 不再需要调整网格列宽
  // if qryMerchantInfo.Active then
  // begin
  //   ...
  //   AdjustGridColumnWidths(gridMerchantInfo, MerchantInfoWidths);
  //   ...
  // end;
end;

procedure TMerchantForm.UpdateToggleStatusButton;
var
  currentStatus: string;
begin
  currentStatus := edtStatus.Text;
  
  // 根据当前状态更新按钮文本和可用性
  if currentStatus = 'active' then
  begin
    btnToggleStatus.Caption := '休息';
    btnToggleStatus.Enabled := True;
  end
  else if currentStatus = 'inactive' then
  begin
    btnToggleStatus.Caption := '营业';
    btnToggleStatus.Enabled := True;
  end
  else if currentStatus = 'pending_approval' then
  begin
    btnToggleStatus.Caption := '待审批';
    btnToggleStatus.Enabled := False;
  end
  else
  begin
    btnToggleStatus.Caption := '切换状态';
    btnToggleStatus.Enabled := False;
  end;
end;

procedure TMerchantForm.btnToggleStatusClick(Sender: TObject);
var
  currentStatus, newStatus: string;
begin
  currentStatus := edtStatus.Text;
  
  // 确定新状态
  if currentStatus = 'active' then
    newStatus := 'inactive'
  else if currentStatus = 'inactive' then
    newStatus := 'active'
  else
    Exit;  // 其他状态不处理
    
  try
    // 更新数据库中的状态
    qryToggleStatus.Close;
    qryToggleStatus.SQL.Text := 'UPDATE merchant SET status = :status WHERE merchant_id = :merchant_id';
    qryToggleStatus.ParamByName('status').AsString := newStatus;
    qryToggleStatus.ParamByName('merchant_id').AsInteger := FMerchantID;
    qryToggleStatus.ExecSQL;
    
    // 更新界面显示
    edtStatus.Text := newStatus;
    UpdateToggleStatusButton;
    
    // 显示确认消息
    if newStatus = 'active' then
      ShowMessage('已成功切换为营业状态')
    else
      ShowMessage('已成功切换为休息状态');
  except
    on E: Exception do
      ShowMessage('状态切换失败: ' + E.Message);
  end;
end;

procedure TMerchantForm.LoadProducts;
var
  ProductWidths: TDictionary<string, Integer>;
begin
  qryProducts.Close;
  // 使用v_all_merchant_products视图替代直接查询product表
  qryProducts.SQL.Text :=
    'SELECT' +
    '  product_id AS 商品编号,' +
    '  product_name AS 商品名称,' +
    '  price AS 价格,' +
    '  stock AS 库存,' +
    '  description AS 描述 ' +
    'FROM v_all_merchant_products ' +
    'WHERE merchant_id = :merchant_id';
  qryProducts.ParamByName('merchant_id').AsInteger := FMerchantID;
  qryProducts.Open;
  qryProducts.FieldByName('描述').OnGetText := GetText;
  
  // 如果没有设置数据源，则设置数据源
  if not Assigned(dsProducts) then
  begin
    dsProducts := TDataSource.Create(Self);
    dsProducts.DataSet := qryProducts;
    // 如果有产品网格，设置其数据源
    if Assigned(gridProducts) then
      gridProducts.DataSource := dsProducts;
  end;
  
  // 调整列宽度
  if qryProducts.Active then
  begin
    ProductWidths := TDictionary<string, Integer>.Create;
    try
      // 定义商品网格列宽
      ProductWidths.AddOrSetValue('商品编号', 80);
      ProductWidths.AddOrSetValue('商品名称', 240);
      ProductWidths.AddOrSetValue('价格', 100);
      ProductWidths.AddOrSetValue('库存', 100);
      ProductWidths.AddOrSetValue('描述', 600);
      
      AdjustGridColumnWidths(gridProducts, ProductWidths);
    finally
      ProductWidths.Free;
    end;
  end;
end;

procedure TMerchantForm.LoadOrders;
var
  OrderWidths: TDictionary<string, Integer>;
begin
  // 使用v_order_details视图简化订单查询
  qryOrders.Close;
  qryOrders.SQL.Text := 
    'SELECT ' +
    '  order_id AS 订单编号, ' +
    '  customer_id AS 顾客编号, ' +
    '  total_amount AS 总金额, ' +
    '  order_status AS 状态, ' +
    '  created_at AS 创建时间, ' +
    '  updated_at AS 更新时间 ' +
    'FROM v_order_details ' +
    'WHERE merchant_id = :merchant_id ' +
    'ORDER BY created_at DESC';
  
  qryOrders.ParamByName('merchant_id').AsInteger := FMerchantID;
  qryOrders.Open;
  
  // 调整列宽度
  if qryOrders.Active then
  begin
    OrderWidths := TDictionary<string, Integer>.Create;
    try
      // 定义订单网格列宽
      OrderWidths.AddOrSetValue('订单编号', 200);
      OrderWidths.AddOrSetValue('顾客编号', 200);
      OrderWidths.AddOrSetValue('总金额', 200);
      OrderWidths.AddOrSetValue('状态', 200);
      OrderWidths.AddOrSetValue('创建时间', 400);
      OrderWidths.AddOrSetValue('更新时间', 400);
      
      AdjustGridColumnWidths(gridOrders, OrderWidths);
    finally
      OrderWidths.Free;
    end;
  end;
end;

procedure TMerchantForm.btnAddProductClick(Sender: TObject);
begin
  qryAddProduct.Close;
  qryAddProduct.SQL.Text := 'INSERT INTO product (merchant_id, name, price, stock, description) VALUES (:merchant_id, :name, :price, :stock, :description)';
  qryAddProduct.ParamByName('merchant_id').AsInteger := FMerchantID;
  qryAddProduct.ParamByName('name').AsWideString := Trim(edtProductName.Text);
  qryAddProduct.ParamByName('price').AsFloat := StrToFloat(edtProductPrice.Text);
  qryAddProduct.ParamByName('stock').AsInteger := StrToInt(edtProductStock.Text);
  qryAddProduct.ParamByName('description').AsWideString := Trim(mmoProductDescription.Text);
  qryAddProduct.ExecSQL;
  LoadProducts; // 重新加载商品信息以显示更新
end;

procedure TMerchantForm.btnUpdateProductClick(Sender: TObject);
var
  cleanDescription: string;
begin
  cleanDescription := Trim(mmoProductDescription.Text);
  qryUpdateProduct.Params.Clear;
  qryUpdateProduct.SQL.Text := 'UPDATE product SET name = :name, price = :price, stock = :stock, description = :description WHERE product_id = :product_id AND merchant_id = :merchant_id';
  qryUpdateProduct.ParamByName('product_id').AsInteger := selectedProductID; // 假设获取当前选中商品ID
  qryUpdateProduct.ParamByName('merchant_id').AsInteger := FMerchantID;
  qryUpdateProduct.ParamByName('name').AsWideString := Trim(edtProductName.Text);
  qryUpdateProduct.ParamByName('price').AsFloat := StrToFloat(edtProductPrice.Text);
  qryUpdateProduct.ParamByName('stock').AsInteger := StrToInt(edtProductStock.Text);
  qryUpdateProduct.ParamByName('description').AsWideString := Trim(mmoProductDescription.Text);
  qryUpdateProduct.ExecSQL;
  LoadProducts;
end;

procedure TMerchantForm.btnDeleteProductClick(Sender: TObject);
begin
  if MessageDlg('确定要删除该商品吗？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    qryDeleteProduct.Close;
    qryDeleteProduct.SQL.Text := 'DELETE FROM product WHERE product_id = :product_id AND merchant_id = :merchant_id';
    qryDeleteProduct.ParamByName('product_id').AsInteger := selectedProductID;
    qryDeleteProduct.ParamByName('merchant_id').AsInteger := FMerchantID;
    qryDeleteProduct.ExecSQL;
    LoadProducts;
  end;
end;

procedure TMerchantForm.btnConfirmOrderClick(Sender: TObject);
begin
  qryConfirmOrder.Close;
  qryConfirmOrder.SQL.Text := 'UPDATE order_info SET status = ''processing'' WHERE order_id = :order_id';
  qryConfirmOrder.ParamByName('order_id').AsInteger := selectedOrderID; // 假设获取当前选中订单ID
  qryConfirmOrder.ExecSQL;
  LoadOrders; // 重新加载订单信息以显示更新
end;

procedure TMerchantForm.btnConfirmDeliveryClick(Sender: TObject);
begin
  qryConfirmDelivery.Close;
  qryConfirmDelivery.SQL.Text := 'UPDATE order_info SET status = ''processed'' WHERE order_id = :order_id';
  qryConfirmDelivery.ParamByName('order_id').AsInteger := selectedOrderID;
  qryConfirmDelivery.ExecSQL;
  CalculateMerchantRevenue; // 计算并更新商家收益
  LoadOrders;
end;

procedure TMerchantForm.CalculateMerchantRevenue;
var
  TotalRevenue: Double;
  TotalOrders: Integer;
  StartDate, EndDate: TDateTime;
  SQL: string;
begin
  StartDate := dtpStartDate.Date;
  EndDate := dtpEndDate.Date;

  // 计算总收入
  qryRevenue.Close;
  // 使用v_order_details视图简化收益计算查询，并增加日期筛选
  SQL := 'SELECT COALESCE(SUM(total_amount), 0) as total_revenue ' +
         'FROM v_order_details ' +
         'WHERE merchant_id = :merchant_id AND order_status = ''delivered'' ' +
         'AND created_at >= :start_date ' +
         'AND created_at <= :end_date';
  
  qryRevenue.SQL.Text := SQL;
  qryRevenue.ParamByName('merchant_id').AsInteger := FMerchantID;
  qryRevenue.ParamByName('start_date').AsDate := StartDate;
  qryRevenue.ParamByName('end_date').AsDate := EndDate + 1;  // 加1天以包含结束日期当天
  qryRevenue.Open;
  
  TotalRevenue := qryRevenue.FieldByName('total_revenue').AsFloat;
  lblRevenueValue.Caption := FormatFloat('#,##0.00', TotalRevenue) + ' 元';
  
  // 计算总订单数量
  qryRevenue.Close;
  SQL := 'SELECT COUNT(*) as total_orders ' +
         'FROM v_order_details ' +
         'WHERE merchant_id = :merchant_id AND order_status = ''delivered'' ' +
         'AND created_at >= :start_date ' +
         'AND created_at <= :end_date';
         
  qryRevenue.SQL.Text := SQL;
  qryRevenue.ParamByName('merchant_id').AsInteger := FMerchantID;
  qryRevenue.ParamByName('start_date').AsDate := StartDate;
  qryRevenue.ParamByName('end_date').AsDate := EndDate + 1;  // 加1天以包含结束日期当天
  qryRevenue.Open;
  
  TotalOrders := qryRevenue.FieldByName('total_orders').AsInteger;
  lblOrdersValue.Caption := IntToStr(TotalOrders) + ' 单';
end;

procedure TMerchantForm.FormShow(Sender: TObject);
begin
  // 需要手动调用每个标签页的Show方法
  case PageControl.ActivePageIndex of
    0: TabAccountShow(Sender);
    1: TabProductShow(Sender);
    2: TabOrderShow(Sender);
    3: TabRevenueShow(Sender);
  else
    TabAccountShow(Sender);
  end;
end;

procedure TMerchantForm.TabAccountShow(Sender: TObject);
begin
  LoadMerchantInfo;
end;

procedure TMerchantForm.TabProductShow(Sender: TObject);
begin
  LoadProducts;
end;

procedure TMerchantForm.TabOrderShow(Sender: TObject);
begin
  LoadOrders;
  
  // 添加订单详情按钮
  if not Assigned(btnOrderDetails) then
  begin
    btnOrderDetails := TButton.Create(Self);
    with btnOrderDetails do
    begin
      Parent := pnlOrders;
      Caption := '订单详情';
      Left := btnConfirmDelivery.Left + btnConfirmDelivery.Width + 10;
      Top := btnConfirmDelivery.Top;
      Width := 300;
      Height := btnConfirmDelivery.Height;
      OnClick := btnOrderDetailsClick;
      Enabled := False; // 初始状态下禁用按钮
    end;
  end;
end;

procedure TMerchantForm.TabRevenueShow(Sender: TObject);
begin
  // 调用统计生成函数，不再直接调用CalculateMerchantRevenue
  btnGenerateStatsClick(nil);
end;

class procedure TMerchantForm.ShowMerchantForm(MerchantID: Integer);
begin
  // 确保只创建一个实例
  if not Assigned(gMerchantForm) then
    Application.CreateForm(TMerchantForm, gMerchantForm);
  
  // 设置商家ID
  gMerchantForm.CurrentMerchantID := MerchantID;
  
  // 显示窗体
  gMerchantForm.Show;
end;

procedure TMerchantForm.FormCreate(Sender: TObject);
begin
  // 初始化变量
  selectedProductID := -1;
  selectedOrderID := -1;
  
  // 确保查询组件已创建
  if not Assigned(qryMerchantInfo) then
    qryMerchantInfo := TFDQuery.Create(Self);
  if not Assigned(qryUpdateMerchantInfo) then
    qryUpdateMerchantInfo := TFDQuery.Create(Self);
  if not Assigned(qryProducts) then
    qryProducts := TFDQuery.Create(Self);
  if not Assigned(qryAddProduct) then
    qryAddProduct := TFDQuery.Create(Self);
  if not Assigned(qryUpdateProduct) then
    qryUpdateProduct := TFDQuery.Create(Self);
  if not Assigned(qryDeleteProduct) then
    qryDeleteProduct := TFDQuery.Create(Self);
  if not Assigned(qryConfirmOrder) then
    qryConfirmOrder := TFDQuery.Create(Self);
  if not Assigned(qryConfirmDelivery) then
    qryConfirmDelivery := TFDQuery.Create(Self);
  if not Assigned(qryRevenue) then
    qryRevenue := TFDQuery.Create(Self);
  if not Assigned(qryToggleStatus) then
    qryToggleStatus := TFDQuery.Create(Self);
  if not Assigned(qryOrderDetails) then
    qryOrderDetails := TFDQuery.Create(Self);
  if not Assigned(qryOrderHistory) then
    qryOrderHistory := TFDQuery.Create(Self);
    
  // 确保数据源已创建
  if not Assigned(dsMerchantInfo) then
  begin
    dsMerchantInfo := TDataSource.Create(Self);
    if Assigned(qryMerchantInfo) then
      dsMerchantInfo.DataSet := qryMerchantInfo;
  end;
  if not Assigned(dsProducts) then
  begin
    dsProducts := TDataSource.Create(Self);
    if Assigned(qryProducts) then
      dsProducts.DataSet := qryProducts;
  end;
    
  ConnectToDatabase;
  
  // 设置默认日期范围
  dtpStartDate.Date := Date - 30;  // 默认显示过去30天
  dtpEndDate.Date := Date;         // 默认结束日期为今天
end;

procedure TMerchantForm.gridProductsCellClick(Column: TColumn);
begin
  if (qryProducts.Active) and (not qryProducts.IsEmpty) then
  begin
    // 先清空编辑框
    edtProductName.Text := '';
    edtProductPrice.Text := '';
    edtProductStock.Text := '';
    mmoProductDescription.Text := '';
    
    // 再填充数据
    selectedProductID := qryProducts.FieldByName('商品编号').AsInteger;
    edtProductName.Text := qryProducts.FieldByName('商品名称').AsWideString;
    edtProductPrice.Text := FloatToStr(qryProducts.FieldByName('价格').AsFloat);
    edtProductStock.Text := IntToStr(qryProducts.FieldByName('库存').AsInteger);
    mmoProductDescription.Text := qryProducts.FieldByName('描述').AsWideString;
  end;
end;

procedure TMerchantForm.gridOrdersCellClick(Column: TColumn);
begin
  if (qryOrders.Active) and (not qryOrders.IsEmpty) then
  begin
    selectedOrderID := qryOrders.FieldByName('订单编号').AsInteger;
    
    // 根据订单状态启用或禁用按钮
    if qryOrders.FieldByName('状态').AsString = 'pending' then
    begin
      btnConfirmOrder.Enabled := True;
      btnConfirmDelivery.Enabled := False;
    end
    else if qryOrders.FieldByName('状态').AsString = 'processing' then
    begin
      btnConfirmOrder.Enabled := False;
      btnConfirmDelivery.Enabled := True;
    end
    else
    begin
      btnConfirmOrder.Enabled := False;
      btnConfirmDelivery.Enabled := False;
    end;
  end;

  // 启用按钮
  btnOrderDetails.Enabled := True;
end;

procedure TMerchantForm.AdjustGridColumnWidths(AGrid: TDBGrid; const AColumnWidths: TDictionary<string, Integer>);
var
  I: Integer;
  Col: TColumn;
  FieldName: string;
  Width: Integer;
begin
  if not Assigned(AGrid) or not Assigned(AColumnWidths) or (AGrid.Columns.Count = 0) then
    Exit; // 如果网格或字典未分配，或网格没有列，则退出

  try
    // 遍历网格的列
    for I := 0 to AGrid.Columns.Count - 1 do
    begin
      Col := AGrid.Columns[I];
      FieldName := Col.FieldName;

      // 检查字段名是否存在于字典中
      if AColumnWidths.TryGetValue(FieldName, Width) then
      begin
        Col.Width := Width; // 从字典中设置宽度
      end;
    end;
  except
    on E: Exception do
      // 静默忽略宽度调整过程中的错误
      ;
  end;
end;

// 新增：更新商家信息按钮点击事件
procedure TMerchantForm.btnUpdateMerchantInfoClick(Sender: TObject);
begin
  // 简单输入验证
  if (Trim(edtName.Text) = '') or (Trim(edtContactInfo.Text) = '') or (Trim(edtBusinessAddress.Text) = '') then
  begin
    ShowMessage('商家名称、联系信息和经营地址不能为空！');
    Exit;
  end;

  try
    qryUpdateMerchantInfo.Close;
    qryUpdateMerchantInfo.SQL.Text := 'UPDATE merchant SET name = :name, contact_info = :contact_info, business_address = :address WHERE merchant_id = :merchant_id';
    qryUpdateMerchantInfo.ParamByName('name').AsWideString := Trim(edtName.Text);
    qryUpdateMerchantInfo.ParamByName('contact_info').AsWideString := Trim(edtContactInfo.Text);
    qryUpdateMerchantInfo.ParamByName('address').AsWideString := Trim(edtBusinessAddress.Text);
    qryUpdateMerchantInfo.ParamByName('merchant_id').AsInteger := FMerchantID;
    qryUpdateMerchantInfo.ExecSQL;
    ShowMessage('商家信息更新成功！');
    // 可以选择重新加载信息以确认，但通常不需要
    // LoadMerchantInfo;
  except
    on E: Exception do
    begin
      ShowMessage('更新商家信息失败：' + E.Message);
    end;
  end;
end;

// 添加生成统计按钮的点击事件处理器
procedure TMerchantForm.btnGenerateStatsClick(Sender: TObject);
begin
  CalculateMerchantRevenue;
end;

function TMerchantForm.GetStatusDescription(const Status: string): string;
begin
  // 调用共享单元中的方法，传入商家ID
  Result := TOrderStatusHelper.GetStatusDescription(Status, FMerchantID);
end;

procedure TMerchantForm.UpdateOrderStatusDisplay(ALabel: TLabel; const Status: string);
var
  TempFont: TFont;
begin
  // 创建临时字体对象
  TempFont := TFont.Create;
  try
    // 复制原始字体属性
    TempFont.Assign(ALabel.Font);
    
    // 应用状态样式到临时字体
    TOrderStatusHelper.ApplyStatusStyle(Status, TempFont);
    
    // 将临时字体属性应用回标签字体
    ALabel.Font.Assign(TempFont);
  finally
    TempFont.Free;
  end;
end;

procedure TMerchantForm.FormatOrderTimeline(const JsonStr: string; var FormattedText: string);
begin
  TOrderStatusHelper.FormatOrderTimeline(JsonStr, FormattedText);
end;

procedure TMerchantForm.InitializeOrderDetailsDialog;
begin
  if not Assigned(dlgOrderDetails) then
  begin
    dlgOrderDetails := TForm.Create(Self);
    with dlgOrderDetails do
    begin
      Caption := '订单详情';
      Width := 600;
      Height := 500;
      Position := poScreenCenter;
      BorderStyle := bsDialog;
      
      pnlOrderInfo := TPanel.Create(dlgOrderDetails);
      with pnlOrderInfo do
      begin
        Parent := dlgOrderDetails;
        Align := alTop;
        Height := 120;
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
      end;
      
      gridOrderItems := TStringGrid.Create(dlgOrderDetails);
      with gridOrderItems do
      begin
        Parent := dlgOrderDetails;
        Align := alTop;
        Height := 150;
        Top := 120;
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

procedure TMerchantForm.ShowEnhancedOrderDetails(OrderID: Integer);
var
  TotalAmount: Double;
  CurrentStatus: string;
  DeliveryManID: Integer;
begin
  InitializeOrderDetailsDialog;
  
  // 查询订单基本信息
  with qryOrderDetails do
  begin
    Close;
    SQL.Text := 
      'SELECT o.order_id, o.status, o.created_at, o.updated_at, ' +
      'c.name AS customer_name, c.contact_info AS customer_contact, c.address, ' +
      'o.merchant_id, o.delivery_man_id ' +
      'FROM order_info o ' +
      'JOIN customer c ON o.customer_id = c.customer_id ' +
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
    DeliveryManID := 0;
    if not FieldByName('delivery_man_id').IsNull then
      DeliveryManID := FieldByName('delivery_man_id').AsInteger;
    
    lblOrderID.Caption := Format('订单编号: #%d', [OrderID]);
    lblOrderStatus.Caption := Format('状态: %s', [TOrderStatusHelper.GetStatusDescription(CurrentStatus, FMerchantID, DeliveryManID)]);
    UpdateOrderStatusDisplay(lblOrderStatus, CurrentStatus);
    lblOrderTime.Caption := Format('创建时间: %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss', FieldByName('created_at').AsDateTime)]);
    lblCustomerInfo.Caption := Format('顾客: %s (%s) - 地址: %s', 
      [FieldByName('customer_name').AsString, 
      FieldByName('customer_contact').AsString,
      FieldByName('address').AsString]);
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

procedure TMerchantForm.LoadOrderStatusHistory(OrderID: Integer);
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

procedure TMerchantForm.btnOrderDetailsClick(Sender: TObject);
begin
  if selectedOrderID <= 0 then
  begin
    ShowMessage('请先选择一个订单');
    Exit;
  end;
  
  ShowEnhancedOrderDetails(selectedOrderID);
end;

procedure TMerchantForm.btnCloseDetailsClick(Sender: TObject);
begin
  dlgOrderDetails.Close;
end;

end.

