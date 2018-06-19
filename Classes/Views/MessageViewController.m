//
//  MessageViewController.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageTextView.h"
#import "Message.h"
#import "Comment.h"
#import "Utils.h"
#import "UserSessionInfo.h"
#import "ChargingStationPresenter.h"
#import "SVProgressHud.h"
#import "WSService.h"

#define DEBUG_CUSTOM_TYPING_INDICATOR 0
#define DEBUG_CUSTOM_BOTTOM_VIEW 0



@interface MessageViewController ()

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, weak) Message *editingMessage;
@property (nonatomic, weak) Message *deletingMessage;

@end

@implementation MessageViewController

@synthesize commentList, station;

- (instancetype)init
{
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}

- (void)commonInit
{
    // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
    [self registerClassForTextView:[MessageTextView class]];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataChanged = NO;
    // Example's configuration
    [self configureDataSource];
    [self configureActionItems];
    
    // SLKTVC's configuration
    self.bounces = YES;
    self.shakeToClearEnabled = NO;
    self.keyboardPanningEnabled = NO;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = YES;
    
    [self.leftButton setImage:[UIImage imageNamed:@"icn_arrow_up"] forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor grayColor]];
    self.leftButton.tag = 1;
    [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 256;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    
    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editorLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.textInputbar.editorRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:MessengerCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - Example's Configuration

- (void)configureDataSource
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *positiveString = @"\U0001F44D";
    NSString *negativeString = @"\U0001F44E";
    
    
    for (Comment *item in self.commentList)
    {
        Message *message = [Message new];
        message.username = item.userName;
        message.textOriginal = item.comment;
        
        NSTimeInterval seconds = item.date / 1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
        NSString *dateText = [Utils relativeDateStringForDate:date];
        
        if (item.reaction == 0)
        {
            message.text = [NSString stringWithFormat:@"%@ %@\n\n%@", item.comment, negativeString, dateText];
        }
        else
        {
            message.text = [NSString stringWithFormat:@"%@ %@\n\n%@", item.comment, positiveString, dateText];
        }
        message.commentObject = item;
        [array addObject:message];
    }

    NSArray *reversed = [[array reverseObjectEnumerator] allObjects];
    self.messages = [[NSMutableArray alloc] initWithArray:reversed];
}

- (void)configureActionItems
{
    int numberOfPositiveComments = 0;
    int numberOfNegativeComments = 0;
    for(Comment *commentItem in commentList)
    {
        if (commentItem.reaction == YES)
        {
            numberOfPositiveComments++;
        }
        else
        {
            numberOfNegativeComments++;
        }
    }
    /*NSString *positiveString = @"\U0001F44D";
    NSString *negativeString = @"\U0001F44E";
    
    NSString *likeDislikeString = [NSString stringWithFormat:@"Comments : %d %@ %d %@", numberOfPositiveComments, positiveString , numberOfNegativeComments, negativeString];*/
    
    if ((numberOfPositiveComments == 0) && (numberOfNegativeComments == 0))
    {
        self.navigationItem.title = @"Be the first to comment!";
    }
    else
    {
        self.navigationItem.title = @"Comments";
    }
    
    //Set user name in our cache and also add button on top left for easy log out
    NSString *userNameForComment = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNameForComments"];
    if (userNameForComment == nil)
    {
        
    }
    else
    {
        UIBarButtonItem *pipItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(logout:)];
        
        self.navigationItem.leftBarButtonItems = @[pipItem];
    }
}


#pragma mark - Action Methods

- (IBAction)closeComments:(id)sender {
    [self.delegate closeComments:dataChanged];
}

- (IBAction)logout:(id)sender {

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Assign UserName"
                                                                              message: @"Input your name, so users can identify you!"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSString *newString = [namefield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([newString isEqualToString:@""])
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid user name"
                                                                           message:@"Please enter a valid user name"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userNameForComments"];
            
            //Set user name in our cache and also add button on top left for easy log out
            [[NSUserDefaults standardUserDefaults] setObject:newString forKey:@"userNameForComments"];
            
            UIBarButtonItem *pipItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(logout:)];
            
            self.navigationItem.leftBarButtonItems = @[pipItem];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)didLongPressCell:(UIGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    alertController.popoverPresentationController.sourceView = gesture.view.superview;
    alertController.popoverPresentationController.sourceRect = gesture.view.frame;
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Edit Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self editCellMessage:gesture];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Delete Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self deleteCellMessage:gesture];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)editCellMessage:(UIGestureRecognizer *)gesture
{
    MessageTableViewCell *cell = (MessageTableViewCell *)gesture.view;
    self.editingMessage = self.messages[cell.indexPath.row];
    
    NSString *userNameForComment = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNameForComments"];
    
    if ([userNameForComment isEqualToString:self.editingMessage.username])
    {
        [self editText:self.editingMessage.textOriginal];
        
        [self.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Bad Action!"
                                                                       message:@"You can only edit your comment!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)deleteCellMessage:(UIGestureRecognizer *)gesture
{
    if (![WSService checkInternet:NO])
    {
        [WSService showNetworkAlertWith:@"Could not delete comment. Please check your internet data connection."];
        [super viewDidLoad];
        return;
    }
    
    MessageTableViewCell *cell = (MessageTableViewCell *)gesture.view;
    self.deletingMessage = self.messages[cell.indexPath.row];
    
    NSString *userNameForComment = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNameForComments"];
    
    if ([userNameForComment isEqualToString:self.deletingMessage.username])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Are you sure?!"
                                                                       message:@"You cannot undo this action."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
        {
            UserSessionInfo *userSession = [UserSessionInfo sharedUser];
            ChargingStationPresenter *presentor = userSession.dependencies.chargingStationPresenter;
            
            [SVProgressHUD showWithStatus:@"Deleting comment..."];

            [presentor deleteCommentForStation:self.deletingMessage.commentObject stationId:[self.station.stationid longLongValue] completion:^(NSError *error) {
                if (error == nil)
                {
                    dataChanged = YES;
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text
                        [self.messages removeObjectAtIndex:cell.indexPath.row];
                        [self.tableView reloadData];
                        
                        [SVProgressHUD showInfoWithStatus:@"The comment deleted."];
                        
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [SVProgressHUD showErrorWithStatus:@"We encountered an error while deleting the comment. Please try later."];
                    });
                }
            }];
                                                                  
                                                                  
          }];
        
        UIAlertAction* defaultAction1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [alert addAction:defaultAction1];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Bad Action!"
                                                                       message:@"You can only delete your comment!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


- (void)editLastMessage:(id)sender
{
    if (self.textView.text.length > 0) {
        return;
    }
    
    NSInteger lastSectionIndex = [self.tableView numberOfSections]-1;
    NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:lastSectionIndex]-1;
    
    Message *lastMessage = [self.messages objectAtIndex:lastRowIndex];
    
    [self editText:lastMessage.text];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Overriden Methods

- (BOOL)ignoreTextInputbarAdjustment
{
    return [super ignoreTextInputbarAdjustment];
}

- (BOOL)forceTextInputbarAdjustmentForResponder:(UIResponder *)responder
{
    if ([responder isKindOfClass:[UIAlertController class]]) {
        return YES;
    }
    
    // On iOS 9, returning YES helps keeping the input view visible when the keyboard if presented from another app when using multi-tasking on iPad.
    return SLK_IS_IPAD;
}

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status
{
    // Notifies the view controller that the keyboard changed status.
    
    switch (status) {
        case SLKKeyboardStatusWillShow:     return NSLog(@"Will Show");
        case SLKKeyboardStatusDidShow:      return NSLog(@"Did Show");
        case SLKKeyboardStatusWillHide:     return NSLog(@"Will Hide");
        case SLKKeyboardStatusDidHide:      return NSLog(@"Did Hide");
    }
}

- (void)textWillUpdate
{
    // Notifies the view controller that the text will update.
    
    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated
{
    // Notifies the view controller that the text did update.
    
    [super textDidUpdate:animated];
}

- (void)didPressLeftButton:(id)sender
{
    // Notifies the view controller when the left button's action has been triggered, manually.
    
    [super didPressLeftButton:sender];

    if (self.leftButton.tag == 1)
    {
        self.leftButton.tag = 0;
        UIImage *btnImage = [UIImage imageNamed:@"icn_arrow_down.png"];
        [self.leftButton setImage:btnImage forState:UIControlStateNormal];
    }
    else
    {
        self.leftButton.tag = 1;
        UIImage *btnImage = [UIImage imageNamed:@"icn_arrow_up.png"];
        [self.leftButton setImage:btnImage forState:UIControlStateNormal];
    }
}

- (void)didPressRightButton:(id)sender
{
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView refreshFirstResponder];
    
    if (![WSService checkInternet:NO])
    {
        [WSService showNetworkAlertWith:@"Could not save comment. Please check your internet data connection."];
        [super viewDidLoad];
        return;
    }
    
    NSString *newComment = self.textView.text;
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNameForComments"];
    if (userName == nil)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Assign UserName"
                                                                                  message: @"Input your name, so users can identify you!"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"name";
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = alertController.textFields;
            UITextField * namefield = textfields[0];
            NSString *newString = [namefield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([newString isEqualToString:@""])
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid user name"
                                                                               message:@"Please enter a valid user name"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                [self saveNewComment:newString newComment:newComment];
            }
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self saveNewComment:userName newComment:newComment];
    }
    
    [super didPressRightButton:sender];
}

- (void) saveNewComment:(NSString *) userName
                newComment: (NSString *) newComment
{
    NSString *UUID = [[NSUUID UUID] UUIDString];
    Comment *comment = [Comment alloc];
    comment.commentId = UUID;
    comment.comment = newComment;
    comment.userName = userName;
    comment.date = [[NSDate date] timeIntervalSince1970] * 1000;
    comment.reaction = self.leftButton.tag;
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    ChargingStationPresenter *presentor = userSession.dependencies.chargingStationPresenter;

    [SVProgressHUD showWithStatus:@"Saving new comment..."];
    
    [presentor addCommentForStation:comment stationId:[self.station.stationid longLongValue] completion:^(NSError *error) {
        if (error == nil)
        {
            dataChanged = YES;
            
            Message *message = [Message new];
            message.username = comment.userName;
            message.textOriginal = comment.comment;
            message.commentObject = comment;
            NSTimeInterval seconds = comment.date / 1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
            NSString *dateText = [Utils relativeDateStringForDate:date];
            NSString *positiveString = @"\U0001F44D";
            NSString *negativeString = @"\U0001F44E";
            
            if (comment.reaction == 0)
            {
                message.text = [NSString stringWithFormat:@"%@ %@\n\n%@", comment.comment, negativeString, dateText];
            }
            else
            {
                message.text = [NSString stringWithFormat:@"%@ %@\n\n%@", comment.comment, positiveString, dateText];
            }
            
            self.navigationItem.title = @"Comments";
            //Set user name in our cache and also add button on top left for easy log out
            NSString *userNameForComment = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNameForComments"];
            if (userNameForComment == nil)
            {
                [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userNameForComments"];
                
                dispatch_async(dispatch_get_main_queue(),^{
                    UIBarButtonItem *pipItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(logout:)];
                
                    self.navigationItem.leftBarButtonItems = @[pipItem];
                });
            }
            
            dispatch_async(dispatch_get_main_queue(),^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                UITableViewRowAnimation rowAnimation = self.inverted ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
                UITableViewScrollPosition scrollPosition = self.inverted ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop;
                
                [self.tableView beginUpdates];
                [self.messages insertObject:message atIndex:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
                [self.tableView endUpdates];
                
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
                [SVProgressHUD showInfoWithStatus:@"The comment is created."];
                
                // Fixes the cell from blinking (because of the transform, when using translucent cells)
                // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(),^{
                [SVProgressHUD showErrorWithStatus:@"We encountered an error while saving the comment. Please try later."];
            });
        }
    }];
}

- (NSString *)keyForTextCaching
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (void)didPasteMediaContent:(NSDictionary *)userInfo
{
    // Notifies the view controller when the user has pasted a media (image, video, etc) inside of the text view.
    [super didPasteMediaContent:userInfo];
    
    SLKPastableMediaType mediaType = [userInfo[SLKTextViewPastedItemMediaType] integerValue];
    NSString *contentType = userInfo[SLKTextViewPastedItemContentType];
    id data = userInfo[SLKTextViewPastedItemData];
    
    NSLog(@"%s : %@ (type = %ld) | data : %@",__FUNCTION__, contentType, (unsigned long)mediaType, data);
}

- (void)didCommitTextEditing:(id)sender
{
    if (![WSService checkInternet:NO])
    {
        [WSService showNetworkAlertWith:@"Could not save comment. Please check your internet data connection."];
        [super viewDidLoad];
        return;
    }
    
    Comment *editedComment = self.editingMessage.commentObject;
    editedComment.comment =self.textView.text;
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    ChargingStationPresenter *presentor = userSession.dependencies.chargingStationPresenter;
    
    NSString *positiveString = @"\U0001F44D";
    NSString *negativeString = @"\U0001F44E";
    
    NSTimeInterval seconds = editedComment.date / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSString *dateText = [Utils relativeDateStringForDate:date];
    
    NSString *displayEditedComment = @"";
    if (editedComment.reaction == 0)
    {
        displayEditedComment = [NSString stringWithFormat:@"%@ %@\n\n%@", editedComment.comment, negativeString, dateText];
    }
    else
    {
        displayEditedComment = [NSString stringWithFormat:@"%@ %@\n\n%@", editedComment.comment, positiveString, dateText];
    }
    
    [SVProgressHUD showWithStatus:@"Updating Comment..."];
    [presentor updateCommentForStation:editedComment stationId:[self.station.stationid longLongValue] completion:^(NSError *error) {
        if (error == nil)
        {
            dataChanged = YES;
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                [SVProgressHUD showInfoWithStatus:@"The comment is updated."];
                // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text
                self.editingMessage.textOriginal = editedComment.comment;
                self.editingMessage.text = displayEditedComment;
                
                [self.tableView reloadData];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [SVProgressHUD showErrorWithStatus:@"We encountered an error while updating the comment. Please try later."];
            });
        }
    }];
    
    
    [super didCommitTextEditing:sender];

}

- (void)didCancelTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the left "Cancel" button
    
    [super didCancelTextEditing:sender];
}

- (BOOL)canPressRightButton
{
    return [super canPressRightButton];
}

- (BOOL)canShowTypingIndicator
{
#if DEBUG_CUSTOM_TYPING_INDICATOR
    return YES;
#else
    return [super canShowTypingIndicator];
#endif
}

- (BOOL)shouldProcessTextForAutoCompletion
{
    return [super shouldProcessTextForAutoCompletion];
}

- (BOOL)shouldDisableTypingSuggestionForAutoCompletion
{
    return [super shouldDisableTypingSuggestionForAutoCompletion];
}

- (CGFloat)heightForAutoCompletionView
{
    CGFloat cellHeight = [self.autoCompletionView.delegate tableView:self.autoCompletionView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cellHeight;
}


#pragma mark - SLKTextViewDelegate Methods

- (BOOL)textView:(SLKTextView *)textView shouldOfferFormattingForSymbol:(NSString *)symbol
{
    if ([symbol isEqualToString:@">"]) {
        
        NSRange selection = textView.selectedRange;
        
        // The Quote formatting only applies new paragraphs
        if (selection.location == 0 && selection.length > 0) {
            return YES;
        }
        
        // or older paragraphs too
        NSString *prevString = [textView.text substringWithRange:NSMakeRange(selection.location-1, 1)];
        
        if ([[NSCharacterSet newlineCharacterSet] characterIsMember:[prevString characterAtIndex:0]]) {
            return YES;
        }
        
        return NO;
    }
    
    return [super textView:textView shouldOfferFormattingForSymbol:symbol];
}

- (BOOL)textView:(SLKTextView *)textView shouldInsertSuffixForFormattingWithSymbol:(NSString *)symbol prefixRange:(NSRange)prefixRange
{
    if ([symbol isEqualToString:@">"]) {
        return NO;
    }
    
    return [super textView:textView shouldInsertSuffixForFormattingWithSymbol:symbol prefixRange:prefixRange];
}

#pragma mark - UITextViewDelegate Methods

- (BOOL)textView:(SLKTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [super textView:textView shouldChangeTextInRange:range replacementText:text];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self messageCellForRowAtIndexPath:indexPath];
}

- (MessageTableViewCell *)messageCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = (MessageTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MessengerCellIdentifier];
    
    if (cell.gestureRecognizers.count == 0) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressCell:)];
        [cell addGestureRecognizer:longPress];
    }
    
    Message *message = self.messages[indexPath.row];
    
    cell.titleLabel.text = message.username;
    cell.bodyLabel.text = message.text;
    
    cell.indexPath = indexPath;
    cell.usedForMessage = YES;
    
    // Cells must inherit the table view's transform
    // This is very important, since the main table view may be inverted
    cell.transform = self.tableView.transform;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        Message *message = self.messages[indexPath.row];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        CGFloat pointSize = [MessageTableViewCell defaultFontSize];
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:pointSize],
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGFloat width = CGRectGetWidth(tableView.frame)-kMessageTableViewCellAvatarHeight;
        width -= 25.0;
        
        CGRect titleBounds = [message.username boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGRect bodyBounds = [message.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        
        if (message.text.length == 0) {
            return 0.0;
        }
        
        CGFloat height = CGRectGetHeight(titleBounds);
        height += CGRectGetHeight(bodyBounds);
        height += 40.0;
        
        if (height < kMessageTableViewCellMinimumHeight) {
            height = kMessageTableViewCellMinimumHeight;
        }
        
        return height;
    }
    else {
        return kMessageTableViewCellMinimumHeight;
    }
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you override this method, to call super.
    [super scrollViewDidScroll:scrollView];
}



#pragma mark - Lifeterm

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
