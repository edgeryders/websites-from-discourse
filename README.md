# NGI Forward Platform

A web-based consultation platform, developed by [Edgeryders OÜ](https://edgeryders.eu/t/6640) for the NGI Forward project.


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

TODO


## 3. Usage

TODO


## 4. Software architecture

This website uses the static website framework [Middleman](https://middlemanapp.com/). However, unlike any "normal" Middleman based website, the website is automatically rebuilt in regular intervals (like, hourly) by a Middleman installation on the server. This allows to integrate dynamic content via API calls (if it does not need updates too often).

Currently, this website integrates the following dynamic elements:

* formatted content on the pages incl. images, which can be managed in an external CMS-like system; we use non-public forum posts in the open source forum software [Discourse](https://www.discourse.org/) for this purpose, because our [main website](https://edgeryders.eu/) is made with Discourse

* **Statistics.** The number of topics, posts and users active in a Discourse category.

* **Thread lists.** Detailed lists of Discourse forum topics in a certain category.

* **Events list.** Obtained from all Discourse topics in a certain category that have a date and time attached (via the [Discourse events plugin](https://meta.discourse.org/t/69776)). Each event is shown with date, time, thumbnail image, title and teaser of the main text.

* **Other.** It is easily possible to embed any external content that can be accessed by API or simply via HTTP and that can be converted to the publishable form with some code. The result should be HTML with CSS and optionally JavaScript. For example, data visualizations such as [graphs about interactions on a Discourse forum](https://edgeryders.eu/t/10113) can be embedded in this way.

Other major software technologies and components used:

* **Bootstrap.** A mature HTML+CSS template framework developed by Twitter.

* **Markdown.** Like in Discourse, all content uses Markdown as the markup language. It is converted to HTML during the Middleman build process.

* **Ruby.** Because Middleman is written in Ruby, and it fits nicely Discourse is in Ruby as well. This is pure Ruby code, without the Ruby on Rails framework.


## 5. Licence

In general, the MIT Licence applies to this software (see file [`LICENSE`](https://github.com/edgeryders/ngi-forward-platform/blob/master/LICENSE)). The following exceptions apply:

* **Partner organization logos.** All files [`assets/images/`](https://github.com/edgeryders/ngi-forward-platform/tree/master/assets/images)`logo-*` are copyrighted and not licensed under MIT License. For the purpose of the NGI Forward Platform (which is website on a specific domain that we operate), permission to use them has been obtained, see #13. If you want to use or publish them for other purposes, you have to obtain permission from the respective organizations yourselves.

* **EU emblem.** The EU emblem in file [`assets/images/eu-emblem.png`](https://github.com/edgeryders/ngi-forward-platform/blob/master/assets/images/eu-emblem.png) is protected as a trade mark or by similar means (it's not clear so far) and its use is subject to the rules in "[The use of the EU emblem in the context of EU programmes](https://ec.europa.eu/info/sites/info/files/use-emblem_en.pdf)".

