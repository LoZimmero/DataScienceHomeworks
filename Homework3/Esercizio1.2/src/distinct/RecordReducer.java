package distinct;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class RecordReducer extends Reducer<Text, Text, Text, LongWritable> {
	
	@Override
	protected void reduce(Text key, Iterable<Text> values,
			Reducer<Text, Text, Text, LongWritable>.Context context) throws IOException, InterruptedException {
		Set<String> distinctSites = new HashSet<String>();
		for (Text value : values) {
			distinctSites.add(value.toString());
		}
		
		// Scriviamo uscita col context
		// K			V
		// prova		2
		context.write(key, new LongWritable(distinctSites.size()));
	}

}
