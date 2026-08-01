# haskell-mod.nvim

Scaffolds empty `.hs` buffers.

If the file lives under a package's `hs-source-dirs`, it is prefixed with its module header:
```haskell
module Foo.Bar.FileName where
```

Otherwise, if the file looks like a standalone script, a runnable `stack script` header is
generated instead:
```haskell
#!/usr/bin/env stack
{- stack script
   --resolver lts
   --package aeson
   --package async
   --package bytestring
   --package containers
   --package directory
   --package filepath
   --package mtl
   --package process
   --package text
   --package time
   --package turtle
   --package unordered-containers
   --package vector
-}
{-# LANGUAGE OverloadedStrings #-}

main :: IO ()
main = do
    pure ()
```

A file counts as a standalone script when all of the following hold:

- No `*.cabal`, `stack.yaml`, `package.yaml`, or `cabal.project` exists anywhere above it
  (the search stops at the git root).
- Its filename does not start with an uppercase letter, so it cannot name a Haskell module.
- It declares no `module ... where`.

Nothing is ever written to a buffer that already has content.

`--resolver lts` floats to the newest LTS snapshot. Note that `stack script` materializes every
listed package on first run, so the first execution of a generated script is slow — trim the
`--package` block to taste.

## Installation
This guide uses `lazy.nvim`.
```lua
{
    "mincomk/haskell-mod.nvim",
    config = true,
}
```
