//
//  NSString+Hash.m
//
//  Created by Tom Corwine on 5/30/12.
//

#import "NSString+hash.h"
#include <stdlib.h>
#import "TDES.h"//3des
char hout992[4096];

@implementation NSString (Hash)


char* BinToHex992(char* bin,int off,int len)
{
    int i;
    for (i=0;i<len;i++)
    {
        sprintf((char*)hout992+i*2,"%02x",*(unsigned char*)((char*)bin+i+off));
    }
    hout992[len*2]=0;
    return hout992;
}
+(NSString*)HexValue:(char*)bin Len:(int)binlen{
    char *hs;
    hs = BinToHex992(bin,0,binlen);//, <#int off#>, <#int len#>)
    hs[binlen*2]=0;
    NSString* str =[[NSString alloc] initWithFormat:@"%s",hs];
    return str;
}

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

+(NSString*)encryptRSA:(NSString*)hexString//加密的数据
{
    NSString *m= PublicKey;
    NSString *e=@"10001";
    NSData *decryptedIPKC= [NSData encryptIPKC:hexString modulus:m exponent:e];
    NSString *postToken=decryptedIPKC.description;
    NSRange range=NSMakeRange(1, postToken.length-2);
    postToken=[[postToken substringWithRange:range] stringByReplacingOccurrencesOfString:@" " withString:@""];
    return postToken;
}


+(NSString*)decryptRSA:(NSString*)hexString
{
    NSString *e=@"10001";
    NSString *d=PrivateKey;
    NSString *n=PrivateKey2;
    NSData *decryptedIPKC= [NSData decryptIPKC:hexString modulus:n exponent:e :d];
    NSString *postToken=decryptedIPKC.description;
    NSRange range=NSMakeRange(1, postToken.length-2);
    postToken=[[postToken substringWithRange:range] stringByReplacingOccurrencesOfString:@" " withString:@""];
    return postToken;
}

+(NSString *)hexStringFromData:(NSData *)data{
    Byte *bytes=(Byte*)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
        
    {
        NSString *newHexStr=[NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr=[NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            
            hexStr=[NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


+ (NSString*)encrypt3DES:(NSString*)plainText withKey:(NSString*)key{
    NSString *mycode=[NSString stringWithFormat:plainText];
    NSString *myUpperCaseStringCode=[mycode uppercaseString];
    NSString *my3DESCodeStr=[NSString stringWithFormat:@""];
    
    for (int i = 0; i <(plainText.length/16); i++) {
        NSRange range=NSMakeRange(i*16, 16);
        NSString *iValue=[NSString stringWithFormat:@"%@",[myUpperCaseStringCode substringWithRange:range]];
        char *data = [iValue UTF8String];
        char *myklk=[key UTF8String];
        char *outbuf[30];
        memset (outbuf,0x00,30);
        encrpt3DES(outbuf,data,myklk);
        NSString *encode = [[NSString alloc] initWithCString:(const char*)outbuf];
        my3DESCodeStr=[NSString stringWithFormat:@"%@%@",my3DESCodeStr,encode];
    }
    return my3DESCodeStr;
}

+ (NSString*)decrypt3DES:(NSString*)plainText withKey:(NSString*)key{
    
    NSString *mycode=[NSString stringWithFormat:plainText];
    NSString *myUpperCaseStringCode=[mycode uppercaseString];
    NSString *my3DESCodeStr=[NSString stringWithFormat:@""];
    
    for (int i = 0; i <(plainText.length/16); i++) {
        NSRange range=NSMakeRange(i*16, 16);
        NSString *iValue=[NSString stringWithFormat:@"%@",[myUpperCaseStringCode substringWithRange:range]];
        char *data = [iValue UTF8String];
        char *myklk=[key UTF8String];
        char *outbuf[30];
        memset (outbuf,0x00,30);
        decrpt3DES(outbuf,data,myklk);
        NSString *encode = [[NSString alloc] initWithCString:(const char*)outbuf];
        my3DESCodeStr=[NSString stringWithFormat:@"%@%@",my3DESCodeStr,encode];
    }
    return my3DESCodeStr;
}

//2to10
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    
    return result;
}

+ (NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

//异或
+ (NSString *)pinxCreator:(NSString *)pan withPinv:(NSString *)pinv
{
    if (pan.length != pinv.length)
    {
        return nil;
    }
    const char *panchar = [pan UTF8String];
    const char *pinvchar = [pinv UTF8String];
    NSString *temp = [[NSString alloc] init];
    for (int i = 0; i < pan.length; i++)
    {
        int panValue = [self charToint:panchar[i]];
        int pinvValue = [self charToint:pinvchar[i]];
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%X",panValue^pinvValue]];
    }
    return temp;
}

+ (NSString *)bcdText:(NSString *)bcd
{
    NSString *bcdcode=[NSString stringWithFormat:@""];
    char out[512] = {0};
    char *data =[bcd UTF8String];
    Str2Hex(data,out,bcd.length);
    NSString *temoBCDcode = [[NSString alloc] initWithCString:(const char*)out];
    return temoBCDcode;
    //    NSString *lastStr=[NSString stringWithFormat:@""];
    //    int bcdLength=bcd.length/8;
    //    if(bcdLength*8!=bcd.length)//不相等
    //    {
    //        NSRange range=NSMakeRange((bcdLength*8), bcd.length-bcdLength*8);
    //        lastStr=[bcd substringWithRange:range];
    //        NSString *tempLastStr=[NSString stringWithFormat:@""];
    //        for (int j=0;j<(8-lastStr.length)/2; j++) {
    //            tempLastStr=[NSString stringWithFormat:@"%@00",tempLastStr];
    //        }
    //        lastStr=[NSString stringWithFormat:@"%@%@",lastStr,tempLastStr];
    //        for (int i=0; i<bcd.length/8+1; i++) {
    //            if(i==bcd.length/8)//最后一个
    //            {
    //                char out[32] = {0};
    //                char *data =[lastStr UTF8String];
    //                Str2Hex(data,out,sizeof(data));
    //                NSString *temoBCDcode = [[NSString alloc] initWithCString:(const char*)out];
    //                bcdcode=[NSString stringWithFormat:@"%@%@",bcdcode,temoBCDcode];
    //            }
    //            else
    //            {
    //                NSRange range=NSMakeRange(i*8,8);
    //                NSString *tempBCD=[bcd substringWithRange:range];
    ////                NSLog(@"----------2--%@",tempBCD);
    //
    //                char out[32] = {0};
    //                char *data =[tempBCD UTF8String];
    //                Str2Hex(data,out,sizeof(data));
    //                NSString *temoBCDcode = [[NSString alloc] initWithCString:(const char*)out];
    //                bcdcode=[NSString stringWithFormat:@"%@%@",bcdcode,temoBCDcode];
    //            }
    //
    //        }
    //    }
    //    else
    //    {
    //        for (int i=1; i<bcd.length/8; i++) {
    //            NSRange range=NSMakeRange(i*8,8);
    //            NSString *tempBCD=[bcd substringWithRange:range];
    ////            NSLog(@"----------3--%@",tempBCD);
    //            char out[32] = {0};
    //            char *data =[tempBCD UTF8String];
    //            Str2Hex(data,out,sizeof(data));
    //            NSString *temoBCDcode = [[NSString alloc] initWithCString:(const char*)out];
    //            bcdcode=[NSString stringWithFormat:@"%@%@",bcdcode,temoBCDcode];
    //        }
    //    }
    
    
    //    return bcdcode;
}

+ (int)charToint:(char)tempChar
{
    if (tempChar >= '0'&& tempChar <='9')
    {
        return tempChar - '0';
    }
    else if (tempChar >= 'A' && tempChar <= 'F')
    {
        return tempChar - 'A' + 10;
    }
    return 0;
}


+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    if (encryptOperation == kCCDecrypt)
    {
        NSData *decryptData =[sText dataUsingEncoding:NSUTF8StringEncoding];// [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [decryptData length];
        vplainText = [decryptData bytes];
    }
    else//加密
        
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [encryptData length];
        vplainText = (const void *)[encryptData bytes];
    }
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    NSString *initVec = @"init Kurodo";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    ccStatus = CCCrypt(encryptOperation,
                       kCCAlgorithmDES,
                       kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSString *result = nil;
    if (encryptOperation == kCCDecrypt)
        
    {
        //        NSLog(@"kCCDecrypt--data---%@",[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes]);
        result=[self hexStringFromData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes]];
    }
    else
    {
        //        NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result=[self hexStringFromData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes]];
                NSLog(@"--data---%@",[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes]);
    }
    return result;
}

//16进制的字符转换成ASCII
+(NSString*)hexToAscII :(NSString *)hexString
{
    NSString *asciiStr=[NSString string];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        NSString *string=[NSString stringWithFormat:@"%c",int_ch];
        
        asciiStr= [NSString stringWithFormat:@"%@%@",asciiStr,string];
    }
    return asciiStr;
}

+ (NSString *)macEncode:(NSString *)macValue
{
    NSString *lastXOR=[NSString string];
    NSString *lastStr=[NSString string];
    unsigned long int bcdLength=macValue.length/16;
    if(bcdLength*16!=macValue.length)//不相等
    {
        NSRange range=NSMakeRange((bcdLength*16), macValue.length-bcdLength*16);
        lastStr=[macValue substringWithRange:range];
        NSString *tempLastStr=[NSString stringWithFormat:@""];
        for (int j=0;j<(16-lastStr.length)/2; j++) {
            tempLastStr=[NSString stringWithFormat:@"%@00",tempLastStr];
        }
        lastStr=[NSString stringWithFormat:@"%@%@",lastStr,tempLastStr];
        for (int i=0; i<=macValue.length/16; i++) {
            if(i==(macValue.length/16))//最后一个
            {
                lastXOR=[self pinxCreator:lastXOR withPinv:lastStr];
            }
            else
            {
                if(lastXOR.length)
                {
                    NSRange range=NSMakeRange(i*16,16);
                    NSString *tempMac=[macValue substringWithRange:range];
                    lastXOR=[self pinxCreator:lastXOR withPinv:tempMac];
                }
                else
                {
                    NSRange range=NSMakeRange(16,16);
                    NSString *tempMac=[macValue substringWithRange:range];
                    NSString *firstMac=[macValue substringWithRange:NSMakeRange(0,16)];//首先取出第一二个数据
                    lastXOR=[self pinxCreator:firstMac withPinv:tempMac];
                    i=1;
                }
            }
           
        }
    }
    else
    {
        NSLog(@"---相等---");
        for (int i=0; i<macValue.length/16; i++) {
            if(lastXOR.length)
            {
                NSRange range=NSMakeRange(i*16,16);
                NSString *tempMac=[macValue substringWithRange:range];
                lastXOR=[self pinxCreator:lastXOR withPinv:tempMac];
            }
            else
            {
                NSRange range=NSMakeRange(16,16);
                NSString *tempMac=[macValue substringWithRange:range];
                NSString *firstMac=[macValue substringWithRange:NSMakeRange(0,16)];//首先取出第一二个数据
                lastXOR=[self pinxCreator:firstMac withPinv:tempMac];
                i=1;
            }
        }
    }
    return lastXOR;
}


+(NSString*)timeFormat:(NSString *)string
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    return str;
}

+(NSString*)cardNumberFormat:(NSString *)string
{
    NSRange bankNumberCodeRange=NSMakeRange((string.length/2-4), 8);
    string=[string stringByReplacingCharactersInRange:bankNumberCodeRange withString:@"**** ****"];
    return string;
}

@end
