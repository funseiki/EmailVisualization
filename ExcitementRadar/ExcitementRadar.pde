// NOTE: You need to copy  ControlP5 into your local Processing>libraries folder
// I put it in our Google Drive
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

// Program Variables
View[] views; //0: daily, 1: monthly, 2: yearly
int curView; // ptr to current view (0: daily, 1: monthly, 2: yearly)
PImage backImg, backImgOn, forwardImg, forwardImgOn, playImg, pauseImg; //load the images in only one time to avoid out of memory error
PFont g_font;
int angle_count;
HashMap g_balls;
ArrayList<Email> g_emails;
ArrayList<Email> g_newEmails;
Ball g_subMenuBall;

int g_yearStart, g_monthStart, g_dayStart, curEmailPtr; // points to current email in arraylist for efficiency

// State Configurations
boolean isPaused; // State control (whether it's paused or not)
//boolean isForward; // State control (whether the time moves forward or backwards) // Let's not implement this cos it's troublesome
boolean isSubmenuOpen;


// XY Configurations
int dotx,doty, radius; // Center dot for radar
int sub_rectx; // Frame of sub menu
int sub_recty;
int play_btnx, play_btny;
int back_btnx, back_btny;
int forward_btnx, forward_btny;

void setup() {
  size(1300, 800);     
  // Configure State Defaults
  isPaused = false;
  //isForward = true;
  isSubmenuOpen = true;
  
  angle_count = 0;
  
  // Configure XY Defaults
  dotx = doty = 400;
  sub_rectx = 750;
  sub_recty = 100;
  radius = 300;
  play_btnx = 370;
  play_btny = 730;
  back_btnx = play_btnx - 100;
  back_btny = play_btny;
  forward_btnx = play_btnx + 100;
  forward_btny = play_btny;  
  
  // Initialize Variables
  views = new View[3];
  views[0] = new View("Daily View", 24); 
  views[1] = new View("Monthly View", 30); // month may be tricky due to uneven number of days 
  views[2] = new View("Yearly View", 12);
  curView = 2; // Default is yearly view.
  frameRate(60);
  // Default frame rate is 60;
  // Do we want to update info twice a second?
  // We should update animation even if we're not updating info
  
  backImg = loadImage("back.png");
  backImgOn = loadImage("back_on.png");
  forwardImg = loadImage("forward.png");
  forwardImgOn= loadImage("forward_on.png");
  playImg = loadImage("play.png");
  pauseImg = loadImage("pause.png");
  
  g_font = createFont("Arial",16,true);
  
   g_yearStart = 2012;
   g_monthStart = 1 ;
   g_dayStart = 1;
   curEmailPtr = 0;
  g_balls = new HashMap();
  g_emails = new ArrayList();
  g_newEmails = new ArrayList<Email>();
  g_subMenuBall = null;
  // Load data into g_emails (assumed already sorted by time)
  // CSV: thread_id, year, month, day, hour, excitement_level, sender, subject, body, datetime, keyword;
   // Hardcode for now 
   Email e1 = new Email(1, 2012, 1, 2, 3, 2, "Mary", "1 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e1);
   Email e2 = new Email(2, 2012, 1, 2, 3, 2, "Mary", "2 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e2);
   Email e3 = new Email(3, 2012, 4, 2, 3, 2, "Mary", "3 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e3);
   Email e4 = new Email(1, 2012, 5, 2, 3, 2, "Mary", "4 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e4);
   Email e5 = new Email(2, 2012, 6, 2, 3, 2, "Mary", "5 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e5);
   Email e6 = new Email(3, 2012, 7, 2, 3, 2, "Mary", "6 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e6);
   Email e7 = new Email(3, 2012, 8, 2, 3, 2, "Mary", "7 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e7);
   Email e8 = new Email(3, 2012, 9, 2, 3, 2, "Mary", "8 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e8);
   Email e9 = new Email(3, 2012, 10, 2, 3, 2, "Mary", "9 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e9);
   Email e10 = new Email(3, 2012, 11, 2, 3, 2, "Mary", "10 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e10);
   Email e11 = new Email(3, 2012, 12, 2, 3, 2, "Mary", "11 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e11);
   Email e12 = new Email(4, 2013, 1, 2, 3, 2, "Mary", "12 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e12);
   Email e13 = new Email(3, 2013, 1, 2, 3, 2, "Mary", "13 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e13);
   Email e14 = new Email(1, 2013, 1, 2, 3, 2, "Mary", "14 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e14);
   Email e15 = new Email(1, 2013, 2, 2, 3, 2, "Mary", "15 Giving a lamb shower", "great body", "02-02-2012", "Ooops!");
   g_emails.add(e15);
}


void draw() {
  
  
  /*
    -- create static background
    If not paused
    {
       Update default changes for all
      Get new changes. 
      update element based on each new change.
      If submenu is open, maybe update submenu?
    }
    else // if paused
    {
      Do not update anything.
    }
    
    If there's a click on:
    {
      1) A circle: launch sub menu
      2) Pause: Pause the visualizer
      3) Dismiss Submenu : Close Sub menu   
    }
  */
  
  // Set static items
  setBackground();
  
  
  if(!isPaused)
  {
     angle_count++; 
  }
  
  
  // Update only two times per second, ie, if frame is 30 or 60...
  boolean doUpdate;
  doUpdate = (angle_count % 30) == 0;
  
  if(doUpdate)
  {
      updateAnimation();
    
    if(!isPaused)
    {
      // Update default changes  
      updateDefaultChanges();  
      
      // Update new information
      updateNewInfo();
      
    }
    
    // Redraws main view
      redrawMainView();
      
      // Update submenu if open
      if(isSubmenuOpen)
      {
         updateSubMenu(); 
      }
  }
  else
  {
    // update animation and redraw main view
    updateAnimation();
    redrawMainView();
    // Update submenu if open
      if(isSubmenuOpen)
      {
         updateSubMenu(); 
      }
  }
  
  
  
   
}

void setBackground()
{
  background(0);
  // Draw main view
  
  
  // radar
  stroke(#00EE00);
  strokeWeight(3);
  fill(0);
  ellipse(dotx,doty,600,600);
 
 
  // Create Sub menu Frame
  stroke(#00EE00);
  strokeWeight(3);
  fill(0);
  rect(sub_rectx,sub_recty,400,600, 7);
  
  // Draw visualization title
  fill(#00EE00);
  textFont(g_font, 20);
 textAlign(LEFT);
  text("Excitement Radar", 30,775); 
  
  // Any other static items? Like static buttons (appearance doesn't change) go here.
 
}

// update default changes for each time unit
void updateDefaultChanges()
{
    // Update time
    views[curView].updateTime();
    
   // Update main view
   // Update all balls
   
    Iterator i = g_balls.entrySet().iterator();  // Get an iterator
    while (i.hasNext()) 
    {
      Map.Entry me = (Map.Entry)i.next();
      Ball b = (Ball) me.getValue();
      b.update();  
    }
    
     
}

// Updates backend with new information based on current time
void updateNewInfo()
{
   // Get email for this time period and update accordingly   
   
   ArrayList e = getNewEmails();
   //println("Size of new emails: " + e.size());
   // We've got the new emails for this time period. Add it in. 
   // But we should stagger it out into sub frames.
   // Add emails to existing balls or create new balls
   g_newEmails = null;
   g_newEmails = e;
   staggerEmail();
    
}

void staggerEmail()
{
  if(g_newEmails.size() == 0)
    return;
    
    int curSubFrame = angle_count%30;
    // Find total number of new emails
    // Update only total / 30 each time
    int eachUpdate = g_newEmails.size() / 30;
    if(eachUpdate == 0)
      eachUpdate = 1;
      // TODO: Note: this stagger will update all remaining at the end, and doesn't stagger the modulus
      // E.g.: if there's 40, it'll update 1 per frame and 11 at frame 29.
    if(angle_count != 29)
    {
      // update only a subset
      int count = 0;
      int i;
      for (i =curSubFrame * eachUpdate ; i< g_newEmails.size() && count < eachUpdate; i++)
     {
       Email e_id = (Email) g_newEmails.get(i);
       int id = e_id.getThreadId();
       println("adding email: "+ i + " id: "+ id + " Subject: " + e_id.getSubject());
       addEmailToBall((Email) g_newEmails.get(i));
       count++;
     }  
     if(i >= g_newEmails.size())
       g_newEmails = new ArrayList<Email>();
    }
    else
    {
       // update all remaining
      int i;
      for (i =curSubFrame * eachUpdate; i< g_newEmails.size() ; i++)
     {
       Email e_id = (Email) g_newEmails.get(i);
       int id = e_id.getThreadId();
       println("29: adding email: "+ i + " id: "+ id + " Subject: " + e_id.getSubject());
       addEmailToBall((Email) g_newEmails.get(i));
       
     } 
     if(i >= g_newEmails.size())
       g_newEmails = new ArrayList<Email>();
    }
    
}

void addEmailToBall(Email e)
{
  // Check if this email is in a ball
  // If yes, add to that ball
  // If no, create new ball and add to g_balls
  if(g_balls.get(e.getThreadId()) != null)
  {
      // Add to this ball
      Ball b = (Ball) g_balls.get(e.getThreadId());
      b.addEmail(e);
  }
  else
  {
     // Create new ball 
     int id = e.getThreadId();
     Ball b = new Ball(getCurrentAngle(), id);
     b.addEmail(e);
     g_balls.put(id, b);
     
  }
    
    
    
}

ArrayList getNewEmails()
{
   // How to translate current time to months from start?
   // TODO: We'll do for year first
   ArrayList result = new ArrayList();
   int time = views[curView].getTime();
   int this_time = g_yearStart * 12 + time; // TODO: year view only. need to do for other views 
   //int years_passed = time / 12;
   //int cur_year = g_yearStart + years_passed;
   //int cur_month = time % 12 +1; // Jan starts at 1
   
   // Get emails from current year and time
   // What's an efficient way to get emails? use curEmailPtr
   // Check if the next email is in this year / month
   // If later than this time, then return empty list, else progress pointer and return list
   
   int failsafe = 0; // just in case we get into an endless loop for some reason
   // Assume we dont have 1200 emails each time period
   while(failsafe < 1200)
   {
      if(curEmailPtr >= g_emails.size())
        return result;
        
      Email e = (Email) g_emails.get(curEmailPtr);
      int e_time = e.getYear() * 12 + e.getMonth();
      //println("e_time: " + e_time + " time: " + this_time);
      if(e_time > this_time)
         return result;
      if(e_time == this_time)
     {
       //println("Adding email");
        result.add(e);
        curEmailPtr++;
     } 
     failsafe++;
   }
   return result;
}

float getCurrentAngle()
{
    int time = views[curView].getTime();
    int total_time = views[curView].getUnitsPerRevolution();
    
    // We update info every 30 frames but animate dial every frame. 
    float angle;
    
    float last_angle = (time % total_time) * TWO_PI / total_time;
    float angle_diff =  angle_count%30  * TWO_PI / total_time / 30;
   float cur_angle = last_angle + angle_diff;
  return cur_angle; 
}

// Redraws the main view
void redrawMainView()
{
  // Redraw Dial
   int time = views[curView].getTime();
    int total_time = views[curView].getUnitsPerRevolution();
   float cur_angle = getCurrentAngle(); 
    /*
    if(isPaused)
    {
      // Go to last-known time.
      angle = last_angle;    
    }
    else
    {*/
      // Add intermediate frames
      float angle = cur_angle;
    //}
    
    
  // There's an angle diff, create the residue of the sweep, ie a white arc with transparency
  // Arc : last angle to current angle
  fill(#ffffff, 120);
  arc(dotx,doty, radius*2, radius*2, -HALF_PI, cur_angle- HALF_PI, PIE);
    
  //println("angle: " + angle);
  
  stroke(#00EE00);
  strokeWeight(2);
  fill(#00EE00);
  //line(dotx,doty,dotx + radius*sin(angle), doty -  radius * cos(angle));
   // draw time text at end of dial
   textFont(g_font, 14);
   
   text(time % total_time + 1, dotx + (radius+15)*sin(angle), doty -  (radius+15) * cos(angle) );   
   
   // Redraw Time control buttons
   /*
     1) Play/Pause
     2) Forward/Backword
   */
   
   if(isPaused)
   {
      // Set play action
      image(playImg, play_btnx, play_btny);
   }
   else
   {
       // Set pause action
      image(pauseImg, play_btnx, play_btny);
   }
  // if(isForward)
    // println("isForward: " + isForward);
   /*if(isForward)
   {
     // Set forward on, back off
      image(backImg, back_btnx, back_btny);
      image(forwardImgOn, forward_btnx, forward_btny);
   }
   else
   {
     // Set forward off, back on
      image(backImgOn, back_btnx, back_btny);
      image(forwardImg, forward_btnx, forward_btny);
   }*/
   
   // Redraw current DateTime.
   // TODO: works for Years only
   
   int years_passed = time / 12;
   int cur_year = g_yearStart + years_passed;
   int cur_month = time % 12 +1; // Jan starts at 1
   setTitle(getMonthOfYear(cur_month) + ", " + cur_year); 
   
   // Redraw all balls
   
    Iterator i = g_balls.entrySet().iterator();  // Get an iterator
    while (i.hasNext()) 
    {
      Map.Entry me = (Map.Entry)i.next();
      Ball b = (Ball)me.getValue();
      b.drawMe();  
    }
}

String getMonthOfYear(int i)
{
  switch(i)
  {
     case 1: 
        return "January";
     case 2:
       return "February";
     case 3:
       return "March";
     case 4:
       return "April";
     case 5:
       return "May";
     case 6:
       return "June";
     case 7:
       return "July";
     case 8:
       return "August";
     case 9:
       return "September";
     case 10:
       return "October";
     case 11:
       return "November";
     case 12:
       return "December";
     default:
     return "";  
  }  
}
void mouseClicked()
{
 
   // Checks if play, back, forward button is pressed
    
      
      // Check play
      if(mouseX>play_btnx && mouseX < play_btnx+58 && mouseY>play_btny && mouseY <play_btny+58){
       println("The mouse is pressed and over the play button");
       isPaused = !isPaused;
      
       //do stuff 
      }
      // Check each ball if it's clicked
      else 
      {
        println("mouse clicked");
         Iterator i = g_balls.entrySet().iterator();  // Get an iterator
        while (i.hasNext()) 
        {
          Map.Entry me = (Map.Entry)i.next();
          Ball b = (Ball) me.getValue();
          int b_x = b.getX();
          int b_y = b.getY();
          int b_radius = b.getDiameter() / 2 - 3; // Force users to click more to the center for more accuracy
          if(mouseX>b_x - b_radius && mouseX < b_x + b_radius && mouseY>b_y - b_radius && mouseY < b_y + b_radius){
            if(g_subMenuBall != null)
              g_subMenuBall.deselect(); 
            g_subMenuBall = b;
            b.select();
            break; // Only 1 ball is to be clicked each time
             //do stuff 
          }
        }   
      }
      /*
      else if(mouseX>back_btnx && mouseX < back_btnx+58 && mouseY>back_btny && mouseY <back_btny+58) // check back
      {
        isForward = false;
      
        //println("The mouse is pressed and over the  back button");
      }
      else if(mouseX>forward_btnx && mouseX < forward_btnx+58 && mouseY>forward_btny && mouseY <forward_btny+58) // check forward
      {
        isForward = true;
      
        //println("The mouse is pressed and over the forward button");
      }*/
      
 
      if(isPaused)
   {
      // Set play action
      image(playImg, play_btnx, play_btny);
   }
   else
   {
       // Set pause action
      image(pauseImg, play_btnx, play_btny);
   }
   /*
   if(isForward)
   {
     // Set forward on, back off
      image(backImg, back_btnx, back_btny);
      image(forwardImgOn, forward_btnx, forward_btny);
   }
   else
   {
     // Set forward off, back on
      image(backImgOn, back_btnx, back_btny);
      image(forwardImg, forward_btnx, forward_btny);
   }*/
        
      
    
}




// Updates and redraws sub menu
void updateSubMenu()
{
  //println("update submenu");
   // Redraw current sub menu
   if (g_subMenuBall == null)
     return;
  //println("update submenu -- got ball"); 
   // TODO: Igoring excitement meter for now and other stats for now.
   // Show: Each email (Sender, Date, Subject, Body)
   String text = g_subMenuBall.getEmailThread();
   
    fill(#00EE00);
    textFont(g_font, 12);
    textAlign(LEFT);
    // TODO: need to restrict width of text and do overflow
    // TODO: Bug: is Ball always adding duplicate Emails? // YES, need to fix duplicate addemail to ball
    text(text, 770,120, 360, 560);
   
}

// Updates any aninimation that is running
void updateAnimation()
{
  // Clear out all new emails for this period
  
  staggerEmail();
}





void setTitle(String text)
{
   fill(#00EE00);
  textFont(g_font, 32);
 textAlign(CENTER, BOTTOM);
  text(text, 650,60);      
}

class View
{
   int time,unitsPerRevolution;
   String title;
   boolean isStepForward;
   
   View(String mytitle, int myUnitsPerRevolution)
   {
      time=0;
     title = mytitle; 
     isStepForward = true;
     unitsPerRevolution = myUnitsPerRevolution;
   }
   void updateTime()
   {
      if(isStepForward)
     {
        time++;
     } 
     else
     {
       time--;
     }
   }
   
   int getTime()
   {
      return time; 
   }
   
   int getUnitsPerRevolution()
   {
      return unitsPerRevolution; 
   }
   
   String getTitle()
   {
      return title; 
   }
   
   void setTimeDirection(boolean isForward)
   {
     isStepForward = isForward;
   }
   
   boolean getTimeDirection()
   {
     return isStepForward;
   }
}

class Email
{
  // same id means the email is in the same thread
   int year, month, day, hour, thread_id, excitement_level;
   String sender, subject, body, datetime, keyword;
   
   Email(int id, int y, int m, int d, int h, int excitement_level, String this_sender, String this_subject, String this_body, String this_datetime, String keyword)
   {
     thread_id = id;
      year = y;
      month = m; 
      day = d;
      hour = h;
      this.excitement_level = excitement_level;
      sender = this_sender;
      subject = this_subject;
      body = this_body;
      datetime= this_datetime; 
      this.keyword = keyword;
   }
   int getYear()
   {
      return year; 
   }
   int getMonth()
   {
      return month; 
   }
   int getDay()
   {
      return day; 
   }
   int getHour()
   {
      return hour; 
   }
   int getThreadId()
   {
      return thread_id; 
   }
   int getExcitementLevel()
   {
      return excitement_level; 
   }
   String getSender()
   {
     return sender;
   }
   String getSubject()
   {
     return subject;
   }
   String getDatetime()
   {
     return datetime;
   }
   String getBody()
   {
     return body;
   }
   String getKeyword()
   {
      return keyword; 
   }
}

class Ball
{
  // This is an email thread on the radar.
  ArrayList<Email> emails;
  float angle;
  int x,y,diameter,heat_level, excitement_level, thread_id; // heat_level: (cold) 1-10 (hot)
  boolean isSelected;
  Ball(float angle, int thread_id)
  {
    this.angle = angle;
    this.heat_level = 3; // default
    this.excitement_level = 0;
    emails = new ArrayList();
    this.thread_id = thread_id;
    this.x = 0; // used for mouseclicks only
    this.y = 0; // used for mouseclicks only
    this.diameter = 0; // used for mouseclicks only
    this.isSelected = false;
  }
  void select()
  {
     this.isSelected = true; 
  }
  void deselect()
  {
     this.isSelected = false; 
  }
  int getSize()
  {
     // Returns the size based on total char number in email body  
     
     int size = 0;
     for(int i=0; i<this.emails.size(); i++)
     {
       Email e = (Email)this.emails.get(i);
       String body = e.getBody(); 
       size += body.length();
     }
     
     
     return size;
  }
  
  void update()
  {
      // decrease excitement
      this.excitement_level--;
      if(this.excitement_level < 0)
        this.excitement_level = 0;
      
      
      // decrement heat_level
      this.heat_level--;
      if(this.heat_level < 1)
        this.heat_level = 1;
  }
  
  void fillColor()
  {
    if(this.isSelected)
    {
        fill(0, 0, 255); // Change to blue if selected
        return;
    }
    switch(this.heat_level)
    {
       case 1:
          fill(255, 245, 0);          
          break;
       case 2:
          fill(255, 225, 0);      
          break;
       case 3:
          fill(255, 205, 0);      
          break;
       case 4:
          fill(255, 185, 0);      
          break;
       case 5:
          fill(255, 165, 0);
          break;
       case 6:
          fill(255, 145, 0);
          break;
       case 7:
          fill(255, 125, 0);
          break;
       case 8:
          fill(255, 105, 0);      
          break;
       case 9:
          fill(255, 125, 0);      
          break;
       case 10:
          fill(255, 115, 0);      
          break;   
       default:
           ;
    }
     
  }
  String getEmailThread()
  {
    // Want latest first
    String result = "";
     for( int i = this.emails.size() -1; i >= 0 ; i--)
     {
         Email e = this.emails.get(i);
         result += "Sender: " + e.getSender() + "\n";
         result += "Date: " + e.getDatetime()+ "\n";
         result += "Keywords: " + e.getKeyword() + "\n";
         result += "Subject: " + e.getSubject() + "\n";
         result +=  e.getBody() + "\n";
         result += "------------------------------------------------------------------------------------------\n";
     }
     return result;
  }
  void addEmail(Email e)
  {
     // increase excitement (x,y)
     emails.add(e);
     
     this.excitement_level += e.getExcitementLevel();
      if(this.excitement_level > 10)
        this.excitement_level = 10;
        
    // change heat
     this.heat_level += 3; // Increase by 3, but decrease by 1, so nett is 2. A nett 2 allows for more lag between emails
     if(this.heat_level >10)
      this.heat_level = 10; 
    
   
  }
  // doUpdate: true if we want to update, false if we just want to redraw
  void drawMe()
  {
    
    // Draws the ball on the radar (with x,y,angle, size, color)
    
     fillColor(); // sets the fill based on heat_level
     
     // Size of email thread
     int size = this.getSize();
     int downsize = size / 10; // upgrade one size only every 100 char // TODO: testing
     if(downsize <= 0)
       downsize = 1;
     int this_diameter = downsize * 20; // TODO: testing
     if (this_diameter > 100)
      this_diameter = 100; 
     
     
     // Draw angular displacement
     // excitement level = this.excitement_level;
    int this_radius = radius - this.excitement_level * 30; // Magnify the distance
    if(this_radius < 10)
      this_radius = 10; // minimum of 10 px for clarity
    
    int x = (int) Math.round( dotx + this_radius * sin(this.angle));
    int y = (int) Math.round(doty - this_radius * cos(this.angle));     
    
     // Draw the ball
     ellipse(x,y,this_diameter,this_diameter);
     
     this.x = x;
     this.y = y;
     this.diameter = this_diameter;
     // show keyword continuously for now
     textAlign(CENTER, CENTER);
     int textSize = downsize + 5; // min : 6
     if(textSize > 32)
       textSize = 32;
      fill(0);
     textFont(g_font, textSize);
     Email e = (Email) emails.get(emails.size() -1);
     String keyword = e.getKeyword();
     text(keyword, x, y, this_diameter);
     
      
  }
  int getX()
  {
     return this.x; 
  }
  int getY()
  {
     return this.y; 
  }
  int getDiameter()
  {
     return this.diameter; 
  }
}
