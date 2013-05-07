function [P,maps] = ListPerms(p)

[P,maps] = ListPerms_([],p,[],[],1:length(p),[]);

function [P,maps] = ListPerms_(p1,p2,P,map1,map2,maps)
if length(p2) == 1,
    P = [P ; [p1 p2]];
    maps = [maps ; [map1 map2]];
else
    [labels,m] = unique(p2,'first');    
    for i = 1:length(labels),
        [P,maps] = ListPerms_([p1 p2(m(i))],[p2(1:m(i)-1) p2(m(i)+1:end)],P,...
                              [map1 map2(m(i))],[map2(1:m(i)-1) map2(m(i)+1:end)],maps);
    end
end