package ClassificationWrapper;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import org.apache.commons.io.IOUtils;
import org.apache.james.mime4j.MimeException;
import org.apache.james.mime4j.parser.ContentHandler;
import org.apache.james.mime4j.stream.BodyDescriptor;
import org.apache.james.mime4j.stream.Field;

public class EmailContentHandler implements ContentHandler {

	private String bodyContent;
	private String[] from, to;
	private String subject;
	private boolean isReply = false;
	private Date date;
	
	public EmailContentHandler() {
		// TODO Auto-generated constructor stub
	}
	
	public String getBody()
	{
		return bodyContent;
	}
	
	public String[] getFrom()
	{
		return from;
	}
	
	public String[] getTo()
	{
		return to;
	}
	
	public String getSubject()
	{
		return subject;
	}
	
	public boolean IsReply()
	{
		return isReply;
	}
	
	public Date getDate()
	{
		return date;
	}
	
	private void parseField(Field field)
	{
		String type = field.getName();
		if(type.contentEquals("Date"))
		{
			System.out.println("This is the date before parse: " + field.getBody());
			SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss");
			dateFormat.setTimeZone(TimeZone.getTimeZone("PST"));
			try
			{
				date = dateFormat.parse(field.getBody());
				System.out.println("Date after parse: " + date.toString());
			}
			catch(Exception e)
			{
				System.out.println("Exception parsing date: " + e.toString());
			}
		}
		else if(type.contentEquals("From"))
		{
			System.out.println("From is this: " + field.getBody());
			from = field.getBody().split(", ");
			for(int i = 0; i < from.length; i++)
			{
				System.out.println("from value[" + i + "]: " + from[i]);
			}
		}
		else if(type.contentEquals("To"))
		{
			System.out.println("To is this: " + field.getBody());
			to = field.getBody().split(", ");
			for(int i = 0; i < to.length; i++)
			{
				System.out.println("to value[" + i + "]: " + to[i]);
			}
		}
		else if(type.contentEquals("Subject"))
		{
			System.out.println("Subject is this: " + field.getBody());
			subject = field.getBody();
			String[] sp =  subject.split(": ");
			if(sp.length > 1 && sp[0].contentEquals("RE"))
			{
				subject = "";
				String colonAdd = "";	// Add back any removed colons in the subject
				isReply = true;
				System.out.println("This is a reply");
				for(int i = 0; i < sp.length; i++)
				{
					if(!sp[i].contentEquals("RE"))
					{
						subject += (colonAdd + sp[i]);
						colonAdd = ": ";
					}
				}
			}
			System.out.println("Here is the subject: " + subject);
		}
	}

	@Override
	public void body(BodyDescriptor arg0, InputStream arg1)
			throws MimeException, IOException {
		StringWriter w = new StringWriter();
		IOUtils.copy(arg1, w);
		String content = w.toString();
		//System.out.println("Here is the content: " + w + "\n and here is the body " + arg0);
		bodyContent = content;
	}

	@Override
	public void endBodyPart() throws MimeException {
		// TODO Auto-generated method stub

	}

	@Override
	public void endHeader() throws MimeException {
		// TODO Auto-generated method stub

	}

	@Override
	public void endMessage() throws MimeException {
		// TODO Auto-generated method stub

	}

	@Override
	public void endMultipart() throws MimeException {
		// TODO Auto-generated method stub

	}

	@Override
	public void epilogue(InputStream arg0) throws MimeException, IOException {
		// TODO Auto-generated method stub

	}

	@Override
	public void field(Field arg0) throws MimeException {
		parseField(arg0);
	}

	@Override
	public void preamble(InputStream arg0) throws MimeException, IOException {
		// TODO Auto-generated method stub

	}

	@Override
	public void raw(InputStream arg0) throws MimeException, IOException {
		// TODO Auto-generated method stub

	}

	@Override
	public void startBodyPart() throws MimeException {
		// TODO Auto-generated method stub

	}

	@Override
	public void startHeader() throws MimeException {
		// TODO Auto-generated method stub

	}

	@Override
	public void startMessage() throws MimeException {
		// TODO Auto-generated method stub

	}

	@Override
	public void startMultipart(BodyDescriptor arg0) throws MimeException {
		// TODO Auto-generated method stub

	}

}
