# MapReduce

## Build
Prima di buildare, bisogna aggiungere al build path la libreria **Hadoop** presente in *User Libraries* dalla VM.
Per buildare, bisogna esportare da eclipse come jar.

## Esecuzione
Si esegue eseguendo il seguente comando
```bash
hadoop jar <path del jar> <path della main class> <path della cartella contenente input dal DFS> <path della cartella di output dal DFS> <numero di reducer da usare>
``` 

Di seguito, come eseguire i diversi esercizi:
### MapReduce1
```bash
hadoop jar MapReduce1.jar count.ApplicationDriver /home/studente/input /home/studente/output1 3
``` 

### MapReduce2
```bash
hadoop jar MapReduce2.jar count.ApplicationDriver /home/studente/input /home/studente/output2 3
``` 

### MapReduce3
```bash
hadoop jar MapReduce3.jar count.ApplicationDriver /home/studente/input /home/studente/output3 3
``` 

## CheatSheet
per cancellare la cartella di output dal dfs:
```bash
hdfs dfs -rm -r <path della cartella>
``` 

Ad esempio:
```bash
hdfs dfs -rm -r /home/studente/output1
``` 