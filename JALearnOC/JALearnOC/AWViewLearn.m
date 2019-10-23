//
//  AWViewLearn.m
//  JALearnOC
//
//  Created by jason on 20/4/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWViewLearn.h"

@implementation AWViewLearn

-(instancetype)init
{
    self = [super init];
    if(self){
        
    }
    
    return self;
}

#warning 分类、扩展、代理、通知、KVO(Key-value observing)、KVC(Key-value coding)、属性
//如果开发者想让这个类禁用KVC，那么重写+ (BOOL)accessInstanceVariablesDirectly方法让其返回NO即可，这样的话如果KVC没有找到set<Key>:属性名时，会直接用setValue：forUndefinedKey：方法。

/*
七、属性关键字
1.读写权限：readonly,readwrite(默认)
2.原子性: atomic(默认)，nonatomic。atomic读写线程安全，但效率低，而且不是绝对的安全，比如如果修饰的是数组，那么对数组的读写是安全的，但如果是操作数组进行添加移除其中对象的还，就不保证安全了。
3.引用计数：

retain/strong
assign：修饰基本数据类型，修饰对象类型时，不改变其引用计数，会产生悬垂指针，修饰的对象在被释放后，assign指针仍然指向原对象内存地址，如果使用assign指针继续访问原对象的话，就可能会导致内存泄漏或程序异常
weak：不改变被修饰对象的引用计数，所指对象在被释放后，weak指针会自动置为nil
copy：分为深拷贝和浅拷贝
浅拷贝：对内存地址的复制，让目标对象指针和原对象指向同一片内存空间会增加引用计数
深拷贝：对对象内容的复制，开辟新的内存空间
 
 可变对象的copy和mutableCopy都是深拷贝
 不可变对象的copy是浅拷贝，mutableCopy是深拷贝
 copy方法返回的都是不可变对象
 
 
 @property (nonatomic, copy) NSMutableArray * array;这样写有什么影响？
 因为copy方法返回的都是不可变对象，所以array对象实际上是不可变的，如果对其进行可变操作如添加移除对象，则会造成程序crash
*/

#warning block 注意小结
//1、不使用外部变量的block是全局block
//2、使用外部变量并且未进行copy操作的block是栈block
//3、对栈block进行copy操作，就是堆block，而对全局block进行copy，仍是全局block
@end
