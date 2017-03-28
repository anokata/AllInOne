public final class ComplexNumber {
    private final double re;
    private final double im;
    
    public int hashCode() {
        Double r = new Double(re);
        Double m = new Double(im);
        return r.hashCode() + m.hashCode();   
    }
    
    public boolean equals(Object x) {
        if (this == x) return true;
        if (x instanceof ComplexNumber) {
            ComplexNumber y = (ComplexNumber) x;
            return (Double.compare(y.re, this.re) == 0 && Double.compare(y.im, this.im) == 0);
        }
        return false;
    }

    public ComplexNumber(double re, double im) {
        this.re = re;
        this.im = im;
    }

    public double getRe() {
        return re;
    }

    public double getIm() {
        return im;
    }
}
