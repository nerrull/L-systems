import controlP5.*;
ControlFrame controlFrame;
class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void settings() {
    size(w, h, P2D);
  }
 

  public void setup() {
    this.surface.setSize(w, h);
    cp5 = new ControlP5(this);
    Slider slider = cp5.addSlider("growth").plugTo("plugGrowth").setRange(0.01, 0.2).setValue(0.01).setPosition(100, 10).setSize(100,20);
    slider.onChange(new CallbackListener() { 
        public void controlEvent(CallbackEvent theEvent) {
          float value = theEvent.getController().getValue();
          field.setGrowthRate(value);
        }});// add the Callback Listener
    cp5.addButton("addPlant",2).setPosition(100, 35).setSize(100,20);
    //cp5.addNumberbox("color 2").plugTo(parent, "c2").setRange(0, 1000).setValue(1).setPosition(100, 60).setSize(100,20);
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

void addPlant(float theValue) {
  field.q.add(0);
  println("adding plant");

}
void plugGrowth(float theValue) {
  println("changing growth to :" +theValue);

}
}
