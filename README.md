# BluetoothLE
An easy using SDK for CoreBluetooth



### 扫描

```objective-c
[[BLE shared] scan];
[[BLE shared] whenFindBluetooth:^(CBPeripheral *peripheral) {
        // 扫描的到的蓝牙(会重复更新已发现蓝牙)
}];
[[BLE shared] whenFindBluetoothAll:^(NSDictionary *peripheralDict) {
	// 扫描到的蓝牙列表
}];
```



### 连接

```objective-c
[[BLE shared] connect:peripheral];
[[BLE shared] whenConnectSuccess:^{
	// 连接成功
}];
[[BLE shared] whenConnectFailure:^{
	// 连接失败
}];
```



### 更新服务

```objective-c
[[BLE shared] whenUpdateService:^(CBService *service) {
	// 更新服务的特征值（services's characteristic）
}];
```



### 断开

```objective-c
[[BLE shared] unconnect];
[[BLE shared] whenUnconnect:^{
	// 已断开
}];
```



### 发送数据

```objective-c

[[BLE shared] send: data];
[[BLE shared] whenSendProgressUpdate:^(NSNumber *progress) {
	// 数据发送进度
}];
[[BLE shared] whenSendSuccess:^{
	// 数据发送成功
}];
[[BLE shared] whenSendFailure:^{
	// 数据发送失败
}];
[[BLE shared] whenReceiveData:^(NSData *data) {
	// 接收到蓝牙返回的数据
}];

```



###测试数据

我们测试了五十组数据，并得到如下结果：

![](https://i.imgur.com/HlyKexU.png)

![](https://i.imgur.com/qRZMYHU.png)

![](https://i.imgur.com/O4afajN.png)

[图表对比工程地址](https://github.com/wuyongrui/PIDCharts)