

#import "NSDate+EZ.h"

@implementation NSDate (EZ)

+ (NSTimeInterval)getNowTimeStamp {
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)humanDateFromTimestamp:(NSTimeInterval)timestamp {
    NSString *timeStr = @"";
	NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzGMT];
	NSDate *now = [NSDate date];
	NSDate *that = [NSDate dateWithTimeIntervalSince1970: timestamp];
    
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setTimeZone:tzGMT];
	
	[outputFormatter setDateFormat: @"yyyy"];
	int nowYear = [[outputFormatter stringFromDate:now] intValue];
	int thatYear = [[outputFormatter stringFromDate:that] intValue];
	
	[outputFormatter setDateFormat: @"M"];
	int nowMonth = [[outputFormatter stringFromDate:now] intValue];
	int thatMonth = [[outputFormatter stringFromDate:that] intValue];
	
	[outputFormatter setDateFormat: @"d"];
	int nowDay = [[outputFormatter stringFromDate:now] intValue];
	int thatDay = [[outputFormatter stringFromDate:that] intValue];
	
	NSTimeInterval disTimeInterval = [now timeIntervalSinceDate:that];
	int dis = disTimeInterval;
	if (dis < 0) {
		timeStr = @"刚刚";
	}else if (nowMonth == thatMonth && nowYear == thatYear){
		if (nowDay == thatDay) {
			if (dis < 3600) {
				if (dis/60 == 0) {
					timeStr = @"刚刚";
				} else {
					timeStr = [NSString stringWithFormat:@"%d分钟前",dis/60];
				}
			} else {
				[outputFormatter setDateFormat: @"今天 H:mm"];
				timeStr = [outputFormatter stringFromDate:that];
			}
		} else if(nowDay == thatDay + 1){
			[outputFormatter setDateFormat: @"昨天 H:mm"];
			timeStr = [outputFormatter stringFromDate:that];
		} else if(nowDay == thatDay + 2){
			[outputFormatter setDateFormat: @"前天 H:mm"];
			timeStr = [outputFormatter stringFromDate:that];
		} else {
			[outputFormatter setDateFormat: @"M月d日 H:mm"];
			timeStr = [outputFormatter stringFromDate:that];
		}
	}else if (nowYear == thatYear && nowMonth != thatMonth){
		[outputFormatter setDateFormat: @"M月d日 H:mm"];
		timeStr = [outputFormatter stringFromDate:that];
	}else{
		[outputFormatter setDateFormat: @"yyyy年 M月d日"];
		timeStr = [outputFormatter stringFromDate:that];
	}
	
	return timeStr;
}

+ (NSString *)dateTimeBetweenStartDate:(NSDate *)sDate endDate:(NSDate *)eDate {
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *dataComponent = [cal components:unitFlags fromDate:sDate toDate:eDate options:0];
    
	int intervalDay = [dataComponent day];
	int intervalHour = [dataComponent hour];
	int intervalMinute = [dataComponent minute];
	int intervalSecond = [dataComponent second];
    
	NSString *hour = nil;
	NSString *minute = nil;
	NSString *second = nil;
	
	if (intervalDay <= 0) {
		if (intervalHour <= 0) {
			if (intervalMinute <= 0) {
				if (intervalSecond <= 0) {
					return [NSString stringWithFormat:@"活动已结束"];
				}
				intervalMinute = 0;
			}
			intervalHour = 0;
		}
		intervalDay = 0;
	}
    
	if (intervalSecond < 10) {
		second = [NSString stringWithFormat:@"0%d",intervalSecond];
	} else {
		second = [NSString stringWithFormat:@"%d",intervalSecond];
	}
    
	if (intervalMinute < 10) {
		minute = [NSString stringWithFormat:@"0%d",intervalMinute];
	} else {
		minute = [NSString stringWithFormat:@"%d",intervalMinute];
	}
    
	if (intervalHour < 10) {
		hour = [NSString stringWithFormat:@"0%d",intervalHour];
	} else {
		hour = [NSString stringWithFormat:@"%d",intervalHour];
	}
    
	return [NSString stringWithFormat:@"%d天 %@小时 %@分",intervalDay,hour,minute];
    
}

@end
