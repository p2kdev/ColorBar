#import <libcolorpicker.h>

static NSString *pillColor = @"E63B79";

@interface MTLumaDodgePillView : UIView
  @property (nonatomic,retain) UIView * colorBarView;
@end

%hook MTStaticColorPillView
  -(void)setPillColor:(UIColor *)arg1
  {
    %orig(LCPParseColorString(pillColor, @"#E63B79"));
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

    self.colorBarView.backgroundColor = LCPParseColorString(pillColor, @"#E63B79");
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

	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.p2kdev.colorbar.plist"];
	if(prefs)
	{
	  pillColor = [prefs objectForKey:@"pillColor"] ? [[prefs objectForKey:@"pillColor"] stringValue] : pillColor;
	}
}

%ctor {
	reloadSettings();
}
