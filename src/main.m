
#import <getopt.h>
#import <string.h>

#import <Foundation/Foundation.h>
#import <AppKit/NSImage.h>

#define VERSION "0.1.0"

extern void print_usage(void);
extern void print_version(void);
extern NSImage * resample_image(NSImage *, double);
extern void save_to_file(NSImage *, NSBitmapImageFileType, NSString *);
extern NSString * get_new_filename(NSString *, NSString *);

static char * gAppName=NULL;

const float XXXHDPI_TO_XXHDPI=0.75f; // 480/640=3/4
const float XXXHDPI_TO_XHDPI=0.5f; // 320/640=1/2
const float XXXHDPI_TO_HDPI=0.375f; // 240/640=3/8
const float XXXHDPI_TO_MDPI=0.25f; // 160/640=1/4
const float XXXHDPI_TO_LDPI=0.1875f; // 120/640=3/16

int main(int argc, char * argv [])
{
    // store the app name
    gAppName=argv[0];
    
    // handle missing parameter
    if(argc==1)
    {
        print_usage();
        return -1;
    }
    
    // handle version
    if(argc == 2)
    {
        if(strcmp(argv[1], "--version")==0 || strcmp(argv[1], "-v")==0)
        {
            print_version();
            return 0;
        }
    }
    
    // store the input file
    const char * inputFile=argv[1];

    @autoreleasepool
    {
        NSString * filename=[NSString stringWithUTF8String:inputFile];
        
        NSImage * img=[[NSImage alloc] initWithContentsOfFile:filename];
        printf("image height: %.2f\n", img.size.height);
        printf("image width: %.2f\n", img.size.width);
        
        NSString * newFileName;
        
        // build for xxhdpi
        NSImage * xxhdpiImg=resample_image(img, XXXHDPI_TO_XXHDPI);
        newFileName=get_new_filename(filename, @"xxhdpi");
        save_to_file(xxhdpiImg, NSPNGFileType, newFileName);
        
        // build for xhdpi
        NSImage * xhdpiImg=resample_image(img, XXXHDPI_TO_XHDPI);
        newFileName=get_new_filename(filename, @"xhdpi");
        save_to_file(xhdpiImg, NSPNGFileType, newFileName);
        
        // build for hdpi
        NSImage * hdpiImg=resample_image(img, XXXHDPI_TO_HDPI);
        newFileName=get_new_filename(filename, @"hdpi");
        save_to_file(hdpiImg, NSPNGFileType, newFileName);
        
        // build for mdpi
        NSImage * mdpiImg=resample_image(img, XXXHDPI_TO_MDPI);
        newFileName=get_new_filename(filename, @"mdpi");
        save_to_file(mdpiImg, NSPNGFileType, newFileName);
        
        // build for ldpi
        NSImage * ldpiImg=resample_image(img, XXXHDPI_TO_LDPI);
        newFileName=get_new_filename(filename, @"ldpi");
        save_to_file(ldpiImg, NSPNGFileType, newFileName);
    }
    
	return 0;
}

NSImage * resample_image(NSImage * aOriginalImage, double aFactor)
{
    // count the new resampled size
    NSSize s=NSMakeSize(
        aFactor*aOriginalImage.size.width,
        aFactor*aOriginalImage.size.height);
    
    // count the new resampled rect
    NSRect r=NSMakeRect(0, 0, s.width, s.height);
    
    // create an NSImage object to which the resampled image will be stored
    NSImage * newImage=[[NSImage alloc] initWithSize:s];
    
    // draw to the new NSImage object
    [newImage lockFocus];
    [aOriginalImage drawInRect:r
        fromRect:NSZeroRect
        operation:NSCompositingOperationSourceOver
        fraction:1.0];
    [newImage unlockFocus];
    
    [newImage autorelease];
    
    return newImage;
}

void save_to_file(NSImage * aImage, NSBitmapImageFileType aType, NSString * aFileName)
{
    CGImageRef cgr = [aImage CGImageForProposedRect:NULL
            context:nil
            hints:nil];
    NSBitmapImageRep * rep = [[NSBitmapImageRep alloc] initWithCGImage:cgr];
    [rep setSize:[aImage size]];
    NSData * data=[rep representationUsingType:aType properties:@{}];
        
    [data writeToFile:aFileName atomically:YES];
    
    [rep autorelease];
}

NSString * get_new_filename(NSString * aFilename, NSString * aDimension)
{
    // get the filename without extension
    NSString * fn=[[aFilename lastPathComponent] stringByDeletingPathExtension];
    NSString * ext=[aFilename pathExtension];
    
    return [NSString stringWithFormat:@"%@_%@.%@", fn, aDimension, ext];
}

void print_usage()
{
    printf("Usage: %s <xxxhdpi image file>\n", gAppName);
}

void print_version()
{
    printf("%s version %s\n", gAppName, VERSION);
}
