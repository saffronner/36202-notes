#set page(
  numbering: "1 / 1",
  paper: "us-letter"
)
#outline(indent: 1em)
#let predictedby = $#h(0.25em) ~ #h(0.25em)$
// #show image: []

= review
- big picture of applied stats: see 36200 image idk
- we have statistics ($overline(x), hat(p), ...$)  and standard error ($"SE"_(overline(x)), "SE"_hat(p), ...$)
- population: literally everyone, hard to measure
- sample: subset of population
- parameter: perfect summary (e.g. mean height)
- statistic: measurable summary (e.g. mean height of sample)
- stderr of stat: typical variation due to random sampling.
  - diff error formulae for each stat.
  - this course: simply calc with software
- inference: give estimate and measure of how far off it might be
  - if statistic is random and sampling distribution known, we have probabilistic inference; can get p-value or margin or err

== 1 variable EDA
- categorical
  - bar graph
  - percent summaries
- quantitative
  - histogram
  - center: $overline(x)$, median
  - spread: stddev, IQR, range
  - five number summary/box plot

== 1 variable transformations
- need normal distributions?
- $x^(1/n)$, $log(x + c)$ so everything is $>1$.
- the above's inverses
- quantile plots (qqplot) can help us diagnose if normal enough (look for straight line)
== 2 variable EDA
- explanatory $x$ axis $->$ response $y$ axis
#figure(
  image("media/2var_eda.png"), caption: none,
)

== 1 variable inference
- statistics ($overline(x), S_x, ...$) predicts parameters ($mu, sigma, ...$)
- components:
  - point estimation: estimate via single number calculated
  - interval estimation: give plausible interview and how plausible
  - significance testing about hypotheses: assess evidence for/against claim about 
  
- 95% confidence interval for $mu$ is $overline(X) plus.minus 2 dot "SE"_(overline(X))$
  - (works for arbitrary parameter/statistic estimate)
  - any sample Standard Error $"SE"$ is $S/sqrt(n)$ with sample stddev $S$ (but remember, we just use software)
  - technically, $2$ should be $t_"crit"$ which varies with $n$, but it approximates to $2$ for 95% confidence when large $n$

- hypotheses testing
  - $H_0$ vs $H_A$
  - "$p$ value is compared to significance level. we do (not) reject the null hypothesis. we do (not) have sufficient evidence that ..."
  - remember: $p$ finds boolean evidence of difference from norm, not magitude of difference

= Statistical Model Primer
- statistical models are often of form: $"quantity" = "expectation" + "error"$
- in 1 variable, eg: $Y_i = mu + epsilon_i$ where $mu$ is the prediction and $epsilon_i$ is the error at $i$.
  - we also specify the distribution and mean + stddev of the errors
- in 2 variables, eg: for some $X$ axis value, $Y_i = mu_(Y|X) + epsilon_i$
  - we also specify the shape, center, spread of the distribution of errors

#pagebreak()
= Simple Linear Regression
- our model idea is $Y_i = beta_0 + beta_1 X + epsilon_i$ where we assume the errors are
  - independent, mean 0, constant stddev/spread (for required for least squares)
  - are normal (required for inference)
  - (can be denoted $"iid", N(mu=0,"variance"=sigma^2)$)

- our *sample* regression equation is $hat(y) = b_0 + b_1 X$

- notice that we have three parameters: $beta_0, beta_1, sigma$
  - they are estimated by $b_0, b_1$ (when using least squares), and $hat(sigma)$: what R calls "Residual standard error"

- to apply the model:
  + *state* the model
    - eg: "we use the SLR model. $"vision distance" = beta_0 + beta_1 dot "age" + epsilon_i$ where errors are independent, mean 0, constant stddev, normal.
  + *validate* the data works for the model
    - linearity: visual inspection
    - errors are:
      - independent: residual plot. residuals "patternlessly" above and below 0 line.
      - mean 0: residual plot. reasonably centered around 0.
      - constant stddev: residual plot. reasonably constant spread, scanning left to right 
      - normal: normal qqplot, follows line
    - if there are problems, consider diff model/transformations
  + *estimate* the parameters
    - use software to find $b_0, b_1, hat(sigma)$
  + *inference*: is data probably showing a relationship between $X$ and $Y$?
    - t test for $beta_1$ $=$ or $eq.not$ 0 
  + *measure strength* of model with $R^2$ (if not chance)
    - $R^2$ is the percent of variability in $Y$ that can be attibuted to the linear relationship with $X$
    - "Multiple R-squared" in R. NOT "Adjusted"
  + *predict* of $Y$ from $X$ (for individual with $X$ or all people with $X$)
    - the equation predicts the point estimate of $Y$ given $X$
    - get prediction vs confidence interval via R for probable values of $Y$ for individual or all at $X$

== Nonlinear Relationships?
- can use a nonlinear model (same four error assumptions)
- can transform it 
- transformations often preferred: fewer parameters make a simpler model
- make sure to not overfit!

= Multiple Regression
- we're often interested in predicting a $Y$ from multiple explanatory $X_i$
- when contribution from each $X_i$ is linear, we have _multiple linear regression_:
  $
  Y_i = beta_0 + beta_1 X_1 + ... + beta_p X_p + epsilon_i
  $
  where errors are
  - independent
  - mean 0 
  - contant stddev
  - normal

- $p+2$ parameters: $beta_({0-p})$ and $sigma$
  - like SLR, $sigma$ is stddev of  errors, ie typical deviation of $Y$ from regression hyperplane
  - $hat(sigma)$ in R is still "residual standard error"

- each $beta_i$ is the avg change in $Y$ when $X_i$ increases by 1 unit and the other $X$s remain fixed

- eg `school.mod = lm(GPA ~ IQ + SelfConcept, data=school)`

- to apply the model:
  + *state* the model
  + *validate* the data works for the model with EDA
    - scatterplots of $Y$ against _each_ explanatory (w/ `pairs` plot). linearity: visual inspection
    - error conditions (also just use a residuals/qqplot):
      - independent: residual plot. residuals "patternlessly" above and below 0 line.
      - mean 0: residual plot. reasonably centered around 0.
      - constant stddev: residual plot. reasonably constant spread, scanning left to right 
    - if there are problems, consider diff model/transformations
    - low multicollinearity (each $X_i$ weakly correlated with each other) (might otherwise get mathematically impossible/conceptually inappropriate, misleading results. see `media/high_multicollinearity`)
      - can _informally_ investigate via: correlation matrix, odd parameter estimates, oddly large estimate stderrs
      - mathematically diagonse via variance inflation factor (vif)
        - let a model be $Y predictedby X_1 + X_2 + X_3$
        - vif of $X_i$ is $1/(1-R^2)$, with $R^2$ from $X_i predictedby$ the other $X$es. 
        - i.e., vif of $X_1$ depends on $X_1 predictedby X_2 + X_3$
        - BUT: just use software.
        - when high multicol., drop variables: check diff subsets of $X$es, recheck diagnostics for each. find best model with R's _adjusted R-squared_ (adjusts for different number of explanatory variables. otherwise, R-squared would be higher with more variables, rmbr?)
        - BUT: also just use software (best subsets routine)
        - vif $>= 2.5$ is concerning
  + *estimate* parameters w/ software
  + *inference*: is data probably showing a relationship between $X_i$ and $Y$?
    - F-statistic: tests if _any_ of $X_i$ are important for predicting $Y$
    - individual T-tests: tests if _each_ $X_i$ is a significant predictor _in the presence of all other explanatories_
  + *predict*: use model, with $R^2$ for its effectiveness
    - multiple R-squared: proportion of variation in $Y$ that can be explained by all of $X_i$. has a few properties:
      - closer to 1 = better "fit"
      - can only increase with more predictors
      - diminshing returns

== including categorical explanatories?
- check for no interaction between predictors
  // #image("media/mult_reg_catvar.png")
  parallel lines 
  iff $X_2$ doesn't depend on $X_1$ 
  iff no interaction between $X_1$ and $X_2$
  iff $X_1$ effect doesn't depend on $X_2$.

  why is this so verbose from the slides :/

- assuming no interaction between predictors:
  - include a binary indicator/dummy variable (1 if smoker, 0 else)
  - call the category defined as 0 a "baseline" category

- if a categorical variable has, say, 3 options, we get _2_ dummy variables, both binary with 0 representing baseline group.
  - "controlling for years of seniority, dept A makes X less than dept C on average"
  - "holding dept constant, we estimate for every extra year of seniority, salary increases by X on average"

== what if categorical explanatories _have_ interaction?
- let us investigate a situation where calories$predictedby$carbs, but with slopes that differ depending on whether the item is meat.
  #image("media/interaction_multreg.png", width: 4in)

- new model: 
  $ Y = beta_0 + beta_1 X_1 + beta_2 dot "DummyMEAT" + beta_3 (X_1 dot "DummyMEAT") + epsilon $ 
  - capture the difference in slopes with an "interaction term" (the $beta_3$ term above)
  - `lm(Calories ~ Carbs + Meat + Carbs:Meat, data=fastfood)`

- assumptions: 
  - population relationship linear within each level of $"Dummy"$
  - within each level of $"Dummy"$, the errors are indep, mean 0, const stddev, normal ($"i.i.d.", N(0, sigma^2)$)

- IMPT: if interaction term stat. significant, then those explanatories must be kept (regardless of their individual variable p-values)
  - this just means that their slopes are indeed different, i think
  - so if they are not significant go back to normal multiple regression ig 

- coefficient $beta_3$ interpretation:
  + difference in slopes; i.e., how the quantitative $X_1$ effect depends on the group $"Dummy"$ value
    - "For every unit increase in $X_1$, the change in $Y$ is $beta_3$ greater/less on avg in $"Dummy"_1$ than in $"Dummy"_0$
  + equivalently: how the vertical difference between the lines changes; i.e., how the group $"Dummy"$ effect depend son the quantitative $X_1$ value
    - "For a particular value $x_1$ of the quantitative variable, "

#image("media/interaction_interpretation.png")

#image("media/MLR_interaction_3level.png")

good luck on exam 1 \<3

#pagebreak(weak: true)

= One way ANOVA
- recall: we first learn the regression models (Q $->$ Q)

- now we investigate the ANOVA (anal. of variance) models (C $->$ Q)

- big picture: evidence of difference in means of our cat. groups?
  - $
      H_0&: mu_1 = mu_2 = ...\
      H_1&: "means not all same"
    $

- model: 
  $
    y_(i j) = mu_j + epsilon_(i j)
  $
  where $j$ indexes the _independent_ cat. populations, $i$ the individuals

  same errors as regression: $i.i.d., N(0, sigma^2)$

  - parameters: each population mean and stddev of pop. errors

- NOTE: One way ANOVA is stat. identical to mult lin reg with categorical X, $k-1$ dummy variables

- apply model steps are similar to regression:
  + *state* the model
  + *validate* the data works for the model with EDA
    - side by side boxplots (Y vs groups), stats for each gruop
      - if largest stddev $div$ smallest stddev $>= 2$, use $alpha = 0.025$ in F test, instead of $alpha = 0.05$
    - groups independent: nature of study. eg no time dependence, 1 person 1 group
    - error conditions:
      - independent: residual plot. residuals "patternlessly" above and below 0 line.
      - mean 0: residual plot. reasonably centered around 0.
      - constant stddev: residual plot. reasonably constant spread, scanning left to right 
      - normal: qqplot
    - if there are problems, consider diff model/transformations
  + *estimate* parameters w/ software
  + *inference*: is data probably showing a relationship?
    - significant with ANOVA F-test (see above)
    - if yes, suppl. with 'multiple comparisons'
  + *predict*: use model, with $R^2$ for its effectiveness
    - multiple R-squared: proportion of variation in $Y$ that can be explained by all of $X_i$. has a few properties:

- we may derive the ANOVA F-statistic:
  #image("media/ANOVA_F_stat.png")

- and ANOVA $R^2$ value:
  #image("media/ANOVA_Rsquared.png")

- ok, now we believe means not equal. but _which_ means?
  - pairwise multiple comparison of means. 
  - we can do this via manual CI inspection for means, but more groups mean much higher false positives.
  - so we use Tukey test:
    #image("media/tukey_CI_ANOVA.png")

= Logistic Regression (Simple Binary case)
- simple (one X) binary (Y = 0 or 1)
  - we can get proportion from a dataset eg with `prop.table(table(dataframe$succeeded))`

- logistic regression: Q $->$ C wow!

- probability $p = P(Y = 1 | X = x)$

- suppose Y binary, $p$ defn above.
  - odds favoring Y = 1 are $p/(1-p)$ (IMPT: this just means if odds=3, odds of Y = 1 are 3:1.)
  - equivalently, $p = "odds"/(1 + "odds")$ via math

- simple binary logistic reg model is 
  $
    "odds"_1 = e^(beta_0 + beta_1 X) \
    "i.e." p = (e^(beta_0+beta_1 X)) / (1 + e^(beta_0 + beta_1 X))
  $
  no error term! $|beta_1|$ measures "steepness" of log

- linreg: eyeball linearity. hard with logistic. use "goodness of fit" test in R (rg though labs for `ResourceSelection` library, `hoslem.test`)
  - output $p$ value: $H_0:$ good fit.

- once GOF test passes for sample, test model for appropriateness for population. check $beta_1$ hypotheses test ($H_A: beta_1 != 0$, sig. relationship)

- interpretation: 
  - $e^(beta_0)$: odds, on avg, favoring Y = 1 when X = 0.
  - $e^(beta_1)$: for every unit incr in X, odds are _multiplied_ by this. (odds ratio!)

- inference: sign. reln? just look at $p$ value for $beta_1$ as usual
  - let's say a CI for $beta_1$ is (lower, upper). to get CI for odds ratio, just $e^"lower"$ etc

- in linreg, $R^2$ measures association. here, there is no mathy nice measure. 

- we use a rough measure: percentage of "concordant pairs"
  - consider: 11 success 14 failures. $11 dot 14 = 154$ pairs. 
  - a pair is concordant iff the success has a higher prob than the failure in the pair (discordant otherwise)
  - where prob is taken from predicting with the model

- putting it all together:
  #image("media/binary_logreg_ex.png")
  ```R
  titaniclogit <- glm(
    factor(survived) ~ sex + age + factor(pclass), 
    family = binomial(link="logit"),
    data = titanic
  )
  summary(titaniclogit)
  ```

= (Multi)nomial Logistic Regression

= Ordinal Logistic Regression
== Proportional-Odds Cumulative Logit Model
(end material for exam 2)

= Introduction to Statistical Learning
= Classifiers
- commonly, we search for cat. response (e.g. pedestrian or not?)
- find boundary in variable space to separate
- EDA: pairs plot
== Logistic Regression as Classification
- take log reg, then separate by which side of $0.5$ $p$ is on
== Discriminant Analysis
- only defined for quantitative $X$
- assume within each class, variables are Normal
- Linear DA: boundaries are lines/hyperplanes
- Quadratic DA: boundaries are quadratic hypersurfaces
  - assumed Normals can be "stretched" or "twisted"
== Classification Trees
- split data into those hyperrectangular things: make decision tree!
- higher nodes are more important
- can use both cat. and quant. $X$
- CAREFUL overfitting!
  - prune to min decisions manually or via algo
  - split b/t train and test data
  - ensembles
    - bagging trains models and takes avg (RANDOM FOREST!)
    - boosting sequentially combines and error corrects (takes weighted avg)
== More about classification tress: The Gini Index
- tree algo decides splits via on purity, often via Gini index
- Gini $in [0,1]$ of decreasing purity
= Intro to Clustering
- UNSUPERVISED!
- create clusters in variable space
== hierarchical aka agglomerative
- start w/ each obs. in a cluster, aggregate based on defn of "closeness"
- "closeness"
  - single linkage: close as nearest nodes (form snakes)
  - complete linkage: close as furthest nodes (form balls)
  - avg linkage: balanced
- assess via adjusted rand index (ARI) $in [-1,1]$ of increasing quality
== $k$-means
- hyperspherical clusters in variable space
- very fast algo, simple, better for data w/ Normal around averages
- minimize within-cluster sum of squares (WSS)
- choose $k$ via elbow plot: incr $k$ untill WSS doesn't steeply drop (care overfitting!)