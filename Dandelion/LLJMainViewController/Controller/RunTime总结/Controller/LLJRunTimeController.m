//
//  LLJRunTimeController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/2/24.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJRunTimeController.h"
#import "LLJRunTimeController+RunTime.h"

@interface LLJRunTimeController ()
{
    NSString *_zhao;
    NSString *_qian;
    NSString *_sun;
    NSString *_li;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *jiang;
@property (nonatomic, strong) NSString *liu;
@property (nonatomic, strong) NSString *zhou;
@property (nonatomic, strong) NSString *wu;
@property (nonatomic, strong) NSString *zheng;
@property (nonatomic, strong) NSString *wang;

- (void)addRunTimeMethod;

@end

@implementation LLJRunTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.name = @"RunTime";
    
    self.age = @"22";
    
    NSLog(@"name = %@, age = %@",self.name,self.age);
    
    NSLog(@"属性 = %@",[self getAllProperties]);
    
    NSLog(@"成员变量 = %@",[self getAllIvar]);

    NSLog(@"方法名 = %@",[self printMothList]);
    
    NSLog(@"_zhao = %@,_qian = %@,_sun = %@,_li = %@,_name = %@,_jiang = %@,_wang = %@,",_zhao,_qian,_sun,_li,self.name,self.jiang,self.wang);
    
    [self setValue:@"傻子" forKeyPath:@"haha"];
    
    [self addRunTimeMethod];
    
    //[self performSelector:@selector(addRunTimeMethod)];
}

#pragma mark - 遍历属性 -
- (NSArray *)getAllProperties{
   u_int count;
   objc_property_t *properties = class_copyPropertyList([self class], &count);
   NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
   for (int i = 0; i<count; i++)
    {
       const char* propertyName = property_getName(properties[i]);
       [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
   free(properties);
   return propertiesArray;
}

#pragma mark - 遍历成员变量 -
- (NSArray *)getAllIvar{
   u_int count;
   Ivar *var = class_copyIvarList([self class], &count);
   NSMutableArray *varArray = [NSMutableArray arrayWithCapacity:count];
   for (int i = 0; i<count; i++)
    {
        const char* propertyName = ivar_getName(var[i]);
        [varArray addObject: [NSString stringWithUTF8String:propertyName]];
        [self setValue:[NSString stringWithFormat:@"赞歌zzz%d",i] forKeyPath:[NSString stringWithUTF8String:propertyName]];
    }
   free(var);
   return varArray;
}

#pragma mark - 遍历方法 -
-(NSArray *)printMothList
{
    NSMutableArray *mothedArray = [NSMutableArray array];
    unsigned int mothCout_f;
    Method *mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0; i<mothCout_f; i++)
    {
        Method temp_f = mothList_f[i];
        IMP imp_f = method_getImplementation(temp_f);
        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        
        [mothedArray addObject: [NSString stringWithUTF8String:name_s]];
    }
    free(mothList_f);
    return mothedArray;
}

#pragma mark - kvc设置成员变量值时没有找到成员变量，调用该方法抛出异常 -
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"没有找到该成员");
}


#pragma mark - 动态添加方法 -
/*
 首先，该方法在调用时，系统会查看这个对象能否接收这个消息（查看这个类有没有这个方法，或者有没有实现这个方法。），如果不能并且只在不能的情况下，就会调用下面这几个方法，给你“补救”的机会，你可以先理解为几套防止程序crash的备选方案，我们就是利用这几个方案进行消息转发，注意一点，前一套方案实现后一套方法就不会执行。如果这几套方案你都没有做处理，那么程序就会报错crash。
 方案一：
 + (BOOL)resolveInstanceMethod:(SEL)sel；
 方案二：
 - (id)forwardingTargetForSelector:(SEL)aSelector;
 方案三：
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
 - (void)forwardInvocation:(NSInvocation *)anInvocation;
 
 
 类里方法过多时或给系统类动态添加方法
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"没有找到该成员");
//    参数一: Class：我们需要一个class，比如我的[self class]。
//
//    参数二: SEL：方法
//
//    参数三: IMP ：IMP就是Implementation的缩写，它是指向一个方法实现的指针，每一个方法都有一个对应的IMP。这里需要的是IMP，所以你不能直接写方法，参照上述 1 来获取
//
//    参数四: const char *types：
//    ”v@:”意思就是这已是一个void类型的方法，没有参数传入。
//    “i@:”就是说这是一个int类型的方法，没有参数传入。
//    ”i@:@”就是说这是一个int类型的方法，有一个对象参数传入。
//    因为每一个方法会默认隐藏两个参数，self、_cmd，self代表方法调用者，_cmd代表这个方法的SEL，该参数就是用来描述这个方法的返回值、参数的，v 代表返回值为void，@ 表示self，: 表示_cmd。
    if (sel == @selector(addRunTimeMethod)) {
        IMP imp = class_getMethodImplementation([self class], @selector(run1));
        class_addMethod([self class], sel, imp, "V@:");
        //class_addMethod([self class], sel, (IMP)run, "V@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

void run(int i, char a) {
    NSLog(@" i = %d, a = %c",i,a);
}

- (void)run1{
    NSLog(@"run/....");
}

@end
