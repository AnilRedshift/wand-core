# WandCore [![Hex version badge](https://img.shields.io/hexpm/v/wand_core.svg)](https://hex.pm/packages/wand_core)

`wand` is a dependency manager that uses a `wand.json` file to replace your deps() in mix.exs. This allows you to add, remove, and upgrade packages easily using the [wand cli](http://github.com/anilredshift/wand)

TL;DR: `wand` is `yarn`, but for elixir.

WandCore is a set of global mix tasks needed for wand to work. Most importantly, it contains the `mix wand_core.deps` task, which enables projects to read their deps from wand.json.

## Installation

In a terminal, type:
`mix archive.install hex wand_core --force`

If you have wand already installed, you can add the arcive with:
`wand core install`

This archive doesn't do much by itself! You'll probably want to install the [wand cli](http://github.com/anilredshift/wand) if you haven't already.

## Usage
Using the [wand cli](http://github.com/anilredshift/wand), type `wand init` to get started.

If you need to manually initialize a project with wand:
Replace your `deps` with `Mix.Tasks.WandCore.Deps.run([])` to start using wand for your project.

## CircleCI and other CI.
You need to have the wand_core archive added to your image before running mix deps.get. The command for CircleCI would be:
`- run: mix archive.install hex wand_core --force`


## Local development
1. `git clone git@github.com:AnilRedshift/wand.git`
2. `cd wand`
3. `mix deps.get`
4. `mix test`

The WandCore repository is fairly straightforward. It uses [mox](https://hexdocs.pm/mox/Mox.html) for side effects. Due to the nature of the tasks, the "unit tests" can feel more like integration tests, but where possible, the heavy lifting is done in stateless modules.

## Contributing
Issues and pull requests are very much welcome! If you are submitting a pull request, please make sure to add unit tests for both the successful and failing codepaths, and run `mix format` before submitting.

## Notes
WandCore is a global archive, and is thus subject to the restriction that it can't have any dependencies. Due to the nature, the goal is to keep WandCore small, with minimal logic. Most of the heavy lifting is done in `wand` proper.

There is an apparent bug in elixir where mix archive.install does not configure the application environment. Therefore, the `impl()` pattern that is present for the mox stubs is such that Application.get_env defaults to the correct prod environment.

[![Coverage Status](https://coveralls.io/repos/github/AnilRedshift/wand-core/badge.svg?branch=master)](https://coveralls.io/github/AnilRedshift/wand-core?branch=master)[![CircleCI](https://circleci.com/gh/AnilRedshift/wand-core.svg?style=svg)](https://circleci.com/gh/AnilRedshift/wand-core)
