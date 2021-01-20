//
//  LLJBlockController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/2/25.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJBlockController.h"

//typedef简化Block的声明 声明一类block
typedef NSString* (^TypeBlock)(NSString *str);

@interface LLJBlockController ()

//block的三种定义方式和使用
//不带参数和返回值
@property (nonatomic, copy) void (^voidBlock)(void);
//带参数和返回值
@property (nonatomic, copy) NSString* (^returnBlock)(NSString *str,NSString *num);
//typedef简化Block的声明
@property (nonatomic, copy) TypeBlock tBlock;
//已方法参数形式使用
- (void)testBlockOne:(TypeBlock)block;

- (void)testBlockTwo:(NSString* (^)(NSString *str))testBlock;

@end

@implementation LLJBlockController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //1
    self.voidBlock = ^{
        NSLog(@"voidBlock");
    };
    !self.voidBlock ?: self.voidBlock();
    
    //2
    self.returnBlock = ^NSString *(NSString *str, NSString *num) {
        return str;
    };
    if (self.returnBlock) {
        NSString *str = self.returnBlock(@"zha",@"ha");
        NSLog(@"str = %@",str);
    }
    
    //3
    self.tBlock = ^NSString *(NSString *str) {
        return @"haha";
    };
    if (self.tBlock) {
        NSString *str = self.tBlock(@"zha");
        NSLog(@"str = %@",str);
    }
    
    //4
    [self testBlockOne:^NSString *(NSString *str) {
        
        NSLog(@"str = %@",str);
        return str;
    }];
    
    //5
    [self testBlockTwo:^NSString *(NSString *str) {
        
        NSLog(@"str = %@",str);

        return str;
    }];
    
}

- (void)testBlockOne:(TypeBlock)block{
    block(@"haha");
}

- (void)testBlockTwo:(NSString *(^)(NSString *))testBlock{
    testBlock(@"shazi");
}
//    5. Block与内存管理 Block：带有自动变量（局部变量）的匿名函数。它是C语言的扩充功能。之所以是拓展，是因为C语言不允许存在这样匿名函数。
//
//    根据Block在内存中的位置分为三种类型：
//
//    NSGlobalBlock是位于全局区的block，它是设置在程序的数据区域（.data区）中。
//
//    NSStackBlock是位于栈区，超出变量作用域，栈上的Block以及 __block变量都被销毁。
//
//    NSMallocBlock是位于堆区，在变量作用域结束时不受影响。
//
//    注意：在 ARC 开启的情况下，将只会有 NSConcreteGlobalBlock 和 NSConcreteMallocBlock 类型的 block。
//
//    一般来说我们总会在设置Block之后，在合适的时间回调Block，而不希望回调Block的时候Block已经被释放了，所以我们需要对Block进行copy，copy到堆中，以便后用。
//
//    Block可能会导致循环引用问题，因为block在拷贝到堆上的时候，会retain其引用的外部变量，那么如果block中如果引用了他的宿主对象，那很有可能引起循环引用
//    4.1 截获自动变量与__block说明符
//
//    前面讲过block所在函数中的，捕获自动变量。但是不能修改它，不然就是“编译错误”。但是可以改变全局变量、静态变量、全局静态变量。其实这两个特点不难理解：
//
//    不能修改自动变量的值是因为：block捕获的是自动变量的const值，名字一样，不能修改
//
//    可以修改静态变量的值：静态变量属于类的，不是某一个变量。由于block内部不用调用self指针。所以block可以调用。
//
//    解决block不能修改自动变量的值，这一问题的另外一个办法是使用__block修饰符。
//    正如它们名字显示得一样，表明了block的三种存储方式：栈、全局、堆。获取block对象中的isa的值，可以得到上面其中一个，下面开始说明哪种block存储在栈、堆、全局。

/*
   1.2 带有自动变量
关于“带有自动变量（局部变量）”的含义，这是因为Block拥有捕获外部变量的功能。在Block中访问一个外部的局部变量，Block会持用它的临时状态，自动捕获变量值，外部局部变量的变化不会影响它的的状态。
   
   int val = 10; void (^blk)(void) = ^{ printf("val=%d
   ",val);
   };
   val = 2;
   blk();
   
   上面这段代码，输出值是：val = 10，而不是2。

block在实现时就会对它引用到的它所在方法中定义的栈变量进行一次只读拷贝，然后在block块内使用该只读拷贝；换句话说block截获自动变量的瞬时值；或者block捕获的是自动变量的副本。
   由于block捕获了自动变量的瞬时值，所以在执行block语法后，即使改写block中使用的自动变量的值也不会影响block执行时自动变量的值。
   
   __block int val = 10; void (^blk)(void) = ^{printf("val=%d
   ",val);};
   val = 2;
   blk();
   
   上面的代码，跟第一个代码段相比只是多了一个__block修饰符。但是输出结果确是2。

   5.1 位于全局区：GlobalBlock

   生成在全局区block有两种情况：

   定义全局变量的地方有block语法时

   void(^block)(void) = ^ { NSLog(@"Global Block");}; int main() {
    
   }复制代码
   block语法的表达式中没有使用应截获的自动变量时

   int(^block)(int count) = ^(int count) { return count;
       };
    block(2);复制代码
   虽然，这个block在循环内，但是blk的地址总是不变的。说明这个block在全局段。注：针对没有捕获自动变量的block来说，虽然用clang的rewrite-objc转化后的代码中仍显示_NSConcretStackBlock，但是实际上不是这样的。

   5.2 位于栈内存：StackBlock

   这种情况，在非ARC下是无法编译的，在ARC下可以编译。

   block语法的表达式中使用截获的自动变量时

   NSInteger i = 10;
   block = ^{ NSLog(@"%ld", i);
   };
   block;复制代码
   设置在栈上的block，如果其作用域结束，该block就被销毁。同样的，由于__block变量也配置在栈上，如果其作用域结束，则该__block变量也会被销毁。

   另外，例如

   typedef void (^block_t)() ;

   -(block_t)returnBlock{
       __block int add=10; return ^{ printf("add=%d
   ",++add);
       };
   }复制代码
   5.3 位于堆内存：MallocBlock

   堆中的block无法直接创建，其需要由_NSConcreteStackBlock类型的block拷贝而来(也就是说block需要执行copy之后才能存放到堆中)。由于block的拷贝最终都会调用_Block_copy_internal函数。

   void(^block)(void); int main(int argc, const char * argv[]) { @autoreleasepool {

          __block NSInteger i = 10;
          block = [^{
              ++i;
          } copy];
          ++i;
          block(); NSLog(@"%ld", i);
      } return 0;
   }复制代码
   我们对这个生成在栈上的block执行了copy操作，Block和__block变量均从栈复制到堆上。上面的代码，有跟没有copy，在非ARC和ARC下一个是stack一个是Malloc。这是因为ARC下默认为Malloc（即使如此，ARC下还是有一些例外，下面会讲）。

   block在ARC和非ARC下有巨大差别。多数情况下，ARC下会默认把栈block被会直接拷贝生成到堆上。那么，什么时候栈上的Block会复制到堆上呢？

   调用Block的copy实例方法时

   Block作为函数返回值返回时

   将Block赋值给附有__strong修饰符id类型的类或Block类型成员变量时

   将方法名中含有usingBlock的Cocoa框架方法或GCD的API中传递Block时

   block在ARC和非ARC下的巨大差别
   在 ARC 中，捕获外部了变量的 block 的类会是 NSMallocBlock 或者 NSStackBlock，如果 block 被赋值给了某个变量，在这个过程中会执行 _Block_copy 将原有的 NSStackBlock 变成 NSMallocBlock；但是如果 block 没有被赋值给某个变量，那它的类型就是 NSStackBlock；没有捕获外部变量的 block 的类会是 NSGlobalBlock 即不在堆上，也不在栈上，它类似 C 语言函数一样会在代码段中。

   在非 ARC 中，捕获了外部变量的 block 的类会是 NSStackBlock，放置在栈上，没有捕获外部变量的 block 时与 ARC 环境下情况相同
   
   即使如此，ARC下还是有一些例外：

   例外
   - (void)viewDidLoad {
       [super viewDidLoad]; // Do any additional setup after loading the view, typically from a nib. [self testBlockForHeap0];
   } #pragma mark - testBlockForHeap0 - crash -(NSArray *)getBlockArray0{ int val =10; return [NSArray arrayWithObjects:
               ^{NSLog(@"blk0:%d",val);},
               ^{NSLog(@"blk1:%d",val);},nil];
   }


   -(void)testBlockForHeap0{ NSArray *tempArr = [self getBlockArray0]; NSMutableArray *obj = [tempArr mutableCopy]; typedef void (^blk_t)(void);
       blk_t block = (blk_t){[obj objectAtIndex:0]};
       block();
   }复制代码
   这段代码在最后一行blk()会异常，因为数组中的block是栈上的。因为val是栈上的。解决办法就是调用copy方法。这种场景，ARC也不会为你添加copy，因为ARC不确定，采取了保守的措施：不添加copy。所以ARC下也是会异常退出。


   image.png
   例外的改进1
   调用block 的copy函数，将block拷贝到堆上:

   - (void)viewDidLoad {
       [super viewDidLoad]; // Do any additional setup after loading the view, typically from a nib. [self testBlockForHeap1];
   }

   -(void)testBlockForHeap1{ NSArray *tempArr = [self getBlockArray1]; NSMutableArray *obj = [tempArr mutableCopy]; typedef void (^blk_t)(void);
       blk_t block = (blk_t){[obj objectAtIndex:0]};
       block();
   }

   -(NSArray *)getBlockArray1{ int val =10; return [NSArray arrayWithObjects:
               [^{NSLog(@"blk0:%d",val);} copy],
               [^{NSLog(@"blk1:%d",val);} copy],nil];
   }复制代码
   打个断点可见，该Block的类型：


   image.png
   例外的改进2
   例如下面代码中，在addBlockToArray方法中的block还是_NSConcreteStackBlock类型的，在testBlockForHeap2方法中就被复制到了堆中，成为_NSConcreteMallocBlock类型的block：

   - (void)viewDidLoad {
       [super viewDidLoad]; // Do any additional setup after loading the view, typically from a nib. [self testBlockForHeap2];
   }

   - (void)addBlockToArray:(NSMutableArray *)array { int val =10;
       [array addObjectsFromArray:@[
            ^{NSLog(@"blk0:%d",val);},
            ^{NSLog(@"blk1:%d",val);}]];
   }

   - (void)testBlockForHeap2{

       NSMutableArray *array = [NSMutableArray array];
       [self addBlockToArray:array]; typedef void (^blk_t)(void); blk_t block = (blk_t){[array objectAtIndex:0]};
       block();
   }复制代码
   打个断点可见，其中Block的类型：
   
   6.2 实现分析

   这里只选取部分关键代码。

   不难看出int main(int argc, char * argv[]) {就是主函数的实现。

   int main(int argc, char * argv[]) {  @autoreleasepool  { __AtAutoreleasePool __autoreleasepool; typedef void (*blk_t)(void); blk_t block = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
           ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);

       }
   }复制代码
   其中，__main_block_impl_0是block的一个C++的实现(最后面的_0代表是main中的第几个block)，也就是说也是一个结构体。

   (1) __main_block_impl_0

   __main_block_impl_0定义如下：

   struct __main_block_impl_0 { struct __block_impl impl; struct __main_block_desc_0* Desc; __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
       impl.isa = &_NSConcreteStackBlock;
       impl.Flags = flags;
       impl.FuncPtr = fp;
       Desc = desc;
     }
   };复制代码
   
   5.4 Block的复制

   在全局block调用copy什么也不做

   在栈上调用copy那么复制到堆上

   在堆上调用block 引用计数增加

   -(void) stackOrHeap{
       __block int val =10;
       blkt1 s= ^{ return ++val;};
       s();
       blkt1 h = [s copy];
       h();
   }复制代码
   不管block配置在何处，用copy方法复制都不会引起任何问题。在ARC环境下，如果不确定是否要copy这个block，那尽管copy即可。

   最后的强调，在 ARC 开启的情况下，除非上面的例外，默认只会有 NSConcreteGlobalBlock 和 NSConcreteMallocBlock 类型的 block。

   6. Block的底层研究方法

   6.1 研究工具：clang

   为了研究编译器是如何实现 block 的，我们需要使用 clang。clang 提供一个命令，可以将 Objetive-C 的源码改写成 c 语言的，借此可以研究 block 具体的源码实现方式。

   首先cd到代码文件目录

   cd /Users/ChenMan/iOSTest/BlockTestApp复制代码
   然后执行clang命令

   clang -rewrite-objc main.m复制代码
   其中，main.m的代码写好如下

   #include  int main(int argc, char * argv[]) {
       @autoreleasepool { typedef void (^blk_t)(void); blk_t block = ^{ printf("Hello, World!
   ");
           };
           block(); //        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class])); }
   }复制代码
   执行情况：
   
   (2) __block_impl

   其中__block_impl的定义如下：

   struct __block_impl { void *isa; int Flags; int Reserved; void *FuncPtr;
   };复制代码
   其结构体成员如下：

   isa，指向所属类的指针，也就是block的类型

   flags，标志变量，在实现block的内部操作时会用到

   Reserved，保留变量

   FuncPtr，block执行时调用的函数指针

   可以看出，它包含了isa指针（包含isa指针的皆为对象），也就是说block也是一个对象(runtime里面，对象和类都是用结构体表示)。

   (3) __main_block_desc_0

   __main_block_desc_0的定义如下：

   static struct __main_block_desc_0 { size_t reserved; size_t Block_size;
   } __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};复制代码
   其结构成员含义如下：

   reserved：保留字段

   Block_size：block大小(sizeof(struct __main_block_impl_0))

   以上代码在定义__main_block_desc_0结构体时，同时创建了__main_block_desc_0_DATA，并给它赋值，以供在main函数中对__main_block_impl_0进行初始化。

   (4) __main_block_desc_0

   如上的main函数中，__main_block_func_0也是block的一个C++的实现

   static void __main_block_func_0(struct __main_block_impl_0 *__cself) { printf("Hello, World!
   ");
           }复制代码
   (5) 综合可知：

   __main_block_impl_0的isa指针指向了_NSConcreteStackBlock。

   从main函数的main.cpp中看，__main_block_impl_0的FuncPtr指向了函数__main_block_func_0。

   __main_block_impl_0的Desc也指向了定义__main_block_desc_0时就创建的__main_block_desc_0_DATA，其中纪录了block结构体大小等信息。

   以上就是根据编译转换的结果。当然，由于 clang 改写的具体实现方式和 LLVM 不太一样，有急切底层兴趣的读者可以进行更深入的研究。
   */

@end
