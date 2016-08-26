## Welcome to `Deleterious Alleles` project
This is a research repo for our recent project "**incomplete dominance of deleterious alleles contribute substantially to trait variation and heterosis in maize**". The manuscript could be found via [bioRxiv]().

## Introduction
In this study, we take advantage of the genetic and genomic tools available to investigate the contribution of deleterious alleles to phenotypic variation. And then we use the deleterious annotation to inform our genomic prediction model to improve the prediction accuracy of phenotypic traits and heterosis.

## Architecture of this Repo
This project contains ~400 commits. A `largedata` directory was intentionally ignored by `github` because of large size of the files. To guide have a better sense about the project, here we briefly introduce the functions or sepecific purposes of the directories. The layout of directories is based on the idea from [ProjectTemplate](http://projecttemplate.net/architecture.html). 

1. **cache**: Here we store intermediate data sets that are generated during a preprocessing step.
2. **data**: Here we store our raw data of small size. Data of large size, i.e. > 100M, store in a `largedata` folder that has been ignored using `gitignore`.
3. **graphs**: Graphs produced during the study process.
4. **lib**: Some functions for our work.
5. **munge**: Here we store some preprocessing or data munging codes.
6. **profilling**: Analysis scripts for the project. It contains some sub-directories.
7. 




## License
This repo is free and open source for reserach usage, licensed under [GPLv2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html).

