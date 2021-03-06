function analyses = Q_W_WL_lda_decoder(data, analyses, params)

if params.stimulus == 0
    [analyses.decoder.Q_W_WL.perc_correct,...
        analyses.decoder.Q_W_WL.perc_correct_singleROIs] = ...
        decoding_performance_n(data.C_df,...
        analyses.behavior.states_vector);
else
end