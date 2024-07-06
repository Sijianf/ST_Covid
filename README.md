# Spatial Temporal Analysis of COVID Data (ST_Covid)

This project focuses on spatial temporal analysis of COVID-19 data. We have developed a series of basic models to illustrate the differences in their assumptions and outcomes. 

The basic models (*Model 0 and Model 1*) operate under the assumption that the high-level mean at time point $j$ is the sum of total $M$ low-level means: 
$$\mu_j^H = \sum_{i=1}^{M} \mu_{i,j}^L$$

The other models estimate the high-level mean at time point $j$ through regression of covariates. Below is an example with lagged time effects: 
$$\mu_j^H = f(Ycase_{j}^H, Ycumulate_{j}^H, \mu_{j-1}^H)$$

## Models Overview

| Model | Features |
| ------------ | ------------ |
| **M0** | No regression for high-level; No lagged time effects as covariates; No cross-level random effects |
| **M1** | No regression for high-level; No lagged time effects as covariates; Cross-level random effects |
| **M2** | Regression for high-level; Lagged time effects as covariates; Cross-level random effects |
| **M3** | Regression for high-level; Lagged time effects only in high-level ${}^*$; Cross-level random effects |

${}^*$ Model 3 turns out to be a simpler version of Model 2.

## Codes

Please see the codes in [models_raw.R](https://github.com/Sijianf/ST_Covid/blob/main/codes/models_raw.R).

## Reports

Please see the convergence reports and WAICs here: 

- [Model 0](https://sijianf.github.io/ST_Covid/pages/Report_June_m0.html).

- [Model 1](https://sijianf.github.io/ST_Covid/pages/Report_June_m1.html).

- [Model 2](https://sijianf.github.io/ST_Covid/pages/Report_June_m2.html).

- [Model 3](https://sijianf.github.io/ST_Covid/pages/Report_June_m3.html).
