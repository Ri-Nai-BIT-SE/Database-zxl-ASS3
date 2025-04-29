unit DeliveryForm;

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
  TDeliveryForm = class(TForm)
    // 标签页控件
    PageControl: TPageControl;
    TabAccount: TTabSheet;
    TabOrder: TTabSheet;
    TabRevenue: TTabSheet;
    
    // 外卖员信息数据源
    dsDeliveryInfo: TDataSource;
    // 外卖员信息查询组件
    qryDeliveryInfo: TFDQuery;
    // 外卖员信息更新查询组件
    qryUpdateDeliveryInfo: TFDQuery;
    
    // 订单处理相关组件
    gridOrders: TDBGrid;
    dsOrders: TDataSource;
    qryOrders: TFDQuery;
    btnAcceptOrder: TButton;
    btnConfirmDelivery: TButton;
    
    // 查询组件
    qryAcceptOrder: TFDQuery;
    qryConfirmDelivery: TFDQuery;
    qryRevenue: TFDQuery;
    
    // 面板组件
    pnlDeliveryInfo: TPanel;
    pnlOrders: TPanel;
    pnlRevenue: TPanel;
    
    // 标签组件
    lblDeliveryInfoTitle: TLabel;
    lblOrdersTitle: TLabel;
    lblRevenueTitle: TLabel;
    
    // -- TabAccount --
    lblName: TLabel;
    edtName: TEdit;
    lblContact: TLabel;
    edtContactInfo: TEdit;
    lblStatus: TLabel;
    edtStatus: TEdit;
    btnUpdateDeliveryInfo: TButton;
    btnToggleStatus: TButton;
    
    // -- 收益统计相关组件 --
    gboxDateRange: TGroupBox;
    lblStartDate: TLabel;
    lblEndDate: TLabel;
    dtpStartDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    btnGenerateStats: TButton;
    
    // -- 收益统计面板组件 --
    pnlRevenueStats: TPanel;
    lblTotalRevenue: TLabel;
    lblRevenueValue: TLabel;
    pnlOrderStats: TPanel;
    lblTotalOrders: TLabel;
    lblOrdersValue: TLabel;
    qryToggleStatus: TFDQuery;
    
    // 订单详情相关组件
    qryOrderDetails: TFDQuery;
    qryOrderHistory: TFDQuery;
    btnOrderDetails: TButton;
    
    procedure FormCreate(Sender: TObject);
    procedure btnAcceptOrderClick(Sender: TObject);
    procedure btnConfirmDeliveryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridOrdersCellClick(Column: TColumn);
    procedure TabAccountShow(Sender: TObject);
    procedure TabOrderShow(Sender: TObject);
    procedure TabRevenueShow(Sender: TObject);
    procedure btnUpdateDeliveryInfoClick(Sender: TObject);
    procedure btnGenerateStatsClick(Sender: TObject);
    procedure btnToggleStatusClick(Sender: TObject);
    procedure btnOrderDetailsClick(Sender: TObject);
    procedure btnCloseDetailsClick(Sender: TObject);
    
  private
    FDeliveryID: Integer; // 外卖员ID字段
    selectedOrderID: Integer; // 选中的订单ID
    dlgOrderDetails: TForm;
    pnlOrderInfo: TPanel;
    lblOrderID: TLabel;
    lblOrderStatus: TLabel;
    lblOrderTime: TLabel;
    lblCustomerInfo: TLabel;
    lblMerchantInfo: TLabel;
    gridOrderItems: TStringGrid;
    memoOrderHistory: TMemo;
    btnCloseDetails: TButton;
    
    procedure ConnectToDatabase;
    procedure LoadDeliveryInfo;
    procedure LoadOrders;
    procedure CalculateDeliveryRevenue;
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
    property CurrentDeliveryID: Integer read FDeliveryID write FDeliveryID;
    class procedure ShowDeliveryForm(DeliveryID: Integer);
  end;

var
  gDeliveryForm: TDeliveryForm;

implementation

{$R *.dfm}

uses
  DataModuleUnit;

procedure TDeliveryForm.GetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

procedure TDeliveryForm.ConnectToDatabase;
begin
  // 确保数据模块已连接
  if not Assigned(DM) then
    Exit;
  // 设置查询组件的连接
  qryDeliveryInfo.Connection := DM.FDConnection;
  qryUpdateDeliveryInfo.Connection := DM.FDConnection;
  qryOrders.Connection := DM.FDConnection;
  qryAcceptOrder.Connection := DM.FDConnection;
  qryConfirmDelivery.Connection := DM.FDConnection;
  qryRevenue.Connection := DM.FDConnection;
  qryToggleStatus.Connection := DM.FDConnection;
  
  // 为订单详情相关的查询组件设置连接
  if Assigned(qryOrderDetails) then
    qryOrderDetails.Connection := DM.FDConnection;
  
  if Assigned(qryOrderHistory) then
    qryOrderHistory.Connection := DM.FDConnection;
end;

procedure TDeliveryForm.LoadDeliveryInfo;
begin
  qryDeliveryInfo.Close;
  qryDeliveryInfo.SQL.Text := 'SELECT name, contact_info, status FROM delivery_man WHERE delivery_man_id = :delivery_id';
  qryDeliveryInfo.ParamByName('delivery_id').AsInteger := FDeliveryID;
  qryDeliveryInfo.Open;

  // 将数据显示到编辑框
  if qryDeliveryInfo.RecordCount > 0 then
  begin
    edtName.Text := qryDeliveryInfo.FieldByName('name').AsString;
    edtContactInfo.Text := qryDeliveryInfo.FieldByName('contact_info').AsString;
    edtStatus.Text := qryDeliveryInfo.FieldByName('status').AsString;
    
    // 更新状态切换按钮
    UpdateToggleStatusButton;
  end
  else
  begin
    // 如果没有数据，清空编辑框
    edtName.Text := '';
    edtContactInfo.Text := '';
    edtStatus.Text := '';
    ShowMessage('未能加载外卖员信息。');
  end;
end;

procedure TDeliveryForm.UpdateToggleStatusButton;
var
  currentStatus: string;
begin
  currentStatus := edtStatus.Text;
  
  // 根据当前状态更新按钮文本和可用性
  if currentStatus = 'active_available' then
  begin
    btnToggleStatus.Caption := '下班';
    btnToggleStatus.Enabled := True;
  end
  else if currentStatus = 'inactive' then
  begin
    btnToggleStatus.Caption := '上班';
    btnToggleStatus.Enabled := True;
  end
  else if currentStatus = 'active_delivering' then
  begin
    btnToggleStatus.Caption := '送货中';
    btnToggleStatus.Enabled := False;
  end
  else if currentStatus = 'pending_approval' then
  begin
    btnToggleStatus.Caption := '待审批';
    btnToggleStatus.Enabled := False;
  end
  else if currentStatus = 'rejected' then
  begin
    btnToggleStatus.Caption := '已拒绝';
    btnToggleStatus.Enabled := False;
  end
  else
  begin
    btnToggleStatus.Caption := '切换状态';
    btnToggleStatus.Enabled := False;
  end;
end;

procedure TDeliveryForm.btnToggleStatusClick(Sender: TObject);
var
  currentStatus, newStatus: string;
begin
  currentStatus := edtStatus.Text;
  
  // 确定新状态
  if currentStatus = 'active_available' then
    newStatus := 'inactive'
  else if currentStatus = 'inactive' then
    newStatus := 'active_available'
  else
    Exit;  // 其他状态不处理
    
  try
    // 更新数据库中的状态
    qryToggleStatus.Close;
    qryToggleStatus.SQL.Text := 'UPDATE delivery_man SET status = :status WHERE delivery_man_id = :delivery_id';
    qryToggleStatus.ParamByName('status').AsString := newStatus;
    qryToggleStatus.ParamByName('delivery_id').AsInteger := FDeliveryID;
    qryToggleStatus.ExecSQL;
    
    // 更新界面显示
    edtStatus.Text := newStatus;
    UpdateToggleStatusButton;
    
    // 显示确认消息
    if newStatus = 'active_available' then
      ShowMessage('已成功上班，现在可以接单了！')
    else
      ShowMessage('已成功下班，休息一下吧！');
  except
    on E: Exception do
      ShowMessage('状态切换失败: ' + E.Message);
  end;
end;

procedure TDeliveryForm.LoadOrders;
var
  OrderWidths: TDictionary<string, Integer>;
  i: Integer; 
begin
  // 确保清除并重新创建数据源
  if Assigned(dsOrders) then
  begin
    if gridOrders.DataSource = dsOrders then
      gridOrders.DataSource := nil;
    FreeAndNil(dsOrders);
  end;
  
  dsOrders := TDataSource.Create(Self);
  dsOrders.DataSet := qryOrders;
  gridOrders.DataSource := dsOrders;

  // 使用新的查询语句
  qryOrders.Close;
  qryOrders.SQL.Text := 
    'SELECT ' +
    '  order_id AS 订单编号, ' +
    '  customer_id AS 顾客编号, ' +
    '  merchant_id AS 商家编号, ' +
    '  total_amount AS 总金额, ' +
    '  order_status AS 状态, ' +
    '  created_at AS 创建时间, ' +
    '  updated_at AS 更新时间 ' +
    'FROM v_order_details ' +
    'WHERE order_status = ''processed'' ' +
    'AND delivery_man_id IS NULL ' +
    'ORDER BY created_at DESC';
  
  try
    qryOrders.Open;
    
    // 调试信息
    if qryOrders.RecordCount > 0 then
    begin
      qryOrders.First;
      
      // 显示所有字段名
      var FieldNames := '';
      for i := 0 to qryOrders.FieldCount - 1 do
        FieldNames := FieldNames + qryOrders.Fields[i].FieldName + ', ';
    end;
    
    // 确保网格可见并启用
    gridOrders.Visible := True;
    gridOrders.Enabled := True;
    
    // 设置列宽
    OrderWidths := TDictionary<string, Integer>.Create;
    try
      // 定义订单网格列宽
      OrderWidths.AddOrSetValue('订单编号', 150);
      OrderWidths.AddOrSetValue('顾客编号', 150);
      OrderWidths.AddOrSetValue('商家编号', 150);
      OrderWidths.AddOrSetValue('总金额', 150);
      OrderWidths.AddOrSetValue('状态', 150);
      OrderWidths.AddOrSetValue('创建时间', 300);
      OrderWidths.AddOrSetValue('更新时间', 300);
      
      AdjustGridColumnWidths(gridOrders, OrderWidths);
    finally
      OrderWidths.Free;
    end;
    
    // 强制更新显示
    gridOrders.Repaint;
    Application.ProcessMessages;
    
  except
    on E: Exception do
      ShowMessage('查询错误: ' + E.Message);
  end;
end;

procedure TDeliveryForm.btnAcceptOrderClick(Sender: TObject);
begin
  // 先检查外卖员状态
  qryDeliveryInfo.Close;
  qryDeliveryInfo.SQL.Text := 'SELECT status FROM delivery_man WHERE delivery_man_id = :delivery_id';
  qryDeliveryInfo.ParamByName('delivery_id').AsInteger := FDeliveryID;
  qryDeliveryInfo.Open;
  
  if qryDeliveryInfo.FieldByName('status').AsString <> 'active_available' then
  begin
    ShowMessage('您当前状态不可接单，需要是"active_available"状态才能接单。');
    Exit;
  end;

  // 更新订单状态为delivering并分配给当前外卖员
  qryAcceptOrder.Close;
  qryAcceptOrder.SQL.Text := 'UPDATE order_info SET status = ''delivering'', delivery_man_id = :delivery_id WHERE order_id = :order_id';
  qryAcceptOrder.ParamByName('delivery_id').AsInteger := FDeliveryID;
  qryAcceptOrder.ParamByName('order_id').AsInteger := selectedOrderID;
  qryAcceptOrder.ExecSQL;
  
  // 更新外卖员状态为delivering
  qryUpdateDeliveryInfo.Close;
  qryUpdateDeliveryInfo.SQL.Text := 'UPDATE delivery_man SET status = ''active_delivering'' WHERE delivery_man_id = :delivery_id';
  qryUpdateDeliveryInfo.ParamByName('delivery_id').AsInteger := FDeliveryID;
  qryUpdateDeliveryInfo.ExecSQL;
  
  LoadOrders; // 重新加载订单
  LoadDeliveryInfo(); // 更新状态显示
  ShowMessage('订单已接受，开始配送！');
end;

procedure TDeliveryForm.btnConfirmDeliveryClick(Sender: TObject);
begin
  // 更新订单状态为delivered
  qryConfirmDelivery.Close;
  qryConfirmDelivery.SQL.Text := 'UPDATE order_info SET status = ''delivered'' WHERE order_id = :order_id AND delivery_man_id = :delivery_id';
  qryConfirmDelivery.ParamByName('order_id').AsInteger := selectedOrderID;
  qryConfirmDelivery.ParamByName('delivery_id').AsInteger := FDeliveryID;
  qryConfirmDelivery.ExecSQL;
  
  // 更新外卖员状态为available
  qryUpdateDeliveryInfo.Close;
  qryUpdateDeliveryInfo.SQL.Text := 'UPDATE delivery_man SET status = ''active_available'' WHERE delivery_man_id = :delivery_id';
  qryUpdateDeliveryInfo.ParamByName('delivery_id').AsInteger := FDeliveryID;
  qryUpdateDeliveryInfo.ExecSQL;
  
  LoadOrders(); // 重新加载订单
  LoadDeliveryInfo(); // 更新状态显示
  CalculateDeliveryRevenue(); // 更新收益信息
  ShowMessage('订单已送达，已更新收益！');
end;

procedure TDeliveryForm.CalculateDeliveryRevenue;
var
  TotalRevenue: Double;
  TotalOrders: Integer;
  StartDate, EndDate: TDateTime;
  SQL: string;
begin
  StartDate := dtpStartDate.Date;
  EndDate := dtpEndDate.Date;

  // 计算总收益 (假设每单收益是订单总金额的10%)
  qryRevenue.Close;
  SQL := 'SELECT COALESCE(SUM(total_amount * 0.1), 0) as total_revenue ' +
         'FROM v_order_details ' +
         'WHERE delivery_man_id = :delivery_id AND order_status = ''delivered'' ' +
         'AND created_at >= :start_date ' +
         'AND created_at <= :end_date';
  
  qryRevenue.SQL.Text := SQL;
  qryRevenue.ParamByName('delivery_id').AsInteger := FDeliveryID;
  qryRevenue.ParamByName('start_date').AsDate := StartDate;
  qryRevenue.ParamByName('end_date').AsDate := EndDate + 1;  // 加1天以包含结束日期当天
  qryRevenue.Open;
  
  TotalRevenue := qryRevenue.FieldByName('total_revenue').AsFloat;
  lblRevenueValue.Caption := FormatFloat('#,##0.00', TotalRevenue) + ' 元';
  
  // 计算总配送订单数量
  qryRevenue.Close;
  SQL := 'SELECT COUNT(*) as total_orders ' +
         'FROM v_order_details ' +
         'WHERE delivery_man_id = :delivery_id AND order_status = ''delivered'' ' +
         'AND created_at >= :start_date ' +
         'AND created_at <= :end_date';
         
  qryRevenue.SQL.Text := SQL;
  qryRevenue.ParamByName('delivery_id').AsInteger := FDeliveryID;
  qryRevenue.ParamByName('start_date').AsDate := StartDate;
  qryRevenue.ParamByName('end_date').AsDate := EndDate + 1;  // 加1天以包含结束日期当天
  qryRevenue.Open;
  
  TotalOrders := qryRevenue.FieldByName('total_orders').AsInteger;
  lblOrdersValue.Caption := IntToStr(TotalOrders) + ' 单';
end;

procedure TDeliveryForm.FormShow(Sender: TObject);
begin
  // 需要手动调用每个标签页的Show方法
  case PageControl.ActivePageIndex of
    0: TabAccountShow(Sender);
    1: TabOrderShow(Sender);
    2: TabRevenueShow(Sender);
  else
    TabAccountShow(Sender);
  end;
end;

procedure TDeliveryForm.TabAccountShow(Sender: TObject);
begin
  LoadDeliveryInfo;
end;

procedure TDeliveryForm.TabOrderShow(Sender: TObject);
begin
  // 确保面板可见
  pnlOrders.Visible := True;
  
  // 确保订单网格可见
  if not Assigned(gridOrders) then
  begin
    gridOrders := TDBGrid.Create(Self);
    gridOrders.Parent := pnlOrders;
    gridOrders.Align := alClient;
  end;
  
  gridOrders.Visible := True;
  gridOrders.Enabled := True;
  gridOrders.OnCellClick := gridOrdersCellClick;
  
  // 加载订单
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
      Width := 120;
      Height := btnConfirmDelivery.Height;
      OnClick := btnOrderDetailsClick;
      Enabled := False; // 初始状态下禁用按钮
    end;
  end;
  
  // 强制刷新
  Application.ProcessMessages;
end;

procedure TDeliveryForm.TabRevenueShow(Sender: TObject);
begin
  btnGenerateStatsClick(nil);
end;

class procedure TDeliveryForm.ShowDeliveryForm(DeliveryID: Integer);
begin
  // 确保只创建一个实例
  if not Assigned(gDeliveryForm) then
    Application.CreateForm(TDeliveryForm, gDeliveryForm);
  
  // 设置外卖员ID
  gDeliveryForm.CurrentDeliveryID := DeliveryID;
  
  // 显示窗体
  gDeliveryForm.Show;
end;

procedure TDeliveryForm.FormCreate(Sender: TObject);
begin
  // 初始化变量
  selectedOrderID := -1;
  
  // 确保查询组件已创建
  if not Assigned(qryDeliveryInfo) then
    qryDeliveryInfo := TFDQuery.Create(Self);
  if not Assigned(qryUpdateDeliveryInfo) then
    qryUpdateDeliveryInfo := TFDQuery.Create(Self);
  if not Assigned(qryOrders) then
    qryOrders := TFDQuery.Create(Self);
  if not Assigned(qryAcceptOrder) then
    qryAcceptOrder := TFDQuery.Create(Self);
  if not Assigned(qryConfirmDelivery) then
    qryConfirmDelivery := TFDQuery.Create(Self);
  if not Assigned(qryRevenue) then
    qryRevenue := TFDQuery.Create(Self);
  if not Assigned(qryToggleStatus) then
    qryToggleStatus := TFDQuery.Create(Self);
  
  // 确保数据源已创建
  if not Assigned(dsDeliveryInfo) then
  begin
    dsDeliveryInfo := TDataSource.Create(Self);
    if Assigned(qryDeliveryInfo) then
      dsDeliveryInfo.DataSet := qryDeliveryInfo;
  end;
  
  // 检查网格控件
  if Assigned(gridOrders) then
  else
  begin
    gridOrders := TDBGrid.Create(Self);
    gridOrders.Parent := pnlOrders;
    gridOrders.Align := alClient;
    gridOrders.Options := [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack];
  end;
  
  // 确保面板可见
  if Assigned(pnlOrders) then 
  begin
    pnlOrders.Visible := True;
    gridOrders.Visible := True;
  end;
  
  // 初始化订单详情相关变量
  selectedOrderID := -1;
  
  // 确保查询组件已创建
  if not Assigned(qryOrderDetails) then
    qryOrderDetails := TFDQuery.Create(Self);
  
  if not Assigned(qryOrderHistory) then
    qryOrderHistory := TFDQuery.Create(Self);
  
  ConnectToDatabase;
  
  // 设置默认日期范围
  dtpStartDate.Date := Date - 30;  // 默认显示过去30天
  dtpEndDate.Date := Date;         // 默认结束日期为今天
  
  Caption := '配送员界面';
  
end;

procedure TDeliveryForm.gridOrdersCellClick(Column: TColumn);
begin
  if not Assigned(gridOrders.DataSource) or not Assigned(gridOrders.DataSource.DataSet) then
    Exit;
    
  selectedOrderID := gridOrders.DataSource.DataSet.FieldByName('order_id').AsInteger;
  
  // 启用订单详情按钮
  btnOrderDetails.Enabled := True;
  
  // 根据订单状态启用或禁用按钮
  if gridOrders.DataSource.DataSet.FieldByName('status').AsString = 'processing' then
  begin
    btnAcceptOrder.Enabled := True;
    btnConfirmDelivery.Enabled := False;
  end
  else if gridOrders.DataSource.DataSet.FieldByName('status').AsString = 'delivering' then
  begin
    btnAcceptOrder.Enabled := False;
    btnConfirmDelivery.Enabled := True;
  end
  else
  begin
    btnAcceptOrder.Enabled := False;
    btnConfirmDelivery.Enabled := False;
  end;
end;

procedure TDeliveryForm.AdjustGridColumnWidths(AGrid: TDBGrid; const AColumnWidths: TDictionary<string, Integer>);
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

procedure TDeliveryForm.btnUpdateDeliveryInfoClick(Sender: TObject);
begin
  // 简单输入验证
  if (Trim(edtName.Text) = '') or (Trim(edtContactInfo.Text) = '') then
  begin
    ShowMessage('姓名和联系信息不能为空！');
    Exit;
  end;

  try
    qryUpdateDeliveryInfo.Close;
    qryUpdateDeliveryInfo.SQL.Text := 'UPDATE delivery_man SET name = :name, contact_info = :contact_info WHERE delivery_man_id = :delivery_id';
    qryUpdateDeliveryInfo.ParamByName('name').AsWideString := Trim(edtName.Text);
    qryUpdateDeliveryInfo.ParamByName('contact_info').AsWideString := Trim(edtContactInfo.Text);
    qryUpdateDeliveryInfo.ParamByName('delivery_id').AsInteger := FDeliveryID;
    qryUpdateDeliveryInfo.ExecSQL;
    ShowMessage('信息更新成功！');
  except
    on E: Exception do
    begin
      ShowMessage('更新信息失败：' + E.Message);
    end;
  end;
end;

procedure TDeliveryForm.btnGenerateStatsClick(Sender: TObject);
begin
  CalculateDeliveryRevenue;
end;

function TDeliveryForm.GetStatusDescription(const Status: string): string;
begin
  // 调用共享单元中的方法，传入配送员ID
  Result := TOrderStatusHelper.GetStatusDescription(Status, 0, FDeliveryID);
end;

procedure TDeliveryForm.UpdateOrderStatusDisplay(ALabel: TLabel; const Status: string);
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

procedure TDeliveryForm.FormatOrderTimeline(const JsonStr: string; var FormattedText: string);
begin
  TOrderStatusHelper.FormatOrderTimeline(JsonStr, FormattedText);
end;

procedure TDeliveryForm.InitializeOrderDetailsDialog;
begin
  if not Assigned(dlgOrderDetails) then
  begin
    dlgOrderDetails := TForm.Create(Self);
    with dlgOrderDetails do
    begin
      Caption := '订单详情';
      Width := 650;
      Height := 550;
      Position := poScreenCenter;
      BorderStyle := bsDialog;
      
      pnlOrderInfo := TPanel.Create(dlgOrderDetails);
      with pnlOrderInfo do
      begin
        Parent := dlgOrderDetails;
        Align := alTop;
        Height := 150;
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
      end;
      
      gridOrderItems := TStringGrid.Create(dlgOrderDetails);
      with gridOrderItems do
      begin
        Parent := dlgOrderDetails;
        Align := alTop;
        Height := 150;
        Top := 150;
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

procedure TDeliveryForm.ShowEnhancedOrderDetails(OrderID: Integer);
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
      'o.merchant_id, o.customer_id, o.delivery_man_id ' +
      'FROM order_info o ' +
      'JOIN customer c ON o.customer_id = c.customer_id ' +
      'JOIN merchant m ON o.merchant_id = m.merchant_id ' +
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
    DeliveryManID := FDeliveryID; // 当前配送员ID
    
    lblOrderID.Caption := Format('订单编号: #%d', [OrderID]);
    lblOrderStatus.Caption := Format('状态: %s', [TOrderStatusHelper.GetStatusDescription(CurrentStatus, MerchantID, DeliveryManID)]);
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

procedure TDeliveryForm.LoadOrderStatusHistory(OrderID: Integer);
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

procedure TDeliveryForm.btnOrderDetailsClick(Sender: TObject);
begin
  if selectedOrderID <= 0 then
  begin
    ShowMessage('请先选择一个订单');
    Exit;
  end;
  
  ShowEnhancedOrderDetails(selectedOrderID);
end;

procedure TDeliveryForm.btnCloseDetailsClick(Sender: TObject);
begin
  dlgOrderDetails.Close;
end;

end. 
