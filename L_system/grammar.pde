import java.util.HashMap;

static boolean isin(String s, String[] strings){
  for (int i =0; i < strings.length; i++){
    if (s.equals( strings[i])) {return true;}
  }
  return false;
}

static interface Command {
    void runCommand();
}
class Grammar{
  protected String[] variables={"X","F"};;
  protected HashMap<String, String> rules;
  protected HashMap<String, Command> drawFunctions;
  float angle,forward_length;

  Grammar(){
     angle = 0.;
     forward_length = -1.;
     rules = new HashMap<String, String>();
     drawFunctions= new  HashMap<String, Command>();
     defineFunctions();
  }
  
  String updateSystem(String system){
    String newString = "";
    for (int i =0; i <system.length();i++){
      String s = ""+system.charAt(i);
      if (isin(s, variables)){
        newString = newString + rules.get(s);
      }
      else newString = newString + s;
    }
    return newString;
  }
  
  void drawSystem(String system){
    pushMatrix();
    for (int i =0; i <system.length();i++){
      String s = ""+system.charAt(i);
      drawFunctions.get(s).runCommand();
    
    }
    popMatrix();
  }
  
   void defineFunctions(){
    drawFunctions.put("-", new Command() {
        public void runCommand() { 
          //System.out.print("-"); 
          rotate(-angle);
        };
    });
    drawFunctions.put("+", new Command() {
        public void runCommand() { 
          //System.out.print("+"); 
          rotate(angle);
        };
    });
    drawFunctions.put("[", new Command() {
        public void runCommand() { 
          //System.out.print("["); 
          pushMatrix();
        };
    });
    drawFunctions.put("]", new Command() {
        public void runCommand() { 
          //System.out.print("]"); 
          popMatrix();
        };
    });
    drawFunctions.put("F", new Command() {
        public void runCommand() { 
          //System.out.print("F"); 
          strokeWeight(1);
          stroke(255,255,255,100);

          line(0,0, 0,forward_length);
          translate(0,forward_length);
        };
    });
    drawFunctions.put("S", new Command() {
        public void runCommand() { 
          //System.out.print("F"); 
          strokeWeight(2);
          stroke(255,255,255,200);
          //float l = -random(1., forward_length);
          line(0,0, 0,forward_length);
          translate(0,forward_length);
        };
    });
    drawFunctions.put("X", new Command() {
        public void runCommand() { 
          //System.out.print("X"); 
        };
    });
  }
}

class Node1 extends Grammar{

  Node1(){
    angle = 25./180.*PI;
    forward_length = -4.;
    defineRules();
    defineFunctions();
  }
  
  void defineRules(){   
    rules.put("X", "F+[[X]-X]-F[-FX]+X");
    rules.put("F", "SS");
    rules.put("S", "SS");
  }
  
  String getInitialString(){
    return "X";
  }
}

class Node2 extends Grammar{

  Node2(){
    angle = 25./180.*PI;
    forward_length = -4.;
    defineRules();
    defineFunctions();
  }
  
  void defineRules(){   
    rules.put("X", "F[+X]F[-X]+X");
    rules.put("F", "SS");
    rules.put("S", "SS");
  }
  
  String getInitialString(){
    return "X";
  }
}

//p25
class Edge1 extends Grammar{
  Edge1(){
    angle = 25.7/180.*PI;
    forward_length = -4.;
    defineRules();
    defineFunctions();
  }
  
  void defineRules(){   
    rules.put("F", "F[+F]F[-F]F");
  }
  
  String getInitialString(){
    return "F";
  }
}

class Edge2 extends Grammar{
  Edge2(){
    angle = 20./180.*PI;
    forward_length = -4.;
    defineRules();
    defineFunctions();
  }
  
  void defineRules(){   
    rules.put("F", "F[+F]F[-F][F]");
  }
  
  String getInitialString(){
    return "F";
  }
}

class Edge3 extends Grammar{
  Edge3(){
    angle = 22.5/180.*PI;
    forward_length = -4.;
    defineRules();
    defineFunctions();
  }
  
  void defineRules(){   
    rules.put("F", "FF-[-F+F+F]+[+F-F-F]");
  }
  
  String getInitialString(){
    return "F";
  }
}
