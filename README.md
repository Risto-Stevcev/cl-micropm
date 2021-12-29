# cl-micropm

A very minimalist "package manager" for Common Lisp.


## Install

Make sure that you have docker installed on your system and that your user has permissions (is in
the `docker` group)

Fetch the single-file executable from git and add the permissions:

``` sh
curl -LO https://github.com/Risto-Stevcev/cl-micropm/raw/main/micropm-get
chmod +x ./micropm-get
```

Then you can also move the file into a path that your system can find, ie:

``` sh
sudo mv ./micropm-get /usr/local/bin/
```


## Usage


### Defining a system

A system is how you set up your project to be used as a library to the rest of the world, similar to
NodeJS packages. An `asd` file (ie `monty-hall.asd`) is a system file, similar to NodeJS'
`package.json`.

The library that's used to interact with systems is called the
[ASDF](https://common-lisp.net/project/asdf/asdf/)  build system, and it's already included in most
Common Lisp compilers. If it's included with the Common Lisp compiler that you're using, but for
some reason you can't call asdf commands, then you may neet to also import it for it to be
available: `(require 'asdf)`.

Here is an example of a system definition for a project called monty-hall in a file
`monty-hall.asd`:

``` common-lisp
;; monty-hall.asd
(asdf:defsystem :monty-hall
  :version      "0.1.0"
  :description  "Monty hall problem simulator"
  :author       "Risto Stevcev <me@risto.codes>"
  :serial       t
  :license      "GNU GPL, version 3"
  :components   ((:file "monty-hall"))
  :depends-on   (#:alexandria #:arrow-macros))
```

The first argument after the `defsystem` call is the name of the system (`:monty-hall`). It's then a
plist of various metadata about the project, as well as dependencies to foreign libraries, like
`#:alexandria` and ` #:arrow-macros`. You can view available libraries at
[quickref](https://quickref.common-lisp.net/index-per-library.html).

In this case, system with the name `monty-hall`, you can get the dependencies by passing in the
system name like this:

```sh
$ micropm-get monty-hall
```

They'll be saved in the project-local `lisp-systems` folder.

Then just make sure to set `CL_SOURCE_REGISTRY` to point to that directory, like this
[.envrc](./envrc), which gets copied by default `.envrc` when installing deps.

Or optionally, use [direnv](direnv.net/) and just copy the [.envrc](./envrc), and it will
load/unload the environment variable for all of your common lisp projects!



## Goals

- Dependendies should not be global, each project may have a local version that's different and may
  want to pin that version.
- It should be easy to work on projects that use different versions of a package, maybe even at the
  same time, without too much hassle.
- It should be easy to set up.
- It should be easy to understand what it's doing and how it works.
- It should be possible to just freeze the dependencies (separate fetching and loading commands).



## How it works

1. Fetch the entire dependency graph using quicklisp and copy it into the project-local
   `lisp-systems` folder
2. Set the `CL_SOURCE_REGISTRY` env file to point to the project-local `lisp-systems` folder


This way it's easy to set up, it's easy to understand what it's doing, and it's possible to freeze
or update each package individually without too much hassle. It *is* using quicklisp, but not
really -- it's only using it to fetch the dependency graph into a local folder, the rest is just
managed by asdf. Note that quicklisp isn't installed, it's entirely run via an ephemeral docker
container that gets unloaded once the dependencies are fetched. Once it's known which deps are used,
it could be updated via other means like directly cloning dependencies from a git repo or using
ultralisp.


## Slimv

Slimv doesn't seem to set env vars:

```lisp
CL-USER> (uiop:getenv "CL_SOURCE_REGISTRY")
NIL
```

Which means that `asdf` won't be able to find your systems.

A hacky workaround:

```sh
$ echo $CL_SOURCE_REGISTRY
/home/risto/git/lisp/lqlite/:/home/risto/git/lisp/lqlite/lisp-systems//
```

```lisp
CL-USER> (si:setenv "CL_SOURCE_REGISTRY" "/home/risto/git/lisp/lqlite/:/home/risto/git/lisp/lqlite/lisp-systems//")
"/home/risto/git/lisp/lqlite/:/home/risto/git/lisp/lqlite/lisp-systems//"
CL-USER> (uiop:getenv "CL_SOURCE_REGISTRY")
"/home/risto/git/lisp/lqlite/:/home/risto/git/lisp/lqlite/lisp-systems//"
CL-USER> (asdf:clear-source-registry)
; No value
CL-USER> (asdf:ensure-source-registry)
; No value
CL-USER> (asdf:load-system :alexandria)
T
```


## Roadmap

- Support Ultralisp
- Self-destruct/uninstall command


## License

See [LICENSE](./LICENSE)
