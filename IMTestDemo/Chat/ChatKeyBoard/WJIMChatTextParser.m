//
//  WJIMChatTextParser.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/16.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatTextParser.h"
#import "NSString+YYAdd.h"
#import "NSAttributedString+YYText.h"
#import "WBStatusHelper.h"

@interface WJIMChatTextParser ()

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightTextColor;

@end

@implementation WJIMChatTextParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        _font = [UIFont systemFontOfSize:17];
        _textColor = [UIColor colorWithWhite:0.2 alpha:1];
        _highlightTextColor = UIColorHex(527ead);
    }
    return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange {
    
    {
        NSArray<NSTextCheckingResult *> *emoticonResults = [[WBStatusHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
        NSUInteger clipLength = 0;
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= clipLength;

            if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            NSString *emoString = [text.string substringWithRange:range];
            NSString *imagePath = [WBStatusHelper emoticonDic][emoString];
            UIImage *image = [WBStatusHelper imageWithPath:imagePath];
            if (!image) continue;
            
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    containsBindingRange = YES;
                    *stop = YES;
                }
            }];
            if (containsBindingRange) continue;
            
            
            YYTextBackedString *backed = [YYTextBackedString stringWithString:emoString];
            NSMutableAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:_font.pointSize].mutableCopy;
            // original text, used for text copy
            [emoText setTextBackedString:backed range:NSMakeRange(0, emoText.length)];
            [emoText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:NSMakeRange(0, emoText.length)];
            
            [text replaceCharactersInRange:range withAttributedString:emoText];
            
            if (selectedRange) {
                *selectedRange = [self _replaceTextInRange:range withLength:emoText.length selectedRange:*selectedRange];
            }
            clipLength += range.length - emoText.length;
        }
    }

    [text enumerateAttribute:YYTextBindingAttributeName inRange:text.rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value && range.length > 1) {
            [text setColor:_highlightTextColor range:range];
        }
    }];
    
    text.font = _font;
    return YES;
}

// correct the selected range during text replacement
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange {
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}


@end
