# ispss

Reading and writing SPSS data. Supplementary module for R package [ilabelled](https://github.com/clewerenz/ilabelled/tree/main).

<i>ispss</i> provides a wrapper for foreign::read.spss to read in SPSS data, whereby the read-in data is formatted as i_labeled objects.

For data output: In addition to a raw data set, a special SPSS syntax is generated for writing SPSS data, whereby meta information such as variable labels, value labels, missing values and scale levels are taken into account.

# Motivation

  - <b>Reduce Dependencies</b>
    - This package does not rely on any third party packages except for its main module [ilabelled](https://github.com/clewerenz/ilabelled/tree/main)