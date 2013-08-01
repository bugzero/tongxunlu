
#import <Foundation/Foundation.h>

@interface NSDate (EZ)

+ (NSTimeInterval)getNowTimeStamp;

+ (NSString *)humanDateFromTimestamp:(NSTimeInterval)timestamp;

+ (NSString *)dateTimeBetweenStartDate:(NSDate *)sDate endDate:(NSDate *)eDate;

@end
