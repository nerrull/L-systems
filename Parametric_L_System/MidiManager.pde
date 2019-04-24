import themidibus.*; //Import the library


MidiBus myBus;
int mpk_input_index;
int loopbe_output_index;
int min_midi_note =48;
int max_midi_note = 72;
boolean verbose;
PriorityQueue<Integer> q;

void initMidi(){
  verbose = true;
  MidiBus.list();
  mpk_input_index =1;
  loopbe_output_index =3;
  q = new PriorityQueue<Integer>();
  myBus = new MidiBus(this, mpk_input_index, loopbe_output_index);
}
  
  void noteOn(Note note){
    myBus.sendNoteOn(note);

    field.slot_q.add(note.pitch() %24);

    if (verbose){
      println();
      println("Note On:");
      println("--------");
      println("Channel:"+note.channel());
      println("Pitch:"+note.pitch());
      println("Velocity:"+note.velocity());
    }
  }

  void sendPercussiveNote(int offset){
      Note note = new Note(1,64+offset, 75);
      println();
      println("Percussive Note On:");
      println("--------");
      println("Channel:"+note.channel());
      println("Pitch:"+note.pitch());
      println("Velocity:"+note.velocity());
      myBus.sendNoteOn(note);
      // myBus.sendNoteOff(note);
  }
  
  void noteOff(Note note) {
    // Receive a noteOff
    myBus.sendNoteOff(note);
    field.off_q.add(note.pitch()%24);

    if (verbose){
      println();
      println("Note Off:");
      println("--------");
      println("Channel:"+note.channel());
      println("Pitch:"+note.pitch());
      println("Velocity:"+note.velocity());
    }    
  }
  
  

  
  void controllerChange(ControlChange change) {
    // Receive a controllerChange

    
    if (verbose){
      println();
      println("Controller Change:");
      println("--------");
      println("Channel:"+change.channel());
      println("Number:"+change.number());
      println("Value:"+change.value());
    }
    
    //Knob numbers (left right top bottom)
    //53 //54 //55 //56
    //49 //50 //51 //52
    
    //Sustain button : 64
    int number = change.number();
    int value = change.value();
    float v = map(value, 0,127,0.,1.);

    switch (number){
      case 64:
        field.reset();
        break;
      case 49:
      
        field.setGrowthRate(v, true);
        break;
        
      case 50:
        v = map(value, 0,127,-1.,1.);
        //field.setWindSpeed(v);
        break;
      case 51:
        //field.setSunSpeed(v);
        break;
        
      case 53:
        field.setSelectedIndex(max(min(field.plant_odds.size()-1, floor(v*field.plant_odds.size())), 0));
        //field.incrementSelected();
        break;
      case 54:
        field.setOdds(field.selected_index, v, true);
        break;
      case 55:
        //field.setSunSpeed(v); //<>//
        break;
      case 56:
        //field.setSunSpeed(v);
        break;
      default:
        return;
    }
  }  
 //<>// //<>// //<>//
  
