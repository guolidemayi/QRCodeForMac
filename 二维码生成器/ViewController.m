//
//  ViewController.m
//  二维码生成器
//
//  Created by 博学明辨 on 2021/3/5.
//

#import "ViewController.h"
#import "QrCodeViewControllor.h"
#import <CoreImage/CIFilter.h>

@interface ViewController ()

@property (weak) IBOutlet NSImageView *iconImageV;
@property (weak) IBOutlet NSTextField *textFeild;

@property (nonatomic, strong) NSButton *qrImageV;

@property (nonatomic, strong) NSImageView *headImageV;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.qrImageV = [NSButton new];
    self.qrImageV.imageScaling = NSImageScaleAxesIndependently;
    self.qrImageV.frame = CGRectMake(0, 0, 300, 300);
    [self.view addSubview:self.qrImageV];
    
    [self.qrImageV addGestureRecognizer:[[NSGestureRecognizer alloc]initWithTarget:self action:@selector(qrImageVClick)]];
    
    self.qrImageV.hidden = YES;
    
    self.headImageV = [[NSImageView alloc]init];
    self.headImageV.alignment = NSTextAlignmentCenter;
    self.headImageV.wantsLayer = YES;
    self.headImageV.layer.cornerRadius = 40;
    self.headImageV.layer.borderColor = [NSColor whiteColor].CGColor;
    self.headImageV.layer.borderWidth = 3;
    self.headImageV.layer.masksToBounds = YES;
    [self.qrImageV addSubview:self.headImageV];
    self.headImageV.imageScaling = NSImageScaleAxesIndependently;
    self.iconImageV.imageScaling = NSImageScaleNone;
}

- (void)qrImageVClick{
    self.qrImageV.hidden = YES;
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)toQrCodeClick:(id)sender {
    
    
    self.qrImageV.hidden = NO;
    self.headImageV.frame = CGRectMake(self.qrImageV.frame.size.width/2 - 40, self.qrImageV.frame.size.height/2 - 40, 80, 80);
    self.qrImageV.image = [self generateWithLogoQRCodeData:self.textFeild.stringValue logoImageName:self.iconImageV.image logoScaleToSuperView:1];
    
}

- (IBAction)choosePicClick:(id)sender {
    self.qrImageV.hidden = YES;
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        [openPanel setPrompt: @"打开"];
        
        openPanel.allowedFileTypes = [NSArray arrayWithObjects: @"png", @"jpg",@"jpeg", nil];
    openPanel.directoryURL = [NSURL URLWithString:@"\(NSHomeDirectory())/Downloads"];;
        
        [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
            
            if (returnCode == 1) {
                NSURL *fileUrl = [[openPanel URLs] objectAtIndex:0];
                // 获取文件内容
                NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:fileUrl error:nil];
//                NSString *fileContext = [[NSString alloc] initWithData:fileHandle.readDataToEndOfFile encoding:NSUTF8StringEncoding];
                NSImage *image =
                [[NSImage alloc]initWithContentsOfURL:fileUrl];
                self.iconImageV.image = image;
                self.headImageV.image = image;
                
            }
        }];
}


- (NSImage *)generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSImage *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView {
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
//    NSImage *icon_image = logoImageName;
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
