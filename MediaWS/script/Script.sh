#!/bin/sh

#  Script.sh
#  
#
#  Created by dxw on 13-3-24.
#

SCRIPT_DIR=$(pwd)

#
#armv7
#x264 script
make clean
CC=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc   ./configure --host=arm-apple-darwin --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk  --prefix='dist'       --extra-cflags='-arch armv7' --extra-ldflags='-arch armv7 -L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/usr/lib/system'   --enable-pic   --enable-static
make && make install

#ffmpeg+h.264
make clean
./configure  --prefix='dist'  --enable-libx264 --enable-gpl --enable-swscale --enable-avfilter  --enable-cross-compile --enable-encoders  --enable-doc   --enable-decoder=h264 --enable-encoder=libx264 --enable-pic  --enable-static  --disable-asm    --disable-debug   --target-os=darwin --arch=arm --cpu=cortex-a8             --extra-cflags='-arch armv7'  --extra-cflags=-I/Users/dingxiuwei/Documents/ffmpeg-iphone-build/x264-armv7/dist/include   --extra-ldflags=-L/Users/dingxiuwei/Documents/ffmpeg-iphone-build/x264-armv7/dist/lib   --extra-ldflags='-arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk'            --cc=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc --as="$SCRIPT_DIR/gas-preprocessor.pl /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc"  --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk 
make && make install



#i386
#x264 script
make clean
CC=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/gcc   ./configure --host=i386-apple-darwin --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk/  --prefix='dist'      --extra-cflags='-arch i386' --extra-ldflags='-arch i386 -L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk/usr/lib/system/'   --enable-pic   --enable-static  --disable--asm
make && make install

#ffmpeg+h.264
make clean
./configure  --prefix='dist'  --enable-libx264 --enable-gpl --enable-swscale --enable-avfilter  --enable-cross-compile --enable-encoders  --enable-doc   --enable-decoder=h264 --enable-encoder=libx264 --enable-pic  --enable-static  --disable-asm    --disable-debug   --target-os=darwin --arch=i386 --cpu=i386 --extra-cflags='-arch i386' --extra-ldflags='-arch i386'              --extra-cflags=-I/Users/dingxiuwei/Documents/ffmpeg-iphone-build/x264-i386/dist/include   --extra-ldflags=-L/Users/dingxiuwei/Documents/ffmpeg-iphone-build/x264-i386/dist/lib   --extra-ldflags='-arch i386 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk'            --cc=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/gcc --as="$SCRIPT_DIR/gas-preprocessor.pl /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/gcc"  --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk/
make && make install



#build-universal
lipo -create -arch armv7 armv7/libavcodec.a -arch i386 i386/libavcodec.a -output universal/libavcodec.a

lipo -create -arch armv7 armv7/libavdevice.a -arch i386 i386/libavdevice.a -output universal/libavdevice.a

lipo -create -arch armv7 armv7/libavformat.a -arch i386 i386/libavformat.a -output universal/libavformat.a

lipo -create -arch armv7 armv7/libavutil.a -arch i386 i386/libavutil.a -output universal/libavutil.a

lipo -create -arch armv7 armv7/libswscale.a -arch i386 i386/libswscale.a -output universal/libswscale.a

lipo -create -arch armv7 armv7/libswresample.a -arch i386 i386/libswresample.a  -output  universal/libswresample.a

lipo -create -arch armv7 armv7/libpostproc.a -arch i386 i386/libpostproc.a -output universal/libpostproc.a

lipo -create -arch armv7 armv7/libx264.a -arch i386 i386/libx264.a -output universal/libx264.a

lipo -create -arch armv7 armv7/libswresample.a -arch i386 i386/libswresample.a universal/libswresample.a
