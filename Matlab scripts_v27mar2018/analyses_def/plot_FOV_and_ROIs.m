function [] = plot_FOV_and_ROIs(data,params)

    %plot whisking informative ROIs
    d1 = size(data.corr_projection,2);
    d2 = size(data.corr_projection,1);
    xFOV = 1:1:d1; xFOV = xFOV*params.mm_px;
    yFOV = 1:1:d2; yFOV = yFOV*params.mm_px;
    imagesc(xFOV,yFOV,data.corr_projection); colormap('gray'); axis image;
%     hold on; plot_contours_monocromatic(exp.data.A,exp.data.corr_projection,[],1); %set the last input value to 0 if you don't want numbers
    for i = 1:params.numROIs
        ROImask = reshape(data.A(:,i)>0,size(data.corr_projection));
        ROImask_fill = imfill(ROImask,'holes');
        hold on;
        contour(xFOV,yFOV,ROImask_fill,'r');
        [yy,xx] = ind2sub(size(data.corr_projection),find(ROImask_fill));
        text(round(min(xx)*params.mm_px),round(mean(yy)*params.mm_px),num2str(i),'color',[1,1,1],'fontsize',12,'fontweight','bold');

    end
    set(gca,'XTick',[],'YTick',[]);