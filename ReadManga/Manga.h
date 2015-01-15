//
//  Manga.h
//  ReadManga
//
//  Created by DuongMac on 1/12/15.
//  Copyright (c) 2015 godduong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Manga : NSManagedObject

@property (nonatomic, retain) NSString * mangaID;
@property (nonatomic, retain) NSString * mangeName;

@end
