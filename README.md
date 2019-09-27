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
* **Ruby.** The programming language of Middleman and Discourse. Under Ubuntu installed with `sudo apt install ruby`. The Ubuntu packages also provides `gem`. For this repo, you will need Ruby 2.5.3 (or higher, probably).
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

4. **Configure your Ruby version manager (if you use one).** You must do it at this point because otherwise you would install a `bundler` version globally on the system in the next step, which can severely mess things up if you *want* to use a Ruby version switching mechanism like `chruby`.

    Now that [all major Ruby version managers understand `.ruby-version`](https://github.com/postmodern/chruby#auto-switching), configuring it simply means to create a file `.ruby-version` in the project root directory, with a string in it representing a Ruby version. In our case "`2.5.3`" or a higher version. Afterwards, check that your Ruby version manager has this as its chosen version now (in case of `chruby`: execute `chruby` while in the project root directory, and the output should contain a line like `* ruby-2.5.3` with your chosen version).

5. **Log in as the system user that will run your software.** This is needed to not run `bundler` as root, which would make the installed bundle only accessible for the root user.

6. **Install `bundler`.** Bundler is the Ruby dependency manager. Installation:

    * If you don't use a Ruby version manager, just install the gem globally via `sudo gem install bundler`.
    * If you do use a Ruby version manager, you (probably) want all your gems to be locally installed. In that case, even if you already have a globally installed `bundler` (see `which bundler`), you can install one into the `.gem/` directory of the current user by executing `gem install bundler`. It is however advisable to not have a globally installed `bundler` at the same time. It can only mess things up!

7. **Install required gems.** To install all gem libraries required by Middleman and the website project, install the packages from inside inside the root folder of your project:

    ```
    cd /path/to/document/root/;
    bundle install;
    ```

    If you use a Ruby version manager like `chruby`, this will install the gems into the `~/.gem/ruby/x.x.x/gems/` folder, so a local installation, which makes sense in this case. If you don't use a Ruby version manager, this will install the gems globally – which also makes sense in this case, as it installs libraries in the most re-usable manner. To force a local installation into the project directory in this case, you can do `bundle install --path vendor/bundle`.

8. **Install required NodeJS packages.** Unfortunately, due to Bootstrap we currently have to also install various packages and tools via `npm`, but this will be fixed in the future. Here, a system-wide installation *should* be possible with `sudo npm install --global` but it did not work when I tried. So for this, I don't bother and just do a local installation as we'll remove all of NodeJS shortly anyway:

    ```
    cd /path/to/document/root/;
    npm install;
    ```

9. **Configure the Discourse API key.** The application uses a Discourse API key to obtain website content from topics in a category that should be access protected to not be confusing redundant content in addition to the website. Obtain a Discourse admin API key under "☰ → Admin → API → API" of your Discourse installation. Then create a file `.env` in the project root directory and put in your API key in the following format:

    ```
    DISCOURSE_API_KEY=95a7f30ed63…
    ```

10. **Configure the webserver.** At the minimum, create a new virtual host / website configuration and point its `DOCUMENT_ROOT` to the `build/` subdirectory of your copy of this repository. In case of Apache2:

    ```
    DocumentRoot /var/www/…/build

    <Directory /var/www/…/build>
      Options +FollowSymLinks
      AllowOverride All
      Require all granted
    </Directory>
    ```

11. **Configure file permissions.** A `git pull` will be executed during the build, which may create files in `.git/` and in your project directory. So make sure that all files in both directories are owned by the user who will execute the build.

12. **Build and test.** Execute the following command in the repository's directory and check if the website is accessible afterwards.

    ```
    LC_ALL="en_US.UTF-8" bundle exec middleman build --verbose --clean;
    ```

13. **Start the development server.** You can use the above `middleman build` command to see changes you make during development, but it is much faster and simpler to see them via Middleman's internal web server. [Auto-reload](https://middlemanapp.com/basics/development-cycle/) of the browser page is already configured for this. Start the internal server with:

    ```
    LC_ALL="en_US.UTF-8" bundle exec middleman server;
    ```

    and then view the site at the URL you'll see in the output of that command.

14. **Configure automatic deployment builds.** For automatic updates of the website when deployed on a server, you need a cron job that runs a deployment script (here `deploy.sh`) regularly, for example once per hour or once in 15 minutes, depending on how close to realtime you need the dynamic information on the site.

    Configuring cron jobs can be horrible if you need to provide certain environment for your command to run. For example, if you use `chruby` or another mechanism to select one of multiple installed Ruby versions, your `deploy.sh` depends on `$PATH` etc. changes as set up by that system. In the case of `chruby`, our `deploy.sh` had to look like this:

    ```
    #!/bin/bash

    # Provide cron with the chruby environment as seen in `/etc/profile.d/chruby.sh`.
    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh

    cd /path/to/document/root/;

    # For now, we just assume to be on the right branch for our website. TODO: throw an error if not.
    git pull;

    LC_ALL="en_US.UTF-8" bundle exec middleman build --clean;
    ```
    And our entry for the cron job in `/etc/crontab` had to be as follows:

    ```
    */15 * * * * username bash --login -c '/path/to/deploy.sh' >>/path/to/cron.log 2>>/path/to/cron_error.log
    ```

    File `/path/to/cron_error.log` must exist and `username` must be a user in whose home directory (as listed in `/etc/passwd`) there is a `.gem/` directory with the gems you installed above via `bundle install`. Otherwise it may fall back on system-wide installed gems and then everything is messed up.

    For manual deployment on a local computer during development, you can create a simplified version of the above `deploy.sh`, usually only containing the `bundle exec middleman build` step.


## 3. Usage

**Editing content.** Edit the relevant Discourse posts defined in the [mapping file](https://github.com/edgeryders/ngi-forward-platform/blob/master/data/discourse_sources.yml). It makes sense to place all this content into one Discourse category. It can be made non-public to prevent redundant public content on the Internet (which may lead to user confusion and SEO penalties).

When editing content, you can use all [standard Markdown syntax](https://daringfireball.net/projects/markdown/syntax), plus the following extensions, which are also supported by Discourse itself:

* **Markdown inside HTML.** In Discourse, you can use Markdown inside HTML block-level tags. This is [not standard Markdown](https://daringfireball.net/projects/markdown/syntax#html), but supported here as well.

In practice, the most important differences to how you'd write and format content in Discourse itself are the following:

* **Images with `upload://` are not supported.** Instead, after uploading an image in the Discourse editor, convert it to `<img src="…" />` syntax using its absolute URL as shown in the editor's preview.

* **HTML element attributes are supported.** In Discourse, HTML element attributes like `id` and `class` are stripped before rendering the output (with a few exceptions). In this framework, they are kept untouched. This allows you to include CSS formatting hints and even Bootstrap CSS classes inside your Discourse content.

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
