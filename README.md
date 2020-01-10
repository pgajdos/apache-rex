apache-rex
==========

This package contains several runnable examples and utility to run them
(or other examples in the structure the utility expects). Examples are 
not required to be minimal or usable in practice, but are allowed to be
such.

Quick Start
-----------
    $ git clone https://github.com/pgajdos/apache-rex.git
    $ cd apache-rex
    $ ./run-rex mod_macro-basic
    $ /usr/sbin/httpd -f /tmp/apache-rex/mod_macro-basic/httpd.conf
    $ /usr/sbin/httpd -f /tmp/apache-rex/mod_macro-basic/httpd.conf -k stop

Prerequisites
-------------
1. Examples assume basic commands (echo, touch, mkdir, etc.) in the `PATH`.
   There's no check for such binaries.
2. Some examples require also higher level helper commands (e. g. sqlite, 
   python) in the `PATH`, see `BINARIES` file in the example directory. 
   Before the test is run, these binaries are checked for existence.
3. All examples require `httpd` (`httpd2`) and `curl` commands in the `PATH`.
   These two binaries are checked via system check before any of examples
   are run.
4. Examples can be run offline, do not use network connection.

### Example Omission

Example is skipped in case

1. helper binary is missing,
2. required module is missing,
3. syntax check failed.

Running an Example
------------------

Example can be run by

    $ run-rex "<example-dir-list>"

for example

    $ run-rex mod_proxy_fcgi-php-fpm
    $ run-rex "*proxy*"

Another possibility is to pass a file with the ordered list of example
dirs:

    $ run-rex <contents-file>

There are options that can be passed to the `run-rex` script by environment
variables, for example

    $ VERBOSITY=2 run-rex */

#### Options for Running an Example

There are several variables which can be used as options to `run-rex`
utility. See the `CONFIGURATION` section of `run-rex` for defaults.

* `MODULE_PATH`  
  Paths separated by colon where modules could be found.
* `RUN_DIR_BASE`  
  Writeable dir for the user which runs `run-rex`. All temporary data
  or results of the tests will be written to subdirs of this directory
  path.
* `HTTP_PORT_START`  
  Depending on example, one or several ports need to be reserved
  for http listening. The set starts with value of this variable and 
  continues by incrementing 1 to reach `n + 1` ports open. The `n` is
  currently equal to `6`. See `AREX_PORTn` for details.
* `FTP_PORT`  
  Port that can be opened by testing FTP daemon.
* `FCGI_PORT`  
  Port that can be used by testing FCGI application.
* `SCGI_PORT`  
  Port that can be used by testing SCGI application.
* `VERBOSITY`  
  Amount of information written by `run-rex` to the stdout. Possible
  values are 0 (normal), 1 (verbose) and 2 (debug).

Example Structure
-----------------

Each example has its own directory, which contains:

* `BINARIES` (optional)  
  States required helper binaries for running the example.
* `DESCRIPTION` (required)  
  Contains summary what the example is showing.
* `MODULES` (required, even if empty)  
  Lists required modules apache should provide to run the example. Module
  names in the list can be separated by white space or colon.
* `MODULES_OPT` (optional)  
  Lists modules that are either optional for given example (see `mod_sed` in 
  `mod_filter-basic` for instance) or are required just for some apache 
  versions (e. g. `authn_core` does not exist for 2.2 but is required in 2.4
  in some examples).
* `example.conf` or `example.conf.in` (required)  
  Contains example apache configuration; in example.conf.in will 
  `@VARIABLE_NAME@` be expanded for enumerated variables first to create 
  example.conf.
* `post-run.sh` (optional)  
  Shows what has to be done after apache stop. It is dual to `pre-run.sh`. 
  Return value of `post-run.sh` is not checked.
* `pre-run.sh` (optional)  
  Shows what has to be done before apache start (e. g. place test ssl 
  certificate on correct place). `pre-run.sh` return value is not checked.
  It can write `$AREX_RUN_DIR/server_environment`, which will be sourced
  into httpd environment.
* `run.sh` (required)  
  Determines an example flow. Script exits `0` in case whole example passed
  or number of failed subexample. If there are more subexamples failing, 
  the highest number should be returned.
* SERVERFLAGS (optional)
  The httpd commandline parameters.
* `skip.sh` (optional)  
  when the example is not runnable (e. g. curl has not --resolve needed by 
  the example). Exits `0` if the example should be skipped.

#### Example Environment Variables

Following variables are expanded in `example.conf.in` and also can be used
in `run.sh`.

* `AREX_RUN_DIR`  
  Writeable dir for the test, `$RUN_DIR_BASE/<test-dir-name>` in the fact.
  All example data, temporary outputs, even configuration and script should 
  be found there after example is run. No cleanup required.
* `AREX_USER`
  User under which all daemons, including httpd, are run.
* `AREX_PORT`  
  This port is automatically opened for the httpd.
* `AREX_PORTn`  
  Additional ports for httpd, need to be `Listen`ed in `example.conf`. `n`
  can be one from `{1, 2, 3, 4, 5, 6}`.
* `AREX_DOCUMENT_ROOT`  
  DocumentRoot for the test server. 
* `AREX_ALLOW_FROM_LOCALHOST`  
  Corresponding access syntax for given version of apache (changed from 2.2 
  to 2.4).
* `AREX_DENY_FROM_ALL`  
  Corresponding access syntax for given version of apache (changed from 2.2 
  to 2.4).
* `AREX_ALLOW_FROM_ALL`  
  Corresponding access syntax for given version of apache (changed from 2.2 
  to 2.4).
* `AREX_AN_OPENSSL_ENGINE`  
  One of supported openssl engine as returned by openssl for given system.
* `AREX_FTP_PORT`  
  Port reserved for test instance of FTP daemon.
* `AREX_FCGI_PORT`  
  Port reserverd for test FCGI application.
* `AREX_SCGI_PORT`  
  Port reserverd for test SCGI application.
* `AREX_OCSP_PORT`  
  Port reserverd for test OCSP responder daemon.
* `AREX_SED_COMMAND`  
  Full path to `sed` command (required for some Filter example definitions).
* `AREX_ROTATELOGS_COMMAND`  
  Full path to `rotatelogs` or `rotatelogs2` command (required e. g. in piped logs).
* `AREX_SOFTHSM2_SO`  
  Mainly used in lib/softhsm, it is softhsm shared library module.
