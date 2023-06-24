package count;
import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class RecordReducer extends Reducer<Text, LongWritable, Text, LongWritable> {
	
	@Override
	protected void reduce(Text month, Iterable<LongWritable> values,
			Reducer<Text, LongWritable, Text, LongWritable>.Context context) throws IOException, InterruptedException {
		long sum = 0L;
		for (LongWritable value : values) {
			sum += value.get();
		}
		
		// Scriviamo uscita col context
		// K			V
		// prova		2
		context.write(month, new LongWritable(sum));
	}

}
