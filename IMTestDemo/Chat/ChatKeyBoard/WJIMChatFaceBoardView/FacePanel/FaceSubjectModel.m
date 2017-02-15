//
//  FaceModel.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "FaceSubjectModel.h"

@implementation FaceModel

//描述方法
- (NSString *)description {
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    // 遍历
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < count; i++) {
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        if ([self valueForKey:name]) {
            [dic setObject:[self valueForKey:name] forKey:name];
        }else {
            [dic setObject:@"" forKey:name];
        }
    }
    return [dic mj_JSONString];
}


@end

@implementation FaceSubjectModel

@end
