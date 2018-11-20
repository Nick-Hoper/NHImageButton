# NHImageButton

- Swift 4.2 编写的带图片按钮

可以自由设置图片在按钮中显示的方向，提供上、下、左、右四个方向，并且提供图片与标题间的间距设置。


![1.png](https://github.com/Nick-Hoper/NHImageButton/blob/master/1.png)

![2.png](https://github.com/Nick-Hoper/NHImageButton/blob/master/2.png)


## Features

- 完美支持Swift4.2编译
- 集成使用简单，二次开发扩展强大

## Requirements

- iOS 9+
- Xcode 8+
- Swift 4.0+
- iPhone

## Example

        //初始化按钮
        @IBOutlet weak var testButton: NHImageButton!

        //设置标题
        testButton.setTitle("v间距10v", for: UIControl.State.normal)
        testButton.setTitle("<-间距20", for: UIControl.State.selected)
        //间距
        testButton.setContentMargin(10, for: UIControl.State.normal)
        testButton.setContentMargin(20, for: UIControl.State.selected)
        //设置图片显示方向
        testButton.setContentMode(NHImageButtonMode.imageBottom, for: UIControl.State.normal)
        testButton.setContentMode(NHImageButtonMode.imageLeft, for: UIControl.State.selected)
         
更详细集成方法，根据实际的例子请查看源代码中的demo



