//
//  NSData+Encrypt_AES256.m
//  2013002-­2
//
//  Created by  tanyg on 13-9-12.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//

#import "NSData+AES256.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (AES256)

//MD5
-(NSString *)md5Hash {

    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], [self length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

//SHA1 40位
-(NSString *)sha1Hash {
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([self bytes], [self length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
            result[16], result[17], result[18], result[19]
            ];
}

//RC4
-(NSString *)RC4Hlovey:(NSString*)aKey
{
    
    NSMutableArray *iS = [[NSMutableArray alloc] initWithCapacity:256];
    NSMutableArray *iK = [[NSMutableArray alloc] initWithCapacity:256];
    
    for (int i= 0; i<256; i++) {
        [iS addObject:[NSNumber numberWithInt:i]];
    }
    
    int j=1;
    
    for (short i=0; i<256; i++) {
        
        UniChar c = [aKey characterAtIndex:i%aKey.length];
        
        [iK addObject:[NSNumber numberWithChar:c]];
    }
    
    j=0;
    
    for (int i=0; i<255; i++) {
        int is = [[iS objectAtIndex:i] intValue];
        UniChar ik = (UniChar)[[iK objectAtIndex:i] charValue];
        
        j = (j + is + ik)%256;
        NSNumber *temp = [iS objectAtIndex:i];
        [iS replaceObjectAtIndex:i withObject:[iS objectAtIndex:j]];
        [iS replaceObjectAtIndex:j withObject:temp];
        
    }
    
    int i=0;
    j=0;
    
    NSString *result = [self bytes];/////?????????????
    
    for (short x=0; x<[self length]; x++) {
        i = (i+1)%256;
        
        int is = [[iS objectAtIndex:i] intValue];
        j = (j+is)%256;
        
        int is_i = [[iS objectAtIndex:i] intValue];
        int is_j = [[iS objectAtIndex:j] intValue];
        
        int t = (is_i+is_j) % 256;
        int iY = [[iS objectAtIndex:t] intValue];
        
        UniChar ch = (UniChar)[result characterAtIndex:x];
        UniChar ch_y = ch^iY;
        
        result = [result stringByReplacingCharactersInRange:NSMakeRange(x, 1) withString:[NSString stringWithCharacters:&ch_y length:1]];
    }
    
    return result;
}

//AES加密
static Byte ivBuff[]   = {0xA,1,0xB,5,4,0xF,7,9,0x17,3,1,6,8,0xC,0xD,91};
-(NSData *)AES256EncryptWithKey:(NSString *)key{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

	NSUInteger dataLength = [self length];
	
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
    bzero(buffer, sizeof(buffer)); // fill with zeroes (for buffer)
    
	size_t numBytesEncrypted = 0;
    

    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
										  keyPtr, kCCKeySizeAES256,
										  ivBuff, /* initialization vector (optional) */
										  [self bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesEncrypted);

    NSLog(@"\ndata = %s \ndataLength = %d \nkey = %s \ncyStatus = %d",[self bytes],dataLength,keyPtr,cryptStatus);
	if (cryptStatus == kCCSuccess) {

		//the returned NSData takes ownership of the buffer and will free it on deallocation
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
		return [GTMBase64_tyg encodeData:data];
	}
	free(buffer); //free the buffer;
    return nil;
}

//AES解密
-(NSData *)AES256DecryptWithKey:(NSString *)key{
    NSData *selfData = [GTMBase64_tyg decodeData:self];
//    NSData *selfData = self;
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	NSUInteger dataLength = [selfData length];
	
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	bzero(buffer, sizeof(buffer)); // fill with zeroes (for buffer)
    
	size_t numBytesDecrypted = 0;
    
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
										  keyPtr, kCCKeySizeAES256,
										  ivBuff /* initialization vector (optional) */,
										  [selfData bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesDecrypted);
    
	NSLog(@"\ndata = %s \ndataLength = %d \nkey = %s \ncyStatus = %d",[self bytes],dataLength,keyPtr,cryptStatus);
    
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
		return data;
	}
	
	free(buffer); //free the buffer;
	return nil;
}

//DES加密
const Byte iv[] = {1,2,3,4,5,6,7,8};
-(NSString *) DESEncrypt:(NSString *)plainText key:(NSString *)key{
    NSString *ciphertext = nil;
    
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes], [textData length],
                                          buffer, 1024,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
         NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
         ciphertext = [GTMBase64_tyg stringByEncodingData:data];
//        ciphertext = [self dataToByteTohex:data];
    }
    return ciphertext;
    
//    char keyPtr[kCCKeySizeAES256+1];
//    bzero(keyPtr, sizeof(keyPtr));
//    
//    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//    
//    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//    NSUInteger dataLength = [data length];
//    
//    size_t bufferSize = dataLength + kCCBlockSizeAES128;
//    void *buffer = malloc(bufferSize);
//    
//    size_t numBytesEncrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                          keyPtr, kCCBlockSizeDES,
//                                          iv,
//                                          [data bytes], dataLength,
//                                          buffer, bufferSize,
//                                          &numBytesEncrypted);
//    
//    if (cryptStatus == kCCSuccess) {
//        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
////        NSString *ciphertext = [self dataToByteTohex:data];
//        NSString *ciphertext = [GTMBase64_tyg stringByEncodingData:data];
//        return ciphertext;
//    }
//    
//    free(buffer);
//    return nil;
}
//DES解密
-(NSString *)DESDecrypt:(NSString *)cipherText key:(NSString *)key{
    NSString *plaintext = nil;
    NSData *cipherdata = [GTMBase64_tyg decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
        }
    return plaintext;
    
//    char keyPtr[kCCKeySizeAES256+1];
//    bzero(keyPtr, sizeof(keyPtr));
//    
//    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//    
////    NSData *data = [self hexToByteToData:cipherText];
//    NSData *data = [GTMBase64_tyg decodeString:cipherText];
//    
//    NSUInteger dataLength = [data length];
//    
//    size_t bufferSize = dataLength + kCCBlockSizeAES128;
//    void *buffer = malloc(bufferSize);
//    
//    size_t numBytesDecrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                          keyPtr, kCCBlockSizeDES,
//                                          iv,
//                                          [data bytes], dataLength,
//                                          buffer, bufferSize,
//                                          &numBytesDecrypted);
//    
//    if (cryptStatus == kCCSuccess) {
//        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
//        NSString *plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
//        return plaintext;
//    }
//    
//    free(buffer);
//    return nil;
}

//二进制转十六进制
-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

//NSData－>Byte数组->16进制数
-(NSString *)dataToByteTohex:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    hexStr = [hexStr uppercaseString];
    return hexStr;
}

//16进制数－>Byte数组->NSData,加上校验码部分
-(NSData *)hexToByteToData:(NSString *)str{
    int j=0;
    Byte bytes[[str length]/2];
    for(int i=0;i<[str length];i++)
    {
        int int_ch;  ///两位16进制数转化后的10进制数
        unichar hex_char1 = [str characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [str characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
//        if (j==[str length]/2-2) {
//            int k=2;
//            int_ch=bytes[0]^bytes[1];
//            while (k
//                int_ch=int_ch^bytes[k];
//                k++;
//            }
//            bytes[j] = int_ch;
//        }
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:[str length]/2 ];
    return newData;
}

@end
