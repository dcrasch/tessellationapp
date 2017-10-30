// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.share;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import java.io.*;
import android.os.Environment;
import android.support.v4.content.FileProvider;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** Plugin method host for presenting a share sheet via Intent */
public class SharePlugin implements MethodChannel.MethodCallHandler {

    private static final String CHANNEL = "plugins.flutter.io/share";

    public static void registerWith(Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        SharePlugin instance = new SharePlugin(registrar.activity());
        channel.setMethodCallHandler(instance);
    }

    private final Context context;

    private SharePlugin(Context context) {
        this.context = context;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("share")) {
            if (!(call.arguments instanceof String)) {
                result.error("ARGUMENT_ERROR", "String argument expected", null);
                return;
            }
            final String text = (String) call.arguments;
            share(text);
            result.success(null);
        } 
        else if (call.method.equals("shareImage")) {
            if (!(call.arguments instanceof String)) {
                result.error("ARGUMENT_ERROR", "String argument expected", null);
                return;
            }
            final String filename = (String) call.arguments;
            shareImage(filename);
            result.success(null);
        }
        else {
            result.error("UNKNOWN_METHOD", "Unknown share method called", null);
        }
    }

    private void share(String text) {
        Intent shareIntent = new Intent();
        shareIntent.setAction(Intent.ACTION_SEND);
        shareIntent.putExtra(Intent.EXTRA_TEXT, text);
        shareIntent.setType("text/plain");
        context.startActivity(Intent.createChooser(shareIntent, null /* dialog title optional */));
    }

    private void shareImage(String filename) {
        File image = new File(filename);
        Uri fileuri = FileProvider.getUriForFile(context, BuildConfig.APPLICATION_ID, image);
        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        shareIntent.setType("image/*");
        shareIntent.putExtra(Intent.EXTRA_STREAM, fileuri);
        shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        context.startActivity(Intent.createChooser(shareIntent, "Share figure"));
    }
}
