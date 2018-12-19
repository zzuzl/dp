package cn.zlihj.dp;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.FileProvider;

import java.io.File;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.io/battery";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("installApk")) {

                    try {
                        installApk((String) call.argument("filePath"));
                        result.success("success");
                    } catch (Exception e) {
                        result.error("error:", e.getMessage(), e);
                    }
                } else {
                  result.notImplemented();
                }
              }
            });
  }


  private void installApk(String fiePath) {
      Intent intent = new Intent(Intent.ACTION_VIEW);
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      File apkFile = new File(fiePath);

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
          intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
          Uri contentUri = FileProvider.getUriForFile(getApplicationContext(), BuildConfig.APPLICATION_ID + ".fileProvider", apkFile);
          intent.setDataAndType(contentUri, "application/vnd.android.package-archive");
      } else {
          intent.setDataAndType(Uri.fromFile(apkFile), "application/vnd.android.package-archive");
          intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      }

      startActivity(intent);
  }
}
