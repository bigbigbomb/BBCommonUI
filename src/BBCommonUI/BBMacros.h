#import <Foundation/Foundation.h>

#ifdef __has_feature
#define OBJC_ARC_ENABLED __has_feature(objc_arc)
#else
#define OBJC_ARC_ENABLED 0
#endif

#ifndef NS_BLOCK_ASSERTIONS
#define DAssert(...) NSAssert(__VA_ARGS__)
#else
#define DAssert(...)
#endif

#define KVO_SET(_key_, _value_) [self willChangeValueForKey:@#_key_]; \
self._key_ = (_value_); \
[self didChangeValueForKey:@#_key_];

id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic);
void objc_setProperty(id self, SEL _cmd, ptrdiff_t offset, id newValue, BOOL atomic,
    BOOL shouldCopy);
void objc_copyStruct(void *dest, const void *src, ptrdiff_t size, BOOL atomic,
    BOOL hasStrong);

#define AtomicRetainedSetToFrom(dest, source) \
    objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, NO)
#define AtomicCopiedSetToFrom(dest, source) \
    objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, YES)
#define AtomicAutoreleasedGet(source) \
    objc_getProperty(self, _cmd, (ptrdiff_t)(&source) - (ptrdiff_t)(self), YES)
#define AtomicStructToFrom(dest, source) \
    objc_copyStruct(&dest, &source, sizeof(__typeof__(source)), YES, NO)
#if !__has_feature(objc_arc)
#define NonatomicRetainedSetToFrom(a, b) do{if(a!=b){[a release];a=[b retain];}}while(0)
#define NonatomicCopySetToFrom(a, b) do{if(a!=b){[a release];a=[b copy];}}while(0)
#else
#define NonatomicRetainedSetToFrom(a, b) do{if(a!=b){a=b;}}while(0)
#define NonatomicCopySetToFrom(a, b) do{if(a!=b){a=[b copy];}}while(0)
#endif

#if defined(CONFIGURATION_Debug) || defined(DEBUG)
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define CGRectDescription(CGRECT) [NSString stringWithFormat:@"x:%f y:%f w:%f h:%f", CGRECT.origin.x, CGRECT.origin.y, CGRECT.size.width, CGRECT.size.height]
#define CGSizeDescription(CGSIZE) [NSString stringWithFormat:@"w:%f h:%f", CGSIZE.width, CGSIZE.height]

#define BBRnd ((arc4random()%256) / 255.0f)

#define RADIANS( DEGREES ) (DEGREES * M_PI / 180.0f)
#define DEGREES( RADIANS ) (RADIANS * 180.0f / M_PI)
#define kMilesPerMeter 0.000621371192
#define kMetersPerMile 1609.344

#define BBRndInt(low, high) ((int)low + arc4random() % (high - low + 1))

#if OBJC_ARC_ENABLED
#define BBImageView(IMAGE_NAME) [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_NAME]]
#define BBImageViewWithCaps(IMAGE_NAME, LEFT_CAP_WIDTH, TOP_CAP_HEIGHT) [[UIImageView alloc] initWithImage:[[UIImage imageNamed:IMAGE_NAME] stretchableImageWithLeftCapWidth:LEFT_CAP_WIDTH topCapHeight:TOP_CAP_HEIGHT]]
#else
#define BBImageView(IMAGE_NAME) [[[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_NAME]] autorelease]
#define BBImageViewWithCaps(IMAGE_NAME, LEFT_CAP_WIDTH, TOP_CAP_HEIGHT) [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:IMAGE_NAME] stretchableImageWithLeftCapWidth:LEFT_CAP_WIDTH topCapHeight:TOP_CAP_HEIGHT]] autorelease]
#endif

#define ARC4RANDOM_MAX      0x100000000
#define BBRndFloat(low, high) ((((float) arc4random() / ARC4RANDOM_MAX) * (high - low)) + low)

#define BBAddTintToViewWithColor(UIVIEW,UICOLOR) {UIView *tintLayer =[[UIView alloc] initWithFrame:CGRectMake(0,0,BBW(UIVIEW),BBH(UIVIEW))]; tintLayer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; tintLayer.alpha=0.25; tintLayer.backgroundColor=UICOLOR; [UIVIEW addSubview:tintLayer];}

#define SuppressPerformSelectorLeakWarning(Stuff) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        Stuff; \
        _Pragma("clang diagnostic pop") \
    } while (0)