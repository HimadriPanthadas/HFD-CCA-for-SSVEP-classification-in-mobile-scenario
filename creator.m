function EPO_NEWW=creator(EPO,starte)
%% Generating Filtered Signals
fs=100;
%FILTER
x=starte;
passband = [x+3,97];
stopband = [x, 99];
[N, Wn]=cheb1ord(passband/fs, stopband/fs, 3, 40);
[B, A] = cheby1(N, 0.5, Wn);

freq = [11 7 5];  % [11 7 5] 5.45, 8.75, 12  [17 11 7 5]
fs = 100;
window_time = 5;

t = [1/fs:1/fs:window_time];

% ground truth
Y=cell(1);
for i=1:size(freq,2)
    Y{i}=[sin(2*pi*60/freq(i)*t);cos(2*pi*60/freq(i)*t);sin(2*pi*2*60/freq(i)*t);cos(2*pi*2*60/freq(i)*t)];
end
EPO_NEWW=EPO;
%%
nSub=23;
chan = {'PO7','PO3','POz','PO4','PO8','O1','Oz','O2'};
%chan = {'L1','L2','L4','L5','L6','L7','L9','L10','R1','R2','R4','R5','R7','R8'}; 

for subNum = 1:(nSub)

    
    for ispeed = 2:sum(~cellfun('isempty', EPO(subNum,:)))+1
        % channel select
        epo_neww = EPO_NEWW{subNum,ispeed};
        epo_neww = proc_selectChannels(epo_neww, chan);
        q=size(epo_neww.x);
        for i=1:size(chan,2)
            for j=1:q(3)
                epo_neww.x(:,i,j)=filtfilt(B, A, epo_neww.x(:,i,j)');
            end
        end
        EPO_NEWW{subNum,ispeed}=epo_neww;
    end
end
