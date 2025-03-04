package de.bladenight.bladenight_app_flutter;

import android.os.Build;
import android.os.Bundle;
import android.window.SplashScreenView;
import androidx.annotation.NonNull;
import androidx.core.view.WindowCompat;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "bladenightchannel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            //Future implementation to show data on Watch
                            if (call.method.equals("flutterToWatch")) {
                                result.success(true);
                            }
                            else {
                                result.success(true);
                                //result.notImplemented();
                            }

                        }
                );
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Aligns the Flutter view vertically with the window.
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            getSplashScreen()
                    .setOnExitAnimationListener(
                            SplashScreenView::remove);
        }

        super.onCreate(savedInstanceState);
    }
    /*@Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        BinaryMessenger messenger = binding.getBinaryMessenger();
        BinaryMessenger.TaskQueue taskQueue =
                messenger.makeBackgroundTaskQueue();
        channel =
                new MethodChannel(
                        messenger,
                        CHANNEL,
                        StandardMethodCodec.INSTANCE,
                        taskQueue);
        channel.setMethodCallHandler(this);
    }*/
}
