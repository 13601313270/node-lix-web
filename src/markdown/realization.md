## 实现方式

通过webpack插件，将源码，提取到两个项目中
![image](https://upload-images.jianshu.io/upload_images/8105934-e08aa70e291dcc0e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "image") 

## 开发模式的改变

### 1、没有API

我们不在需要api，连http的路径都是随机的，开发过程基于函数，为了方便调试lix做了一个改动，就是**service**内部的代码如果有console.log，虽然它是在服务器端执行，但是它会输出到浏览器端的控制台里，统一了了两端的调试。
![image](https://upload-images.jianshu.io/upload_images/8105934-8caa984b93b303e3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "image") 
我们再也不用需要打点日志的系统了，方便了日常和预发环境的调试。

### 2、后端逻辑复用

如果后端某些逻辑是复用逻辑那么lix如何开发呢？过去后端的复用是基于api地址的复用，所有页面使用一个http地址。那么lix如何处理复用呢？
答案是基于函数
![image](https://upload-images.jianshu.io/upload_images/8105934-120e0972a9df9a53.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "image") 
我举了一个例子，有一个常用的删除功能，那么我们提取一个函数，函数里面有远端调用。所有使用方，调用这个函数即可。用这种方式，我们很方便的把跟这个事件相关的前后端逻辑，都封装到里面，我们重新组织了复用，我们的复用是基于前后端一体的复用

### 3、作用域

因为**service**内部的执行是物理隔离的，所以不要试图通过作用域链获取外部的变量，例如这样：
![image](https://upload-images.jianshu.io/upload_images/8105934-5630bfbb491037e9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "image") 
这样服务端执行的时候，会报错获取不到变量，所有要传递的数据，通过参数传递，例如这样映射：
![image](https://upload-images.jianshu.io/upload_images/8105934-dcdfd94770c61818.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "image") 

### 4、上下文

服务器端执行的部分需要上下文，lix开发方式，通过this对象来绑定所有要执行的变量和方法，例如这样：
![image](https://upload-images.jianshu.io/upload_images/8105934-ee9a1d5a17e09867.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "image") 

上下文变量，`this.user`和上下文方法`this.runSql()`，过去node开发中的中间件，都需要用代码来代替，例如例子中的`this.user.type==='admin'`，代表管理员用户。

上下文的扩展，主要通过扩展this对象来实现，当然也可以继续使用require方法引用基础包。但是官方并不建议这样做。

那么我的项目如何改造才能使用lix的一体化开发方式呢。首先要求你的项目有一个伴随的Node项目，最好是midway、ice这样的既有node又有web的框架。

使用一体化开发，能够加快开发进度，是一种优秀的全栈开发实践。随着使用可以发现，对整个项目的代码层次来讲更适合开发者的阅读，代码更整齐。
结合分布式开发框架，可以拆分项目。
