//
//  UILabel+AWChangeLineSpaceAndWordSpace.h
//  JALearnOC
//
//  Created by jason on 15/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (AWChangeLineSpaceAndWordSpace)

/**
* 改变行间距
*/
- (void)changeLineSpaceForLabel:(float)space;

/**
 *  改变字间距
 */
- (void)changeWordSpaceForLabel:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)changeSpaceForLabelWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


@end

NS_ASSUME_NONNULL_END
