# Spatial Temporal Analysis of COVID Data (ST_Covid)

## Table of Contents
- [Project Overview](#project-overview)
- [Nimble Codes](#nimble-codes)
- [Tracking of Model Selection](#tracking-of-model-selection)
- [Reports](#reports)

## Project Overview

This project focuses on spatial temporal analysis of COVID-19 data. We have developed a series of basic models to illustrate the differences in their assumptions and outcomes.  

### Starting Models 
The basic models (*Model 0 and Model 1*) operate under the assumption that the high-level mean at time point $j$ is the sum of total $M$ low-level means: 

$$\mu_j^H = \sum_{i=1}^{M} \mu_{i,j}^L$$

The other models estimate the high-level mean at time point $j$ through regression of covariates. Below is an example with lagged time effects: 

$$\mu_j^H = f(Ycase_{j}^H, Ycumulate_{j}^H, \mu_{j-1}^H)$$

We now give more details of 4 starting models, and below we will provide a more comprehensive table of candidate models for selection.

| Model | Features |
|-------|:--------:|
| m0 | No regression for high-level; No lagged time effects as covariates; No cross-level random effects |
| m1 | No regression for high-level; No lagged time effects as covariates; Cross-level random effects |
| m2 | Regression for high-level; Lagged time effects as covariates; Cross-level random effects | 
| m3 | Regression for high-level; Lagged time effects only in high-level ${}^*$; Cross-level random effects | 

${}^*$ Model 3 turns out to be a simpler version of Model 2.

## Nimble Codes

Please see the model codes in [models_raw.R](https://github.com/Sijianf/ST_Covid/blob/main/codes/models_raw.R).  

## Tracking of Model Selection

### High Models
- **H0**: Sum Only
- **H0a**: Sum + Temporal Random Effect
- **H0b**: Intercept + Temporal Random Effect
- **H1**: Current Case Count + Temporal Random Effect
- **H2**: H1 + Lagged Death Count
- **H3**: H1 + Cumulative Case Count
- **H4**: H1 + Lagged Death Count + Cumulative Case Count
- **H5**: H4 + Spatial Effects and Additional Model Components

### Low Models
- **L1**: Current Case Count + Spatial Random Effect + Temporal Random Effect
- **L2**: L1 + Lagged Death Count
- **L3**: L1 + Cumulative Case Count
- **L4**: L1 + Lagged Death Count + Cumulative Case Count
- **L5**: L4 + Spatial Temporal Random Effect
- **L6**: L1 + Spatial CAR Model
- **L7**: L5 + Spatial CAR Model
- **L7a**: L7 - Spatial Random Effect - Spatial Temporal Random Effect

### 8 by 8 Tracking Table

|         |  **H0**  |  **H0a** |  **H0b** |  **H1**  |  **H2**  |  **H3**  |  **H4**  |  **H5**  |
|:--------|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
| **L1**  |    m0    |    m1    |    m11   |          |    m4    |          |    m3    |          |
| **L2**  |          |    m7    |    m17   |          |    m5    |          |          |          |
| **L3**  |          |          |          |          |          |          |          |          |
| **L4**  |          |    m8    |    m18   |          |    m10   |          |    m2    |          |
| **L5**  |          |          |    m20   |          |          |          |          |          |
| **L6**  |          |          |          |          |          |          |          |          |
| **L7**  |    m12   |    m9    |    m19   |          |    m6    |          |          |          |
| **L7a** |    m13   |          |    m14   |          |    m15   |          |    m16   |          |

## Reports

### Joint modeling

|Model   |DIC H                   |DIC L                    |DIC3 H                  |DIC3 L                   |WAIC H                |WAIC L                   |WAIC Total (High + Low)  |
|:------:|:-----------------------|:------------------------|:-----------------------|:------------------------|:---------------------|:------------------------|:-----------------------:|
|$m0$    |$1137.8$                |$22532.2$                |$1111.1$                |$22629.5$                |$1121.3$              |$22642.6$                |$23763.9$                |
|$m1$    |$1211.3$                |$22611.1$                |$1155.3$                |$22713.2$                |$1181.6$              |$22735.6$                |$23917.2$                |
|$m2$    |$1208.5$                |$22169.1$                |$1150.9$                |$22191.4$                |$1177.5$              |$22213.4$                |$23390.9$                |
|$m3$    |$1212.3$                |$22623.1$                |$1153.3$                |$22720.7$                |$1179.6$              |$22743.9$                |$23923.5$                |
|$m4$    |$1213$                  |$22620$                  |$1153.8$                |$22720.2$                |$1180.5$              |$22743.1$                |$23923.6$                |
|$m5$    |$1214.9$                |$22464.2$                |$1153.9$                |$22549.4$                |$1181$                |$22572.5$                |$23753.5$                |
|$m6$    |$1235.2$                |$24474$                  |$1168.5$                |$21058.8$                |$1202.4$              |$21573.7$                |$22776.1$                |
|$m7$    |$1212$                  |$22456.6$                |$1157.3$                |$22543.2$                |$1184$                |$22565.4$                |$23749.4$                |
|$m8$    |$1211.7$                |$22164.3$                |$1149.3$                |$22188.2$                |$1175.1$              |$22209.9$                |$23385.0$                |
|$m9$    |$1209.7$                |$24073.3$                |$1150$                  |$20874.8$                |$1176$                |$21356.9$                |$22532.9$                |
|$m10$   |$1230$                  |$22457.6$                |$1164.9$                |$22514.9$                |$1196.6$              |$22538.7$                |$23735.3$                |
|$m11$   |$1352$                  |$22867.9$                |$1235.4$                |$22863.5$                |$1291.2$              |$22890.1$                |$24181.3$                |
|$m12$   |${\color{red}{1131.8}}$ |$24103.9$                |${\color{red}{1105.5}}$ |${\color{red}{20818.3}}$ |${\color{red}{1116}}$ |${\color{red}{21277.4}}$ |${\color{red}{22393.4}}$ |
|$m13$   |$1133.9$                |${\color{red}{22097.4}}$ |$1106.4$                |$22117.4$                |$1117$                |$22130.2$                |$23247.2$                |
|$m14$   |$1400$                  |$22514.4$                |$1264$                  |$22364.9$                |$1337.3$              |$22400.9$                |$23738.2$                |
|$m15$   |$1243.9$                |$22461.9$                |$1166.9$                |$22519.3$                |$1198.8$              |$22543.6$                |$23742.4$                |
|$m16$   |$1208.2$                |$22190$                  |$1150.9$                |$22211.5$                |$1177$                |$22233.4$                |$23410.4$                |
|$m17$   |$1364.6$                |$22733.4$                |$1246.4$                |$22682.2$                |$1307$                |$22709.9$                |$24016.9$                |
|$m18$   |$1395.5$                |$22691.7$                |$1262.9$                |$22378.4$                |$1336.2$              |$22414.9$                |$23751.1$                |
|$m19$   |$1358.4$                |$24731.8$                |$1238.4$                |$21023.8$                |$1296.8$              |$21589.6$                |$22886.4$                |
|$m20$   |$1355$                  |$24459.8$                |$1238.4$                |$21023$                  |$1295.6$              |$21594.1$                |$22889.7$                |



### Separate modeling

|Model                |DIC H                   |DIC L                    |DIC3 H                  |DIC3 L                   |WAIC H                  |WAIC L                   |WAIC Total (High + Low)  |
|:-------------------:|:-----------------------|:------------------------|:-----------------------|:------------------------|:-----------------------|:------------------------|:-----------------------:|
|${\color{grey}{m0}}$ |${\color{grey}{1137.8}}$|${\color{grey}{22532.2}}$|${\color{grey}{1111.1}}$|${\color{grey}{22629.5}}$|${\color{grey}{1121.3}}$|${\color{grey}{22642.6}}$|${\color{grey}{23763.9}}$|
|${\color{grey}{m1}}$ |${\color{grey}{1212.8}}$|${\color{grey}{22610.7}}$|${\color{grey}{1155.5}}$|${\color{grey}{22714.6}}$|${\color{grey}{1181.6}}$|${\color{grey}{22737.2}}$|${\color{grey}{23918.8}}$|
|$m2$                 |$1347.8$                |$22283.8$                |$1234.6$                |$22301.7$                |$1299.5$                |$22337.1$                |$23636.6$                |
|$m3$                 |$1356.2$                |$22743.9$                |$1234.8$                |$22831.3$                |$1301.1$                |$22867.6$                |$24168.7$                |
|$m4$                 |$1360.3$                |$22752.4$                |$1238$                  |$22831.9$                |$1304.5$                |$22868.2$                |$24172.7$                |
|$m5$                 |$1351.4$                |$22586$                  |$1239$                  |$22660.3$                |$1305.8$                |$22696.1$                |$24001.9$                |
|$m6$                 |$1370.7$                |$24041.8$                |$1237.5$                |$20963.4$                |$1304.4$                |$21476$                  |${\color{red}{22780.4}}$ |
|${\color{grey}{m7}}$ |${\color{grey}{1217.1}}$|${\color{grey}{22445.3}}$|${\color{grey}{1156.5}}$|${\color{grey}{22543}}$  |${\color{grey}{1182.9}}$|${\color{grey}{22565.5}}$|${\color{grey}{23748.4}}$|
|${\color{grey}{m8}}$ |${\color{grey}{1208.1}}$|${\color{grey}{22161.4}}$|${\color{grey}{1149.2}}$|${\color{grey}{22186.7}}$|${\color{grey}{1174.7}}$|${\color{grey}{22207.9}}$|${\color{grey}{23382.6}}$|
|${\color{grey}{m9}}$ |${\color{grey}{1212.6}}$|${\color{grey}{24078.9}}$|${\color{grey}{1149}}$  |${\color{grey}{20872.7}}$|${\color{grey}{1174.9}}$|${\color{grey}{21355.4}}$|${\color{grey}{22530.3}}$|
|$m10$                |$1362$                  |$22249.6$                |$1238$                  |$22296$                  |$1304$                  |$22331.6$                |$23635.6$                |
|$m11$                |$1399.6$                |$22744$                  |$1260.4$                |$22831.2$                |$1332.7$                |$22868.1$                |$24200.8$                |
|${\color{grey}{m12}}$|${\color{grey}{1131.8}}$|${\color{grey}{24103.9}}$|${\color{grey}{1105.5}}$|${\color{grey}{20818.3}}$|${\color{grey}{1116}}$  |${\color{grey}{21277.4}}$|${\color{grey}{22393.4}}$|
|${\color{grey}{m13}}$|${\color{grey}{1133.9}}$|${\color{grey}{22097.4}}$|${\color{grey}{1106.4}}$|${\color{grey}{22117.4}}$|${\color{grey}{1117}}$  |${\color{grey}{22130.2}}$|${\color{grey}{23247.2}}$|
|$m14$                |$1398.3$                |$22317$                  |$1261.4$                |$22315.8$                |$1334.9$                |$22351.8$                |$23686.7$                |
|$m15$                |$1363.6$                |$22319.7$                |$1238.8$                |$22314.6$                |$1306.9$                |$22350.5$                |$23657.4$                |
|$m16$                |$1358.5$                |$22335.7$                |$1235.8$                |$22317$                  |$1302.1$                |$22353.2$                |$23655.3$                |
|$m17$                |$1393$                  |$22589$                  |$1260.3$                |$22659.4$                |$1332.4$                |$22695.6$                |$24028.0$                |
|$m18$                |$1387.2$                |$22309.3$                |$1259.6$                |$22301.6$                |$1331.2$                |$22337$                  |$23668.2$                |
|$m19$                |$1396.9$                |$24158.8$                |$1260.7$                |$20960.7$                |$1333$                  |$21473.5$                |$22806.5$                |
|$m20$                |$1399.7$                |$24355.4$                |$1261.9$                |$20959.4$                |$1335.3$                |$21466.7$                |$22802.0$                |



#### Separate modeling for high level

|Model |DIC H                   |DIC3 H                  |WAIC H                  |
|:-----|:-----------------------|:-----------------------|:-----------------------|
|H0b   |$1387.2$                |$1259.6$                |$1331.2$                |
|H2    |$1351.4$                |$1238$                  |$1304.5$                |
|H4    |${\color{red}{1347.8}}$ |${\color{red}{1234.6}}$ |${\color{red}{1299.5}}$ |


#### Separate modeling for low level

|Model |DIC L                    |DIC3 L                   |WAIC L                   |
|:-----|:------------------------|:------------------------|:------------------------|
|L1    |$22744$                  |$22831.2$                |$22867.6$                |
|L2    |$22586$                  |$22659.4$                |$22695.6$                |
|L4    |${\color{red}{22249.6}}$ |$22296$                  |$22331.6$                |
|L5    |$24355.4$                |${\color{red}{20959.4}}$ |${\color{red}{21466.7}}$ |
|L7    |$24041.8$                |$20960.7$                |$21473.5$                |
|L7a   |$22317$                  |$22314.6$                |$22350.5$                |


Please see the detailed convergence reports and WAICs here: 

- [Model 0](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m0.html)
- [Model 1](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m1.html)
- [Model 2](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m2.html)
- [Model 3](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m3.html)
- [Model 4](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m4.html)
- [Model 5](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m5.html)
- [Model 6](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m6.html)
- [Model 7](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m7.html)
- [Model 8](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m8.html)
- [Model 9](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m9.html)
- [Model 10](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m10.html)
- [Model 11](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m11.html)
- [Model 12](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m12.html)
- [Model 13](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m13.html)
- [Model 14](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m14.html)
- [Model 15](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m15.html)
- [Model 16](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m16.html)
- [Model 17](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m17.html)
- [Model 18](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m18.html)
- [Model 19](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m19.html)
- [Model 20](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m20.html)


