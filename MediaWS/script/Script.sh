#!/bin/sh

#  Script.sh
#  
#
#  Created by dxw on 13-3-24.
#
#

#x264 script
make clean
CC=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc   ./configure --host=arm-apple-darwin --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk  --prefix='dist'       --extra-cflags='-arch armv7' --extra-ldflags='-arch armv7 -L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/usr/lib/system'   --enable-pic   --enable-static
make && make install
