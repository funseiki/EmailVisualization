package ClassificationWrapper;

import java.io.File;
import java.io.FileInputStream;
import java.util.Date;

import org.apache.james.mime4j.parser.MimeStreamParser;
import org.apache.james.mime4j.stream.MimeConfig;

import com.aliasi.classify.Classification;
import com.aliasi.classify.Classified;
import com.aliasi.classify.ConfusionMatrix;
import com.aliasi.classify.JointClassification;
import com.aliasi.classify.JointClassifier;
import com.aliasi.classify.JointClassifierEvaluator;
import com.aliasi.util.AbstractExternalizable;
import com.aliasi.util.Files;

public class EmailResult
{	
	// Do this so we can package as a runnable .jar
	public static void main(String[] args)
	{
		// Will only be used to debug, the below line should be commented in production code
		//EmailResult r = new EmailResult("<Insert test email here>");
	}
	
	EmailContentHandler handler;
	File email;
	
	public EmailResult(String filePath) 
	{
		email = new File(filePath);
		
		handler = new EmailContentHandler();
		
		MimeConfig m = new MimeConfig();
		m.setMaxLineLen(Integer.MAX_VALUE);
		
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

}
