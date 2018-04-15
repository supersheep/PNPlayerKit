//
//  ViewController.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/12.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "VC2ViewController.h"
#import "UIControllerAnimator.h"
#import "PNPlayerView.h"
#import "PNVideoPlayViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import <Masonry/Masonry.h>

@interface ViewController () <PNPlayerViewDelegate>
@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) AVPlayer *player1;
@property (nonatomic, strong) AVPlayer *player2;
@property (nonatomic, strong) PLPlayer *qnPlayer;

@property (nonatomic, strong) CALayer *player2Layer;

@property (nonatomic, strong) PNPlayerView *player;
@property (nonatomic, strong) PNPlayerView *player22;
@end

@implementation ViewController


- (void)playerViewPlayButtonTapped:(PNPlayerView *)player{
    NSLog(@"play button tapped");
}

- (void)playerView:(PNPlayerView *)player loadedTimeChanged:(NSInteger)loadedTime{
    
}
- (void)playerView:(PNPlayerView *)player currentTimeChanged:(NSInteger)currentTime{
    
}
- (void)playerView:(PNPlayerView *)player statusDidChange:(PNPlayerStatus)status{
    NSString *statusString = @"";
    
    switch (status) {
        case PNPlayerStatusFailed: { statusString = @"PNPlayerStatusFailed";break; }
        case PNPlayerStatusReadyToPlay: { statusString = @"PNPlayerStatusReadyToPlay";break; }
        case PNPlayerStatusPlaying: { statusString = @"PNPlayerStatusPlaying";break; }
        case PNPlayerStatusPaused: { statusString = @"PNPlayerStatusPaused";break; }
        case PNPlayerStatusCompleted: { statusString = @"PNPlayerStatusCompleted";break; }
        case PNPlayerStatusBuffering: { statusString = @"PNPlayerStatusBuffering";break; }
        case PNPlayerStatusUnknown: { statusString = @"PNPlayerStatusUnknown";break; }
    }
    
    NSLog(@"status changed to %@", statusString);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVideo];
    
    

}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)initVideo{
    
//    NSString *video = @"http://techslides.com/demos/sample-videos/small.mp4";
    NSString *video = @"https://video.piaoniu.com/review/15233560872751648.mp4";
    NSString *poster = @"http://img.piaoniu.com/video/a250c96b065f7e9ed8eac3bd82695f7b0d9dba0c.jpg";

    PNPlayerView *player = [[PNPlayerView alloc] initWithControlType:PNPlayerControlTypeTiny];
    player.delegate = self;
    [player setVideo:video poster:poster];
    player.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 16.0f * 9.0f);
    [self.view addSubview:player];

    self.player = player;
    //    [player play];





//    NSString *video2 = @"https://video.piaoniu.com/review/15233560872751648.mp4";
    NSString *poster2 = @"http://img.piaoniu.com/video/a250c96b065f7e9ed8eac3bd82695f7b0d9dba0c.jpg";

    PNPlayerView *player2 = [[PNPlayerView alloc] initWithControlType:PNPlayerControlTypeFull];
    [player2 setVideo:video poster:poster2];
    player2.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.width / 16.0f * 9.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 16.0f * 9.0f);
    player2.delegate = self;
    [self.view addSubview:player2];
    self.player22 = player2;


    
    UIButton *btn1 = [UIButton new];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 250, 100, 50);
    [btn1 setTitle:@"play" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton new];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(100, 250, 100, 50);
    [btn2 setTitle:@"pause" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(pauseVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    UIButton *btn3 = [UIButton new];
    [btn3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn3.frame = CGRectMake(200, 250, 100, 50);
    [btn3 setTitle:@"popVC" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    
    
    UIButton *btn4 = [UIButton new];
    [btn4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn4.frame = CGRectMake(300, 250, 100, 50);
    [btn4 setTitle:@"transform" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(transform) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    
    UIButton *btn5 = [UIButton new];
    [btn5 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn5.frame = CGRectMake(0, 300, 100, 50);
    [btn5 setTitle:@"replace control" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(replaceControl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
}

- (void)replaceControl{
    [self.player setControlType:PNPlayerControlTypeFull];
}

- (void)transform{
    [self.view bringSubviewToFront:self.player22];
//    float degrees = 90; //the value in degrees
//    self.player.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);

}

- (void)popVC{
    PNVideoPlayViewController *vc = [[PNVideoPlayViewController alloc] init];
    [vc setVideo:@"https://video.piaoniu.com/review/15233560872751648.mp4" poster:@"http://img.piaoniu.com/video/a250c96b065f7e9ed8eac3bd82695f7b0d9dba0c.jpg"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)qiniuInit{
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    PLPlayer *player = [PLPlayer playerWithURL:[NSURL URLWithString:@"http://video.piaoniu.com/review/15233560872751648.mp4"] option:option];
    
    player.playerView.frame = CGRectMake(0, 0, 160, 90);
    _qnPlayer = player;
    [self.view addSubview:player.playerView];

    
    [_qnPlayer play];
    // 设定代理 (optional)
    
    
}

- (void)pauseVideo{
    [PNPlayer pauseCurrent];
}

- (void)playVideo{
    [self.player play];
}


- (void)normalInit{
    UIButton *btn1 = [UIButton new];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(50, 50, 100, 50);
    [btn1 setTitle:@"alala" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pauseVideo1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    
    UIButton *btn2 = [UIButton new];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(150, 50, 100, 50);
    [btn2 setTitle:@"done" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    NSURL *url = [NSURL URLWithString:@"http://video.piaoniu.com/review/15233560872751648.mp4"];
    self.asset = [AVURLAsset assetWithURL:url];
    
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    self.player1 = player;
    
//    [self addProgressObserver:player];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 150, 160, 90);
    //playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.view.layer addSublayer:playerLayer];
    
    
    [self.player1 play];
}

- (void)done{
    [self.player1 play];
    [self.player1 seekToTime:self.player2.currentItem.currentTime];
    
    [_player2 pause];
    [_player2Layer removeFromSuperlayer];
    
}
//
//- (void)addProgressObserver:(AVPlayer *)player{
//    AVPlayerItem *playerItem = player.currentItem;
//    //这里设置每秒执行一次
//    [player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        float current = CMTimeGetSeconds(time);
//        float total = CMTimeGetSeconds([playerItem duration]);
//        NSLog(@"当前已经播放%.2fs.", current);
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pauseVideo1{
    [self.player1 pause];
}

- (void)addVideo{
    [self.player1 pause];
    
    AVPlayer *player2 = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:self.asset]];
    
    self.player2 = player2;
    
    
    
    AVPlayerLayer *playerLayer2 = [AVPlayerLayer playerLayerWithPlayer:self.player2];
    playerLayer2.frame = CGRectMake(160, 150, 160, 90);
    //playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.view.layer addSublayer:playerLayer2];
    
    [self.player1 pause];
    [self.player2 play];
    
    self.player2Layer = playerLayer2;
    
    [self.player2 seekToTime:self.player1.currentItem.currentTime];
}

- (void)tapped:(id)sender{
    VC2ViewController *vc2 = [VC2ViewController new];
    vc2.transitioningDelegate = self;
    [self presentViewController:vc2 animated:YES completion:nil];
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [UIControllerAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [UIControllerAnimator new];
}

@end
