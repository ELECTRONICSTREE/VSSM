


void updateSensorOutput(float sensorX, float sensorY) {
  float distance = dist(ps.origin.x, ps.origin.y, sensorX + 50, sensorY + 50);
  float maxDistance = 150;
  float intensityFactor = map(smokeLevel, 0, 100, 0, 1023);  // Intensity of smoke

  if (smokeEnabled && distance <= maxDistance) {
    isDetecting = true;
    float gasFactor = getGasSensitivityFactor();
    sensorOutput = max(0, intensityFactor * gasFactor * (1 - constrain(distance / maxDistance, 0, 1)));
  } else {
    isDetecting = false;
    sensorOutput = 0;
  }
}


void displaySensorOutput(float x, float y, float output) {
  fill(255);
  textAlign(CENTER);
  textSize(16);
  if (isDetecting) {
    text("Sensor Output: " + int(output), x, y);
    text("Voltage: " + nf((output / 1023.0) * 5.0, 1, 2) + "V", x, y + 20);
  } else {
    text("No Gas Detected", x, y);
  }
}

float getGasSensitivityFactor() {
  int gasSelection = (int) cp5.get(ScrollableList.class, "GasSelection").getValue();
  return gasSelection == 0 ? smokeFactor : gasSelection == 1 ? methaneFactor : gasSelection == 2 ? co2Factor : ammoniaFactor;
}

void updateSmokeColor() {
  int gasSelection = (int) cp5.get(ScrollableList.class, "GasSelection").getValue();

  if (gasSelection == 0) {
    smokeColor = color(50, 50, 50);
    currentGasFactor = smokeFactor;
  } else if (gasSelection == 1) {
    smokeColor = methaneColor;
    currentGasFactor = methaneFactor;
  } else if (gasSelection == 2) {
    smokeColor = co2Color;  // Red for CO2
    currentGasFactor = co2Factor;
  } else if (gasSelection == 3) {
    smokeColor = ammoniaColor;
    currentGasFactor = ammoniaFactor;
  }

  ps.updateColor(smokeColor);

  float sensorX = 500;
  float sensorY = 200;
  updateSensorOutput(sensorX, sensorY);
}


void drawSmokeSensor(float x, float y) {
  imageMode(CENTER);
  noTint();
  image(sensorImage, x + 50, y + 50, 145, 245);
}


void baudlist(int index) {
  String baudstring;
  baudstring = baudlist.getItem(index).get("name").toString();
  selectedbaudrate = Integer.parseInt(baudstring);
  println("Selected", selectedbaudrate);
}


void comportlist(int index) {
  selectedport = portlist.getItem(index).get("name").toString();
  println("Selected", selectedport);
}


void button() {
  if (!btnStatus) {
    if (selectedport == null || selectedbaudrate == 0) {
      println("Error: Please select both a port and a baud rate before connecting.");
      return;
    }
    try {
      serial = new Serial(this, selectedport, selectedbaudrate);
      cntbutton.setLabel("Disconnect");
      btnStatus = true;
      println("Connected to", selectedport, "at", selectedbaudrate);
    }
    catch (Exception e) {
      println("Error connecting to serial port:", e);
    }
  } else {
    serial.stop();
    cntbutton.setLabel("Connect");
    btnStatus = false;
    println("Disconnected from", selectedport);
  }
}



void LogoImage() {

  imageMode(CENTER);
  noTint();
  image(treelogo, 770, 575, 48, 48);
}


void drawConnectedImage() {

  imageMode(CENTER);
  noTint();
  image(usbcon, 150, 383, 32, 32);
}

void drawDisconnectedImage() {
  imageMode(CENTER);
  noTint();
  image(usbdiscon, 150, 383, 32, 32);
}

String previousData = "";

void sendDataToArduino() {
  // Get the selected gas
  int gasSelection = (int) cp5.get(ScrollableList.class, "GasSelection").getValue();
  String gasType;

  switch (gasSelection) {
  case 0:
    gasType = "Smoke";
    break;
  case 1:
    gasType = "Methane";
    break;
  case 2:
    gasType = "CO2";
    break;
  case 3:
    gasType = "Ammonia";
    break;
  default:
    gasType = "Unknown";
    break;
  }

  if (isDetecting) {
    String data = "Gas:" + gasType +
      ",S:" + int(sensorOutput) +
      ",V:" + nf((sensorOutput / 1023.0) * 5.0, 1, 2);

    if (!data.equals(previousData)) {
      if (serial != null && serial.active()) {
        serial.write(data + "\n"); //
        println("Data Sent: " + data);
      }
    }
    previousData = data;
  }
}
