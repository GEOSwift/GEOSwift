//
//  HumboldtCallback.m
//  geosswifttest2
//
//  Created by Andrea Cremaschi on 20/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

#import "HumboldtCallback.h"
#import <geos/geos_c.h>

#ifdef LOG_VERBOSE
#define HLogInfo(fmt, ...) DDLogInfo((@"--[Humboldt INFO]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogWarn(fmt, ...) DDLogWarn((@"--[Humboldt WARNING]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogError(fmt, ...) DDLogError((@"--[Humboldt ERROR]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogVerbose(fmt, ...) DDLogVerbose((@"--[Humboldt]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define HLogInfo(fmt, ...) NSLog((@"--[Humboldt INFO]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogWarn(fmt, ...) NSLog((@"--[Humboldt WARNING]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogError(fmt, ...) NSLog((@"--[Humboldt ERROR]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define HLogVerbose(fmt, ...) NSLog((@"--[Humboldt]-- %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

#ifdef LOG_VERBOSE
#define HumboldtLumberjack 1
#else
#define HumboldtLumberjack 0
#endif

@interface NSString (FromVariadic)
+(NSString *)stringFromVariadicArgumentsList:(const char *)args, ... NS_REQUIRES_NIL_TERMINATION;
@end

@implementation NSString (FromVariadic)
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
#if HumboldtLumberjack
    HLogInfo(@"%@.", noticeString);
#else
    NSLog(@"--[Humboldt NOTICE] -- %@.", noticeString);
#endif
};

void errorCallback(const char *args,...) {
    NSString *errorString= [NSString stringFromVariadicArgumentsList:args, nil];
#if HumboldtLumberjack
    HLogError(@"%@.", errorString);
#else
    NSLog(@"--[Humboldt ERROR] -- %@.", errorString);
#endif
};

GEOSContextHandle_t initGEOSWrapper_r() {
    return initGEOS_r(noticeCallback, errorCallback);
}
