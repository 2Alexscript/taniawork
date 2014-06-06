/*   1:    */ package edu.iu.nwb.analysis.extractcoauthorship.algorithms;
/*   2:    */ 
/*   3:    */ import edu.iu.nwb.analysis.extractcoauthorship.metadata.SupportedFileTypes;
/*   4:    */ import edu.iu.nwb.analysis.extractcoauthorship.metadata.SupportedFileTypes.CitationFormat;
/*   5:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.ExtractNetworkFromTable;
/*   6:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.GraphContainer;
/*   7:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.GraphContainer.PropertyParsingException;
/*   8:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.InvalidColumnNameException;

/*   9:    */ import java.io.FileNotFoundException;
/*  10:    */ import java.io.IOException;
/*  11:    */ import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
/*  12:    */ import java.util.Dictionary;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/*  13:    */ import java.util.Properties;
import java.util.StringTokenizer;

import javax.swing.JOptionPane;

/*  14:    */ import org.cishell.framework.CIShellContext;
/*  15:    */ import org.cishell.framework.algorithm.Algorithm;
/*  16:    */ import org.cishell.framework.algorithm.AlgorithmExecutionException;
/*  17:    */ import org.cishell.framework.algorithm.ProgressMonitor;
/*  18:    */ import org.cishell.framework.algorithm.ProgressTrackable;
/*  19:    */ import org.cishell.framework.data.BasicData;
/*  20:    */ import org.cishell.framework.data.Data;
/*  21:    */ import org.osgi.service.log.LogService;

/*  22:    */ import prefuse.data.Graph;
import prefuse.data.Node;
/*  23:    */ import prefuse.data.Table;
import stemmer.PorterAlgo;
/*  24:    */ 
/*  25:    */ public class ExtractAlgorithm
/*  26:    */   implements Algorithm, SupportedFileTypes, ProgressTrackable
/*  27:    */ {
/*  28:    */   Data[] data;
/*  29:    */   Dictionary parameters;
/*  30:    */   CIShellContext ciContext;
/*  31:    */   LogService logger;
/*  32:    */   ProgressMonitor progressMonitor;
/*  33:    */   
/*  34:    */   public ProgressMonitor getProgressMonitor()
/*  35:    */   {
/*  36: 36 */     return this.progressMonitor;
/*  37:    */   }
/*  38:    */   
/*  39:    */   public void setProgressMonitor(ProgressMonitor monitor)
/*  40:    */   {
/*  41: 40 */     this.progressMonitor = monitor;
/*  42:    */   }
/*  43:    */   
/*  44:    */   public ExtractAlgorithm(Data[] dm, Dictionary parameters, CIShellContext cContext)
/*  45:    */   {
/*  46: 46 */     this.data = dm;
/*  47: 47 */     this.parameters = parameters;
/*  48: 48 */     this.ciContext = cContext;
/*  49: 49 */     this.logger = ((LogService)this.ciContext.getService(LogService.class.getName()));
/*  50:    */   }
/*  51:    */   
/*  52:    */   public Data[] execute()
/*  53:    */     throws AlgorithmExecutionException
/*  54:    */   {
/*  55: 53 */     Table dataTable = (Table)this.data[0]
/*  56: 54 */       .getData();
/*  57:    */     
/*  58:    */ 
/*  59: 57 */     String fileFormat = this.parameters.get("fileFormat").toString();
/*  60: 58 */     String fileFormatPropertiesFile = getFileTypeProperties(fileFormat);
/*  61:    */     
/*  62: 60 */     ClassLoader loader = getClass().getClassLoader();
/*  63: 61 */     InputStream fileTypePropertiesFile = loader
/*  64: 62 */       .getResourceAsStream(fileFormatPropertiesFile);
/*  65:    */     
/*  66: 64 */     Properties metaData = new Properties();
/*  67:    */     try
/*  68:    */     {
/*  69: 66 */       metaData.load(fileTypePropertiesFile);
/*  70:    */     }
/*  71:    */     catch (FileNotFoundException fnfe)
/*  72:    */     {
/*  73: 68 */       this.logger.log(1, fnfe.getMessage(), fnfe);
/*  74:    */     }
/*  75:    */     catch (IOException ie)
/*  76:    */     {
/*  77: 70 */       this.logger.log(1, ie.getMessage(), ie);
/*  78:    */     }
/*  79:    */     try
/*  80:    */     {
					int step = 1;
					this.logger.log(1,"Doing Bieber Method");
/*  81: 73 */       String authorColumn = SupportedFileTypes.CitationFormat.getAuthorColumnByName(fileFormat);
/*  82: 74 */       GraphContainer gc = GraphContainer.initializeGraph(dataTable, authorColumn, authorColumn, false, metaData, this.logger, this.progressMonitor);
					Graph outputGraph = gc.buildGraph(authorColumn, authorColumn, "|", false, this.logger);
					outputGraph.addColumn("indexids", String.class);
					outputGraph.addColumn("focusterms", String.class);
					outputGraph.addColumn("mainjournal", String.class);

				/*	this.logger.log(1,outputGraph.getNode(2).toString());
					this.logger.log(1,outputGraph.getNode(2).getColumnName(0));
					this.logger.log(1,outputGraph.getNode(2).getColumnName(1));
					this.logger.log(1,outputGraph.getNode(2).getColumnName(2));
					this.logger.log(1,outputGraph.getNode(2).getColumnName(3));*/
					int erorcount = 0;
					for (int i = 0; i < outputGraph.getNodeCount()-1; i++){
						try{
							String authorcheck =  outputGraph.getNode(i).getString("label");
							
							String reso = "";
							String termreso = "";
							ArrayList<String> journals = new ArrayList<String>();
							for (int j = 0; j < dataTable.getRowCount()-1; j++){
								String authorrow = dataTable.getString(j, 1);
								if (authorrow.toLowerCase().contains(authorcheck.toLowerCase())){
									if (reso.length() <= 0){
										reso = 	dataTable.getString(j, 0);
										
									}
									else {
										reso = reso+","+dataTable.getString(j, 0);
										
									}
									
									
									termreso = termreso + " " + dataTable.getString(j, 15);
									journals.add(dataTable.getString(j, 4));
									
								}
								
							}

							outputGraph.getNode(i).setString("indexids", reso);
							outputGraph.getNode(i).setString("focusterms", getTerms(termreso));
							outputGraph.getNode(i).setString("mainjournal", journals.get(0));
							 
						}
						catch (IndexOutOfBoundsException ex ){
							erorcount++;
						}
						
					}
					this.logger.log(1, "errorfound: "+Integer.toString(erorcount));
					
					/*this.logger.log(1,outputGraph.getNode(2).toString());
					this.logger.log(1,outputGraph.getNode(2).getColumnName(0));
					this.logger.log(1,outputGraph.getNode(2).getColumnName(1));
					this.logger.log(1,outputGraph.getNode(2).getColumnName(2));*/
					
					Data outputData1 = new BasicData(outputGraph,  Graph.class.getName());
					Dictionary graphAttributes = outputData1.getMetadata();
					graphAttributes.put("Modified", new Boolean(true));	
					graphAttributes.put("Parent", this.data[0]);
					graphAttributes.put("Type", "Network");	
					graphAttributes.put("Label",  "Bieber Extracted Co-Authorship Network");
/*  95: 87 */       Table outputTable = ExtractNetworkFromTable.constructTable(outputGraph);
/*  97: 89 */       Data outputData2 = new BasicData(outputTable,  Table.class.getName());
/* 100: 92 */       Dictionary tableAttributes = outputData2.getMetadata();
/* 101: 93 */       tableAttributes.put("Modified", new Boolean(true));
/* 102: 94 */       tableAttributes.put("Parent", this.data[0]);
/* 103: 95 */       tableAttributes.put("Type", "Matrix");
/* 104: 96 */       tableAttributes.put("Label", "Bieber Author information");
/* 106: 98 */       return new Data[] { outputData1, outputData2 };
/* 107:    */     }
/* 108:    */     catch (InvalidColumnNameException ex)
/* 109:    */     {
						JOptionPane.showMessageDialog(null, "ERROR 1");
/* 110:100 */       throw new AlgorithmExecutionException(ex.getMessage(), ex);
/* 111:    */     }
/* 112:    */     catch (GraphContainer.PropertyParsingException e)
/* 113:    */     {
					JOptionPane.showMessageDialog(null, "ERROR 2");
/* 114:102 */       throw new AlgorithmExecutionException(e);
/* 115:    */     }
/* 116:    */   }

public String getTerms(String filetext){
	String retoString = "";
	filetext = fixText(filetext.toLowerCase());

	 StringTokenizer strtoken = new StringTokenizer(filetext);
     ArrayList<String> filetoken = new ArrayList<String>();
     while(strtoken.hasMoreElements()){
         filetoken.add(strtoken.nextToken());
     }
     
     
     ArrayList<String> split = completeStem(filetoken);
	
	
	
	Map<String, Integer> counts = new HashMap<String,Integer>();
    for(int i=0; i<split.size()-1; i++){
        String phrase = split.get(i);
        Integer count = counts.get(phrase);
        if(count==null){
            counts.put(phrase, 1);
        } else {
            counts.put(phrase, count+1);
        }
    }

    Map.Entry<String,Integer>[] entries = counts.entrySet().toArray(new Map.Entry[0]);
    Arrays.sort(entries, new Comparator<Map.Entry<String, Integer>>() {
        public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
            return o2.getValue().compareTo(o1.getValue());
        }
    });
    int rank=1;
    int termcount = 0;
    System.out.println("Rank Freq Phrase");
    for(Map.Entry<String,Integer> entry:entries){
        int count = entry.getValue();
        if(count>1){
           // System.out.printf("%4d %4d %s\n", rank++, count,entry.getKey());
            
            if (termcount < 100){
            	if (retoString.length() <= 0){
            		retoString = entry.getKey();
            	}
            	else {
            		retoString = retoString + " | " + entry.getKey();
            	}
            	
            //	 termArray[termcount]=entry.getKey();
                 termcount++;
            }
           
            
        }
    }
	return retoString;

}
public static ArrayList<String> completeStem(List<String> tokens1){
    PorterAlgo pa = new PorterAlgo();
    ArrayList<String> arrstr = new ArrayList<String>();
    for (String i : tokens1){
    	if (i.length() > 1){
            String s1 = pa.step1(i);
            String s2 = pa.step2(s1);
            String s3= pa.step3(s2);
            String s4= pa.step4(s3);
            String s5= pa.step5(s4);
            
            if ((s5.length() > 3)&&(isStopWord(s5) == false)){
            	arrstr.add(s5);
            }
    	}
      
    }
    return arrstr;
}


public static String fixText(String s){
	
	String pattern = "\r";
	s = s.replaceAll(pattern, " ");
	pattern = "\n";
	s = s.replaceAll(pattern, " ");
	pattern = ";";
	s = s.replaceAll(pattern, " ");
	pattern = ",";
	s = s.replaceAll(pattern, " ");
	pattern = "\\]";
	s = s.replaceAll(pattern, " ");
	pattern = "\\[";
	s = s.replaceAll(pattern, " ");
	pattern = ">";
	s = s.replaceAll(pattern, " ");
	pattern = "<";
	s = s.replaceAll(pattern, " ");
	pattern = "/";
	s = s.replaceAll(pattern, " ");
	pattern = "'s";
	s = s.replaceAll(pattern, " ");
	pattern = "'";
	s = s.replaceAll(pattern, " ");
	pattern = ":";
	s = s.replaceAll(pattern, " ");
	pattern = "&nbsp;";
	s = s.replaceAll(pattern, " ");
	pattern = "-";
	s = s.replaceAll(pattern, " ");
	pattern = "/n";
	s = s.replaceAll(pattern, " ");
	pattern = "\r";
	s = s.replaceAll(pattern, " ");
	pattern = "\\.";
	s = s.replaceAll(pattern, " ");
	pattern = "\\?";
	s = s.replaceAll(pattern, " ");
	pattern = "\\)";
	s = s.replaceAll(pattern, " ");
	pattern = "\\(";
	s = s.replaceAll(pattern, " ");
	pattern = "Monday";
	s = s.replaceAll(pattern, " ");
	s = s.replaceAll("[-+.^:,]"," ");
	s = s.replaceAll("[\\-\\+\\.\\^:,]"," ");
	
	s = s.replaceAll("[^\\x20-\\x7e]", " ");
	
	
	s = s.replaceAll("^ +| +$|( )+", "$1");

	return s;
}

public static Boolean isStopWord(String s){
	 String[] stopwords = {"a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost",
	            "alone", "along", "already", "also", "although", "always", "am", "among", "amongst", "amoungst", "amount", "an", "and",
	            "another", "any", "anyhow", "anyone", "anything", "anyway", "anywhere", "are", "around", "as", "at", "back", "be", "became",
	            "because", "become", "becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides",
	            "between", "beyond", "bill", "both", "bottom", "but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt",
	            "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven", "else",
	            "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few",
	            "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from",
	            "front", "full", "further", "get", "give", "go", "had", "has", "hasnt",
	            "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself",
	            "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into",
	            "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many",
	            "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must",
	            "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none",
	            "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto",
	            "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own", "part", "per", "perhaps",
	            "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she",
	            "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something",
	            "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their",
	            "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon",
	            "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru",
	            "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until",
	            "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever",
	            "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while",
	            "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet",
	            "you", "your", "yours", "yourself", "yourselves", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "1.", "2.", "3.", "4.", "5.", "6.", "11",
	            "7.", "8.", "9.", "12", "13", "14", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
	            "terms", "CONDITIONS", "conditions", "values", "interested.", "care", "sure", ".", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "{", "}", "[", "]", ":", ";", ",", "<", ".", ">", "/", "?", "_", "-", "+", "=",
	            "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	            "contact", "grounds", "buyers", "tried", "said,", "plan", "value", "principle.", "forces", "sent:", "is,", "was", "like",
	            "discussion", "tmus", "diffrent.", "layout", "area.", "thanks", "thankyou", "hello", "bye", "rise", "fell", "fall", "psqft.", "http://", "km", "miles"};
	
	 for (int i = 0; i < stopwords.length; i++){
		 if (s.compareTo(stopwords[i].toLowerCase()) == 0){
			 return true;
		 }
	 }
	 
	 
	 return false;
}

/* 117:    */   
/* 118:    */   private String getFileTypeProperties(String fileType)
/* 119:    */   {
/* 120:107 */     String propertiesFileName = "/edu/iu/nwb/analysis/extractcoauthorship/metadata/";
/* 121:    */     
/* 122:109 */     return propertiesFileName + fileType + ".properties";
/* 123:    */   }
/* 124:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractcoauthorship_1.0.1.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractcoauthorship.algorithms.ExtractAlgorithm
 * JD-Core Version:    0.7.0.1
 */