import peasy.*;

import twitter4j.util.*;
import twitter4j.*;
import twitter4j.management.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.auth.*;

float detail = 0;
PFont font, fontsmall;
int count;
TwitterStream twitterStream;

float maxSize = 1000;
float f = 0;
PeasyCam cam;

String tweet;

void setup(){
  frameRate(30);
  cursor(CROSS);
  fullScreen(P3D);
  //size(1500,1000,P3D);
  cam = new PeasyCam(this, 4000);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(4000);
  openTwitterStream();
  
  font = createFont("Courier",500,true);
  fontsmall = createFont("Courier",500,true);
  
  count = 1;
  
  noFill();
  strokeWeight(1);
}

void draw(){
  
  background(0);
  
  textFont(font,400);   
  textAlign(RIGHT);// STEP 3 Specify font to be used
  fill(201,131,222);                     // STEP 4 Specify font color 
  text("IDEAS",-200,-500);
  text(count,0,0);
  
  textFont(fontsmall,75);   
  textAlign(RIGHT);// STEP 3 Specify font to be used
  fill(201,131,222);                     // STEP 4 Specify font color 
  text("FPS:" + frameRate,-200,500);
  
  textFont(fontsmall,75);   
  textAlign(LEFT);// STEP 3 Specify font to be used
  fill(201,131,222);                     // STEP 4 Specify font color 
  text("t" + tweet,-200,650);
  
  stroke(255);
  
  translate(width/2, height/2);
  rotateX(PI/5.0f);
  rotateY(PI/5.0f);
  
  for (float i = f; i < TWO_PI+f; i+= TWO_PI / detail) {
    pushMatrix();
    fill(0,0,0,0);
    translate(0, 0, cos(i) * 100.0f);
    stroke(max(30 + cos(i) * 150,0));
    ellipse(0, 0, maxSize*2.0f + sin(i) * maxSize, maxSize*2.0f + sin(i) * maxSize);
    popMatrix();
  }
  f+= 0.01f;
}


// Stream it
void openTwitterStream() {  
 
  // OAuth stuff
  ConfigurationBuilder cb = new ConfigurationBuilder();  
  cb.setOAuthConsumerKey("***");
  cb.setOAuthConsumerSecret("***");
  cb.setOAuthAccessToken("***");
  cb.setOAuthAccessTokenSecret("***"); 
 
  //the stream object
  TwitterStream twitterStream = new TwitterStreamFactory(cb.build()).getInstance();
 
  // filter is used to pass querys to the stream
  // see twitter4j's java doc
  FilterQuery filtered = new FilterQuery();
 
  // if you enter keywords here it will filter, otherwise it will sample
  String keywords[] = {
    "idea"
  };

  filtered.track(keywords);

  twitterStream.addListener(listener);
 
  if (keywords.length==0) {

    twitterStream.sample();
  } else { 
    twitterStream.filter(filtered);
  }
  println("connected");
} 

StatusListener listener = new StatusListener() {
 
  //@Override
  public void onStatus(Status status) {
    System.out.println("@" + status.getUser().getScreenName() + " - " + status.getText());
  
  tweet = "@" + status.getUser().getScreenName() + " - " + status.getText();
  
detail ++;

count++;

}
 
  //@Override
  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }
 
  //@Override
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
  }
 
  //@Override
  public void onScrubGeo(long userId, long upToStatusId) {
    System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }
 
  //@Override
  public void onStallWarning(StallWarning warning) {
    System.out.println("Got stall warning:" + warning);
  }
 
  //@Override
  public void onException(Exception ex) {
    ex.printStackTrace();
  }
};
