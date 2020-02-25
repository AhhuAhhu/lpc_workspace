function [] = write2lpc(filename, var)

fid=fopen(filename, 'w');
fprintf(fid, '%g\n', var);
fclose(fid);
