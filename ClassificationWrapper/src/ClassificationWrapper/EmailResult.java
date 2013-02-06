package ClassificationWrapper;

import java.io.File;
import java.io.FileInputStream;
import java.util.Date;
import java.util.Iterator;
import java.util.Set;

import org.apache.james.mime4j.parser.MimeStreamParser;
import org.apache.james.mime4j.stream.MimeConfig;

import com.aliasi.chunk.Chunk;
import com.aliasi.chunk.Chunking;
import com.aliasi.classify.Classification;
import com.aliasi.classify.Classified;
import com.aliasi.classify.ConfusionMatrix;
import com.aliasi.classify.JointClassification;
import com.aliasi.classify.JointClassifier;
import com.aliasi.classify.JointClassifierEvaluator;
import com.aliasi.sentences.MedlineSentenceModel;
import com.aliasi.sentences.SentenceChunker;
import com.aliasi.sentences.SentenceModel;
import com.aliasi.tokenizer.IndoEuropeanTokenizerFactory;
import com.aliasi.tokenizer.TokenizerFactory;
import com.aliasi.util.AbstractExternalizable;
import com.aliasi.util.Files;

public class EmailResult
{
	
	// These are Factory/utility objects, so they can be static
	static TokenizerFactory tokenizerFactory = IndoEuropeanTokenizerFactory.INSTANCE;
	static SentenceModel sentenceModel = new MedlineSentenceModel();
	static SentenceChunker sentenceChunker = new SentenceChunker(tokenizerFactory, sentenceModel);
	
	EmailContentHandler handler;
	File email;
	String emailBody = "";
	int excitementLevel = 0;
	
	public EmailResult(String filePath) 
	{
		email = new File(filePath);
		
		handler = new EmailContentHandler();
		
		MimeConfig m = new MimeConfig();
		m.setMaxLineLen(Integer.MAX_VALUE);
		m.setMaxHeaderLen(Integer.MAX_VALUE);
		
		MimeStreamParser parser = new MimeStreamParser(m);
		parser.setContentHandler(handler);
		try
		{
			parser.parse(new FileInputStream(email));	// Handler functions will be called here
		}
		catch(Exception e)
		{
			System.out.println("Exception while parsing: " + e.toString());
		}
		// Handler is now ready to be queried
		//System.out.println("********Getting Sentences***********");
		String body = handler.getBody();
		AssignPoints(body);
	}
	
	private void AssignPoints(String input)
	{
		Chunking chunking = sentenceChunker.chunk(input.toCharArray(),0,input.length());
		Set<Chunk> sentences = chunking.chunkSet();
		if(sentences.size() < 1)
		{
			//System.out.println("No sentences found");
			return;
		}
		String slice = chunking.charSequence().toString();
		int i = 1;
		for(Iterator<Chunk> it = sentences.iterator(); it.hasNext();)
		{
			Chunk sentence = it.next();
			
		    int start = sentence.start();
		    int end = sentence.end();
		    //System.out.println("Sentence " + (i++) + ":");
		    //System.out.println(slice.substring(start,end));
		    String current = slice.substring(start, end);
		    
		    // Here we make sure we're not including an old message
		    String[] messageSplit = current.split("-----Original Message-----");
		    if(messageSplit.length == 0)
		    {
		    	break;
		    }
		    else if(messageSplit[0].length() == 0)
		    {
		    	break;
		    }
		    current = messageSplit[0];
	    	emailBody += current;
	    	//System.out.println("Current chunk: " + i);
	    	//System.out.println(current);
	    	excitementLevel += checkForExcitement(current);
		    if(messageSplit.length > 1)	// There was an older message included
		    {
		    	break;
		    }
		    i++;
		}

		excitementLevel += checkForExcitement(getSubject());	// Also check the subject line
		
    	//System.out.println("Current excitement level: " + excitementLevel);
	}
	
	private int checkForExcitement(String sentence)
	{
		int ret = 0;
		if(sentence.contains("!"))
		{
			ret++;
		}
		String[] caps= sentence.split("\\b[A-Z]{3,}\\b");
		if(caps.length > 1)
		{
			//System.out.println("Got " + caps.length + " caps");
			ret++;	// 1 point per sentence, regardless of how many caps
		}
		else
		{
			//System.out.println("No caps found");
		}
		return ret;
	}
	
	public int getExcitementLevel()
	{
		return excitementLevel;
	}
	
	public String getBody()
	{
		return handler.getBody();
	}
	
	public String[] getFrom()
	{
		return handler.getFrom();
	}
	
	public String[] getTo()
	{
		return handler.getTo();
	}
	
	public String getSubject()
	{
		return handler.getSubject();
	}
	
	public boolean IsReply()
	{
		return handler.IsReply();
	}
	
	public Date getDate()
	{
		return handler.getDate();
	}
	
	public int getDay()
	{
		return handler.getDate().getDate();
	}
	
	public int getHour()
	{
		return handler.getDate().getHours() + 1;
	}
	
	public int getMonth()
	{
		return handler.getDate().getMonth() + 1;
	}
	
	public int getYear()
	{
		int year = handler.getDate().getYear() + 1900;
		return year;
	}
	
	public String getDateTime()
	{
		String s ="";
		Date d = handler.getDate();
		s += (getHour() % 12) + ":" + d.getMinutes() + ":" + d.getSeconds();
		return s;
	}
	
	// Do this so we can package as a runnable .jar
	public static void main(String[] args)
	{
		// Will only be used to debug, the below line should be commented in production code
		//EmailResult r = new EmailResult("<Email here>");
	}

}
