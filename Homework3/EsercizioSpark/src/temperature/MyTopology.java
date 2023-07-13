package temperature;

import org.apache.storm.Config;
import org.apache.storm.LocalCluster;
import org.apache.storm.topology.TopologyBuilder;

public class MyTopology {
	public static void main(String[] args) throws Exception {
		Config config = new Config();
		config.setDebug(false);
		
		// Topology
		TopologyBuilder builder = new TopologyBuilder();
		builder.setSpout("SocketSpout", new SocketSpout());
		builder.setBolt("SamplingBolt", new SamplingBolt())
			.shuffleGrouping("SocketSpout");
		builder.setBolt("AlertBolt", new AlertBolt())
			.shuffleGrouping("SocketSpout");
		builder.setBolt("AlertLogBolt", new AlertLogBolt())
			.shuffleGrouping("AlertBolt");
		
		// Execute using LocalCluster
		LocalCluster cluster = new LocalCluster();
		cluster.submitTopology("myTopology", config, builder.createTopology());
		
		// Wait 10 seconds before stopping
		Thread.sleep(100000);
		
		// Shutdown local cluster
		cluster.shutdown();

		/*
		// Execute using StormSubmitter
		StormSubmitter.submitTopology("myTopology", config, builder.createTopology());
	
		 */
		
	}
}
