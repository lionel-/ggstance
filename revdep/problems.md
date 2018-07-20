# cobalt

Version: 3.3.0

## In both

*   checking re-building of vignette outputs ... WARNING
    ```
    ...
    Loaded glmnet 2.0-16
    
    CBPS: Covariate Balancing Propensity Score
    Version: 0.19
    Authors: Christian Fong [aut, cre],
      Marc Ratkovic [aut],
      Kosuke Imai [aut],
      Chad Hazlett [ctb],
      Xiaolin Yang [ctb],
      Sida Peng [ctb]
    
    ##
    ## ebal Package: Implements Entropy Balancing.
    
    ## See http://www.stanford.edu/~jhain/ for additional information.
    
    
    Quitting from lines 225-239 (cobalt_A1_other_packages.Rmd) 
    Error: processing vignette 'cobalt_A1_other_packages.Rmd' failed with diagnostics:
    there is no package called 'designmatch'
    Execution halted
    ```

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘designmatch’
    ```

# jtools

Version: 1.0.0

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      3: capture(act$val <- eval_bare(get_expr(quo), get_env(quo)))
      4: withCallingHandlers(code, message = function(condition) {
             out$push(condition)
             invokeRestart("muffleMessage")
         })
      5: eval_bare(get_expr(quo), get_env(quo))
      6: print(plot_coefs(fit, plot.distributions = TRUE))
      7: plot_coefs(fit, plot.distributions = TRUE)
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      OK: 406 SKIPPED: 0 FAILED: 1
      1. Error: plot.distributions works (@test-export-summs.R#272) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

*   checking re-building of vignette outputs ... WARNING
    ```
    Error in re-building vignettes:
      ...
    Loading required package: grid
    Loading required package: Matrix
    Loading required package: survival
    
    Attaching package: 'survey'
    
    The following object is masked from 'package:graphics':
    
        dotchart
    
    Quitting from lines 287-288 (summ.Rmd) 
    Error: processing vignette 'summ.Rmd' failed with diagnostics:
    argument is of length zero
    Execution halted
    ```

*   checking Rd cross-references ... NOTE
    ```
    Packages unavailable to check Rd xrefs: ‘effects’, ‘wec’, ‘arm’, ‘rockchalk’, ‘pequod’, ‘car’, ‘piecewiseSEM’
    ```

# scatr

Version: 1.0.1

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘R6’ ‘cowplot’ ‘ggplot2’ ‘ggridges’ ‘ggstance’ ‘jmvcore’
      All declared Imports should be used.
    ```

