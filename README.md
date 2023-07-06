# Sorbet-aware OpenFeature Ruby Implementation

[OpenFeature](https://openfeature.dev) is an open standard for vendor-agnostic feature flagging. [Sorbet](https://sorbet.org) is a type-checker for Ruby, built by Stripe. Sorbet provides powerful runtime utilities to achieve things traditionally not possible with Ruby, such as interfaces, immutable structures and enums. This makes it a very good option when defining specifications.

If an organization is not already using Sorbet, you probably don't want to introduce a dependency on `sorbet-runtime`, which this gem does. As such, this will always be a distinct implementation, separate from the official [Ruby SDK](https://github.com/open-feature/ruby-sdk).

Current OpenFeature specification target version: `0.5.2`
Current supported Ruby versions: `2.7.X`, `3.0.X`, `3.1.X`, `3.2.X`
Support for Evaluation Context and Hooks is not complete.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add openfeature-sdk-sorbet

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install openfeature-sdk-sorbet

## Usage

```ruby
require "open_feature"

# Configure global API properties

OpenFeature.set_provider(OpenFeature::NoOpProvider.new)
OpenFeature.set_evaluation_context(OpenFeature::EvaluationContext.new(fields: { "globally" => "available" }))
OpenFeature.add_hooks([OpenFeature::Hook.new]) # experimental, not fully supported

client = OpenFeature.create_client(evaluation_context: OpenFeature::EvaluationContext.new(fields: { "client" => "available" }))

# Fetch boolean value
# Also methods available for String, Number, Integer, Float and Structure (Hash)
bool_value = client.fetch_boolean_value(flag_key: "my_toggle", default_value: false) # => (true or false)

# Sorbet sprinkles in type safety
bool_value = client.fetch_boolean_value(flag_key: "my_toggle", default_value: "bad!") # => raises TypeError from Sorbet, invalid default value

# Additional evaluation context can be provided during invocation
number_value = client.fetch_number_value(flag_key: "my_toggle", default_value: 1, context: OpenFeature::EvaluationContext.new(fields: { "only_this_call_site" => 10 })) # => merges client and global context

# Fetch structure evaluation details
structure_evaluation_details = client.fetch_structure_details(flag_key: "my_structure", default_value: { "a" => "fallback" }) # => EvaluationDetails(value: Hash, flag_key: "my_structure", ...)
```

### Note on `Structure`

The OpenFeature specification defines [Structure as a potential return type](https://openfeature.dev/specification/types#structure). This is somewhat ambiguous in Ruby, further complicated by `T::Struct` that we get from Sorbet. For now, the type I've elected here is `T.any(T::Array[T.untyped], T::Hash[T.untyped, T.untyped]` (loosely, either an Array of untyped members or a Hash with untyped keys and untyped values) for flexibility but with a little more structure than a YML or JSON parsable string. This decision might change in the future upon further interpretation or new versions of the specification.

### Evaluation Context

We support global evaluation context (set on the `OpenFeature` module), client evaluation context (set on client instances or during client initialization) and invocation evaluation context (passed in during flag evaluation). In compliance with the specification, the invocation context merges into the client context which merges into the global context. Fields in invocation context take precedence over fields in the client context which take precedence over fields in the global context.

### Provider Abstract Class

By default, this implementation sets the provider to the `OpenFeature::NoOpProvider` which always returns the default value. It's up to the individual teams to define their own providers based on their flag source (in the future, I'll release open-source providers based on various, common vendors).

This gem also provides `OpenFeature::MultipleSourceProvider` to allow fetching flags from multiple sources. This is especially useful if your existing application has flags spread across bespoke and vendor solutions and you want to unify the evaluation sites. It can be instantiated and configured like so:

```ruby
provider = OpenFeature::MultipleSourceProvider.new(
  providers: [
    CustomProvider.new,
    OpenFeature::NoOpProvider.new
  ]
)

OpenFeature.set_provider(provider)
```

#### Implementing Custom Providers

Thanks to Sorbet abstract classes, it's fairly straightforward to implement a new provider. Here is an example for a JSON-based flag format on disk:

```ruby
class JsonFileFlagProvider < OpenFeature::Provider
  extend T::Sig

  sig { void }
  def initialize
    super(OpenFeature::ProviderStatus::NotReady)
  end

  def init(context)
    @file = File.open(context.file || "flags.json")
    @status = OpenFeature::ProviderStatus::Ready
  end

  sig { overridable.void }
  def shutdown
    @file.close
  end

  sig { override.returns(OpenFeature::ProviderMetadata) }
  def metadata
    OpenFeature::ProviderMetadata.new(name: "Json File Flag Provider")
  end

  sig { override.returns(T::Array[Hook]) }
  def hooks
    []
  end

  sig do
    override
      .params(
        flag_key: String,
        default_value: T::Boolean,
        context: T.nilable(EvaluationContext)
      )
      .returns(OpenFeature::ResolutionDetails[T::Boolean])
  end
  def resolve_boolean_value(flag_key:, default_value:, context: nil)
    file_input = JSON.parse(File.read("flags.rb"))
    value = file_input.fetch("flag_key", default_value)

    OpenFeature::ResolutionDetails.new(
      value: value,
      # ... other optional fields
    )
  end

  # ... other resolver methods
end
```

By inheriting from the `OpenFeature::Provider` class, Sorbet will indicate what methods it's expecting and what their type signatures should be.

##### A note on `initialize` versus `init`

The Ruby `initialize` method is the best place to do any direct construction logic for an object, such as setting configuration values. `init` is called by OpenFeature when setting a provider and is the best place to make any HTTP requests, establish persistent connections, or any other connection logic that could potentially fail. By the end of this method, `@status` must be set to either `Ready` or `Error`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run Rubocop and the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maxveldink/openfeature-sdk-sorbet. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/maxveldink/openfeature-sdk-sorbet/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in this project's codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/maxveldink/openfeature-sdk-sorbet/blob/master/CODE_OF_CONDUCT.md).

## Sponsorships

I love creating in the open. If you find this or any other [maxveld.ink](https://maxveld.ink) content useful, please consider sponsoring me on [GitHub](https://github.com/sponsors/maxveldink).
