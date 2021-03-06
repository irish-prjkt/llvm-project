=======================================================
Capturing configuration information during installation
=======================================================

.. contents::
   :local:

The Problem
===========

Currently the libc++ supports building the library with a number of different
configuration options.  Unfortunately all of that configuration information is
lost when libc++ is installed. In order to support "persistent"
configurations libc++ needs a mechanism to capture the configuration options
in the INSTALLED headers.


Design Goals
============

* The solution should not INSTALL any additional headers. We don't want an extra
  #include slowing everybody down.

* The solution should not unduly affect libc++ developers. The problem is limited
  to installed versions of libc++ and the solution should be as well.

* The solution should not modify any existing headers EXCEPT during installation.
  It makes developers lives harder if they have to regenerate the libc++ headers
  every time they are modified.

* The solution should not make any of the libc++ headers dependent on
  files generated by the build system. The headers should be able to compile
  out of the box without any modification.

* The solution should not have ANY effect on users who don't need special
  configuration options. The vast majority of users will never need this so it
  shouldn't cost them.


The Solution
============

When you first configure libc++ using CMake we check to see if we need to
capture any options. If we haven't been given any "persistent" options then
we do NOTHING.

Otherwise we create a custom installation rule that modifies the installed __config
header. The rule first generates a dummy "__config_site" header containing the required
#defines. The contents of the dummy header are then prepended to the installed
__config header. By manually prepending the files we avoid the cost of an
extra #include and we allow the __config header to be ignorant of the extra
configuration all together. An example "__config" header generated when
-DLIBCXX_ENABLE_THREADS=OFF is given to CMake would look something like:

.. code-block:: cpp

  //===----------------------------------------------------------------------===//
  //
  // Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
  // See https://llvm.org/LICENSE.txt for license information.
  // SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
  //
  //===----------------------------------------------------------------------===//

  #ifndef _LIBCPP_CONFIG_SITE
  #define _LIBCPP_CONFIG_SITE

  #define _LIBCPP_HAS_NO_THREADS
  /* #undef _LIBCPP_HAS_NO_MONOTONIC_CLOCK */

  #endif
  // -*- C++ -*-
  //===----------------------------------------------------------------------===//
  //
  // Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
  // See https://llvm.org/LICENSE.txt for license information.
  // SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
  //
  //===----------------------------------------------------------------------===//

  #ifndef _LIBCPP_CONFIG
  #define _LIBCPP_CONFIG
