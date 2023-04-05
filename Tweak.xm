#import <libcolorpicker.h>

static NSString *pillColor = @"E63B79";

@interface MTLumaDodgePillView : UIView
  @property (nonatomic,retain) UIView * colorBarView;
@end

static UIColor* getColorFromLib() {
  return LCPParseColorString(pillColor, @"#E63B79");
  //return [UIColor colorWithRed:0.90 green:0.23 blue:0.47 alpha:1.00];
}

%hook MTStaticColorPillView
  -(void)setPillColor:(UIColor *)arg1
  {
    %orig(getColorFromLib());
  }
%end

%hook MTLumaDodgePillView
  %property (nonatomic,retain) UIView * colorBarView;

  -(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3
  {
    id orig = %orig;
    self.colorBarView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.colorBarView];
    self.colorBarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.colorBarView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.colorBarView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.colorBarView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.colorBarView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;

    self.colorBarView.backgroundColor = getColorFromLib();
    return orig;
  }

  // -(void)layoutSubviews
  // {
  //   %orig;
  //   self.alpha = 1;
  //   self.colorBarView.layer.cornerRadius = self.frame.size.height/2;
  //   [self bringSubviewToFront:self.colorBarView];
  // }

%end


static void reloadSettings() {
		static CFStringRef prefsKey = CFSTR("com.p2kdev.colorbar");
		CFPreferencesAppSynchronize(prefsKey);

		if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"pillColor", prefsKey))) {
			pillColor = [(id)CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"pillColor", prefsKey)) stringValue];
		}
}

%ctor {
	reloadSettings();
}
