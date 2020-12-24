# 注意事项

1、`__service__`第一个参数是一个函数，必须使用function(){}函数表达式，不能使用箭头函数()=>{}，因为es标准里箭头函数使用外部的this的对象。

2、在`__service__`内的code里执行console.log是推荐的调试方法，console.log的执行，会输出到浏览器端的控制台。但是线上环境建议关闭，否则容易输出敏感内容，关闭方法可以在准备工作第三步配置，类似下面这样

```
  const returnData = await apiFunc.default.call(this.thisService, ...params);
  if(env==='prod'){
    // 添加执行函数捕获的console内容（注意线上环境要返回[]空数组）
    returnData['console'] = [];
  }
  ctx.body = returnData;
```

3、内外作用域是隔离的，不要使用作用域链获取外部的变量
```
async () => {
  const id = 1;// 外部作用域变量
  const data = await __service__(function () {
    return this.sql('select * from XXX where id='+id);// 错误方法，因为隔离性，内部无法引用外部作用域变量id
  });
  setData(data)
}
```
```
async () => {
  const id = 1;// 外部作用域变量
  const data = await __service__(function (id) {
     // 通过参数传递，获取了id
  },id);
  setData(data)
}
```
