function [results] = withinTrialDP(e, binWidth,winLength, beforeSignal, afterSignal,shuffNum)
 
% Main algorithm for computing detect probability from temporal
% correlations and mutual information

for s = 1:47
    
%Pre-allocate matrices
tic
sessionNum = s;
trialHitCount = 0;  trialMissCount = 0;
    for ti = 1 : length(e(sessionNum).t)
        t = e(sessionNum).t(ti);
        if ~isempty(t.mu1)
            if strcmp(t.eot, 'c')
                trialHitCount = trialHitCount + 1;
            elseif strcmp(t.eot, 'f')
                 trialMissCount = trialMissCount + 1;
            end
        end
    end
    
    mu1SignalH = nan(trialHitCount, winLength);
    mu2SignalH = nan(trialHitCount, winLength);
    
    mu1SignalM = nan(trialMissCount, winLength);
    mu2SignalM = nan(trialMissCount, winLength);

    
    counterH = 0;  counterM = 0;
    for ti = 1 : length(e(sessionNum).t)
        t = e(sessionNum).t(ti);
        if ~isempty(t.mu1) && nansum(t.mu1)>0 && (strcmp(t.eot, 'c') || strcmp(t.eot, 'f'))
            
               mu1 = double(t.mu1);
               mu2 = double(t.mu2);
               
               mu1Filtered = gaussFilterSpikes(double(t.mu1), binWidth);
               mu2Filtered = gaussFilterSpikes(double(t.mu2), binWidth);

            if strcmp(t.eot, 'c') && ~isempty(t.mu1) && nansum(t.mu1)>0
                
                counterH = counterH + 1;
                
                mu1SignalH(counterH, :) = cutOut(mu1Filtered, t.signalOn, beforeSignal+winLength-1, afterSignal);
                mu2SignalH(counterH, :) = cutOut(mu2Filtered, t.signalOn, beforeSignal+winLength-1, afterSignal);
                 mu1H(counterH, :) = cutOut(mu1Filtered, t.signalOn, beforeSignal+winLength-1, afterSignal);
                mu2H(counterH, :) = cutOut(mu2Filtered, t.signalOn, beforeSignal+winLength-1, afterSignal);
                
                mu1SignalH(counterH, :) = detrend(mu1SignalH(counterH, :));
                mu2SignalH(counterH, :) = detrend(mu2SignalH(counterH, :));
                
                
                corrH(counterH,:) = nancorr(mu1SignalH(counterH, :),mu2SignalH(counterH, :));
                miH(counterH,:) = average_mutual_information(mu1SignalH(counterH, :),mu2SignalH(counterH, :));
                
            elseif strcmp(t.eot, 'f') && ~isempty(t.mu1) && nansum(t.mu1)>0
                
               
                counterM = counterM + 1;
                  mu1M(counterM, :) = cutOut(mu1Filtered, t.signalOn, beforeSignal+winLength-1, afterSignal);
                 mu2M(counterM, :) = cutOut(mu2Filtered, t.signalOn, beforeSignal+winLength-1, afterSignal);   
                
                mu1SignalM(counterM, :) = cutOut(mu1Filtered, t.signalOn, beforeSignal+winLength-1, afterSignal);
                mu2SignalM(counterM, :) = cutOut(mu2Filtered, t.signalOn, beforeSignal+winLength-1, afterSignal);
                mu1SignalM(counterM, :) = detrend(mu1SignalM(counterM, :));
                mu2SignalM(counterM, :) = detrend(mu2SignalM(counterM, :));
                
                
                corrM(counterM,:) = nancorr(mu1SignalM(counterM, :),mu2SignalM(counterM, :));
                miM(counterM,:) = average_mutual_information(mu1SignalM(counterM, :),mu2SignalM(counterM, :));
            
            end
        end
    end
    
   

end

clearvars -except e results

end
