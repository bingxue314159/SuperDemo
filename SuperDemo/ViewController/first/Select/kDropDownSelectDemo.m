//
//  kDropDownSelectDemo.m
//  SuperDemo
//
//  Created by tanyugang on 15/4/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "kDropDownSelectDemo.h"
#import "DropDownListView.h"

@interface kDropDownSelectDemo (){
    NSArray *arryList;
    DropDownListView * Dropobj;
}

@end

@implementation kDropDownSelectDemo

- (void)viewDidLoad
{
    [super viewDidLoad];
    arryList=@[@"India",@"Swaziland",@"Africa",@"Australlia",@"Pakistan",@"Srilanka",@"Mexico",@"United Kingdom",@"United States",@"Portugal"];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:self.view animated:YES];
    
    /*----------------Set DropDown backGroundColor-----------------*/
    [Dropobj SetBackGroundDropDwon_R:0.0 G:108.0 B:194.0 alpha:0.70];
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    /*----------------Get Selected Value[Single selection]-----------------*/
    _lblSelectedCountryNames.text=[arryList objectAtIndex:anIndex];
}
- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    
    /*----------------Get Selected Value[Multiple selection]-----------------*/
    if (ArryData.count>0) {
        _lblSelectedCountryNames.text=[ArryData componentsJoinedByString:@"\n"];
        CGSize size=[self GetHeightDyanamic:_lblSelectedCountryNames];
        _lblSelectedCountryNames.frame=CGRectMake(16, 240, 287, size.height);
    }
    else{
        _lblSelectedCountryNames.text=@"";
    }
    
}
- (void)DropDownListViewDidCancel{
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        [Dropobj fadeOut];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGSize)GetHeightDyanamic:(UILabel*)lbl
{
    NSRange range = NSMakeRange(0, [lbl.text length]);
    CGSize constraint;
    constraint= CGSizeMake(287 ,MAXFLOAT);
    CGSize size;
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float>6.0) {
        NSDictionary *attributes = [lbl.attributedText attributesAtIndex:0 effectiveRange:&range];
        CGSize boundingBox = [lbl.text boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    else{
        
        
        size = [lbl.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    }
    return size;
}
- (IBAction)DropDownPressed:(id)sender {
    
    
    [Dropobj fadeOut];
    [self showPopUpWithTitle:@"Select Country" withOption:arryList xy:CGPointMake(16, 58) size:CGSizeMake(287, 330) isMultiple:YES];
}

- (IBAction)DropDownSingle:(id)sender {
    [Dropobj fadeOut];
    [self showPopUpWithTitle:@"Select Country" withOption:arryList xy:CGPointMake(16, 150) size:CGSizeMake(287, 280) isMultiple:NO];
}

@end
