
//color[] palette = {#FF7700, #00AFB5, #00B9AE, #F9A03F, #EA526F, #6461A0, #B68CB8, #F5FF90, #D6FFB7, #98CE00, #16E0BD, #78C3FB, #CE2D4F, #CE6D8B, #F06543, #D95D39, #FF784F, #FFCA3A, #EFCA08, #A8C256, #254441};

color [] palette = {#b80d0d, #0d27a8, #6e80db, #ffd21c, #9aba3a, #470711, #f4ffd1, #ff773d, #c9006b, #4e31f5};
color [] palette1 = {#e1dbff, #0d27a8, #6e80db, #2c3382};


JSONObject json;
int max = 0;
int nbChildren = 0;
int childN = 0;

void setup() {
  // a5 is 150mm by 210mm
  // 2480 x 1748 px
  size(750, 1050); // size that fits in my screen for now
  background(0);
  noFill();
  //rectMode(CENTER);

  //noStroke();
  // within the json -> children
  json = loadJSONObject("data/trace.json");

  // get the total children
  nbChildren = countChildren(json);
  println("total children:" + nbChildren);

  // get the longest "name"
  max = maxLen(json);
  println("max is " + max);

  //backgroundzzz(json, 0); childN = 0;
  linezzz(json, 10, childN, 0);
  noLoop();
}

void backgroundzzz(JSONObject json, int c) {

  childN ++;
  JSONArray children = json.getJSONArray("children");
  int childrenSize = children.size();

  // recursive part
  for (int i = 0; i < childrenSize; i++) {
    println(childN);
    fill(palette1[i % palette1.length]);
    noStroke();
    rect(width, childN, -i*50, 100);
    backgroundzzz(children.getJSONObject(i), c++);
  }
}

void linezzz(JSONObject json, float x, float y, int c) {

  // count every time we arrive here, we are at a new child
  childN ++;

  JSONArray children = json.getJSONArray("children");
  int childrenSize = children.size();

  String name = (String) json.get("name");
  int nameLen = name.length();

  float newLen = map(nameLen, 0, max, 0, width);
  float rectW = height/nbChildren * childrenSize;
  println(childrenSize);

  // new color for every child
  //fill(palette[c % palette.length]);
  fill(palette[childrenSize % palette.length]);
  noStroke();

  // determine x, y coordinates
  x = c*x;

  if (name.startsWith("org.jitsi")) {
    for (float xi = x; xi<newLen; xi=xi+10) {
      rect(xi, y, 5, rectW); //normal rect mode
    }
  } else if (name.startsWith("com.google")) {
    rect(x, y, newLen, rectW); //normal rect mode
  } else if (name.startsWith("org.json")) {
    for (float xi = x; xi<newLen; xi=xi+30) {
      rect(xi, y, 25, rectW); //normal rect mode
    }
  }



  //rect(width/2, childN, newLen, rectW); // enter rect mode


  // recursive part
  for (int i = 0; i < childrenSize; i++) {
    linezzz(children.getJSONObject(i), 10, childN, c++);
  }
}


int maxLen(JSONObject json) {
  String name = (String) json.get("name");
  int ms = name.length();

  JSONArray children = json.getJSONArray("children");
  for (int i = 0; i < children.size(); i++) {
    ms = Math.max(ms, maxLen(children.getJSONObject(i)));
  }
  return ms;
}


int countChildren(JSONObject json) {
  int c = 1;
  JSONArray children = json.getJSONArray("children");
  for (int i = 0; i < children.size(); i++) {
    c += countChildren(children.getJSONObject(i));
  }
  return c;
}

void draw() {
}

void keyPressed() {
  if (key == 's') {
    saveFrame("line-######.png");
  }
}
