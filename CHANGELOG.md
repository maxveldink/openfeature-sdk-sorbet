# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2024-02-21

### Changed

- Set minimum Ruby version back to 3.0.

## [0.3.1] - 2024-01-26

### Changed

- Loosened underlying `Hash` type for evaluation context.

### Fixed

- Fixed issue where `MultipleSourceProvider` was not passing context to each internal provider.

## [0.3.0] - 2024-01-24

### Added

- Added `OpenFeatureSorbet::Provider#status` reader that returns an `OpenFeatureSorbet::ProviderStatus`.
- Added `OpenFeatureSorbet::Provider#init` as an overridable method on `Provider`s that can perform any initialization work for the given provider. This method accepts the global `EvaluationContext` and has a `void` return type. The default implementation is a no-op.
- Added `OpenFeatureSorbet::Provider#shutdown` as an overridable method on `Provider`s that can perform any cleanup work for the given provider. This method has a `void` return type and the default implementation is a no-op.
- Added `OpenFeature.shutdown` to invoke the current provider's `shutdown` method.

### Changed

- *Breaking* Changed minimum supported Ruby version to 3.1.
- *Breaking* `OpenFeatureSorbet::Provider` changed from a module interface to an abstract class to support default method implementations.
- *Breaking* `OpenFeatureSorbet::Provider.initialize` now must accept an `OpenFeatureSorbet::ProviderStatus`. Any providers may pass this in during initialization. If you need to do additional setup in `Provider.init`, we recommend you pass `OpenFeatureSorbet::ProviderStatus::NotReady` here.

## [0.2.0] - 2023-05-17

### Added

- Added ability to set evaluation context globally on the `Configuration` singleton, i.e. `OpenFeatureSorbet::Configuration.instance.evaluation_context = OpenFeatureSorbet::EvaluationContext.new(fields: { "globally" => "available" })`.
- Added ability to set evaluation context globally on the `OpenFeature` module, i.e. `OpenFeature.set_evaluation_context(OpenFeatureSorbet::EvaluationContext.new(fields: { "globally" => "available" }))`.
- Added ability to set evaluation context on a `Client` instance, i.e. `client.evaluation_context = OpenFeatureSorbet::EvaluationContext.new(fields: { "client" => "available" })`.
- Added ability to set hooks and evaluation context on `Client` initialization, i.e. `OpenFeature.create_client(name: "my_client", evaluation_context: OpenFeatureSorbet::EvaluationContext.new(fields: { "client" => "available" }), hooks: OpenFeatureSorbet::Hook.new)`
- Added `Configuration#reset!` to reset global configuration to the default state.

### Changed

- Renamed `Configuration#set_provider` to `Configuration#provider=`.
- Renamed `Configuration#add_provider` to `Configuration#hooks=`.
- During flag initialization, contexts are now merged. The invocation context takes precedence over the client context which takes precedence over the global context.

### Removed

- Removed `Configuration#clear_hooks!` in favor of `Configuration#reset!`.

## [0.1.2] - 2023-05-16

### Added

- Introduced `OpenFeatureSorbet::MultipleSourceProvider` to allow fetching flags from multiple sources.

## [0.1.1] - 2023-05-15

### Changed

- Expanded type of structure resolver to `T.any(T::Array[T.untyped], T::Hash[T.untyped, T.untyped])`

## [0.1.0] - 2023-05-15

### Added

- Provider interface and `NoOpProvider` implementation
- Global API configuration for provider and hooks
- Client initialization with basic support for fetching values and details
