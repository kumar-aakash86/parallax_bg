#import "ParallaxBgPlugin.h"
#if __has_include(<parallax_bg/parallax_bg-Swift.h>)
#import <parallax_bg/parallax_bg-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "parallax_bg-Swift.h"
#endif

@implementation ParallaxBgPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftParallaxBgPlugin registerWithRegistrar:registrar];
}
@end
