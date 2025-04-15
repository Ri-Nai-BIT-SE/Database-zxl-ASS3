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
    
    // 商家信息显示网格
    gridMerchantInfo: TDBGrid;
    // 商家信息数据源
    dsMerchantInfo: TDataSource;
    // 商家信息查询组件
    qryMerchantInfo: TFDQuery;
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
    // 收益查看相关组件
    lblMerchantRevenue: TLabel;
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
procedure TMerchantForm.ConnectToDatabase;
begin
  // 确保数据模块已连接
  if not Assigned(DM) then
    Exit;
  // 设置查询组件的连接
  qryMerchantInfo.Connection := DM.FDConnection;
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
var
  MerchantInfoWidths: TDictionary<string, Integer>;
begin
  qryMerchantInfo.Close;
  qryMerchantInfo.SQL.Text := 'SELECT username, name, contact_info, business_address, status FROM merchant WHERE merchant_id = :merchant_id';
  qryMerchantInfo.ParamByName('merchant_id').AsInteger := FMerchantID; // 使用字段
  qryMerchantInfo.Open;
  
  // 调整列宽度
  if qryMerchantInfo.Active then
  begin
    MerchantInfoWidths := TDictionary<string, Integer>.Create;
    try
      // 定义商家信息网格列宽
      MerchantInfoWidths.AddOrSetValue('username', 120);
      MerchantInfoWidths.AddOrSetValue('name', 150);
      MerchantInfoWidths.AddOrSetValue('contact_info', 180);
      MerchantInfoWidths.AddOrSetValue('business_address', 220);
      MerchantInfoWidths.AddOrSetValue('status', 80);
      
      AdjustGridColumnWidths(gridMerchantInfo, MerchantInfoWidths);
    finally
      MerchantInfoWidths.Free;
    end;
  end;
end;
procedure TMerchantForm.LoadProducts;
var
  ProductWidths: TDictionary<string, Integer>;
begin
  qryProducts.Close;
  qryProducts.SQL.Text := 'SELECT product_id, name, price, stock, description FROM product WHERE merchant_id = :merchant_id';
  qryProducts.ParamByName('merchant_id').AsInteger := FMerchantID;
  qryProducts.Open;
  
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
      ProductWidths.AddOrSetValue('product_id', 80);
      ProductWidths.AddOrSetValue('name', 150);
      ProductWidths.AddOrSetValue('price', 80);
      ProductWidths.AddOrSetValue('stock', 70);
      ProductWidths.AddOrSetValue('description', 220);
      
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
  // 直接通过联表查询获取订单信息
  qryOrders.Close;
  qryOrders.SQL.Text := 
    'SELECT ' +
    '  oi.order_id, ' +
    '  oi.customer_id, ' +
    '  SUM(oitem.quantity * oitem.price_at_order) AS total_amount, ' +
    '  oi.status, ' +
    '  oi.created_at, ' +
    '  oi.updated_at ' +
    'FROM order_info oi ' +
    'JOIN order_item oitem ON oi.order_id = oitem.order_id ' +
    'WHERE oi.merchant_id = :merchant_id ' +
    'GROUP BY oi.order_id, oi.customer_id, oi.status, oi.created_at, oi.updated_at ' +
    'ORDER BY oi.created_at DESC';
  
  qryOrders.ParamByName('merchant_id').AsInteger := FMerchantID;
  qryOrders.Open;
  
  // 调整列宽度
  if qryOrders.Active then
  begin
    OrderWidths := TDictionary<string, Integer>.Create;
    try
      // 定义订单网格列宽
      OrderWidths.AddOrSetValue('order_id', 70);
      OrderWidths.AddOrSetValue('customer_name', 120);
      OrderWidths.AddOrSetValue('total_amount', 90);
      OrderWidths.AddOrSetValue('status', 100);
      OrderWidths.AddOrSetValue('created_at', 130);
      OrderWidths.AddOrSetValue('updated_at', 130);
      
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
  qryConfirmDelivery.SQL.Text := 'UPDATE order_info SET status = ''delivered'' WHERE order_id = :order_id';
  qryConfirmDelivery.ParamByName('order_id').AsInteger := selectedOrderID;
  qryConfirmDelivery.ExecSQL;
  CalculateMerchantRevenue; // 计算并更新商家收益
  LoadOrders;
end;

procedure TMerchantForm.CalculateMerchantRevenue;
var
  TotalRevenue: Double;
begin
  qryRevenue.Close;
  qryRevenue.SQL.Text := 
    'SELECT COALESCE(SUM(oitem.quantity * oitem.price_at_order), 0) as total_revenue ' +
    'FROM order_info oi ' +
    'JOIN order_item oitem ON oi.order_id = oitem.order_id ' +
    'WHERE oi.merchant_id = :merchant_id AND oi.status = ''delivered''';
  
  qryRevenue.ParamByName('merchant_id').AsInteger := FMerchantID;
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
  CalculateMerchantRevenue;
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
  if not Assigned(dsProducts) then
  begin
    dsProducts := TDataSource.Create(Self);
    if Assigned(qryProducts) then
      dsProducts.DataSet := qryProducts;
  end;
    
  ConnectToDatabase;
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
    selectedProductID := qryProducts.FieldByName('product_id').AsInteger;
    edtProductName.Text := qryProducts.FieldByName('name').AsWideString;
    edtProductPrice.Text := FloatToStr(qryProducts.FieldByName('price').AsFloat);
    edtProductStock.Text := IntToStr(qryProducts.FieldByName('stock').AsInteger);
    mmoProductDescription.Text := qryProducts.FieldByName('description').AsWideString;
  end;
end;

procedure TMerchantForm.gridOrdersCellClick(Column: TColumn);
begin
  if (qryOrders.Active) and (not qryOrders.IsEmpty) then
  begin
    selectedOrderID := qryOrders.FieldByName('order_id').AsInteger;
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

end.

