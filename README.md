## Everything that really should be in Foundation, but isn't.

Consider FoundationKit Foundation's big brother. We add lots of useful categories, helpers, classes and macros.

FoundationKit is built With ARC for both for iOS 4.0+ and Mac OS 10.6+.

It's still very much work in progress, so don't yet use it in production.
If you start a new app today, it's the perfect time to begin with it.

## Conventions

- Classes are prefixed with `FK`
- The project is set to use 2 spaces for indents
- ARC only, no explicitly defined `ivar`s
- Every `.h` file has only a concise comment header that mentions that this file belongs to `FoundationKit` and credits to other 3rd parties if appropriate (see example header below). The `.m` files don't have a comment header.
- Category file names must be named after the classes that they extend (e.g. `NSArray+FKAdditions`). Generic categories that span multiple classes are not allowed!
- Use `assert` instead of `NSAssert` macros to ensure program exit.
- For all other guidelines have a look at the `Styleguide.md`.

## Example Header Comment

    // Part of FoundationKit http://foundationk.it
    //
    // Derived from [Author] [License Type]-licensed [Project Name]: [URL]


## Workarounds

- For iOS5b2, this workaround helps with compiling problems: https://devforums.apple.com/thread/107259
- If you get "Protocol *" errors when compiling, you are using 10.6 SDK - for FoundationKit, you need 10.7.