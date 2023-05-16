# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.2] - 2023-05-16

### Added

- Introduced `OpenFeature::MultipleSourceProvider` to allow fetching flags from multiple sources.

## [0.1.1] - 2023-05-15

### Changed

- Expanded type of structure resolver to `T.any(T::Array[T.untyped], T::Hash[T.untyped, T.untyped])`

## [0.1.0] - 2023-05-15

### Added

- Provider interface and `NoOpProvider` implementation
- Global API configuration for provider and hooks
- Client initialization with basic support for fetching values and details
