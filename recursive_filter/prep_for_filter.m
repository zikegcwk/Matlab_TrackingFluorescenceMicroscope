function prep_for_filter(input_path, output_path);
sim_D_list = [linspace(0.001, 0.1, 20)];
dt = 0.05;

% Parameters defining the beam profile for the filter to assume
GammaL = 4;
GammaR = 1e9;
GammaB = 225;
P0 = 2000;
w0 = 0.5;
lambda = 0.532;

% Parameters defining the spatial grid for the filter to use
dr = 0.05;
dz = 0.1;
Rmax = 1.25;
Zmax = 3;

% Parameters defining the spatial region to define as the detection volume
rcyl = 0.3;
hcyl = 0.6;
focalind = focal_indices(dr, dz, Rmax, Zmax, rcyl, hcyl);

chdir(input_path);
u = dir;
a = {u.name};

for ii = 3:length(a),
    chdir(a{ii});
    load data;
    chdir('..');
    
    signal = atime2bin(t0, dt);
    
    D_list = sim_D_list; %[sim_D_list(1)];
    m_list = ones(size(sim_D_list));
    save(strcat(output_path, sprintf('/filter_input_%s', a{ii})), 'dt', 'signal', 'D_list', 'm_list', 'GammaL',...
                 'GammaB', 'GammaR', 'P0', 'w0', 'lambda', 'dr', 'dz', 'Rmax', 'Zmax', 'focalind');
end;
fprintf('All done.\n');
