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
  System.Generics.Collections, System.UITypes;

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
    
  private
    FDeliveryID: Integer; // 外卖员ID字段
    selectedOrderID: Integer; // 选中的订单ID
    procedure ConnectToDatabase;
    procedure LoadDeliveryInfo;
    procedure LoadOrders;
    procedure CalculateDeliveryRevenue;
    procedure AdjustGridColumnWidths(AGrid: TDBGrid; const AColumnWidths: TDictionary<string, Integer>);
    procedure GetText(Sender: TField; var Text: String; DisplayText: Boolean);
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

procedure TDeliveryForm.LoadOrders;
var
  OrderWidths: TDictionary<string, Integer>;
begin
  qryOrders.Close;
  
  // 未接单：查询状态为processed的订单，即等待外卖员接单的订单
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
    'WHERE delivery_man_id = :delivery_id ' +
    'AND order_status = ''processed'' ' +
    'AND delivery_man_id IS NULL ' +
    'ORDER BY created_at DESC';

  qryOrders.ParamByName('delivery_id').AsInteger := FDeliveryID;
  qryOrders.Open;

  // 调整列宽度
  if qryOrders.Active then
  begin
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
  LoadOrders;
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
    
  // 确保数据源已创建
  if not Assigned(dsDeliveryInfo) then
  begin
    dsDeliveryInfo := TDataSource.Create(Self);
    if Assigned(qryDeliveryInfo) then
      dsDeliveryInfo.DataSet := qryDeliveryInfo;
  end;
  
  ConnectToDatabase;
  
  // 设置默认日期范围
  dtpStartDate.Date := Date - 30;  // 默认显示过去30天
  dtpEndDate.Date := Date;         // 默认结束日期为今天
  
  Caption := '配送员界面';
end;

procedure TDeliveryForm.gridOrdersCellClick(Column: TColumn);
begin
  if (qryOrders.Active) and (not qryOrders.IsEmpty) then
  begin
    selectedOrderID := qryOrders.FieldByName('订单编号').AsInteger;
    
    // 根据订单状态启用或禁用按钮
    if qryOrders.FieldByName('状态').AsString = 'processed' then
    begin
      // 检查外卖员状态是否为可接单状态
      qryDeliveryInfo.Close;
      qryDeliveryInfo.SQL.Text := 'SELECT status FROM delivery_man WHERE delivery_man_id = :delivery_id';
      qryDeliveryInfo.ParamByName('delivery_id').AsInteger := FDeliveryID;
      qryDeliveryInfo.Open;
      
      btnAcceptOrder.Enabled := (qryDeliveryInfo.FieldByName('status').AsString = 'active_available');
      btnConfirmDelivery.Enabled := False;
    end
    else if qryOrders.FieldByName('状态').AsString = 'delivering' then
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

end. 
