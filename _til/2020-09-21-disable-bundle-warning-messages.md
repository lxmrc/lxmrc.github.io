---
layout: post
title: Disable annoying Bundler warnings
date: 2020-09-21 13:42 +1000
---

I kept getting these warnings after running `bundle` commands:

```
The dependency tzinfo (~> 1.2) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x64-mingw32, x86-mswin32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x64-mingw32 x86-mswin32 java`.
The dependency tzinfo-data (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x64-mingw32, x86-mswin32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x64-mingw32 x86-mswin32 java`.
The dependency wdm (~> 0.1.1) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x86-mswin32, x64-mingw32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`.
```
I don't care about these and they fill up my terminal. [This GitHub issue](https://github.com/tzinfo/tzinfo-data/issues/12) explains the messages and a number of ways to get rid of them, the simplest of which is:

```
$ bundle config --local disable_platform_warnings true
```
This only silences them locally i.e. for the current working directory/application (which is good).
