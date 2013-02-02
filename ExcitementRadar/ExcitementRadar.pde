// Program Variables
View[] views; //0: daily, 1: monthly, 2: yearly
int curView; // ptr to current view (0: daily, 1: monthly, 2: yearly)
PImage backImg, backImgOn, forwardImg, forwardImgOn, playImg, pauseImg; //load the images in only one time to avoid out of memory error
PFont g_font;
int angle_count;

// State Configurations
boolean isPaused; // State control (whether it's paused or not)
boolean isForward; // State control (whether the time moves forward or backwards)
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
  isForward = true;
  isSubmenuOpen = false;
  
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
  // Load data from file (Load into array?)
  
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
      
      
      
      // Is there a click? If yes, Respond to it
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
  
  
  setTitle("Year: 2012");
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
 
     
}

// Updates backend with new information based on current time
void updateNewInfo()
{
   // Get email for this time period and update accordingly   
}

// Redraws the main view
void redrawMainView()
{
  // Redraw Dial
    int time = views[curView].getTime();
    int total_time = views[curView].getUnitsPerRevolution();
    
    // We update info every 30 frames but animate dial every frame. 
    float angle;
    
    float last_angle = (time % total_time) * TWO_PI / total_time;
    float angle_diff =  angle_count%30 * (1 % total_time) * TWO_PI / total_time / 30;
   float cur_angle = last_angle + angle_diff; 
    /*
    if(isPaused)
    {
      // Go to last-known time.
      angle = last_angle;    
    }
    else
    {*/
      // Add intermediate frames
      angle = cur_angle;
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
   
   text(time % total_time, dotx + (radius+15)*sin(angle), doty -  (radius+15) * cos(angle) );   
   
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
   }
   
   
   // Redraw current DateTime.
   
   
   
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
      else if(mouseX>back_btnx && mouseX < back_btnx+58 && mouseY>back_btny && mouseY <back_btny+58) // check back
      {
        isForward = false;
      
        //println("The mouse is pressed and over the  back button");
      }
      else if(mouseX>forward_btnx && mouseX < forward_btnx+58 && mouseY>forward_btny && mouseY <forward_btny+58) // check forward
      {
        isForward = true;
      
        //println("The mouse is pressed and over the forward button");
      }
      
 
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
   }
        
      
    
}




// Updates and redraws sub menu
void updateSubMenu()
{
   // Redraw current sub menu
}

// Updates any aninimation that is running
void updateAnimation()
{
  
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
   int year, month, day, hour, thread_id;
   String sender, subject, body, datetime, keyword;
   
   Email(int id, int y, int m, int d, int h, String this_sender, String this_subject, String this_body, String this_datetime, String keyword)
   {
     thread_id = id;
      year = y;
      month = m; 
      day = d;
      hour = h;
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
  Email[] emails;
  float angle;
  int x,y;
  Ball(float angle, int x, int y)
  {
    this.angle = angle;
    this.x = x;
    this.y = y;
  }
  int getSize()
  {
     // Returns the size based on email excitement ( we should really look at content though)
     return 0;
  }
}
