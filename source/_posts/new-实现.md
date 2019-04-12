---
title: new 实现
date: 2019-04-12 15:29:45
tags: js
---
## 构造函数和实例化
`js`中可以通过构造函数批量创建对象，创建的过程通过`new`关键词实现，这个过程也叫实例化，实例化的对象具有默认的属性和原型方法
```js
function Person(name, age) {
  this.name = name;
  this.age = age;
}

Person.prototype.sayHello = function() {
  console.log(`My name is ${this.name}, I'm ${this.age} years old`);
}

const jsonya = new Person('jsonya', 25);
jsonya.sayHello();
```

## `new` 的过程做了什么？
- 创建一个空对象
- 将这个空对象的原型指向构造函数的原型
- 执行构造函数，并将默认属性挂载到这个空对象上
- 判断构造函数的返回值，如果是对象则返回这个对象，否则返回这个空对象

## 模拟`new` 关键字？
```js
// New 函数的第一个参数为构造函数，剩余的参数为实例化传入的参数
function New() {
  // step1: 创建一个空对象
  const obj = {};
  // 获取构造函数，默认是第一个参数为构造函数，所以利用数组将参数第一个推出，原来的arguments只剩下非构造函数部分
  const Constructor = [].shift.call(arguments);
  // step2: 将这个空对象的原型指向构造函数原型
  obj.__proto__ = Constructor.prototype;
  // step3: 执行构造函数，并且将属性挂载到空对象
  const result = Constructor.apply(obj, arguments);
  // step4: 判断返回值是不是对象
  return result instanceof Object ? result : obj;
}

function Person(name, age) {
  this.name = name;
  this.age = age;
}
Person.prototype.sayHello = function() {
  console.log(`my name is ${this.name}, I'm ${this.age} years old`);
}
// 执行
const jsonya = New(Person, 'jsonya', 25);
jsonya.sayHello();
```

ok，实现了一个`new`了，但其实我们通过分析原生的new方法可以看出，在new一个函数的时候，会返回一个`func`同时在这个`func`里面会返回一个对象`Object`，这个对象包含父类func的属性以及隐藏的`__proto__`

```js
function New(Constructor) {
  return function() {
    // step1: 创建一个空对象
    const obj = {};
    // step2: 将这个空对象的原型指向构造函数原型
    obj.__proto__ = Constructor.prototype;
    // step3: 执行构造函数，并且将属性挂载到空对象
    const result = Constructor.apply(obj, arguments);
    // step4: 判断返回值是不是对象
    return result instanceof Object ? result : obj;
  }
}

function Person(name, age) {
  this.name = name;
  this.age = age;
}
Person.prototype.sayHello = function() {
  console.log(`my name is ${this.name}, I'm ${this.age} years old`);
}

const jsonya = New(Person)('jsonya', 25);
jsonya.sayHello();
```
可以看出我们的第二种实现原理上是一致的 ，只不过我们将构造函数和参数区分开了
