//
//  KKCornerRadiusBtn.h
//  StomatologicalOfCustomer
//
//  Created by 吴灶洲 on 2017/6/27.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface KKCornerRadiusBtn : UIButton
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
@property (assign, nonatomic) IBInspectable CGFloat space;
@end
