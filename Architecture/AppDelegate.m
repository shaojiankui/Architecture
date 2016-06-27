//
//  AppDelegate.m
//  Architecture
//
//  Created by Jakey on 16/6/27.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *showLabel;
@property (weak) IBOutlet JKDragView *dragView;

@property (weak) IBOutlet NSButton *x64DeviceButton;
@property (weak) IBOutlet NSButton *x64SimButton;
@property (weak) IBOutlet NSButton *x32DeviceButton;
@property (weak) IBOutlet NSButton *x32DeviceButton2;
@property (weak) IBOutlet NSButton *x32SimButton;

- (IBAction)selectButtonTouched:(id)sender;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self.dragView didEnterJKViewDraging:^{
        NSLog(@"didEnterJKViewDraging");
    }];
    [self.dragView didDragJKViewEnd:^(NSString *result) {
        [self checkArchitectureWithLibPath:result];
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)selectButtonTouched:(id)sender {
    [self checkArchitectureWithLibPath:[self browseDone]];
    
}
-(void)checkArchitectureWithLibPath:(NSString*)path{
    self.showLabel.stringValue = @"";
    self.x64DeviceButton.state = 0;
    self.x64SimButton.state = 0;
    self.x32DeviceButton.state = 0;
    self.x32DeviceButton2.state = 0;
    self.x32SimButton.state = 0;

    
    if ([[path.pathExtension lowercaseString] isEqualToString:@"a"] || [[path.pathExtension lowercaseString] isEqualToString:@"framework"]) {
    }else{
        NSLog(@"格式不符合");
        return;
    }
    _filePath = path;
    NSString *fileName = _filePath.lastPathComponent;

//     /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/lipo
//    /usr/bin/lipo -info  xxx/xxx.a
    if ([[_filePath.pathExtension lowercaseString] isEqualToString:@"framework"]) {
        _filePath = [_filePath stringByAppendingPathComponent:[fileName stringByDeletingPathExtension]];
    }
    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file;

    [task setLaunchPath:@"/usr/bin/lipo"];
    [task setArguments:@[@"-info",_filePath]];
    [task setStandardOutput:pipe];
    file = [pipe fileHandleForReading];
    [task launch];
    
    NSData *outputData  = [file readDataToEndOfFile];
    NSString *outputString  =  [[NSString alloc] initWithData:outputData encoding: NSUTF8StringEncoding];
    NSLog(@"outputString:%@",outputString);
    self.showLabel.stringValue = outputString;
    
    [outputString stringByReplacingOccurrencesOfString:_filePath withString:@""];
    if ([outputString rangeOfString:@"arm64"].location != NSNotFound) {
        self.x64DeviceButton.state = 1;
    }
    if ([outputString rangeOfString:@"x86_64 arm64 "].location != NSNotFound) {
        self.x64SimButton.state = 1;
    }
    if ([outputString rangeOfString:@"armv7s"].location != NSNotFound ) {
        self.x32DeviceButton.state = 1;
        self.x32DeviceButton2.state = 1;
    }
    if ([outputString rangeOfString:@"armv7"].location != NSNotFound ) {
        self.x32DeviceButton2.state = 1;
    }
    if ([outputString rangeOfString:@"i386"].location != NSNotFound) {
        self.x32SimButton.state = 1;
    }

}
-(NSString*)browseDone{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:TRUE];
    [openDlg setCanChooseDirectories:FALSE];
    [openDlg setAllowsMultipleSelection:FALSE];
    [openDlg setAllowsOtherFileTypes:FALSE];
    [openDlg setAllowedFileTypes:@[@"a", @"A", @"framework", @"FRAMEWORK"]];
    
    NSString* fileNameOpened;
    if ([openDlg runModal] == NSOKButton)
    {
        fileNameOpened = [[[openDlg URLs] objectAtIndex:0] path];
        //[self.productCer setStringValue:fileNameOpened];
    }
    return fileNameOpened?:@"";
}
@end
