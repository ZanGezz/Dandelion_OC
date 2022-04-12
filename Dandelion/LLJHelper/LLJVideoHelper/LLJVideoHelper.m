//
//  LLJVideoHelper.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/16.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJVideoHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation LLJVideoHelper

+ (CGFloat)degressFromVideoFileWithURL:(NSURL *)url {
    
    CGFloat angel = 0.0;
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;

        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            //Portrait
            angel = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            //PortraitUpsideDown
            angel = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            //LandscapeRight
            angel = M_PI_2;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            //LandscapeLeft
            angel = 180;
        }
    }
       return angel;
}

+ (LLJVideoOrientation)videoOrientationWithURL:(NSURL *)url {
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if ([videoTracks count] == 0) {
        return LLJVideoOrientationNotFound;
    }

    AVAssetTrack* videoTrack    = [videoTracks objectAtIndex:0];
    CGAffineTransform txf       = [videoTrack preferredTransform];
    CGFloat videoAngleInDegree  = atan2(txf.b, txf.a) * 180 / M_PI;
    
    LLJVideoOrientation orientation = 0;
    switch ((int)videoAngleInDegree) {
        case 0:
            orientation = LLJVideoOrientationRight;
            break;
        case 90:
            orientation = LLJVideoOrientationUp;
            break;
        case 180:
            orientation = LLJVideoOrientationLeft;
            break;
        case -90:
            orientation = LLJVideoOrientationDown;
            break;
        default:
            orientation = LLJVideoOrientationNotFound;
            break;
    }

    return orientation;
}

@end
