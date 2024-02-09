function score_partition = calcul_score(y_pred, y)

    indices_1 = find(y_pred == 1);
    indices_2 = find(y_pred == 2);
    indices_3 = find(y_pred == 3);

    


    repartition= perms([1;2;3]);

    score = zeros(1,6);

    for i=1:size(repartition, 1)
        y_copie= y_pred;
        y_copie(indices_1) = repartition(i,1);
        y_copie(indices_2) = repartition(i,2);
        y_copie(indices_3) = repartition(i,3);

        score(i) = sum(y_copie==y);
    end

    score_partition = max(score)/length(y_pred);

    


end

