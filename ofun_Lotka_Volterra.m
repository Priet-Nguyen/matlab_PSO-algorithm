% ## Copyright (C) 2022 Lenovo
% ##
% ## This program is free software: you can redistribute it and/or modify
% ## it under the terms of the GNU General Public License as published by
% ## the Free Software Foundation, either version 3 of the License, or
% ## (at your option) any later version.
% ##
% ## This program is distributed in the hope that it will be useful,
% ## but WITHOUT ANY WARRANTY; without even the implied warranty of
% ## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% ## GNU General Public License for more details.
% ##
% ## You should have received a copy of the GNU General Public License
% ## along with this program.  If not, see <https://www.gnu.org/licenses/>.
% 
% ## -*- texinfo -*-
% ## @deftypefn {} {@var{retval} =} ofun_Lotka_Volterra (@var{input1}, @var{input2})
% ##
% ## @seealso{}
% ## @end deftypefn
% 
% ## Author: Lenovo <Lenovo@DESKTOP-UASQ1D3>
% ## Created: 2022-10-30

function [f,sum_c] = ofun_Lotka_Volterra(x)
  %denom=(x(4)*x(7)*x(8)+x(5)*x(6)*x(9));
  c0=[];
  c=[];
  % objective function (min)
  %of=(-x(1)*x(6)*x(9)-x(2)*x(4)*x(8)+x(3)*x(4)*x(6))^2/(x(4)*x(7)*x(8)+x(5)*x(6)*x(9))^2;
  of= 
  % constraints type <=0
  c0(1)=x(9)-x(7);
  c0(2)=-(x(1)*x(7)*x(9)-x(2)*x(5)*x(9)-x(3)*x(4)*x(7))/(x(4)*x(7)*x(8)+x(5)*x(6)*x(9));
  c0(3)=-(-x(1)*x(7)*x(8)+x(2)*x(5)*x(8)-x(3)*x(5)*x(6))/(x(4)*x(7)*x(8)+x(5)*x(6)*x(9));
  c0(4)=-(-x(1)*x(6)*x(9)-x(2)*x(4)*x(8)+x(3)*x(4)*x(6))/(x(4)*x(7)*x(8)+x(5)*x(6)*x(9));
  c0(5)=x(4)+x(6);
  c0(6)=x(8)-x(5);

  %Pxeq=(x(1)*x(7)*x(9)-x(2)*x(5)*x(9)-x(3)*x(4)*x(7))/denom
  %defining pernalty for each constraints
  for i=1:length(c0)
    if c0(i)>0
      c(i)=1;
    else
      c(i)=0;
    end
  end

pernalty=10000;
sum_c=sum(c);
f=of+pernalty*sum(c);
end
