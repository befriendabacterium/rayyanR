
# rayyanR

[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![](https://img.shields.io/github/last-commit/befriendabacterium/rayyanR.svg)](https://github.com/befriendabacterium/rayyanR/commits/main)

R ‘package’ to process Rayyan outputs

### Overview and installation

RayyanR, an R ‘package’ to read dataframes of screening decisions from the Rayyan
screening platform for systematic review (<https://rayyan.ai>).

Note that you currently need to register to Rayyan and get credentials/keys for an API application before you can use this R package. Please request API keys via the [Request Form](http://ryn.ai/APIRequestForm).

``` r
remotes::install_github("https://github.com/befriendabacterium/rayyanR")
```

The Rayyan API v1 documentation is currently only accessible via Insomia, a software that you now have to pay for. However, you can access the API documentation by:

1. Downloading and installing an old version of Insomnia [here](https://github.com/Kong/insomnia/releases/tag/core%402023.5.7). Insomnia.Core-2023.5.7.exe is the one you need for Windows, Insomnia.Core-2023.5.7.dmg is the one you need for Mac.
2. Cloning the Rayyan API v1 repository [here](https://github.com/rayyansys/rayyan-api-docs) inside Insomnia using [this guide](https://docs.insomnia.rest/insomnia/git-sync). N.B. You will need to use the 'Git clone' option and authenticate with GitHub to do this - remember to clone the Rayyan API Github repo, not this one!
3. You should see all endpoints in the API. Try them one by one and go to any endpoint and click the Docs tab for more information.

### Issues and suggestions

Please report any issues and suggestions on the [issues
link](https://github.com/befriendabacterium/rayyanR/issues) for the
repository.

### Package overview

Currently a one-function (‘get_review_results_df_tidied()’) package to read bibliographic dataframes directly from Rayyan via the API, and process them into a more human-readable and R-user friendly format.

### Citing this package

Please cite this package as: Jones ML, Pritchard, C & Grainger MJ (2025). rayyanR: An R package to process outputs of the Rayyan screening platform for systematic reviews. <a href="https://github.com/befriendabacterium/rayyanR" target="_blank">https://github.com/befriendabacterium/rayyanR</a>.
