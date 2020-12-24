# 项目介绍

目前中后台项目，越来越流行大前端一体化项目，项目内部包含Api接口逻辑，包含展示模块，以达到一个人就可以维护项目，避免独立后端开发人员排期冲突。

目前比较流行的框架有
阿里的飞冰：https://ice.work/docs/guide/basic/structure
虽然前后端都在一个项目里，但是这类项目总会有独立的目录，来分别放View和Api逻辑。两部分也是分别用独立的框架来实现，例如 Koa 和 React。

一个目录提供Api接口，View项目提供展示，两者之间通过Api地址链接。就像下图这样。
![v2-272ad54e2ade561d4b2827f1d51a19dc_720w.png](https://ata2-img.oss-cn-zhangjiakou.aliyuncs.com/87285d227d5c9779b929c928031cf1b9.png)

还有一点要注意，中后台项目的这种接口调用映射关系，有一个特点，就是提供的接口一般并不具备复用性，通过对大量项目的统计，超过60%的接口只被一个功能点使用。所以接口和调用者是高度耦合的。

这从逻辑上讲，具有必然性，如果某个一体化项目里的接口，被其他项目引用，想必也是一个逻辑上很奇怪的事情。因为复用性高、通用性强的逻辑，也不会放到前后端一体化项目里，必然以独立的服务对外提供。所以整体结构就像下图这样。Node提供紧耦合的Api，但是会去调用其他通用的服务。
![v2-a3cc2afb608bf2207cef7d4b881867c3_720w.png](https://ata2-img.oss-cn-zhangjiakou.aliyuncs.com/52a845d19a9295412956498215731cd6.png)


接下来我们针对一个接口，我们来看一下每一个具体的例子，左侧是view项目，期间会调用/api/data接口，右侧是Node项目提供/api/data的后端逻辑。

![20200909225259.jpg](https://ata2-img.oss-cn-zhangjiakou.aliyuncs.com/ab19c71483fceee86fad5409d966ae2c.jpg)
新的一体化应用，通过特殊的__service__作用域，可以将两者代码写在一起。所有在`__service__`内部的代码都会在服务器执行


使用lix一体化开发，过去我们需要在两个项目里维护代码，现在可以前后端js代码写在一起。

![avatar](https://img.alicdn.com/tfs/TB1TUA3fkcx_u4jSZFlXXXnUFXa-1920-1080.jpg)

###所有在`__service__`内部的代码都会在服务器端执行

![20200909225439.jpg](https://ata2-img.oss-cn-zhangjiakou.aliyuncs.com/ed5f307ffc477b92ce7e556e8e7aad4e.jpg)

## 开发模式的改变

### 1、没有API
我们不在需要api，连http的路径都是随机的，开发过程基于函数，为了方便调试lix做了一个改动，就是__service__内部的代码如果有console.log，虽然它是在服务器端执行，但是它会输出到浏览器端的控制台里，统一了了两端的调试。
![FA3D306E-6FDC-4BAB-A909-FE6B7EE5D6AF.png](https://ata2-img.oss-cn-zhangjiakou.aliyuncs.com/79f15b1847c9ca2ddecdd564fa319e5f.png)
我们再也不用需要打点日志的系统了，方便了日常和预发环境的调试。

### 2、后端逻辑复用
如果后端某些逻辑是复用逻辑那么lix如何开发呢？过去后端的复用是基于api地址的复用，所有页面使用一个http地址。那么lix如何处理复用呢？
答案是基于函数
![595C6CF9-9981-4BD2-99D6-A4F1F0F85BE9.png](https://ata2-img.oss-cn-zhangjiakou.aliyuncs.com/f2aca68a9aa2ba918b126626bcbbeb50.png)
我举了一个例子，有一个常用的删除功能，那么我们提取一个函数，函数里面有远端调用。所有使用方，调用这个函数即可。用这种方式，我们很方便的把跟这个事件相关的前后端逻辑，都封装到里面，我们重新组织了复用，我们的复用是基于前后端一体的复用

### 3、作用域
因为__service__内部的执行是物理隔离的，所以不要试图通过作用域链获取外部的变量，例如这样：
![EE934DDD-D134-4916-AAB7-30E5D075BFD3.png](https://ata2-img.oss-cn-zhangjiakou.aliyuncs.com/ea75a6ed80f556720ac3d042a191bd35.png)
这样服务端执行的时候，会报错获取不到变量，所有要传递的数据，通过参数传递，例如这样映射：
![B664494A-937D-45D6-B7D7-E994CF90F62E.png](https://ata2-img.oss-cn-zhangjiakou.aliyuncs.com/6e9a48c95daac67e56ad02f4f818f1cd.png)

### 4、上下文
服务器端执行的部分需要上下文，lix开发方式，通过this对象来绑定所有要执行的变量和方法，例如这样：
![3C7CFF21-6EB8-4B3B-A3BE-F82194E7E7CB.png](https://ata2-img.oss-cn-zhangjiakou.aliyuncs.com/7f45c723ca35fab2db4b3fd25c4467ac.png)

上下文变量，`this.user`和上下文方法`this.runSql()`，过去node开发中的中间件，都需要用代码来代替，例如例子中的`this.user.type==='admin'`，代表管理员用户。

上下文的扩展，主要通过扩展this对象来实现，当然也可以继续使用require方法引用基础包。但是官方并不建议这样做。

那么我的项目如何改造才能使用lix的一体化开发方式呢。首先要求你的项目有一个伴随的Node项目，最好是midway、ice这样的既有node又有web的框架。
