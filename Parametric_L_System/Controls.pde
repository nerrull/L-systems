import controlP5.*;

import peasy.org.apache.commons.math.geometry.Rotation;
import peasy.org.apache.commons.math.geometry.Vector3D;

class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;
  Slider growthSlider;
  Slider ageSlider;

  ArrayList<Slider> odds_sliders;
  int last_selected = 0;
  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    odds_sliders = new ArrayList<Slider>(10);
  }
  
  public void settings() {
    size(w, h, P2D);
  }
 
  public void setup() {
    this.surface.setSize(w, h);
    cp5 = new ControlP5(this);
    growthSlider = cp5.addSlider("growth").plugTo("plugGrowth").setRange(0.01, 1.).setValue(0.1).setPosition(10, 10).setSize(100,20);
    growthSlider.onChange(new CallbackListener() { 
        public void controlEvent(CallbackEvent theEvent) {
          float value = theEvent.getController().getValue();
          field.setGrowthRate(value, false);
        }});// add the Callback Listener
        
    ageSlider = cp5.addSlider("ageDeath").plugTo("ageDeath").setRange(1., 500.).setValue(100).setPosition(120, 10).setSize(100,20);
    ageSlider.onChange(new CallbackListener() { 
        public void controlEvent(CallbackEvent theEvent) {
          float value = theEvent.getController().getValue();
          field.deathAge  =value;
        }});// add the Callback Listener
    cp5.addButton("addPlant",2).setPosition(100, 35).setSize(100,20);
    //cp5.addNumberbox("color 2").plugTo(parent, "c2").setRange(0, 1000).setValue(1).setPosition(100, 60).setSize(100,20);
    
    Slider s;
    int x_offset = 10;
    int y_offset = 150;

    for(int i =0; i < field.plant_odds.size(); i++){
       String name = field.possiblePlantNames[i];
       s = cp5.addSlider(name)
        .setPosition(x_offset, y_offset)
        .setSize(20,40)
        .setRange(0.,1.)
        .setValue(1.);
        
       s.onChange(new CallbackListener() { 
          public void controlEvent(CallbackEvent theEvent) {
            float v = theEvent.getController().getValue();
            String n =theEvent.getController().getName();
            field.setOdds(n, v);
            println("Setting odds for "  +n );
          }});// add the Callback Listener to the button 
   
       s.getValueLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE).setPaddingX(0);
       s.getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
       s.setColorForeground(color(0, 0, 125));
       x_offset +=50;
       odds_sliders.add(s);
    }
    odds_sliders.get(0).setColorForeground(color(0, 125, 0));
  }
  
  void updateSelected(int index){
    odds_sliders.get(last_selected).setColorForeground(color(0, 0, 125));
    odds_sliders.get(index).setColorForeground(color(0, 125, 0));
    last_selected= index;
  }
  void updateOdds(int idx, float value){
    odds_sliders.get(idx).setValue(value);
  }
  public void draw() {
    background(20);
    //pushMatrix();
    //translate(width/2, height/2);
    //rotate(frameCount*0.05);
    //fill(255,0,0);
    //rect(0,0,100,100);
    //popMatrix();
  }
void updateGrowthValue(float v){
  growthSlider.setValue(v);
}
void addPlant(float theValue) {
  field.q.add(0);
  println("adding plant");

}
void plugGrowth(float theValue) {
  println("changing growth to :" +theValue);

}

void setAge(float theValue) {
  println("changing growth to :" +theValue);

}
}



void updateCamPosition(){
  float radius = (float)100.;
  float y= sin(frameCount /100)*radius;
  float z = cos(frameCount /100)*radius;
  float x =500;
  //cam.handleDrag(-1.,0.);
}


void SetCamVector(PVector p)
{
  Rotation rot=new Rotation(new Vector3D(0,0,10),new Vector3D(p.x,p.y,p.z));
  cam.setState(new CameraState(rot, new Vector3D(p.x,p.y,p.z), cam.getDistance()));
  cam.lookAt(0,0,0);
}

void SetCamVector(float x, float y, float z)
{
  Rotation rot=new Rotation(new Vector3D(0,0,10),new Vector3D(x,y,z));
  cam.setState(new CameraState(rot, new Vector3D(x,y,z), cam.getDistance()));
  cam.lookAt(0,0,0);

}
