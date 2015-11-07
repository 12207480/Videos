
#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

//**设置颜色*/
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *) createImageWithColor: (UIColor *) color x:(float)x y:(float)y w:(float)width h:(float)height;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
// 获取视频的缩略图
+(UIImage *)imageFromVideoURL:(NSURL*)videoURL;

@end
