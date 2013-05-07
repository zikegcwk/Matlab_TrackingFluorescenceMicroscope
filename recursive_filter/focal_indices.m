function focalind = focal_indices(dr, dz, Rmax, Zmax, rcyl, hcyl);
% dr and dz are the grid sizes in the radial and axial dimensions
% Rmax and Zmax are the radial and axial limits
% rcyl is the radius of the cylindrical focal volume
% 2*hcyl is the height of the cylindrical focal volume.

r_range = dr:dr:Rmax;

sum_indices = [];
r_max_ind = max(find(r_range <= rcyl));

for zz = 1:length(0 : dz : Zmax),
    z = dz * (zz-1);
%     if z^2 / b^2 + dr^2 / a^2 <= 1,
%         r_max_z = sqrt( a^2 * (1 - z^2 / b^2) );
%         r_max_ind = max(find(r_range < r_max_z));
%         sum_indices(end+1:end+r_max_ind) = length(r_range) * (zz - 1) + ((1:r_max_ind)-1);
%     end;
    if z <= hcyl & z >= -hcyl,
        sum_indices(end+1:end+r_max_ind) = length(r_range) * (zz - 1) + ((1:r_max_ind) - 1);
    end;
end;

focalind = sum_indices;

return;