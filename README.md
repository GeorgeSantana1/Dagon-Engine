[![Build Status](https://travis-ci.org/gecko0307/dagon.svg?branch=master)](https://travis-ci.org/gecko0307/dagon)
[![DUB Package](https://img.shields.io/dub/v/dagon.svg)](https://code.dlang.org/packages/dagon)
[![DUB Downloads](https://img.shields.io/dub/dt/dagon.svg)](https://code.dlang.org/packages/dagon)
[![License](http://img.shields.io/badge/license-boost-blue.svg)](http://www.boost.org/LICENSE_1_0.txt)
[![Patreon button](https://img.shields.io/badge/patreon-donate-yellow.svg)](http://patreon.com/gecko0307 "Become a Patron!")

Dagon
=====
The goal of this project is creating a modern, easy to use, extendable 3D game engine for D language. Dagon is based on OpenGL 4.0 core profile. It works on Windows and Linux, both 32 and 64-bit. 

> This is current development branch of the engine. You are recommended to use [stable branch](https://github.com/gecko0307/dagon) instead. Follow Dagon development on [Trello](https://trello.com/b/4sDgRjZI/dagon) to see priority tasks. 

If you like Dagon, please support its development on [Patreon](https://www.patreon.com/gecko0307) or [Liberapay](https://liberapay.com/gecko0307). You can also make one-time donation via [PayPal](https://www.paypal.me/tgafarov). I appreciate any support. Thanks in advance!

Features
--------
Feature set in Dagon NG is not stabilized yet.

Screenshots
-----------
[![Screenshot1](https://1.bp.blogspot.com/-qC2fIlkQA7E/XO2335jW2iI/AAAAAAAAD8M/Tc9Wjg2CkzUMyo2k_Kg35y70qkUj7-FIwCPcBGAYYCw/s1600/2019-05-29%2B01_20_42-Dagon%2BNG.jpg)](https://1.bp.blogspot.com/-qC2fIlkQA7E/XO2335jW2iI/AAAAAAAAD8M/Tc9Wjg2CkzUMyo2k_Kg35y70qkUj7-FIwCPcBGAYYCw/s1600/2019-05-29%2B01_20_42-Dagon%2BNG.jpg)

[![Screenshot2](https://1.bp.blogspot.com/-IaDVtXOtJZw/XWG0FeJPFuI/AAAAAAAAEHQ/lk9WdRFGlegSSt0hnNLFEdGw_6XyrS7NgCLcBGAs/s1600/ng-terrain-bushes.jpg)

Made with Dagon
---------------
* [dagon-demo](https://github.com/gecko0307/dagon-demo) - a test application that demonstrates most of Dagon's features
* [Dagoban](https://github.com/Timu5/dagoban) - a Sokoban clone based on Dagon and Nuklear
* [dagon-shooter](https://github.com/aferust/dagon-shooter) - a shooter game using Dagon
* [Introductory examples](https://github.com/gecko0307/dagon-tutorials).

Usage
-----
To use Dagon NG, add the following dependency to your `dub.json`:
```
"dagon": "~dagon-ng"
```
Be ready for breaking changes at any time.

Dependencies
------------
Dagon depends on the following D packages:
* [dlib](https://github.com/gecko0307/dlib)
* [bindbc-opengl](https://github.com/BindBC/bindbc-opengl)
* [bindbc-sdl](https://github.com/BindBC/bindbc-sdl)
* [bindbc-freetype](https://github.com/BindBC/bindbc-freetype)
* [bindbc-nuklear](https://github.com/Timu5/bindbc-nuklear)

Runtime dependencies (dynamic link libraries):
* [SDL](https://www.libsdl.org) 2.0.5
* [Freetype](https://www.freetype.org) 2.8.1
* [Nuklear](https://github.com/vurtun/nuklear)

Under Windows runtime dependencies are automatically deployed if you are building with Dub. Under other OSes you have to install them manually. You can also compile Dagon without Freetype and Nuklear support, if you don't need text and UI rendering. To do that, add the following to your project's `dub.json`:

```d
"subConfigurations": {
    "dagon": "Minimal"
}
```

Supported subConfigurations are also `"NoNuklear"` and `"NoFreetype"` to remove these dependencies separately.

Documentation
-------------
Doesn't exist yet. There are [tutorials](https://github.com/gecko0307/dagon/wiki/Tutorials) on Dagon 0.10.0 usage.

License
-------
Copyright (c) 2016-2019 Timur Gafarov, Rafał Ziemniewski, Mateusz Muszyński, Björn Roberg, dayllenger. Distributed under the Boost Software License, Version 1.0 (see accompanying file COPYING or at http://www.boost.org/LICENSE_1_0.txt).

Sponsors
--------
Rafał Ziemniewski, Kumar Sookram, Aleksandr Kovalev.
