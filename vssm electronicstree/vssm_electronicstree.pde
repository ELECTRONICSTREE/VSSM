import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
ScrollableList Gaslist;
Serial serial;
ScrollableList portlist;
ScrollableList baudlist;
Button cntbutton;
Textarea receivedArea;
Println arduinoConsole;

boolean btnStatus = false;
String selectedport;
int selectedbaudrate;

float smokeLevel = 50;
float sensorOutput = 0;
boolean smokeEnabled = false;


ParticleSystem ps;
PImage smokeTexture;
PImage sensorImage;
PImage bkmenuImage;
PImage usbcon, usbdiscon;
PImage treelogo;


color smokeColor = color(50, 50, 50);
color methaneColor = color(0, 255, 255);
color co2Color = color(255, 0, 0);
color ammoniaColor = color(0, 255, 0);


float smoothingFactor = 0.5;
float gasSensitivity = 1.0;


float smokeFactor = 1.0;
float methaneFactor = 0.8;
float co2Factor = 1.5;
float ammoniaFactor = 1.2;
float currentGasFactor = smokeFactor;


boolean isDragging = false;
PVector dragOffset = new PVector(0, 0);
boolean isDetecting = false;


float menuX = 10;
float menuY = 10;
float menuWidth = 220;
float menuHeight = height - 20;



void setup() {
  size(800, 600);
  surface.setIcon(loadImage("smksensoricon.png"));
  surface.setTitle("Virtul Smoke Sensor - electronicstree.com");

  cp5 = new ControlP5(this);
  serialUIControles();
  setupUIControls();
  loadAssets();

  ps = new ParticleSystem(0, new PVector(400, 300), smokeTexture);
}

void draw() {

  color topColor = color(114, 122, 154);
  color bottomColor = color(216, 219, 233);
  drawGradient(topColor, bottomColor);
  drawMenuBackground();
  LogoImage();

  if (btnStatus) {
    drawConnectedImage();
  } else {
    drawDisconnectedImage();
  }

  if (!smokeEnabled) {
    isDragging = false;
  }

  float sensorX = 440;
  float sensorY = 250;
  drawSmokeSensor(sensorX, sensorY);

  if (isDragging) {
    ps.origin.set(mouseX + dragOffset.x, mouseY + dragOffset.y);
  }

  if (smokeEnabled) {
    ps.addParticle();
    float intensityFactor = map(smokeLevel, 0, 100, 0, 1);
    ps.applyForce(new PVector(0, -0.1 * intensityFactor));
  }
  ps.run();

  updateSensorOutput(sensorX, sensorY);
  displaySensorOutput(470, 40, sensorOutput);
  sendDataToArduino();
  updateSmokeColor();

  if (portlist.isInside() && !portlist.isOpen()) {
    portlist.bringToFront();
    portlist.open();
  } else if (!portlist.isInside() && portlist.isOpen()) {
    portlist.close();
  }

  if (baudlist.isInside() && !baudlist.isOpen()) {
    baudlist.bringToFront();
    baudlist.open();
  } else if (!baudlist.isInside() && baudlist.isOpen()) {
    baudlist.close();
  }
}


void mousePressed() {
  if (dist(mouseX, mouseY, ps.origin.x, ps.origin.y) < 50) {
    isDragging = true;
    dragOffset.set(ps.origin.x - mouseX, ps.origin.y - mouseY);
  }
}

void mouseReleased() {
  isDragging = false;
}
