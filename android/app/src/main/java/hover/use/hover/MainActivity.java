package hover.use.hover;

import android.content.Intent;
import android.os.Bundle;

import com.hover.sdk.api.Hover;
import com.hover.sdk.api.HoverParameters;

import java.util.Map;

import io.flutter.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    // Hover Action function
  private static final String CHANNEL = "kikoba.co.tz/hover";
    private  void SendMoney(String PhoneNumber,String amount){
        try {
            Hover.initialize(this);
            Log.d("MainActivity", "Sims are = " + Hover.getPresentSims(this));
            Log.d("MainActivity", "Hover actions are = " + Hover.getAllValidActions(this));
        } catch (Exception e) {
            Log.e("MainActivity", "hover exception", e);

        }
        Intent i = new HoverParameters.Builder(this)
                .request("86c3cc6f")
                .extra("PhoneNumber", PhoneNumber)
                .extra("Amount", amount)
                .buildIntent();

        startActivityForResult(i,0);
    }
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);



    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            (call, result) -> {
// Get arguments from flutter code
              final Map<String,Object> arguments = call.arguments();
              String PhoneNumber = (String) arguments.get("phoneNumber");
              String amount = (String) arguments.get("amount");
              if (call.method.equals("sendMoney")) {
                SendMoney(PhoneNumber,amount);
                String response = "sent";
                result.success(response);
              }
            });
  }
}
