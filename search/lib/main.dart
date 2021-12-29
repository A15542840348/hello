import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 错误提示：Error: Cannot run with sound null safety, because the following dependencies
// 解决方案：Run->Edit Configurations
//         填入 --no-sound-null-safety

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            child: const Text("test"),
            onPressed: () {
              // ignore: avoid_print
              print('按钮回调');
            },
          ),
          SearchTextFieldBar(),
        ],
      ),
    );
  }
}

class SearchTextFieldBar extends StatefulWidget {
  ///搜索框的长度
  double? width;
  ///显示清除文字按钮
  bool showClear;
  ///点击键盘上的回车键的回调
  Function(String text)? onSubmitted;
  ///返回键颜色
  Color backColor;
  ///返回键的回调
  Function()? onBackCallback;
  ///搜索框的高度
  double height;
  ///搜索框的圆角
  double defaultBorderRadius;
  ///搜索框上显示的文案
  String hint;
  SearchTextFieldBar({
    this.hint = '搜索',
    Key? key,
    this.width = 40,
    this.showClear = false,
    this.backColor = Colors.brown,
    this.onBackCallback,
    this.onSubmitted,
    this.height = 40,
    this.defaultBorderRadius = 20.0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchTextFieldBarState();
  }
}

class SearchTextFieldBarState extends State<SearchTextFieldBar>
    with SingleTickerProviderStateMixin {
  ///文本输入框的默认使用控制器
  TextEditingController defaultTextController = TextEditingController();
  ///边距
  EdgeInsets maigin = const EdgeInsets.only(top: 10.0, bottom: 10.0);
  ///是否显示左侧返回按钮
  bool isShowBackButton = false;
  ///搜索框背景色
  Color backgroundColor = Colors.blue;
  ///对其方式
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center;
  late Animation<double> animation;
  late AnimationController controller;
  //创建FocusNode对象实例
  FocusNode focusNode = FocusNode();

  ///点击图标进入输入框
  iconCallback() {
    if (animation.status == AnimationStatus.dismissed) controller.forward();
    Future.delayed(const Duration(seconds: 1), () {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void initState() {
    super.initState();
    //添加listener监听
    //对应的TextField失去或者获取焦点都会回调此监听
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        print('得到焦点');
      } else {
        print('失去焦点');
        if (defaultTextController.text == '') {
          controller.reverse();
        }
      }
    });

    //伸缩动画
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    //图片宽高从0变到300
    animation = Tween(begin: 40.0, end: 300.0).animate(controller);
    animation.addListener(() {
      setState(() {
        widget.width = animation.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: maigin, //添加外部修改widet.margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ///左侧返回按钮
          buildLeftBackWidget(),

          ///右侧搜索框内容区域
          buildContentContainer(),
        ],
      ),
    );
  }

  ///左侧按钮
  Widget buildLeftBackWidget() {
    ///在APPBar位置时需要返回按键
    if (isShowBackButton) {
      return BackButton(
        color: widget.backColor,
        onPressed: () {
          if (widget.onBackCallback != null) {
            widget.onBackCallback!();
          } else {
            Navigator.of(context).pop();
          }
        },
      );
    } else {
      return Container();
    }
  }

  Container buildContentContainer() {
    return Container(
      height: widget.height,
      width: widget.width, //calulateWidth(),

      ///内边距
      padding: EdgeInsets.only(left: 10),

      ///圆角边框
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(widget.defaultBorderRadius),
      ),
      child: Row(
        ///居中
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: IconButton(
              onPressed: () {
                //iconCallback
                iconCallback();
                //print("点击搜索按钮");
              },
              icon: ImageIcon(
                AssetImage('images/search_icon.png'),
                color: Colors.white,
              ),
              //icon: Icon(Icons.manage_search),
              padding: EdgeInsets.all(0.0),
              iconSize: 40,
              color: Colors.white,
              alignment: Alignment.centerLeft,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment(-1, 0),
              child: TextField(
                ///控制textfield清空
                controller: defaultTextController,

                ///当输入文本时实时回调
                onChanged: (text) {
                  ///多层判断 优化刷新
                  ///只有当有改变时再刷新
                  if (text.length > 0) {
                    if (!widget.showClear) {
                      widget.showClear = true;
                      setState(() {});
                    }
                  } else {
                    if (widget.showClear) {
                      widget.showClear = false;
                      setState(() {});
                    }
                  }
                },
                onSubmitted: (text) {
                  if (widget.onSubmitted != null) {
                    widget.onSubmitted!(text);
                  }
                  focusNode.unfocus();
                },

                ///输入框不自动获取焦点
                autofocus: false,
                focusNode: focusNode,

                style: const TextStyle(
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  ///重要 用于编辑框对齐
                  isDense: true,

                  ///清除文本内边框
                  contentPadding: EdgeInsets.zero,

                  ///不设置边框
                  border: InputBorder.none,

                  ///设置提示文本
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          buildClearButton(),
        ],
      ),
    );
  }

  ///清除按键
  ///当文本框有内容输入时显示清除按钮
  buildClearButton() {
    ///当文本输入框中有内容时才显示清除按钮
    if (widget.showClear) {
      return IconButton(
        icon: const Icon(
          Icons.clear,
          size: 24.0,
          color: Colors.white70,
        ),
        onPressed: () {
          widget.showClear = false;
          setState(() {});
          defaultTextController.clear();
          if (!focusNode.hasFocus) {
            controller.reverse();
          }
        },
      );
    } else {
      return Container();
    }
  }

  ///计算当前 Widget 使用到的宽度
  /*double? calulateWidth() {
    ///如果左侧的返回按钮显示了
    ///则需要减去按钮所占用的宽度
    if (isShowBackButton) {
      widget.width = widget.width! - 60.0;
    }
    return widget.width;
  }*/

  @override
  void dispose() {
    controller.dispose();
    //释放
    focusNode.dispose();
    super.dispose();
  }
}
