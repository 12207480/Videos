//
//  NSData+HexToByte.m
//  mPOS
//
//  Created by 德益富 on 15/5/13.
//  Copyright (c) 2015年 Dyf. All rights reserved.
//

#import "NSData+HexToByte.h"
#include <openssl/opensslv.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bn.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

@implementation NSData (HexToByte)

+(NSData*) hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+(NSData*) decryptIPKC:(NSString*)ipkc modulus:(NSString*)mod exponent:(NSString*)exp :(NSString *)d{
    NSString * hexString = ipkc;
    int hexStringLength= [hexString length] / 2;
    //unsigned char enc_bin[144];
    unsigned char dec_bin[hexStringLength];
    //int enc_len;
    int dec_len;
    RSA * rsa_pub = RSA_new();
    
    const char *N=[mod UTF8String] ;
    const char *E=[exp UTF8String];
    
    const char *D=[d UTF8String];
    
    char * myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    if (!BN_hex2bn(&rsa_pub->n, N)) {
        printf("NO CARGO EL MODULO");
    }
    if (!BN_hex2bn(&rsa_pub->e, E)) {
        printf("NO CARGO EL EXPONENTE");
    }
    if (!BN_hex2bn(&rsa_pub->d, D)) {
        printf("NO CARGO EL EXPONENTE");
    }
    if ((dec_len = RSA_private_encrypt(hexStringLength, (unsigned char*)myBuffer, dec_bin, rsa_pub,RSA_NO_PADDING))<0) {
//        printf("NO\n ");
    }
    NSData* data = [NSData dataWithBytes:dec_bin length:sizeof(dec_bin)];
    free(myBuffer);
    return data;
}


+(NSData*) encryptIPKC:(NSString*)ipkc modulus:(NSString*)mod exponent:(NSString*)exp{
    NSString * hexString = ipkc;
    int hexStringLength= [hexString length] / 2;
    //unsigned char enc_bin[144];
    unsigned char dec_bin[hexStringLength];
    //int enc_len;
    int dec_len;
    RSA * rsa_pub = RSA_new();
    
    const char *N=[mod UTF8String];
    const char *E=[exp UTF8String];
    char * myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    if (!BN_hex2bn(&rsa_pub->n, N)) {
        printf("NO CARGO EL MODULO");
    }
    if (!BN_hex2bn(&rsa_pub->e, E)) {
        printf("NO CARGO EL EXPONENTE");
    }
    if ((dec_len = RSA_public_encrypt(hexStringLength, (unsigned char*)myBuffer, dec_bin, rsa_pub,RSA_NO_PADDING))<0) {
        printf("NO\n ");
    }
    NSData* data = [NSData dataWithBytes:dec_bin length:sizeof(dec_bin)];
    free(myBuffer);
    return data;
}

+(NSData*) encodeBCD:(NSString *)value{
    NSMutableData *vdata = [[NSMutableData alloc] init];
    __uint8_t bytes[1] = {6};
    [vdata appendBytes:&bytes length:1];
    NSRange range;
    range.location = 0;
    range.length = 1;
    for (int i = 0; i < [value length];) {
        range.location = i;
        NSString *temp = [value substringWithRange:range];
        int _intvalue1 = [temp intValue];
        _intvalue1 = _intvalue1 << 4;
        range.location = i + 1;
        temp = [value substringWithRange:range];
        int _intvalue2 = [temp intValue];
        int intvalue = _intvalue1 | _intvalue2;
        bytes[0] = intvalue;
        [vdata appendBytes:&bytes length:1];
        i += 2;
    }
    bytes[0] = 255;
    [vdata appendBytes:&bytes length:1];
    bytes[0] = 255;
    [vdata appendBytes:&bytes length:1];
    bytes[0] = 255;
    [vdata appendBytes:&bytes length:1];
    bytes[0] = 255;
    [vdata appendBytes:&bytes length:1];
    return vdata;
}

@end
