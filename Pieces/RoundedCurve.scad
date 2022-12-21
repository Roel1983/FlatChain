
RoundedCurve(20, 1, 45, 135);

module RoundedCurve(d1, d2, a1, a2) {
    difference() {
        pie(d1 + d2, a1, a2);
        circle(d=d1 - d2);
    }
    for (a = [a1,a2]) {
        rotate(a) translate([d1 / 2,0]) {
            circle(d=d2);
        }
    }

    module pie(d, a1, a2) {
        if (a1 != 0) {
            rotate(a1) pie(d, 0, a2 - a1);
        } else if (a1 > a2) {
            pie(d, a1, a2 + 360);
        } else if (a2 > 360) {
            pie(d, a1, a2 - 360);
        } else {
            if (a2 <= 90) {
                intersection() {
                    circle(d=d);
                    square(d);
                    rotate(-90 + a2) square(d);
                }
            } else if (a2 < 180) {
                intersection() {
                    circle(d=d);
                    union() {
                        square(d);
                        rotate(-90 + a2) square(d);
                    }
                }
            } else if (a2 < 270) {
                difference() {
                    circle(d=d);
                    rotate(-90) square(d);
                    rotate(a2) square(d);
                }
            } else if (a2 != 360) {
                difference() {
                    circle(d=d);
                    intersection() {
                        rotate(-90) square(d);
                        rotate(a2) square(d);
                    }
                }
            } else {
                circle(d=d);
            }
        }
    }
}



