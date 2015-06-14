//
//  GEOSwiftCallback.m
//
//  Created by Andrea Cremaschi on 20/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

#import "GEOSwiftCallback.h"
#import <geos/geos_c.h>

#ifdef LOG_VERBOSE
#define HLogInfo(fmt, ...) DDLogInfo((@"--[GEOSwift INFO]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogWarn(fmt, ...) DDLogWarn((@"--[GEOSwift WARNING]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogError(fmt, ...) DDLogError((@"--[GEOSwift ERROR]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogVerbose(fmt, ...) DDLogVerbose((@"--[GEOSwift]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define HLogInfo(fmt, ...) NSLog((@"--[GEOSwift INFO]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogWarn(fmt, ...) NSLog((@"--[GEOSwift WARNING]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogError(fmt, ...) NSLog((@"--[GEOSwift ERROR]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogVerbose(fmt, ...) NSLog((@"--[GEOSwift]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

#ifdef LOG_VERBOSE
#define GEOSwiftLumberjack 1
#else
#define GEOSwiftLumberjack 0
#endif

@interface NSString (FromVariadic)
+(NSString *)stringFromVariadicArgumentsList:(const char *)args, ... NS_REQUIRES_NIL_TERMINATION;
@end

@implementation NSString (FromVariadic)

#pragma mark - Callbacks

+(NSString *)stringFromVariadicArgumentsList:(const char *)fmt, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableString *newContentString = [NSMutableString string];
    va_list args;
    va_start(args, fmt);
    for (const char *arg = fmt; arg != nil; arg = va_arg(args, const char*))
    {
        [newContentString appendString: [NSString stringWithUTF8String:arg]];
    }
    va_end(args);
    
    return [newContentString copy];
}
@end

void noticeCallback(const char *args,...) {
    NSString *noticeString= [NSString stringFromVariadicArgumentsList:args, nil];
#if GEOSwiftLumberjack
    HLogInfo(@"%@.", noticeString);
#else
    NSLog(@"--[GEOSwift NOTICE] -- %@.", noticeString);
#endif
};

void errorCallback(const char *args,...) {
    NSString *errorString= [NSString stringFromVariadicArgumentsList:args, nil];
#if GEOSwiftLumberjack
    HLogError(@"%@.", errorString);
#else
    NSLog(@"--[GEOSwift ERROR] -- %@.", errorString);
#endif
};

#pragma mark - Wrappers

GEOSContextHandle_t initGEOSWrapper_r() {
    return initGEOS_r(noticeCallback, errorCallback);
}

//void GEOSGeom_destroyWrapper_r(GEOSContextHandle_t handle, GEOSGeometry* g) {
//    @try {
//        GEOSGeom_destroy_r(handle, g);
//    }
//    @catch (NSException *exception) {
//    }
//    @finally {
//    }
//}
