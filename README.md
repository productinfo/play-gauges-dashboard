ShinobiPlay: Gauges Dashboard (Objective-C)
=====================

The Gauges dashboard project from ShinobiPlay. Demonstrates radial gauges.

![Screenshot](screenshot.png?raw=true)

Building the project
------------------

In order to build this project you'll need a copy of ShinobiGauges. If you don't have it yet, you can download a free trial from the [ShinobiGauges website](http://www.shinobicontrols.com/ios/shinobigauges/price-plans/shinobigauges/shinobigauges-free-trial-form).

If you've used the installer to install ShinobiGauges, the project should just work. If you haven't, then once you've downloaded and unzipped ShinobiGauges, open up the project in Xcode, and drag ShinobiGauges.framework from the finder into Xcode's 'frameworks' group, and Xcode will sort out all the header and linker paths for you.

If you're using the trial version you'll need to add your license key. To do so, open up GaugesDashboardViewController.m and add the following line inside `viewDidLoad`:

    [ShinobiGauges setLicenseKey:@"your license key"];

Contributing
------------

We'd love to see your contributions to this project - please go ahead and fork it and send us a pull request when you're done! Or if you have a new project you think we should include here, email info@shinobicontrols.com to tell us about it.

License
-------

The [Apache License, Version 2.0](license.txt) applies to everything in this repository, and will apply to any user contributions.
