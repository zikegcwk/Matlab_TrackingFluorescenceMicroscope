function g2tau=FCS_diff_poly(t,A,B,C,D,E,F)

%g2tau=1./(D.*t.^3+C.*t.^2+B.*t+A).^0.5;
g2tau=1./(F.*t.^5+E.*t.^4+D.*t.^3+C.*t.^2+B.*t+A).^0.5;

%g2tau=A.*t.^3+B.*t.^2+C.*t+D;
end

