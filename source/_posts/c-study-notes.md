---
title: 《C++入门经典（第10版）》学习笔记
date: 2021-3-13 17:36:42
author: Tokisaki Galaxy
summary: 
tags: 
categories: 学习记录
---

写在学《C++入门经典（第10版）》的时候，主要是记录一些以前没有注意，不知道的地方。

强力安利这本书，讲的浅显易懂，而且使用的技术都比较新，非常适合自学的人。

全文都是我一个字一个字打上来的，为了省事，会适量忽略一些不重要信息（比如要包含声明头文件，反正vs有提示，就不打了）。

## 第2章 C++基础知识

### 转义序列

名称|转义序列
---|---
换行符|\n
水平制表符|\t
响铃符|\a
反斜杠|\\
双引号|\"

此外， C++11 支持**原始字符串字面值**，适合于有大量字符需要转义的情况。
要求以`R`开头，而且字符串内容要放到圆括号内，圆括号外还要再加一对双引号。
以下代码输出字符串字面值 "c:\Windows\"。

```c++
cout << R"(c:\Windows\)";
```

### 格式化带小数点的数字

[传送门](#用流函数格式化输出)

## 第3章 更多的控制流程

### 枚举类型（选读）

**枚举类型**是值用一组 int 类型的常量来定义的类型。枚举类型就像是包含了一组声明常量的列表。
枚举类型中，两个或更多的命名常量可接受同一个 int 值。
如果不指定任何数值，枚举类型中的标识符会被自动分配一组连续的值，这些值的第一个是0，其余常量是上一个值增加1——除非显式指定了一个或多个枚举常量的值。

```c++
enum Direction { NORTH = 0, SOUTH = 1, EAST = 2, WEST = 3 }
enum Direction { NORTH, SOUTH, EAST, WEST }
//以上两条语句等价。
```

C++11 中引入了一种新的枚举，称为**强枚举**或**枚举类**。
为定义强枚举，在 enum 后添加关键字 class 就可以了。

### 再论递增操作符和递减操作符

++在变量之前，先递增再返回值；++在变量之后，先返回值再递增。

## 第4章 过程抽象和返回值的函数

### 一些预定义函数

名称|说明
---|---
sqrt|平方根
pow|乘方（幂）（实参，返回值均为 double ）
abs|取 int 的绝对值
labs|取 long 的绝对值
fabs|取 double 的绝对值
ceil|向上取整
floor|向下取整
srand|为随机数生成器提供种子值
rand|随机数

### 强制类型转换

```c++
static_cast<目标类型>(表达式);
// int 转 double
static_cast<double>(3);

//强制类型转换的古老形式
类型名(表达式);
double(3);

//虽然说要尽量使用第一种，但是第二种打的字少一些，所以...
```

### 另一种形式的函数声明

函数声明中不一定要列出形参名称，以下两个函数声明等价：

```c++
double abc(int a, double b);
double abc(int, double);
```

但应坚持使用第一种形式，以确保可读性。

## 第5章 用函数完成所有子任务

### 传引用参数

有时候有奇效，用起来超级舒服。

```c++
// 普通的（传值调用函数）声明方法
int abc(int a);
// 传引用函数声明方法
int abc(int& a);
```

## 第6章 I/O流——对象和类入门

### 文件I/O

```c++
using namespace std;
ifstream inStream;
ofstream outStream;

inStream.open("infile.dat");
outStream.open("outfile.dat");

inStream.close();
outStream.close();
```

#### 追加到文件（选读）

```c++
ofstream fout;
fout.open("data.txt",ios::app);
```

### 用流函数格式化输出

每个输出流的成员函数（部分）：

标志|含义
---|---
precision()|指定小数点后不同位数
setf()|设置标志
width()|输出项占多少个空格（域宽）（用于左右对齐）

setf()的格式化标志：

标志|含义
---|---
ios::fixed|不用科学计数法
ios::scientific|用科学计数法
ios::showpoint|显示浮点数后面所有0
ios::showpos|正整数之前会输出正号
ios::right|右对齐
ios::left|左对齐

任何标志都可以使用unsetf()取消。

### 操纵元

标志|含义
---|---
endl|这个不说了
setw|和width完全一样
setprecision|和precision完全一样

这玩意感觉挺多余的。。

### 字符串I/O

put(),get(),putback()

#### 万用型流参数

适用于有时候是cin，有时候是输入文件流的情况。

名称|关键字
---|---
输入流|istream
输出流|ostream

#### 函数的默认实参（选读）

```c++
void newLine(istream& inStream = cin);
```

#### 检查文件结尾

方法1：

```c++
double next, sum = 0;
int count = 0;
while (inStream >> next)
{
    sum += next;
    count++;
}
```

方法2：
eof成员函数。

#### 预定义字符函数

待施工。。。
