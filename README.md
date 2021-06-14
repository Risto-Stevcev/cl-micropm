# cl-micropm

A very minimalist "package manager" for Common Lisp.


## Usage

Assuming you have a system with the name `mysystem`, you can get the dependencies like this:

```sh
$ ./get-deps.sh mysystem
```

They'll be saved in the project-local `lisp-systems` folder.

Then just make sure to set `CL_SOURCE_REGISTRY` to point to that directory like this [.envrc](./envrc)

Or optionally, use [direnv](direnv.net/) and just copy the [.envrc](./envrc), and it will
load/unload the environment variable for all of your common lisp projects!



## Motivation

There are a few attempts at a package manager for common lisp floating around, such as quicklisp,
qlot, and CLPM.  The motivation to do this came from a few things I found that were lacking with
these:

1. Dependendies should not be global, each project may have a local version that's different and may
   want to pin that version.
2. It should be easy to work on projects that use different versions of a package, maybe even at the
   same time, without too much hassle.
2. It should be easy to set up.
3. It should be easy to understand what it's doing and how it works.
4. It should be possible to just freeze the dependencies (separate fetching and loading).
5. It should be complete. Many of these seem to be in a forever beta stage.



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


## License

See [LICENSE](./LICENSE)
