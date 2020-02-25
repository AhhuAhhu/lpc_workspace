$wave_path = 'wav\\';
$raw_path = 'raw\\';
$pitch_path = 'pitch\\';
$lpc_path = 'lpc\\';
$lpctxt_path = 'lpctxt\\';
$lpc_syn_wav_path = 'lpcWav\\';


opendir wavp, $wave_path;
@waves = readdir(wavp);
foreach $wavname(@waves)
{
if($wavname eq "." || $wavname eq "..")
{next;}
$real_name = "$wavname";
$real_name =~ s/\.wav//;
printf "$real_name\n" ;


#read wave and remove the header
open wav_file, "$wave_path$real_name.wav" or die "$!";
binmode(wav_file);
read(wav_file, $buf, 12);
$file_head_bin = $buf;
($class_type, $chunk_size, $file_type) = unpack('a4La4',$buf);
read(wav_file, $buf, 24);
$format_chunk_info_bin = $buf;
@format_chunk_info = unpack('a4LS2L2S2', $buf);


$tool_path = 'C:\Users\Administrator\Desktop\ΆΰΓ½Με\02-lpc_homework\lpc_homework\lpc_workspace\\sptk3.1';
$frame_len = 512;
$frame_shift = 80;
$sample_rate_k = 16;
$para_order = 20;


$pitch_file_name = "$pitch_path$real_name.pitch";
$lpc_file_name = "$lpc_path$real_name.lpc";


#synthesis lpc voice
system("$tool_path\\excite -p $frame_shift $pitch_file_name | $tool_path\\poledf -m $para_order -p $frame_shift $lpc_file_name > tmp.lpc.syn");
system("$tool_path\\x2x +fs < tmp.lpc.syn > tmp.lpc.syn.short");


#write lpc synthesis wav
$tmp_file = "tmp.lpc.syn.short";
$raw_syn_size = -s "$tmp_file";
#printf $raw_syn_size,"\n";
open syn_short_file, "< $tmp_file" or die "$!";
binmode(syn_short_file);
$lpc_syn_wav = "$lpc_syn_wav_path$real_name.wav";
open syn_wav_file, ">$lpc_syn_wav" or die "$!";
binmode(syn_wav_file);
$data_chunk_info_bin = pack('a4L', 'data', $raw_syn_size);
$file_head_bin = pack('a4La4', 'RIFF', $raw_syn_size + 8 + 24 + 4, 'WAVE');
print syn_wav_file $file_head_bin, $format_chunk_info_bin, $data_chunk_info_bin;
read(syn_short_file, $buf, $raw_syn_size);
print syn_wav_file $buf;
close syn_short_file;
close syn_wav_file;
system("del tmp.lpc.syn");
system("del tmp.lpc.syn.short");
}
closedir wavp;