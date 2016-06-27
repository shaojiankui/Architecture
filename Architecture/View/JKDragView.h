//
//  DragView.h
//  JKArchitecture
//
//  Created by Jakey on 16/6/27.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void (^DidDragJKViewEnd)(NSString *result);
typedef void (^DidEnterJKViewDraging)();

@interface JKDragView : NSView
{
    DidDragJKViewEnd _didDragJKViewEnd;
    DidEnterJKViewDraging _didEnterJKViewDraging;
    
}
-(void)didDragJKViewEnd:(DidDragJKViewEnd)didDragJKViewEnd;
-(void)didEnterJKViewDraging:(DidEnterJKViewDraging)didEnterJKViewDraging;
@end
