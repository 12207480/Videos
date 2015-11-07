//
//  NSString+Hash.h
//
//  Created by Tom Corwine on 5/30/12..
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (Hash)

+(NSString*)encryptRSA:(NSString*)hexString;
+(NSString*)decryptRSA:(NSString*)hexString;

+ (NSString*)encrypt3DES:(NSString*)plainText withKey:(NSString*)key;
+ (NSString*)decrypt3DES:(NSString*)plainText withKey:(NSString*)key;

+ (NSString *)hexStringFromData:(NSData *)data;
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;
+ (NSString *)ToHex:(uint16_t)tmpid;
+ (NSString *)pinxCreator:(NSString *)pan withPinv:(NSString *)pinv;

+ (NSString *)bcdText:(NSString *)bcd;
+(NSString*)hexToAscII :(NSString *)hexString;
+ (NSString *)macEncode:(NSString *)macValue;
+(NSString*)timeFormat:(NSString *)string;
+(NSString*)cardNumberFormat:(NSString *)string;

+(NSString*)HexValue:(char*)bin Len:(int)binlen;

@end
