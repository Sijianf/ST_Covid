# Spatial Temporal Analysis of COVID Data (ST_Covid_project)

This project focuses on spatial temporal analysis of COVID-19 data. We have developed a series of basic models to illustrate the differences in their assumptions and outcomes. All models operate under the assumption that the high-level mean is the sum of low-level means: 
$$\mu^H = \sum_{i=1}^{M} \mu_i^L$$

| Model | Features |
| ------------ | ------------ |
| **Model 0 (Basic model)** | No cumulative counts as covariates; No cross-level random effects |
| **Model 1** | No cumulative counts as covariates; Added cross-level random effects |
| **Model 2** | Added cumulative counts as covariates ${}^*$; Added cross-level random effects |

${^*}$ Model 2 also incorporates $\mu_{i,j}^L$ as a covariate, namely the mean rate from the previous time point to address the time series effect.

Please the codes in the [models_raw.R](https://github.com/Sijianf/ST_Covid_project/blob/main/models_raw.R).
