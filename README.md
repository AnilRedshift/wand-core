# WandCore
[![Coverage Status](https://coveralls.io/repos/github/AnilRedshift/wand-core/badge.svg?branch=master)](https://coveralls.io/github/AnilRedshift/wand-core?branch=master)[![CircleCI](https://circleci.com/gh/AnilRedshift/wand-core.svg?style=svg)](https://circleci.com/gh/AnilRedshift/wand-core)

Global archive needed to use [wand](http://github.com/anilredshift/wand)

## Installation

Run this
`mix archive.install hex wand_core --force`

## Usage
Using the [wand cli](http://github.com/anilredshift/wand), type `wand init` to get started.

If you need to manually initialize a project with wand:
Replace your `deps` with `Mix.Tasks.WandCore.Deps.run([])` to start using wand for your project.

## CircleCI and other CI.
You need to have the wand_core archive added to your image before running mix deps.get. The command for CircleCI would be:
`- run: mix archive.install hex wand_core --force`


## Local development
You usually will want to add the package as a global dependency. However, if you need to install it locally, you can use `wand add wand_core` :-)

The docs can be found at [https://hexdocs.pm/wand_core](https://hexdocs.pm/wand_core).
