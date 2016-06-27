//
//  JKDragView.m
//  Architecture
//
//  Created by Jakey on 16/6/27.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import "JKDragView.h"

@implementation JKDragView
- (void)awakeFromNib {
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSURLPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        if (files.count <= 0) {
            return NO;
        }
        
    }
    return YES;
}


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        return NSDragOperationCopy;
    }
    if(_didEnterJKViewDraging){
        _didEnterJKViewDraging();
    }
    return NSDragOperationNone;
}
- (void)draggingEnded:(id <NSDraggingInfo>)sender{
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    NSArray *list = [zPasteboard propertyListForType:NSFilenamesPboardType];
    if(_didDragJKViewEnd){
        _didDragJKViewEnd([list firstObject]);
    }
    
}

-(void)didDragJKViewEnd:(DidDragJKViewEnd)didDragJKViewEnd{
    _didDragJKViewEnd = [didDragJKViewEnd copy];
}
-(void)didEnterJKViewDraging:(DidEnterJKViewDraging)didEnterJKViewDraging{
    _didEnterJKViewDraging = [didEnterJKViewDraging copy];
}

@end
