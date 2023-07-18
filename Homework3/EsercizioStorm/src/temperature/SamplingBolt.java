package temperature;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Map;

import org.apache.storm.task.OutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichBolt;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;

public class SamplingBolt extends BaseRichBolt {

	
	private OutputCollector collector;
	private FileOutputStream fileOutputStream;
	
	@Override
	public void execute(Tuple arg0) {
		Long id = arg0.getLong(0);
		String location = arg0.getString(1);
		Long temperature = arg0.getLong(2);
		
		if (id%10 < 2) {
			// Get only 20% of event by filtering IDs
			collector.emit(new Values(id, location, temperature));
			String fileStr = "" + id +"," + location + "," + temperature + "\n";
			System.out.println(fileStr);
			try {
				fileOutputStream.write(fileStr.getBytes());
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		collector.ack(arg0);
	}

	@Override
	public void prepare(Map arg0, TopologyContext arg1, OutputCollector arg2) {
		this.collector = arg2;
		try {
			this.fileOutputStream = new FileOutputStream("logfile.txt");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void declareOutputFields(OutputFieldsDeclarer arg0) {
		arg0.declare(new Fields("id","location","temperature"));
		
	}
	
	@Override
	public void cleanup() {
		// TODO Auto-generated method stub
		super.cleanup();
		if (fileOutputStream != null)
			try {
				fileOutputStream.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}

}
