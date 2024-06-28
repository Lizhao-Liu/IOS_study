//
//  HCBCodeScanView.m
//  NewDriver4iOS
//
//  Created by yangtianyin on 16/1/13.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import "HCBCodeScanerView.h"
#import "HCBCodeScanerMaskView.h"
#import "UIImage+HCBCodeScanerExtension.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import <ScanKitFrameWork/ScanKitFrameWork.h>
#import <sys/utsname.h>
#import <sys/sysctl.h>

UIColor *HCBCODESCANER_RGBA_COLOR_MAKE(CGFloat r, CGFloat g, CGFloat b) {
    return [UIColor colorWithRed:r / 255.f
                           green:g / 255.f
                            blue:b / 255.f
                           alpha:1.0];
}

@interface HCBCodeScanerView () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) CALayer *backgroundLayer;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) CALayer *scanBackgroundLayer;
@property (nonatomic, assign, getter=isTorchOn) BOOL torchOn;
@property (nonatomic, strong) UIView *torchContainerView;
@property (nonatomic, strong) UIImageView *torchImageView;
@property (nonatomic, strong) UIButton *torchButton;
@property (nonatomic, strong) UILabel *torchLabel;
@property (nonatomic, assign) int captureSampleCount;
@property (nonatomic, assign, getter=isVideoLayerScaled) BOOL videoLayerScaled;
@property (nonatomic, assign, getter=isAcceptScanData) BOOL acceptScanData;
@property (nonatomic, assign) MBScanViewFormatType formatType; // 默认二维码
@property (nonatomic, strong) HmsScanOptions *hmsOptions;

@property (nonatomic, strong) HCBCodeScanerMaskView *maskView;
@property (nonatomic, strong) UILabel *tips;

@property (nonatomic, assign) long long lastScanTime;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;

- (void)toggleTorch:(UIButton *)sender;
- (BOOL)isTorchOn;
- (void)torchOn;
- (void)torchOff;

- (CGFloat)calculateVideoScaleFactorWithCodeObject:(AVMetadataMachineReadableCodeObject *)objc;
- (void)setVideoScale:(CGFloat)scale animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)resetVideoScale;
- (BOOL)canScaleVideoTo:(CGFloat)factor;

@end

@implementation HCBCodeScanerView

#pragma mark - Overriding

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _captureSampleCount = 0;
        _videoLayerScaled = NO;
        _acceptScanData = YES;
        _lastScanTime = 0;
        
        [self createScanInfo];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                     withType:(MBScanViewFormatType)type {
    
    _formatType = type;
    
    return [self initWithFrame:frame];
}

- (void)dealloc {
    [self.session removeInput:_deviceInput];
    [self.session removeOutput:_videoDataOutput];
    [self.session removeOutput:_stillImageOutput];

    if (self.session.isRunning) {
        [self.session stopRunning];
    }

    [_previewLayer removeFromSuperlayer];
}

#pragma mark - Public

+ (BOOL)checkCameraIsVisible {
    NSString *mediaType = AVMediaTypeVideo; // Or AVMediaTypeAudio

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

+ (void)checkPhotoLibraryIsVisibleWithCompletion:(void (^)(BOOL allowed))completion {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
            !completion ?: completion(NO);
            break;
        case PHAuthorizationStatusLimited:
        case PHAuthorizationStatusAuthorized:
            !completion ?: completion(YES);
            break;

        case PHAuthorizationStatusNotDetermined:
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//                !completion ?: completion(status == PHAuthorizationStatusAuthorized);
            }];
            break;
    }
}

- (void)pauseScanSession {
    [self.session stopRunning];
}

- (void)restartScanSession {
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
}

#pragma mark - Private

- (void)createScanInfo {
    BOOL isConCamera = [[self class] checkCameraIsVisible];
    if (isConCamera == YES) {
        [self setScanCode];
        [self setScanUI];
    }
}

- (void)setScanUI {
    _maskView = [[HCBCodeScanerMaskView alloc] initWithFrame:self.bounds];
    [self addSubview:_maskView];

    _scanBackgroundLayer = [CALayer layer];
    _scanBackgroundLayer.contents = (id)[[UIImage imageNamed_CodeScaner:@"scan_bg"] CGImage];
    _scanBackgroundLayer.frame = scanFrame(pWith, pWith);
    [_maskView.layer addSublayer:_scanBackgroundLayer];

    self.torchContainerView.center = CGPointMake(self.bounds.size.width / 2, CGRectGetMaxY(_scanBackgroundLayer.frame) - self.torchContainerView.bounds.size.height / 2);
    [self addSubview:self.torchContainerView];

    _tips = [[UILabel alloc] init];
    if (self.metadataObjectTypes == nil || self.metadataObjectTypes.count <= 0) {
        _tips.text = @"将二维码放入框内，即可自动扫描";
    } else if (self.metadataObjectTypes.count == 0) {
        AVMetadataObjectType type = self.metadataObjectTypes.firstObject;
        if ([type isEqualToString:AVMetadataObjectTypeQRCode]) {
            _tips.text = @"将二维码放入框内，即可自动扫描";
        }
    } else {
        _tips.text = @"将二维码或条形码放入框内，即可自动扫描";
    }
    
    _tips.font = [UIFont systemFontOfSize:13];
    [_tips sizeToFit];
    CGRect frame = _tips.frame;
    frame.origin = CGPointMake((self.bounds.size.width - _tips.bounds.size.width) / 2, scanLineEnd + 21);
    _tips.frame = frame;
    _tips.textColor = HCBCODESCANER_RGBA_COLOR_MAKE(204, 204, 204);
    [self addSubview:_tips];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _maskView.frame = self.bounds;
    [_maskView setNeedsLayout];
    _scanBackgroundLayer.frame = scanFrame(pWith, pWith);
    self.torchContainerView.center = CGPointMake(self.bounds.size.width / 2, CGRectGetMaxY(_scanBackgroundLayer.frame) - self.torchContainerView.bounds.size.height / 2);
    CGRect frame = _tips.frame;
    frame.origin = CGPointMake((self.bounds.size.width - _tips.bounds.size.width) / 2, scanLineEnd + 21);
    _tips.frame = frame;
    _previewLayer.frame = self.bounds;
    CGRect scanAreaFrame = scanFrame(pWith, pWith);

    if (_headerLabel) {
        _headerLabel.frame = CGRectMake(0, 0, self.bounds.size.width - 80, [_headerLabel sizeThatFits:CGSizeMake(self.bounds.size.width - 80, MAXFLOAT)].height);
        _headerLabel.center = CGPointMake(self.bounds.size.width / 2.f, scanAreaFrame.origin.y / 2.f);
    }
    self.lineView.frame = scanFrame(pWith, 3.f);
}

// 开始扫码
- (void)beginScanLine {
    if (self.lineView == nil) {
        self.lineView = [[UIImageView alloc] initWithFrame:scanFrame(pWith, 3.f)];
        [self.lineView setImage:[UIImage imageNamed_CodeScaner:@"scan_line"]];
        [self insertSubview:self.lineView belowSubview:self.torchContainerView];
    } else {
        self.lineView.frame = scanFrame(pWith, 3.f);
    }

    [self.lineView.layer removeAllAnimations];
    [self restartScanLine];

    CAKeyframeAnimation *ani = [CAKeyframeAnimation animation];

    // 初始化路径
    CGMutablePathRef aPath = CGPathCreateMutable();

    // 动画起始点
    CGPathMoveToPoint(aPath, NULL, self.bounds.size.width / 2, scanLineBegin);
    CGPathAddLineToPoint(aPath, NULL, self.bounds.size.width / 2, scanLineEnd);
    CGPathAddLineToPoint(aPath, NULL, self.bounds.size.width / 2, scanLineBegin);

    ani.repeatCount = NSIntegerMax;
    ani.path = aPath;
    ani.duration = 4;
    CGPathRelease(aPath);

    [self.lineView.layer addAnimation:ani forKey:@"position"];

    [self startSession];
}

- (void)startSession {
    dispatch_async(self.sessionQueue, ^{
        if (!self.session.isRunning) {
            [self.session startRunning];
        }
    });
}

- (void)pauseScanLine {
    [self pauseLayer:self.lineView.layer];
}

- (void)restartScanLine {
    [self resumeLayer:self.lineView.layer];
}

- (void)removeScanLine {
    self.lineView.frame = self.lineView.layer.frame;
    [self.lineView.layer removeAllAnimations];
    if (self.isVideoLayerScaled) {
        [self resetVideoScale];
    }
}

// 设置扫码基本信息
- (void)setScanCode {
    self.sessionQueue = dispatch_queue_create("com.hcb.codescaner.sessionQueue", DISPATCH_QUEUE_SERIAL);

    // Configure device input
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }

    // Configure video data output
    if ([self.session canAddOutput:self.videoDataOutput]) {
        [self.session addOutput:self.videoDataOutput];
    }

    // Configure still image output
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }

//    if ([self shouldLowFrequency]) {
//        [self.device lockForConfiguration:nil];
//
//        self.device.activeVideoMaxFrameDuration = CMTimeMake(1, 6);
//        self.device.activeVideoMinFrameDuration = CMTimeMake(1, 3);
//        [self.device unlockForConfiguration];
//    } else {
//        [self.device lockForConfiguration:nil];
//
//        self.device.activeVideoMaxFrameDuration = CMTimeMake(1, 12);
//        self.device.activeVideoMinFrameDuration = CMTimeMake(1, 8);
//        [self.device unlockForConfiguration];
//    }
    
    // Configure preview layer
    [self.layer addSublayer:self.previewLayer];
}

- (void)pauseLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)toggleTorch:(UIButton *)sender {
    self.torchOn = !self.isTorchOn;
}

- (void)torchOn {
    if (![self.device hasTorch]) {
        return;
    }
    self.torchLabel.text = @"轻点关闭";
    self.torchButton.selected = YES;
    self.torchImageView.highlighted = YES;
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode:AVCaptureTorchModeOn];
    [self.device unlockForConfiguration];
}

- (void)torchOff {
    if (![self.device hasTorch]) {
        return;
    }
    self.torchLabel.text = @"轻点照亮";
    self.torchButton.selected = NO;
    self.torchImageView.highlighted = NO;
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode:AVCaptureTorchModeOff];
    [self.device unlockForConfiguration];
}

- (CGFloat)calculateVideoScaleFactorWithCodeObject:(AVMetadataMachineReadableCodeObject *)objc {
    NSArray *corners = objc.corners;
    CGPoint point1 = CGPointZero;
    CGPoint point2 = CGPointZero;
    CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)corners[0], &point1);
    CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)corners[2], &point2);
    return 75 / (point2.x - point1.x);
}

- (void)setVideoScale:(CGFloat)scale animated:(BOOL)animated completion:(void (^)(void))completion {
    // Calculate video scale
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    CGFloat maxScaleAndCropFactor = connection.videoMaxScaleAndCropFactor / 16;
    scale = MIN(scale, maxScaleAndCropFactor);
    CGFloat zoom = scale / connection.videoScaleAndCropFactor;
    // Set video scale
    [self.device lockForConfiguration:nil];
    connection.videoScaleAndCropFactor = scale;
    [self.device unlockForConfiguration];

    // Animate scale
    void (^animation)(void) = ^{
        self.previewLayer.transform = CATransform3DScale(self.previewLayer.transform, zoom, zoom, 1.0);
    };

    if (animated) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.25];
        [CATransaction setCompletionBlock:^{
            if (completion) {
                completion();
            }
        }];
        animation();
        [CATransaction commit];
    } else {
        animation();
        if (completion) {
            completion();
        }
    }
}

- (void)resetVideoScale {
    _videoLayerScaled = NO;
    [self setVideoScale:1.0 animated:NO completion:nil];
}

- (BOOL)canScaleVideoTo:(CGFloat)factor {
    return factor > 1;
}

// 时间间隔(毫秒)
- (long long)spaceTime {
    if ([self shouldLowFrequency]) {
        return 350;
    }
    return 180;
}

// 获取当前时间毫秒
- (long long)nowTimestamp {
    struct timeval t;
    gettimeofday(&t,NULL);
    long long dwTime = ((long long)1000000 * t.tv_sec + (long long)t.tv_usec)/1000;
    return dwTime;
}

#pragma mark - Setter

- (void)setTorchOn:(BOOL)torchOn {
    if (_torchOn == torchOn) {
        return;
    }
    if (torchOn) {
        [self torchOn];
    } else {
        [self torchOff];
    }
    _torchOn = torchOn;
}

- (void)setHeaderLabel:(UILabel *)headerLabel {
    if (_headerLabel == headerLabel) {
        return;
    }
    if (_headerLabel) {
        [_headerLabel removeFromSuperview];
    }
    _headerLabel = headerLabel;
    if (_headerLabel) {
        [self addSubview:_headerLabel];
    }
}

#pragma mark - Getter

- (AVCaptureDevice *)device {
    if (_device) {
        return _device;
    }
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return _device;
}

- (AVCaptureDeviceInput *)deviceInput {
    if (_deviceInput) {
        return _deviceInput;
    }
    _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    return _deviceInput;
}

- (AVCaptureStillImageOutput *)stillImageOutput {
    if (_stillImageOutput) {
        return _stillImageOutput;
    }
    _stillImageOutput = [AVCaptureStillImageOutput new];
    _stillImageOutput.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    return _stillImageOutput;
}

- (AVCaptureVideoDataOutput *)videoDataOutput {
    if (_videoDataOutput) {
        return _videoDataOutput;
    }
    _videoDataOutput = [AVCaptureVideoDataOutput new];
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    return _videoDataOutput;
}

- (AVCaptureSession *)session {
    if (_session) {
        return _session;
    }
    _session = [AVCaptureSession new];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (_previewLayer) {
        return _previewLayer;
    }
    _previewLayer.backgroundColor = [UIColor clearColor].CGColor;
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.bounds;
    return _previewLayer;
}

- (UIView *)torchContainerView {
    if (_torchContainerView) {
        return _torchContainerView;
    }
    _torchContainerView = [UIView new];
    _torchContainerView.bounds = CGRectMake(0, 0, 90, 90);
    self.torchImageView.center = CGPointMake(_torchContainerView.bounds.size.width / 2, self.torchImageView.bounds.size.height / 2);
    self.torchButton.center = self.torchImageView.center;
    self.torchLabel.center = CGPointMake(self.torchImageView.center.x, _torchContainerView.bounds.size.height - self.torchLabel.bounds.size.height / 2 - 8);
    [_torchContainerView addSubview:self.torchImageView];
    [_torchContainerView addSubview:self.torchButton];
    [_torchContainerView addSubview:self.torchLabel];
    return _torchContainerView;
}

- (UIImageView *)torchImageView {
    if (_torchImageView) {
        return _torchImageView;
    }
    _torchImageView = [UIImageView new];
    _torchImageView.bounds = CGRectMake(0, 0, 40, 60);
    _torchImageView.contentMode = UIViewContentModeBottom;
    _torchImageView.image = [UIImage imageNamed_CodeScaner:@"flashlight_off"];
    _torchImageView.highlightedImage = [UIImage imageNamed_CodeScaner:@"flashlight_on"];
    return _torchImageView;
}

- (UIButton *)torchButton {
    if (_torchButton) {
        return _torchButton;
    }
    _torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _torchButton.bounds = CGRectMake(0, 0, 100, 100);
    [_torchButton addTarget:self action:@selector(toggleTorch:) forControlEvents:UIControlEventTouchUpInside];
    return _torchButton;
}

- (UILabel *)torchLabel {
    if (_torchLabel) {
        return _torchLabel;
    }
    _torchLabel = [UILabel new];
    _torchLabel.font = [UIFont systemFontOfSize:13];
    _torchLabel.text = @"轻点照亮";
    _torchLabel.textColor = [UIColor whiteColor];
    [_torchLabel sizeToFit];
    return _torchLabel;
}

- (HmsScanOptions *)hmsOptions {
    if (_hmsOptions != nil) {
        return _hmsOptions;
    }
    
    if (self.formatType == MBScanViewFormatTypeTypeQR) {
        _hmsOptions = [[HmsScanOptions alloc] initWithScanFormatType:(QR_CODE | DATA_MATRIX)];
    } else {
        _hmsOptions = [[HmsScanOptions alloc] initWithScanFormatType:ALL];
    }
    return _hmsOptions;
}

//#pragma mark - AVCaptureMetadataOutputObjectsDelegate
//
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
//    if (!self.isAcceptScanData) {
//        return;
//    }
//
//    AVMetadataObject *metadataObject = metadataObjects.lastObject;
//
//    if (!metadataObject || ![metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
//        return;
//    }
//
//    AVMetadataMachineReadableCodeObject *codeObject = (AVMetadataMachineReadableCodeObject *)metadataObject;
//
//    // Scale video preview layer
//    if (_enableScale && !self.isVideoLayerScaled) {
//        AVMetadataMachineReadableCodeObject *transformedCodeObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:codeObject];
//        CGFloat factor = [self calculateVideoScaleFactorWithCodeObject:transformedCodeObject];
//        if ([self canScaleVideoTo:factor]) {
//            _acceptScanData = NO;
//            _videoLayerScaled = YES;
//            __weak typeof(self) wself = self;
//            [self setVideoScale:factor animated:YES completion:^{
//                wself.acceptScanData = YES;
//            }];
//            return;
//        }
//    }
//
//    // Handle scan results
//    if (_delegate && [_delegate respondsToSelector:@selector(codeScanResult:)]) {
//        [_delegate codeScanResult:codeObject.stringValue];
//    }
//
//    [self.session stopRunning];
//    [self pauseScanLine];
//}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary *)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightness = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    if (++_captureSampleCount <= 10 && brightness < 0 && !self.isTorchOn) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.torchOn = YES;
        });
    }
    
    long long nowTime = [self nowTimestamp];
//    NSLog(@"nowTime:%lld, lastScanTime:%lld, space:%lld", nowTime, _lastScanTime, (nowTime - _lastScanTime));
    if (nowTime - _lastScanTime < [self spaceTime]) {
        // 触发频控 return
        return;
    }
    _lastScanTime = nowTime;
    
//    NSLog(@"nowTime:%lld, willscan", nowTime);
    @autoreleasepool{
        CFRetain(sampleBuffer);
        NSDictionary *dataDic = [HmsBitMap bitMapForSampleBuffer:sampleBuffer withOptions:self.hmsOptions];
//        NSLog(@"huaweiscan.result:%@", dataDic);
//        NSNumber *zoomValue = dataDic[@"zoomValue"];
//        if (zoomValue != nil && self.device.videoZoomFactor != [zoomValue floatValue]) {
//            [self.device lockForConfiguration:nil];
//            self.device.videoZoomFactor = [zoomValue floatValue];
//            [self.device unlockForConfiguration];
//        }
        //resultList = [HmsBitMap multiDecodeBitMapForSampleBuffer:sampleBuffer withOptions:[[HmsScanOptions alloc] initWithScanFormatType:ALL Photo:false]];
        if (dataDic == nil || dataDic.count == 0) {
            CFRelease(sampleBuffer);
            return;
        }
        
        NSString *resultStr = dataDic[@"text"];
        if (resultStr == nil || resultStr.length <= 0) {
            CFRelease(sampleBuffer);
            return;
        }
        
        NSArray *pointList = [dataDic objectForKey:@"ResultPoint"];
        if ([self areaVisible:pointList] == NO) {
            CFRelease(sampleBuffer);
            // 不在扫码区域
            return;
        }
        
        CFRelease(sampleBuffer);
        
        // Handle scan results
        if (_delegate && [_delegate respondsToSelector:@selector(codeScanResult:)]) {
            [_delegate codeScanResult:resultStr];
        }
        
        if (self.session.isRunning){
            [self.session stopRunning];
        }
        [self pauseScanLine];
    }
}

- (BOOL)areaVisible:(NSArray *)list {
    
    //return [self calculationArea:list];
    // 目前跟进华为sdk返回的point计算区域有问题，先不手动限制区域
    return YES;
}

- (BOOL)calculationArea:(NSArray *)list {
    CGPoint point = [self getScanCenter:list];
    CGRect scanAreaFrame = scanFrame(pWith, pWith);
    if (CGPointEqualToPoint(point, CGPointZero) == NO && CGRectContainsPoint(scanAreaFrame, point) == NO) {
        // 不在扫码区域
//        UIView *r_view = [[UIView alloc] init];
//        r_view.frame = CGRectMake(point.x-20, point.y-20, 40, 40);
//        r_view.backgroundColor = [UIColor greenColor];
//        r_view.layer.cornerRadius = 20;
//        r_view.layer.masksToBounds = YES;
//        [self addSubview:r_view];
        
        return NO;
    }
    return YES;
}

-(CGPoint)getScanCenter:(NSArray *)list {
    if (list == nil || list.count <= 0) {
        return CGPointZero;
    }
    float posXEnd = 0;
    float posYEnd = 0;
    for (int i=0; i<list.count; i++) {
        float pos_X = [[[list objectAtIndex:i] objectForKey:@"posX"] floatValue];
        posXEnd = posXEnd + pos_X;
        float pos_Y = [[[list objectAtIndex:i] objectForKey:@"posY"] floatValue];
        posYEnd = posYEnd + pos_Y;
    }
    float scan_x = posXEnd/4;
    float scan_y = posYEnd/4;
    CGPoint point = CGPointMake(scan_x, scan_y);
    return point;
}

- (BOOL)shouldLowFrequency {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceMode = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSDictionary *map = @{
        @"iPhone5,3": @(1), // iPhone5 ~ iPhone7(不包括iPhone7) 及 iPhoneSE 降频, 更老的型号不关注
        @"iPhone5,4": @(1),
        @"iPhone6,1": @(1),
        @"iPhone6,2": @(1),
        @"iPhone7,1": @(1),
        @"iPhone7,2": @(1),
        @"iPhone8,1": @(1),
        @"iPhone8,2": @(1),
        @"iPhone8,4": @(1),
        
        @"iPad2,1": @(1),
        @"iPad2,2": @(1),
        @"iPad2,3": @(1),
        @"iPad2,4": @(1),
        @"iPad2,5": @(1),
        @"iPad2,6": @(1),
        @"iPad2,7": @(1),
        
        @"iPad4,1": @(1),
        @"iPad4,2": @(1),
        @"iPad4,3": @(1)
    };
    
    if (deviceMode == nil) {
        return NO;
    }
    
    id object = [map objectForKey:deviceMode];
    if (object) {
        return YES;
    }
    
    return NO;
}

@end
