/*
@author NerdItYourself
@version 1.0, 2/3/2016
*/

// Import library used for Kinect
import SimpleOpenNI.*;

SimpleOpenNI  context;

// Just one user is managed in this example
PVector hand_r_real = new PVector();
PVector hand_r_calc = new PVector();
PVector hand_l_real = new PVector();
PVector hand_l_calc = new PVector();

// Flag used to activate or deactive debug curve mode
// If you want to test how bezier curves will appear without Kinect
// set debug_curve = true and curves will follow mouse position
boolean debug_curve = false;

void setup()
{

  // Init canvas size
  size(1100,700,P3D);

  if(!debug_curve)
  {
    context = new SimpleOpenNI(this);
    if(context.isInit() == false)
    {
       println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
       exit();
       return;  
    }
    
    // enable depthMap generation 
    context.enableDepth();
    // enable skeleton generation for all joints
    context.enableUser();
  }
  background(255,255,255);

  stroke(0,0,0);
  strokeWeight(3);
  smooth(8);

}


void draw(){
 
  translate(150,-50);
  stroke(0,20);

  if(!debug_curve)
  {
    // update the cam
    context.update();
  
    // Check id there is an user
    int[] userList = context.getUsers();
    for(int i = 0; i < userList.length; i++)  
    {
      
      // Check if we have identified the skeleton
      if(context.isTrackingSkeleton(userList[i]))
      {
     
        // Get right hand coordinates
        context.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_RIGHT_HAND,hand_r_real);
        context.convertRealWorldToProjective(hand_r_real,hand_r_calc);
        // Get left hand coordinates
        context.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_LEFT_HAND,hand_l_real);
        context.convertRealWorldToProjective(hand_l_real,hand_l_calc);
     
       if(!Float.isNaN(hand_r_calc.x) && !Float.isNaN(hand_r_calc.y))
          curveRight(hand_r_calc.x, hand_r_calc.y);
    
      // Uncomment these two lines if you want to draw a curve also with you left hand
      // if(!Float.isNaN(hand_l_calc.x) && !Float.isNaN(hand_l_calc.y))
      //    curveLeft(hand_l_calc.x, hand_l_calc.y);
    
      }
  
    }
  }
  else
  {
   curveRight(mouseX, mouseY);
  }

}


void curveLeft(float x, float y)
{
  // Write here code for curve that you want to draw with your left hand
}

void curveRight(float x, float y){
    
  noFill();
  beginShape();
  
  // First curve
  // Note: change arguments of bezier function to change curve!
  bezier(width/2, height - 50 , x, y, x, y,400, 500);
  
  // Second curve: uncomment the following two lines to use this curve and comment lines of the other curves
  // Note: try to change vertex and bezierVertex arguments to change curve!
  // vertex(x+250, y+200);
  // bezierVertex(x/2+400, y/2+150, y, x, x/10-100, y/10+100);

  // Third line: uncomment the following line to use this curve and comment lines of the other curves
  // Note: this is a line! Change arguments of bezier function to change curve!
  // bezier(width/2, height/2 , x, y, x, y, width/2, height/2);

  // Try to adjust curves as you want!
  
  endShape();
}



void keyPressed()
{
   // Press a key to clear image on canvas
   background(255);
  // A delay has been introduced in order to not draw immediately a new line after you have clean the canvas  
   delay(1000);
}  



// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  
  PVector jointPos = new PVector();
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

