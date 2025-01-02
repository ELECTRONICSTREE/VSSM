
void serialUIControles() {


  PFont serFont = createFont("calibrib.ttf", 16);
  ControlFont serControlFont = new ControlFont(serFont, 16);

  cp5.addTextlabel("serLabel")
    .setText("SERIAL CONNECTION SETTINGS")
    .setPosition(12, 340)
    .setFont(serControlFont)
    .setColor(color(255));


  PFont pfont = createFont("Calibri.ttf", 20, true);
  ControlFont font = new ControlFont(pfont, 14);

  portlist = cp5.addScrollableList("comportlist")
    .setPosition(15, 406)
    .setSize(100, 100)
    .setBarHeight(30)
    .setItemHeight(30)
    .setFont(font)
    .setColorBackground(color(96, 104, 136))
    .setColorForeground(color(56, 61, 79))
    .setColorActive(color(56, 61, 79))
    .bringToFront()
    .setCaptionLabel("COM Port")
    ;
  portlist.getCaptionLabel().getStyle().marginTop = 5;
  portlist. getValueLabel().getStyle().marginTop = 5;

  String[] avaialableports = Serial.list();

  for (int i=0; i<avaialableports.length; i++) {
    portlist.addItem(avaialableports[i], avaialableports[i]);
  }

  baudlist = cp5.addScrollableList("baudlist")
    .setPosition(125, 406)
    .setSize(100, 100)
    .setBarHeight(30)
    .setItemHeight(30)
    .setFont(font)
    .setCaptionLabel("Baudrate")
    .setColorBackground(color(96, 104, 136))
    .setColorForeground(color(56, 61, 79))
    .setColorActive(color(56, 61, 79));

  baudlist.getCaptionLabel().getStyle().marginTop = 5;
  baudlist. getValueLabel().getStyle().marginTop = 5;

  baudlist.addItem("9600", 9600);
  baudlist.addItem("19200", 19200);
  baudlist.addItem("38400", 38400);
  baudlist.addItem("57600", 57600);
  baudlist.addItem("115200", 115200);



  cntbutton = cp5.addButton("button")
    .setPosition(15, 366)
    .setSize(100, 30)
    .setLabel("Connect")
    .setFont(font)
    .setColorBackground(color(96, 104, 136))
    .setColorForeground(color(56, 61, 79))
    .setColorActive(color(56, 61, 79));

  receivedArea = cp5.addTextarea("receivedData")
    .setSize(210, 80)
    .setPosition(15, 500)
    .setFont(font)
    .setColorBackground(color(56, 61, 79));

  arduinoConsole = cp5.addConsole(receivedArea);
}


void setupUIControls() {



  PFont smokeFont = createFont("calibrib.ttf", 16);
  ControlFont smokeControlFont = new ControlFont(smokeFont, 16);

  cp5.addTextlabel("smokeLabel")
    .setText("SIMULATION SETTINGS")
    .setPosition(12, 30)
    .setFont(smokeControlFont)
    .setColor(color(255));




  PFont pfont = createFont("Calibri.ttf", 14, true);
  ControlFont font = new ControlFont(pfont, 14);

  cp5.addIcon("smokeEnabled", 10)
    .setPosition(135, 235)
    .setSize(50, 50)
    .setRoundedCorners(20)
    .setFont(createFont("fontawesome-webfont.ttf", 40))
    .setFontIcons(#00f057, #00f058) // Icons for on/off states
    .setSwitch(true)
    .setColorForeground(color(96, 104, 136))
    .setColorBackground(color(96, 104, 136))
    .setColorActive(color(56, 61, 79));



  cp5.addTextlabel("toggleLabel")
    .setText("GAS/SMOKE  -----  START/STOP")
    .setPosition(15, 220) // Position the label near the toggle
    .setFont(font)
    .setColor(color(255)); // Optional: Customize the label color

  cp5.addSlider("smokeLevel")
    .setPosition(15, 80)
    .setSize(200, 18)
    .setRange(0, 100)
    .setValue(50)
    .setFont(font)
    .setLabel("Smoke Intensity")
    .setColorBackground(color(96, 104, 136))
    .setColorForeground(color(56, 61, 79))
    .setColorActive(color(56, 61, 79))
    .getCaptionLabel()
    .align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);

  cp5.addSlider("smoothingFactor")
    .setPosition(15, 130)
    .setSize(200, 18)
    .setRange(0, 1)
    .setValue(0.5)
    .setFont(font)
    .setLabel("Smoothing Factor")
    .setColorBackground(color(96, 104, 136))
    .setColorForeground(color(56, 61, 79))
    .setColorActive(color(56, 61, 79))
    .getCaptionLabel()
    .align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);

  cp5.addSlider("gasSensitivity")
    .setPosition(15, 180)
    .setSize(200, 18)
    .setRange(0, 5)
    .setValue(1.0)
    .setFont(font)
    .setColorBackground(color(96, 104, 136))
    .setColorForeground(color(56, 61, 79))
    .setColorActive(color(56, 61, 79))
    .setLabel("Smoke Sensitivity")
    .getCaptionLabel()
    .align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);

  Gaslist = cp5.addScrollableList("GasSelection")
    .setPosition(15, 245)
    .setSize(100, 100)
    .setBarHeight(30)
    .setItemHeight(25)
    .setFont(font)
    .setColorBackground(color(96, 104, 136))
    .setColorForeground(color(56, 61, 79))
    .setColorActive(color(56, 61, 79))
    .addItem("Smoke", 0)
    .addItem("Methane", 1)
    .addItem("CO2", 2)
    .addItem("Ammonia", 3)
    .setLabel("Select Gas")
    .close();

  Gaslist.getCaptionLabel().getStyle().marginTop = 5;
  Gaslist.getValueLabel().getStyle().marginTop = 5;
}

void drawMenuBackground() {

  noStroke();
  fill(0, 0, 0, 20);
  rect(13, 13, 220, height - 20, 5);

  // Draw menu background
  fill(161, 167, 188, 200);
  rect(10, 10, 220, height - 20, 5);
}

void drawGradient(color c1, color c2) {
  for (int y = 0; y < height; y++) {
    stroke(lerpColor(c1, c2, map(y, 0, height, 0, 1)));
    line(0, y, width, y);
  }
}
