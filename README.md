
# rayyanR (v0.1)

[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![](https://img.shields.io/github/last-commit/befriendabacterium/rayyanR.svg)](https://github.com/befriendabacterium/rayyanR/commits/main)

R ‘package’ to process review results from the Rayyan evidence synthesis platform

### Installation

RayyanR, an R ‘package’ to read dataframes of screening decisions from the Rayyan
screening platform for systematic review (<https://rayyan.ai>).

Note that you currently need to register to Rayyan and get credentials/keys for an API application before you can use this R package. Please request API keys via the [Request Form](http://ryn.ai/APIRequestForm).

``` r
remotes::install_github("https://github.com/befriendabacterium/rayyanR")

```
### Package overview

*N.B. The current version of the package is very early stage, probably very buggy and limited to reviews where the record/abstract and report/full text stage data are stored in separate Rayyan reviews. Nonetheless, as I've gotten it working for my systematic review at least, I thought it useful to create an early pre-release. As well as acting as a marker for myself of when things worked for my review, it also provides people with an opportunity to try it on their reviews and flag early bugs in GitHub Issues, ahead of a first proper release.*

The current, pre-release version of the package is intended to be an interface to v1 of the Rayyan API, which allows you to download review data from Rayyan (reviewresults.R), and feed it into a PRISMA2020 diagram alongside pre-screening data (rayyan2PRISMA2020.R). Currently, it will only work (hopefully...) with 'old school' Rayyan reviews from a time where there was not a full text screening stage, and so the record/abstract and report/full text stage data are stored in separate Rayyan reviews. This is because whilst having both stages in one review is the now the recommended implementation of Rayyan, the API does not currently have an endpoint to the Full Text stage of a review with two stages (I assume because this feature was added to Rayyan fairly recently). But hopefully this will be implemented soon, and I can incorporate it into the package soon (I am speaking to Rayyan about this)!

To (attempt to) use the current pre-release version of the package in its entirity:

1. Make a Rayyan review for the report/abstract stage of your review, and do your screening with another reviewer.
2. Export the results within Rayyan as a .ris file, and upload them into a new Rayyan review for the report/full text stage. Do your screening with another reviewer.
3. Feed both record and report review IDs into the reviewresults() function alongside your API tokens
4. Optionally, feed the resulting dataframe in as the 'screening_recordsandreports.R' parameter of 'rayyan2PRISMA2020.R', alongside your Identification (searches and deduplication) stage data and some other parameters, to make a PRISMA2020 diagram with the [PRISMA2020 R package](https://github.com/prisma-flowdiagram/PRISMA2020).

The dataframe produced by reviewresults() will be a bit messy, as it currently reads in all Rayyan Labels and Exclusion Reasons from all reviewers (!). However, provided you specify the exclusion reason strings you want to tally up exactly and you have not used specified them both as Labels *and* Exclusion Reasons in Rayyan, then it should manage to tally them up correctly...

### Issues and suggestions

Again, this is a very early and no doubt buggy and lacking in features pre-release version. Therefore, I really, really welcome reporting of issues/bugs/feature requests/general moaning at me via the [issues
link](https://github.com/befriendabacterium/rayyanR/issues) for the repository. Thanks!

### API documentation for anyone wishing to contribute

The Rayyan API v1 documentation is currently only accessible via Insomia, a software that you now have to pay for. However, you can access the API documentation by:

1. Downloading and installing an old version of Insomnia [here](https://github.com/Kong/insomnia/releases/tag/core%402023.5.7). Insomnia.Core-2023.5.7.exe is the one you need for Windows, Insomnia.Core-2023.5.7.dmg is the one you need for Mac.
2. Cloning the Rayyan API v1 repository [here](https://github.com/rayyansys/rayyan-api-docs) inside Insomnia. You can use [this guide](https://docs.insomnia.rest/insomnia/git-sync) but the version of Insominia you'll be using is slightly different so the screenshots/process will not align completely. You will need to use the 'Git clone' option and authenticate with GitHub to do this - remember to clone the Rayyan API Github repo, not this one!
3. You should see all endpoints in the API. Try them one by one and go to any endpoint and click the Docs tab for more information.

### Citing this package

Please cite this package as: Jones ML, Murray, L, Grainger MJ & Pritchard, C (2025). rayyanR: An R package to process outputs of the Rayyan screening platform for systematic reviews. <a href="https://github.com/befriendabacterium/rayyanR" target="_blank">https://github.com/befriendabacterium/rayyanR</a>.

### Acknowledgements

The current version of the package was produced with the support of [Evidence Synthesis Hackathon](https://www.eshackathon.org/) at their Newcastle 2023, 2024, and London 2025 in-person hackathons. They are great and we thank them dearly, alongside support from [Evidence-Based Toxicology Collaboration](https://www.ebtox.org/), who funded Matt Lloyd Jones's attendance at the Newcastle 2024 hackathon.
