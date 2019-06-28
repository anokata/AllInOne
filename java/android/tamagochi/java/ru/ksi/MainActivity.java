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

  @Override
  protected void onCreate(Bundle savedInstanceState) {
	super.onCreate(savedInstanceState);
	setContentView(R.layout.activity_main);

	TextView text = (TextView)findViewById(R.id.my_text);
	text.setText("Hi");
	Button button = (Button) findViewById(R.id.button_id);
	button.setOnClickListener(new View.OnClickListener() {
	  public void onClick(View v) {
	  }
	});
  }
}
