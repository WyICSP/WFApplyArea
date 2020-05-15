#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSObject+RuntimeMethodHelper.h"
#import "UICollectionView+CollectEvent.h"
#import "UIControl+CollectEvent.h"
#import "UIScrollView+CollectEvent.h"
#import "UITableView+CollectEvent.h"
#import "UIViewController+CollectEvent.h"
#import "CollectionManager.h"
#import "StorageManager.h"
#import "EventModel.h"
#import "PageModel.h"

FOUNDATION_EXPORT double WFStatisticsVersionNumber;
FOUNDATION_EXPORT const unsigned char WFStatisticsVersionString[];

