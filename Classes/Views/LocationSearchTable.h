//
//  LocationSearchTable.h
//  ReLive
//
//  Created by kamyFCMacBook on 1/27/16.
//
//

#import <UIKit/UIKit.h>
#import "ChargingStation.h"

@protocol SearchResultsDelegate

-(void)dropPinZoomIn:(ChargingStation *)station;

@end

@interface LocationSearchTable : UITableViewController<UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating, UISearchBarDelegate,
UISearchControllerDelegate>
{
    
    
}


@property (weak, nonatomic) id <SearchResultsDelegate> delegate;

@property (strong, nonatomic) NSArray *filteredList;

@end



