package ru.ksi;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.Button;
import android.widget.Toast;
import android.view.View;
import android.content.ClipboardManager;
import android.content.ClipData;

public class MainActivity extends Activity {
  private static String extract(String s) {
	int start = s.indexOf("%3D");
	int end = s.indexOf("%26");
	if(start == -1 ||  end == -1) {
	  return "error";
	}
	return s.substring(start + 3, end);
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
	super.onCreate(savedInstanceState);
	setContentView(R.layout.activity_main);

	TextView text = (TextView)findViewById(R.id.my_text);
	text.setText("Извлечь youtube video id");
	Button button = (Button) findViewById(R.id.button_id);
	button.setOnClickListener(new View.OnClickListener() {
	  public void onClick(View v) {
		ClipboardManager myClipboard = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
		ClipData abc = myClipboard.getPrimaryClip();
		ClipData.Item item = abc.getItemAt(0);
		String text = item.getText().toString();
		String video_id = MainActivity.extract(text);
		ClipData myClip = ClipData.newPlainText("text", video_id);
		myClipboard.setPrimaryClip(myClip);

		Toast toast = Toast.makeText(getApplicationContext(), 
			video_id, Toast.LENGTH_SHORT); 
		toast.show(); 
	  }
	});
  }
}
