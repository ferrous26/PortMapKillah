//
//  main.m
//  uTorrentRemover
//
//  Created by Mark Rada on 12-03-09.
//  Copyright (c) 2012 Marketcircle Incorporated. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
  return macruby_main("rb_main.rb", argc, argv);
}
