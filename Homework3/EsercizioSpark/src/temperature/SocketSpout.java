package temperature;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Map;

import org.apache.storm.spout.SpoutOutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichSpout;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Values;

public class SocketSpout extends BaseRichSpout{
	
	private SpoutOutputCollector collector;
	private BufferedReader reader;
	

	@Override
	public void nextTuple() {
		// TODO Auto-generated method stub
		String line = null;
		try {
			line = reader.readLine();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return;
		}
		if (line == null) return;
		String[] tokens = line.split(" ");
		String id = tokens[5];
		String location = tokens[6];
		String temperatureStr = tokens[8];
		
		long temperature = -1;
		long idLong = -1;
		try {
			temperature = Long.parseLong(temperatureStr);
			idLong = Long.parseLong(id);
		} catch (Exception e) {
			e.printStackTrace();
			return;
		}
		
		collector.emit(new Values(idLong, location, temperature));
		
	}

	@Override
	public void open(Map arg0, TopologyContext arg1, SpoutOutputCollector arg2) {
		this.collector = arg2;
		
		Socket socket;
		try {
			socket = new Socket("localhost", 7777);
	        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
	        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
	        this.reader = in;
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void declareOutputFields(OutputFieldsDeclarer arg0) {
		arg0.declare(new Fields("id","location","temperature"));
		
	}
	

}
