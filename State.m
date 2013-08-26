//
//  State.m
//  Ytubeapp
//
//  Created by Matthias Stumpp on 07.01.13.
//  Copyright (c) 2013 Matthias Stumpp. All rights reserved.
//

#import "State.h"

@interface State()
@property NSMutableDictionary *transitionIn;
@property NSMutableDictionary *transitionOut;
@end

@implementation State

-(id)initWithName:(NSString*)name
{
    self = [super init];
    if (self) {
        self.name = name;
        self.transitionIn = [NSMutableDictionary dictionary];
        self.transitionOut = [NSMutableDictionary dictionary];
    }
    return self;
}

-(State*)onViewState:(int)viewState do:(ViewCallback)callback
{
    return [self onViewState:viewState mode:tIn do:callback];
}

-(State*)onViewState:(int)viewState mode:(int)mode do:(ViewCallback)callback
{
    if (mode == tIn || mode == tInOut)
        [self addTransitionInViewState:viewState do:callback];

    if (mode == tOut || mode == tInOut) {
        [self addTransitionOutViewState:viewState do:callback];

    return self;
}

-(void)addTransitionInViewState:(int)viewState do:(ViewCallback)callback
{
    if (![self.transitionIn objectForKey:viewState])
        [self.transitionIn setObject:[NSMutableArray arrayWithObject:callback] forKey:viewState]];
    else
        [[self.transitionIn objectForKey:viewState] addObject:callback];
}

-(void)addTransitionOutViewState:(int)viewState do:(ViewCallback)callback
{
    if (![self.transitionOut objectForKey:viewState])
        [self.transitionOut setObject:[NSMutableArray arrayWithObject:callback] forKey:viewState]];
    else
        [[self.transitionOut objectForKey:viewState] addObject:callback];
}

-(BOOL)processStateIn:(int)viewState
{
    if ([self.transitionIn objectForKey:state]) {
        [[self.transitionIn objectForKey:state] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            ((ViewCallback)object)();
        }];
    }
    return TRUE;
}

-(BOOL)processStateOut:(int)viewState
{
    if ([self.transitionOut objectForKey:state]) {
        [[self.transitionOut objectForKey:state] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            ((ViewCallback)object)();
        }];
    }
    return TRUE;
}

@end
