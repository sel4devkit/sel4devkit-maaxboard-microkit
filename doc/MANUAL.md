# Introduction

This Package forms part of the seL4 Developer Kit. It provides a fully
coordinated build of MaaXBoard Microkit. Several other Packages associated
with the seL4 Developer Kit depend upon this Package in achieving a
consistent build of the MaaXBoard Microkit.

# Usage

Must be invoked inside the following:
* sel4devkit-maaxboard-microkit-docker-dev-env

Show usage instructions:
```
make
```

Remove previously built output, and rebuild:
```
make reset
make get
make all
```

# Maintenance

Presents detailed technical aspects relevant to understanding and maintaining
this Package.

## Retain Previously Built Output

For consistency and understanding, it is generally desirable to be able to
build from source. However, in this instance, the build process can be
particularly time consuming. As a concession, the build output is prepared in
advance, and retained in the Package. Where this previously built output is
present, it shall block a rebuild. If the previously built output be removed
(`make reset`), then a rebuild may be triggered (`make all`).

The retention of build artefacts is ordinarily avoided, and this is reflected
in the configured set of file types to be ignored. As such, following a
rebuild, to examine and retain the resulting content (including build
artefacts), instruct git as follows:

Examine all files, including any that are ordinarily ignored:
```
git status --ignored
```

Force the addition of files, even if they ordinarily ignored:
```
git add --force <Path Files>
```

## Dependencies

Seeking a consistent build, both Microkit, and its dependency on seL4, are
fixed to specific revisions. The intention is to remain aligned with the
latest release as far as possible. As Microkit and seL4 evolve, it may become
appropriate to revisit these revisions, to benefit from any recent
enhancements.

## Compiler Toolchain

Microkit currently assumes use of a specific Compiler Toolchain
(aarch64-linux-gnu). For environmental simplicity alone, we favour the default
Compiler Toolchain associated with our selected docker base image as provided
by Debian. Currently, Microkit does not provide a mechanism to select the
Compiler Toolchain. As a workaround, Microkit is trivially patched to adopt
this Compiler Toolchain (aarch64-linux-gnu).

## Avoid Document Build

Since the document build process has various dependencies not necessary for
routine development, Microkit is instructed to avoid the document build phase.
