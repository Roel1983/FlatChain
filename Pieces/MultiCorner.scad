module MultiCorner(n, r=undef, d=undef) {
    if(r != undef && d == undef) {
        MultiCorner(n, d = 2 * r);
    } else {
        intersection_for(i = [0:n-1]) rotate(i * 360 / n) {
            square([d, 2 * d], true);
        }
    }
}
