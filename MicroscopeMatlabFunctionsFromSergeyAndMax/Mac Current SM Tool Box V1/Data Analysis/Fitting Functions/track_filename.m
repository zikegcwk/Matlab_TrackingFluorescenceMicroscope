function output = track_filename(corename,track_filename)




%rawdatatoimport = '(donor_acceptor_defmlc)cascade101.102.103.104.105.106.107.108.109.110.111.112.113.114.115.(072308 P4P6 WT on PEG 20 mM Ba and 100 mM Na mM)(4).dat'; %(donor_acceptor_defmlc)
%tobeimported ='(kinetics_defmlc)cascade101.102.103.104.105.106.107.108.109.110.111.112.113.114.115.(072308 P4P6 WT on PEG 20 mM Ba and 100 mM Na mM)(4).dat'; %(kinetics_defmlc)

if track_filename==0
rawdatatoimport = strcat( '(donor_acceptor_defmlc)', corename);
tobeimported =    strcat( '(kinetics_defmlc)', corename);
else
    
rawdatatoimport = strcat( '(raw)', corename);
tobeimported =    strcat( '(kinetics)', corename);
  
    
end


output = {
    rawdatatoimport,
    tobeimported
};