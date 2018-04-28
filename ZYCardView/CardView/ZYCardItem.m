//
//  ZYCardItem.m
//  ZYCardView
//
//  Created by youyun on 2018/4/26.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import "ZYCardItem.h"

#define ACTION_MARGIN_RIGHT kWidth(150)
#define ACTION_MARGIN_LEFT kWidth(150)
#define ACTION_VELOCITY 400
#define SCALE_STRENGTH 4
#define SCALE_MAX 0.93
#define ROTATION_MAX 1
#define ROTATION_STRENGTH kWidth(414)

#define BUTTON_WIDTH kWidth(40)

@interface ZYCardItem ()

@property (nonatomic, strong) UIView *textContainerView;

@property (nonatomic, strong) UIImageView *shadowImageView;

@property (nonatomic, strong) UIImageView *loveIcon;

@property (nonatomic, strong) UIImageView *unLoveIcon;

@end

@implementation ZYCardItem {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addItemSubView];
        
        [self configItem];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        
        [self addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}

#pragma mark - Private Method
- (void)configItem {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.allowsEdgeAntialiasing=YES;
    
}

- (void)addItemSubView {
    
    UIView *bgView=[[UIView alloc]initWithFrame:self.bounds];
    bgView.layer.cornerRadius=4;
    bgView.clipsToBounds=YES;
    bgView.layer.allowsEdgeAntialiasing=YES;
    [self addSubview:bgView];
    
    [bgView addSubview:self.headerImageView];
    
    [bgView addSubview:self.textContainerView];
    
    [self.textContainerView addSubview:self.titleLabel];
    
    [self.textContainerView addSubview:self.contentLabel];
    
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.bottom.mas_equalTo(0);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(16);
        
        make.bottom.mas_equalTo(-12);
        
    }];
    
    [self.vipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLabel.mas_top);
        
        make.leading.equalTo(self.nameLabel.mas_trailing).mas_equalTo(7);
        
        // make.width.height.mas_equalTo(16);
    }];
    
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(-16);
        
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).mas_equalTo(0);
        
        make.leading.mas_equalTo(16);
        
        make.trailing.mas_equalTo(-16);
        
        //make.height.mas_equalTo(100);
        
    }];
    
    [bgView addSubview:self.loveIcon];
    
    [self.loveIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(12);
        
        make.trailing.mas_equalTo(-12);
        
    }];
    
    [bgView addSubview:self.unLoveIcon];
    
    [self.unLoveIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(12);
        
        make.bottom.mas_equalTo(-12);
        
    }];
    
}

#pragma mark - Event Response
-(void)tap:(UITapGestureRecognizer*)sender{
    
    if (self.canPan==NO) {
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerImageViewDidClickOfCardItem:)]) {
        
        [self.delegate headerImageViewDidClickOfCardItem:self];
    }
}

#pragma mark - 拖动
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.canPan==NO) {
        
        return;
    }
    
    // locationInView     获取到的是手指点击屏幕实时的坐标点
    // translationInView  获取到的是手指移动后，在相对坐标中的偏移量
    
    xFromCenter = [gestureRecognizer translationInView:self].x;
    yFromCenter = [gestureRecognizer translationInView:self].y;
    
    CGFloat alphaRate = fabs(xFromCenter) / 60;
    
    if (xFromCenter < 0) {
        // 向左，不喜欢
        
        self.unLoveIcon.alpha = alphaRate;
        
    }else {
        // 向右，喜欢
        
        self.loveIcon.alpha = alphaRate;
    }
    
    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateBegan:{
            
        };
            
        case UIGestureRecognizerStateChanged:{
            
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            CGFloat scale = MAX(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            self.center = CGPointMake(self.originalCenter.x + xFromCenter, self.originalCenter.y + yFromCenter);
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            self.transform = scaleTransform;
            [self updateOverlay:xFromCenter];
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
            
            [self followUpActionWithDistance:xFromCenter andVelocity:[gestureRecognizer velocityInView:self.superview]];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

#pragma mark - 滑动中事件
-(void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        
    } else {
        
    }
    
    [self.delegate moveCards:distance];
}

#pragma mark - 后续动作判断
- (void)followUpActionWithDistance:(CGFloat)distance andVelocity:(CGPoint)velocity
{
    if (xFromCenter > 0 && (distance > ACTION_MARGIN_RIGHT||velocity.x > ACTION_VELOCITY)) {
        
        [self rightAction:velocity];
        
    } else if (xFromCenter <0 && (distance < -ACTION_MARGIN_LEFT||velocity.x < -ACTION_VELOCITY)) {
        
        [self leftAction:velocity];
        
    } else {
        
        [UIView animateWithDuration:RESET_ANIMATION_TIME
                         animations:^{
                             
                             self.loveIcon.alpha = 0;
                             
                             self.unLoveIcon.alpha = 0;
                             self.center = self.originalCenter;
                             self.transform = CGAffineTransformMakeRotation(0);
                             
                         }];
        [self.delegate moveBackCards];
    }
}

#pragma mark - 右滑后续事件
-(void)rightAction:(CGPoint)velocity
{
    CGFloat distanceX = kScreenWidth + CARD_WIDTH + self.originalCenter.x;//横向移动距离
    CGFloat distanceY = distanceX * yFromCenter/xFromCenter;//纵向移动距离
    CGPoint finishPoint = CGPointMake(self.originalCenter.x + distanceX, self.originalCenter.y + distanceY);//目标center点
    
    CGFloat vel = sqrtf(pow(velocity.x, 2)+pow(velocity.y, 2));//滑动手势横纵合速度
    CGFloat displace=sqrt(pow(distanceX-xFromCenter,2)+pow(distanceY-yFromCenter,2));//需要动画完成的剩下距离
    
    CGFloat duration=fabs(displace/vel);//动画时间
    
    if (duration>0.6) {
        duration=0.6;
    }else if(duration<0.3){
        duration=0.3;
    }
    
    [UIView animateWithDuration:duration
                     animations:^{
                         
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
                     }completion:^(BOOL complete){
                         
                         [self.delegate cardSwiped:self LorR:YES];
                     }];
    [self.delegate adjustOtherCards];
    
}

#pragma mark - 左滑后续事件
-(void)leftAction:(CGPoint)velocity
{
    CGFloat distanceX = -CARD_WIDTH - self.originalCenter.x;//横向移动距离
    CGFloat distanceY=distanceX*yFromCenter/xFromCenter;//纵向移动距离
    CGPoint finishPoint = CGPointMake(self.originalCenter.x+distanceX, self.originalCenter.y+distanceY);//目标center点
    
    CGFloat vel=sqrtf(pow(velocity.x, 2)+pow(velocity.y, 2));//滑动手势横纵合速度
    CGFloat displace=sqrt(pow(distanceX-xFromCenter,2)+pow(distanceY-yFromCenter,2));//需要动画完成的剩下距离
    
    CGFloat duration=fabs(displace/vel);//动画时间
    
    if (duration>0.6) {
        duration=0.6;
    }else if(duration<0.3){
        duration=0.3;
    }
    
    [UIView animateWithDuration:duration
                     animations:^{
                         
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
                     }completion:^(BOOL complete){
                         
                         [self.delegate cardSwiped:self LorR:NO];
                     }];
    [self.delegate adjustOtherCards];
    
}

#pragma mark - 点击右滑事件
-(void)rightClickAction
{
    if (self.canPan==NO) {
        return;
    }
    
    CGPoint finishPoint = CGPointMake([[UIScreen mainScreen]bounds].size.width+CARD_WIDTH*2/3, 2*PAN_DISTANCE+self.frame.origin.y);
    [UIView animateWithDuration:CLICK_ANIMATION_TIME
                     animations:^{
                         
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
                     }completion:^(BOOL complete){
                         
                         [self.delegate cardSwiped:self LorR:YES];
                     }];
    
    [self.delegate adjustOtherCards];
    
}

#pragma mark - 点击左滑事件
-(void)leftClickAction
{
    if (self.canPan==NO) {
        return;
    }
    
    CGPoint finishPoint = CGPointMake(-CARD_WIDTH*2/3, 2*PAN_DISTANCE+self.frame.origin.y);
    [UIView animateWithDuration:CLICK_ANIMATION_TIME
                     animations:^{
                         
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
                     }completion:^(BOOL complete){
                         
                         [self.delegate cardSwiped:self LorR:NO];
                     }];
    
    [self.delegate adjustOtherCards];
    
}

#pragma mark - Setter && Getter
- (UIImageView *)headerImageView {
    
    if (!_headerImageView) {
        
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds))];
        
        _headerImageView.userInteractionEnabled = YES;
                
        _headerImageView.backgroundColor = [UIColor orangeColor];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        
        [_headerImageView addGestureRecognizer:tap];
        
        _headerImageView.layer.allowsEdgeAntialiasing=YES;
        
    }
    
    return _headerImageView;
}

- (UIView *)textContainerView {
    
    if (!_textContainerView) {
        
        _textContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerImageView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.headerImageView.bounds))];
        
        _textContainerView.backgroundColor = [UIColor cyanColor];
    }
    
    return _textContainerView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, CGRectGetWidth(self.textContainerView.bounds)-32, 28)];
        
        _titleLabel.font = kFont(14);
        
        _titleLabel.textColor = [UIColor zy_colorWithHex:0x333434];
        
        _titleLabel.text = @"28岁·178cm·30-5w·属龙·摩羯座";
        
    }
    
    return _titleLabel;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc]init];
        
        _nameLabel.font = kFont(22);
        
        _nameLabel.textColor = [UIColor whiteColor];
        
        _nameLabel.text = @"杨铁心";
        
        [self.headerImageView addSubview:_nameLabel];
        
    }
    
    return _nameLabel;
}

- (UIImageView *)vipIcon {
    
    if (!_vipIcon) {
        
        _vipIcon = [[UIImageView alloc]initWithImage:kImage(@"icon 徽章")];
        
        [self.headerImageView addSubview:_vipIcon];
    }
    
    return _vipIcon;
}

- (UIButton *)locationButton {
    
    if (!_locationButton) {
        
        _locationButton = [UIButton new];
        
        [_locationButton setTitle:@"杭州" forState:UIControlStateNormal];
        
        _locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        _locationButton.titleLabel.font = kFont(14);
        
        [_locationButton setImage:kImage(@"地点") forState:UIControlStateNormal];
        
        [_locationButton setTitleColor:[UIColor zy_colorWithHex:0xe6e6e6] forState:UIControlStateNormal];
        
        [_locationButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
        
        [self.headerImageView addSubview:_locationButton];
    }
    
    return _locationButton;
}

- (UIImageView *)shadowImageView {
    
    if (!_shadowImageView) {
        
        _shadowImageView = [[UIImageView alloc]initWithImage:kImage(@"图片阴影")];
        
        [self.headerImageView addSubview:_shadowImageView];
    }
    
    return _shadowImageView;
}

- (ZYDetailView *)contentLabel {
    
    if (!_contentLabel) {
        _contentLabel = [ZYDetailView new];
        
        _contentLabel.text = @"摩羯座，摩羯座，摩羯座，摩羯座摩，摩羯座摩,坚强独立但也渴望被保护。热爱旅行、摄影、电影、美食。相信";
        
        _contentLabel.preferMaxWidth = kScreenWidth - (16+16) * 2;
        
        _contentLabel.backgroundColor = [UIColor whiteColor];
        
        [self.textContainerView addSubview:_contentLabel];
        
    }
    return _contentLabel;
}

- (UIImageView *)loveIcon {
    
    if (!_loveIcon) {
        
        _loveIcon = [[UIImageView alloc]initWithImage:kImage(@"Like")];
        
        _loveIcon.alpha = 0;
    }
    
    return _loveIcon;
}

- (UIImageView *)unLoveIcon {
    
    if (!_unLoveIcon) {
        
        _unLoveIcon = [[UIImageView alloc]initWithImage:kImage(@"unLike")];
        
        _unLoveIcon.alpha = 0;
        
    }
    
    return _unLoveIcon;
}

- (void)setModel:(PasserbyModel *)model {
    
    _model = model;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.headerPic]];
    
    self.nameLabel.text = model.name;
    
    [self.locationButton setTitle:model.address forState:UIControlStateNormal];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@岁·%@cm·%@·属%@·%@", model.age, model.height, model.money, model.shengxiao, model.constellation];
    
    self.contentLabel.text = model.abstract;
}


@end
