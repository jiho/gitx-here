/*
 *		NSObject subclass to get key-down information at startup
 *
 *		Adapted from:
 *		http://bbs.applescript.net/viewtopic.php?id=19065
 *
 */

#import "StartupController.h"
#import <Carbon/Carbon.h>

@implementation StartupController

+(BOOL)cmdKeyDown {
    return ((GetCurrentKeyModifiers() & cmdKey) != 0);
}

+(BOOL)optKeyDown {
    return ((GetCurrentKeyModifiers() & optionKey) != 0);
}

// the possible key modifiers are 'optionKey', 'cmdKey', 'shiftKey', 'controlKey'

@end