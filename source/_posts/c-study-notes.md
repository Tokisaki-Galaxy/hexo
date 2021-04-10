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

略

## 第7章 数组

### C++11基于范围的for语句

C++11中一种新的for循环，用于快速遍历数组元素。

```c++
int arr[]={1,2,3,4,5};
for(auto i : arr)
    cout<<i;
```

甚至可以这样

```c++
int arr[]={1,2,3,4,5};
for(int& i : arr)
    i++;
for(int i : arr)
    cout<<i;
```

### 整个数组作为函数参数

和传引用参数用法差不多。
**为了防止不经意间的修改，一般使用const修饰。**

## 第8章 字符串和向量

### 预定义C字符串函数

函数|说明|提示
---|---|---
strcpy(Target_string,Src_string)|将Src_string中的值复制到Target_string中|不检查Target_string中最大可存储的容量
strcat(Target_string,Src_string)|将Src_string中的值连接到Target_string末尾|不检查Target_string中最大可存储的容量
strlen(Src_string)|返回Src_string长度的整数（空字符'\0'不计算在内）
strcmp(String_1, String_2)|如果两个字符串相等，就返回0|如果相等，会返回0，它会转换成false。注意这可能与你想象的相反。

如果需要检查Target_string中最大可存储的容量，可以使用例如strcpy_s，后面带_s的函数。

### 标准string类

#### getline成员函数

有两个版本

```c++
istream& getline(istream& ins, string& strVar, char delimiter);
istream& getline(istream& ins, string& strVar);
```

第一个版本允许你自定义定界符，第二个版本默认定界符为'\n'

**注意，混用cin和getline的时候需要注意，cin会把'\n'给getline，导致getline读到空字符串。**

#### 成员函数

示例|说明
---|---
**元素访问**<br>str[i]<br>str.at(i)<br><br>str.substr(position, length)<br>str,length()|<br>返回对索引i处的引用，不检查非法索引<br>和上面一样，但是这个版本会检查非法索引<br>返回调用对象的一个子字符串，从position开始，含有length个字符<br>返回长度
**赋值/修改**<br>str.empty()<br>str.insert(pos, str2)<br>str.erase(pos, length)|<br>如果str为空字符串，就返回true，否则返回false<br>在str的pos处插入str2<br>删除长度为length的子字符串，从pos处开始
**查找**<br>str.find(str1)<br><br>str.find(str1, pos)<br>str.find_first_of(str1, pos)<br>str.find_first_not_of(str1, pos)|<br>返回str1在str中首次出现的索引。如果str1没找到，返回特殊值string::npos<br>返回str1在str中首次出现的索引，从pos出开始查找<br>返回str1的任何字符在str中首次出现的索引，从pos处开始查找<br>返回不属于str1的任何字符在str中首次出现的索引，从pos处开始查找

#### 小细节

赋值操作不适应于C字符串，所以下面这个看似合法的语句其实是非法的。

```c++
aCString = stringVariable.c_str();  //非法
```

#### 字符串转换

C++11下的函数（C++11前滚）
转化到数字
stof(不会吧还有人用float),stod,stoi,stol
各种奇怪的类型转换为字符串
to_string

### 向量

最喜欢的功能之一，必须拥有名字，安排上。
*可以自动扩充还一下子就知道长度的高级数组谁不喜欢呢*

## 第9章 指针和动态数组

### 基本内存管理

new完了记得要delete。
另外delete之后的虚悬指针记得要指向nullptr。
