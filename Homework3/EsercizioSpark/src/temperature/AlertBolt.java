package temperature;


import java.io.FileOutputStream;

import java.util.Map;

import org.apache.storm.task.OutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichBolt;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;

public class AlertBolt extends BaseRichBolt {

	
	private OutputCollector collector;
	private FileOutputStream fileOutputStream;
	
	@Override
	public void execute(Tuple arg0) {
		Long id = arg0.getLong(0);
		String location = arg0.getString(1);
		Long temperature = arg0.getLong(2);
		
		if (temperature >= 35L) {
			long timestamp = System.currentTimeMillis();
			collector.emit(new Values(timestamp, location, temperature));
		}
		collector.ack(arg0);
	}

	@Override
	public void prepare(Map arg0, TopologyContext arg1, OutputCollector arg2) {
		this.collector = arg2;
		
	}

	@Override
	public void declareOutputFields(OutputFieldsDeclarer arg0) {
		arg0.declare(new Fields("timestamp","location","temperature"));
		
	}
}
