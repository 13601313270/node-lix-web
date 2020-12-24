## 准备工作

`npm i node-lix`

### 1、在webpack配置文件里添加插件（view项目）
```javascript
const {lix} = require('node-lix')
module.exports = {
  entry: {
    index: 'XXXX',
  },
  output: {
    publicPath: '/'
  },
  module: {
    rules: []
  },
  plugins: [
    new lix({
      // 提取的服务端code文件保存到的位置
      getSaveCodePath(hash) {
        return `${__dirname}/../service`
      },
      // 浏览器请求这个函数对应的http的地址
      getHttpUrl(hash, annotation) {
        if (annotation) {
          return `/api_service/${hash}/${annotation}`
        } else {
          return `/api_service/${hash}`
        }
      },
      // 提取的服务端code保存的文件名
      saveFileName(hash, annotation) {
        return hash + '.js'
      }
    }),
  ]
};
```
### 2、创建服务端代码里的this对象（node项目）

**service**包的函数的上下文都在this对象上扩展

![image](https://upload-images.jianshu.io/upload_images/8105934-43aea154230b2d43.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "image") 

我们在Node项目里创建一个类，用于远端调用代码代码的this对象

以midway例如：

```javascript
import {provide, inject} from '@ali/midway';
@provide('thisService')
export class IThis {
  sql(sql){
    // run sql code
  }
}
```

### 3、中间层（链接http地址和保存的code文件）（node项目）

接下来你需要根据你的项目情况，写一个中间层，保证node服务，接收http地址，可以正确的去执行保存的函数。

例如 midway 用可以这样写

```javascript
import {provide, controller, post, inject} from '@ali/midway';
import {IThis} from '../../RunInService';
@provide()
@controller('/api_service')
export class RunInServiceController {
  @inject()
  thisService: IThis;
  @post('/:path')
  @post('/:path/:name')
  async templates(ctx): Promise<void> {
    await super.send(
      async () => {
        const {path} = this.params;
        const {params} = this.body;
        // 去生成的文件夹拉取生成的code文件
        const apiFunc = require('../../../service/' + path)
        // 执行的时候，第二步构造的IThis类的实例，绑定作为this对象
        try {
          ctx.body = await apiFunc.default.call(this.thisService, ...params);
        } catch (e) {
          ctx.body = await apiFunc.error(e);
        }
      }
    );
  }
}
```

### 4、创建前端 函数（view项目）
```javascript
import {IThis} from '../../../node/src/This.ts';// 引入第二步构造的服务端this对象，可以获得完整的IDE语法提示
export function createService<T>(self: T) {
  return function (service: (this: T, ...params: any[]) => any, ...params: any[]): any {
    // @ts-ignore
    if (service instanceof Promise) {
      // @ts-ignore
      return service.then(res => {
        return res;
      });
    } else {
      // @ts-ignore
      return Promise.resolve(service);
    }
  };
}
export const __service__ = createService(new IThis())
```

保存在view项目里，名称需要叫`__service__.js`或者`__service__.ts`
如果不使用ts类型，这一步可以省略

## 使用

### react的Demo
```react
import React, {useState, useEffect} from 'react';
import {__service__} from "@/__service__";
export default function () {
  const [data, setData] = useState([]);
  return <div>
    <div onClick={async () => {
      const data = await __service__(function () {
        return this.sql('select * from XXX');
      });
      setData(data)
    }}>
      获取数据
    </div>
    <div>
      {
        data.map(item => {
          return <p>{item.name}</p>
        })
      }
    </div>
  </div>
}
```

### vue的Demo
```vue
<template>
  <div class="home">
    <button @click="getData">获取数据</button>
  </div>
</template>
<script>
import { __service__ } from '@/__service__'
export default {
  name: 'Home',
  date () {
    return {
      id: 1
    }
  },
  methods: {
    async getData () {
      const dataList = await __service__(async function (id) {
        if (this.user.type === 'admin') {
          return this.runSql('DELETE FROM XXX WHERE id=' + (+id))
        }
      }, this.id)
      console.log(dataList)
    }
  }
}
</script>
```

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
