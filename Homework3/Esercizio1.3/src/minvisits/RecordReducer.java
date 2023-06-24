package minvisits;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class RecordReducer extends Reducer<Text, LongWritable, Text, LongWritable> {
	
	@Override
	protected void reduce(Text key, Iterable<LongWritable> values,
			Reducer<Text, LongWritable, Text, LongWritable>.Context context) throws IOException, InterruptedException {
		Long minValue = null;
		for (LongWritable value : values) {
			long parsedValue = value.get();
			if (minValue == null) minValue = parsedValue;
			if (minValue > parsedValue) minValue = parsedValue;
		}
		
		// Scriviamo uscita col context
		// K			V
		// prova		2
		context.write(key, new LongWritable(minValue));
	}

}
