# Websites From Discourse

A [Middleman](https://middlemanapp.com/)-based framework for semi-static, multilingual websites that can be edited via [Discourse](https://www.discourse.org/) forum posts.


## Content

[**1. Overview**](#1-overview)

[**2. Installation**](#2-installation)

[**3. Usage**](#3-usage)

[**4. Software architecture**](#4-software-architecture)

[**5. Licence**](#5-licence)

------


## 1. Overview

This website publishing framework uses the static website framework [Middleman](https://middlemanapp.com/) and gets its content mostly from the open source forum software [Discourse](https://www.discourse.org/). This allows using Discourse as a basic CMS to edit the content on the website.

Unlike a typical static website, this one allows quasi-dynamic content because Middleman is installed server-side and set up to re-generate the website every few minutes. The platform supports multiple language versions and, just like in Discourse itself, all content uses Markdown for formatting while HTML is also supported.

The result is a fast web platform with dynamic content that has no or minimal potential security issues because it's a static website. Also the source code turns out to be easy and comfortable to maintain: it is very compact because all the content resides in Discourse rather than being mixed into the code.

**Branch overview.** Here's the overview of our branch setup:

* **`master`.** The only branch you need to care about when wanting to use this software. It contains a website scaffolding structure with all features but no actual content. Most other branches are for individual project websites, containing added content.

* **`ngi-forward`.** A web-based exchange platform for a co-design and participation process. Developed by [Edgeryders OÜ](https://edgeryders.eu/t/6640) for the NGI Forward project. The platform can be seen live under [ngi.edgeryders.eu](https://ngi.edgeryders.eu/).

* **`reef2.`** Project website for the Edgeryders "Reef 2.0" project, a collective living space in Brussels that is currently in the making.

* **`econsf.`** Project website for the Edgeryders "Economic Science-Fiction Seminary" project, an event in Brussels in autumn 2019.


## 2. Installation

**Requirements.** You need to install the following prerequisites on your computer resp. your server:

* **`git`.** A version control system for source files.
* **Ruby.** The programming language of Middleman and Discourse. Under Ubuntu installed with `sudo apt install ruby`. The Ubuntu packages also provide `gem`.
* **`bundler`.** The Ruby dependency manager. Installed with `sudo gem install bundler`.
* **`npm`.** The Node.js package manager, needed for Bootstrap. Under Ubuntu installed with `sudo apt install npm`.
* [Middleman](https://middlemanapp.com/). Installed with `sudo gem install middleman`.
* **Apache2.** A web server. We need it just for serving static files, and of course you can install any webserver you like for that purpose.

**Installation and configuration.** With the requirements in place, install this software as follows:

1. **Fork this repository.** This website framework relies on a web-accessible git repository for deployment, and the easiest way for that is forking this Github repository into your own account. Use the top-right "Fork" button here on the Github repository webpage for that. Alternatively, clone it into any other web-accessible git repository of your liking.

2. **Clone your repository.** Now that you have an "authoritative" online git repository that will always contain the latest code of your website, clone it to your server (if you want to install for deployment) resp. to your local computer (if you want to install for development). You only need to clone the relevant branch, which is `master` if you want to start development on a new website project or one of the existing website branches to deploy that website on a server or develop it further. To clone only one branch:

    ```
    git clone --single-branch -b <branchname> https://github.com/<username>/websites-from-discourse.git
    ```

3. **For a new website: create a new branch.** This keeps the master branch clean for pulling in new updates from the origin repository, and allows you to manage multiple websites with one Github account. Reason: with one branch per website, pull requests between the branches for code re-use are possible on Gitub. Pull requests are not supported between copied repositories. They are supported between forked repositories, but forked repositories are not possible within the same Github account. To create a new branch locally and in the remote repo:

    ```
    git checkout -b <branchname>
    git push --set-upstream origin <branchname>
    ```

4. **Install required packages.** To install all gem and npm libraries required by Middleman and the website project, execute the following.

    ```
    cd /path/to/document/root/;
    bundle install;
    npm install;
    ```

    This will install the gems system-wide, which can be argued to be the "right" way to install libraries (namely, in a re-usable manner). For `npm` we'd like to do a similar thing, but `sudo npm install --global` just malfunctions, installing the stuff still into the local directory but with root file ownership and permissions. We'll get rid of using `npm` at all soon in this project, so let's ignore this issue for now. If you rather want to install the gems for your website only, execute:

    ```
    cd /path/to/document/root/;
    bundle install --path vendor/bundle;
    npm install;
    ```

5. **Configure the webserver.** At the minimum, create a new virtual host / website configuration and point its `DOCUMENT_ROOT` to the `build/` subdirectory of your copy of this repository.

6. **Deploy and test.** Execute the following command in the repository's directory and check if the website is accessible afterwards.

    ```
    LC_ALL="en_US.UTF-8" bundle exec middleman build --verbose;
    ```

7. **Configure deployment.** For automatic updates of the website when deployed on a server, you need a cron job that runs a deployment script (here `deploy.sh`) regularly, for example once per hour or once in 15 minutes, depending on how close to realtime you need the dynamic information on the site.

    Configuring cron jobs can be horrible if you need to provide certain environment for your command to run. For example, if you use `chruby` or another mechanism to select one of multiple installed Ruby versions, your `deploy.sh` depends on `$PATH` etc. changes as set up by that system. In the case of `chruby`, our `deploy.sh` had to look like this:

    ```
    #!/bin/bash

    # Provide cron with the chruby environment as seen in `/etc/profile.d/chruby.sh`.
    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh

    cd /path/to/document/root/;

    # For now, we just assume to be on the right branch for our website. TODO: throw an error if not.
    git pull;

    LC_ALL="en_US.UTF-8" bundle exec middleman build;
    ```
    And our entry for the cron job in `/etc/crontab` had to be as follows:

    ```
    */15 * * * * username bash --login -c '/path/to/deploy.sh' >>/path/to/cron.log 2>>/path/to/cron_error.log
    ```

    For manual deployment on a local computer during development, you can create a simplified version of the above `deploy.sh`, usually only containing the `bundle exec middleman build` step.


## 3. Usage

**Editing content.** Edit the relevant Discourse posts defined in the [mapping file](https://github.com/edgeryders/ngi-forward-platform/blob/master/data/discourse_sources.yml). It makes sense to place all this content into one Discourse category. We used the [Internet of Humans → Web Content](https://edgeryders.eu/c/ioh/web-content) sub-category. It is non-public to prevent redundant public content on the Internet (which may lead to user confusion and SEO penalties).

**Editing templates, i18n string translations or code.** These parts of the website are directly hosted inside this Github repository. Edit them with the usual pull/edit/commit/push git workflow. For small edits, you can also directly change the file using the Github web interface. Hints on where to edit what:

* **Color scheme.** See `assets/css/_bootstrap-variables.scss`.

* **Logos.** See `source/assets/`.

* **CSS overrides and additions.** See `assets/css/index.scss`. Everything you want to look different from standard Bootstrap should go here.

* **Discourse content sources.** See `data/discourse_sources.yml`.

**Rebuilding the site.** If set up as instructed above, on a sever the website will rebuild itself automatically at every cron job run, which includes updating the repository from Github, all content and all other dynamic elements. When you are editing the site and want to see the results immediately, on a server you can also execute the cron job script manually:

```
/path/to/document/root/deploy.sh;
```

(Later, [we will also provide a URL switch](https://github.com/edgeryders/websites-from-discourse/issues/38) for the same purpose.)


## 4. Software architecture

This website uses the static website framework [Middleman](https://middlemanapp.com/). However, unlike any "normal" Middleman based website, the website is automatically rebuilt in regular intervals (like, hourly) by a Middleman installation on the server. This allows to integrate dynamic content via API calls (if it does not need updates too often).

For example, the `ngi-forward` branch integrates the following dynamic elements:

* **Formatted content.** The content blocks incl. images used on the various pages can be managed in an external CMS-like system. We use non-public, wiki-type posts in the open source forum software [Discourse](https://www.discourse.org/) for this purpose, because our [main website](https://edgeryders.eu/) is made with Discourse. Each text block maps to one topic in Discourse, and each translation of that text block to one post in that topic. The mapping is defined in [`data/discourse_sources.yml`](https://github.com/edgeryders/ngi-forward-platform/blob/master/data/discourse_sources.yml).

* **Statistics.** The number of topics, posts and users active in a Discourse category.

* **Thread lists.** Detailed lists of Discourse forum topics in a certain category.

* **Events list.** Obtained from all Discourse topics in a certain category that have a date and time attached (via the [Discourse events plugin](https://meta.discourse.org/t/69776)). Each event is shown with date, time, thumbnail image, title and teaser of the main text.

* **Other.** It is easily possible to embed any external content that can be accessed by API or simply via HTTP and that can be converted to the publishable form with some code. The result should be HTML with CSS and optionally JavaScript. For example, data visualizations such as [graphs about interactions on a Discourse forum](https://edgeryders.eu/t/10113) can be embedded in this way.

Other major software technologies and components used:

* **Bootstrap.** A mature HTML+CSS template framework developed by Twitter.

* **Markdown.** Like in Discourse, all content uses Markdown as the markup language. It is converted to HTML during the Middleman build process.

* **Ruby.** Because Middleman is written in Ruby, we also use Ruby. Note that this is about pure Ruby code, without the Ruby on Rails framework. It fits nicely because Discourse itself is written in Ruby as well.


## 5. Licence

In general, the MIT Licence applies to this software (see file [`LICENSE`](https://github.com/edgeryders/ngi-forward-platform/blob/master/LICENSE)). The following exceptions apply:

* **Branch `ngi-forward`: partner organization logos.** All files [`assets/images/logo-*`](https://github.com/edgeryders/ngi-forward-platform/tree/master/assets/images) are copyrighted and not licensed under MIT License. For the purpose of the NGI Forward Platform (which is website on a specific domain that we operate), permission to use them has been obtained, see #13. If you want to use or publish them for other purposes, you have to obtain permission from the respective organizations yourselves.

* **Branch `ngi-forward`: EU emblem.** The EU emblem in file [`assets/images/eu-emblem.png`](https://github.com/edgeryders/ngi-forward-platform/blob/master/assets/images/eu-emblem.png) is protected as a trade mark or by similar means (it's not clear so far) and its use is subject to the rules in "[The use of the EU emblem in the context of EU programmes](https://ec.europa.eu/info/sites/info/files/use-emblem_en.pdf)".
