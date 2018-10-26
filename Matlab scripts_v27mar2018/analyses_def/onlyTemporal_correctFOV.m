function new_data = onlyTemporal_correctFOV(original_data, new_movie)
% orginal data = original data structure
% new movie = 3d array

addpath(genpath('/home/calcium/Monica/linescan_project/code/ETIC/Pnevmatikakis, Paninski'));
curr_dir = pwd;
cd('/home/calcium/Monica/linescan_project/code/cvx');
cvx_setup;
cd(curr_dir);

if length(size(new_movie))==3
    new_movie2d = reshape(new_movie,[],size(new_movie,3));
else
    new_movie2d = new_movie';
end
Y = new_movie2d;
d1 = original_data.linesPerFrame; d2 = original_data.pixels_per_line;
CN = correlation_image(Y,8,d1,d2);

%transform select ROIs in a matrix format
A = fromManualToMatrix(original_data.rois_inside,original_data.roi,...
    original_data.pixels_per_line, original_data.linesPerFrame,...
    original_data.numero_neuronas);

if original_data.framePeriod > 5
    %extract raw fluorescence
    Fraw = zeros(size(A,2),size(Y,2));
    for ii=1:size(A,2)
        Fraw(ii,:) = mean(Y(find(A(:,ii)),:),1);
    end
    b = NaN*ones(size(Y,1),1);
    f = NaN*ones(1,size(Y,2));
    options.p = 2;
    C_sp = zeros(size(Fraw));
    S = zeros(size(Fraw));
    figure;
    for i = 1:size(Fraw,1)
        [C_sp(i,:),~,~,~,~,S(i,:)] = constrained_foopsi(Fraw(i,:),[],[],[],[],options);
        hold off; plot(zscore(Fraw(i,:)),'k');
        hold on; plot(zscore(C_sp(i,:)),'r');
        title(['ROI ', num2str(i), ' of ', num2str(size(Fraw,1))]);
        drawnow;
    end
    close
    
    [C_df,Df] = extract_DF_F(Y,A,C_sp,[],[]);
    P.p = options.p;
    
    
    new_data.numero_neuronas = original_data.numero_neuronas;
    new_data.Fraw = Fraw;
    new_data.A = A;
    % new_data.C = C;
    new_data.C_df = C_df;
    peaks = zeros(size(new_data.C_df)); %find C_df peaks
    for i = 1:size(peaks,1)
        [pks,locs] = findpeaks(new_data.C_df(i,:));
        peaks(i,locs) = pks;
    end
    % peaks(peaks<0.1)=0;
    new_data.peaks = peaks;
    if ~isempty(b)
        new_data.b = b;
    end
    new_data.f = f;
    new_data.S = S;
    new_data.P = P;
    if ~isempty(options)
        new_data.opt = options;
    else
        options.d1 = new_data.linesPerFrame;
        options.d2 = new_data.pixels_per_line;
        options.nrgthr = 1;
        new_data.opt = options;
    end
    
else
    
    %extract raw fluorescence
    Fraw = zeros(size(A,2),size(Y,2));
    for ii=1:size(A,2)
        Fraw(ii,:) = mean(Y(find(A(:,ii)),:),1);
    end
    
    w_bar = waitbar(0,'Estimating ROIs weights');
    %assign weights for each ROIs' pixel
    for ii=1:size(A,2)
        pixels = find(A(:,ii));
        A(pixels,ii) = CN(pixels).*(CN(pixels)>=0);
    end
    A = A/max(A(:));
    
    b = mean(Y,2);
    b = b/max(b);
    b = max(0,b-sum(A,2));
    
    waitbar(1/4,w_bar,'Extracting fluorescence');
    tic;
    [W,H,err] = nmf(Y,size(A,2)+1,[A,b],2,10);
    toc;
    waitbar(2/4,w_bar,'Fitting calcium model');
    F_demix = H(1:end-1,:);
    A = W(:,1:end-1);
    f = H(end,:);
    options.p =1;
    C_sp = zeros(size(F_demix));
    S = zeros(size(F_demix));
    figure;
    for i = 1:size(F_demix,1)
        [C_sp(i,:),~,~,~,~,S(i,:)] = constrained_foopsi(F_demix(i,:),[],[],[],[],options);
        hold off; plot(zscore(F_demix(i,:)),'k');
        hold on; plot(zscore(C_sp(i,:)),'r');
        title(['ROI ', num2str(i), ' of ', num2str(size(F_demix,1))]);
        drawnow;
    end
    close
    [C_df,~] = extract_DF_F(Y,A,C_sp,[],[]);
    P.p = options.p;
    
    
    waitbar(3/4,w_bar,'Saving results');
    
    new_data.numero_neuronas = original_data.numero_neuronas;
    new_data.Fraw = Fraw;
    new_data.A = A;
    % new_data.C = C;
    new_data.C_df = C_df;
    peaks = zeros(size(new_data.C_df)); %find C_df peaks
    for i = 1:size(peaks,1)
        [pks,locs] = findpeaks(new_data.C_df(i,:));
        peaks(i,locs) = pks;
    end
    % peaks(peaks<0.1)=0;
    new_data.peaks = peaks;
    if ~isempty(b)
        new_data.b = b;
    end
    new_data.f = f;
    new_data.S = S;
    new_data.P = P;
    if ~isempty(options)
        new_data.opt = options;
    else
        options.d1 = new_data.linesPerFrame;
        options.d2 = new_data.pixels_per_line;
        options.nrgthr = 1;
        new_data.opt = options;
    end
    waitbar(4/4,w_bar,'Done!');
    close(w_bar);
end

end


function A = fromManualToMatrix(rois_inside,rois_border,pixelsPerRow,...
    linePerFrame, numROIs)
%this function takes the pixels of each ROI and put them in a matrix
%format. The matrix A has N_pixels row and N_ROIs colums, where N_pixels is
%the number of pixels of the FOV and N_ROIs is the number of the detected
%ROIs. For each column, pixels belonging to the corresponding ROI have
%value 1, all other have value 0.
A = zeros(pixelsPerRow*linePerFrame,numROIs);
for i = 1:numROIs
    pixels_in = squeeze(rois_inside(i,:,:));
    pixels_bor = squeeze(rois_border(i,:,:));
    pixels_temp = [pixels_in, pixels_bor];
    pixels_temp(:,sum(pixels_temp,1)==0)=[];
    %     pixels_pos = (pixels_temp(1,:)-1)*pixelsPerRow + pixels_temp(2,:);
    pixels_pos = (pixels_temp(2,:)-1)*linePerFrame + pixels_temp(1,:);
    A(pixels_pos,i) = 1;
end
A(sum(A,1)==0,:)=[];
end

