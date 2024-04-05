/*
 * This file is part of Kiwix for iOS & macOS.
 *
 * Kiwix is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * any later version.
 *
 * Kiwix is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Kiwix; If not, see https://www.gnu.org/licenses/.
*/

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#include "kiwix/book.h"
#pragma clang diagnostic pop

#import "ZimFileMetaData.h"

#define SAFE_READ(X, Y) try {X = Y;} catch (std::exception) {X = nil;}
#define SAFE_READ_BOOL(X, Y) try {X = Y;} catch (std::exception) {X = false;}

@implementation ZimFileMetaData

- (nullable instancetype)initWithBook:(void *)book {
    self = [super init];
    if (self) {
        kiwix::Book *_book = static_cast<kiwix::Book *>(book);
        
        try {
            NSString *identifier = [NSString stringWithUTF8String:_book->getId().c_str()];
            self.fileID = [[NSUUID alloc] initWithUUIDString:identifier];
            self.title = [NSString stringWithUTF8String:_book->getTitle().c_str()];
            self.groupIdentifier = [NSString stringWithUTF8String:_book->getName().c_str()];
            self.fileDescription = [NSString stringWithUTF8String:_book->getDescription().c_str()];
            self.languageCodes = [self getLanguageCodesFromBook:_book];
            self.category = [self getCategoryFromBook:_book];
            self.creationDate = [self getCreationDateFromBook:_book];
            self.size = [NSNumber numberWithUnsignedLongLong:_book->getSize()];
            self.articleCount = [NSNumber numberWithUnsignedLongLong:_book->getArticleCount()];
            self.mediaCount = [NSNumber numberWithUnsignedLongLong:_book->getMediaCount()];
            self.creator = [NSString stringWithUTF8String:_book->getCreator().c_str()];
            self.publisher = [NSString stringWithUTF8String:_book->getPublisher().c_str()];
        } catch (std::exception) {
            return nil;
        }
        
        // fail if required property is nil
        if (self.fileID == nil) { return nil; }
        if (self.creationDate == nil) { return nil; }
        if (self.size == nil) { return nil; }
        if (self.articleCount == nil) { return nil; }
        if (self.mediaCount == nil) { return nil; }
        if (self.creator == nil) { return nil; }
        if (self.publisher == nil) { return nil; }
        
        SAFE_READ(self.downloadURL, [self getURL:_book->getUrl()]);
        SAFE_READ(self.faviconURL, [self getFaviconURLFromBook:_book]);
        SAFE_READ(self.flavor, [self getFlavorFromBook:_book]);
        
        SAFE_READ_BOOL(self.hasDetails, _book->getTagBool("details"));
        SAFE_READ_BOOL(self.hasPictures, _book->getTagBool("pictures"));
        SAFE_READ_BOOL(self.hasVideos, _book->getTagBool("videos"));
        SAFE_READ_BOOL(self.requiresServiceWorkers, _book->getTagBool("sw"));
    }
    return self;
}

- (NSString *)getLanguageCodesFromBook:(kiwix::Book *)book {
    NSString* string = [NSString stringWithUTF8String:book->getCommaSeparatedLanguages().c_str()];
    NSArray* components = [string componentsSeparatedByString: @","];
    NSMutableArray* langCodes = [NSMutableArray array];
    [components enumerateObjectsUsingBlock:^(id  _Nonnull codeString, NSUInteger idx, BOOL * _Nonnull stop) {
        [langCodes addObject: codeString];
    }];
    return [langCodes componentsJoinedByString: @","];
}

- (NSString *)getCategoryFromBook:(kiwix::Book *)book {
    try {
        return [NSString stringWithUTF8String:book->getTagStr("category").c_str()];
    } catch (std::out_of_range e) {
        return @"other";
    }
}

- (NSDate *)getCreationDateFromBook:(kiwix::Book *)book {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    return [formatter dateFromString:[NSString stringWithUTF8String:book->getDate().c_str()]];
}

- (NSURL *)getURL:(std::string)urlString {
    if (urlString.length() == 0) { return nil; }
    return [NSURL URLWithString:[NSString stringWithUTF8String:urlString.c_str()]];
}

- (NSURL *)getFaviconURLFromBook:(kiwix::Book *)book {
    try {
        std::string url = book->getIllustrations().at(0)->url;
        return [self getURL:url];
    } catch (std::exception) {
        return nil;
    }
}

- (NSString *)getFlavorFromBook:(kiwix::Book *)book {
    NSString *flavor = [NSString stringWithUTF8String:book->getFlavour().c_str()];
    return [flavor stringByReplacingOccurrencesOfString:@"_" withString:@""];
}

@end
