# pubver
CLI tool to set/bump the `version` key in pubspec.yaml. Semver-compliant (Almost. 
It uses [pub_semver](https://pub.dartlang.org/packages/pub_semver) which is a bit different.)

## Installing
Install the package from the command line:
```
pub global activate pubspec_version
```

This will add the **pubver** binary to your `~/.pub-cache/bin`.
## Usage
### Bumping the version
```
pubver bump <part>
``` 
where `<part>` can be either **breaking**, **major**, **minor**, **patch** or **build**.

#### Examples
Before | Command | After
--- | --- | ---
1.2.3 | `pubver bump breaking`  | 2.0.0
0.2.1 | `pubver bump breaking`  | 0.3.0
0.2.1 | `pubver bump major`     | 1.0.0
0.2.1 | `pubver bump minor`     | 0.3.0
0.2.1 | `pubver bump patch`     | 0.2.2
0.2.1 | `pubver bump build`     | 0.2.1+1
0.2.1+42 | `pubver bump build`     | 0.2.1+43
0.2.1+foo | `pubver bump build`     | 0.2.1+foo.1
0.2.1+42.foo | `pubver bump build`     | 0.2.1+43.foo
0.2.1+foo.bar.1.2 | `pubver bump build`     | 0.2.1+foo.bar.2.2

The `bump build` command is a bit tricky. It either increments the first numeric part of the build (if there is a 
numeric part) or appends `.1` to the build (otherwise).

### Setting the version
```
pubver set <version>
```
where `<version>` can be any arbitrary version.

### Getting the version
```
pubver get
```

### Output
The tool prints the new version to stdout. This allows post processing, e.g. making a git commit.
```bash
git ci . -m "Release $(pubver bump breaking)"
```
