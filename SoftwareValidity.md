# Software Validity {#SoftwareValidity}

*Chapter lead: Martijn Schuemie*

The central question of software validity is

> Does the software do what it is expected to do?

Software validity is an essential component of evidence quality: only if our analysis software does what it is expected to do can we produce reliable evidence. As described in Section \@ref(automation), it is essential to view every study as a software development exercise, creating an automated script that executes the entire analysis, from data in the Common Data Model (CDM) to the results such as estimates, figures as tables. It is this script, and any software used in this script, that must be validated. As described in Section \@ref(analysisImplementation), we can write the entire analysis as custom code, or we can use the functionality available in the [OHDSI Methods Library](https://ohdsi.github.io/MethodsLibrary/). The advantage of using the Methods Library is that great care has already been taken to ensure its validity, so establishing the validity of the entire analysis becomes less burdensome. \index{software validity} \index{common data model}

In this chapter we first describe best practices for writing valid analysis code. After this we discuss how the Methods library is validated through its software development process and testing. \index{software development process}

## Study Code Validity

### Automation As a Requirement for Reproducibility {#automation}

Traditionally, observational studies are often viewed as a journey rather than a process: a database expert may extract a data set from the database and hand this over to the data analyst, who may open it in a spreadsheet editor or other interactive tool, and start working on the analysis. In the end, a result is produced, but little is preserved of how it came about. The destination of the journey was reached, but it is not possible to retrace the exact steps taken to get there. This practice is entirely unacceptable, both because it is not reproducible, but also because it lacks transparency; we do not know exactly what was done to produce the result, so we also cannot verify that no mistakes were made. \index{study code validity}

Every analysis generating evidence must therefore be fully automated. By automated we mean the analysis should be implemented as a single script, and we should be able to redo the entire analysis from database in CDM format to results, including tables and figures, with a single command. The analysis can be of arbitrary complexity, perhaps producing just a single count, or generating empirically calibrated estimates for millions of research questions, but the same principle applies. The script can invoke other scripts, which in turn can invoke even lower-level analysis processes.

The analysis script can be implemented in any computer language, although in OHDSI the preferred language is R. Thanks to the [DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/) R package, we can connect directly to the data in CDM format, and many advanced analytics are available through the other R packages in the [OHDSI Methods Library](https://ohdsi.github.io/MethodsLibrary/).

### Programming Best Practices

Observational analyses can become very complex, with many steps needed to produce the final results. This complexity can make it harder to maintain the analysis code and increase the likelihood of making errors, as well as making it harder to notice errors. Luckily, computer programmers have over many years developed best practices for writing code that can deal with complexity, which are easy to read, reuse, adapt, and verify. [@Martin_2008] A full discussion of these best practices could fill many books. Here, we highlight these four important principles: \index{programming best practices}

- **Abstraction**: Rather than write a single large script that does everything, leading to so-called "spaghetti code" where dependencies between lines of code can go from anywhere to anywhere (e.g. a value set on line 10 is used in line 1,000), we can organize our code in units called "functions." A function should have a clear goal, for example "take random sample," and once created we can then use this function in our larger script without having to think of the minutiae of what the function does; we can abstract the function to a simple-to-understand concept.
- **Encapsulation**: For abstraction to work, we should make sure that dependencies of a function are minimized and clearly defined. Our example sampling function should have a few arguments (e.g. a dataset and a sample size), and one output (e.g. the sample). Nothing else should influence what the function does. So-called "global variables", variables that are set outside a function, are not arguments of a function, but are nevertheless used in the function, should be avoided.
- **Clear naming**: Variables and functions should have clear names, making code read almost like natural language. For example, instead of `x <- spl(y, 100)`, we can write code that reads `sampledPatients <- takeSample(patients, sampleSize = 100)`. Try to resist the urge to abbreviate. Modern languages have no limits on the length of variable and function names.
- **Reuse**: One advantage of writing clear, well encapsulated functions is that they can often be reused. This not only saves time, it also means there will be less code, so less complexity and fewer opportunities for errors.

### Code Validation

Several approaches exist to verify the validity of software code, but two are especially relevant for code implementing an observational study:

- **Code review**: One person writes the code, and another person reviews the code.
- **Double coding**: Two persons both independently write the analysis code, and afterwards the results of the two scripts are compared.

Code review has the advantage that it is usually less work, but the disadvantage is that the reviewer might miss some errors. Double coding on the other hand is usually very labor intensive, but it is less likely, although not impossible, that errors are missed. Another disadvantage of double coding is that two separate implementations *almost always*  produce different results, due to the many minor arbitrary choices that need to made (e.g. should "until exposure end" be interpreted as including the exposure end date, or not?). As a consequence, the two supposedly independent programmers often need to work together to align their analyses, thus breaking their independence.

Other software validation practices such as unit testing are less relevant here because a study is typically a one-time activity with highly complex relationships between input (the data in CDM) and outputs (the study results), making these practices less usable. Note that these practices are applied in the Methods Library.

### Using the Methods Library

The [OHDSI Methods Library](https://ohdsi.github.io/MethodsLibrary/) provides a large set of functions, allowing most observational studies to be implemented using only a few lines of code. Using the Methods Library therefore shifts most of the burden of establishing the validity of one's study code to the Library. Validity of the Methods Library is ensured by its software development process and by extensive testing.

## Methods Library Software Development Process

The OHDSI Methods Library is developed by the OHDSI community. Proposed changes to the Library are discussed in two venues: The GitHub issue trackers (for example the CohortMethod issue tracker[^issueTrackerUrl]) and the OHDSI Forums.[^forumsUrl] Both are open to the public. Any member of the community can contribute software code to the Library, however, final approval of any changes incorporated in the released versions of the software is performed by the OHDSI Population-Level Estimation Workgroup leadership (Drs. Marc Suchard and Martijn Schuemie) and OHDSI Patient-Level Prediction Workgroup leadership (Drs. Peter Rijnbeek and Jenna Reps) only.

[^issueTrackerUrl]: https://github.com/OHDSI/CohortMethod/issues
[^forumsUrl]: http://forums.ohdsi.org/

Users can install the Methods Library in R directly from the master branches in the GitHub repositories, or through a system known as "drat" that is always up-to-date with the master branches. A number of the Methods Library packages are available through R’s Comprehensive R Archive Network (CRAN), and this number is expected to increase over time.

Reasonable software development and testing methodologies are employed by OHDSI to maximize the accuracy, reliability and consistency of the Methods Library performance. Importantly, as the Methods Library is released under the terms of the Apache License V2, all source code underlying the Methods Library, whether it be in R, C++, SQL, or Java is available for peer review by all members of the OHDSI community, and the public in general. Thus, all the functionality embodied within the Methods Library is subject to continuous critique and improvement relative to its accuracy, reliability and consistency.

### Source Code Management

All of the Methods Library’s source code is managed in the source code version control system "git" publicly accessible via GitHub. The OHDSI Methods Library repositories are access-controlled. Anyone in the world can view the source code, and any member of the OHDSI community can submit changes through so-called pull requests. Only the OHDSI Population-Level Estimation Workgroup and Patient-Level Prediction Workgroup leadership can approve such requests, make changes to the master branches, and release new versions. Continuous logs of code changes are maintained within the GitHub repositories and reflect all aspects of changes in code and documentation. These commit logs are available for public review.

New versions are released by the OHDSI Population-Level Estimation Workgroup and Patient-Level Prediction Workgroup leadership as needed. A new release starts by pushing changes to a master branch with a package version number (as defined in the DESCRIPTION file inside the package) that is greater than the version number of the previous release. This automatically triggers checking and testing of the package. If all tests are passed, the new version is automatically tagged in the version control system and the package is automatically uploaded to the OHDSI drat repository. New versions are numbered using three-component version number:

- New **micro versions** (e.g. from 4.3.2 to 4.3.3) indicate bug fixes only. No new functionality, and forward and backward compatibility are guaranteed
- New **minor versions** (e.g. from 4.3.3 to 4.4.0) indicate added functionality. Only backward compatibility is guaranteed
- New **major versions** (e.g. from 4.4.0 to 5.0.0) indicate major revisions. No guarantees are made in terms of compatibility

### Documentation

All packages in the Methods Library are documented through R’s internal documentation framework. Each package has a package manual that describes every function available in the package. To promote alignment between the function documentation and the function implementation, the [roxygen2](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html) software is used to combine a function’s documentation and source code in a single file. The package manual is available on demand through R’s command line interface, as a PDF in the package repositories, and as a web page. In addition, many packages also have vignettes that highlight specific use cases of a package. All documentation can be viewed though the Methods Library website.[^methodsLibrarySiteUrl]

[^methodsLibrarySiteUrl]: https://ohdsi.github.io/MethodsLibrary/

All Method Library source code is available to end users. Feedback from the community is facilitated using GitHub’s issue tracking system and the OHDSI forums.

### Availability of Current and Historical Archive Versions

Current and historical versions of the Methods Library packages are available in two locations. First, the GitHub version control system contains the full development history of each package, and the state of a package at each point in time can be reconstructed and retrieved. Most importantly, each released version is tagged in GitHub. Second, the released R source packages are stored in the OHDSI GitHub drat repository.

### Maintenance, Support and Retirement

Each current version of the Methods Library is actively supported by OHDSI with respect to bug reporting, fixes and patches. Issues can be reported through GitHub’s issue tracking system, and through the OHDSI forums. Each package has a package manual, and zero, one or several vignettes. Online video tutorials are available, and in-person tutorials are provided from time to time.

### Qualified Personnel

Members of the OHDSI community represent multiple statistical disciplines and are based at academic, not-for-profit and industry-affiliated institutions on multiple continents.

All leaders of the OHDSI Population-Level Estimation Workgroup and OHDSI Patient-Level Prediction Workgroup hold PhDs from accredited academic institutions and have published extensively in peer reviewed journals.

### Physical and Logical Security

The OHDSI Methods Library is hosted on the GitHub[^githubUrl] system. GitHub’s security measures are described at [https://github.com/security](https://github.com/security). Usernames and passwords are required by all members of the OHDSI community to contribute modifications to the Methods Library, and only the Population-Level Estimation Workgroup and Patient-Level Prediction Workgroup leadership can make changes to the master branches. User accounts are limited in access based upon standard security policies and functional requirements.

[^githubUrl]: https://github.com/

### Disaster Recovery

The OHDSI Methods Library is hosted on the GitHub system. GitHub’s disaster recovery facilities are described at [https://github.com/security](https://github.com/security).

## Methods Library Testing

We distinguish between two types of tests performed on the Methods Library: Tests for individual functions in the packages (so-called "unit tests"), and tests for more complex functionality using simulations.

### Unit Test

A large set of automated validation tests is maintained and upgraded by OHDSI to enable the testing of source code against known data and known results. Each test begins with specifying some simple input data, then executes a function in one of the packages on this input, and evaluates whether the output is exactly what would be expected. For simple functions, the expected result is often obvious (for example when performing propensity score matching on example data containing only a few subjects); for more complicated functions the expected result may be generated using combinations of other functions available in R (for example, Cyclops, our large-scale regression engine, is tested among others by comparing results on simple problems with other regression routines in R).  We aim for these tests in total to cover 100% of the lines of executable source code.

These tests are automatically performed when changes are made to a package (specifically, when changes are pushed to the package repository). Any errors noted during testing automatically trigger emails to the leadership of the Workgroups, and must be resolved prior to release of a new version of a package. The source code and expected results for these tests are available for review and use in other applications as may be appropriate. These tests are also available to end users and/or system administrators and can be run as part of their installation process to provide further documentation and objective evidence as to the accuracy, reliability and consistency of their installation of the Methods Library.

### Simulation

For more complex functionality it is not always obvious what the expected output should be given the input. In these cases simulations are sometimes used, generating input given a specific statistical model, and establishing whether the functionality produces results in line with this known model. For example, in the [SelfControlledCaseSeries](https://ohdsi.github.io/SelfControlledCaseSeries/) package simulations are used to verify that the method is able to detect and appropriately model temporal trends in simulated data.

## Summary

\BeginKnitrBlock{rmdsummary}
- An observational study should be implemented as an automated script that executes the entire analysis, from data in the CDM to the results, to ensure reproducibility and transparency.

- Custom study code should adhere to best programming practices, including abstraction, encapsulation, clear naming, and code reuse.

- Custom study code can be validated using code review or double coding.

- The Methods Library provides validated functionality that can be used in observational studies.

- The Methods Library is validated by using a software development process aimed at creating valid software, and by testing.

\EndKnitrBlock{rmdsummary}
