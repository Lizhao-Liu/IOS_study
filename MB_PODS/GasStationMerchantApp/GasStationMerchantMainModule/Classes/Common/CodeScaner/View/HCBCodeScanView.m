//
//  HCBCodeScanView.m
//  NewDriver4iOS
//
//  Created by yangtianyin on 16/1/13.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import "HCBCodeScanView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>



@interface HCBCodeScanView()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
@property (strong,nonatomic)UIImageView *lineView;

@end

@implementation HCBCodeScanView

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createScanInfo];
    }
    
    return self;
}

-(void)createScanInfo {
    
    BOOL isConCamera = [[self class] checkCameraIsVisible];
    if (isConCamera == YES) {
        
        [self setScanCode];
        [self setScanUI];
    }
}

+(BOOL)checkCameraIsVisible {
    
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    switch (authStatus) {
        case AVAuthorizationStatusRestricted:
            return NO;
            break;
        case AVAuthorizationStatusNotDetermined:
            return YES;
            break;
        case AVAuthorizationStatusDenied:
            return NO;
            break;
        default:
            break;
    }
    
    return YES;
}



-(void)setScanUI {
    
    HCBScanMaskView *maskView = [[HCBScanMaskView alloc] initWithFrame:self.frame];
    maskView.top = 0.f;
    [self addSubview:maskView];

    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"bg_scan"] CGImage];

    mask.frame = scanFrame(pWith, pWith);
    [maskView.layer addSublayer:mask];
    
    UILabel *lTitle = [[UILabel alloc] init];
    lTitle.text = @"将二维码放入框内，即可自动扫描";
    lTitle.font = [UIFont systemFontOfSize:13];
    [lTitle sizeToFit];
    lTitle.top = scanLineEnd + 15;
    lTitle.left = (self.width - lTitle.width) / 2;
    lTitle.textColor = [UIColor whiteColor];
    [self addSubview:lTitle];
}

//开始扫码
-(void)beginScanLine {
    
    if (self.lineView == nil) {
        
        self.lineView = [[UIImageView alloc] initWithFrame:scanFrame(pWith, 3.f)];
        [self.lineView setImage:[UIImage imageNamed:@"couponline"]];
        [self addSubview:self.lineView];
    }
    [self.lineView.layer removeAllAnimations];
    [self restartScanLine];
    CAKeyframeAnimation *ani=[CAKeyframeAnimation animation];
    //初始化路径
    CGMutablePathRef aPath=CGPathCreateMutable();
    //动画起始点
    CGPathMoveToPoint(aPath, nil, self.width / 2, scanLineBegin);
    CGPathAddLineToPoint(aPath, NULL,self.width / 2, scanLineEnd);
    CGPathAddLineToPoint(aPath, NULL,self.width / 2, scanLineBegin);
    
    ani.repeatCount = NSIntegerMax;
    ani.path=aPath;
    ani.duration=4;
    CGPathRelease(aPath);
    [self.lineView.layer addAnimation:ani forKey:@"position"];
    
    [self.session startRunning];
}

-(void)pauseScanLine {
    
    [self pauseLayer:self.lineView.layer];
}

-(void)restartScanLine {
    
    [self resumeLayer:self.lineView.layer];
}

-(void)removeScanLine {
    
    self.lineView.frame = self.lineView.layer.frame;
    [self.lineView.layer removeAllAnimations];
}


//设置扫码基本信息
-(void)setScanCode {
    
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效区域
    [self.output setRectOfInterest:CGRectMake(scanLineBegin / self.height, ((self.width - pWith) / 2) / self.width, pWith / self.height, pWith / self.width)];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // 条码类型
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
//    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame =CGRectMake(0,0,self.width,self.height);
    [self.layer addSublayer:self.preview];
}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] -    pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    [_session stopRunning];
    [self pauseScanLine];
    if ([metadataObjects count] >0) {
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if (self.delegate != nil
                && [self.delegate respondsToSelector:@selector(codeScanResult:)] == YES) {
                
                [self.delegate codeScanResult:metadataObject.stringValue];
            }
        });
    }
}
@end
