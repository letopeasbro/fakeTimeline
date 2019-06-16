## 开发环境
* Xcode 10.2.1
* Swift 5.0
* CocoaPods 1.5.3

```
CocoaPods引用
Alamofire		// 网络请求框架
Moya			// 网络抽象层
RxSwift			// 响应式编程框架
RxCocoa			// 响应式编程框架在UIKit上的部分封装
SnapKit			// Swift的AutoLayout框架
MJRefresh		// 列表刷新控件
```


##网络图片加载框架说明
* **WebImageLoader**，处理单个图片加载的对象，首先依次从内存、硬盘、服务器加载该图片，获取到图片后通过回调通知持有者释放本对象
* **WebImageManager**，生成WebImageLoader并管理其执行的多线程任务，考虑复用WebImageLoader减少相同图片的网络请求，但时间限制暂时没有优化
* **WebImageHolder**, 作为UIImageView或其他类型视图网络图片的ViewModel，用来管理WebImageLoader的生命周期和处理同一视图多次请求不同图片的情况