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
