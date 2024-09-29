% Event-60, channels- 73, ear channels-14, total number of windows=500

% CCA based classifier
ACC_all_2 = [];  
mean_AUC_2=[]; 
ACC_all_2_fin=[]; 

% Generating Compared Signals
freq = [11 7 5];  % [11 7 5] 5.45, 8.75, 12  [17 11 7 5]
fs = 100;
window_time = 5;

t = [1/fs:1/fs:window_time];

% Ground truth
Y = cell(1);
for i=1:size(freq,2)
    Y{i} = [sin(2*pi*60/freq(i)*t); cos(2*pi*60/freq(i)*t); sin(2*pi*2*60/freq(i)*t); cos(2*pi*2*60/freq(i)*t)];
end

%% Selected channels
chan = {'PO7','PO3','POz','PO4','PO8','O1','Oz','O2'};



nSub = 23;
k = 0;
bp=9; %starting frequency of the passband
for x = bp:1:bp
    
    k = k + 1; % indicator of value of x
    EPO_NEWW = creator(EPO, x);
    for subNum = 1:nSub
        
        for ispeed = 2:5
            % channel select

            a_epo2 = EPO_NEWW{subNum, ispeed};            
            if size(a_epo2) ~= 0
                a_epo2 = proc_selectChannels(a_epo2, chan);

                
                % one-hot decoding
                a_epo2.y_dec = double(onehotdecode(a_epo2.y, [1, 2, 3], 1));
                
                nTrial = size(a_epo2.y, 2);

                r2_corr = [];
                r2 = [];

                for i = 1:nTrial
                    r2_dump = [];
                    for j = 1:size(freq,2)
                        [~,~, r2_corr{j}] = canoncorr(a_epo2.x(:,:,i), Y{j}');
                        r2_dump = [r2_dump mean(r2_corr{j})];

                    end
                    r2(i,:) = r2_dump;

                end
                
                [acc_tr2,acc_lda2,acc_nb2] = train_test_LDAA_hfd_cca(r2, a_epo2.y_dec, nTrial);
           
                ACC_all_tr2(ispeed, subNum) = acc_tr2;
                ACC_all_nb2(ispeed, subNum) = acc_nb2;
                ACC_all_lda2(ispeed, subNum) = acc_lda2;

            end
        end
        
        % Average Accuracy per Speed
        for ispeed = 2:5

            mean_AUC_tr2(ispeed) = sum(ACC_all_tr2(ispeed,:)) / nnz(ACC_all_tr2(ispeed,:));
            mean_AUC_lda2(ispeed) = sum(ACC_all_lda2(ispeed,:)) / nnz(ACC_all_lda2(ispeed,:));
            mean_AUC_nb2(ispeed) = sum(ACC_all_nb2(ispeed,:)) / nnz(ACC_all_nb2(ispeed,:));    
        end

    end
end

% Define the speeds
speeds = [0, 0.8, 1.6, 2];

% Print the results for each variable
fprintf('Speeds: %.1f %.1f %.1f %.1f\n', speeds);
fprintf('mean_Acc_local_discriminant_analysis: %.2f %.2f %.2f %.2f\n', mean_AUC_lda2(2:end));
fprintf('mean_Acc_naive_bayes: %.2f %.2f %.2f %.2f\n', mean_AUC_nb2(2:end));
fprintf('mean_Acc_tree: %.2f %.2f %.2f %.2f\n', mean_AUC_tr2(2:end));
