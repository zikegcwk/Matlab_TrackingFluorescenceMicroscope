function [output] = AppendCovMatsToHMMFitOutput(output,x,cov_mats_string)
A = output.A;
E = output.E;
fitChannelType = output.fitChannelType;

cov_mats_string = AddParensForRegExp(cov_mats_string);
paramsToTry = regexp(cov_mats_string,'(?<={)[^{}]*(?=})','match');
if isempty(paramsToTry),
    output.covmats = [];
else
    n = length(paramsToTry);
    covmats = cell([0 0]);

    confInt = 0.3;
    % boundsMeshSize = 3;
    auto_MeshSpacing = 'square';

    %get confidence regions

    % coordsMeshSize = 4;
    logPxMax = LogPxWith_E_(A,E,fitChannelType,x);
    for i = 1:length(paramsToTry),
        varsstr = regexp(paramsToTry{i},'[ae]\(\d*(,\d*)*\)','match');

        coordsMeshSize = 4;

        numParams = length(varsstr);

        coordsGrid = cell([numParams 1]);
        var_regions = cell([numParams 1]);
        
        try

            for j = 1:numParams,  
                covmats{i}.varnames{j} = varsstr{j};
                if strcmp(varsstr{j}(1),'a'),
                    [r,c] = GetNumsFromString_(varsstr{j});
                    var_regions{j} = GetConfRegionSizeA_(r,c,A,E,fitChannelType,confInt,x,coordsMeshSize,auto_MeshSpacing);
                    coordsGrid{j} = var_regions{j};
                elseif strcmp(varsstr{j}(1),'e'),
                    [n,c,p] = GetNumsFromString_(varsstr{j});
                    var_regions{j} = GetConfRegionSizeE_(n,c,p,A,E,fitChannelType,confInt,x,coordsMeshSize,auto_MeshSpacing);
                    coordsGrid{j} = var_regions{j};
                end
                repVec = [1 (coordsMeshSize)];
                for k = 1:numParams-1,
                    coordsGrid{j} = repmat(coordsGrid{j},repVec);
                    repVec = [1 repVec];
                end
                if strcmp(varsstr{j}(1),'a'),
                    coordsGrid{j} = shiftdim(coordsGrid{j},j-1) - A(r,c);
                elseif strcmp(varsstr{j}(1),'e'),  
                    coordsGrid{j} = shiftdim(coordsGrid{j},j-1) - E{n,c}(p);
                end
        %         keyboard
            end   
        %     keyboard

            coords = zeros(numel(coordsGrid{1}),numParams);
            yvalues = zeros(size(coords,1),1);
            beta0 = zeros(1,((numParams)^2 + numParams)/2); %initial guess for covariance parameters
            for i2 = 1:size(coords,1),
                Atry = A;
                Etry = E;
                for j = 1:numParams,
                    coords(i2,j) = coordsGrid{j}(i2);
                    if strcmp(varsstr{j}(1),'a'),
                        [r,c] = GetNumsFromString_(varsstr{j});
                        Atry(r,c) = A(r,c) + coordsGrid{j}(i2);
                    elseif strcmp(varsstr{j}(1),'e'),
                        [n,c,p] = GetNumsFromString_(varsstr{j});
                        Etry{n,c}(p) = E{n,c}(p) + coordsGrid{j}(i2);
                    end
                end
                Atry = Atry - diag(diag(Atry)) + (eye(size(A,1)) - diag(sum(Atry - diag(diag(Atry)),2)));
                yvalues(i2) = exp(LogPxWith_E_(Atry,Etry,fitChannelType,x)-logPxMax);
            %     sum(Atry,2)
            %     pause
            end

            coords(end+1,:) = zeros(1,size(coords,2)); %point at origin
            yvalues(end+1) = 1; %exp(LogPxWith_es_(A,e)-logPxMax);
        %     [coords yvalues]
        %     figure,hist(yvalues)
        %     title('here')

            beta0 = zeros(1,(numParams^2 + numParams)/2); %initial guess for covariance parameters
            ix = 1;
            for i2 = 1:numParams,
                if strcmp(varsstr{i2}(1),'a'),
                    [r,c] = GetNumsFromString_(varsstr{i2});
                    beta0(ix) = var_regions{i2}(end) - A(r,c);
                elseif strcmp(varsstr{j}(1),'e'),
                    [n,c,p] = GetNumsFromString_(varsstr{i2});
                    beta0(ix) = var_regions{i2}(end) - E{n,c}(p);
                end
                ix = ix + numParams - (i2 - 1);
            end
            betaFit = nlinfit(coords,yvalues,@MultiNormWithBetavecMaxOne_v3,beta0);
            L = BetaToL(betaFit);
            C = L*L';
            covmats{i}.C = C;
            %keyboard
        catch
            disp('warning: covariance matrix fit crashed');
            covmats{i}.varnames{1} = '';
            covmats{i}.C = [];
        end
        end
    end
    output.covmats = covmats;
end