#import <libactivator/libactivator.h>

@interface Listener : NSObject <LAListener, UIAlertViewDelegate>
@end

@implementation Listener

static Listener *listener;
static UIAlertView *alert;

// IMPORTANT: the listener needs to be registered exactly like this because of ARC being enabled
// If not, memory leak -> insta-crash
+ (void)load {
    @autoreleasepool {
        listener = [[Listener alloc] init];
        [[LAActivator sharedInstance] registerListener:listener forName:@"com.jakej.editpasteboard"];
    }
}

// Use a UIAlertView because we have *no* idea what view controller's will be active/visible
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    alert = [[UIAlertView alloc] initWithTitle:@"EditPasteboard" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = [UIPasteboard generalPasteboard].string;
    [alert show];
    
    event.handled = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [UIPasteboard generalPasteboard].string = [alert textFieldAtIndex:0].text;
    }
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

// This information can also be stored in a .plist; it's mostly personal preference.
// I think it minimizes extraneous directory's
- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    return @"Edit Pasteboard";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return @"Edit the contents of the pasteboard, or just take a peek.";
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return @[@"springboard", @"lockscreen", @"application"];
}

@end