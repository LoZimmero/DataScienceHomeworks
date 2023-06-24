package distinct;
import java.io.IOException;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class ApplicationDriver {
	public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
		// Pattern di lancio - instanziazione
		Job job = Job.getInstance();
		
		// Hadoop deve sapere da dove partire.
		// Specifichiamo quindi l'entrypoint del job
		job.setJarByClass(distinct.ApplicationDriver.class);
		
		// Impostiamo un nome simbolico al Job
		job.setJobName("CountSitesApplication");
		
		// Si possono settare qui il numero di reduce da istanziare, mentre
		// i mapper sono gestiti dal framework. Se non si setta il numero,
		// di default si usa un solo reducer
		job.setNumReduceTasks(Integer.parseInt(args[2]));
		
		// Specifichiamo il path da usare copme imput dell'applicazione a partire dal DFS
		// Noi glielo facciamo prendere da program arguments
		FileInputFormat.addInputPath(job, new Path(args[0]));
		
		// Path di uscita
		FileOutputFormat.setOutputPath(job, new Path(args[1]));
		
		job.setMapperClass(distinct.RecordMapper.class);
		job.setReducerClass(distinct.RecordReducer.class);
		// Qui si poteva usare anche un combiner, ma non lo facciamo
		
		// Specifichiamo il formato dell'uscita
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(Text.class);
		
		// Facciamo attendere il main finché il Job non completa.
		// Con questa riga, inoltre, lanciamo il job
		System.exit(job.waitForCompletion(true) ? 0 : 1);
		
	}
}
