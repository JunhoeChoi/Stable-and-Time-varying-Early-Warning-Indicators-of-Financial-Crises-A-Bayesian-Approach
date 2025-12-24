# Stable-and-Time-varying-Early-Warning-Indicators-of-Financial-Crises:-Bayesian-verses-Machine-Learning-Approach

## Abstract
Previous studies have endeavored to identify early warning indicators (EWIs) that are useful in predicting financial crises. This paper aims to categorize a multitude of explanatory variables into three distinct groups: stable EWIs, time-varying EWIs with varying utility over time, and irrelevant variables for financial crisis prediction by utilizing a sparse time-varying parameter (sparse-TVP) model. This paper offers two significant contributions. Firstly, through data-driven analysis, stable EWIs and time-varying EWIs were identified from a wide range of macroeconomic variables. Stable EWIs include the credit-to-GDP ratio and the instability of bank funding structures, which is consistent with the broad literature of EWIs specification. Additionally, global total credit-to-GDP ratio, which has gained prominence since the 1980s, was identified as a time-varying EWI. This finding implies the increasing necessity of considering the influence of global financial cycles to comprehend the underlying mechanisms of financial crises in the past a few decades. Secondly, the proposed sparse-TVP model exhibits superior predictive accuracy compared to alternative techniques assuming fixed parameters, such as logistic regression, LASSO regression, and some RNN-type models. This result suggests that the dynamics of EWIs provide valuable insights not only into past financial crisis mechanisms but also for forecasting future financial crises.

## Data

The model uses macro-financial indicators from the JST dataset.  
The table below summarizes variable definitions and transformations.

### Financial Crisis Variable (Dependent Variable)
We construct the financial crisis indicator using the Jordà–Schularick–Taylor (JST) Macrohistory Database (Jordà, Schularick, and Taylor, 2017), which provides the most comprehensive cross-country macro-financial dataset currently available. The database covers annual macroeconomic and financial variables for 16 advanced economies over the period 1870–2017.
Systemic financial crises are defined following Schularick and Taylor (2012) as events in which a country’s banking sector experiences severe distress, including bank runs, sharp increases in default rates, large capital losses, and subsequent public intervention, bankruptcy, or forced mergers of financial institutions.

#### Crisis Label Construction
- The baseline crisis indicator equals 1 in the year marking the onset of a systemic financial crisis in a given country.
- To enable early warning prediction, the dependent variable is set to 1 for one and two years prior to the crisis onset, capturing the pre-crisis phase.
- The crisis year itself and the four subsequent years are excluded from the analysis to avoid post-crisis bias, following Bussière and Fratzscher (2006). These periods are characterized by recovery dynamics and adjustment processes that do not reflect transitions from healthy to crisis regimes.

#### Sample Exclusions
To ensure consistency and avoid structural distortions, the following observations are excluded:
- Post-crisis recovery years (crisis year + four years)
- 1933–1939, corresponding to the later phase of the Great Depression
- World War I (1914–1918) and World War II (1939–1945)
- All observations with missing values in any explanatory variables
These exclusions ensure that the model focuses on economically meaningful transitions from normal conditions to systemic financial crises.

### Explanatory Variables

| Variable               | Transformation    | Definition                                            |
| ---------------------- | ----------------- | ----------------------------------------------------- |
| Credit                 | 2-year difference | Total loans to non-financial private sectors / GDP    |
| Credit*                | 2-year difference | Global average of credit to GDP ratio                 |
| Capital asset ratio    | 2-year difference | Tier 1 capital / total assets                         |
| Noncore funding ratio  | 2-year difference | Other liabilities / (deposits + other liabilities)    |
| Investment             | 2-year difference | Investment / GDP                                      |
| Current account        | 2-year difference | Current account / GDP                                 |
| Exchange rates         | 2-year difference | Real exchange rates to US Dollar                      |
| Public debt            | level             | Public debt / GDP                                     |
| Slope of yield curves  | level             | Long-term interest rates − short-term interest rates  |
| Slope of yield curves* | level             | Global average of yield curve slopes                  |
| Equity price           | 2-year growth     | 2-year real total return (capital gain and dividends) |
| Inflation rate         | 2-year growth     | 2-year growth of consumer price index                 |
| Consumption            | 2-year growth     | 2-year growth of real consumption                     |
| House price            | 2-year growth     | 2-year growth of real house price index               |

#### Notes
- All explanatory variables are normalized to have a mean of zero and a standard deviation of one.
- Variables transformed into growth rates are winsorized at the 5th percentile in both upper and lower tails to mitigate the influence of outliers.

## Model Specification (Sparse TVP Model)

We consider a time-varying parameter model defined as follows:

$$
\beta_t = \beta_{t-1} + \omega_t \tag{1}
$$
<br/>
$$
q_t = x_t \beta_t \tag{2}
$$

where

$$
\omega_t \sim \mathcal{N}_p(0, Q).
$$

Here, $q_t$ denotes the vector of logit-transformed probabilities of financial crises at time $t$, and $x_t$ denotes the corresponding explanatory variables at time $t$. $\beta_t$ is a $p$-dimensional vector of time-varying coefficients and $Q$ is a diagonal $p \times p$  covariance matrix governing the evolution of the state process, defined as $Q$ = diag(**$\theta$**); **$\theta$** = ( $\theta_1$,..., $\theta_p$).

### Properties of $\beta$ and $\theta$ values
The objective is to categorize the numerous explanatory variables into three types: 1) stable EWI, 2) time-varying EWI, and 3) irrelevant variables for prediction.

| Category               | $\beta_j$ values | $\theta_j$ values |
|------------------------|------------|------------|
| Stable EWIs            | non-zero   | zero       |
| Time-varying EWIs      | non-zero   | non-zero   |
| Irrelevant variables   | zero       | zero       |

In other words, the goal is to distinguish between $\beta_j$ and $\theta_j$ values that are close to zero and those that are not. To find this, the study uses Bayesian inference framework using **Shrinkage Prior**.

### Shrinkage Prior
It is desirable to employ a shrinkage prior that exhibits the property of shrinking the estimates of state variables to zero when the they are in close proximity to zero, while returning the estimated value without shrinkage when it is significantly distant from zero. The study uses the **horseshoe prior**, which is computationally advantageous and typically used in this context, to perform baseline estimation. For $j$ = 1, ... , $p$, the model assumes the following prior distributions for parameters.

$$
\beta_{j,1} \mid \lambda_j, \tau \sim N\left(0, \tau^2 \lambda_j^2 \right) \tag{3}
$$
<br/>
$$
\lambda_j \sim C^+(0, 1) \tag{4}
$$
<br/>
$$
\tau \sim C^+(0, \tau_0) \tag{5}
$$

$$
\theta_j \mid \kappa_j, \xi \sim N\left(0, \xi^2 \kappa_j^2 \right) \tag{6}
$$
<br/>
$$
\kappa_j \sim C^+(0, 1) \tag{7}
$$
<br/>
$$
\xi \sim C^+(0, \xi_0) \tag{8}
$$

$\tau_0$ and $\xi_0$ are the hyper-parameters which reflect the prior assumptions about the degree of shrinkage of $\tau$ and $\xi$, respectively. Since there is no strong consensus on their calibration, they are commonly set to 1 in empirical applications. Here, the hyper parameters are set to be 0.8 and 1, respectively, following Piironen and Vehtari(2017) The model is estimated with MCMC sampling.

## Results for identifying EWIs
Medians of the estimated posterior distributions are as follows. 

**Time-varying coefficients estimated from the Sparse TVP model**
<img src="Overview of estimated coefficients.png">

Coefficients of all variables are as follows.

**Coefficients of All Variables**
<img src="All Variables.png">

**Coefficients of Time-Varying EWIs**
<img src="EWI_Vary.png">

**Coefficients of Stable EWIs**
<img src="Stable_EWI.png">

## Forecasting Financial Crisis

Previously, I have identified a set of EWIs among various macroeconomic variables. The analysis reveals that these EWIs consist of those that have been consistently useful over a long period, as well as those that have become effective recently: mainly since the 1980s. Stable EWIs identified include credit-to-GDP ratio and the non- core funding ratio of banks, which is in line with numerous previous studies that have attempted to identify EWIs. Variables that have gained increasing importance in recent years include the global credit-to-GDP ratio, which suggests that there is a growing need to consider global factors, not just domestic ones, in predicting and understanding financial crises.

I have confirmed that Sparse TVP model surpasses alternative models, such as logistic regression and LASSO regression, in terms of out-of-sample prediction accuracy. Our results suggest that taking into account the time variation of EWIs can enhance our understanding of past crises and, at the same time, offer valuable insights into future financial crisis predictions.

This section exhibits performance evaluations for out-of-sample prediction of various machine learning models including Recurrent Neural Networks. Later on the paper, we will compare the results with Sparse TVP model. (See details in [Forecast in Machine Learnings](Forecasting_ML.ipynb))

## Model Specification in forecasting models (RNNs)

### Short Definition of Recurrent neural networks

Here, I am conducting Recurrent neural networks and the gated RNNs (LSTM and GRU). Recurrent neural networks (RNNs) are a class of neural networks specially designed to process sequential data, such as time series and language. RNNs utilize their hidden states as a form of memory to dynamically process a sequence of explanatory variables over time. One of the most important features of RNNs is their ability to maintain the temporal order of the input sequence, which is particularly useful in situations where temporal ordering is critical to avoid overfitting. Given their ability to retain memory and preserve temporal ordering, RNNs may represent an ideal tool for predicting systemic financial crises. By analyzing the time series, RNNs can detect the accumulation of vulnerabilities and retain the accumulated level of vulnerability. In the presence of a critical incident, such as a domestic economic slowdown or an international shock, RNNs can generate signals, which can facilitate timely interventions to prevent potential crisis scenarios.

In this paper, for machine learning models, we consider three different RNN models: basic RNN, RNN with Long-Short Term Memory (LSTM), and RNN with GRU. Basic RNNs, while having a relatively low number of parameters, can be vulnerable to instabilities such as the vanishing or exploding gradient problem. To address these issues, LSTMs and GRUs implement gating mechanisms, which have proven effective at improving the stability of the models. Consequently, these architectures are commonly referred to as gated RNNs. Gated RNNs are particularly proficient at retaining information about past events in a time series. When dealing with panel data, which often involves longitudinal or repeated observations, LSTMs and GRUs may be more appropriate choices due to their capacity to capture long-term dependencies in the data.

Table below presents an overview of the prediction models used in the study.

|   Model  |                          Hyperparameters                          |
| :------: | :---------------------------------------------------------------: |
|    RNN   | Time window = 5 · Hidden layer dimension = 10 · L2 weight = 0.001 |
| RNN-LSTM | Time window = 5 · Hidden layer dimension = 10 · L2 weight = 0.001 |
|  RNN-GRU | Time window = 5 · Hidden layer dimension = 10 · L2 weight = 0.001 |

### Performance Evaluation

#### ROC curve (AUC)

For the prediction exercises, we partition the entire dataset into an earlier part as a training sample and a latter part as a testing sample, based on a specific year. This kind of partitioning in chronological order is necessary because our dataset exhibits temporal ordering, and we seek to avoid employing future values in the current prediction task. To ensure robustness, we compare multiple cutoff years, such as 1980 and 1990, as reference points. Results in Sparse-TVP model also support our data split periods. In short, the predictive powers in global credit to GDP had been grown since 1980s, thereby supporting the plausibility of splitting time periods around this era.

The evaluation of predictive accuracy follows standard practice, using the area under the **ROC curve (AUC)** to maintain coherence and comparability with prior researches. Higher AUC values correspond to better predictions, with a maximum value of one for a perfect model that can perfectly differentiate between the two states, crises, and normal periods. An AUC of 0.5 indicates a random guess, while an AUC below 0.5 implies that the predictions are less accurate than random guessing.

### Split Data

This paper considers two sample splits.

* (1) Training sample: (1870-1980) Test Sample: (1981-2017) 
* (2) Training sample: (1870-1990) Test sample: 1991-2017)

## Results for Forecasting Evaluations
|    Model / Specification    | In-sample (1) | Out-of-sample (1) | In-sample (2) | Out-of-sample (2) |
| :-------------------------: | :-----------: | :---------------: | :-----------: | :---------------: |
|        **Sparse-TVP**       |      0.98     |        0.68       |      0.96     |        0.79       |
|            Logit            |      0.82     |        0.49       |      0.82     |        0.64       |
|            Lasso            |      0.82     |        0.54       |      0.81     |        0.71       |
|             RNN             |      0.98     |        0.74       |      0.89     |        0.77       |
|           RNN-LSTM          |      0.83     |        0.67       |      0.91     |        0.66       |
|           RNN-GRU           |      0.84     |        0.71       |      0.89     |        0.73       |
|                             |               |                   |               |                   |
|      **Sample Period**      |   1870–1980   |     1981–2017     |   1870–1990   |     1991–2017     |
| **Pre-crisis Observations** |       18      |         44        |       36      |         26        |

## Robustness Check using Country by Country Cross Validation inspired by Tölö (2020)

In this analysis, I assume that the coeﬀicient matrix depends only on time t and not on country j. Therefore, we implicitly assume that all countries present during the same period follow the same data generating process, without considering the heterogeneity of coeﬀicients between countries. We make this assumption because our main objective is to estimate the time-series usefulness of variables viewed globally, rather than to analyze the differences between countries. However, it is important to individually validate whether these assumptions are correct.

Furthermore, even from the perspective of policymakers who formulate global macroprudential regulations, it is important to know whether insights obtained using a specific country group will be valid for other countries with similar properties. Therefore, in this section, we present the results of country-by-country cross-validation, as described by Tölö (2020).

### Idea

The idea is as follows. First, we create a training dataset by excluding a specific country and estimate models. Then, we perform out-of-sample prediction using the excluded countries as the test data. 

## Results

|   OOS                    | Sequential (1) | Sequential (2) | Country-by-Country |
| :----------------------: | :------------: | :------------: | :----------------: |
|      **Sparse-TVP**      |      0.68      |      0.79      |        0.81        |
|           Logit          |      0.49      |      0.64      |        0.79        |
|           Lasso          |      0.54      |      0.71      |        0.79        |
|            RNN           |      0.74      |      0.77      |        0.84        |
|         RNN-LSTM         |      0.67      |      0.66      |        0.84        |
|          RNN-GRU         |      0.71      |      0.73      |        0.85        |
|                          |                |                |                    |
|     **Train Period**     |    1870–1980   |    1870–1990   |          –         |
|      **Test Period**     |    1981–2017   |    1991–2017   |          –         |
| **Pre-crisis (Trained)** |       18       |       36       |          –         |
|  **Pre-crisis (Tested)** |       44       |       26       |          –         |
|  **Period**              |       -        |       -        |      1870–2017     |
|  **Pre-crisis**          |       -        |       -        |          62        |

The results in the Table above show that the models in the country by country cross-validation exhibit superior performance compared to most models in sequential evaluation, which indicates the diﬀiculty of sequential out-of-sample prediction. However, the model is too heavy.

Despite the lower AUC statistics of sparse-TVP compared to RNN-based models in country by country cross-validation, it possesses comparative advantage. Unlike neural networks, the sparse-TVP model enables us to comprehend which early warning indicators (EWIs) have a more substantial predictive power and track the variations in their predictive power. Therefore, I concluded that the sparse-TVP model achieves more flexible and accurate learning of past financial crises and demonstrates high predictive power for future financial crisis forecasts simultaneously.
