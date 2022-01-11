import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;

  double widthValue = 40.0;
  late Animation<double> animation;
  late AnimationController controller;
  //创建FocusNode对象实例
  FocusNode focusNode = FocusNode();

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
        widthValue = animation.value;
      });
    });
    /*animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画执行结束时反向执行动画
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //动画恢复到初始状态时执行动画（正向）
        controller.forward();
      }
    });*/

    //启动动画（正向）
    //controller.forward();
  }

  void startEasyAnimation() {
    controller.forward();
  }

  void _incrementCounter() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Row(children: <Widget>[
          Text(widget.title),
          Expanded(child: SizedBox()), //自动扩展挤压
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MySearchRoute()),
              );
              //print("点击搜索");
            },
            icon: ImageIcon(
              AssetImage('images/search_icon.png'),
              color: Colors.red,
            ),
          )
        ])),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              SearchStaticBar(
                heroTag: "searchStatidBar",
                clickCallBack: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (animation.status == AnimationStatus.completed) {
                    //动画执行结束时反向执行动画
                    controller.reverse();
                  } else if (animation.status == AnimationStatus.dismissed) {
                    //动画恢复到初始状态时执行动画（正向）
                    controller.forward();
                  }
                  //setWidthValue();
                },
                /*clickCallBack: () {
                _incrementCounter();
                //Navigator.pushNamed(context, TestPage2());
              },*/
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Text(''), // 中间用Expanded控件
                  ),
                  SearchTextFieldBar(
                    hint: "搜索",
                    defaultBorderRadius: 20.0,
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    padding: const EdgeInsets.only(left: 12), //搜索图标和字和左边距
                    heroTag: "searchTextFieldBar",
                    splashColor: const Color(0xFFD6D6D6),
                    backColor: Colors.blue,
                    backgroundColor: Colors.deepPurple,
                    inputTextColor: Colors.red,
                    hintColor: Colors.orange,
                    clearButtonColor: Colors.green,

                    focusNode: focusNode,

                    //controller,
                    onSubmitted: (value) {
                      print("onSubmitted : $value");
                    },
                    onBackCallback: () {
                      print("返回按钮按下"); //不设置的话，会直接返回上一页
                    },
                    //clearCallback,
                    iconCallback: () {
                      if (animation.status == AnimationStatus.dismissed)
                        controller.forward();
                      Future.delayed(Duration(seconds: 1), () {
                        FocusScope.of(context).requestFocus(focusNode);
                      });
                    },
                    inputKeyWordsLength: 20,
                    fontSize: 14,
                    isShowBackButton: true, //是否显示返回按键
                    width:
                        widthValue, //widthValue,//MediaQuery.of(context).size.width - 150,
                    //height : double.infinity
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Expanded(
                  child: Text(''), // 中间用Expanded控件
                ),
                SearchTextFieldBar(
                  hint: "搜索",
                  defaultBorderRadius: 20.0,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  padding: const EdgeInsets.only(left: 12), //搜索图标和字和左边距
                  heroTag: "searchTextFieldBar",
                  splashColor: const Color(0xFFD6D6D6),
                  backColor: Colors.blue,
                  backgroundColor: Colors.blue,
                  inputTextColor: Colors.red,
                  hintColor: Colors.orange,
                  clearButtonColor: Colors.green,

                  //controller,
                  onSubmitted: (value) {
                    print("onSubmitted : $value");
                  },
                  onBackCallback: () {
                    print("返回按钮按下"); //不设置的话，会直接返回上一页
                  },
                  //clearCallback,
                  iconCallback: () {
                    if (animation.status == AnimationStatus.dismissed)
                      controller.forward();
                    Future.delayed(Duration(seconds: 1), () {
                      FocusScope.of(context).requestFocus(focusNode);
                    });
                  },
                  inputKeyWordsLength: 20,
                  fontSize: 14,
                  isShowBackButton: false, //是否显示返回按键
                  width:
                      200, //widthValue,//MediaQuery.of(context).size.width - 150,
                  //height : double.infinity
                ),
              ])
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    //释放
    focusNode.dispose();
    super.dispose();
  }
}

class MySearchRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          //leading: BackButton(color: Colors.blue,),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Row(children: <Widget>[
            Expanded(
              child: SearchTextFieldBar(
                  hint: "搜索",
                  defaultBorderRadius: 3.0,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  padding: const EdgeInsets.only(left: 12), //搜索图标和字和左边距
                  heroTag: "searchTextFieldBar",
                  splashColor: const Color(0xFFD6D6D6),
                  backColor: Colors.blue,
                  backgroundColor: Colors.deepPurple,
                  inputTextColor: Colors.red,
                  hintColor: Colors.orange,
                  clearButtonColor: Colors.green,

                  //focusNode:focusNode,

                  textFieldAutoFocus: true,

                  //controller,
                  onSubmitted: (value) {
                    print("onSubmitted : $value");
                  },
                  onBackCallback: () {
                    print("返回按钮按下"); //不设置的话，会直接返回上一页
                  },
                  //clearCallback,
                  iconCallback: () {},
                  inputKeyWordsLength: 20,
                  fontSize: 14,
                  isShowBackButton: false, //是否显示返回按键
                  width:
                      310, //widthValue,//MediaQuery.of(context).size.width - 150,
                  height: 40),
            ), //自动扩展挤压
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "取消",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                )),
            /*IconButton(
              onPressed: (){
                print("点击搜索");
              },
              icon: ImageIcon(AssetImage('images/search_icon.png'), color: Colors.red,),
            )*/
          ])),
    );
  }
}

class SearchTextFieldBar extends StatefulWidget {
  ///搜索框上显示的文案
  String hint;

  ///hero过渡动画的tag
  String? heroTag;

  ///搜索框的圆角
  double defaultBorderRadius;
  EdgeInsets margin;
  EdgeInsets padding;

  ///如果考虑不需要水波纹效果那么就可以设置颜色为透明色
  Color splashColor;

  ///返回键颜色
  Color backColor;

  ///搜索框背景颜色
  Color backgroundColor;

  ///输入字体颜色
  Color inputTextColor;

  ///提示字体颜色
  Color hintColor;

  ///清除按钮颜色
  Color clearButtonColor;

  ///文本输入框焦点控制
  FocusNode? focusNode;

  ///文本输入框控制器
  TextEditingController? controller;

  ///点击键盘上的回车键的回调
  Function(String text)? onSubmitted;

  ///清除搜索回调
  Function? clearCallback;

  ///返回键的回调
  Function()? onBackCallback;

  ///清除搜索回调
  Function? iconCallback;

  ///输入文本的长度限制
  int inputKeyWordsLength;

  ///输入框文字大小
  double fontSize;

  ///是否显示左侧的返回键
  bool isShowBackButton;

  ///搜索框的长度
  double? width;

  ///搜索框的高度
  double? height;

  ///自动获取焦点
  bool textFieldAutoFocus;

  SearchTextFieldBar(
      {this.hint = "搜索",
      this.defaultBorderRadius = 20.0,
      this.margin = const EdgeInsets.only(top: 10.0, bottom: 10.0),
      this.padding = const EdgeInsets.only(left: 12),
      this.heroTag,
      this.splashColor = const Color(0xFFD6D6D6),
      this.backColor = Colors.white,
      this.backgroundColor = Colors.white,
      this.inputTextColor = Colors.black,
      this.hintColor = const Color(0xff999999),
      this.clearButtonColor = const Color(0xffacacac),
      this.focusNode,
      this.controller,
      this.onSubmitted,
      this.onBackCallback,
      this.iconCallback,
      this.clearCallback,
      this.inputKeyWordsLength = 20,
      this.fontSize = 14,
      this.isShowBackButton = false,
      this.width,
      this.height,
      this.textFieldAutoFocus = false}) {
    if (this.height == null) {
      this.height = this.defaultBorderRadius * 2;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return SearchTextFieldBarState();
  }
}

class SearchTextFieldBarState extends State<SearchTextFieldBar> {
  ///为true 时显示清除选项
  bool showClear = false;

  ///文本输入框的默认使用控制器
  TextEditingController defaultTextController = TextEditingController();
  @override
  void initState() {
    super.initState();

    ///创建默认的焦点控制
    if (widget.focusNode == null) {
      widget.focusNode = new FocusNode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      ///外边距
      margin: widget.margin,

      ///水平方向线性排列
      child: Row(
        children: [
          ///左侧的返回按钮
          buildLeftBackWidget(),

          ///右侧的搜索框内容区域
          buildContentContainer(),
        ],
      ),
    );
  }

  ///构建左侧的返回按钮
  Widget buildLeftBackWidget() {
    ///当用在APPBar的位置时
    ///常常需要配合一个返回按钮
    if (widget.isShowBackButton) {
      ///返回键按钮
      return BackButton(
        color: widget.backColor,
        onPressed: () {
          ///返回事件回调
          if (widget.onBackCallback != null) {
            widget.onBackCallback!();
          } else {
            ///直接关闭当前页面
            Navigator.of(context).pop();
          }
        },
      );
    } else {
      ///当不需要显示返回按钮时
      ///设置一个空视图
      return Container();
    }
  }

  ///构建搜索框的显示区域[Container]
  LayoutBuilder buildContainer(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return buildContentContainer();
    });
  }

  ///构建搜索框的显示区域[Container]
  Container buildContentContainer() {
    return Container(
      height: widget.height,

      ///获取当前StatelessWidget的宽度
      width: calculateWidth(),

      ///对齐方式
      alignment: Alignment(-1, 0),

      ///内边距
      padding: widget.padding,

      ///圆角边框
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.defaultBorderRadius),
      ),
      child: buildRow(),
    );
  }

  ///计算当前 Widget 使用到的宽度
  double? calculateWidth() {
    ///不同应用场景的配制
    if (widget.width != null) {
      return widget.width;
    }

    ///默认使用
    double width = 200;

    ///如果左侧的按钮返回按钮显示了
    ///则需要减去按钮所占用的宽度
    if (widget.isShowBackButton) {
      width -= 60;
    }
    return width;
  }

  ///构建搜索图标与显示文本
  Row buildRow() {
    return Row(
      ///左对齐
      mainAxisAlignment: MainAxisAlignment.start,

      ///居左
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ///左侧的搜索图标
        SizedBox(
          height: 18.0,
          width: 18.0,
          child: IconButton(
            onPressed: () {
              //iconCallback
              if (widget.iconCallback != null) {
                widget.iconCallback!();
              }
              //print("点击搜索按钮");
            },
            icon: ImageIcon(
              AssetImage('images/search_icon.png'),
              color: Colors.red,
            ),
            //icon: Icon(Icons.manage_search),
            padding: EdgeInsets.all(0.0),
            iconSize: 18,
            color: Colors.white,
            alignment: Alignment.centerLeft,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ),
        /*FloatingActionButton(
          onPressed: (){
            print("点击搜索按钮");
          },
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 18.0,height: 18.0),
            child: Image.asset(
              "images/search_icon.png",
              width: 18.0,
              height: 18.0,
            ),
          ),
          backgroundColor:widget.backgroundColor,
          elevation:0,//设置背景阴影

        ),*/
        /*Image.asset(
          "images/a.jpg",//"images/search_icon.png",
          width: 18.0,
          height: 18.0,
        ),*/
        const SizedBox(
          width: 10.0,
        ),

        ///中间的输入框
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment(-1, 0),
            child: buildTextField(),
          ),
        ),

        ///右侧的清除小按钮
        buildClearButton(),
      ],
    );
  }

  ///lib/demo/search_textfield_bar.dart
  ///构建搜索输入TextField
  TextField buildTextField() {
    return TextField(
      ///设置键盘的类型
      keyboardType: TextInputType.text,

      ///键盘回车键的样式为搜索
      textInputAction: TextInputAction.search,

      ///只有苹果手机上有效果
      keyboardAppearance: Brightness.dark,

      ///控制器配置
      controller:
          widget.controller == null ? defaultTextController : widget.controller,

      ///最大行数
      maxLines: 1,

      ///输入文本格式过滤
      inputFormatters: [
        ///输入的内容长度限制
        LengthLimitingTextInputFormatter(widget.inputKeyWordsLength),
      ],

      ///当输入文本时实时回调
      onChanged: (text) {
        ///多层判断 优化刷新
        ///只有当有改变时再刷新
        if (text.length > 0) {
          if (!showClear) {
            showClear = true;
            setState(() {});
          }
        } else {
          if (showClear) {
            showClear = false;
            setState(() {});
          }
        }
      },

      ///点击键盘上的回车键
      ///或者是搜索按钮的回调
      onSubmitted: (text) {
        if (widget.onSubmitted != null) {
          widget.onSubmitted!(text);
        }
      },

      ///输入框不自动获取焦点
      autofocus: widget.textFieldAutoFocus, //false,
      focusNode: widget.focusNode,

      style: TextStyle(
          fontSize: widget.fontSize,
          color: widget.inputTextColor,
          fontWeight: FontWeight.w300),

      ///输入框的边框装饰
      decoration: InputDecoration(
          //重要 用于编辑框对齐
          isDense: true,

          ///清除文本内边跑
          contentPadding: EdgeInsets.zero,

          ///不设置边框
          border: InputBorder.none,

          ///设置提示文本
          hintText: widget.hint,

          ///设置提示文本的样式
          hintStyle: TextStyle(
            fontSize: widget.fontSize,
            color: widget.hintColor,
          )),
    );
  }

  ///清除按键
  ///当文本框有内容输入时显示清除按钮
  buildClearButton() {
    ///当文本输入框中有内容时才显示清除按钮
    if (showClear) {
      return IconButton(
        icon: Icon(
          Icons.clear,
          size: 24.0,
          color: widget.clearButtonColor,
        ),
        onPressed: () {
          showClear = false;
          setState(() {});
          if (widget.controller == null) {
            defaultTextController.clear();
          } else {
            widget.controller!.text = "";
          }
          if (widget.clearCallback != null) {
            widget.clearCallback!();
          }
        },
      );
    } else {
      return Container();
    }
  }
}
