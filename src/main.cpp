#include <iostream>
#include <ev3wrap.hpp>
#include <functional>
// get the value of pi
#define _USE_MATH_DEFINES
#include <math.h>

using namespace Ev3Wrap;
struct XY {
    float x;
    float y;
};
// function that takes an XY vector (struct) and rotates it by some angle in degrees
// returns the rotated vector
XY rotate(XY v, float angle) {
    float rad = angle * M_PI / 180;
    float cos_rad = cos(rad);
    float sin_rad = sin(rad);
    XY r;
    r.x = v.x * cos_rad - v.y * sin_rad;
    r.y = v.x * sin_rad + v.y * cos_rad;
    return r;
}
XY unitVectorize(XY v) {
    float length = sqrt(v.x * v.x + v.y * v.y);
    XY r;
    r.x = v.x / length;
    r.y = v.y / length;
    return r;
}

void moveOmni(XY goal, float goalRotation, CompassSensor myCompass, Motor topLeft, Motor topRight, Motor bottomLeft, Motor bottomRight) {
    // initialize some constants first
    // assume motors have default anti clockwise spin
    XY Va = unitVectorize({-0.5, -0.5}); // top left
    XY Vb = unitVectorize({-0.5, 0.5}); // top right
    XY Vc = unitVectorize({0.5, 0.5}); // bottom right
    XY Vd = unitVectorize({0.5, -0.5}); // bottom left
    float currentRotation = myCompass.getRelativeDirection();
    // rotate all 4 of the base vectors
    Va = rotate(Va, currentRotation);
    Vb = rotate(Vb, currentRotation);
    Vc = rotate(Vc, currentRotation);
    Vd = rotate(Vd, currentRotation);
    // redefine some variable names, to accomodate for copy and pasting from the SymPy generated solution
    float X_a = Va.x;
    float Y_a = Va.y;
    float X_b = Vb.x;
    float Y_b = Vb.y;
    float X_c = Vc.x;
    float Y_c = Vc.y;
    float X_d = Vd.x;
    float Y_d = Vd.y;
    float e = sqrt(pow(goal.x, 2) + pow(goal.y, 2));
    // e is not a normalized vector so we need to normalize it to get X_e and Y_e
    float X_e = goal.x / e;
    float Y_e = goal.y / e;
    float theta = goalRotation;
    // insert the math formulas here (copy and paste)
    // topLeft
    float a = (-X_b*Y_c*theta + X_b*Y_d*theta + X_c*Y_b*theta + X_c*Y_d*theta - 2.0*X_c*Y_e*e - X_d*Y_b*theta
     - X_d*Y_c*theta + 2.0*X_d*Y_e*e + 2.0*X_e*Y_c*e - 2.0*X_e*Y_d*e)/(2.0*X_a*Y_c - 2.0*X_a*Y_d - 2.0*X_b*Y_c
      + 2.0*X_b*Y_d - 2.0*X_c*Y_a + 2.0*X_c*Y_b + 2.0*X_d*Y_a - 2.0*X_d*Y_b);
    // topRight
    float b = (X_a*Y_c*theta - X_a*Y_d*theta - X_c*Y_a*theta - X_c*Y_d*theta + 2.0*X_c*Y_e*e + X_d*Y_a*theta
     + X_d*Y_c*theta - 2.0*X_d*Y_e*e - 2.0*X_e*Y_c*e + 2.0*X_e*Y_d*e)/(2.0*X_a*Y_c - 2.0*X_a*Y_d - 2.0*X_b*Y_c
      + 2.0*X_b*Y_d - 2.0*X_c*Y_a + 2.0*X_c*Y_b + 2.0*X_d*Y_a - 2.0*X_d*Y_b);
    // bottomRight
    float c = (-X_a*Y_b*theta - X_a*Y_d*theta + 2.0*X_a*Y_e*e + X_b*Y_a*theta + X_b*Y_d*theta - 2.0*X_b*Y_e*e
     + X_d*Y_a*theta - X_d*Y_b*theta - 2.0*X_e*Y_a*e + 2.0*X_e*Y_b*e)/(2.0*X_a*Y_c - 2.0*X_a*Y_d - 2.0*X_b*Y_c
      + 2.0*X_b*Y_d - 2.0*X_c*Y_a + 2.0*X_c*Y_b + 2.0*X_d*Y_a - 2.0*X_d*Y_b);
    // bottomLeft
    float d = (X_a*Y_b*theta + X_a*Y_c*theta - 2.0*X_a*Y_e*e - X_b*Y_a*theta - X_b*Y_c*theta + 2.0*X_b*Y_e*e
     - X_c*Y_a*theta + X_c*Y_b*theta + 2.0*X_e*Y_a*e - 2.0*X_e*Y_b*e)/(2.0*X_a*Y_c - 2.0*X_a*Y_d - 2.0*X_b*Y_c
      + 2.0*X_b*Y_d - 2.0*X_c*Y_a + 2.0*X_c*Y_b + 2.0*X_d*Y_a - 2.0*X_d*Y_b);
    topLeft.runForever(a);
    topRight.runForever(b);
    bottomRight.runForever(c);
    bottomLeft.runForever(d);
}

int main() {
    std::cout << "Hello World!\n";
    IrSeeker myIrSeeker = IrSeeker::bind();
    CompassSensor myCompass = CompassSensor::bind();
    Motor topLeft = Motor::bind(ev3dev::OUTPUT_A);
    Motor topRight = Motor::bind(ev3dev::OUTPUT_B);
    Motor bottomLeft = Motor::bind(ev3dev::OUTPUT_C);
    Motor bottomRight = Motor::bind(ev3dev::OUTPUT_D);
    myCompass.setZero();
    float ballDirection = myIrSeeker.getDirectionACDegrees();
    float rotation = 0;
    while (true) {
        ballDirection = myIrSeeker.getBallDirection();
        if (ballDirection == 0) {
            rotation = 0;
        }
        else if (ballDirection == -1) {
            rotation = -10;
        }
        else {
            rotation = 10;
        }
        moveOmni({10, 10}, rotation, myCompass, topLeft, topRight, bottomLeft, bottomRight);
    }
    return 0;
}