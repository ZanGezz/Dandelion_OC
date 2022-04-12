//
//  LLJVideoHelper.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/16.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//AVAsset：素材库里的素材；
//AVAssetTrack：素材的轨道；
//AVMutableComposition ：一个用来合成视频的工程文件；
//AVMutableCompositionTrack ：工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材；
//AVMutableVideoCompositionLayerInstruction：视频轨道中的一个视频，可以缩放、旋转等；
//AVMutableVideoCompositionInstruction：一个视频轨道，包含了这个轨道上的所有视频素材；
//AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行；
//AVAssetExportSession：配置渲染参数并渲染。

typedef NS_ENUM(NSUInteger, LLJVideoOrientation) {
    LLJVideoOrientationUp,               //Device starts recording in Portrait
    LLJVideoOrientationDown,             //Device starts recording in Portrait upside down
    LLJVideoOrientationLeft,             //Device Landscape Left  (home button on the left side)
    LLJVideoOrientationRight,            //Device Landscape Right (home button on the Right side)
    LLJVideoOrientationNotFound = 99
};

@interface LLJVideoHelper : NSObject

/**
 * TODO:设置系统声音
 */
+ (CGFloat)degressFromVideoFileWithURL:(NSURL *)url;

+ (LLJVideoOrientation)videoOrientationWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
