using LMBMinterface

"""
min f(x) x in R^n

f is nonsmooth function
g is a subgradient of f
"""

function testFun(n::Cint,xp::Ptr{Cdouble},gp::Ptr{Cdouble})
  x=unsafe_wrap(Array,xp,(convert(Int, n),));
  g=unsafe_wrap(Array,gp,(convert(Int, n),));

  f = 0.0;
  g[1] = 0.0;

  for i=1:n-1
    g[i+1] = 0.0;
    a = -x[i]-x[i+1];
    b = -x[i]-x[i+1]+(x[i]*x[i]+x[i+1]*x[i+1]-1.0);

    if (a >= b)
      f = f+a;
      g[i] = g[i]-1.0;
      g[i+1] = -1.0;
    else
      f = f+b;  
      g[i] = g[i]-1.0+2.0*x[i];
      g[i+1] = -1.0+2*x[i+1];
    end
  end
  return(convert(Cdouble,f))
end


x=randn(100);
optval,optsol=LMBMinterface.lmbm(testFun,x;printinfo=true,tol=1e-5)
