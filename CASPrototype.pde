void setup()
{
  // MathFunction foo = new VariableFunction("x");
  // foo = new PowerFunction(foo, 3);
  // foo = new ProductFunction(new ConstantFunction(10), foo);
  // foo = new SumFunction(foo, new VariableFunction("x"));

  MathFunction foo = new VariableFunction("x");
  foo = new PowerFunction(foo, 3);
  foo = new SumFunction(new ConstantFunction(10), foo);
  foo = new ProductFunction(foo, new VariableFunction("x"));

  println(foo+"       foo(2) = "+foo.evaluate(2));
  println(foo.getDerivative()+"       foo'(2) = "+foo.getDerivative().evaluate(2));

  exit();
}


String parenthesize(MathFunction mf, byte myOoo) {
  if ( mf.getOoo() >= myOoo )
  {
    return "("+mf.toString()+")";
  } else {
    return mf.toString();
  }
}

//=================================================
//=================================================
abstract class MathFunction
{
  final boolean suppress0and1 = false; //true;

  abstract MathFunction getDerivative();
  abstract float evaluate(float x);
  abstract String toString();
  abstract byte getOoo();
}
//=================================================
class ConstantFunction extends MathFunction
{
  float myValue;
  
  byte getOoo()
  {
    return 0;
  }

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

  byte getOoo()
  {
    return 0;
  }

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

  byte getOoo()
  {
    return 3;
  }

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

    return parenthesize(lhs, getOoo())+"*"+parenthesize(rhs, getOoo());
  }
}
//=================================================
class SumFunction extends MathFunction
{
  MathFunction lhs, rhs;

  byte getOoo()
  {
    return 4;
  }

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
    
    return parenthesize(lhs, getOoo())+"+"+parenthesize(rhs, getOoo());
  }
}

//=================================================
class PowerFunction extends MathFunction
{
  MathFunction base;
  int exponent;

  byte getOoo()
  {
    return 2;
  }

  PowerFunction(MathFunction f1, int expon)
  {
    base = f1;
    exponent = expon;
  }

  MathFunction getDerivative()
  {
    return new ProductFunction( 
    new ProductFunction(
    new ConstantFunction(exponent), 
    new PowerFunction(base, exponent-1)), 
    base.getDerivative()
      );
  }

  float evaluate(float x)
  {
    return pow(base.evaluate(x), exponent);
  }

  String toString()
  {
    return parenthesize(base, getOoo())+"^"+exponent;
  }
}

