close all; clear all; clc
warning off;
addpath(genpath('ClusteringMeasure'));
addpath(genpath('utils'));
ResSavePath = 'Res/';
MaxResSavePath = 'maxRes/';

if(~exist(ResSavePath,'file'))
    mkdir(ResSavePath);
    addpath(genpath(ResSavePath));
end

if(~exist(MaxResSavePath,'file'))
    mkdir(MaxResSavePath);
    addpath(genpath(MaxResSavePath));
end

dataPath = './datasets/';
datasetName = {'MSRC_v1'};

for dataIndex = 1 : 1
    dataName = [dataPath datasetName{dataIndex} '.mat'];
    load(dataName);
    num_cluster = max(gt);
    [A_x, A_h, runtime1] = PreProcess(fea, num_cluster);
    ResBest = zeros(1, 8);
    ResStd = zeros(1, 8);
    % parameters setting
    r1 = 0 : 0.05 : 1;
    acc = zeros(length(r1), 1);
    nmi = zeros(length(r1), 1);
    purity = zeros(length(r1), 1);
    idx = 1;
    for r1Index = 1 : length(r1)
        r1Temp = r1(r1Index);
        fprintf('Please wait a few minutes\n');
        disp(['Dataset: ', datasetName{dataIndex}, ...
            ', --r1--: ', num2str(r1Temp)]);
        tic;
        [H_star, F, A_star, Obj] = UOMvSC(A_x, A_h, num_cluster, r1Temp);
        [~ , label] = max(F, [], 2);
        res = zeros(2, 8);
        res(1,:) = Clustering8Measure(gt, label);
        Runtime(idx) = toc;
        disp(['runtime: ', num2str(Runtime(idx))]);
        idx = idx + 1;
        tempResBest(1, : ) = res(1, : );
        tempResStd(1, : ) = res(2, : );
        acc(r1Index, 1) = tempResBest(1, 7);
        nmi(r1Index, 1) = tempResBest(1, 4);
        purity(r1Index, 1) = tempResBest(1, 8);
        resFile = [ResSavePath datasetName{dataIndex}, '-ACC=', num2str(tempResBest(1, 7)), ...
            '-r1=', num2str(r1Temp), '.mat'];
        save(resFile, 'tempResBest', 'tempResStd');
        for tempIndex = 1 : 8
            if tempResBest(1, tempIndex) > ResBest(1, tempIndex)
                if tempIndex == 7
                    newH = H_star;
                    newF = F;
                    newA = A_star;
                    newObj = Obj;
                end
                ResBest(1, tempIndex) = tempResBest(1, tempIndex);
                ResStd(1, tempIndex) = tempResStd(1, tempIndex);
            end
        end
    end
    aRuntime = mean(Runtime) + runtime1;
    resFile2 = [MaxResSavePath datasetName{dataIndex}, '-ACC=', num2str(ResBest(1, 7)), '.mat'];
    save(resFile2, 'ResBest', 'ResStd', 'acc', 'nmi', 'purity', 'aRuntime', 'gt', ...
        'newH', 'newF', 'newA', 'newObj');
    resFile3 = [MaxResSavePath datasetName{dataIndex}, '.mat'];
    save(resFile3, 'ResBest', 'ResStd', 'acc', 'nmi', 'purity', 'aRuntime', 'gt', ...
        'newH', 'newF', 'newA', 'newObj');
end