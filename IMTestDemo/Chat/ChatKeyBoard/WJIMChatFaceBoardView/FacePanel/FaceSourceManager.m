//
//  FaceSourceManager.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "FaceSourceManager.h"

@implementation FaceSourceManager

//从持久化存储里面加载表情源
+ (NSArray *)loadFaceSource
{
    NSMutableArray *subjectArray = [NSMutableArray array];
    //, @"emotion"
    NSArray *sources = @[@"face",@"face"];
    
    for (int i = 0; i < sources.count; ++i)
    {
        NSString *plistName = sources[i];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *allkeys = faceDic.allKeys;
        
        FaceSubjectModel *subjectM = [[FaceSubjectModel alloc] init];
        
        if ([plistName isEqualToString:@"face"]) {
            subjectM.faceSize = SubjectFaceSizeKindSmall;
            subjectM.subjectTitle = [NSString stringWithFormat:@"表情%d", i];
            subjectM.subjectIcon = @"f_static_000";
        }
        
//        else {
//            subjectM.faceSize = SubjectFaceSizeKindMiddle;
//            subjectM.subjectTitle = [NSString stringWithFormat:@"动态图%d", i];
//            subjectM.subjectIcon = @"f_static_000";
//        }
        
        
        NSMutableArray *modelsArr = [NSMutableArray array];
        
        for (int i = 0; i < allkeys.count; ++i) {
            NSString *name = allkeys[i];
            //这才是表情
            FaceModel *fm = [[FaceModel alloc] init];
            fm.faceTitle = name;
            fm.faceIcon = [faceDic objectForKey:name];
            [modelsArr addObject:fm];
        }
        subjectM.faceModels = modelsArr;
        
        [subjectArray addObject:subjectM];
    }
    
    
    return subjectArray;
}


@end
