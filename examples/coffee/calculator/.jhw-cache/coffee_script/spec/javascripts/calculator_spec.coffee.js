(function() {

  describe("Calculator", function() {
    beforeEach(function() {
      return this.calculator = new Calculator();
    });
    it("is not in scientific mode by default", function() {
      return expect(this.calculator).not.toBeScientific();
    });
    describe("scientific mode", function() {
      beforeEach(function() {
        return this.calculator = new Calculator(true);
      });
      return it("is in scientific mode when set", function() {
        return expect(this.calculator).toBeScientific();
      });
    });
    describe("#add", function() {
      return it("adds two numbers", function() {
        return expect(this.calculator.add(1, 1)).toEqual(2);
      });
    });
    describe("#substract", function() {
      return it("substracts two numbers", function() {
        return expect(this.calculator.substract(10, 1)).toEqual(9);
      });
    });
    describe("#multiply", function() {
      return it("multiplies two numbers", function() {
        return expect(this.calculator.multiply(5, 4)).toEqual(20);
      });
    });
    return describe("#divide", function() {
      return it("divides two numbers", function() {
        return expect(this.calculator.divide(20, 5)).toEqual(4);
      });
    });
  });

}).call(this);
