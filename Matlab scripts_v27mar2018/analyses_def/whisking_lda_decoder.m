function analyses = whisking_lda_decoder(data, analyses,  params)

if params.stimulus == 0
    stimulus_bin = data.whisking;
    [analyses.decoder.whisk.perc_correct,...
        analyses.decoder.whisk.perc_correct_singleROIs] = ...
        decoding_performance(data.C_df,...
        stimulus_bin);
else
end