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
  System.Generics.Collections, System.UITypes;
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
    lblRevenueValue: TLabel;
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
    lblRevenueTitle: TLabel;
    // -- TabAccount --
    lblName: TLabel;
    edtName: TEdit;
    lblContact: TLabel;
    edtContactInfo: TEdit;
    lblAddress: TLabel;
    edtBusinessAddress: TEdit;
    btnUpdateMerchantInfo: TButton;
    // -- 新增日期筛选组件 --
    gboxDateRange: TGroupBox;
    lblStartDate: TLabel;
    lblEndDate: TLabel;
    dtpStartDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    btnGenerateStats: TButton;
    
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
  private
    FMerchantID: Integer; // 添加商家ID字段
    selectedProductID: Integer; // 添加选中的商品ID
    selectedOrderID: Integer; // 添加选中的订单ID
    procedure ConnectToDatabase;
    procedure LoadMerchantInfo;
    procedure LoadProducts;
    procedure LoadOrders;
    procedure CalculateMerchantRevenue;
    procedure AdjustGridColumnWidths(AGrid: TDBGrid; const AColumnWidths: TDictionary<string, Integer>);
    procedure GetText(Sender: TField; var Text: String; DisplayText: Boolean);
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
end;
procedure TMerchantForm.LoadMerchantInfo;
begin
  qryMerchantInfo.Close;
  qryMerchantInfo.SQL.Text := 'SELECT name, contact_info, business_address FROM merchant WHERE merchant_id = :merchant_id';
  qryMerchantInfo.ParamByName('merchant_id').AsInteger := FMerchantID;
  qryMerchantInfo.Open;

  // 将数据显示到编辑框
  if qryMerchantInfo.RecordCount > 0 then
  begin
    edtName.Text := qryMerchantInfo.FieldByName('name').AsString;
    edtContactInfo.Text := qryMerchantInfo.FieldByName('contact_info').AsString;
    edtBusinessAddress.Text := qryMerchantInfo.FieldByName('business_address').AsString;
  end
  else
  begin
    // 如果没有数据，清空编辑框
    edtName.Text := '';
    edtContactInfo.Text := '';
    edtBusinessAddress.Text := '';
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
      ProductWidths.AddOrSetValue('商品名称', 150);
      ProductWidths.AddOrSetValue('价格', 80);
      ProductWidths.AddOrSetValue('库存', 70);
      ProductWidths.AddOrSetValue('描述', 220);
      
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
  qryConfirmDelivery.SQL.Text := 'UPDATE order_info SET status = ''delivering'' WHERE order_id = :order_id';
  qryConfirmDelivery.ParamByName('order_id').AsInteger := selectedOrderID;
  qryConfirmDelivery.ExecSQL;
  CalculateMerchantRevenue; // 计算并更新商家收益
  LoadOrders;
end;

procedure TMerchantForm.CalculateMerchantRevenue;
var
  TotalRevenue: Double;
  StartDate, EndDate: TDateTime;
  SQL: string;
begin
  StartDate := dtpStartDate.Date;
  EndDate := dtpEndDate.Date;

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

end.

