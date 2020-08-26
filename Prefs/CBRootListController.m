#import <Preferences/Preferences.h>

@interface CBRootListController : PSListController
@end


@implementation CBRootListController
	- (NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		}

		return _specifiers;
	}
@end
