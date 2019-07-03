# NGI Forward Platform

A web-based exchange platform for a co-design and participation process. Developed by [Edgeryders OÜ](https://edgeryders.eu/t/6640) for the NGI Forward project.


## Content

[**1. Overview**](#1-overview)

[**2. Installation**](#2-installation)

[**3. Usage**](#3-usage)

[**4. Software architecture**](#4-software-architecture)

[**5. Licence**](#5-licence)

------


## 1. Overview

The website built here can be seen live under [ngi.edgeryders.eu](https://ngi.edgeryders.eu/) (preliminary domain, will change later). It uses the static website framework [Middleman](https://middlemanapp.com/) and gets its content mostly from the open source forum software [Discourse](https://www.discourse.org/). This allows using Discourse as a basic CMS to edit the content on a website. Like Discourse, all content uses Markdown as markup language.


## 2. Installation

For deployment, you need to install the following on your server:

* `git`
* Ruby
* `bundler`, the Ruby dependency manager
* `npm`, needed for Bootstrap
* [Middleman](https://middlemanapp.com/)
* the code from this repository, by cloning the repository

After the basic installation is done, configure it as follows:

1. Make the `DOCUMENT_ROOT` of your website point to the `build/` subdirectory of your copy of this repository.

2. Create a build script `deploy.sh` and place it into the root directory of your copy of this repository. Content will usually be like this:

    ```
    #!/bin/bash
    git pull https://github.com/edgeryders/ngi-forward-platform;
    LC_ALL="en_US.UTF-8" bundle exec middleman build;
    ```

3. Execute your `deploy.sh` and check if the website is now accessible.

4. Configure a cron job that runs `deploy.sh` regularly, for example once per hour or once in 15 minutes, depending on how close to realtime you need the dynamic information on the site.

    Configuring cron jobs can be horrible if you need to provide certain environment for your command to run. For example, if you use `chruby` or another mechanism to select one of multiple installed Ruby versions, your `deploy.sh` depends on `$PATH` etc. changes as set up by that system. In the case of `chruby`, we had to do the following steps until the cron job started to work:
    
    1. Adding the environment changes done by `chruby` (as seen in `/etc/profile.d/chruby.sh`) to the top of the `deploy.sh` script:
    
           source /usr/local/share/chruby/chruby.sh
           source /usr/local/share/chruby/auto.sh
    
    2. Configuring the cron job in `/etc/crontab` as follows:
    
           */15 * * * * username bash --login -c '/path/to/deploy.sh' >>/path/to/cron.log 2>>/path/to/cron_error.log


## 3. Usage

**Editing content.** Edit the relevant Discourse posts defined in the [mapping file](https://github.com/edgeryders/ngi-forward-platform/blob/master/data/discourse_sources.yml). It makes sense to place all this content into one Discourse category. We used the [Internet of Humans → Web Content](https://edgeryders.eu/c/ioh/web-content) sub-category. It is non-public to prevent redundant public content on the Internet (which may lead to user confusion and SEO penalties).

**Editing templates, i18n string translations or code.** These parts of the website are directly hosted inside this Github repository. Edit them with the usual pull/edit/commit/push git workflow. For small edits, you can also directly change the file using the Github web interface.

**Rebuilding the site.** The website will rebuild itself automatically at every cron job run, which includes updating the repository from Github, all content and all other dynamic elements. When you are editing and immediately want to see how the results look, you can trigger a rebuilding via SSH as follows:

```
ssh edgeryders_ngi_user@server.edgeryders.eu

web32@server:~$ cd /var/www/clients/client12/ngi.edgeryders.eu/web
web32@server:~$ ./deploy.sh
```

(Later, [we will also provide a URL switch](https://github.com/edgeryders/ngi-forward-platform/issues/38) for the same purpose.)


## 4. Software architecture

This website uses the static website framework [Middleman](https://middlemanapp.com/). However, unlike any "normal" Middleman based website, the website is automatically rebuilt in regular intervals (like, hourly) by a Middleman installation on the server. This allows to integrate dynamic content via API calls (if it does not need updates too often).

Currently, this website integrates the following dynamic elements:

* **Formatted content.** The content blocks incl. images used on the various pages can be managed in an external CMS-like system. We use non-public, wiki-type posts in the open source forum software [Discourse](https://www.discourse.org/) for this purpose, because our [main website](https://edgeryders.eu/) is made with Discourse. Each text block maps to one topic in Discourse, and each translation of that text block to one post in that topic. The mapping is defined in [`data/discourse_sources.yml`](https://github.com/edgeryders/ngi-forward-platform/blob/master/data/discourse_sources.yml).

* **Statistics.** The number of topics, posts and users active in a Discourse category.

* **Thread lists.** Detailed lists of Discourse forum topics in a certain category.

* **Events list.** Obtained from all Discourse topics in a certain category that have a date and time attached (via the [Discourse events plugin](https://meta.discourse.org/t/69776)). Each event is shown with date, time, thumbnail image, title and teaser of the main text.

* **Other.** It is easily possible to embed any external content that can be accessed by API or simply via HTTP and that can be converted to the publishable form with some code. The result should be HTML with CSS and optionally JavaScript. For example, data visualizations such as [graphs about interactions on a Discourse forum](https://edgeryders.eu/t/10113) can be embedded in this way.

Other major software technologies and components used:

* **Bootstrap.** A mature HTML+CSS template framework developed by Twitter.

* **Markdown.** Like in Discourse, all content uses Markdown as the markup language. It is converted to HTML during the Middleman build process.

* **Ruby.** Because Middleman is written in Ruby. It fits nicely because Discourse itself is written in Ruby as well. This is pure Ruby code, without the Ruby on Rails framework.


## 5. Licence

In general, the MIT Licence applies to this software (see file [`LICENSE`](https://github.com/edgeryders/ngi-forward-platform/blob/master/LICENSE)). The following exceptions apply:

* **Partner organization logos.** All files [`assets/images/logo-*`](https://github.com/edgeryders/ngi-forward-platform/tree/master/assets/images) are copyrighted and not licensed under MIT License. For the purpose of the NGI Forward Platform (which is website on a specific domain that we operate), permission to use them has been obtained, see #13. If you want to use or publish them for other purposes, you have to obtain permission from the respective organizations yourselves.

* **EU emblem.** The EU emblem in file [`assets/images/eu-emblem.png`](https://github.com/edgeryders/ngi-forward-platform/blob/master/assets/images/eu-emblem.png) is protected as a trade mark or by similar means (it's not clear so far) and its use is subject to the rules in "[The use of the EU emblem in the context of EU programmes](https://ec.europa.eu/info/sites/info/files/use-emblem_en.pdf)".

