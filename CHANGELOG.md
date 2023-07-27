# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0.2] - 2023-07-27

### Fixed

- Fixed an issue where the `OpenFeature::MultipleSourceProvider` did not properly pass evaluation context to the internal providers.

## [0.2.0.1] - 2023-07-21

### Changed

* Loosened the type for the `EvaluationContext` underlying Hash to `T::Hash[T.untyped, T.untyped]`. This allows for more varied context to be past to flag evaluation. This is necessary since we don't fully support the Hooks specification and cannot handle all flag evaluation use cases. This behavior will be reverted once the Hooks spec is fully implemented.

## [0.2.0] - 2023-05-17

### Added

- Added ability to set evaluation context globally on the `Configuration` singleton, i.e. `OpenFeature::Configuration.instance.evaluation_context = OpenFeature::EvaluationContext.new(fields: { "globally" => "available" })`.
- Added ability to set evaluation context globally on the `OpenFeature` module, i.e. `OpenFeature.set_evaluation_context(OpenFeature::EvaluationContext.new(fields: { "globally" => "available" }))`.
- Added ability to set evaluation context on a `Client` instance, i.e. `client.evaluation_context = OpenFeature::EvaluationContext.new(fields: { "client" => "available" })`.
- Added ability to set hooks and evaluation context on `Client` initialization, i.e. `OpenFeature.create_client(name: "my_client", evaluation_context: OpenFeature::EvaluationContext.new(fields: { "client" => "available" }), hooks: OpenFeature::Hook.new)`
- Added `Configuration#reset!` to reset global configuration to the default state.

### Changed

- Renamed `Configuration#set_provider` to `Configuration#provider=`.
- Renamed `Configuration#add_provider` to `Configuration#hooks=`.
- During flag initialization, contexts are now merged. The invocation context takes precedence over the client context which takes precedence over the global context.

### Removed

- Removed `Configuration#clear_hooks!` in favor of `Configuration#reset!`.

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
