//
//  QrCodeViewControllor.m
//  二维码生成器
//
//  Created by 博学明辨 on 2021/3/5.
//

#import "QrCodeViewControllor.h"
#import <CoreImage/CIFilter.h>

@interface QrCodeViewControllor ()

@property (nonatomic, strong) NSImageView *imageV;
@end

@implementation QrCodeViewControllor

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageV = [NSImageView new];
    [self.view addSubview:self.imageV];
    self.imageV.frame = CGRectMake(100, 100, 300, 300);
    
}


//- (NSImage *)snapshotImage {
//
//    NSGraphicsBeginImageContextWithOptions(self.qrImageV.frame.size, self.opaque, 0);
//    [self.qrImageV.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return snap;
//}






/**
 *  生成一张带有logo的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param logoImageName    logo的image名
 *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (NSImage *)generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSImage *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = data;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 4、将CIImage类型转成UIImage类型
    
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:outputImage];
    NSImage *start_image = [[NSImage alloc] initWithSize:rep.size];
    [start_image addRepresentation:rep];
    
    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
//    UIGraphicsBeginImageContext(start_image.size);
//
//    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
//    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
//
//    // 再把小图片画上去
//    UIImage *icon_image = logoImageName;
//    CGFloat icon_imageW = start_image.size.width * logoScaleToSuperView;
//    CGFloat icon_imageH = start_image.size.height * logoScaleToSuperView;
//    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
//    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
//
//    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
//
//    // 6、获取当前画得的这张图片
//    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
//
//    // 7、关闭图形上下文
//    UIGraphicsEndImageContext();
    
    return start_image;
}
@end
