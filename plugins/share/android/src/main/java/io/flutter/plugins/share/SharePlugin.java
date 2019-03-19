// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.share;

import android.content.Intent;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.Map;

import android.support.v4.content.FileProvider;
import android.net.Uri;
import java.io.File;

/** Plugin method host for presenting a share sheet via Intent */
public class SharePlugin implements MethodChannel.MethodCallHandler {

  private static final String CHANNEL = "plugins.flutter.io/share";

  public static void registerWith(Registrar registrar) {
    MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
    SharePlugin instance = new SharePlugin(registrar);
    channel.setMethodCallHandler(instance);
  }

  private final Registrar mRegistrar;

  private SharePlugin(Registrar registrar) {
    this.mRegistrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
    if (call.method.equals("share")) {
      if (!(call.arguments instanceof Map)) {
        throw new IllegalArgumentException("Map argument expected");
      }
      // Android does not support showing the share sheet at a particular point on screen.
      String shareText = (String) call.argument("text");
      String shareImage = (String) call.argument("image");

      if ((shareText == null || shareText.isEmpty()) &&
          (shareImage == null || shareImage.isEmpty())) {
          throw new IllegalArgumentException("Non-empty text expected");
      }
      if (!(shareImage==null || shareImage.isEmpty())) {
          shareImage(shareImage);
      }
      else {
          share(shareText);
      }
      result.success(null);
    } else {
      result.notImplemented();
    }
  }

  private void share(String text) {
    if (text == null || text.isEmpty()) {
      throw new IllegalArgumentException("Non-empty text expected");
    }

    Intent shareIntent = new Intent();
    shareIntent.setAction(Intent.ACTION_SEND);
    shareIntent.putExtra(Intent.EXTRA_TEXT, text);
    shareIntent.setType("text/plain");
    Intent chooserIntent = Intent.createChooser(shareIntent, null /* dialog title optional */);
    if (mRegistrar.activity() != null) {
      mRegistrar.activity().startActivity(chooserIntent);
    } else {
      chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      mRegistrar.context().startActivity(chooserIntent);
    }
  }

  private void shareImage(String filename) {

    if (filename == null || filename.isEmpty()) {
      throw new IllegalArgumentException("Non-empty image expected");
    }
    File imageFile = new File(filename);
    Uri fileuri = FileProvider.getUriForFile(mRegistrar.context(), "nl.cloudscripting.fileprovider", imageFile);
    Intent shareIntent = new Intent();
    shareIntent.setAction(Intent.ACTION_SEND);
    shareIntent.setType("image/*");
    shareIntent.putExtra(Intent.EXTRA_STREAM, fileuri);
    shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
    Intent chooserIntent = Intent.createChooser(shareIntent, null /* dialog title optional */);
    if (mRegistrar.activity() != null) {
      mRegistrar.activity().startActivity(chooserIntent);
    } else {
      chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      mRegistrar.context().startActivity(chooserIntent);
    }
  }
}
