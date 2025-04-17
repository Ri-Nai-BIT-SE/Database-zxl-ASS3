unit CustomerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Comp.DataSet, Vcl.DBCtrls, Vcl.Mask, System.Generics.Collections,
  System.UITypes, System.Math;

type
  TCartItem = class
    ProductID: Integer;
    ProductName: string;
    Price: Double;
    Quantity: Integer;
    constructor Create(AProductID: Integer; AProductName: string; APrice: Double; AQuantity: Integer);
  end;

  TCustomerForm = class(TForm)
    PageControl: TPageControl;
    TabAccount: TTabSheet;
    TabMerchant: TTabSheet;
    TabOrder: TTabSheet;
    TabCart: TTabSheet;
    pnlAccountInfo: TPanel;
    lblAccountTitle: TLabel;
    lblName: TLabel;
    edtName: TEdit;
    lblContact: TLabel;
    edtContactInfo: TEdit;
    lblAddress: TLabel;
    edtAddress: TEdit;
    btnUpdateInfo: TButton;
    lblBalance: TLabel;
    lblBalanceValue: TLabel;
    gboxRecharge: TGroupBox;
    lblRechargeAmount: TLabel;
    edtRechargeAmount: TEdit;
    btnRecharge: TButton;
    pnlMerchants: TPanel;
    lblMerchantTitle: TLabel;
    pnlMerchantList: TPanel;
    gridMerchants: TDBGrid;
    pnlProducts: TPanel;
    lblSelectedMerchant: TLabel;
    lblMerchantName: TLabel;
    lblProducts: TLabel;
    gridProducts: TDBGrid;
    btnAddToCart: TButton;
    btnViewCart: TButton;
    btnPlaceOrder: TButton;
    pnlOrders: TPanel;
    lblOrdersTitle: TLabel;
    gridOrders: TDBGrid;
    btnOrderAgain: TButton;
    btnOrderDetails: TButton;
    Splitter1: TSplitter;
    edtQuantity: TEdit;
    lblQuantity: TLabel;
    qryCustomerInfo: TFDQuery;
    qryUpdateCustomerInfo: TFDQuery;
    qryMerchants: TFDQuery;
    dsMerchants: TDataSource;
    qryProducts: TFDQuery;
    dsProducts: TDataSource;
    qryOrders: TFDQuery;
    dsOrders: TDataSource;
    qryOrderDetails: TFDQuery;
    qryPlaceOrder: TFDQuery;
    qryAddOrderItem: TFDQuery;
    qryRecharge: TFDQuery;
    pnlCart: TPanel;
    lblCartTitle: TLabel;
    gridCart: TStringGrid;
    pnlCartButtons: TPanel;
    btnRemoveFromCart: TButton;
    btnUpdateQuantity: TButton;
    btnClearCart: TButton;
    btnCartPlaceOrder: TButton;
    lblTotalAmount: TLabel;
    lblTotalAmountValue: TLabel;
    edtCartQuantity: TEdit;
    lblCartQuantity: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabAccountShow(Sender: TObject);
    procedure TabMerchantShow(Sender: TObject);
    procedure TabOrderShow(Sender: TObject);
    procedure TabCartShow(Sender: TObject);
    procedure btnUpdateInfoClick(Sender: TObject);
    procedure btnRechargeClick(Sender: TObject);
    procedure gridMerchantsCellClick(Column: TColumn);
    procedure gridProductsCellClick(Column: TColumn);
    procedure btnAddToCartClick(Sender: TObject);
    procedure btnViewCartClick(Sender: TObject);
    procedure btnPlaceOrderClick(Sender: TObject);
    procedure gridOrdersCellClick(Column: TColumn);
    procedure btnOrderAgainClick(Sender: TObject);
    procedure btnOrderDetailsClick(Sender: TObject);
    procedure btnRemoveFromCartClick(Sender: TObject);
    procedure btnUpdateQuantityClick(Sender: TObject);
    procedure btnClearCartClick(Sender: TObject);
    procedure btnCartPlaceOrderClick(Sender: TObject);
    procedure gridCartSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    FCustomerID: Integer;
    FSelectedMerchantID: Integer;
    FSelectedProductID: Integer;
    FSelectedOrderID: Integer;
    FCart: TList<TCartItem>;
    FWalletBalance: Double;
    FSelectedCartRow: Integer;
    
    procedure ConnectToDatabase;
    procedure LoadCustomerInfo;
    procedure LoadMerchants;
    procedure LoadProducts(MerchantID: Integer);
    procedure LoadOrders;
    procedure ClearCart;
    procedure AdjustGridColumnWidths(AGrid: TDBGrid; const AColumnWidths: TDictionary<string, Integer>);
    function GetCartTotalValue: Double;
    procedure ShowCartContents;
    procedure ShowOrderDetails(OrderID: Integer);
    function PlaceOrder(MerchantID: Integer; CartItems: TList<TCartItem>): Boolean;
    function ReorderFromHistory(OrderID: Integer): Boolean;
    procedure UpdateCartGrid;
    procedure GetText(Sender: TField; var Text: String; DisplayText: Boolean);
  public
    property CustomerID: Integer read FCustomerID write FCustomerID;
    class procedure ShowCustomerForm(CustomerID: Integer);
  end;

var
  gCustomerForm: TCustomerForm;

implementation

{$R *.dfm}

uses
  DataModuleUnit;

{ TCartItem }

constructor TCartItem.Create(AProductID: Integer; AProductName: string; APrice: Double; AQuantity: Integer);
begin
  ProductID := AProductID;
  ProductName := AProductName;
  Price := APrice;
  Quantity := AQuantity;
end;

{ TCustomerForm }

class procedure TCustomerForm.ShowCustomerForm(CustomerID: Integer);
begin
  if not Assigned(gCustomerForm) then
    gCustomerForm := TCustomerForm.Create(Application);
    
  // 先设置CustomerID
  gCustomerForm.CustomerID := CustomerID;
  
  // 立即加载账户信息
  gCustomerForm.LoadCustomerInfo;
  
  gCustomerForm.Show;
end;

procedure TCustomerForm.FormCreate(Sender: TObject);
begin
  Caption := '消费者界面';
  FCart := TList<TCartItem>.Create;
  FSelectedMerchantID := -1;
  FSelectedProductID := -1;
  FSelectedOrderID := -1;
  FSelectedCartRow := -1;
  ConnectToDatabase;
  
  // 初始化购物车表格
  with gridCart do
  begin
    ColCount := 5;
    RowCount := 2; // 表头+至少一个空行
    FixedRows := 1;
    
    // 设置表头
    Cells[0, 0] := '商品ID';
    Cells[1, 0] := '商品名称';
    Cells[2, 0] := '单价';
    Cells[3, 0] := '数量';
    Cells[4, 0] := '小计';
    
    // 清空第一行数据
    Cells[0, 1] := '';
    Cells[1, 1] := '';
    Cells[2, 1] := '';
    Cells[3, 1] := '';
    Cells[4, 1] := '';
    
    // 设置列宽
    ColWidths[0] := 80;
    ColWidths[1] := 250;
    ColWidths[2] := 80;
    ColWidths[3] := 80;
    ColWidths[4] := 100;
  end;
end;

procedure TCustomerForm.FormShow(Sender: TObject);
begin
  // 移除原来的case判断，直接调用TabAccountShow
  // 需要手动调用每个标签页的Show方法
  case PageControl.ActivePageIndex of
    0: TabAccountShow(Sender);
    1: TabMerchantShow(Sender);
    2: TabOrderShow(Sender);
    3: TabCartShow(Sender);
  else
    TabAccountShow(Sender);
  end;

end;

procedure TCustomerForm.ConnectToDatabase;
begin
  // 确保数据模块已连接
  if not Assigned(DM) then
    Exit;
    
  // 设置所有查询组件的连接
  qryCustomerInfo.Connection := DM.FDConnection;
  qryUpdateCustomerInfo.Connection := DM.FDConnection;
  qryMerchants.Connection := DM.FDConnection;
  qryProducts.Connection := DM.FDConnection;
  qryOrders.Connection := DM.FDConnection;
  qryOrderDetails.Connection := DM.FDConnection;
  qryPlaceOrder.Connection := DM.FDConnection;
  qryAddOrderItem.Connection := DM.FDConnection;
  qryRecharge.Connection := DM.FDConnection;
end;

procedure TCustomerForm.LoadCustomerInfo;
begin
  qryCustomerInfo.Close;
  qryCustomerInfo.ParamByName('customer_id').AsInteger := FCustomerID;
  qryCustomerInfo.Open;
  
  if qryCustomerInfo.RecordCount > 0 then
  begin
    edtName.Text := qryCustomerInfo.FieldByName('name').AsString;
    edtContactInfo.Text := qryCustomerInfo.FieldByName('contact_info').AsString;
    edtAddress.Text := qryCustomerInfo.FieldByName('address').AsString;
    FWalletBalance := qryCustomerInfo.FieldByName('wallet_balance').AsFloat;
    lblBalanceValue.Caption := Format('%.2f 元', [FWalletBalance]);
  end
  else
  begin
    edtName.Text := '';
    edtContactInfo.Text := '';
    edtAddress.Text := '';
    lblBalanceValue.Caption := '0.00 元';
  end;
end;

procedure TCustomerForm.LoadMerchants;
var
  MerchantWidths: TDictionary<string, Integer>;
begin
  qryMerchants.Close;
  qryMerchants.Open;
  qryMerchants.FieldByName('商家地址').OnGetText := GetText;
  
  if qryMerchants.Active then
  begin
    MerchantWidths := TDictionary<string, Integer>.Create;
    try
      MerchantWidths.AddOrSetValue('商家编号', 80);
      MerchantWidths.AddOrSetValue('商家名称', 160);
      MerchantWidths.AddOrSetValue('商家地址', 300);
      
      AdjustGridColumnWidths(gridMerchants, MerchantWidths);
    finally
      MerchantWidths.Free;
    end;
  end;
end;

procedure TCustomerForm.LoadProducts(MerchantID: Integer);
var
  ProductWidths: TDictionary<string, Integer>;
begin
  qryProducts.Close;
  qryProducts.ParamByName('merchant_id').AsInteger := MerchantID;
  qryProducts.Open;
  qryProducts.FieldByName('描述').OnGetText := GetText;

  
  if qryProducts.Active then
  begin
    ProductWidths := TDictionary<string, Integer>.Create;
    try
      ProductWidths.AddOrSetValue('商品编号', 80);
      ProductWidths.AddOrSetValue('商品名称', 200);
      ProductWidths.AddOrSetValue('价格', 80);
      ProductWidths.AddOrSetValue('库存', 70);
      ProductWidths.AddOrSetValue('描述', 450);
      
      AdjustGridColumnWidths(gridProducts, ProductWidths);
    finally
      ProductWidths.Free;
    end;
  end;
end;

procedure TCustomerForm.LoadOrders;
var
  OrderWidths: TDictionary<string, Integer>;
begin
  qryOrders.Close;
  qryOrders.ParamByName('customer_id').AsInteger := FCustomerID;
  qryOrders.Open;
  
  if qryOrders.Active then
  begin
    OrderWidths := TDictionary<string, Integer>.Create;
    try
      OrderWidths.AddOrSetValue('订单编号', 100);
      OrderWidths.AddOrSetValue('商家编号', 100);
      OrderWidths.AddOrSetValue('订单状态', 150);
      OrderWidths.AddOrSetValue('下单时间', 200);
      OrderWidths.AddOrSetValue('更新时间', 200);
      
      AdjustGridColumnWidths(gridOrders, OrderWidths);
    finally
      OrderWidths.Free;
    end;
  end;
end;

procedure TCustomerForm.AdjustGridColumnWidths(AGrid: TDBGrid; const AColumnWidths: TDictionary<string, Integer>);
var
  i: Integer;
  FieldName: string;
begin
  if not Assigned(AGrid.DataSource) or not Assigned(AGrid.DataSource.DataSet) then
    Exit;
    
  for i := 0 to AGrid.Columns.Count - 1 do
  begin
    FieldName := AGrid.Columns[i].Title.Caption;
    if AColumnWidths.ContainsKey(FieldName) then
      AGrid.Columns[i].Width := AColumnWidths[FieldName];
  end;
end;

procedure TCustomerForm.ClearCart;
var
  i: Integer;
begin
  for i := FCart.Count - 1 downto 0 do
  begin
    FCart[i].Free;
    FCart.Delete(i);
  end;
end;

function TCustomerForm.GetCartTotalValue: Double;
var
  i: Integer;
  TotalValue: Double;
begin
  TotalValue := 0;
  for i := 0 to FCart.Count - 1 do
    TotalValue := TotalValue + (FCart[i].Price * FCart[i].Quantity);
  Result := TotalValue;
end;

procedure TCustomerForm.ShowCartContents;
var
  i: Integer;
  CartContents: string;
  TotalValue: Double;
begin
  if FCart.Count = 0 then
  begin
    ShowMessage('购物车是空的');
    Exit;
  end;
  
  CartContents := '购物车内容:' + #13#10 + #13#10;
  TotalValue := 0;
  
  for i := 0 to FCart.Count - 1 do
  begin
    CartContents := CartContents + Format('%s - %.2f元 x %d = %.2f元', 
      [FCart[i].ProductName, FCart[i].Price, FCart[i].Quantity, 
       FCart[i].Price * FCart[i].Quantity]) + #13#10;
       
    TotalValue := TotalValue + (FCart[i].Price * FCart[i].Quantity);
  end;
  
  CartContents := CartContents + #13#10 + Format('总价: %.2f元', [TotalValue]);
  ShowMessage(CartContents);
end;

procedure TCustomerForm.ShowOrderDetails(OrderID: Integer);
var
  OrderDetails: string;
  TotalAmount: Double;
begin
  qryOrderDetails.Close;
  qryOrderDetails.SQL.Text := 
    'SELECT oi.order_item_id, oi.product_id, p.name AS product_name, ' +
    'oi.quantity, oi.price_at_order ' +
    'FROM order_item oi ' +
    'JOIN product p ON oi.product_id = p.product_id ' +
    'WHERE oi.order_id = :order_id';
  qryOrderDetails.ParamByName('order_id').AsInteger := OrderID;
  qryOrderDetails.Open;
  
  if qryOrderDetails.RecordCount = 0 then
  begin
    ShowMessage('未找到订单详情');
    Exit;
  end;
  
  OrderDetails := Format('订单 #%d 详情:', [OrderID]) + #13#10 + #13#10;
  TotalAmount := 0;
  
  qryOrderDetails.First;
  while not qryOrderDetails.Eof do
  begin
    OrderDetails := OrderDetails + Format('%s - %.2f元 x %d = %.2f元',
      [qryOrderDetails.FieldByName('product_name').AsString,
       qryOrderDetails.FieldByName('price_at_order').AsFloat,
       qryOrderDetails.FieldByName('quantity').AsInteger,
       qryOrderDetails.FieldByName('price_at_order').AsFloat * 
       qryOrderDetails.FieldByName('quantity').AsInteger]) + #13#10;
       
    TotalAmount := TotalAmount + 
      (qryOrderDetails.FieldByName('price_at_order').AsFloat * 
       qryOrderDetails.FieldByName('quantity').AsInteger);
       
    qryOrderDetails.Next;
  end;
  
  OrderDetails := OrderDetails + #13#10 + Format('总价: %.2f元', [TotalAmount]);
  ShowMessage(OrderDetails);
end;

function TCustomerForm.PlaceOrder(MerchantID: Integer; CartItems: TList<TCartItem>): Boolean;
var
  TotalAmount: Double;
  OrderID: Integer;
  i: Integer;
  TransactionStarted: Boolean;
begin
  Result := False;
  
  if CartItems.Count = 0 then
  begin
    ShowMessage('购物车是空的，无法下单');
    Exit;
  end;
  
  // 计算订单总金额
  TotalAmount := GetCartTotalValue;
  
  // 检查钱包余额是否足够
  if TotalAmount > FWalletBalance then
  begin
    ShowMessage(Format('钱包余额不足，当前余额：%.2f元，需要：%.2f元', 
      [FWalletBalance, TotalAmount]));
    Exit;
  end;
  
  TransactionStarted := False;
  try
    // 开始事务
    DM.FDConnection.StartTransaction;
    TransactionStarted := True;
    
    // 创建订单
    qryPlaceOrder.Close;
    qryPlaceOrder.SQL.Text := 
      'INSERT INTO order_info (customer_id, merchant_id, status, created_at, updated_at) ' +
      'VALUES (:customer_id, :merchant_id, ''pending'', pg_systimestamp(), pg_systimestamp()) ' +
      'RETURNING order_id';
    qryPlaceOrder.ParamByName('customer_id').AsInteger := FCustomerID;
    qryPlaceOrder.ParamByName('merchant_id').AsInteger := MerchantID;
    qryPlaceOrder.Open;
    
    if qryPlaceOrder.RecordCount = 0 then
      raise Exception.Create('创建订单失败');
      
    OrderID := qryPlaceOrder.FieldByName('order_id').AsInteger;
    
    // 添加订单项
    for i := 0 to CartItems.Count - 1 do
    begin
      qryAddOrderItem.Close;
      qryAddOrderItem.SQL.Text := 
        'INSERT INTO order_item (order_id, product_id, quantity, price_at_order) ' +
        'VALUES (:order_id, :product_id, :quantity, :price_at_order)';
      qryAddOrderItem.ParamByName('order_id').AsInteger := OrderID;
      qryAddOrderItem.ParamByName('product_id').AsInteger := CartItems[i].ProductID;
      qryAddOrderItem.ParamByName('quantity').AsInteger := CartItems[i].Quantity;
      qryAddOrderItem.ParamByName('price_at_order').AsFloat := CartItems[i].Price;
      qryAddOrderItem.ExecSQL;
    end;
    
    // 扣除钱包余额
    qryUpdateCustomerInfo.Close;
    qryUpdateCustomerInfo.SQL.Text := 
      'UPDATE customer SET wallet_balance = wallet_balance - :amount ' +
      'WHERE customer_id = :customer_id';
    qryUpdateCustomerInfo.ParamByName('amount').AsFloat := TotalAmount;
    qryUpdateCustomerInfo.ParamByName('customer_id').AsInteger := FCustomerID;
    qryUpdateCustomerInfo.ExecSQL;
    
    // 提交事务
    DM.FDConnection.Commit;
    TransactionStarted := False;
    
    // 更新余额显示
    FWalletBalance := FWalletBalance - TotalAmount;
    lblBalanceValue.Caption := Format('%.2f 元', [FWalletBalance]);
    
    // 清空购物车
    ClearCart;
    // 更新购物车显示
    UpdateCartGrid;
    
    ShowMessage(Format('订单已创建，订单号：%d', [OrderID]));
    Result := True;
  except
    on E: Exception do
    begin
      if TransactionStarted then
        DM.FDConnection.Rollback;
      ShowMessage('下单失败：' + E.Message);
    end;
  end;
end;

function TCustomerForm.ReorderFromHistory(OrderID: Integer): Boolean;
var
  MerchantID: Integer;
  CurrentProductID: Integer;
  CurrentProductName: string;
  CurrentPrice: Double;
  CurrentQuantity: Integer;
  tempQuery: TFDQuery;
begin
  Result := False;
  
  // 清空购物车
  ClearCart;
  
  try
    // 创建临时查询对象
    tempQuery := TFDQuery.Create(nil);
    try
      tempQuery.Connection := DM.FDConnection;
      
      // 获取订单的商家ID
      qryOrderDetails.Close;
      qryOrderDetails.SQL.Text := 
        'SELECT merchant_id FROM order_info WHERE order_id = :order_id';
      qryOrderDetails.ParamByName('order_id').AsInteger := OrderID;
      qryOrderDetails.Open;
      
      if qryOrderDetails.RecordCount = 0 then
        raise Exception.Create('未找到订单信息');
        
      MerchantID := qryOrderDetails.FieldByName('merchant_id').AsInteger;
      
      // 查询订单中的商品ID和数量
      qryOrderDetails.Close;
      qryOrderDetails.SQL.Text := 
        'SELECT oi.product_id, oi.quantity ' +
        'FROM order_item oi ' +
        'WHERE oi.order_id = :order_id';
      qryOrderDetails.ParamByName('order_id').AsInteger := OrderID;
      qryOrderDetails.Open;
      
      if qryOrderDetails.RecordCount = 0 then
        raise Exception.Create('未找到订单商品信息');
      
      // 将商品添加到购物车，每个商品都查询当前价格
      qryOrderDetails.First;
      while not qryOrderDetails.Eof do
      begin
        CurrentProductID := qryOrderDetails.FieldByName('product_id').AsInteger;
        CurrentQuantity := qryOrderDetails.FieldByName('quantity').AsInteger;
        
        // 使用临时查询对象查询当前商品信息和价格
        tempQuery.Close;
        tempQuery.SQL.Text := 
          'SELECT name, price, is_available, stock ' +
          'FROM product ' +
          'WHERE product_id = :product_id';
        tempQuery.ParamByName('product_id').AsInteger := CurrentProductID;
        tempQuery.Open;
        
        if tempQuery.RecordCount > 0 then
        begin
          // 检查商品是否可用和库存是否足够
          if not tempQuery.FieldByName('is_available').AsBoolean then
          begin
            ShowMessage(Format('商品"%s"已下架，无法添加到购物车', 
              [tempQuery.FieldByName('name').AsString]));
            qryOrderDetails.Next;
            Continue;
          end;
          
          if tempQuery.FieldByName('stock').AsInteger < CurrentQuantity then
          begin
            ShowMessage(Format('商品"%s"库存不足，当前库存: %d, 需要: %d', 
              [tempQuery.FieldByName('name').AsString, 
               tempQuery.FieldByName('stock').AsInteger, 
               CurrentQuantity]));
            // 调整为当前可用库存
            if tempQuery.FieldByName('stock').AsInteger > 0 then
              CurrentQuantity := tempQuery.FieldByName('stock').AsInteger
            else
            begin
              qryOrderDetails.Next;
              Continue;
            end;
          end;
          
          // 使用商品当前价格和名称
          CurrentProductName := tempQuery.FieldByName('name').AsString;
          CurrentPrice := tempQuery.FieldByName('price').AsFloat;
          
          // 添加到购物车
          FCart.Add(TCartItem.Create(
            CurrentProductID,
            CurrentProductName,
            CurrentPrice,
            CurrentQuantity
          ));
        end
        else
        begin
          ShowMessage(Format('商品ID: %d 已不存在，无法添加到购物车', [CurrentProductID]));
        end;
        
        qryOrderDetails.Next;
      end;
      
      // 如果购物车为空（所有商品都无法添加），则退出
      if FCart.Count = 0 then
      begin
        ShowMessage('无法重新下单，所有商品都无法添加到购物车');
        Exit;
      end;
      
      // 切换到商家选项卡并显示相应商家的商品
      FSelectedMerchantID := MerchantID;
      
      // 加载商家名称
      qryOrderDetails.Close;
      qryOrderDetails.SQL.Text := 
        'SELECT name FROM merchant WHERE merchant_id = :merchant_id';
      qryOrderDetails.ParamByName('merchant_id').AsInteger := MerchantID;
      qryOrderDetails.Open;
      
      if qryOrderDetails.RecordCount > 0 then
        lblMerchantName.Caption := qryOrderDetails.FieldByName('name').AsString;
      
      // 更新购物车显示
      UpdateCartGrid();
      
      Result := True;
    finally
      tempQuery.Free; // 释放临时查询对象
    end;
  except
    on E: Exception do
    begin
      ShowMessage('重新下单失败：' + E.Message);
    end;
  end;
end;

procedure TCustomerForm.TabAccountShow(Sender: TObject);
begin
  LoadCustomerInfo;
end;

procedure TCustomerForm.TabMerchantShow(Sender: TObject);
begin
  LoadMerchants;
  
  // 如果已选择商家，加载商品
  if FSelectedMerchantID > 0 then
    LoadProducts(FSelectedMerchantID);
end;

procedure TCustomerForm.TabOrderShow(Sender: TObject);
begin
  LoadOrders;
end;

procedure TCustomerForm.TabCartShow(Sender: TObject);
begin
  UpdateCartGrid;
end;

procedure TCustomerForm.btnUpdateInfoClick(Sender: TObject);
begin
  try
    qryUpdateCustomerInfo.Close;
    qryUpdateCustomerInfo.SQL.Text := 
      'UPDATE customer SET name = :name, contact_info = :contact_info, address = :address ' +
      'WHERE customer_id = :customer_id';
    qryUpdateCustomerInfo.ParamByName('name').AsString := edtName.Text;
    qryUpdateCustomerInfo.ParamByName('contact_info').AsString := edtContactInfo.Text;
    qryUpdateCustomerInfo.ParamByName('address').AsString := edtAddress.Text;
    qryUpdateCustomerInfo.ParamByName('customer_id').AsInteger := FCustomerID;
    qryUpdateCustomerInfo.ExecSQL;
    
    ShowMessage('个人信息更新成功');
  except
    on E: Exception do
      ShowMessage('个人信息更新失败：' + E.Message);
  end;
end;

procedure TCustomerForm.btnRechargeClick(Sender: TObject);
var
  RechargeAmount: Double;
begin
  try
    RechargeAmount := StrToFloat(edtRechargeAmount.Text);
    
    if RechargeAmount <= 0 then
    begin
      ShowMessage('充值金额必须大于0');
      Exit;
    end;
    
    qryRecharge.Close;
    qryRecharge.SQL.Text := 
      'UPDATE customer SET wallet_balance = wallet_balance + :amount ' +
      'WHERE customer_id = :customer_id ' +
      'RETURNING wallet_balance';
    qryRecharge.ParamByName('amount').AsFloat := RechargeAmount;
    qryRecharge.ParamByName('customer_id').AsInteger := FCustomerID;
    qryRecharge.Open;
    
    if qryRecharge.RecordCount > 0 then
    begin
      FWalletBalance := qryRecharge.FieldByName('wallet_balance').AsFloat;
      lblBalanceValue.Caption := Format('%.2f 元', [FWalletBalance]);
      edtRechargeAmount.Text := '';
      ShowMessage(Format('充值成功，当前余额：%.2f元', [FWalletBalance]));
    end;
  except
    on E: Exception do
      ShowMessage('充值失败：' + E.Message);
  end;
end;

procedure TCustomerForm.gridMerchantsCellClick(Column: TColumn);
var
  MerchantID: Integer;
  MerchantName: string;
begin
  if not Assigned(gridMerchants.DataSource.DataSet) then
    Exit;
    
  MerchantID := gridMerchants.DataSource.DataSet.FieldByName('商家编号').AsInteger;
  MerchantName := gridMerchants.DataSource.DataSet.FieldByName('商家名称').AsString;
  
  FSelectedMerchantID := MerchantID;
  lblMerchantName.Caption := MerchantName;
  
  LoadProducts(MerchantID);
end;

procedure TCustomerForm.gridProductsCellClick(Column: TColumn);
begin
  if not Assigned(gridProducts.DataSource.DataSet) then
    Exit;
    
  FSelectedProductID := gridProducts.DataSource.DataSet.FieldByName('商品编号').AsInteger;
end;

procedure TCustomerForm.btnAddToCartClick(Sender: TObject);
var
  ProductID: Integer;
  ProductName: string;
  Price: Double;
  Quantity: Integer;
  i: Integer;
  Found: Boolean;
begin
  if FSelectedProductID <= 0 then
  begin
    ShowMessage('请先选择商品');
    Exit;
  end;
  
  try
    Quantity := StrToInt(edtQuantity.Text);
    
    if Quantity <= 0 then
    begin
      ShowMessage('商品数量必须大于0');
      Exit;
    end;
  except
    ShowMessage('请输入有效的商品数量');
    Exit;
  end;
  
  ProductID := gridProducts.DataSource.DataSet.FieldByName('商品编号').AsInteger;
  ProductName := gridProducts.DataSource.DataSet.FieldByName('商品名称').AsString;
  Price := gridProducts.DataSource.DataSet.FieldByName('价格').AsFloat;
  
  // 检查购物车中是否已有该商品
  Found := False;
  for i := 0 to FCart.Count - 1 do
  begin
    if FCart[i].ProductID = ProductID then
    begin
      FCart[i].Quantity := FCart[i].Quantity + Quantity;
      Found := True;
      Break;
    end;
  end;
  
  // 如果购物车中没有该商品，则添加
  if not Found then
    FCart.Add(TCartItem.Create(ProductID, ProductName, Price, Quantity));
    
  ShowMessage(Format('已添加 %s x%d 到购物车', [ProductName, Quantity]));
  
  // 自动切换到购物车标签页
  UpdateCartGrid;
end;

procedure TCustomerForm.btnViewCartClick(Sender: TObject);
begin
  PageControl.ActivePage := TabCart;
end;

procedure TCustomerForm.btnPlaceOrderClick(Sender: TObject);
begin
  if FSelectedMerchantID <= 0 then
  begin
    ShowMessage('请先选择商家');
    Exit;
  end;
  
  if FCart.Count = 0 then
  begin
    ShowMessage('购物车是空的，无法下单');
    Exit;
  end;
  
  if MessageDlg('确认下单？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if PlaceOrder(FSelectedMerchantID, FCart) then
    begin
      // 下单成功，刷新订单列表
      LoadOrders;
    end;
  end;
end;

procedure TCustomerForm.gridOrdersCellClick(Column: TColumn);
begin
  if not Assigned(gridOrders.DataSource.DataSet) then
    Exit;
    
  FSelectedOrderID := gridOrders.DataSource.DataSet.FieldByName('订单编号').AsInteger;
end;

procedure TCustomerForm.btnOrderAgainClick(Sender: TObject);
begin
  if FSelectedOrderID <= 0 then
  begin
    ShowMessage('请先选择一个订单');
    Exit;
  end;
  
  if ReorderFromHistory(FSelectedOrderID) then
    ShowMessage('已加载历史订单商品到购物车，您可以修改商品数量或直接下单');
end;

procedure TCustomerForm.btnOrderDetailsClick(Sender: TObject);
begin
  if FSelectedOrderID <= 0 then
  begin
    ShowMessage('请先选择一个订单');
    Exit;
  end;
  
  ShowOrderDetails(FSelectedOrderID);
end;

procedure TCustomerForm.UpdateCartGrid;
var
  i: Integer;
  TotalValue: Double;
begin
  // 更新购物车表格
  with gridCart do
  begin
    // 清空表格内容，但保留表头
    RowCount := System.Math.Max(2, FCart.Count + 1);
    for i := 1 to RowCount - 1 do
    begin
      Cells[0, i] := '';
      Cells[1, i] := '';
      Cells[2, i] := '';
      Cells[3, i] := '';
      Cells[4, i] := '';
    end;
    
    // 填充购物车内容
    for i := 0 to FCart.Count - 1 do
    begin
      Cells[0, i + 1] := IntToStr(FCart[i].ProductID);
      Cells[1, i + 1] := FCart[i].ProductName;
      Cells[2, i + 1] := Format('%.2f', [FCart[i].Price]);
      Cells[3, i + 1] := IntToStr(FCart[i].Quantity);
      Cells[4, i + 1] := Format('%.2f', [FCart[i].Price * FCart[i].Quantity]);
    end;
  end;
  
  // 更新总价
  TotalValue := GetCartTotalValue;
  lblTotalAmountValue.Caption := Format('%.2f 元', [TotalValue]);
  
  // 重置选择
  FSelectedCartRow := -1;
  edtCartQuantity.Text := '';
end;

procedure TCustomerForm.gridCartSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if (ARow > 0) and (ARow <= FCart.Count) then
  begin
    FSelectedCartRow := ARow;
    edtCartQuantity.Text := gridCart.Cells[3, ARow];
  end
  else
  begin
    FSelectedCartRow := -1;
    edtCartQuantity.Text := '';
  end;
end;

procedure TCustomerForm.btnRemoveFromCartClick(Sender: TObject);
begin
  if (FSelectedCartRow <= 0) or (FSelectedCartRow > FCart.Count) then
  begin
    ShowMessage('请先选择要删除的商品');
    Exit;
  end;
  
  // 删除选中的商品
  FCart[FSelectedCartRow - 1].Free;
  FCart.Delete(FSelectedCartRow - 1);
  
  UpdateCartGrid;
  ShowMessage('商品已从购物车中移除');
end;

procedure TCustomerForm.btnUpdateQuantityClick(Sender: TObject);
var
  NewQuantity: Integer;
begin
  if (FSelectedCartRow <= 0) or (FSelectedCartRow > FCart.Count) then
  begin
    ShowMessage('请先选择要修改的商品');
    Exit;
  end;
  
  try
    NewQuantity := StrToInt(edtCartQuantity.Text);
    
    if NewQuantity <= 0 then
    begin
      ShowMessage('商品数量必须大于0');
      Exit;
    end;
    
    // 更新数量
    FCart[FSelectedCartRow - 1].Quantity := NewQuantity;
    
    UpdateCartGrid;
    ShowMessage('商品数量已更新');
  except
    ShowMessage('请输入有效的商品数量');
  end;
end;

procedure TCustomerForm.btnClearCartClick(Sender: TObject);
begin
  if FCart.Count = 0 then
  begin
    ShowMessage('购物车已经是空的');
    Exit;
  end;
  
  if MessageDlg('确定要清空购物车吗？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ClearCart;
    UpdateCartGrid;
    ShowMessage('购物车已清空');
  end;
end;

procedure TCustomerForm.btnCartPlaceOrderClick(Sender: TObject);
begin
  if FCart.Count = 0 then
  begin
    ShowMessage('购物车是空的，无法下单');
    Exit;
  end;
  
  if FSelectedMerchantID <= 0 then
  begin
    ShowMessage('请先在商家页面选择一个商家');
    Exit;
  end;
  
  if MessageDlg('确认下单？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if PlaceOrder(FSelectedMerchantID, FCart) then
    begin
      // 下单成功，刷新订单列表和购物车
      LoadOrders;
      UpdateCartGrid;
    end;
  end;
end;

procedure TCustomerForm.GetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

end.
