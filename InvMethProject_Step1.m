%set up for 1 Hz data long (merged) sac files
clear
fclose('all');

comp='LHZ';
%eval(['!/bin/ls ./Longfiles/DR01-2015-year_',comp,'.sac | sort | uniq > list.all'])
eval(['!/bin/ls ./Longfiles/DR03-2016-0-xx_',comp,'.sac > list.all'])
%eval(['!/bin/ls ./Longfiles/DR02-201*-0-xx_',comp,'.sac >> list.all'])

!cat list.all | wc -l > list.num
fid1 = fopen('list.num');
fid2 = fopen('list.all');

i=1;
while 1
           tline = fgetl(fid2);
            if ~ischar(tline), break, end
            if i==1
            stnames=tline;
            else
                stnames=char(stnames,tline);
            end
            i=i+1;
        end
        fclose(fid2);

nstas=fscanf(fid1,'%d');
fclose(fid1);

for i=1:nstas
    H=figure(i);
    [sachdr,data]=load_sac(stnames(i,:));
    year=sachdr.nzyear;
    datestr_start=['01-01-',num2str(year)];
    d_start=datenum(datestr_start)+sachdr.nzjday-1;
    ndays_data=sachdr.npts/60/60/24;
    d_end=d_start+ndays_data;
    xl=[d_start,d_end];

    data=detrend(data);
    sensitivity = 5.038830e8;
    data=data/sensitivity;
    adata=diff([0;data]); %convert to acceleration (1 s/s)

    [b,a]=butter(2,0.5/50,'high');
    fdata=filter(b,a,data);
    fdata=cumsum(fdata); %convert fdata to displacement

    D=1; %Decimation Factor
    [month,day]=monthday(sachdr.nzyear,sachdr.nzjday);
    tzmin=datenum(sachdr.nzyear,month,day,sachdr.nzhour,sachdr.nzmin,sachdr.sec);
    tzmax=tzmin+length(adata)*sachdr.delta/(24*60*60);
    Td=linspace(tzmin,tzmax,length(adata));

    NW=1024;
    freqs=[];
    Ax=[110 130 1000 1200];
    set(H,'Position',Ax);
    [S,F,T,PSD]=spectrogram(detrend(fdata),hanning(NW),round(0.95*NW),freqs,1);
    F=F/sachdr.delta/D;
    medPSD=mean(PSD,2);
    [~,C]=size(PSD);
    PSDnorm=repmat(medPSD,1,C); %build a matrix for pre-event spectral normalization
    PSDdiff=PSD./PSDnorm; %normalize to get signal/noise PSD
    PSDsm=imgaussfilt(PSD,[3,11]); %smooth the PSD spectrograms a bit (quasi-Gaussian)    
    PSDdiffsm=PSDdiff;
    PSDdiffsm=imgaussfilt(PSDdiff,[3,11]);
    PSDlim=[-160 -80];

    h=subplot(6,1,1:2);
    imagesc(Td,F,10*log10(PSDdiffsm));
    xlim(xl)
    axis xy
    ylabel('F (Hz)')
    colormap("jet")
    ax=get(h,'Position');
    s=mean(std(10*log10(PSDdiffsm)));
    m=median(median(10*log10(PSDdiffsm+eps)));
    caxis([m-3*s m+3*s])
    hc=colorbar;
    set(get(hc,'label'),'string','PSD (dB rel. median)');
    tick_locations=[datenum(year,1,1:365),datenum(year+1,1,1:365)];
    set(gca,'XTick',tick_locations)
    datetick('x',6,'keeplimits', 'keepticks')
    xtickangle(90)
    set(h,'Position',ax)
    set(gcf,'units','normalized','position',[0.1300 0.1100 0.8 0.7])
   

    %PSDdiffsm
    data_lowerpixels = 10*log10(PSDdiffsm);
    lowerpixels = imresize(data_lowerpixels, [2376 2376]);
    filteredImage = medfilt2(lowerpixels, [1, 5]); % Adjust the filter size as needed

    h=subplot(6,1,3:4);
    imagesc(Td,F,filteredImage);
    xlim(xl)
    axis xy
    ylabel('F (Hz)')
    colormap("jet")
    ax=get(h,'Position');
    s=mean(std(10*log10(PSDdiffsm)));
    m=median(median(10*log10(PSDdiffsm+eps)));
    caxis([-10 10])
    hc=colorbar;
    set(get(hc,'label'),'string','PSD (dB rel. median)');
    tick_locations=[datenum(year,1,1:365),datenum(year+1,1,1:365)];
    set(gca,'XTick',tick_locations)      %x-axis ticks normal, inside
    datetick('x',6,'keeplimits', 'keepticks')
    set(h,'Position',ax)
    set(gcf,'units','normalized','position',[0.1300 0.1100 0.8 0.7])
    ylim([.03 .09])

hold on

    h=subplot(6,1,5:6);
    imagesc(Td,F,filteredImage);
    xlim(xl)
    axis xy
    ylabel('F (Hz)')
    colormap("jet")
    ax=get(h,'Position');
    s=mean(std(10*log10(PSDdiffsm)));
    m=median(median(10*log10(PSDdiffsm+eps)));
    caxis([-10 10])
    hc=colorbar;
    set(get(hc,'label'),'string','PSD (dB rel. median)');
    tick_locations=[datenum(year,1,1:365),datenum(year+1,1,1:365)];
    set(gca,'XTick', [])    %removes x-axis ticks
    datetick('x',6,'keeplimits', 'keepticks')
    set(h,'Position',ax)
    set(gcf,'units','normalized','position',[0.1300 0.1100 0.8 0.7])
    ylim([.03 .09])

end

% 1Jan to 8Apr = DR03_2016_0_LHZ, which is 99 days
% The matrix was resized to 2376 x 2376 so that each interval is 1 hr
% 99 days x 24 hours = 2376 hours
% the matrix was smoothed horizontally with medfilt2 [1, 5]





