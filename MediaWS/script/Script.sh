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

#ffmpeg+h.264
make clean
./configure  --prefix='dist'  --enable-libx264 --enable-gpl --enable-swscale --enable-avfilter  --enable-cross-compile --enable-encoders  --enable-doc   --enable-decoder=h264 --enable-encoder=libx264 --enable-pic  --enable-static  --disable-asm    --disable-debug   --target-os=darwin --arch=arm --cpu=cortex-a8             --extra-cflags='-arch armv7'  --extra-cflags=-I/Users/dingxiuwei/Documents/ffmpeg-iphone-build/x264-armv7/dist/include   --extra-ldflags=-L/Users/dingxiuwei/Documents/ffmpeg-iphone-build/x264-armv7/dist/lib   --extra-ldflags='-arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk'            --cc=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc --as="$SCRIPT_DIR/gas-preprocessor.pl /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc"  --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk 
make && make install
