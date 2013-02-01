void setup()
{
  coricaTest();
  jiehanTest();
  exit();
}

void jiehanTest()
{
  MathFunction foo = new VariableFunction("x");
  foo = new PowerFunction(foo, 3);
  foo = new SumFunction(new ConstantFunction(10), foo);
  foo = new ProductFunction(foo, new VariableFunction("x"));

  println(foo+"       foo(2) = "+foo.evaluate(2));
  println(foo.getDerivative()+"       foo'(2) = "+foo.getDerivative().evaluate(2));
}

void coricaTest()
{
  MathFunction foo = new ConstantFunction(3);
  foo = new SumFunction(foo, new ConstantFunction(4));
  foo = new ProductFunction(foo, new ConstantFunction(5));
  println("(3+4)*5: "+foo+" = "+foo.evaluate(0));

  foo = new ConstantFunction(3);
  foo = new ProductFunction(foo, new SumFunction(new ConstantFunction(4), new ConstantFunction(5)));
  println("3*(4+5): "+foo+" = "+foo.evaluate(0));
}

//=================================================
//=================================================
abstract class MathFunction
{
  final boolean suppress0and1 = false;

  abstract MathFunction getDerivative();
  abstract float evaluate(float x);
  abstract String toString();
  byte myOoo = 0;

  String parenthesize(MathFunction mf, byte Ooo) {
    if ( mf.myOoo >= Ooo )
    {
      return "("+mf.toString()+")";
    } 
    else {
      return mf.toString();
    }
  }
}
//=================================================
class ConstantFunction extends MathFunction
{
  float myValue;

  ConstantFunction(float k)
  {
    myOoo = 0;
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
    myOoo = 0;
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
    myOoo = 3;
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

    return parenthesize(lhs, myOoo)+"*"+parenthesize(rhs, myOoo);
  }
}
//=================================================
class SumFunction extends MathFunction
{
  MathFunction lhs, rhs;

  SumFunction(MathFunction f1, MathFunction f2)
  {
    myOoo = 4;
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

    return parenthesize(lhs, myOoo)+"+"+parenthesize(rhs, myOoo);
  }
}

//=================================================
class PowerFunction extends MathFunction
{
  MathFunction base;
  int exponent;

  PowerFunction(MathFunction f1, int expon)
  {
    myOoo = 2;
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
    return parenthesize(base, myOoo)+"^"+exponent;
  }
}

