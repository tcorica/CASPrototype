void setup()
{
  MathFunction foo = new ConstantFunction(9);
  foo = new ProductFunction(foo, new VariableFunction("x"));
  foo = new SumFunction(foo, new ConstantFunction(7));

  println(foo+"       foo(2) = "+foo.evaluate(2));
  println(foo.getDerivative()+"       foo'(2) = "+foo.getDerivative().evaluate(2));

  exit();
}
//=================================================
//=================================================
abstract class MathFunction
{
  final boolean suppress0and1 = true;  // Not implemented!

  abstract MathFunction getDerivative();
  abstract float evaluate(float x);
  abstract String toString();
}
//=================================================
class ConstantFunction extends MathFunction
{
  float myValue;

  ConstantFunction(float k)
  {
    myValue = k;
  }

  MathFunction getDerivative()
  {
    return new ConstantFunction(0);
  }

  float evaluate(float x)
  {
    return myValue;
  }

  String toString()
  {
    if (abs(myValue-round(myValue))<0.001) // suppress trailing zeros or nines
      return round(myValue)+"";
    else 
      return myValue+"";
  }
}
//=================================================
class VariableFunction extends MathFunction
{
  String myVariable;

  VariableFunction(String v)
  {
    myVariable = v;
  }

  MathFunction getDerivative()
  {
    return new ConstantFunction(1);
  }

  float evaluate(float x)
  {
    return x;
  }

  String toString()
  {
    return myVariable;
  }
}

//=================================================
class ProductFunction extends MathFunction
{
  MathFunction lhs, rhs;

  ProductFunction(MathFunction f1, MathFunction f2)
  {
    lhs = f1;
    rhs = f2;
  }

  MathFunction getDerivative()
  {
    // (f*g)' = f' * g + g' * f
    return new SumFunction(
    new ProductFunction(lhs.getDerivative(), rhs), 
    new ProductFunction(rhs.getDerivative(), lhs));
  }

  float evaluate(float x)
  {
    return lhs.evaluate(x)*rhs.evaluate(x);
  }

  String toString()
  {
    if (suppress0and1)
    {
      if (lhs.toString().equals("1"))
        return rhs.toString();
      else 
        if (lhs.toString().equals("0"))
        return "0";
    }

    return lhs.toString()+"*"+rhs.toString();
  }
}
//=================================================
class SumFunction extends MathFunction
{
  MathFunction lhs, rhs;

  SumFunction(MathFunction f1, MathFunction f2)
  {
    lhs = f1;
    rhs = f2;
  }

  MathFunction getDerivative()
  {
    // (f+g)' = f' + g'
    return new SumFunction(
    lhs.getDerivative(), 
    rhs.getDerivative());
  }

  float evaluate(float x)
  {
    return lhs.evaluate(x)+rhs.evaluate(x);
  }

  String toString()
  {
    if (suppress0and1)
    {
      if (lhs.toString().equals("0"))
        return rhs.toString();
      if (rhs.toString().equals("0"))
        return lhs.toString();
    }
    return lhs.toString()+"+"+rhs.toString();
  }
}

//=================================================
class PowerFunction extends MathFunction
{
  MathFunction lhs;
  int exponent;

  PowerFunction(MathFunction f1, int expon)
  {
    lhs = f1;
    exponent = expon;
  }

  MathFunction getDerivative()
  {
    return new ProductFunction(
    new ConstantFunction(exponent), 
    new PowerFunction(lhs, exponent-1));
  }

  float evaluate(float x)
  {
    return pow(lhs.evaluate(x),exponent);
  }

  String toString()
  {
    return lhs.toString()+"^"+exponent;
  }
}

