#!/bin/sh
SOURCE=ru/ksi
BASE=/usr/lib
SDK="/mnt/store/android/sdk"
BUILD_TOOLS="${SDK}/build-tools/20.0.0"
PLATFORM="${SDK}/platforms/android-20"
TARGET=Ksi
SIGNER=${SDK}/build-tools/29.0.0/apksigner

rm -rf build/*
mkdir -p build/gen build/obj build/apk
"${BUILD_TOOLS}/aapt" package -f -m -J build/gen/ -S res -M AndroidManifest.xml -I "${PLATFORM}/android.jar"
javac -source 1.7 -target 1.7 -bootclasspath "${JAVA_HOME}/jre/lib/rt.jar" \
		 -classpath "${PLATFORM}/android.jar" -d build/obj \
		 build/gen/${SOURCE}/R.java java/${SOURCE}/MainActivity.java
"${BUILD_TOOLS}/dx" --dex --output=build/apk/classes.dex build/obj/
"${BUILD_TOOLS}/aapt" package -f -M AndroidManifest.xml -S res/  -I "${PLATFORM}/android.jar" \
		-F build/${TARGET}.unsigned.apk build/apk/
"${BUILD_TOOLS}/zipalign" -f 4 build/${TARGET}.unsigned.apk build/${TARGET}.aligned.apk
${SIGNER} sign --ks keystore.jks \
        --ks-key-alias androidkey --ks-pass pass:android \
		      --key-pass pass:android --out build/${TARGET}.apk \
			  build/${TARGET}.aligned.apk

