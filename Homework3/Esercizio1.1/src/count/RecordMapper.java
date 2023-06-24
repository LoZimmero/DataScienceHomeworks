package count;
import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class RecordMapper extends Mapper<LongWritable, Text, Text, LongWritable> {
	
	@Override
	protected void map(LongWritable key, Text value, Mapper<LongWritable, Text, Text, LongWritable>.Context context)
			throws IOException, InterruptedException {
		String line = value.toString();						// Stringa in input
		StringTokenizer st = new StringTokenizer(line);		// Per separare la riga del file in parole
		
		logMessage(line);
		if (st.countTokens() != 3) {
			logMessage("Invalid line at position " + key + ": " + line + ". Expected 3 tokens!");
			return;
		}
		
		String month = st.nextToken();
		String site = st.nextToken();
		String visitsStr = st.nextToken();
				
		long visits = -1;
		try {
			visits = Long.parseLong(visitsStr);
		} catch (Exception e) {
			logMessage("Invalid visit count at line number " + key + ". This line will be discarded");
			return;
		}
		
		context.write(new Text(month), new LongWritable(visits));
	}
	
	private void logMessage(String msg) {
		System.out.println(msg);
	}
}