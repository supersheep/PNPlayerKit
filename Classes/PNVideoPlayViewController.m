//
//  PNVideoPlayViewController.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/15.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import "PNVideoPlayViewController.h"
#import "PNPlayerView.h"
#import <Masonry/Masonry.h>

@interface PNVideoPlayViewController () <PNPlayerViewDelegate>
@property (nonatomic, strong) PNPlayerView *player;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, strong) NSString *poster;

@end

@implementation PNVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PNPlayerView *player = [[PNPlayerView alloc] initWithControlType:PNPlayerControlTypeFull];
    [self.view addSubview:player];
    [player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (_video) {
        [player setVideo:_video poster:_poster];
    }
    player.delegate = self;
    self.player = player;
    [self.player play];
    // Do any additional setup after loading the view.
}

- (void)setVideo:(NSString *)video poster:(NSString *)poster{
    _video = video;
    _poster = poster;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)playerViewCloseButtonTapped:(PNPlayerView *)player{}
- (void)playerViewPlayButtonTapped:(PNPlayerView *)player{}
- (void)playerView:(PNPlayerView *)player loadedTimeChanged:(NSInteger)loadedTime{}
- (void)playerView:(PNPlayerView *)player currentTimeChanged:(NSInteger)currentTime{}
- (void)playerView:(PNPlayerView *)player statusDidChange:(PNPlayerStatus)status{}

@end
