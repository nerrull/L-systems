import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.antialiasing.FXAA.FXAA;
import processing.core.PApplet;
import processing.opengl.PGraphics3D;
import com.thomasdiewald.pixelflow.java.utils.DwUtils;



class Renderer{
  FXAA fxaa;
  DwPixelFlow context;
  PGraphics3D canvas;
  PGraphics3D canvas_aa;

  Renderer(PApplet sketch){
      context = new DwPixelFlow(sketch);
      context.print();
      context.printGL();
      fxaa = new FXAA(context);
      boolean[] RESIZED = {false};
      canvas = DwUtils.changeTextureSize(sketch, canvas, width, height, 0, RESIZED);
      canvas_aa = DwUtils.changeTextureSize(sketch, canvas_aa, width, height, 0, RESIZED);
  }
  
  void beginDraw(PApplet sketch){
    canvas.beginDraw();
    DwUtils.copyMatrices((PGraphics3D) sketch.g, canvas);
    // background
    canvas.blendMode(PConstants.BLEND);
    canvas.background(255);
    
  }
  
  void endDraw(){
    canvas.endDraw();
    fxaa.apply(canvas, canvas_aa);
  }
  
  void draw(float x, float y, float w, float h){
    DwUtils.beginScreen2D(g);
    {
      blendMode(REPLACE);
      clear();
      image(canvas_aa, x,y,w,h);
    }
    DwUtils.endScreen2D(g);
    
    // some info, window title
    String txt_fps = String.format(getClass().getName()+ "   [fps %6.2f]", frameRate);
    surface.setTitle(txt_fps);
  }
  
  PGraphics getCanvas(){
    return this.canvas;
  }
}
