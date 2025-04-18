unit OrderStatus;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.DateUtils,
  Vcl.Graphics, System.UITypes;

type
  // 定义订单状态常量
  TOrderStatusConstants = class
  public
    // 状态常量
    const
      STATUS_PENDING = 'pending';
      STATUS_PROCESSING = 'processing';
      STATUS_PROCESSED = 'processed';
      STATUS_DELIVERING = 'delivering';
      STATUS_DELIVERED = 'delivered';
      STATUS_CANCELLED = 'cancelled';
  end;

  // 订单状态辅助类
  TOrderStatusHelper = class
  public
    // 获取状态对应的中文描述
    class function GetStatusDescription(const Status: string; const MerchantID: Integer = 0; const DeliveryManID: Integer = 0): string;
    
    // 格式化订单状态时间线
    class procedure FormatOrderTimeline(const JsonStr: string; var FormattedText: string);
    
    // 获取状态对应的颜色
    class function GetStatusColor(const Status: string): TColor;
    
    // 添加状态样式到文本组件
    class procedure ApplyStatusStyle(const Status: string; var Font: TFont);
  end;

implementation

{ TOrderStatusHelper }

class function TOrderStatusHelper.GetStatusDescription(const Status: string; const MerchantID: Integer = 0; const DeliveryManID: Integer = 0): string;
begin
  if Status = string(TOrderStatusConstants.STATUS_PENDING) then
    Result := string('待处理')
  else if Status = string(TOrderStatusConstants.STATUS_PROCESSING) then
    Result := string('处理中')
  else if Status = string(TOrderStatusConstants.STATUS_PROCESSED) then
    Result := string('已处理')
  else if Status = string(TOrderStatusConstants.STATUS_DELIVERING) then
    Result := string('配送中')
  else if Status = string(TOrderStatusConstants.STATUS_DELIVERED) then
    Result := string('已送达')
  else if Status = string(TOrderStatusConstants.STATUS_CANCELLED) then
    Result := string('已取消')
  else
    Result := Status;
    
  // 根据状态添加对应的ID信息
  if (Status = string(TOrderStatusConstants.STATUS_PENDING)) or 
     (Status = string(TOrderStatusConstants.STATUS_PROCESSING)) or 
     (Status = string(TOrderStatusConstants.STATUS_PROCESSED)) or 
     (Status = string(TOrderStatusConstants.STATUS_CANCELLED)) then
  begin
    if MerchantID > 0 then
      Result := Result + Format(' (商家ID: %d)', [MerchantID]);
  end
  else if (Status = string(TOrderStatusConstants.STATUS_DELIVERING)) or 
          (Status = string(TOrderStatusConstants.STATUS_DELIVERED)) then
  begin
    if DeliveryManID > 0 then
      Result := Result + Format(' (配送员ID: %d)', [DeliveryManID]);
  end;
end;

class procedure TOrderStatusHelper.FormatOrderTimeline(const JsonStr: string; var FormattedText: string);
var
  JsonObj: TJSONObject;
  Status, TimeStr: string;
  UpdatedAt: TDateTime;
  MerchantID, DeliveryManID: Integer;
  Year, Month, Day, Hour, Min, Sec: Word;
begin
  JsonObj := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;
  try
    Status := JsonObj.GetValue('status').Value;
    
    // 默认使用当前时间
    UpdatedAt := Now;
    
    // 尝试解析更新时间
    if JsonObj.TryGetValue('updated_at', TimeStr) then
    begin
      // 从JSON中提取时间字符串，移除时区信息
      TimeStr := StringReplace(TimeStr, '+08', '', [rfReplaceAll]);
      TimeStr := StringReplace(TimeStr, '+00', '', [rfReplaceAll]);
      
      // 尝试多种方式解析时间
      if Pos('.', TimeStr) > 0 then
      begin
        // 包含毫秒的格式：2025-04-14 13:14:28.347706
        // 移除毫秒部分以简化解析
        TimeStr := Copy(TimeStr, 1, Pos('.', TimeStr) - 1);
      end;
      
      try
        // 尝试使用标准格式解析
        UpdatedAt := StrToDateTime(TimeStr);
      except
        // 如果标准解析失败，尝试手动解析
        try
          if Length(TimeStr) >= 19 then // 确保有足够的字符
          begin
            Year := StrToIntDef(Copy(TimeStr, 1, 4), 0);
            Month := StrToIntDef(Copy(TimeStr, 6, 2), 0);
            Day := StrToIntDef(Copy(TimeStr, 9, 2), 0);
            Hour := StrToIntDef(Copy(TimeStr, 12, 2), 0);
            Min := StrToIntDef(Copy(TimeStr, 15, 2), 0);
            Sec := StrToIntDef(Copy(TimeStr, 18, 2), 0);
            
            if (Year > 0) and (Month > 0) and (Day > 0) then
              UpdatedAt := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Min, Sec, 0);
          end;
        except
          // 如果所有解析尝试都失败，保持使用当前时间
        end;
      end;
    end;
    
    // 读取可能存在的商家ID和配送员ID
    MerchantID := 0;
    DeliveryManID := 0;
    
    if JsonObj.TryGetValue('merchant_id', Status) and (Status <> 'null') then
      MerchantID := StrToIntDef(Status, 0);
      
    if JsonObj.TryGetValue('delivery_man_id', Status) and (Status <> 'null') then
      DeliveryManID := StrToIntDef(Status, 0);
    
    Status := JsonObj.GetValue('status').Value;
    FormattedText := Format('%s - 状态变更为: %s', 
      [FormatDateTime('yyyy-mm-dd hh:nn:ss', UpdatedAt),
       GetStatusDescription(Status, MerchantID, DeliveryManID)]);
  finally
    JsonObj.Free;
  end;
end;

class function TOrderStatusHelper.GetStatusColor(const Status: string): TColor;
begin
  if Status = TOrderStatusConstants.STATUS_PENDING then
    Result := clGray
  else if Status = TOrderStatusConstants.STATUS_PROCESSING then
    Result := clBlue
  else if Status = TOrderStatusConstants.STATUS_PROCESSED then
    Result := clNavy
  else if Status = TOrderStatusConstants.STATUS_DELIVERING then
    Result := clPurple
  else if Status = TOrderStatusConstants.STATUS_DELIVERED then
    Result := clGreen
  else if Status = TOrderStatusConstants.STATUS_CANCELLED then
    Result := clRed
  else
    Result := clWindowText;
end;

class procedure TOrderStatusHelper.ApplyStatusStyle(const Status: string; var Font: TFont);
begin
  // 应用字体样式
  Font.Style := [fsBold];
  Font.Color := GetStatusColor(Status);
end;

end. 
