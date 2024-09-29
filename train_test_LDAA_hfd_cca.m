function [avg_accuracy_treen,...
    avg_accuracy_ldan,avg_accuracy_n_bn]=train_test_LDAA_hfd_cca(an,label,n_events)
k = 5;
for i=1:1:3
    % Randomly shuffle the events and their labels
    idx = randperm(n_events);
    an_shuffled = an(idx,:);
    label_shuffled = label(idx);

    % Perform fivefold cross-validation

    for fold = 1:k
        % Split data into training and testing sets
        test_indices = ((fold - 1) * floor(n_events / k) + 1) : (fold * floor(n_events / k));
        train_indices = setdiff(1:n_events, test_indices);

        train_datan = an_shuffled(train_indices,:);
        train_labels = label_shuffled(train_indices);
        test_datan = an_shuffled(test_indices,:);
        test_labels = label_shuffled(test_indices);

        % Train your model on the training data

        fitn_tree=fitctree(train_datan, train_labels);
        fitn_lda=fitcdiscr(train_datan, train_labels);
        fitn_nb=fitcnb(train_datan, train_labels,'DistributionNames','normal');

        n_test_events=length(test_labels);

        CLASS=predict(fitn_tree,test_datan);
        acc=length(find(test_labels == CLASS'))/n_test_events;
        accuracy_trn(fold) = acc*100;

        CLASS=predict(fitn_lda,test_datan);
        acc=length(find(test_labels == CLASS'))/n_test_events;
        accuracy_ldan(fold) = acc*100;

        CLASS=predict(fitn_nb,test_datan);
        acc=length(find(test_labels == CLASS'))/n_test_events;
        accuracy_nbn(fold) = acc*100;

    end
        
        avg_accuracy_t_reen(i) = mean(accuracy_trn);
        avg_accuracy_l_ldan(i) = mean(accuracy_ldan);
        avg_accuracy_n_ban(i) = mean(accuracy_nbn);

  end
    

avg_accuracy_treen = mean(avg_accuracy_t_reen);
avg_accuracy_ldan = mean(avg_accuracy_l_ldan);
avg_accuracy_n_bn = mean(avg_accuracy_n_ban);

end
