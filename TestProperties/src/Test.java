import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class Test {
	public static void main(String[] args) throws IOException {
		Properties props = new Properties();
		FileInputStream in = new FileInputStream("glace2d.properties");
		props.load(in);
		for (String s : props.stringPropertyNames())
			System.out.println(s + " : " + props.getProperty(s));
		in.close();		
	}
}
