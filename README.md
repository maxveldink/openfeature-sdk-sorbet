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
OpenFeature.add_hooks([OpenFeature::Hook.new]) # experimental, not fully supported

client = OpenFeature.create_client

# Fetch boolean value
# Also methods available for String, Number, Integer, Float and Structure (Hash)
bool_value = client.fetch_boolean_value(flag_key: "my_toggle", default_value: false) # => (true or false)

# Sorbet sprinkles in type safety
bool_value = client.fetch_boolean_value(flag_key: "my_toggle", default_value: "bad!") # => raises TypeError from Sorbet, invalid default value

# Fetch structure evaluation details
structure_evaluation_details = client.fetch_structure_details(flag_key: "my_structure", default_value: { "a" => "fallback" }) # => EvaluationDetails(value: Hash, flag_key: "my_structure", ...)
```

### Note on `Structure`

The OpenFeature specification defines [Structure as a potential return type](https://openfeature.dev/specification/types#structure). This is somewhat ambiguous in Ruby, further complicated by `T::Struct` that we get from Sorbet. For now, the type I've elected here is `T::Hash[T.untyped, T.untyped]` for flexibility but with a little more structure than a YML or JSON parsable string. This decision might change in the future upon further interpretation or new versions of the specification.

### Provider Interface

By default, this implementation sets the provider to the `OpenFeature::NoOpProvider` which always returns the default value. It's up to the individual teams to define their own providers based on their flag source (in the future, I'll release open-source providers based on various, common vendors).

Thanks to Sorbet interfaces, it's fairly straightforward to implement a new provider. Here is an example for a JSON-based flag format on disk:

```ruby
class JsonFileFlagProvider
  extend T::Sig

  include OpenFeature::Provider

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

By including the `OpenFeature::Provider` module, Sorbet will indicate what methods it's expecting and what their type signatures should be.

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
