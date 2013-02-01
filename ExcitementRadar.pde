boolean isPaused;
boolean isSubmenuOpen;
View[] views; //0: daily, 1: monthly, 2: yearly
int curView;
int curFrame;
int dotx,doty, radius;



void setup() {
  size(1200, 800);     
  isPaused = false;
  isSubmenuOpen = false;
  curFrame = 0;
  dotx = doty = 400;
  radius = 300;
  views = new View[3];
  views[0] = new View("Daily View", 24); 
  views[1] = new View("Monthly View", 30); // month may be tricky due to uneven number of days 
  views[2] = new View("Yearly View", 12);
  curView = 2; // Default is yearly view.
  frameRate(60);
  // Default frame rate is 60;
  // Do we want to update info twice a second?
  // We should update animation even if we're not updating info
  
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
  
  // Update only two times per second, ie, if frame is 30 or 60...
  boolean doUpdate;
  doUpdate = (frameCount % 30) == 0;
  
  
  if(doUpdate)
  {
      updateAnimation();
    
    if(!isPaused)
    {
      // Update default changes  
      updateDefaultChanges();  
      
      // Update new information
      updateNewInfo();
      
      // Redraws main view
      redrawMainView();
      
      // Update submenu if open
      if(isSubmenuOpen)
      {
         updateSubMenu(); 
      }
      
      // Is there a click? If yes, Respond to it
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
  
  // Any other static items? Like buttons go here.
 
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
   float angle = (time % total_time) * TWO_PI / total_time + frameCount%30 * (1 % total_time) * TWO_PI / total_time / 30;
   
  //println("angle: " + angle);
  
  stroke(#00EE00);
  strokeWeight(2);
  line(dotx,doty,dotx + radius*sin(angle), doty -  radius * cos(angle));
 
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
