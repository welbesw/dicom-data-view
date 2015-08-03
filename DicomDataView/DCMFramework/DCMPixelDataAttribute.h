/*=========================================================================
 Program:   OsiriX
 
 Copyright (c) OsiriX Team
 All rights reserved.
 Distributed under GNU - LGPL
 
 See http://www.osirix-viewer.com/copyright.html for details.
 
 This software is distributed WITHOUT ANY WARRANTY; without even
 the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 PURPOSE.
 =========================================================================*/

// 7/7/2005 Fixed bug with planar configuration and YBR. LP

#import <Foundation/Foundation.h>
#import "DCMAttribute.h"

enum photometricmode{DCM_UNKNOWN_PHOTOMETRIC, DCM_MONOCHROME1,  DCM_MONOCHROME2, DCM_RGB, DCM_ARGB,  DCM_YBR_FULL_422, DCM_YBR_PARTIAL_422, DCM_YBR_FULL, DCM_YBR_RCT,  DCM_YBR_ICT, DCM_HSV, DCM_CMYK, DCM_PALETTE };



@class DCMTransferSyntax;
@class DCMObject;
@class NSImage;

@interface DCMPixelDataAttribute : DCMAttribute {
    int		_rows;
    int		_columns;
    int		_samplesPerPixel;
    int		_bytesPerSample;
    int		_numberOfFrames;
    int		_pixelDepth;
    int		_bitsAllocated;
    BOOL	_isShort, _isSigned;
    float	_compression;
    int		_min;
    int		_max;
    DCMTransferSyntax *transferSyntax;
    BOOL	_isDecoded;
    NSMutableArray *_framesDecoded;
    DCMObject *_dcmObject;
    BOOL  _framesCreated;
    NSRecursiveLock *singleThread;
}

@property int rows;
@property int columns;
@property int numberOfFrames;
@property(retain) DCMTransferSyntax *transferSyntax;
@property int samplesPerPixel;
@property int bytesPerSample;
@property int pixelDepth;
@property BOOL isShort;
@property float compression;
@property BOOL isDecoded;

- (id) initWithAttributeTag:(DCMAttributeTag *)tag
                         vr:(NSString *)vr
                     length:(long) vl
                       data:(DCMDataContainer *)dicomData
       specificCharacterSet:(DCMCharacterSet *)specificCharacterSet
             transferSyntax:(DCMTransferSyntax *)ts
                  dcmObject:(DCMObject *)dcmObject
                 decodeData:(BOOL)decodeData;

- (void)deencapsulateData:(DCMDataContainer *)dicomData;

- (void)addFrame:(NSMutableData *)data;
- (void)replaceFrameAtIndex:(int)index withFrame:(NSData *)data;

//Pixel decoding
- (void)decodeData;
- (BOOL)convertToTransferSyntax:(DCMTransferSyntax *)ts quality:(int)quality;
- (NSData *)convertDataFromLittleEndianToHost:(NSMutableData *)data;
- (NSData *)convertDataFromBigEndianToHost:(NSMutableData *)data;
- (void)convertLittleEndianToHost;
- (void)convertBigEndianToHost;
- (void)convertHostToLittleEndian;
- (void)convertHostToBigEndian;
- (NSData *)convertRLEToHost:(NSData *)rleData;
- (void)createOffsetTable;
- (void)interleavePlanes;
- (NSData *)interleavePlanesInData:(NSData *)data;
- (NSMutableData *)createFrameAtIndex:(int)index;
- (void)createFrames;
- (void)setLossyImageCompressionRatio:(NSMutableData *)data quality: (int) quality;
- (void)findMinAndMax:(NSMutableData *)data;
//- (void)decodeRescale;
//RGB data will be interleaved after being converted from Palette or YBR.
- (void)convertToRGBColorspace;
- (NSData *)convertDataToRGBColorSpace:(NSData *)data;
- (NSData *)convertPaletteToRGB:(NSData *)data;
- (NSData *) convertYBrToRGB:(NSData *)ybrData kind:(NSString *)theKind isPlanar:(BOOL)isPlanar;
- (NSData *)convertToFloat:(NSData *)data;
- (NSData *)decodeFrameAtIndex:(int)index;

@end