class LeafPattern{
	PShape leafShape;
	ArrayList<PShape> leafAges;
	Word w;
	WordTree word;
    HashMap<String, ParametricRule> rules;
	float growth_step;

	void init(){
		leafAges = new ArrayList<PShape>(32);
		w = new Word();
		word = new WordTree();
		defineGeneralRules();
	}

	LeafPattern(ParametricRule leafRule){
		init();
		rules.put("L",leafRule);
		w.add(new Leaf(0,1));
	    word.init(w.modules);
	}

	boolean updateLeaf(float growth_step){
		word.update(rules, growth_step);
		word.parse();
		return word.isDone();
	}

	//Age should be between 0 and 1
	void drawLeaf(float age, PGraphics c){
		int idx = (int) map(age, 0, 1, 0, leafAges.size());
		c.shape(leafAges.get(idx));
	}

	void getLeaf(float age, PGraphics c){
		int idx = (int) map(age, 0, 1, 0, leafAges.size());
		c.shape(leafAges.get(idx));
	}

    void defineGeneralRules(){
	   rules.put("D", D);
	   rules.put("I", I);
	   rules.put("IR", IR);
    }
};

class LeafManager{
	HashMap<String, LeafPattern> leafPatterns;

	LeafManager(){ //<>//
		float growth_step =0.1;
		leafPatterns = new HashMap<String, LeafPattern> (8);
		leafPatterns.put("TulipLeaf", new LeafPattern(TulipLeafRule) );
		for (LeafPattern leaf: leafPatterns.values()){
			int i =0;
			while (leaf.updateLeaf(growth_step)){
				println("Leaf update #" + i );
				i++;
			}
		}
	}

	void drawLeaf(String name, float age, PGraphics c){
		leafPatterns.get(name).drawLeaf(age, c);
	}

	//PShape getLeaf(String name, float age, PGraphics c){
	//	return leafPatterns.get(name).drawLeaf(age, c);
	//}
};

ParametricRule TulipLeafRule = new ParametricRule() {
	public boolean rule(Module m,  ArrayList<Module> ret, boolean dirty) { 
    float age = m.getP("age");
    float size = m.getP("size");
    float angle = radians(7);
    float extra_angle = angle - radians((angle/size));
    ret.add(new LBrack());
    ret.add(new Fill());
    ret.add(new White());
    ret.add(new Minus(angle));
    ret.add(new TimedRotation(size/1.5,extra_angle, new Minus(0)));
    ret.add(new F(.1));
    ret.add(new I(size));
    ret.add(new Plus(angle));
    ret.add(new TimedRotation(size/1.5,extra_angle, new Plus(0)));
    ret.add(new F(.1));
    ret.add(new F(.1));
    ret.add(new F(.1));
    ret.add(new F(.1));

    ret.add(new I(size));
    ret.add(new Plus(angle));
    ret.add(new TimedRotation(size/1.5,extra_angle, new Plus(0)));
    ret.add(new F(.1));
    ret.add(new I(size));
    ret.add(new RBrack());
        
    ret.add(new LBrack());
    ret.add(new Fill());
    ret.add(new White());
    ret.add(new Plus(angle));
    ret.add(new TimedRotation(size/1.5,extra_angle, new Plus(0)));
    ret.add(new F(.1));
    ret.add(new I(size));
    ret.add(new Minus(angle));
    ret.add(new TimedRotation(size/1.5,extra_angle, new Minus(0)));
    ret.add(new F(.1));
    ret.add(new F(.1));
    ret.add(new F(.1));
    ret.add(new F(.1));
    ret.add(new I(size));
    ret.add(new Minus(angle));
    ret.add(new TimedRotation(size/1.5,extra_angle, new Minus(0)));
    ret.add(new F(.1));
    ret.add(new I(size));
    ret.add(new RBrack());
    return true;
    }
};
